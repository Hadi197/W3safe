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
  jumlah_peserta: number
  foto_dokumentasi: string[]
  status: 'draft' | 'submitted' | 'approved'
  catatan?: string
  approved_by?: string
  approved_at?: string
  created_by?: string
  created_at: string
  updated_at: string
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
  topik: string
  materi?: string
  jumlah_peserta: number
  foto_dokumentasi?: string[]
  status: 'draft' | 'submitted' | 'approved'
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
      status?: 'draft' | 'submitted' | 'approved'
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
        jumlah_peserta,
        foto_dokumentasi,
        status,
        catatan,
        created_by,
        created_at,
        updated_at,
        unit:units!unit_id(id, nama, kode)
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

    // Process data: normalize optional fields
    const processedData = (data || []).map((briefing: any) => ({
      ...briefing,
      jumlah_peserta: briefing.jumlah_peserta || 0,
      foto_dokumentasi: briefing.foto_dokumentasi || [],
      catatan: briefing.catatan || ''
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
        jumlah_peserta,
        foto_dokumentasi,
        status,
        catatan,
        created_by,
        created_at,
        updated_at,
        unit:units!unit_id(id, nama, kode)
      `)
      .eq('id', id)
      .single()

    if (error) throw error
    
    if (!data) return null
    
    // Handle PostgREST returning unit as array or object
    const processedData = {
      ...data,
      unit: data.unit && Array.isArray(data.unit) && data.unit.length > 0 ? data.unit[0] : data.unit
    }
    
    return processedData as SafetyBriefing
  }

  /**
   * Get safety briefing by unit
   */
  async getByUnit(unitId: string): Promise<SafetyBriefing[]> {
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
        jumlah_peserta,
        foto_dokumentasi,
        status,
        catatan,
        created_by,
        created_at,
        updated_at,
        approved_by,
        approved_at,
        unit:units!unit_id(id, nama, kode)
      `)
      .eq('unit_id', unitId)
      .order('tanggal', { ascending: false })

    if (error) throw error
    
    // Handle PostgREST returning unit as array or object
    const processedData = (data || []).map((item: any) => ({
      ...item,
      unit: Array.isArray(item.unit) && item.unit.length > 0 ? item.unit[0] : item.unit
    }))
    
    return processedData as SafetyBriefing[]
  }

  /**
   * Get safety briefing by date range
   */
  async getByDateRange(startDate: string, endDate: string): Promise<SafetyBriefing[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('id, tanggal, waktu_mulai, waktu_selesai, unit_id, petugas_id, topik, materi, jumlah_peserta, foto_dokumentasi, status, catatan, created_by, created_at, updated_at')
      .gte('tanggal', startDate)
      .lte('tanggal', endDate)
      .order('tanggal', { ascending: false })

    if (error) throw error

    // Load unit and petugas data separately
    const processedData = await Promise.all((data || []).map(async (briefing) => {
      const briefingWithRelations = {
        ...briefing,
        // Ensure all required properties are present
        jumlah_peserta: briefing.jumlah_peserta || 0,
        foto_dokumentasi: briefing.foto_dokumentasi || [],
        catatan: briefing.catatan || ''
      } as SafetyBriefing

      // Get unit data
      if (briefing.unit_id) {
        const { data: unit } = await supabase
          .from('units')
          .select('id, nama, kode')
          .eq('id', briefing.unit_id)
          .single()

        if (unit) {
          briefingWithRelations.unit = {
            id: unit.id,
            nama: unit.nama,
            kode: unit.kode
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
  async getByStatus(status: 'draft' | 'submitted' | 'approved'): Promise<SafetyBriefing[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('id, tanggal, waktu_mulai, waktu_selesai, unit_id, petugas_id, topik, materi, jumlah_peserta, foto_dokumentasi, status, catatan, created_by, created_at, updated_at')
      .eq('status', status)
      .order('tanggal', { ascending: false })

    if (error) throw error

    // Load unit data separately
    const processedData = await Promise.all((data || []).map(async (briefing) => {
      const briefingWithRelations = {
        ...briefing,
        // Ensure all required properties are present
        jumlah_peserta: briefing.jumlah_peserta || 0,
        foto_dokumentasi: briefing.foto_dokumentasi || [],
        catatan: briefing.catatan || ''
      } as SafetyBriefing

      // Get unit data
      if (briefing.unit_id) {
        const { data: unit } = await supabase
          .from('units')
          .select('id, nama, kode')
          .eq('id', briefing.unit_id)
          .single()

        if (unit) {
          briefingWithRelations.unit = {
            id: unit.id,
            nama: unit.nama,
            kode: unit.kode
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
      topik: dto.topik,
      materi: dto.materi,
      jumlah_peserta: dto.jumlah_peserta,
      foto_dokumentasi: dto.foto_dokumentasi || [],
      status: dto.status,
      catatan: dto.catatan,
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
        .select('id, nama, kode')
        .eq('id', data.unit_id)
        .single()

      if (unit) {
        unitData = {
          id: unit.id,
          nama: unit.nama,
          kode: unit.kode
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
    if (dto.topik) dbData.topik = dto.topik
    if (dto.materi !== undefined) dbData.materi = dto.materi
    if (dto.jumlah_peserta !== undefined) dbData.jumlah_peserta = dto.jumlah_peserta
    if (dto.foto_dokumentasi !== undefined) dbData.foto_dokumentasi = dto.foto_dokumentasi
    if (dto.status) dbData.status = dto.status
    if (dto.catatan !== undefined) dbData.catatan = dto.catatan

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
        .select('id, nama, kode')
        .eq('id', data.unit_id)
        .single()

      if (unit) {
        unitData = {
          id: unit.id,
          nama: unit.nama,
          kode: unit.kode
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
    
    if (briefing?.foto_dokumentasi && briefing.foto_dokumentasi.length > 0) {
      // Delete all photos from storage
      await Promise.all(
        briefing.foto_dokumentasi.map((url: string) => this.deletePhoto(url))
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
    status: 'draft' | 'submitted' | 'approved'
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
