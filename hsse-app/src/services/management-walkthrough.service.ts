import { supabase } from '@/services/api/supabase'

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

export interface ManagementWalkthrough {
  id?: string
  nomor_walkthrough: string
  tanggal_walkthrough: string
  waktu_mulai: string
  waktu_selesai?: string
  unit_id?: string
  area_inspeksi: string
  departemen?: string
  pimpinan_walkthrough: string
  anggota_tim?: string[]
  jumlah_tim?: number
  tujuan_walkthrough?: string
  fokus_area?: string[]
  jenis_walkthrough?: 'rutin' | 'terjadwal' | 'insidental' | 'follow_up' | 'khusus'
  
  // Observasi Kondisi
  kondisi_housekeeping?: 'baik' | 'cukup' | 'kurang' | 'buruk'
  kondisi_pencahayaan?: 'baik' | 'cukup' | 'kurang' | 'buruk'
  kondisi_ventilasi?: 'baik' | 'cukup' | 'kurang' | 'buruk'
  kondisi_akses_jalan?: 'baik' | 'cukup' | 'kurang' | 'buruk'
  
  // APD
  kepatuhan_apd?: number
  apd_tersedia?: boolean
  apd_kondisi_baik?: boolean
  apd_digunakan_benar?: boolean
  apd_tidak_sesuai?: string[]
  
  // Perilaku Kerja
  pekerja_diamati?: number
  perilaku_aman?: number
  perilaku_tidak_aman?: number
  perilaku_tidak_aman_detail?: any
  
  // Interaksi Pekerja
  jumlah_pekerja_diwawancara?: number
  feedback_pekerja?: string[]
  saran_pekerja?: string[]
  pekerja_aware_prosedur?: boolean
  
  // Temuan
  jumlah_temuan?: number
  temuan_bahaya?: any
  temuan_kritis?: number
  temuan_mayor?: number
  temuan_minor?: number
  temuan_observasi?: number
  
  // Pelanggaran
  pelanggaran_prosedur?: string[]
  pelanggaran_peraturan?: string[]
  area_non_compliance?: string[]
  
  // Positive Findings
  praktek_baik?: string[]
  area_excellent?: string[]
  pekerja_teladan?: string[]
  
  // Action Items
  action_items?: any
  jumlah_action_item?: number
  action_selesai?: number
  action_progress?: number
  action_belum_mulai?: number
  
  // Immediate Actions
  tindakan_segera?: string[]
  area_ditutup?: string[]
  pekerjaan_dihentikan?: string[]
  
  // Dokumentasi
  foto_walkthrough?: string[]
  dokumen_pendukung?: string[]
  sketsa_lokasi_url?: string
  video_url?: string
  
  // Ringkasan
  ringkasan_observasi?: string
  rekomendasi?: string[]
  catatan_khusus?: string
  
  // Status
  status?: 'draft' | 'in_progress' | 'completed' | 'cancelled'
  tingkat_urgensi?: 'rendah' | 'normal' | 'tinggi' | 'kritis'
  perlu_follow_up?: boolean
  tanggal_follow_up?: string
  status_follow_up?: 'belum' | 'terjadwal' | 'selesai' | 'tidak_perlu'
  
  // Scoring
  skor_keseluruhan?: number
  skor_housekeeping?: number
  skor_apd?: number
  skor_perilaku?: number
  
  // Metadata
  created_by?: string
  created_at?: string
  updated_at?: string
  approved_by?: string
  approved_at?: string
  
  // Relations
  unit?: any
}

export interface WalkthroughFilters {
  search?: string
  unit_id?: string
  jenis?: string
  status?: string
  tingkat_urgensi?: string
  bulan?: string
}

class ManagementWalkthroughService {
  private tableName = 'management_walkthrough'

  /**
   * Upload foto temuan ke storage
   */
  async uploadPhoto(file: File, walkthroughId: string): Promise<string> {
    const fileExt = file.name.split('.').pop()
    const fileName = `${walkthroughId}/${Date.now()}.${fileExt}`
    const filePath = `walkthrough/${fileName}`

    const { error: uploadError } = await supabase.storage
      .from('safety-forum-photos')
      .upload(filePath, file)

    if (uploadError) {
      throw uploadError
    }

    const { data } = supabase.storage
      .from('safety-forum-photos')
      .getPublicUrl(filePath)

    return data.publicUrl
  }

  /**
   * Upload dokumen pendukung
   */
  async uploadDocument(file: File, walkthroughId: string): Promise<string> {
    const fileExt = file.name.split('.').pop()
    const fileName = `${walkthroughId}/${Date.now()}.${fileExt}`
    const filePath = `walkthrough-docs/${fileName}`

    const { error: uploadError } = await supabase.storage
      .from('safety-forum-photos')
      .upload(filePath, file)

    if (uploadError) {
      throw uploadError
    }

    const { data } = supabase.storage
      .from('safety-forum-photos')
      .getPublicUrl(filePath)

    return data.publicUrl
  }

  /**
   * Generate nomor walkthrough otomatis
   */
  async generateNomorWalkthrough(): Promise<string> {
    const today = new Date()
    const year = today.getFullYear()
    const month = String(today.getMonth() + 1).padStart(2, '0')
    const prefix = `MW-${year}-${month}`

    const { data, error } = await supabase
      .from(this.tableName)
      .select('nomor_walkthrough')
      .like('nomor_walkthrough', `${prefix}%`)
      .order('nomor_walkthrough', { ascending: false })
      .limit(1)

    if (error) throw error

    let nextNumber = 1
    if (data && data.length > 0 && data[0]) {
      const lastNumber = data[0].nomor_walkthrough?.split('-').pop()
      nextNumber = parseInt(lastNumber || '0') + 1
    }

    return `${prefix}-${String(nextNumber).padStart(3, '0')}`
  }

  /**
   * Get all walkthroughs dengan filter (backward compatible)
   */
  async getAll(filters?: WalkthroughFilters): Promise<ManagementWalkthrough[]> {
    const response = await this.getPaginated(filters, { page: 1, pageSize: 10000 })
    return response.data
  }

  /**
   * Get paginated walkthroughs dengan filter
   */
  async getPaginated(
    filters?: WalkthroughFilters,
    pagination?: PaginationParams
  ): Promise<PaginatedResponse<ManagementWalkthrough>> {
    const page = pagination?.page || 1
    const pageSize = pagination?.pageSize || 20
    const from = (page - 1) * pageSize
    const to = from + pageSize - 1

    let query = supabase
      .from(this.tableName)
      .select(`
        *,
        unit:units!unit_id(id, kode, nama)
      `, { count: 'exact' })
      .order('tanggal_walkthrough', { ascending: false })

    // Apply filters
    if (filters?.search) {
      query = query.or(`nomor_walkthrough.ilike.%${filters.search}%,area_inspeksi.ilike.%${filters.search}%,pimpinan_walkthrough.ilike.%${filters.search}%`)
    }

    if (filters?.unit_id) {
      query = query.eq('unit_id', filters.unit_id)
    }

    if (filters?.jenis) {
      query = query.eq('jenis_walkthrough', filters.jenis)
    }

    if (filters?.status) {
      query = query.eq('status', filters.status)
    }

    if (filters?.tingkat_urgensi) {
      query = query.eq('tingkat_urgensi', filters.tingkat_urgensi)
    }

    if (filters?.bulan) {
      const parts = filters.bulan.split('-')
      if (parts.length === 2 && parts[0] && parts[1]) {
        const year = parts[0]
        const month = parts[1]
        const nextMonth = parseInt(month) + 1
        const nextYear = nextMonth > 12 ? parseInt(year) + 1 : parseInt(year)
        const nextMonthStr = nextMonth > 12 ? '01' : String(nextMonth).padStart(2, '0')
        query = query.gte('tanggal_walkthrough', `${year}-${month}-01`)
        query = query.lt('tanggal_walkthrough', `${nextYear}-${nextMonthStr}-01`)
      }
    }

    query = query.range(from, to)

    const { data, error, count } = await query

    if (error) throw error

    return {
      data: (data || []).map(item => ({
        ...item,
        unit: item.unit ? {
          ...item.unit,
          kode: item.unit.kode,
          nama: item.unit.nama
        } : null
      })),
      count: count || 0,
      page,
      pageSize,
      totalPages: Math.ceil((count || 0) / pageSize)
    }
  }

  /**
   * Get walkthrough by ID
   */
  async getById(id: string): Promise<ManagementWalkthrough | null> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select(`
        *,
        unit:units!unit_id(id, kode, nama)
      `)
      .eq('id', id)
      .single()

    if (error) throw error
    return data ? {
      ...data,
      unit: data.unit ? {
        ...data.unit,
        kode: data.unit.kode,
        nama: data.unit.nama
      } : null
    } : null
  }

  /**
   * Create walkthrough baru
   */
  async create(walkthrough: ManagementWalkthrough): Promise<ManagementWalkthrough> {
    // Generate nomor otomatis jika belum ada
    if (!walkthrough.nomor_walkthrough) {
      walkthrough.nomor_walkthrough = await this.generateNomorWalkthrough()
    }

    const { data, error } = await supabase
      .from(this.tableName)
      .insert(walkthrough)
      .select()
      .single()

    if (error) throw error
    return data
  }

  /**
   * Update walkthrough
   */
  async update(id: string, walkthrough: Partial<ManagementWalkthrough>): Promise<ManagementWalkthrough> {
    const { data, error } = await supabase
      .from(this.tableName)
      .update(walkthrough)
      .eq('id', id)
      .select()
      .single()

    if (error) throw error
    return data
  }

  /**
   * Delete walkthrough
   */
  async delete(id: string): Promise<void> {
    const { error } = await supabase
      .from(this.tableName)
      .delete()
      .eq('id', id)

    if (error) throw error
  }

  /**
   * Update status walkthrough
   */
  async updateStatus(id: string, status: string): Promise<void> {
    const { error } = await supabase
      .from(this.tableName)
      .update({ status })
      .eq('id', id)

    if (error) throw error
  }

  /**
   * Update action item status
   */
  async updateActionItem(id: string, actionIndex: number, newStatus: string): Promise<void> {
    // Get current data
    const { data: current, error: fetchError } = await supabase
      .from(this.tableName)
      .select('action_items')
      .eq('id', id)
      .single()

    if (fetchError) throw fetchError

    const actionItems = current.action_items || []
    if (actionIndex >= 0 && actionIndex < actionItems.length) {
      actionItems[actionIndex].status = newStatus
    }

    // Count status
    const counts = {
      selesai: 0,
      progress: 0,
      belum_mulai: 0
    }

    actionItems.forEach((item: any) => {
      if (item.status === 'selesai') counts.selesai++
      else if (item.status === 'progress') counts.progress++
      else counts.belum_mulai++
    })

    const { error: updateError } = await supabase
      .from(this.tableName)
      .update({
        action_items: actionItems,
        action_selesai: counts.selesai,
        action_progress: counts.progress,
        action_belum_mulai: counts.belum_mulai
      })
      .eq('id', id)

    if (updateError) throw updateError
  }

  /**
   * Get statistics
   */
  async getStatistics() {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('status, tingkat_urgensi, jumlah_temuan, temuan_kritis, temuan_mayor')

    if (error) throw error

    const stats = {
      total: data?.length || 0,
      byStatus: {
        draft: 0,
        in_progress: 0,
        completed: 0,
        cancelled: 0
      },
      byUrgensi: {
        rendah: 0,
        normal: 0,
        tinggi: 0,
        kritis: 0
      },
      totalTemuan: 0,
      temuanKritis: 0,
      temuanMayor: 0
    }

    data?.forEach((item: any) => {
      stats.byStatus[item.status as keyof typeof stats.byStatus]++
      stats.byUrgensi[item.tingkat_urgensi as keyof typeof stats.byUrgensi]++
      stats.totalTemuan += item.jumlah_temuan || 0
      stats.temuanKritis += item.temuan_kritis || 0
      stats.temuanMayor += item.temuan_mayor || 0
    })

    return stats
  }

  /**
   * Get walkthroughs yang perlu follow-up
   */
  async getFollowUpNeeded(): Promise<ManagementWalkthrough[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select(`
        *,
        unit:units!unit_id(id, kode, nama)
      `)
      .eq('perlu_follow_up', true)
      .in('status_follow_up', ['belum', 'terjadwal'])
      .order('tanggal_follow_up', { ascending: true })

    if (error) throw error
    return (data || []).map(item => ({
      ...item,
      unit: item.unit ? {
        ...item.unit,
        kode: item.unit.kode,
        nama: item.unit.nama
      } : null
    }))
  }

  /**
   * Get temuan kritis yang masih open
   */
  async getCriticalFindings(): Promise<ManagementWalkthrough[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select(`
        *,
        unit:units!unit_id(id, kode, nama)
      `)
      .gt('temuan_kritis', 0)
      .neq('status', 'completed')
      .order('tanggal_walkthrough', { ascending: false })

    if (error) throw error
    return (data || []).map(item => ({
      ...item,
      unit: item.unit ? {
        ...item.unit,
        kode: item.unit.kode,
        nama: item.unit.nama
      } : null
    }))
  }
}

export const managementWalkthroughService = new ManagementWalkthroughService()
