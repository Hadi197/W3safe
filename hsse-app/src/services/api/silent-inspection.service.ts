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

export interface SilentInspection {
  id: string
  tanggal: string
  waktu_mulai: string
  waktu_selesai?: string
  unit_id?: string
  area_inspeksi?: string
  inspector_id?: string
  anggota_tim?: string[]
  kategori_bahaya?: 'fisik_mekanik' | 'kimia' | 'biologis' | 'ergonomi' | 'psikososial' | 'kombinasi'
  checklist_items?: any
  jumlah_temuan: number
  temuan_critical: number
  temuan_major: number
  temuan_minor: number
  deskripsi_temuan?: string
  foto_kondisi_unsafe?: string[]
  foto_perilaku_unsafe?: string[]
  skor_kepatuhan?: number
  tingkat_risiko?: 'rendah' | 'sedang' | 'tinggi' | 'sangat_tinggi'
  kondisi_housekeeping?: 'baik' | 'cukup' | 'buruk'
  penggunaan_apd?: 'baik' | 'cukup' | 'buruk'
  rekomendasi?: string
  tindakan_korektif?: string
  pic_tindak_lanjut?: string
  target_penyelesaian?: string
  status_tindak_lanjut: 'open' | 'in_progress' | 'closed'
  status: 'draft' | 'submitted' | 'verified' | 'closed'
  catatan?: string
  verified_by?: string
  verified_at?: string
  created_at: string
  updated_at: string
  // Relations
  unit?: {
    id: string
    nama: string
    kode: string
  }
  inspector?: {
    id: string
    nama: string
    nip: string
  }
  verifier?: {
    id: string
    nama: string
    nip: string
  }
}

export interface CreateSilentInspectionDto {
  tanggal: string
  waktu_mulai: string
  waktu_selesai?: string
  unit_id?: string
  area_inspeksi?: string
  inspector_id?: string
  anggota_tim?: string[]
  kategori_bahaya?: string
  checklist_items?: any
  jumlah_temuan?: number
  temuan_critical?: number
  temuan_major?: number
  temuan_minor?: number
  deskripsi_temuan?: string
  foto_kondisi_unsafe?: string[]
  foto_perilaku_unsafe?: string[]
  skor_kepatuhan?: number
  tingkat_risiko?: string
  kondisi_housekeeping?: string
  penggunaan_apd?: string
  rekomendasi?: string
  tindakan_korektif?: string
  pic_tindak_lanjut?: string
  target_penyelesaian?: string
  status_tindak_lanjut?: string
  status?: string
  catatan?: string
}

export interface UpdateSilentInspectionDto {
  tanggal?: string
  waktu_mulai?: string
  waktu_selesai?: string
  unit_id?: string
  area_inspeksi?: string
  inspector_id?: string
  anggota_tim?: string[]
  kategori_bahaya?: string
  checklist_items?: any
  jumlah_temuan?: number
  temuan_critical?: number
  temuan_major?: number
  temuan_minor?: number
  deskripsi_temuan?: string
  foto_kondisi_unsafe?: string[]
  foto_perilaku_unsafe?: string[]
  skor_kepatuhan?: number
  tingkat_risiko?: string
  kondisi_housekeeping?: string
  penggunaan_apd?: string
  rekomendasi?: string
  tindakan_korektif?: string
  pic_tindak_lanjut?: string
  target_penyelesaian?: string
  status_tindak_lanjut?: string
  status?: string
  catatan?: string
  verified_by?: string
  verified_at?: string
}

class SilentInspectionService {
  private tableName = 'silent_inspection'
  private bucketName = 'silent-inspection-photos'

  async uploadPhoto(file: File, inspectionId: string): Promise<string> {
    const fileExt = file.name.split('.').pop()
    const fileName = `${inspectionId}_${Date.now()}_${Math.random().toString(36).substring(7)}.${fileExt}`
    
    const { error: uploadError } = await supabase.storage
      .from(this.bucketName)
      .upload(fileName, file)

    if (uploadError) throw uploadError

    const { data } = supabase.storage
      .from(this.bucketName)
      .getPublicUrl(fileName)

    return data.publicUrl
  }

  async uploadPhotos(files: File[], inspectionId: string): Promise<string[]> {
    const uploadPromises = files.map(file => this.uploadPhoto(file, inspectionId))
    return Promise.all(uploadPromises)
  }

  async deletePhoto(photoUrl: string): Promise<void> {
    const fileName = photoUrl.split('/').pop()
    if (!fileName) return

    const { error } = await supabase.storage
      .from(this.bucketName)
      .remove([fileName])

    if (error) throw error
  }

  // Backward compatible - load all records
  async getAll(filters?: {
    search?: string
    unit_id?: string
    tingkat_risiko?: string
    status?: string
    tanggal_dari?: string
    tanggal_sampai?: string
  }): Promise<SilentInspection[]> {
    const result = await this.getPaginated(filters, { page: 1, pageSize: 10000 })
    return result.data
  }

  // Paginated version for performance
  async getPaginated(
    filters?: {
      search?: string
      unit_id?: string
      tingkat_risiko?: string
      status?: string
      tanggal_dari?: string
      tanggal_sampai?: string
    },
    pagination: PaginationParams = { page: 1, pageSize: 20 }
  ): Promise<PaginatedResponse<SilentInspection>> {
    let query = supabase
      .from(this.tableName)
      .select(`
        *,
        unit:unit_id (
          id,
          nama,
          kode
        ),
        inspector:inspector_id (
          id,
          nama,
          nip
        ),
        verifier:verified_by (
          id,
          nama,
          nip
        )
      `, { count: 'exact' })
      .order('tanggal', { ascending: false })

    if (filters?.search) {
      query = query.or(`area_inspeksi.ilike.%${filters.search}%,deskripsi_temuan.ilike.%${filters.search}%`)
    }

    if (filters?.unit_id) {
      query = query.eq('unit_id', filters.unit_id)
    }

    if (filters?.tingkat_risiko) {
      query = query.eq('tingkat_risiko', filters.tingkat_risiko)
    }

    if (filters?.status) {
      query = query.eq('status', filters.status)
    }

    if (filters?.tanggal_dari) {
      query = query.gte('tanggal', filters.tanggal_dari)
    }

    if (filters?.tanggal_sampai) {
      query = query.lte('tanggal', filters.tanggal_sampai)
    }

    // Apply pagination
    const from = (pagination.page - 1) * pagination.pageSize
    const to = from + pagination.pageSize - 1
    query = query.range(from, to)

    const { data, error, count } = await query

    if (error) throw error

    const totalCount = count || 0
    const totalPages = Math.ceil(totalCount / pagination.pageSize)

    return {
      data: (data || []) as SilentInspection[],
      count: totalCount,
      page: pagination.page,
      pageSize: pagination.pageSize,
      totalPages
    }
  }

  async getById(id: string): Promise<SilentInspection | null> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select(`
        *,
        unit:unit_id (
          id,
          nama,
          kode
        ),
        inspector:inspector_id (
          id,
          nama,
          nip
        ),
        verifier:verified_by (
          id,
          nama,
          nip
        )
      `)
      .eq('id', id)
      .single()

    if (error) throw error
    return data
  }

  async getByUnit(unitId: string): Promise<SilentInspection[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select(`
        *,
        unit:unit_id (
          id,
          nama,
          kode
        ),
        inspector:inspector_id (
          id,
          nama,
          nip
        ),
        verifier:verified_by (
          id,
          nama,
          nip
        )
      `)
      .eq('unit_id', unitId)
      .order('tanggal', { ascending: false })

    if (error) throw error
    return data || []
  }

  async getByDateRange(startDate: string, endDate: string): Promise<SilentInspection[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select(`
        *,
        unit:unit_id (
          id,
          nama,
          kode
        ),
        inspector:inspector_id (
          id,
          nama,
          nip
        ),
        verifier:verified_by (
          id,
          nama,
          nip
        )
      `)
      .gte('tanggal', startDate)
      .lte('tanggal', endDate)
      .order('tanggal', { ascending: false })

    if (error) throw error
    return data || []
  }

  async getByStatus(status: string): Promise<SilentInspection[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select(`
        *,
        unit:unit_id (
          id,
          nama,
          kode
        ),
        inspector:inspector_id (
          id,
          nama,
          nip
        ),
        verifier:verified_by (
          id,
          nama,
          nip
        )
      `)
      .eq('status', status)
      .order('tanggal', { ascending: false })

    if (error) throw error
    return data || []
  }

  async getByRiskLevel(tingkatRisiko: string): Promise<SilentInspection[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select(`
        *,
        unit:unit_id (
          id,
          nama,
          kode
        ),
        inspector:inspector_id (
          id,
          nama,
          nip
        ),
        verifier:verified_by (
          id,
          nama,
          nip
        )
      `)
      .eq('tingkat_risiko', tingkatRisiko)
      .order('tanggal', { ascending: false })

    if (error) throw error
    return data || []
  }

  async create(dto: CreateSilentInspectionDto): Promise<SilentInspection> {
    const { data, error } = await supabase
      .from(this.tableName)
      .insert(dto)
      .select(`
        *,
        unit:unit_id (
          id,
          nama,
          kode
        ),
        inspector:inspector_id (
          id,
          nama,
          nip
        ),
        verifier:verified_by (
          id,
          nama,
          nip
        )
      `)
      .single()

    if (error) throw error
    return data
  }

  async update(id: string, dto: UpdateSilentInspectionDto): Promise<SilentInspection> {
    const { data, error } = await supabase
      .from(this.tableName)
      .update(dto)
      .eq('id', id)
      .select(`
        *,
        unit:unit_id (
          id,
          nama,
          kode
        ),
        inspector:inspector_id (
          id,
          nama,
          nip
        ),
        verifier:verified_by (
          id,
          nama,
          nip
        )
      `)
      .single()

    if (error) throw error
    return data
  }

  async delete(id: string): Promise<void> {
    // Get the inspection to delete associated photos
    const inspection = await this.getById(id)
    if (inspection) {
      // Delete photos from storage
      const allPhotos = [
        ...(inspection.foto_kondisi_unsafe || []),
        ...(inspection.foto_perilaku_unsafe || [])
      ]
      
      for (const photoUrl of allPhotos) {
        try {
          await this.deletePhoto(photoUrl)
        } catch (error) {
          console.error('Error deleting photo:', error)
        }
      }
    }

    const { error } = await supabase
      .from(this.tableName)
      .delete()
      .eq('id', id)

    if (error) throw error
  }

  async verify(id: string, verifiedBy: string): Promise<SilentInspection> {
    return this.update(id, {
      status: 'verified',
      verified_by: verifiedBy,
      verified_at: new Date().toISOString()
    })
  }

  async getStats(): Promise<{
    total: number
    byStatus: Record<string, number>
    byRiskLevel: Record<string, number>
    criticalFindings: number
    openFollowUps: number
  }> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('status, tingkat_risiko, temuan_critical, status_tindak_lanjut')

    if (error) throw error

    const stats = {
      total: data.length,
      byStatus: {} as Record<string, number>,
      byRiskLevel: {} as Record<string, number>,
      criticalFindings: 0,
      openFollowUps: 0
    }

    data.forEach(item => {
      // Count by status
      stats.byStatus[item.status] = (stats.byStatus[item.status] || 0) + 1
      
      // Count by risk level
      if (item.tingkat_risiko) {
        stats.byRiskLevel[item.tingkat_risiko] = (stats.byRiskLevel[item.tingkat_risiko] || 0) + 1
      }
      
      // Sum critical findings
      stats.criticalFindings += item.temuan_critical || 0
      
      // Count open follow-ups
      if (item.status_tindak_lanjut === 'open') {
        stats.openFollowUps++
      }
    })

    return stats
  }
}

export const silentInspectionService = new SilentInspectionService()
