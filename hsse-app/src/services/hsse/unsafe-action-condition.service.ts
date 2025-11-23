import { supabase } from '@/lib/supabase'
import type { Database } from '@/types/database'

type UnsafeActionCondition = Database['public']['Tables']['unsafe_action_condition']['Row']
type UnsafeActionConditionInsert = Database['public']['Tables']['unsafe_action_condition']['Insert']
type UnsafeActionConditionUpdate = Database['public']['Tables']['unsafe_action_condition']['Update']

export interface CreateUnsafeActionConditionDto {
  tanggal_kejadian: string
  waktu_kejadian: string
  lokasi_kejadian: string
  unit_kerja: string
  jenis_kejadian: 'unsafe_action' | 'unsafe_condition'
  kategori: string
  sub_kategori?: string
  deskripsi_kejadian: string
  penyebab_diduga?: string
  potensi_risiko?: string
  pelapor_nama: string
  pelapor_jabatan?: string
  pelapor_kontak?: string
  tindakan_segera?: string
  area_diamankan?: boolean
  korban_ada?: boolean
  korban_jumlah?: number
  foto_kejadian?: string[]
  video_kejadian?: string[]
  audio_catatan?: string
  prioritas?: 'low' | 'medium' | 'high' | 'critical'
  severity_level?: number
  latitude?: number
  longitude?: number
  gps_accuracy?: number
}

export interface UpdateUnsafeActionConditionDto extends Partial<CreateUnsafeActionConditionDto> {
  status?: 'draft' | 'reported' | 'investigating' | 'resolved' | 'closed'
  assigned_to?: string
  investigasi_dilakukan?: boolean
  temuan_investigasi?: string
  rekomendasi_koreksi?: string[]
  target_penyelesaian?: string
  aktual_penyelesaian?: string
}

export class UnsafeActionConditionService {
  private static readonly TABLE_NAME = 'unsafe_action_condition'

  static async getAll(options: {
    page?: number
    limit?: number
    search?: string
    jenis_kejadian?: string
    status?: string
    prioritas?: string
    unit_kerja?: string
  } = {}) {
    const { page = 1, limit = 20, search, jenis_kejadian, status, prioritas, unit_kerja } = options

    let query = supabase
      .from(this.TABLE_NAME)
      .select('*', { count: 'exact' })

    // Apply filters
    if (jenis_kejadian) {
      query = query.eq('jenis_kejadian', jenis_kejadian)
    }
    if (status) {
      query = query.eq('status', status)
    }
    if (prioritas) {
      query = query.eq('prioritas', prioritas)
    }
    if (unit_kerja) {
      query = query.eq('unit_kerja', unit_kerja)
    }
    if (search) {
      query = query.or(`deskripsi_kejadian.ilike.%${search}%,lokasi_kejadian.ilike.%${search}%,pelapor_nama.ilike.%${search}%`)
    }

    // Apply pagination
    const from = (page - 1) * limit
    const to = from + limit - 1
    query = query.range(from, to)

    // Order by most recent first
    query = query.order('created_at', { ascending: false })

    const { data, error, count } = await query

    if (error) throw error

    return {
      data: data || [],
      total: count || 0,
      page,
      limit,
      totalPages: Math.ceil((count || 0) / limit)
    }
  }

  static async getById(id: string): Promise<UnsafeActionCondition> {
    const { data, error } = await supabase
      .from(this.TABLE_NAME)
      .select('*')
      .eq('id', id)
      .single()

    if (error) throw error
    return data
  }

  static async create(dto: CreateUnsafeActionConditionDto): Promise<UnsafeActionCondition> {
    const { data, error } = await supabase
      .from(this.TABLE_NAME)
      .insert(dto)
      .select()
      .single()

    if (error) throw error
    return data
  }

  static async update(id: string, dto: UpdateUnsafeActionConditionDto): Promise<UnsafeActionCondition> {
    const { data, error } = await supabase
      .from(this.TABLE_NAME)
      .update(dto)
      .eq('id', id)
      .select()
      .single()

    if (error) throw error
    return data
  }

  static async delete(id: string): Promise<void> {
    const { error } = await supabase
      .from(this.TABLE_NAME)
      .delete()
      .eq('id', id)

    if (error) throw error
  }

  static async uploadPhoto(file: File, incidentId: string): Promise<string> {
    const fileExt = file.name.split('.').pop()
    const fileName = `${incidentId}_${Date.now()}.${fileExt}`
    const filePath = `unsafe-action-condition-photos/${fileName}`

    const { error: uploadError } = await supabase.storage
      .from('safety-files')
      .upload(filePath, file)

    if (uploadError) throw uploadError

    const { data } = supabase.storage
      .from('safety-files')
      .getPublicUrl(filePath)

    return data.publicUrl
  }

  static async uploadVideo(file: File, incidentId: string): Promise<string> {
    const fileExt = file.name.split('.').pop()
    const fileName = `${incidentId}_${Date.now()}.${fileExt}`
    const filePath = `unsafe-action-condition-videos/${fileName}`

    const { error: uploadError } = await supabase.storage
      .from('safety-files')
      .upload(filePath, file)

    if (uploadError) throw uploadError

    const { data } = supabase.storage
      .from('safety-files')
      .getPublicUrl(filePath)

    return data.publicUrl
  }

  static async uploadAudio(file: File, incidentId: string): Promise<string> {
    const fileExt = file.name.split('.').pop() || 'webm'
    const fileName = `${incidentId}_${Date.now()}.${fileExt}`
    const filePath = `unsafe-action-condition-audio/${fileName}`

    const { error: uploadError } = await supabase.storage
      .from('safety-files')
      .upload(filePath, file)

    if (uploadError) throw uploadError

    const { data } = supabase.storage
      .from('safety-files')
      .getPublicUrl(filePath)

    return data.publicUrl
  }

  static async getStatistics() {
    const { data, error } = await supabase
      .from(this.TABLE_NAME)
      .select('jenis_kejadian, status, prioritas, created_at')

    if (error) throw error

    const stats = {
      total_incidents: data?.length || 0,
      by_type: {
        unsafe_action: data?.filter(item => item.jenis_kejadian === 'unsafe_action').length || 0,
        unsafe_condition: data?.filter(item => item.jenis_kejadian === 'unsafe_condition').length || 0
      },
      by_status: {
        draft: data?.filter(item => item.status === 'draft').length || 0,
        reported: data?.filter(item => item.status === 'reported').length || 0,
        investigating: data?.filter(item => item.status === 'investigating').length || 0,
        resolved: data?.filter(item => item.status === 'resolved').length || 0,
        closed: data?.filter(item => item.status === 'closed').length || 0
      },
      by_priority: {
        low: data?.filter(item => item.prioritas === 'low').length || 0,
        medium: data?.filter(item => item.prioritas === 'medium').length || 0,
        high: data?.filter(item => item.prioritas === 'high').length || 0,
        critical: data?.filter(item => item.prioritas === 'critical').length || 0
      },
      recent_incidents: data?.filter(item => {
        const createdDate = new Date(item.created_at)
        const weekAgo = new Date()
        weekAgo.setDate(weekAgo.getDate() - 7)
        return createdDate >= weekAgo
      }).length || 0
    }

    return stats
  }
}
