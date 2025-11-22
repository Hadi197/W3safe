import { supabase } from '../api/supabase'

export interface SafetyPatrol {
  id?: string
  nomor_patrol: string
  tanggal_patrol: string
  waktu_mulai: string
  waktu_selesai?: string
  shift?: 'pagi' | 'siang' | 'malam'
  unit_id?: string
  area_patrol: string
  lokasi_spesifik?: string
  ketua_patrol: string
  anggota_patrol?: string[]
  jumlah_anggota?: number
  jenis_patrol?: 'rutin' | 'terjadwal' | 'insidental' | 'khusus' | 'malam' | 'emergency'
  tujuan_patrol?: string
  fokus_patrol?: string[]
  cuaca?: 'cerah' | 'mendung' | 'hujan' | 'panas'
  suhu_area?: number
  kondisi_pencahayaan?: 'baik' | 'cukup' | 'kurang' | 'buruk'
  kondisi_ventilasi?: 'baik' | 'cukup' | 'kurang' | 'buruk'
  tingkat_kebisingan?: 'normal' | 'cukup_bising' | 'bising' | 'sangat_bising'
  jumlah_unsafe_condition?: number
  unsafe_condition?: any[]
  jumlah_unsafe_act?: number
  unsafe_act?: any[]
  pekerja_diamati?: number
  pekerja_patuh_apd?: number
  pekerja_tidak_patuh_apd?: number
  persentase_kepatuhan_apd?: number
  detail_apd?: any[]
  skor_housekeeping?: number
  kondisi_housekeeping?: 'sangat_baik' | 'baik' | 'cukup' | 'kurang' | 'buruk'
  area_kotor?: string[]
  area_rapi?: string[]
  jumlah_mesin_diperiksa?: number
  mesin_kondisi_baik?: number
  mesin_perlu_perbaikan?: number
  detail_mesin?: any[]
  rambu_k3_lengkap?: boolean
  rambu_k3_hilang?: string[]
  rambu_k3_rusak?: string[]
  label_b3_lengkap?: boolean
  jalur_evakuasi_bebas?: boolean
  pintu_darurat_berfungsi?: boolean
  apar_tersedia?: boolean
  apar_expire?: number
  emergency_light_berfungsi?: boolean
  good_practice?: string[]
  area_excellent?: string[]
  pekerja_teladan?: string[]
  total_temuan?: number
  temuan_kritikal?: number
  temuan_mayor?: number
  temuan_minor?: number
  rekomendasi?: string[]
  catatan_patrol?: string
  action_items?: any[]
  jumlah_action_item?: number
  action_selesai?: number
  action_progress?: number
  action_belum_mulai?: number
  stop_work_issued?: boolean
  stop_work_area?: string[]
  stop_work_alasan?: string
  foto_patrol?: string[]
  dokumen_pendukung?: string[]
  skor_keseluruhan?: number
  skor_apd?: number
  skor_kondisi_area?: number
  skor_peralatan?: number
  grade?: 'A' | 'B' | 'C' | 'D' | 'E'
  status?: 'draft' | 'submitted' | 'reviewed' | 'closed' | 'cancelled'
  tingkat_urgensi?: 'rendah' | 'normal' | 'tinggi' | 'kritis'
  perlu_follow_up?: boolean
  tanggal_follow_up?: string
  status_follow_up?: 'belum' | 'dijadwalkan' | 'selesai'
  reviewed_by?: string
  reviewed_at?: string
  review_notes?: string
  created_by?: string
  created_at?: string
  updated_at?: string
  unit?: any
}

export interface PatrolFilters {
  search?: string
  unit_id?: string
  jenis?: string
  status?: string
  shift?: string
  start_date?: string
  end_date?: string
}

export interface PatrolStats {
  total_patrol: number
  patrol_bulan_ini: number
  temuan_kritikal: number
  temuan_belum_selesai: number
  avg_skor: number
  patrol_by_status: { status: string; count: number }[]
  patrol_by_grade: { grade: string; count: number }[]
}

class SafetyPatrolService {
  async getAll(filters?: PatrolFilters): Promise<SafetyPatrol[]> {
    let query = supabase
      .from('safety_patrol')
      .select('*, unit:units(id, kode, nama)')
      .order('tanggal_patrol', { ascending: false })

    if (filters?.search) {
      query = query.or(`nomor_patrol.ilike.%${filters.search}%,area_patrol.ilike.%${filters.search}%,ketua_patrol.ilike.%${filters.search}%`)
    }

    if (filters?.unit_id) {
      query = query.eq('unit_id', filters.unit_id)
    }

    if (filters?.jenis) {
      query = query.eq('jenis_patrol', filters.jenis)
    }

    if (filters?.status) {
      query = query.eq('status', filters.status)
    }

    if (filters?.shift) {
      query = query.eq('shift', filters.shift)
    }

    if (filters?.start_date) {
      query = query.gte('tanggal_patrol', filters.start_date)
    }

    if (filters?.end_date) {
      query = query.lte('tanggal_patrol', filters.end_date)
    }

    const { data, error } = await query

    if (error) throw error
    return data || []
  }

  async getById(id: string): Promise<SafetyPatrol | null> {
    const { data, error } = await supabase
      .from('safety_patrol')
      .select('*, unit:units(id, kode, nama)')
      .eq('id', id)
      .single()

    if (error) throw error
    return data
  }

  async create(patrol: Partial<SafetyPatrol>): Promise<SafetyPatrol> {
    // Generate nomor patrol jika belum ada
    if (!patrol.nomor_patrol) {
      patrol.nomor_patrol = await this.generateNomorPatrol()
    }

    const { data, error } = await supabase
      .from('safety_patrol')
      .insert(patrol)
      .select()
      .single()

    if (error) throw error
    return data
  }

  async update(id: string, patrol: Partial<SafetyPatrol>): Promise<SafetyPatrol> {
    const { data, error } = await supabase
      .from('safety_patrol')
      .update(patrol)
      .eq('id', id)
      .select()
      .single()

    if (error) throw error
    return data
  }

  async delete(id: string): Promise<void> {
    const { error } = await supabase
      .from('safety_patrol')
      .delete()
      .eq('id', id)

    if (error) throw error
  }

  async generateNomorPatrol(): Promise<string> {
    const today = new Date()
    const year = today.getFullYear()
    const month = String(today.getMonth() + 1).padStart(2, '0')
    const prefix = `SP-${year}-${month}`

    const { data, error } = await supabase
      .from('safety_patrol')
      .select('nomor_patrol')
      .like('nomor_patrol', `${prefix}%`)
      .order('nomor_patrol', { ascending: false })
      .limit(1)

    if (error) throw error

    if (data && data.length > 0 && data[0]?.nomor_patrol) {
      const parts = data[0].nomor_patrol.split('-')
      const lastPart = parts[parts.length - 1]
      const lastNumber = parseInt(lastPart || '0')
      const newNumber = String(lastNumber + 1).padStart(3, '0')
      return `${prefix}-${newNumber}`
    }

    return `${prefix}-001`
  }

  async getStatistics(): Promise<PatrolStats> {
    const today = new Date()
    const startOfMonth = new Date(today.getFullYear(), today.getMonth(), 1)
      .toISOString()
      .split('T')[0]

    // Total patrol
    const { count: total } = await supabase
      .from('safety_patrol')
      .select('*', { count: 'exact', head: true })

    // Patrol bulan ini
    const { count: bulanIni } = await supabase
      .from('safety_patrol')
      .select('*', { count: 'exact', head: true })
      .gte('tanggal_patrol', startOfMonth)

    // Temuan kritikal
    const { data: kritikal } = await supabase
      .from('safety_patrol')
      .select('temuan_kritikal')
      .gt('temuan_kritikal', 0)

    const totalKritikal = kritikal?.reduce((sum, p) => sum + (p.temuan_kritikal || 0), 0) || 0

    // Temuan belum selesai
    const { data: belumSelesai } = await supabase
      .from('safety_patrol')
      .select('jumlah_action_item, action_selesai')
      .neq('status', 'closed')

    const totalBelumSelesai = belumSelesai?.reduce((sum, p) => 
      sum + (p.jumlah_action_item || 0) - (p.action_selesai || 0), 0
    ) || 0

    // Average score
    const { data: scores } = await supabase
      .from('safety_patrol')
      .select('skor_keseluruhan')
      .not('skor_keseluruhan', 'is', null)

    const avgSkor = scores && scores.length > 0
      ? Math.round(scores.reduce((sum, s) => sum + (s.skor_keseluruhan || 0), 0) / scores.length)
      : 0

    // Patrol by status
    const { data: byStatus } = await supabase
      .from('safety_patrol')
      .select('status')

    const patrolByStatus = this.groupAndCount(byStatus || [], 'status')

    // Patrol by grade
    const { data: byGrade } = await supabase
      .from('safety_patrol')
      .select('grade')
      .not('grade', 'is', null)

    const patrolByGrade = this.groupAndCount(byGrade || [], 'grade')

    return {
      total_patrol: total || 0,
      patrol_bulan_ini: bulanIni || 0,
      temuan_kritikal: totalKritikal,
      temuan_belum_selesai: totalBelumSelesai,
      avg_skor: avgSkor,
      patrol_by_status: patrolByStatus,
      patrol_by_grade: patrolByGrade
    }
  }

  private groupAndCount(data: any[], key: string): any[] {
    const grouped = data.reduce((acc, item) => {
      const value = item[key] || 'unknown'
      acc[value] = (acc[value] || 0) + 1
      return acc
    }, {} as Record<string, number>)

    return Object.entries(grouped).map(([k, count]) => ({
      [key]: k,
      count: count as number
    }))
  }

  async uploadPhoto(file: File, patrolId: string): Promise<string> {
    const fileExt = file.name.split('.').pop()
    const fileName = `${Date.now()}.${fileExt}`
    const filePath = `patrol/${patrolId}/${fileName}`

    const { error: uploadError } = await supabase.storage
      .from('safety-forum-photos')
      .upload(filePath, file)

    if (uploadError) throw uploadError

    const { data } = supabase.storage
      .from('safety-forum-photos')
      .getPublicUrl(filePath)

    return data.publicUrl
  }

  async uploadDocument(file: File, patrolId: string): Promise<string> {
    const fileExt = file.name.split('.').pop()
    const fileName = `${Date.now()}.${fileExt}`
    const filePath = `patrol/docs/${patrolId}/${fileName}`

    const { error: uploadError } = await supabase.storage
      .from('safety-forum-photos')
      .upload(filePath, file)

    if (uploadError) throw uploadError

    const { data } = supabase.storage
      .from('safety-forum-photos')
      .getPublicUrl(filePath)

    return data.publicUrl
  }

  async getFollowUpPatrols(): Promise<SafetyPatrol[]> {
    const { data, error } = await supabase
      .from('safety_patrol')
      .select('*, unit:units(id, kode, nama)')
      .eq('perlu_follow_up', true)
      .neq('status_follow_up', 'selesai')
      .order('tanggal_follow_up', { ascending: true })

    if (error) throw error
    return data || []
  }

  async getCriticalFindings(): Promise<SafetyPatrol[]> {
    const { data, error } = await supabase
      .from('safety_patrol')
      .select('*, unit:units(id, kode, nama)')
      .gt('temuan_kritikal', 0)
      .order('tanggal_patrol', { ascending: false })
      .limit(20)

    if (error) throw error
    return data || []
  }
}

export const safetyPatrolService = new SafetyPatrolService()
