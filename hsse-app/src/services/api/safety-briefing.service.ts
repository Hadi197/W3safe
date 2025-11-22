import { supabase } from './supabase'

export interface PaginationParams {
  page: number
  pageSize: number
}

export interface PaginatedResponse<T> {
  data: T[]
  count: number
  page: number
  pageSize: number
  totalPages: number
}

export interface SafetyBriefing {
  id: string
  tanggal: string
  waktu_mulai: string
  waktu_selesai?: string
  unit_id?: string
  petugas_id?: string
  topik: string
  materi?: string
  jumlah_peserta?: number
  daftar_peserta?: string[]
  foto_dokumentasi?: string[]
  status: 'draft' | 'approved' | 'rejected'
  catatan?: string
  created_at?: string
  updated_at?: string
  unit?: { id: string; nama: string; kode: string }
  petugas?: { id: string; nama: string; nip: string }
}

export interface CreateSafetyBriefingDto {
  tanggal: string
  waktu_mulai: string
  waktu_selesai?: string
  unit_id?: string
  petugas_id?: string
  topik: string
  materi?: string
  jumlah_peserta?: number
  daftar_peserta?: string[]
  foto_dokumentasi?: string[]
  status?: 'draft' | 'approved' | 'rejected'
  catatan?: string
}

export interface UpdateSafetyBriefingDto extends Partial<CreateSafetyBriefingDto> {}

class SafetyBriefingService {
  private readonly tableName = 'safety_briefing'
  private readonly bucketName = 'safety-briefing-photos'

  /**
   * Get all safety briefing records (backward compatible)
   */
  async getAll(): Promise<SafetyBriefing[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select(`
        *,
        unit:unit_id (id, nama, kode),
        petugas:petugas_id (id, nama, nip)
      `)
      .order('tanggal', { ascending: false })
      .order('waktu_mulai', { ascending: false })

    if (error) throw error
    return data || []
  }

  /**
   * Get paginated safety briefing records with filters
   */
  async getPaginated(
    params: PaginationParams,
    filters?: {
      searchQuery?: string
      unitId?: string
      status?: 'draft' | 'approved' | 'rejected'
      month?: string
    }
  ): Promise<PaginatedResponse<SafetyBriefing>> {
    const { page, pageSize } = params
    const from = (page - 1) * pageSize
    const to = from + pageSize - 1

    let query = supabase
      .from(this.tableName)
      .select(`
        *,
        unit:unit_id (id, nama, kode),
        petugas:petugas_id (id, nama, nip)
      `, { count: 'exact' })

    // Apply filters
    if (filters?.searchQuery) {
      query = query.ilike('topik', `%${filters.searchQuery}%`)
    }

    if (filters?.unitId) {
      query = query.eq('unit_id', filters.unitId)
    }

    if (filters?.status) {
      query = query.eq('status', filters.status)
    }

    if (filters?.month) {
      query = query.ilike('tanggal', `${filters.month}%`)
    }

    // Apply pagination and ordering
    const { data, error, count } = await query
      .order('tanggal', { ascending: false })
      .order('waktu_mulai', { ascending: false })
      .range(from, to)

    if (error) throw error

    return {
      data: data || [],
      count: count || 0,
      page,
      pageSize,
      totalPages: Math.ceil((count || 0) / pageSize)
    }
  }

  /**
   * Get safety briefing by ID
   */
  async getById(id: string): Promise<SafetyBriefing | null> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select(`
        *,
        unit:unit_id (id, nama, kode),
        petugas:petugas_id (id, nama, nip)
      `)
      .eq('id', id)
      .single()

    if (error) throw error
    return data
  }

  /**
   * Get safety briefing by unit
   */
  async getByUnit(unitId: string): Promise<SafetyBriefing[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select(`
        *,
        unit:unit_id (id, nama, kode),
        petugas:petugas_id (id, nama, nip)
      `)
      .eq('unit_id', unitId)
      .order('tanggal', { ascending: false })

    if (error) throw error
    return data || []
  }

  /**
   * Get safety briefing by date range
   */
  async getByDateRange(startDate: string, endDate: string): Promise<SafetyBriefing[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select(`
        *,
        unit:unit_id (id, nama, kode),
        petugas:petugas_id (id, nama, nip)
      `)
      .gte('tanggal', startDate)
      .lte('tanggal', endDate)
      .order('tanggal', { ascending: false })

    if (error) throw error
    return data || []
  }

  /**
   * Get safety briefing by status
   */
  async getByStatus(status: 'draft' | 'approved' | 'rejected'): Promise<SafetyBriefing[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select(`
        *,
        unit:unit_id (id, nama, kode),
        petugas:petugas_id (id, nama, nip)
      `)
      .eq('status', status)
      .order('tanggal', { ascending: false })

    if (error) throw error
    return data || []
  }

  /**
   * Upload single photo
   */
  async uploadPhoto(file: File, briefingId?: string): Promise<string> {
    const fileExt = file.name.split('.').pop()
    const timestamp = Date.now()
    const randomStr = Math.random().toString(36).substring(7)
    const fileName = `${briefingId || 'temp'}_${timestamp}_${randomStr}.${fileExt}`
    const filePath = `${fileName}`

    const { error: uploadError } = await supabase.storage
      .from(this.bucketName)
      .upload(filePath, file, {
        cacheControl: '3600',
        upsert: false
      })

    if (uploadError) throw uploadError

    // Get public URL
    const { data } = supabase.storage
      .from(this.bucketName)
      .getPublicUrl(filePath)

    return data.publicUrl
  }

  /**
   * Upload multiple photos (batch)
   */
  async uploadPhotos(files: File[], briefingId?: string): Promise<string[]> {
    const uploadPromises = files.map(file => this.uploadPhoto(file, briefingId))
    return await Promise.all(uploadPromises)
  }

  /**
   * Delete photo from storage
   */
  async deletePhoto(photoUrl: string): Promise<void> {
    // Extract file path from URL
    const urlParts = photoUrl.split('/')
    const fileName = urlParts[urlParts.length - 1]

    if (!fileName) {
      throw new Error('Invalid photo URL')
    }

    const { error } = await supabase.storage
      .from(this.bucketName)
      .remove([fileName])

    if (error) throw error
  }

  /**
   * Create new safety briefing
   */
  async create(dto: CreateSafetyBriefingDto): Promise<SafetyBriefing> {
    const { data, error } = await supabase
      .from(this.tableName)
      .insert({
        ...dto,
        status: dto.status || 'draft'
      })
      .select(`
        *,
        unit:unit_id (id, nama, kode),
        petugas:petugas_id (id, nama, nip)
      `)
      .single()

    if (error) throw error
    return data
  }

  /**
   * Update safety briefing
   */
  async update(id: string, dto: UpdateSafetyBriefingDto): Promise<SafetyBriefing> {
    const { data, error } = await supabase
      .from(this.tableName)
      .update(dto)
      .eq('id', id)
      .select(`
        *,
        unit:unit_id (id, nama, kode),
        petugas:petugas_id (id, nama, nip)
      `)
      .single()

    if (error) throw error
    return data
  }

  /**
   * Delete safety briefing
   */
  async delete(id: string): Promise<void> {
    // First, get the record to delete associated photos
    const briefing = await this.getById(id)
    
    if (briefing?.foto_dokumentasi && briefing.foto_dokumentasi.length > 0) {
      // Delete all photos from storage
      await Promise.all(
        briefing.foto_dokumentasi.map(url => this.deletePhoto(url))
      )
    }

    const { error } = await supabase
      .from(this.tableName)
      .delete()
      .eq('id', id)

    if (error) throw error
  }

  /**
   * Update status
   */
  async updateStatus(
    id: string, 
    status: 'draft' | 'approved' | 'rejected'
  ): Promise<SafetyBriefing> {
    return await this.update(id, { status })
  }

  /**
   * Get statistics
   */
  async getStats(startDate?: string, endDate?: string) {
    let query = supabase
      .from(this.tableName)
      .select('id, status, jumlah_peserta', { count: 'exact' })

    if (startDate) query = query.gte('tanggal', startDate)
    if (endDate) query = query.lte('tanggal', endDate)

    const { data, error, count } = await query

    if (error) throw error

    const stats = {
      total: count || 0,
      draft: data?.filter(d => d.status === 'draft').length || 0,
      approved: data?.filter(d => d.status === 'approved').length || 0,
      rejected: data?.filter(d => d.status === 'rejected').length || 0,
      totalPeserta: data?.reduce((sum, d) => sum + (d.jumlah_peserta || 0), 0) || 0
    }

    return stats
  }
}

export const safetyBriefingService = new SafetyBriefingService()
