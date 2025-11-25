import { supabase } from '../api/supabase'

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

export interface SafetyInduction {
  id?: string
  nomor_induction: string
  
  // Data Peserta
  nama_peserta: string
  nik?: string
  no_identitas?: string
  perusahaan: string
  jabatan?: string
  departemen?: string
  no_telepon?: string
  email?: string
  foto_peserta?: string
  
  // Jenis Peserta
  jenis_peserta: 'karyawan_baru' | 'karyawan_pindah' | 'kontraktor' | 'vendor' | 'tamu' | 'mahasiswa_pkl' | 'tamu_vip'
  kategori_pekerjaan?: 'office' | 'produksi' | 'maintenance' | 'operator' | 'supervisor' | 'manager' | 'teknisi' | 'driver' | 'security' | 'cleaning'
  
  // Waktu & Lokasi
  tanggal_induction: string
  waktu_mulai: string
  waktu_selesai?: string
  durasi_menit?: number
  unit_id?: string
  lokasi_induction: string
  ruangan?: string
  
  // Instruktur
  instruktur_utama: string
  instruktur_pendamping?: string[]
  pic_hse?: string
  
  // Materi Checklist
  materi_kebijakan_k3?: boolean
  materi_prosedur_emergency?: boolean
  materi_apd_wajib?: boolean
  materi_rambu_k3?: boolean
  materi_identifikasi_bahaya?: boolean
  materi_pelaporan_insiden?: boolean
  materi_permit_to_work?: boolean
  materi_housekeeping?: boolean
  materi_chemical_safety?: boolean
  materi_working_at_height?: boolean
  materi_confined_space?: boolean
  materi_loto?: boolean
  materi_fire_safety?: boolean
  materi_first_aid?: boolean
  materi_ergonomi?: boolean
  
  // Materi Tambahan
  materi_tambahan?: Array<{
    judul: string
    durasi_menit: number
    disampaikan: boolean
  }>
  
  // Site Tour
  site_tour_dilakukan?: boolean
  area_dikunjungi?: string[]
  durasi_tour_menit?: number
  pemandu_tour?: string
  
  // APD
  apd_diberikan?: Array<{
    jenis_apd: string
    ukuran: string
    jumlah: number
    nomor_aset: string
    tanggal_serah: string
  }>
  kartu_id_diberikan?: boolean
  nomor_kartu_id?: string
  akses_area?: string[]
  
  // Assessment
  ujian_dilakukan?: boolean
  jenis_ujian?: 'tertulis' | 'lisan' | 'praktek' | 'online' | 'campuran'
  jumlah_soal?: number
  skor_ujian?: number
  passing_grade?: number
  status_ujian?: 'lulus' | 'tidak_lulus' | 'belum_ujian' | 'remedial'
  tanggal_ujian?: string
  
  // Sertifikat
  sertifikat_diterbitkan?: boolean
  nomor_sertifikat?: string
  tanggal_terbit_sertifikat?: string
  masa_berlaku_bulan?: number
  tanggal_expired?: string
  file_sertifikat?: string
  
  // Re-Induction
  perlu_reinduction?: boolean
  tanggal_reinduction_scheduled?: string
  alasan_reinduction?: string
  
  // Dokumentasi
  foto_kegiatan?: string[]
  video_induction?: string
  materi_presentasi?: string[]
  dokumen_pendukung?: string[]
  
  // Signature
  waktu_hadir?: string
  tanda_tangan_peserta?: string
  tanda_tangan_instruktur?: string
  tanda_tangan_pic_hse?: string
  
  // Feedback
  feedback_peserta?: string
  rating_materi?: number
  rating_instruktur?: number
  saran_peserta?: string
  
  // Evaluasi
  evaluasi_pemahaman?: 'sangat_baik' | 'baik' | 'cukup' | 'kurang'
  evaluasi_keaktifan?: 'sangat_aktif' | 'aktif' | 'cukup' | 'pasif'
  catatan_instruktur?: string
  rekomendasi_khusus?: string
  
  // Follow-up
  follow_up_diperlukan?: boolean
  jenis_follow_up?: string[]
  pic_follow_up?: string
  tanggal_follow_up?: string
  status_follow_up?: 'pending' | 'scheduled' | 'completed' | 'cancelled'
  
  // Status
  status: 'scheduled' | 'ongoing' | 'completed' | 'passed' | 'failed' | 'no_show' | 'cancelled' | 'rescheduled'
  approved_by?: string
  approved_at?: string
  approval_notes?: string
  
  // Metadata
  created_by?: string
  created_at?: string
  updated_at?: string
  
  // Relations
  unit?: {
    id: string
    nama: string
    kode: string
  }
}

class SafetyInductionService {
  private tableName = 'safety_induction'

  // Generate nomor induction otomatis: IND-YYYY-MM-XXX
  async generateNomorInduction(): Promise<string> {
    const now = new Date()
    const year = now.getFullYear()
    const month = String(now.getMonth() + 1).padStart(2, '0')
    const prefix = `IND-${year}-${month}`

    const { data, error } = await supabase
      .from(this.tableName)
      .select('nomor_induction')
      .ilike('nomor_induction', `${prefix}%`)
      .order('nomor_induction', { ascending: false })
      .limit(1)

    if (error) throw error

    if (data && data.length > 0 && data[0]?.nomor_induction) {
      const lastPart = data[0].nomor_induction.split('-').pop()
      const lastNumber = parseInt(lastPart || '0')
      const newNumber = String(lastNumber + 1).padStart(3, '0')
      return `${prefix}-${newNumber}`
    }

    return `${prefix}-001`
  }

  // Backward compatible - load all records
  async getAll(filters?: {
    search?: string
    unit_id?: string
    jenis_peserta?: string
    status?: string
    tanggal_dari?: string
    tanggal_sampai?: string
    perusahaan?: string
    instruktur?: string
  }) {
    const result = await this.getPaginated(filters, { page: 1, pageSize: 10000 })
    return result.data
  }

  // Paginated version for performance
  async getPaginated(
    filters?: {
      search?: string
      unit_id?: string
      jenis_peserta?: string
      status?: string
      tanggal_dari?: string
      tanggal_sampai?: string
      perusahaan?: string
      instruktur?: string
    },
    pagination: PaginationParams = { page: 1, pageSize: 20 }
  ): Promise<PaginatedResponse<SafetyInduction>> {
    // Query without JOIN first, then fetch unit separately
    let query = supabase
      .from(this.tableName)
      .select('*', { count: 'exact' })
      .order('tanggal_induction', { ascending: false })

    if (filters?.search) {
      query = query.or(`nama_peserta.ilike.%${filters.search}%,nomor_induction.ilike.%${filters.search}%,nik.ilike.%${filters.search}%`)
    }

    if (filters?.unit_id) {
      query = query.eq('unit_id', filters.unit_id)
    }

    if (filters?.jenis_peserta) {
      query = query.eq('jenis_peserta', filters.jenis_peserta)
    }

    if (filters?.status) {
      query = query.eq('status', filters.status)
    }

    if (filters?.perusahaan) {
      query = query.ilike('perusahaan', `%${filters.perusahaan}%`)
    }

    if (filters?.instruktur) {
      query = query.ilike('instruktur_utama', `%${filters.instruktur}%`)
    }

    if (filters?.tanggal_dari) {
      query = query.gte('tanggal_induction', filters.tanggal_dari)
    }

    if (filters?.tanggal_sampai) {
      query = query.lte('tanggal_induction', filters.tanggal_sampai)
    }

    // Apply pagination
    const from = (pagination.page - 1) * pagination.pageSize
    const to = from + pagination.pageSize - 1
    query = query.range(from, to)

    const { data, error, count } = await query

    if (error) throw error

    const totalCount = count || 0
    const totalPages = Math.ceil(totalCount / pagination.pageSize)

    // Fetch unit data separately if needed
    const dataWithUnits = await Promise.all(
      (data || []).map(async (induction) => {
        if (induction.unit_id) {
          const { data: unitData } = await supabase
            .from('units')
            .select('id, nama, kode')
            .eq('id', induction.unit_id)
            .single()
          
          return { ...induction, units: unitData }
        }
        return induction
      })
    )

    return {
      data: dataWithUnits as SafetyInduction[],
      count: totalCount,
      page: pagination.page,
      pageSize: pagination.pageSize,
      totalPages
    }
  }

  // Get by ID
  async getById(id: string) {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('*')
      .eq('id', id)
      .single()

    if (error) throw error
    
    // Fetch unit separately
    if (data.unit_id) {
      const { data: unitData } = await supabase
        .from('units')
        .select('id, nama, kode')
        .eq('id', data.unit_id)
        .single()
      
      return { ...data, units: unitData } as SafetyInduction
    }
    
    return data as SafetyInduction
  }

  // Normalize data before save (handle case-insensitive values)
  private normalizeData(induction: Partial<SafetyInduction>): Partial<SafetyInduction> {
    const normalized = { ...induction }
    
    // Normalize enum fields to lowercase
    if (normalized.jenis_peserta) {
      normalized.jenis_peserta = normalized.jenis_peserta.toLowerCase() as any
    }
    if (normalized.kategori_pekerjaan) {
      normalized.kategori_pekerjaan = normalized.kategori_pekerjaan.toLowerCase() as any
    }
    if (normalized.jenis_ujian) {
      normalized.jenis_ujian = normalized.jenis_ujian.toLowerCase() as any
    }
    if (normalized.status_ujian) {
      normalized.status_ujian = normalized.status_ujian.toLowerCase() as any
    }
    if (normalized.evaluasi_pemahaman) {
      normalized.evaluasi_pemahaman = normalized.evaluasi_pemahaman.toLowerCase() as any
    }
    if (normalized.evaluasi_keaktifan) {
      normalized.evaluasi_keaktifan = normalized.evaluasi_keaktifan.toLowerCase() as any
    }
    if (normalized.status_follow_up) {
      normalized.status_follow_up = normalized.status_follow_up.toLowerCase() as any
    }
    if (normalized.status) {
      normalized.status = normalized.status.toLowerCase() as any
    }
    
    return normalized
  }

  // Create new induction
  async create(induction: Partial<SafetyInduction>) {
    // Generate nomor if not provided
    if (!induction.nomor_induction) {
      induction.nomor_induction = await this.generateNomorInduction()
    }

    // Calculate expired date if certificate issued
    if (induction.sertifikat_diterbitkan && induction.tanggal_terbit_sertifikat && induction.masa_berlaku_bulan) {
      const terbitDate = new Date(induction.tanggal_terbit_sertifikat)
      const expiredDate = new Date(terbitDate)
      expiredDate.setMonth(expiredDate.getMonth() + induction.masa_berlaku_bulan)
      induction.tanggal_expired = expiredDate.toISOString().split('T')[0]
    }

    // Normalize data
    const normalizedInduction = this.normalizeData(induction)

    const { data, error } = await supabase
      .from(this.tableName)
      .insert(normalizedInduction)
      .select()
      .single()

    if (error) throw error
    return data
  }

  // Update induction
  async update(id: string, induction: Partial<SafetyInduction>) {
    // Recalculate expired date if changed
    if (induction.sertifikat_diterbitkan && induction.tanggal_terbit_sertifikat && induction.masa_berlaku_bulan) {
      const terbitDate = new Date(induction.tanggal_terbit_sertifikat)
      const expiredDate = new Date(terbitDate)
      expiredDate.setMonth(expiredDate.getMonth() + induction.masa_berlaku_bulan)
      induction.tanggal_expired = expiredDate.toISOString().split('T')[0]
    }

    // Normalize data
    const normalizedInduction = this.normalizeData(induction)

    const { data, error } = await supabase
      .from(this.tableName)
      .update(normalizedInduction)
      .eq('id', id)
      .select()
      .single()

    if (error) throw error
    return data
  }

  // Delete induction
  async delete(id: string) {
    const { error } = await supabase
      .from(this.tableName)
      .delete()
      .eq('id', id)

    if (error) throw error
  }

  // Get statistics
  async getStatistics() {
    const { data: all, error: allError } = await supabase
      .from(this.tableName)
      .select('id, status, skor_ujian, rating_materi, rating_instruktur, tanggal_induction, tanggal_expired, jenis_peserta')

    if (allError) throw allError

    const now = new Date()
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1)
    const endOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0)

    const thisMonth = all?.filter((item: any) => {
      const date = new Date(item.tanggal_induction)
      return date >= startOfMonth && date <= endOfMonth
    }) || []

    const passed = all?.filter((item: any) => item.status === 'passed') || []
    const failed = all?.filter((item: any) => item.status === 'failed') || []
    const scheduled = all?.filter((item: any) => item.status === 'scheduled') || []

    // Certificates expiring in next 30 days
    const next30Days = new Date()
    next30Days.setDate(next30Days.getDate() + 30)
    const expiringSoon = all?.filter((item: any) => {
      if (!item.tanggal_expired) return false
      const expDate = new Date(item.tanggal_expired)
      return expDate > now && expDate <= next30Days
    }) || []

    // Average scores
    const scoresData = all?.filter((item: any) => item.skor_ujian !== null && item.skor_ujian !== undefined) || []
    const avgScore = scoresData.length > 0
      ? scoresData.reduce((sum: number, item: any) => sum + (item.skor_ujian || 0), 0) / scoresData.length
      : 0

    // Average ratings
    const ratingsMateri = all?.filter((item: any) => item.rating_materi) || []
    const avgRatingMateri = ratingsMateri.length > 0
      ? ratingsMateri.reduce((sum: number, item: any) => sum + (item.rating_materi || 0), 0) / ratingsMateri.length
      : 0

    const ratingsInstruktur = all?.filter((item: any) => item.rating_instruktur) || []
    const avgRatingInstruktur = ratingsInstruktur.length > 0
      ? ratingsInstruktur.reduce((sum: number, item: any) => sum + (item.rating_instruktur || 0), 0) / ratingsInstruktur.length
      : 0

    // By type
    const byType = all?.reduce((acc: Record<string, number>, item: any) => {
      acc[item.jenis_peserta] = (acc[item.jenis_peserta] || 0) + 1
      return acc
    }, {}) || {}

    return {
      total: all?.length || 0,
      bulan_ini: thisMonth.length,
      passed: passed.length,
      failed: failed.length,
      scheduled: scheduled.length,
      expiring_soon: expiringSoon.length,
      avg_skor: Math.round(avgScore),
      avg_rating_materi: Math.round(avgRatingMateri * 10) / 10,
      avg_rating_instruktur: Math.round(avgRatingInstruktur * 10) / 10,
      by_type: byType
    }
  }

  // Get expiring certificates (next 30 days)
  async getExpiringCertificates() {
    const now = new Date()
    const next30Days = new Date()
    next30Days.setDate(next30Days.getDate() + 30)

    const { data, error } = await supabase
      .from(this.tableName)
      .select('*')
      .eq('sertifikat_diterbitkan', true)
      .gte('tanggal_expired', now.toISOString().split('T')[0])
      .lte('tanggal_expired', next30Days.toISOString().split('T')[0])
      .order('tanggal_expired', { ascending: true })
      .limit(20)

    if (error) throw error
    return data as SafetyInduction[]
  }

  // Get upcoming scheduled inductions
  async getUpcomingInductions() {
    const today = new Date().toISOString().split('T')[0]

    const { data, error } = await supabase
      .from(this.tableName)
      .select('*')
      .eq('status', 'scheduled')
      .gte('tanggal_induction', today)
      .order('tanggal_induction', { ascending: true })
      .limit(20)

    if (error) throw error
    return data as SafetyInduction[]
  }

  // Upload file helper
  async uploadFile(file: File, folder: 'certificates' | 'photos' | 'documents' | 'signatures'): Promise<string> {
    const fileExt = file.name.split('.').pop()
    const fileName = `${Date.now()}-${Math.random().toString(36).substring(7)}.${fileExt}`
    const filePath = `induction/${folder}/${fileName}`

    const { error: uploadError } = await supabase.storage
      .from('hsse')
      .upload(filePath, file)

    if (uploadError) throw uploadError

    const { data } = supabase.storage
      .from('hsse')
      .getPublicUrl(filePath)

    return data.publicUrl
  }

  // Get participants by company
  async getByCompany(perusahaan: string) {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('*')
      .ilike('perusahaan', `%${perusahaan}%`)
      .order('tanggal_induction', { ascending: false })

    if (error) throw error
    return data as SafetyInduction[]
  }
}

export const safetyInductionService = new SafetyInductionService()
