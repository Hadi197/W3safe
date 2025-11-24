import { supabase, isSupabaseConfigured } from './supabase'

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
  triwulan?: number
  tahun?: number
  unit_id?: string
  wilayah_id?: string
  inspector_id?: string
  area_inspeksi: string
  checklist?: any
  skor_total?: number
  temuan?: any
  rekomendasi?: string
  foto_temuan?: string[]
  status: 'draft' | 'approved' | 'closed'
  approved_by?: string
  approved_at?: string
  created_at: string
  updated_at: string
  // Mapped properties for frontend compatibility
  nomor_inspeksi?: string
  waktu_mulai?: string
  waktu_selesai?: string
  jenis_inspeksi?: string
  fokus_inspeksi?: any
  jumlah_temuan?: number
  kategori_temuan?: any
  kategori_bahaya?: string
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
  tindak_lanjut?: any
  tindakan_korektif?: string
  pic_tindak_lanjut?: string
  target_penyelesaian?: string
  status_tindak_lanjut?: string
  status_verifikasi?: string
  foto_inspeksi?: any
  dokumen_pendukung?: any
  catatan_inspector?: string
  catatan_verifier?: string
  catatan?: string
  verified_by?: string
  created_by?: string
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
  // Additional properties used in service
  triwulan?: number
  tahun?: number
  wilayah_id?: string
  fokus_inspeksi?: any
  skor_total?: number
  temuan?: any
}

export interface UpdateSilentInspectionDto {
  tanggal?: string
  waktu_mulai?: string
  waktu_selesai?: string
  unit_id?: string
  wilayah_id?: string
  area_inspeksi?: string
  inspector_id?: string
  anggota_tim?: string[]
  kategori_bahaya?: string
  checklist_items?: any
  fokus_inspeksi?: any
  jumlah_temuan?: number
  temuan_critical?: number
  temuan_major?: number
  temuan_minor?: number
  deskripsi_temuan?: string
  foto_kondisi_unsafe?: string[]
  foto_perilaku_unsafe?: string[]
  skor_kepatuhan?: number
  skor_total?: number
  temuan?: string
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

  async uploadPhoto(file: File, inspectionId?: string): Promise<string> {
    const fileExt = file.name.split('.').pop()
    const timestamp = Date.now()
    const randomStr = Math.random().toString(36).substring(7)
    const prefix = inspectionId || `temp_${timestamp}`
    const fileName = `${prefix}_${timestamp}_${randomStr}.${fileExt}`

    console.log(`📤 Uploading to bucket: ${this.bucketName}`)
    console.log(`📄 Filename: ${fileName}`)
    console.log(`📏 File size: ${file.size} bytes`)

    const { data: uploadData, error: uploadError } = await supabase.storage
      .from(this.bucketName)
      .upload(fileName, file, {
        cacheControl: '3600',
        upsert: false
      })

    if (uploadError) {
      console.error('❌ Upload error:', uploadError)
      throw new Error(`Upload failed: ${uploadError.message}`)
    }

    console.log('✅ Upload successful:', uploadData)

    const { data } = supabase.storage
      .from(this.bucketName)
      .getPublicUrl(fileName)

    console.log('🔗 Public URL:', data.publicUrl)
    return data.publicUrl
  }

  async uploadPhotos(files: File[], inspectionId?: string): Promise<string[]> {
    console.log(`📤 Uploading ${files.length} photos for inspection: ${inspectionId || 'temp'}`)

    const uploadPromises = files.map(async (file, index) => {
      try {
        console.log(`📤 Uploading photo ${index + 1}/${files.length}: ${file.name}`)
        return await this.uploadPhoto(file, inspectionId)
      } catch (error) {
        console.error(`❌ Failed to upload photo ${index + 1}:`, error)
        const errorMessage = error instanceof Error ? error.message : 'Unknown error'
        throw new Error(`Upload failed for ${file.name}: ${errorMessage}`)
      }
    })

    try {
      const results = await Promise.all(uploadPromises)
      console.log(`✅ Successfully uploaded ${results.length} photos`)
      return results
    } catch (error) {
      console.error('❌ Batch upload failed:', error)
      throw error
    }
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

  // Helper function to calculate risk level based on findings
  private calculateRiskLevel(item: any): string {
    const critical = item.temuan_critical || 0
    const major = item.temuan_major || 0
    const minor = item.temuan_minor || 0

    // Risk calculation logic:
    // - Critical findings: High risk
    // - Major findings: Medium risk
    // - Minor findings: Low risk
    // - Score-based fallback
    if (critical > 0) return 'sangat_tinggi'
    if (major > 2) return 'tinggi'
    if (major > 0 || minor > 3) return 'sedang'
    if (minor > 0) return 'rendah'

    // Fallback to score-based calculation
    const score = item.skor_total
    if (score && score < 50) return 'sangat_tinggi'
    if (score && score < 70) return 'tinggi'
    if (score && score < 85) return 'sedang'
    return 'rendah'
  }

  // Paginated version for performance
  async getPaginated(
    filters?: {
      search?: string
      unit_id?: string
      tingkat_risiko?: string
      status?: string
      status_verifikasi?: string
      tanggal_dari?: string
      tanggal_sampai?: string
    },
    pagination: PaginationParams = { page: 1, pageSize: 20 }
  ): Promise<PaginatedResponse<SilentInspection>> {
    let query = supabase
      .from(this.tableName)
      .select(`
        id,
        tanggal,
        triwulan,
        tahun,
        unit_id,
        wilayah_id,
        inspector_id,
        area_inspeksi,
        checklist,
        rekomendasi,
        status,
        approved_by,
        approved_at,
        created_at,
        updated_at,
        foto_kondisi_unsafe,
        foto_perilaku_unsafe,
        temuan_critical,
        temuan_major,
        temuan_minor
      `, { count: 'exact' })
      .order('tanggal', { ascending: false })

    if (filters?.search) {
      query = query.or(`area_inspeksi.ilike.%${filters.search}%,rekomendasi.ilike.%${filters.search}%`)
    }

    if (filters?.unit_id) {
      query = query.eq('unit_id', filters.unit_id)
    }

    if (filters?.status_verifikasi) {
      // Map status_verifikasi filter to actual status column
      if (filters.status_verifikasi === 'verified') {
        query = query.eq('status', 'approved')
      } else if (filters.status_verifikasi === 'pending') {
        query = query.neq('status', 'approved')
      }
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

    // Fetch related data for each item
    const processedData = await Promise.all((data || []).map(async (item: any) => {
      const itemWithRelations = {
        ...item,
      // Map database columns to frontend expected properties
      nomor_inspeksi: `SI-${item.id?.slice(-8) || 'UNKNOWN'}`, // Generate simple inspection number
      waktu_mulai: '08:00:00', // Default time
      waktu_selesai: '17:00:00', // Default time
      jenis_inspeksi: 'silent',
      fokus_inspeksi: item.checklist || [],
      jumlah_temuan: (item.temuan_critical || 0) + (item.temuan_major || 0) + (item.temuan_minor || 0),
      kategori_bahaya: 'General',
      foto_kondisi_unsafe: item.foto_kondisi_unsafe || [],
      foto_perilaku_unsafe: item.foto_perilaku_unsafe || [],
      skor_kepatuhan: 0,
      tingkat_risiko: this.calculateRiskLevel(item),
      kondisi_housekeeping: 'Baik',
      penggunaan_apd: 'Baik',
      tindakan_korektif: item.rekomendasi || '',
      status_verifikasi: item.status === 'approved' ? 'verified' : 'pending',
      verified_by: item.approved_by,
      created_by: item.approved_by
      } as SilentInspection

      // Get unit data
      if (item.unit_id) {
        const { data: unit } = await supabase
          .from('units')
          .select('id, nama, kode')
          .eq('id', item.unit_id)
          .single()

        if (unit) {
          itemWithRelations.unit = {
            id: unit.id,
            nama: unit.nama,
            kode: unit.kode
          }
        }
      }

      // Get inspector data
      if (item.inspector_id) {
        const { data: inspector } = await supabase
          .from('pegawai')
          .select('id, nama_lengkap, nip')
          .eq('id', item.inspector_id)
          .single()

        if (inspector) {
          itemWithRelations.inspector = {
            id: inspector.id,
            nama: inspector.nama_lengkap,
            nip: inspector.nip
          }
        }
      }

      return itemWithRelations
    }))

    return {
      data: processedData,
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
        id, tanggal, triwulan, tahun, unit_id, wilayah_id, inspector_id,
        area_inspeksi, checklist, rekomendasi,
        status, approved_by, approved_at,
        created_at, updated_at,
        foto_kondisi_unsafe, foto_perilaku_unsafe,
        temuan_critical, temuan_major, temuan_minor
      `)
      .eq('id', id)
      .single()

    if (error) throw error

    // Load relations separately
    let unitData = undefined
    let inspectorData = undefined

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

    if (data.inspector_id) {
      const { data: inspector } = await supabase
        .from('pegawai')
        .select('id, nama_lengkap, nip')
        .eq('id', data.inspector_id)
        .single()

      if (inspector) {
        inspectorData = {
          id: inspector.id,
          nama: inspector.nama_lengkap,
          nip: inspector.nip
        }
      }
    }

    // Map to frontend format
    return {
      ...data,
      nomor_inspeksi: `SI-${data.id?.slice(-8) || 'UNKNOWN'}`,
      waktu_mulai: '08:00:00',
      waktu_selesai: '17:00:00',
      jenis_inspeksi: 'silent',
      fokus_inspeksi: data.checklist || [],
      jumlah_temuan: (data.temuan_critical || 0) + (data.temuan_major || 0) + (data.temuan_minor || 0),
      kategori_bahaya: 'General',
      foto_kondisi_unsafe: data.foto_kondisi_unsafe || [],
      foto_perilaku_unsafe: data.foto_perilaku_unsafe || [],
      skor_kepatuhan: 0,
      tingkat_risiko: 'Rendah',
      kondisi_housekeeping: 'Baik',
      penggunaan_apd: 'Baik',
      tindakan_korektif: data.rekomendasi || '',
      status_verifikasi: data.status === 'approved' ? 'verified' : 'pending',
      verified_by: data.approved_by,
      created_by: data.approved_by,
      unit: unitData,
      inspector: inspectorData
    }
  }

  async getByUnit(unitId: string): Promise<SilentInspection[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select(`
        *,
        foto_kondisi_unsafe,
        foto_perilaku_unsafe,
        unit:unit_id (
          id,
          nama,
          kode
        ),
        inspector:pegawai!inspector_id (
          id,
          nama,
          nip
        ),
        verifier:pegawai!verified_by (
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
        foto_kondisi_unsafe,
        foto_perilaku_unsafe,
        unit:unit_id (
          id,
          nama,
          kode
        ),
        inspector:pegawai!inspector_id (
          id,
          nama,
          nip
        ),
        verifier:pegawai!verified_by (
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
        foto_kondisi_unsafe,
        foto_perilaku_unsafe,
        unit:unit_id (
          id,
          nama,
          kode
        ),
        inspector:pegawai!inspector_id (
          id,
          nama,
          nip
        ),
        verifier:pegawai!verified_by (
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
        foto_kondisi_unsafe,
        foto_perilaku_unsafe,
        unit:unit_id (
          id,
          nama,
          kode
        ),
        inspector:pegawai!inspector_id (
          id,
          nama,
          nip
        ),
        verifier:pegawai!verified_by (
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
    // Ensure we have a valid inspector_id
    let inspectorId = dto.inspector_id

    if (!inspectorId) {
      // Try to get current user and find their pegawai record
      try {
        const { data: { user }, error: userError } = await supabase.auth.getUser()
        if (user && !userError) {
          console.log('Current user email:', user.email)

          // Find pegawai record for this user
          const { data: pegawai, error: pegawaiError } = await supabase
            .from('pegawai')
            .select('id, nama_lengkap, jabatan')
            .eq('email', user.email)
            .single()

          if (pegawai && !pegawaiError) {
            console.log('Found pegawai record:', pegawai)
            inspectorId = pegawai.id
          } else {
            console.log('Pegawai not found for user, will use demo inspector')
            // Don't throw error here, just log and continue to fallback
          }
        } else {
          console.log('No authenticated user found')
        }
      } catch (error) {
        console.warn('Error getting current user:', error)
      }

      // Fallback to demo user if no pegawai found or error occurred
      if (!inspectorId) {
        inspectorId = await this.getDemoPetugasId()
      }
    }

    // Calculate triwulan correctly (1-4)
    const tanggal = new Date(dto.tanggal)
    const bulan = tanggal.getMonth() + 1 // getMonth() returns 0-11, so add 1
    const triwulan = Math.ceil(bulan / 3) // This gives 1, 2, 3, or 4

    // Map frontend DTO to database columns
    const dbData = {
      tanggal: dto.tanggal,
      triwulan: dto.triwulan || triwulan,
      tahun: dto.tahun || tanggal.getFullYear(),
      unit_id: dto.unit_id,
      wilayah_id: dto.wilayah_id,
      inspector_id: inspectorId,
      area_inspeksi: dto.area_inspeksi,
      checklist: dto.checklist_items || dto.fokus_inspeksi || [],
      jumlah_temuan: (dto.temuan_critical || 0) + (dto.temuan_major || 0) + (dto.temuan_minor || 0),
      temuan_critical: dto.temuan_critical || 0,
      temuan_major: dto.temuan_major || 0,
      temuan_minor: dto.temuan_minor || 0,
      rekomendasi: dto.rekomendasi || dto.tindakan_korektif,
      status: dto.status || 'draft',
      created_by: inspectorId
    }

    const { data, error } = await supabase
      .from(this.tableName)
      .insert(dbData)
      .select()
      .single()

    if (error) throw error

    // Load relations separately
    let unitData = undefined
    let inspectorData = undefined

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

    if (data.inspector_id) {
      const { data: inspector } = await supabase
        .from('pegawai')
        .select('id, nama_lengkap, nip')
        .eq('id', data.inspector_id)
        .single()

      if (inspector) {
        inspectorData = {
          id: inspector.id,
          nama: inspector.nama_lengkap,
          nip: inspector.nip
        }
      }
    }

    return {
      ...data,
      nomor_inspeksi: `SI-${data.id?.slice(-8) || 'UNKNOWN'}`,
      waktu_mulai: '08:00:00',
      waktu_selesai: '17:00:00',
      jenis_inspeksi: 'silent',
      fokus_inspeksi: data.checklist || [],
      jumlah_temuan: (data.temuan_critical || 0) + (data.temuan_major || 0) + (data.temuan_minor || 0),
      kategori_bahaya: 'General',
      foto_kondisi_unsafe: data.foto_kondisi_unsafe || [],
      foto_perilaku_unsafe: data.foto_perilaku_unsafe || [],
      skor_kepatuhan: 0,
      tingkat_risiko: 'Rendah',
      kondisi_housekeeping: 'Baik',
      penggunaan_apd: 'Baik',
      tindakan_korektif: data.rekomendasi || '',
      status_verifikasi: data.status === 'approved' ? 'verified' : 'pending',
      verified_by: data.approved_by,
      created_by: data.approved_by,
      unit: unitData,
      inspector: inspectorData
    }
  }

  async update(id: string, dto: UpdateSilentInspectionDto): Promise<SilentInspection> {
    // Calculate triwulan correctly (1-4)
    const tanggal = dto.tanggal ? new Date(dto.tanggal) : new Date()
    const bulan = tanggal.getMonth() + 1 // getMonth() returns 0-11, so add 1
    const triwulan = Math.ceil(bulan / 3) // This gives 1, 2, 3, or 4

    // Map frontend DTO to database columns (only include defined fields)
    const dbData: any = {}

    if (dto.tanggal !== undefined) {
      dbData.tanggal = dto.tanggal
      // Recalculate triwulan and tahun when tanggal changes
      const tanggal = new Date(dto.tanggal)
      dbData.triwulan = Math.ceil((tanggal.getMonth() + 1) / 3)
      dbData.tahun = tanggal.getFullYear()
    }

    if (dto.unit_id !== undefined) dbData.unit_id = dto.unit_id
    if (dto.wilayah_id !== undefined) dbData.wilayah_id = dto.wilayah_id
    if (dto.area_inspeksi !== undefined) dbData.area_inspeksi = dto.area_inspeksi
    if (dto.checklist_items !== undefined || dto.fokus_inspeksi !== undefined) {
      dbData.checklist = dto.checklist_items || dto.fokus_inspeksi || []
    }
    if (dto.jumlah_temuan !== undefined) dbData.jumlah_temuan = dto.jumlah_temuan
    if (dto.temuan_critical !== undefined) dbData.temuan_critical = dto.temuan_critical
    if (dto.temuan_major !== undefined) dbData.temuan_major = dto.temuan_major
    if (dto.temuan_minor !== undefined) dbData.temuan_minor = dto.temuan_minor
    if (dto.rekomendasi !== undefined || dto.tindakan_korektif !== undefined) {
      dbData.rekomendasi = dto.rekomendasi || dto.tindakan_korektif
    }
    if (dto.foto_kondisi_unsafe !== undefined) dbData.foto_kondisi_unsafe = dto.foto_kondisi_unsafe
    if (dto.foto_perilaku_unsafe !== undefined) dbData.foto_perilaku_unsafe = dto.foto_perilaku_unsafe
    if (dto.status !== undefined) dbData.status = dto.status

    const { data, error } = await supabase
      .from(this.tableName)
      .update(dbData)
      .eq('id', id)
      .select()
      .single()

    if (error) throw error

    // Load relations separately
    let unitData = undefined
    let inspectorData = undefined

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

    if (data.inspector_id) {
      const { data: inspector } = await supabase
        .from('pegawai')
        .select('id, nama_lengkap, nip')
        .eq('id', data.inspector_id)
        .single()

      if (inspector) {
        inspectorData = {
          id: inspector.id,
          nama: inspector.nama_lengkap,
          nip: inspector.nip
        }
      }
    }

    return {
      ...data,
      nomor_inspeksi: `SI-${data.id?.slice(-8) || 'UNKNOWN'}`,
      waktu_mulai: '08:00:00',
      waktu_selesai: '17:00:00',
      jenis_inspeksi: 'silent',
      fokus_inspeksi: data.checklist || [],
      jumlah_temuan: (data.temuan_critical || 0) + (data.temuan_major || 0) + (data.temuan_minor || 0),
      kategori_bahaya: 'General',
      foto_kondisi_unsafe: data.foto_kondisi_unsafe || [],
      foto_perilaku_unsafe: data.foto_perilaku_unsafe || [],
      skor_kepatuhan: 0,
      tingkat_risiko: 'Rendah',
      kondisi_housekeeping: 'Baik',
      penggunaan_apd: 'Baik',
      tindakan_korektif: data.rekomendasi || '',
      status_verifikasi: data.status === 'approved' ? 'verified' : 'pending',
      verified_by: data.approved_by,
      created_by: data.approved_by,
      unit: unitData,
      inspector: inspectorData
    }
  }

  async delete(id: string): Promise<void> {
    // Get the inspection to delete associated photos
    const inspection = await this.getById(id)
    if (inspection) {
      // Delete photos from storage
      const allPhotos = [
        ...(inspection.foto_inspeksi || [])
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

  // Helper method to get demo petugas ID
  private async getDemoPetugasId(): Promise<string> {
    try {
      // First, try to find existing demo inspector
      const { data: existingInspector, error: findError } = await supabase
        .from('pegawai')
        .select('id')
        .eq('nip', 'DEMO001')
        .single()

      if (existingInspector && !findError) {
        return existingInspector.id
      }

      // If not found, create demo inspector
      console.log('Creating demo inspector...')
      const { data: newInspector, error: createError } = await supabase
        .from('pegawai')
        .insert({
          nama_lengkap: 'Safety Inspector Demo',
          nip: 'DEMO001',
          email: 'demo@safety.local',
          jabatan: 'Safety Inspector',
          role: 'user',
          status: 'aktif'
        })
        .select('id')
        .single()

      if (createError) {
        console.error('Failed to create demo inspector:', createError)
        // Try to use any existing pegawai as fallback
        const { data: fallbackInspector } = await supabase
          .from('pegawai')
          .select('id')
          .limit(1)
          .single()

        if (fallbackInspector) {
          console.warn('Using fallback inspector:', fallbackInspector.id)
          return fallbackInspector.id
        }

        throw new Error('Unable to create or find any inspector')
      }

      console.log('Demo inspector created:', newInspector?.id)
      return newInspector?.id || ''
    } catch (error) {
      console.error('Error getting demo inspector ID:', error)
      throw new Error('Unable to get demo inspector ID')
    }
  }
}

export const silentInspectionService = new SilentInspectionService()
