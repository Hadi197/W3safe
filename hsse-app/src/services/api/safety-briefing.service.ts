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
  status: 'draft' | 'approved' | 'rejected'
  created_by?: string
  created_at: string
  updated_at: string
  // Mapped properties for frontend compatibility
  topik_briefing?: string
  materi_briefing?: string
  foto_briefing?: any
  // Relations
  unit?: {
    id: string
    nama: string
    kode: string
  }
  petugas?: {
    id: string
    nama: string
    nip: string
  }
}

export interface CreateSafetyBriefingDto {
  tanggal: string
  waktu_mulai: string
  waktu_selesai?: string
  unit_id?: string
  petugas_id?: string
  topik?: string
  topik_briefing?: string
  materi?: string
  materi_briefing?: string
  foto_dokumentasi?: string[]
  status?: 'draft' | 'approved' | 'rejected'
}

export interface UpdateSafetyBriefingDto extends Partial<CreateSafetyBriefingDto> {}

class SafetyBriefingService {
  private readonly tableName = 'safety_briefing'
  private readonly bucketName = 'safety-briefing-photos'

  /**
   * Get all safety briefing records (backward compatible)
   */
  async getAll(): Promise<SafetyBriefing[]> {
    const result = await this.getPaginated({ page: 1, pageSize: 1000 })
    return result.data
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
        id,
        tanggal,
        waktu_mulai,
        waktu_selesai,
        unit_id,
        petugas_id,
        topik,
        materi,
        foto_briefing,
        status,
        created_by,
        created_at,
        updated_at
      `, { count: 'exact' })

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

    // Get unit data separately
    const processedData = await Promise.all((data || []).map(async (briefing) => {
      const briefingWithRelations = {
        ...briefing,
        // Map database columns to frontend properties
        topik_briefing: briefing.topik,
        materi_briefing: briefing.materi,
        foto_dokumentasi: briefing.foto_briefing || []
      } as SafetyBriefing

      // Get unit data
      if (briefing.unit_id) {
        const { data: unit } = await supabase
          .from('units')
          .select('id, nama_unit, kode_unit')
          .eq('id', briefing.unit_id)
          .single()

        if (unit) {
          briefingWithRelations.unit = {
            id: unit.id,
            nama: unit.nama_unit,
            kode: unit.kode_unit
          }
        }
      }

      // Get petugas data
      if (briefing.petugas_id) {
        const { data: petugas } = await supabase
          .from('pegawai')
          .select('id, nama_lengkap, nip')
          .eq('id', briefing.petugas_id)
          .single()

        if (petugas) {
          briefingWithRelations.petugas = {
            id: petugas.id,
            nama: petugas.nama_lengkap,
            nip: petugas.nip
          }
        }
      }

      return briefingWithRelations
    }))

    return {
      data: processedData,
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
        id,
        tanggal,
        waktu_mulai,
        waktu_selesai,
        unit_id,
        petugas_id,
        topik,
        materi,
        status,
        created_by,
        created_at,
        updated_at
      `)
      .eq('id', id)
      .single()

    if (error) throw error

    // Get unit and petugas data separately
    const briefingWithRelations = {
      ...data,
      // Map database columns to frontend properties
      topik_briefing: data.topik,
      materi_briefing: data.materi,
      foto_briefing: data.materi // placeholder
    } as SafetyBriefing

    if (data.unit_id) {
      const { data: unit } = await supabase
        .from('units')
        .select('id, nama_unit, kode_unit')
        .eq('id', data.unit_id)
        .single()

      if (unit) {
        briefingWithRelations.unit = {
          id: unit.id,
          nama: unit.nama_unit,
          kode: unit.kode_unit
        }
      }
    }

    if (data.petugas_id) {
      const { data: petugas } = await supabase
        .from('pegawai')
        .select('id, nama_lengkap, nip')
        .eq('id', data.petugas_id)
        .single()

      if (petugas) {
        briefingWithRelations.petugas = {
          id: petugas.id,
          nama: petugas.nama_lengkap,
          nip: petugas.nip
        }
      }
    }

    return briefingWithRelations
  }

  /**
   * Get safety briefing by unit
   */
  async getByUnit(unitId: string): Promise<SafetyBriefing[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select(`
        id,
        nomor_briefing,
        tanggal,
        waktu_mulai,
        waktu_selesai,
        unit_id,
        area_briefing,
        topik_briefing,
        peserta,
        jumlah_peserta,
        materi_briefing,
        poin_poin_pembahasan,
        kesimpulan,
        rekomendasi,
        tindak_lanjut,
        foto_briefing,
        dokumen_pendukung,
        status,
        jenis_briefing,
        created_by,
        created_at,
        updated_at,
        approved_by,
        approved_at
      `)
      .eq('unit_id', unitId)
      .order('tanggal', { ascending: false })

    if (error) throw error

    // Get unit data for each briefing
    const processedData = await Promise.all((data || []).map(async (briefing) => {
      const briefingWithRelations = {
        ...briefing,
        // Map database columns to frontend properties
        topik_briefing: briefing.topik,
        materi_briefing: briefing.materi,
        foto_dokumentasi: briefing.foto_briefing || []
      } as SafetyBriefing

      if (briefing.unit_id) {
        const { data: unit } = await supabase
          .from('units')
          .select('id, nama, kode')
          .eq('id', briefing.unit_id)
          .single()

        if (unit) {
          briefingWithRelations.unit = unit
        }
      }

      return briefingWithRelations
    }))

    return processedData
  }

  /**
   * Get safety briefing by date range
   */
  async getByDateRange(startDate: string, endDate: string): Promise<SafetyBriefing[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('id, tanggal, waktu_mulai, waktu_selesai, unit_id, petugas_id, topik, materi, status, created_by, created_at, updated_at')
      .gte('tanggal', startDate)
      .lte('tanggal', endDate)
      .order('tanggal', { ascending: false })

    if (error) throw error

    // Load unit and petugas data separately
    const processedData = await Promise.all((data || []).map(async (briefing) => {
      const briefingWithRelations = {
        ...briefing,
        topik_briefing: briefing.topik,
        materi_briefing: briefing.materi
      } as SafetyBriefing

      // Get unit data
      if (briefing.unit_id) {
        const { data: unit } = await supabase
          .from('units')
          .select('id, nama_unit, kode_unit')
          .eq('id', briefing.unit_id)
          .single()

        if (unit) {
          briefingWithRelations.unit = {
            id: unit.id,
            nama: unit.nama_unit,
            kode: unit.kode_unit
          }
        }
      }

      return briefingWithRelations
    }))

    return processedData
  }

  /**
   * Get safety briefing by status
   */
  async getByStatus(status: 'draft' | 'approved' | 'rejected'): Promise<SafetyBriefing[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('id, tanggal, waktu_mulai, waktu_selesai, unit_id, petugas_id, topik, materi, status, created_by, created_at, updated_at')
      .eq('status', status)
      .order('tanggal', { ascending: false })

    if (error) throw error

    // Load unit data separately
    const processedData = await Promise.all((data || []).map(async (briefing) => {
      const briefingWithRelations = {
        ...briefing,
        topik_briefing: briefing.topik,
        materi_briefing: briefing.materi
      } as SafetyBriefing

      // Get unit data
      if (briefing.unit_id) {
        const { data: unit } = await supabase
          .from('units')
          .select('id, nama_unit, kode_unit')
          .eq('id', briefing.unit_id)
          .single()

        if (unit) {
          briefingWithRelations.unit = {
            id: unit.id,
            nama: unit.nama_unit,
            kode: unit.kode_unit
          }
        }
      }

      return briefingWithRelations
    }))

    return processedData
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
    // Map frontend properties to database columns
    const dbData = {
      tanggal: dto.tanggal,
      waktu_mulai: dto.waktu_mulai,
      waktu_selesai: dto.waktu_selesai,
      unit_id: dto.unit_id,
      petugas_id: dto.petugas_id || (await this.getDemoPetugasId()),
      topik: dto.topik_briefing || dto.topik,
      materi: dto.materi_briefing || dto.materi,
      foto_briefing: (dto as any).foto_dokumentasi || [],
      status: dto.status || 'draft',
      created_by: dto.petugas_id || (await this.getDemoPetugasId())
    }

    const { data, error } = await supabase
      .from(this.tableName)
      .insert(dbData)
      .select()
      .single()

    if (error) throw error

    // Get unit data separately to avoid join issues
    let unitData = undefined
    if (data.unit_id) {
      const { data: unit } = await supabase
        .from('units')
        .select('id, nama_unit, kode_unit')
        .eq('id', data.unit_id)
        .single()

      if (unit) {
        unitData = {
          id: unit.id,
          nama: unit.nama_unit,
          kode: unit.kode_unit
        }
      }
    }

    // Map response to frontend format
    return {
      ...data,
      topik_briefing: data.topik,
      materi_briefing: data.materi,
      unit: unitData
    }
  }

  // Helper method to get demo petugas ID
  private async getDemoPetugasId(): Promise<string> {
    const { data } = await supabase
      .from('pegawai')
      .select('id')
      .eq('nip', 'DEMO001')
      .single()

    return data?.id || ''
  }

  /**
   * Update safety briefing
   */
  async update(id: string, dto: UpdateSafetyBriefingDto): Promise<SafetyBriefing> {
    // Map frontend properties to database columns
    const dbData: any = {}

    if (dto.tanggal) dbData.tanggal = dto.tanggal
    if (dto.waktu_mulai) dbData.waktu_mulai = dto.waktu_mulai
    if (dto.waktu_selesai !== undefined) dbData.waktu_selesai = dto.waktu_selesai
    if (dto.unit_id) dbData.unit_id = dto.unit_id
    if (dto.petugas_id) dbData.petugas_id = dto.petugas_id
    if (dto.topik_briefing) dbData.topik = dto.topik_briefing
    if (dto.materi_briefing) dbData.materi = dto.materi_briefing
    if ((dto as any).foto_dokumentasi !== undefined) dbData.foto_briefing = (dto as any).foto_dokumentasi
    if (dto.status) dbData.status = dto.status

    const { data, error } = await supabase
      .from(this.tableName)
      .update(dbData)
      .eq('id', id)
      .select()
      .single()

    if (error) throw error

    // Get unit data separately to avoid join issues
    let unitData = undefined
    if (data.unit_id) {
      const { data: unit } = await supabase
        .from('units')
        .select('id, nama_unit, kode_unit')
        .eq('id', data.unit_id)
        .single()

      if (unit) {
        unitData = {
          id: unit.id,
          nama: unit.nama_unit,
          kode: unit.kode_unit
        }
      }
    }

    // Map response to frontend format
    return {
      ...data,
      topik_briefing: data.topik,
      materi_briefing: data.materi,
      unit: unitData
    }
  }

  /**
   * Delete safety briefing
   */
  async delete(id: string): Promise<void> {
    // First, get the record to delete associated photos
    const briefing = await this.getById(id)
    
    if (briefing?.foto_briefing && briefing.foto_briefing.length > 0) {
      // Delete all photos from storage
      await Promise.all(
        briefing.foto_briefing.map((url: string) => this.deletePhoto(url))
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
