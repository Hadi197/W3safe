import { supabase } from './api/supabase'

export interface SafetyDrill {
  id?: string
  nomor_drill: string
  
  // Jenis & Kategori
  jenis_drill: 'fire_drill' | 'earthquake_drill' | 'evacuation_drill' | 'chemical_spill' | 
                'medical_emergency' | 'bomb_threat' | 'gas_leak' | 'confined_space' | 
                'height_rescue' | 'water_rescue' | 'severe_weather' | 'security_breach' | 
                'power_outage' | 'active_shooter' | 'full_scale'
  kategori_drill: 'planned' | 'unannounced' | 'tabletop' | 'functional' | 'full_scale'
  tingkat_drill: 'plant_wide' | 'area_specific' | 'department' | 'shift_based' | 'team_based'
  
  // Informasi Dasar
  judul_drill: string
  deskripsi?: string
  
  // Unit & Lokasi
  unit_id?: string
  unit_kerja: string
  area_lokasi: string
  ruang_khusus?: string
  titik_kumpul: string
  area_terdampak?: string[]
  units?: { id: string; nama: string; kode: string }
  
  // Jadwal
  tanggal_drill: string
  waktu_mulai: string
  waktu_selesai?: string
  durasi_menit?: number
  shift?: string
  
  // Perencanaan
  tanggal_perencanaan?: string
  pic_perencanaan?: string
  tujuan_drill: string
  sasaran_drill?: string[]
  skenario: string
  kriteria_keberhasilan?: string[]
  
  // Tim Drill
  drill_commander: string
  jabatan_commander?: string
  safety_officer: string
  jabatan_safety?: string
  observer?: string[]
  controller?: string[]
  evaluator?: string[]
  
  // Tim Emergency Response
  ert_leader?: string
  ert_members?: string[]
  first_aider?: string[]
  fire_team?: string[]
  evacuation_team?: string[]
  communication_team?: string[]
  
  // Partisipan
  jumlah_peserta: number
  jumlah_karyawan?: number
  jumlah_kontraktor?: number
  jumlah_observer?: number
  daftar_peserta?: any
  
  // Pre-Drill Briefing
  briefing_dilakukan?: boolean
  tanggal_briefing?: string
  waktu_briefing?: string
  peserta_briefing?: string[]
  materi_briefing?: string
  
  // Peralatan
  peralatan_digunakan?: any
  apar_digunakan?: number
  hydrant_digunakan?: number
  stretcher_digunakan?: number
  ppe_digunakan?: string[]
  alat_komunikasi?: string[]
  
  // Alarm & Komunikasi
  alarm_activated?: boolean
  waktu_alarm?: string
  jenis_alarm?: string
  pa_system_used?: boolean
  radio_communication?: boolean
  emergency_contact_called?: string[]
  
  // Pelaksanaan
  drill_dimulai?: boolean
  waktu_aktual_mulai?: string
  waktu_deteksi?: string
  waktu_alarm_berbunyi?: string
  waktu_mulai_evakuasi?: string
  waktu_selesai_evakuasi?: string
  waktu_all_clear?: string
  total_waktu_evakuasi?: number
  
  // Response Time
  detection_time?: number
  alarm_to_evacuation?: number
  evacuation_duration?: number
  response_team_arrival?: number
  
  // Observasi
  observasi_positif?: string[]
  observasi_negatif?: string[]
  perilaku_peserta?: string
  kepatuhan_prosedur?: string
  
  // Evaluasi Kinerja
  evakuasi_teratur?: boolean
  rute_evakuasi_jelas?: boolean
  pintu_darurat_berfungsi?: boolean
  lampu_darurat_berfungsi?: boolean
  alat_pemadam_siap?: boolean
  p3k_tersedia?: boolean
  komunikasi_efektif?: boolean
  koordinasi_tim_baik?: boolean
  
  // Penilaian
  penilaian_kesiapan?: number
  penilaian_response?: number
  penilaian_koordinasi?: number
  penilaian_komunikasi?: number
  penilaian_evakuasi?: number
  penilaian_peralatan?: number
  
  // Scoring
  skor_total?: number
  skor_maksimal?: number
  persentase_keberhasilan?: number
  grade?: 'A' | 'B' | 'C' | 'D' | 'E'
  
  // Target vs Aktual
  target_waktu_evakuasi?: number
  selisih_waktu?: number
  target_tercapai?: boolean
  
  // Temuan
  jumlah_temuan?: number
  temuan_kritis?: number
  temuan_mayor?: number
  temuan_minor?: number
  detail_temuan?: any
  
  // Korban Simulasi
  ada_korban_simulasi?: boolean
  jumlah_korban_simulasi?: number
  detail_korban?: any
  
  // Near Miss & Incident
  near_miss_terjadi?: boolean
  detail_near_miss?: string
  actual_incident?: boolean
  detail_incident?: string
  
  // Improvement
  area_perbaikan?: string[]
  rekomendasi?: string[]
  best_practice?: string[]
  lesson_learned?: string[]
  
  // Action Items
  action_items?: any
  corrective_actions?: any
  
  // Debriefing
  debriefing_dilakukan?: boolean
  tanggal_debriefing?: string
  waktu_debriefing?: string
  peserta_debriefing?: string[]
  hasil_debriefing?: string
  
  // Dokumentasi
  foto_drill?: string[]
  video_drill?: string[]
  dokumen_pendukung?: string[]
  laporan_drill?: string

  
  // External
  pihak_eksternal_terlibat?: boolean
  nama_pihak_eksternal?: string[]
  waktu_kedatangan_eksternal?: string
  peran_pihak_eksternal?: string
  
  // Environment
  kondisi_cuaca?: string
  suhu_celsius?: number
  kondisi_lingkungan?: string
  faktor_pengganggu?: string
  
  // Compliance
  regulasi_acuan?: string[]
  compliance_status?: 'compliant' | 'partially_compliant' | 'non_compliant' | 'not_applicable'
  gap_analysis?: string
  
  // Status
  status: 'planned' | 'ongoing' | 'completed' | 'cancelled' | 'postponed'
  alasan_cancel?: string
  alasan_postpone?: string
  tanggal_reschedule?: string
  
  // Approval
  submitted_by?: string
  submitted_at?: string
  reviewed_by?: string
  reviewed_at?: string
  approved_by?: string
  approved_at?: string
  approval_status?: 'draft' | 'submitted' | 'reviewed' | 'approved' | 'rejected'
  approval_notes?: string
  
  // Sertifikat
  sertifikat_diberikan?: boolean
  nomor_sertifikat?: string
  tanggal_sertifikat?: string
  masa_berlaku_bulan?: number
  tanggal_kadaluarsa?: string
  
  // Next Drill
  next_drill_scheduled?: boolean
  tanggal_next_drill?: string
  catatan_next_drill?: string
  
  // Metadata
  created_by: string
  created_at?: string
  updated_by?: string
  updated_at?: string
}

export interface DrillFilters {
  search?: string
  jenis_drill?: string
  kategori_drill?: string
  status?: string
  unit_kerja?: string
  drill_commander?: string
  grade?: string
  tanggal_dari?: string
  tanggal_sampai?: string
}

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

class SafetyDrillService {
  private tableName = 'safety_drill'

  // Generate nomor drill: DRL-YYYY-MM-XXX
  async generateNomorDrill(): Promise<string> {
    const now = new Date()
    const year = now.getFullYear()
    const month = String(now.getMonth() + 1).padStart(2, '0')
    const prefix = `DRL-${year}-${month}`

    const { data, error } = await supabase
      .from(this.tableName)
      .select('nomor_drill')
      .like('nomor_drill', `${prefix}%`)
      .order('nomor_drill', { ascending: false })
      .limit(1)

    if (error) {
      console.error('Error generating nomor drill:', error)
      return `${prefix}-001`
    }

    if (!data || data.length === 0) {
      return `${prefix}-001`
    }

    const lastNomor = data[0]?.nomor_drill
    if (!lastNomor) {
      return `${prefix}-001`
    }
    
    const lastSequence = parseInt(lastNomor.split('-')[3] || '0')
    const newSequence = String(lastSequence + 1).padStart(3, '0')

    return `${prefix}-${newSequence}`
  }

  // Get all drills with filters (backward compatible - no pagination)
  async getAll(filters?: DrillFilters): Promise<SafetyDrill[]> {
    const result = await this.getPaginated(filters, { page: 1, pageSize: 10000 })
    return result.data
  }

  // Get paginated drills with filters (NEW - Performance optimized)
  async getPaginated(
    filters?: DrillFilters,
    pagination: PaginationParams = { page: 1, pageSize: 20 }
  ): Promise<PaginatedResponse<SafetyDrill>> {
    // Build query with count
    let query = supabase
      .from(this.tableName)
      .select('*', { count: 'exact' })
      .order('tanggal_drill', { ascending: false })

    if (filters?.search) {
      query = query.or(`nomor_drill.ilike.%${filters.search}%,judul_drill.ilike.%${filters.search}%,drill_commander.ilike.%${filters.search}%`)
    }

    if (filters?.jenis_drill) {
      query = query.eq('jenis_drill', filters.jenis_drill)
    }

    if (filters?.kategori_drill) {
      query = query.eq('kategori_drill', filters.kategori_drill)
    }

    if (filters?.status) {
      query = query.eq('status', filters.status)
    }

    if (filters?.unit_kerja) {
      query = query.eq('unit_kerja', filters.unit_kerja)
    }

    if (filters?.drill_commander) {
      query = query.eq('drill_commander', filters.drill_commander)
    }

    if (filters?.grade) {
      query = query.eq('grade', filters.grade)
    }

    if (filters?.tanggal_dari) {
      query = query.gte('tanggal_drill', filters.tanggal_dari)
    }

    if (filters?.tanggal_sampai) {
      query = query.lte('tanggal_drill', filters.tanggal_sampai)
    }

    // Apply pagination
    const from = (pagination.page - 1) * pagination.pageSize
    const to = from + pagination.pageSize - 1
    query = query.range(from, to)

    const { data, error, count } = await query

    if (error) {
      console.error('Error fetching drills:', error)
      throw error
    }

    // Fetch unit data manually for each drill
    const dataWithUnits = await Promise.all(
      (data || []).map(async (drill) => {
        if (drill.unit_id) {
          const { data: unitData } = await supabase
            .from('units')
            .select('id, nama, kode')
            .eq('id', drill.unit_id)
            .single()
          return { ...drill, units: unitData }
        }
        return drill
      })
    )

    const totalCount = count || 0
    const totalPages = Math.ceil(totalCount / pagination.pageSize)

    return {
      data: dataWithUnits,
      count: totalCount,
      page: pagination.page,
      pageSize: pagination.pageSize,
      totalPages
    }
  }

  // Get by ID
  async getById(id: string): Promise<SafetyDrill | null> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('*')
      .eq('id', id)
      .single()

    if (error) {
      console.error('Error fetching drill:', error)
      throw error
    }

    // Fetch unit data manually if unit_id exists
    if (data && data.unit_id) {
      const { data: unitData } = await supabase
        .from('units')
        .select('id, nama, kode')
        .eq('id', data.unit_id)
        .single()
      return { ...data, units: unitData }
    }

    return data
  }

  // Normalize data before save (handle case-insensitive values)
  private normalizeData(drill: Partial<SafetyDrill>): Partial<SafetyDrill> {
    const normalized = { ...drill }
    
    // Normalize enum fields to lowercase
    if (normalized.jenis_drill) {
      normalized.jenis_drill = normalized.jenis_drill.toLowerCase() as any
    }
    if (normalized.kategori_drill) {
      normalized.kategori_drill = normalized.kategori_drill.toLowerCase() as any
    }
    if (normalized.tingkat_drill) {
      normalized.tingkat_drill = normalized.tingkat_drill.toLowerCase() as any
    }
    if (normalized.status) {
      normalized.status = normalized.status.toLowerCase() as any
    }
    if (normalized.compliance_status) {
      normalized.compliance_status = normalized.compliance_status.toLowerCase() as any
    }
    
    return normalized
  }

  // Create new drill
  async create(drill: SafetyDrill): Promise<SafetyDrill> {
    console.log('=== CREATE DRILL SERVICE ===')
    console.log('Drill data before processing:', drill)
    
    if (!drill.nomor_drill) {
      drill.nomor_drill = await this.generateNomorDrill()
    }

    // Remove units field if it exists (from JOIN query)
    const { units, ...drillWithoutUnits } = drill as any

    // Normalize data
    const normalizedDrill = this.normalizeData(drillWithoutUnits)

    console.log('Normalized drill data:', normalizedDrill)

    const { data, error } = await supabase
      .from(this.tableName)
      .insert(normalizedDrill)
      .select()
      .single()

    console.log('Supabase response - data:', data)
    console.log('Supabase response - error:', error)

    if (error) {
      console.error('Error creating drill:', error)
      throw error
    }

    console.log('Create successful, returning data')
    return data
  }

  // Update drill
  async update(id: string, drill: Partial<SafetyDrill>): Promise<SafetyDrill> {
    console.log('=== UPDATE DRILL SERVICE ===')
    console.log('Drill ID:', id)
    console.log('Drill data before normalization:', drill)
    
    // Remove units field if it exists (from JOIN query)
    const { units, ...drillWithoutUnits } = drill as any
    
    // Normalize data
    const normalizedDrill = this.normalizeData(drillWithoutUnits)
    console.log('Normalized drill data:', normalizedDrill)
    
    const { data, error } = await supabase
      .from(this.tableName)
      .update(normalizedDrill)
      .eq('id', id)
      .select()
      .single()

    console.log('Supabase response - data:', data)
    console.log('Supabase response - error:', error)

    if (error) {
      console.error('Error updating drill:', error)
      throw error
    }

    console.log('Update successful, returning data')
    return data
  }

  // Delete drill
  async delete(id: string): Promise<void> {
    const { error } = await supabase
      .from(this.tableName)
      .delete()
      .eq('id', id)

    if (error) {
      console.error('Error deleting drill:', error)
      throw error
    }
  }

  // Get statistics
  async getStatistics(): Promise<any> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('*')

    if (error) {
      console.error('Error fetching statistics:', error)
      return {
        total: 0,
        bulan_ini: 0,
        completed: 0,
        planned: 0,
        ongoing: 0,
        avg_score: 0,
        grade_a: 0,
        grade_b: 0,
        by_jenis: {},
        by_kategori: {}
      }
    }

    const now = new Date()
    const currentMonth = now.getMonth()
    const currentYear = now.getFullYear()

    const bulan_ini = (data || []).filter((d: SafetyDrill) => {
      const drillDate = new Date(d.tanggal_drill)
      return drillDate.getMonth() === currentMonth && drillDate.getFullYear() === currentYear
    }).length

    const completed = (data || []).filter((d: SafetyDrill) => d.status === 'completed').length
    const planned = (data || []).filter((d: SafetyDrill) => d.status === 'planned').length
    const ongoing = (data || []).filter((d: SafetyDrill) => d.status === 'ongoing').length

    const scoresData = (data || []).filter((d: SafetyDrill) => d.persentase_keberhasilan !== null && d.persentase_keberhasilan !== undefined)
    const avg_score = scoresData.length > 0
      ? scoresData.reduce((sum: number, d: SafetyDrill) => sum + (d.persentase_keberhasilan || 0), 0) / scoresData.length
      : 0

    const grade_a = (data || []).filter((d: SafetyDrill) => d.grade === 'A').length
    const grade_b = (data || []).filter((d: SafetyDrill) => d.grade === 'B').length

    const by_jenis = (data || []).reduce((acc: any, d: SafetyDrill) => {
      acc[d.jenis_drill] = (acc[d.jenis_drill] || 0) + 1
      return acc
    }, {})

    const by_kategori = (data || []).reduce((acc: any, d: SafetyDrill) => {
      acc[d.kategori_drill] = (acc[d.kategori_drill] || 0) + 1
      return acc
    }, {})

    return {
      total: data?.length || 0,
      bulan_ini,
      completed,
      planned,
      ongoing,
      avg_score: Math.round(avg_score * 100) / 100,
      grade_a,
      grade_b,
      by_jenis,
      by_kategori
    }
  }

  // Get upcoming drills (next 30 days)
  async getUpcomingDrills(): Promise<SafetyDrill[]> {
    const today = new Date().toISOString().split('T')[0]
    const futureDate = new Date()
    futureDate.setDate(futureDate.getDate() + 30)
    const future = futureDate.toISOString().split('T')[0]

    const { data, error } = await supabase
      .from(this.tableName)
      .select('*')
      .in('status', ['planned', 'ongoing'])
      .gte('tanggal_drill', today)
      .lte('tanggal_drill', future)
      .order('tanggal_drill', { ascending: true })

    if (error) {
      console.error('Error fetching upcoming drills:', error)
      throw error
    }

    return data || []
  }

  // Get drills with poor performance (grade D or E)
  async getPoorPerformanceDrills(): Promise<SafetyDrill[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('*')
      .in('grade', ['D', 'E'])
      .eq('status', 'completed')
      .order('tanggal_drill', { ascending: false })
      .limit(10)

    if (error) {
      console.error('Error fetching poor performance drills:', error)
      throw error
    }

    return data || []
  }

  // Get drills with critical findings
  async getCriticalFindingsDrills(): Promise<SafetyDrill[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('*')
      .gt('temuan_kritis', 0)
      .eq('status', 'completed')
      .order('temuan_kritis', { ascending: false })
      .limit(10)

    if (error) {
      console.error('Error fetching critical findings drills:', error)
      throw error
    }

    return data || []
  }

  // Get drills needing next drill scheduling
  async getNeedNextDrillScheduling(): Promise<SafetyDrill[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('*')
      .eq('status', 'completed')
      .eq('next_drill_scheduled', false)
      .order('tanggal_drill', { ascending: false })

    if (error) {
      console.error('Error fetching drills needing scheduling:', error)
      throw error
    }

    return data || []
  }

  // Get drill performance trend (last 12 months)
  async getPerformanceTrend(): Promise<any[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('tanggal_drill, persentase_keberhasilan, grade')
      .eq('status', 'completed')
      .not('persentase_keberhasilan', 'is', null)
      .order('tanggal_drill', { ascending: true })

    if (error) {
      console.error('Error fetching performance trend:', error)
      return []
    }

    return data || []
  }

  // Get data for Rekap Implementasi K3L table
  async getRekapK3L(year: number = new Date().getFullYear()): Promise<any[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('tanggal_drill, waktu_mulai, tujuan_drill, drill_commander, jumlah_peserta, area_lokasi')
      .gte('tanggal_drill', `${year}-01-01`)
      .lte('tanggal_drill', `${year}-12-31`)
      .order('tanggal_drill', { ascending: false })

    if (error) {
      console.error('Error fetching Rekap K3L data:', error)
      throw error
    }

    // Transform data to match Rekap K3L format
    return (data || []).map((item, index) => ({
      no: index + 1,
      kegiatan: item.tujuan_drill,
      dokumentasi: 'Tidak Ada',
      hari_tanggal: item.tanggal_drill,
      jam: item.waktu_mulai,
      pimpinan: item.drill_commander,
      peserta: item.jumlah_peserta,
      tempat: item.area_lokasi,
      keterangan: '-'
    }))
  }

  // Upload file helper
  async uploadFile(file: File, folder: string = 'drill-docs'): Promise<string> {
    const fileName = `${Date.now()}-${file.name}`
    const filePath = `${folder}/${fileName}`

    const { data, error } = await supabase.storage
      .from('hsse')
      .upload(filePath, file)

    if (error) {
      console.error('Error uploading file:', error)
      throw error
    }

    const { data: urlData } = supabase.storage
      .from('hsse')
      .getPublicUrl(filePath)

    return urlData.publicUrl
  }
}

export const safetyDrillService = new SafetyDrillService()
