import { supabase } from './api/supabase'

export interface TemuanItem {
  id: string
  nomor: string
  module: string
  moduleLabel: string
  tanggal: string
  unit: string
  area: string
  deskripsi: string
  temuan_text: string
  tindak_lanjut_text: string
  jumlah_temuan: number
  temuan_kritis: number
  temuan_mayor: number
  temuan_minor: number
  temuan_details: any[]
  action_items: any[]
  status: string
  pic: string
  created_by: string
}

export interface ActionItemDetail {
  id: string
  nomor: string
  module: string
  moduleLabel: string
  tanggal: string
  unit: string
  area: string
  no: number
  temuan: string
  tindakan: string
  pic: string
  target_date: string
  prioritas: string
  status: string
  overdue: boolean
  daysUntilDue?: number
}

export interface TemuanStatistics {
  total_inspeksi: number
  total_temuan: number
  temuan_kritis: number
  temuan_mayor: number
  temuan_minor: number
  total_action_items: number
  action_items_completed: number
  action_items_pending: number
  action_items_overdue: number
  completion_rate: number
}

class TemuanMonitoringService {
  /**
   * Get all temuan from all modules
   */
  async getAllTemuan(filters?: {
    start_date?: string
    end_date?: string
    unit_id?: string
    module?: string
    status?: string
    prioritas?: string
  }): Promise<TemuanItem[]> {
    const allTemuan: TemuanItem[] = []

    try {
      // 1. Safety Patrol
      let spQuery = supabase
        .from('safety_patrol')
        .select(`
          id,
          nomor_patrol,
          tanggal_patrol,
          area_patrol,
          catatan_patrol,
          jumlah_unsafe_condition,
          jumlah_unsafe_act,
          unsafe_condition,
          unsafe_act,
          action_items,
          status,
          ketua_patrol,
          created_by,
          units(nama)
        `)
        .order('tanggal_patrol', { ascending: false })

      if (filters?.start_date) spQuery = spQuery.gte('tanggal_patrol', filters.start_date)
      if (filters?.end_date) spQuery = spQuery.lte('tanggal_patrol', filters.end_date)
      if (filters?.unit_id) spQuery = spQuery.eq('unit_id', filters.unit_id)
      if (filters?.status) spQuery = spQuery.eq('status', filters.status)

      const { data: spData, error: spError } = await spQuery

      if (spError) {
        console.error('Error fetching safety_patrol:', spError)
      }
      if (spData) {
        allTemuan.push(...spData.map((item: any) => {
          // Combine unsafe conditions and acts into temuan_details
          const temuanDetails: any[] = []
          if (item.unsafe_condition && Array.isArray(item.unsafe_condition)) {
            temuanDetails.push(...item.unsafe_condition.map((uc: any) => ({
              ...uc,
              jenis: 'unsafe_condition',
              kondisi_tidak_aman: uc.kondisi_tidak_aman || uc.deskripsi || uc.kondisi
            })))
          }
          if (item.unsafe_act && Array.isArray(item.unsafe_act)) {
            temuanDetails.push(...item.unsafe_act.map((ua: any) => ({
              ...ua,
              jenis: 'unsafe_act',
              tindakan_tidak_aman: ua.tindakan_tidak_aman || ua.deskripsi || ua.tindakan
            })))
          }

          // Extract temuan text from unsafe conditions and acts
          const temuanTexts: string[] = []
          if (item.unsafe_condition && Array.isArray(item.unsafe_condition)) {
            temuanTexts.push(...item.unsafe_condition.map((uc: any) => 
              uc.kondisi_tidak_aman || uc.deskripsi || uc.kondisi || ''
            ).filter(Boolean))
          }
          if (item.unsafe_act && Array.isArray(item.unsafe_act)) {
            temuanTexts.push(...item.unsafe_act.map((ua: any) => 
              ua.tindakan_tidak_aman || ua.deskripsi || ua.tindakan || ''
            ).filter(Boolean))
          }

          // Extract tindak lanjut from action items
          const tindakLanjutTexts: string[] = []
          if (item.action_items && Array.isArray(item.action_items)) {
            tindakLanjutTexts.push(...item.action_items.map((ai: any) => 
              ai.tindakan || ai.rekomendasi || ai.action || ''
            ).filter(Boolean))
          }

          return {
            id: item.id,
            nomor: item.nomor_patrol,
            module: 'safety_patrol',
            moduleLabel: 'Safety Patrol',
            tanggal: item.tanggal_patrol,
            unit: item.units?.nama || '-',
            area: item.area_patrol || '-',
            deskripsi: item.catatan_patrol || 'Patrol K3 Area',
            temuan_text: temuanTexts.join('; ') || '-',
            tindak_lanjut_text: tindakLanjutTexts.join('; ') || '-',
            jumlah_temuan: (item.jumlah_unsafe_condition || 0) + (item.jumlah_unsafe_act || 0),
            temuan_kritis: 0,
            temuan_mayor: 0,
            temuan_minor: (item.jumlah_unsafe_condition || 0) + (item.jumlah_unsafe_act || 0),
            temuan_details: temuanDetails,
            action_items: item.action_items || [],
            status: item.status,
            pic: item.ketua_patrol || '-',
            created_by: item.created_by
          }
        }))
      }

      // 2. Management Walkthrough
      let mwQuery = supabase
        .from('management_walkthrough')
        .select(`
          *,
          units(nama)
        `)
        .order('tanggal_walkthrough', { ascending: false })

      if (filters?.start_date) mwQuery = mwQuery.gte('tanggal_walkthrough', filters.start_date)
      if (filters?.end_date) mwQuery = mwQuery.lte('tanggal_walkthrough', filters.end_date)
      if (filters?.unit_id) mwQuery = mwQuery.eq('unit_id', filters.unit_id)
      if (filters?.status) mwQuery = mwQuery.eq('status', filters.status)

      const { data: mwData, error: mwError } = await mwQuery

      if (mwError) {
        console.error('Error fetching management_walkthrough:', mwError)
      }
      if (mwData) {
        allTemuan.push(...mwData.map((item: any) => {
          // Parse temuan if it's an array
          let temuanDetails = []
          if (item.temuan && Array.isArray(item.temuan)) {
            temuanDetails = item.temuan
          }

          // Extract temuan text
          const temuanTexts: string[] = []
          if (temuanDetails && Array.isArray(temuanDetails)) {
            temuanTexts.push(...temuanDetails.map((t: any) => 
              t.deskripsi || t.temuan || t.kondisi || t.observasi || ''
            ).filter(Boolean))
          }

          // Extract tindak lanjut from action items
          const tindakLanjutTexts: string[] = []
          if (item.action_items && Array.isArray(item.action_items)) {
            tindakLanjutTexts.push(...item.action_items.map((ai: any) => 
              ai.tindakan || ai.rekomendasi || ai.action || ''
            ).filter(Boolean))
          }

          return {
            id: item.id,
            nomor: item.nomor_walkthrough,
            module: 'management_walkthrough',
            moduleLabel: 'Management Walkthrough',
            tanggal: item.tanggal_walkthrough,
            unit: item.units?.nama || '-',
            area: item.area_inspeksi || '-',
            deskripsi: item.deskripsi_walkthrough || item.tujuan_walkthrough || 'Management Walkthrough',
            temuan_text: temuanTexts.join('; ') || '-',
            tindak_lanjut_text: tindakLanjutTexts.join('; ') || '-',
            jumlah_temuan: item.jumlah_temuan || 0,
            temuan_kritis: item.temuan_kritis || 0,
            temuan_mayor: item.temuan_mayor || 0,
            temuan_minor: item.temuan_minor || 0,
            temuan_details: temuanDetails,
            action_items: item.action_items || [],
            status: item.status,
            pic: item.pimpinan_walkthrough || '-',
            created_by: item.created_by
          }
        }))
      }

      // 3. Silent Inspection
      let siQuery = supabase
        .from('silent_inspection')
        .select(`
          id,
          tanggal,
          area_inspeksi,
          deskripsi_temuan,
          rekomendasi,
          jumlah_temuan,
          temuan_critical,
          temuan_major,
          temuan_minor,
          status,
          inspector_id,
          created_by,
          units(nama),
          inspector:pegawai!silent_inspection_inspector_id_fkey(nama)
        `)
        .order('tanggal', { ascending: false })

      if (filters?.start_date) siQuery = siQuery.gte('tanggal', filters.start_date)
      if (filters?.end_date) siQuery = siQuery.lte('tanggal', filters.end_date)
      if (filters?.unit_id) siQuery = siQuery.eq('unit_id', filters.unit_id)
      if (filters?.status) siQuery = siQuery.eq('status', filters.status)

      const { data: siData, error: siError } = await siQuery

      if (siError) {
        console.error('Error fetching silent_inspection:', siError)
      }
      if (siData) {
        allTemuan.push(...siData.map((item: any) => {
          // Parse tindak_lanjut if available
          let actionItems = []
          if (item.tindak_lanjut && Array.isArray(item.tindak_lanjut)) {
            actionItems = item.tindak_lanjut
          }

          // Extract tindak lanjut text from rekomendasi
          const tindakLanjutTexts: string[] = []
          if (item.rekomendasi) {
            tindakLanjutTexts.push(item.rekomendasi)
          }

          return {
            id: item.id,
            nomor: `SI-${item.tanggal}`,
            module: 'silent_inspection',
            moduleLabel: 'Silent Inspection',
            tanggal: item.tanggal,
            unit: item.units?.nama || '-',
            area: item.area_inspeksi || '-',
            deskripsi: item.deskripsi_temuan || 'Silent Inspection K3',
            temuan_text: item.deskripsi_temuan || '-',
            tindak_lanjut_text: tindakLanjutTexts.join('; ') || item.rekomendasi || '-',
            jumlah_temuan: item.jumlah_temuan || 0,
            temuan_kritis: item.temuan_critical || 0,
            temuan_mayor: item.temuan_major || 0,
            temuan_minor: item.temuan_minor || 0,
            temuan_details: [],
            action_items: actionItems,
            status: item.status,
            pic: item.inspector?.nama || '-',
            created_by: item.created_by
          }
        }))
      }

      // 4. Safety Drill
      let sdQuery = supabase
        .from('safety_drill')
        .select(`
          id,
          nomor_drill,
          judul_drill,
          deskripsi,
          tujuan_drill,
          catatan_next_drill,
          tanggal_drill,
          area_lokasi,
          status,
          drill_commander,
          created_by,
          units(nama)
        `)
        .order('tanggal_drill', { ascending: false })

      if (filters?.start_date) sdQuery = sdQuery.gte('tanggal_drill', filters.start_date)
      if (filters?.end_date) sdQuery = sdQuery.lte('tanggal_drill', filters.end_date)
      if (filters?.unit_id) sdQuery = sdQuery.eq('unit_id', filters.unit_id)
      if (filters?.status) sdQuery = sdQuery.eq('status', filters.status)

      const { data: sdData, error: sdError } = await sdQuery

      if (sdError) {
        console.error('Error fetching safety_drill:', sdError)
      }
      if (sdData) {
        allTemuan.push(...sdData.map((item: any) => ({
          id: item.id,
          nomor: item.nomor_drill,
          module: 'safety_drill',
          moduleLabel: 'Safety Drill',
          tanggal: item.tanggal_drill,
          unit: item.units?.nama || '-',
          area: item.area_lokasi || '-',
          deskripsi: item.deskripsi || item.judul_drill || item.tujuan_drill || 'Safety Drill',
          temuan_text: item.tujuan_drill || item.deskripsi || '-',
          tindak_lanjut_text: item.catatan_next_drill || '-',
          jumlah_temuan: 0,
          temuan_kritis: 0,
          temuan_mayor: 0,
          temuan_minor: 0,
          temuan_details: [],
          action_items: [],
          status: item.status,
          pic: item.drill_commander || '-',
          created_by: item.created_by
        })))
      }

      // 5. Safety Forum
      let sfQuery = supabase
        .from('safety_forum')
        .select(`
          *,
          units(nama)
        `)
        .order('tanggal_forum', { ascending: false })

      if (filters?.start_date) sfQuery = sfQuery.gte('tanggal_forum', filters.start_date)
      if (filters?.end_date) sfQuery = sfQuery.lte('tanggal_forum', filters.end_date)
      if (filters?.unit_id) sfQuery = sfQuery.eq('unit_id', filters.unit_id)
      if (filters?.status) sfQuery = sfQuery.eq('status', filters.status)

      const { data: sfData, error: sfError } = await sfQuery

      if (sfError) {
        console.error('Error fetching safety_forum:', sfError)
      }
      if (sfData) {
        allTemuan.push(...sfData.map((item: any) => {
          const actionItems = item.action_items || []
          // Parse temuan details if available
          let temuanDetails = []
          if (item.temuan && Array.isArray(item.temuan)) {
            temuanDetails = item.temuan
          }

          // Extract temuan text
          const temuanTexts: string[] = []
          if (temuanDetails && Array.isArray(temuanDetails)) {
            temuanTexts.push(...temuanDetails.map((t: any) => 
              t.deskripsi || t.temuan || t.isu || t.masalah || ''
            ).filter(Boolean))
          }
          if (!temuanTexts.length && item.topik_dibahas && Array.isArray(item.topik_dibahas)) {
            temuanTexts.push(...item.topik_dibahas.filter(Boolean))
          }

          // Extract tindak lanjut from action items
          const tindakLanjutTexts: string[] = []
          if (actionItems && Array.isArray(actionItems)) {
            tindakLanjutTexts.push(...actionItems.map((ai: any) => 
              ai.tindakan || ai.rekomendasi || ai.action || ''
            ).filter(Boolean))
          }

          return {
            id: item.id,
            nomor: item.nomor_forum,
            module: 'safety_forum',
            moduleLabel: 'Safety Forum',
            tanggal: item.tanggal_forum,
            unit: item.units?.nama || '-',
            area: item.lokasi || '-',
            deskripsi: item.deskripsi || item.tema_forum || (item.topik_dibahas ? item.topik_dibahas.join(', ') : '') || 'Safety Forum',
            temuan_text: temuanTexts.join('; ') || item.tema_forum || '-',
            tindak_lanjut_text: tindakLanjutTexts.join('; ') || '-',
            jumlah_temuan: actionItems.length,
            temuan_kritis: actionItems.filter((a: any) => a.prioritas === 'kritikal').length,
            temuan_mayor: actionItems.filter((a: any) => a.prioritas === 'tinggi').length,
            temuan_minor: actionItems.filter((a: any) => a.prioritas === 'sedang' || a.prioritas === 'rendah').length,
            temuan_details: temuanDetails,
            action_items: actionItems,
            status: item.status,
            pic: item.ketua_forum || '-',
            created_by: item.created_by
          }
        }))
      }

      // Sort by date descending
      allTemuan.sort((a, b) => new Date(b.tanggal).getTime() - new Date(a.tanggal).getTime())

      return allTemuan
    } catch (error) {
      console.error('Error fetching all temuan:', error)
      throw error
    }
  }

  /**
   * Get all action items from all modules with details
   */
  async getAllActionItems(filters?: {
    start_date?: string
    end_date?: string
    unit_id?: string
    module?: string
    status?: string
    prioritas?: string
    overdue_only?: boolean
  }): Promise<ActionItemDetail[]> {
    const allActionItems: ActionItemDetail[] = []
    const today = new Date().toISOString().split('T')[0] || ''

    try {
      const temuanList = await this.getAllTemuan({
        start_date: filters?.start_date,
        end_date: filters?.end_date,
        unit_id: filters?.unit_id,
        module: filters?.module,
        status: filters?.status
      })

      temuanList.forEach(temuan => {
        if (temuan.action_items && Array.isArray(temuan.action_items)) {
          temuan.action_items.forEach((item: any) => {
            // Apply filters
            if (filters?.prioritas && item.prioritas !== filters.prioritas) return
            if (filters?.status && item.status !== filters.status) return

            const isOverdue = item.target_date && item.target_date < today && item.status !== 'selesai'
            
            if (filters?.overdue_only && !isOverdue) return

            // Calculate days until due
            let daysUntilDue: number | undefined
            if (item.target_date && item.status !== 'selesai') {
              const targetDate = new Date(item.target_date)
              const todayDate = new Date(today)
              daysUntilDue = Math.ceil((targetDate.getTime() - todayDate.getTime()) / (1000 * 60 * 60 * 24))
            }

            allActionItems.push({
              id: `${temuan.id}-${item.no}`,
              nomor: temuan.nomor,
              module: temuan.module,
              moduleLabel: temuan.moduleLabel,
              tanggal: temuan.tanggal,
              unit: temuan.unit,
              area: temuan.area,
              no: item.no || 0,
              temuan: item.temuan || '-',
              tindakan: item.tindakan || '-',
              pic: item.pic || '-',
              target_date: item.target_date || '-',
              prioritas: item.prioritas || 'rendah',
              status: item.status || 'belum_mulai',
              overdue: isOverdue,
              daysUntilDue
            })
          })
        }
      })

      return allActionItems
    } catch (error) {
      console.error('Error fetching all action items:', error)
      throw error
    }
  }

  /**
   * Get statistics for temuan monitoring
   */
  async getStatistics(filters?: {
    start_date?: string
    end_date?: string
    unit_id?: string
    module?: string
  }): Promise<TemuanStatistics> {
    try {
      const temuanList = await this.getAllTemuan(filters)
      const actionItems = await this.getAllActionItems(filters)

      const stats: TemuanStatistics = {
        total_inspeksi: temuanList.length,
        total_temuan: temuanList.reduce((sum, t) => sum + t.jumlah_temuan, 0),
        temuan_kritis: temuanList.reduce((sum, t) => sum + t.temuan_kritis, 0),
        temuan_mayor: temuanList.reduce((sum, t) => sum + t.temuan_mayor, 0),
        temuan_minor: temuanList.reduce((sum, t) => sum + t.temuan_minor, 0),
        total_action_items: actionItems.length,
        action_items_completed: actionItems.filter(a => a.status === 'selesai').length,
        action_items_pending: actionItems.filter(a => a.status !== 'selesai').length,
        action_items_overdue: actionItems.filter(a => a.overdue).length,
        completion_rate: 0
      }

      if (stats.total_action_items > 0) {
        stats.completion_rate = (stats.action_items_completed / stats.total_action_items) * 100
      }

      return stats
    } catch (error) {
      console.error('Error calculating statistics:', error)
      throw error
    }
  }

  /**
   * Get priority distribution
   */
  async getPriorityDistribution(filters?: any): Promise<{ prioritas: string; count: number }[]> {
    try {
      const actionItems = await this.getAllActionItems(filters)
      
      const distribution = [
        { prioritas: 'kritikal', count: 0 },
        { prioritas: 'tinggi', count: 0 },
        { prioritas: 'sedang', count: 0 },
        { prioritas: 'rendah', count: 0 }
      ]

      actionItems.forEach(item => {
        const found = distribution.find(d => d.prioritas === item.prioritas)
        if (found) found.count++
      })

      return distribution
    } catch (error) {
      console.error('Error getting priority distribution:', error)
      throw error
    }
  }

  /**
   * Get module distribution
   */
  async getModuleDistribution(filters?: any): Promise<{ module: string; label: string; count: number }[]> {
    try {
      const temuanList = await this.getAllTemuan(filters)
      
      const moduleMap = new Map<string, { label: string; count: number }>()
      
      temuanList.forEach(item => {
        const existing = moduleMap.get(item.module)
        if (existing) {
          existing.count++
        } else {
          moduleMap.set(item.module, { label: item.moduleLabel, count: 1 })
        }
      })

      return Array.from(moduleMap.entries()).map(([module, data]) => ({
        module,
        label: data.label,
        count: data.count
      }))
    } catch (error) {
      console.error('Error getting module distribution:', error)
      throw error
    }
  }
}

export const temuanMonitoringService = new TemuanMonitoringService()
