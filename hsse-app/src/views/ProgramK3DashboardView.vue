<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { supabase } from '@/services/api/supabase'
import { safetyDrillService } from '@/services/safety-drill.service'

interface ProgramData {
  id: string
  name: string
  icon: string
  realization: number | string
  target: string
  isPercentage: boolean
  color: string
}

interface InsidenData {
  no: number
  tanggal: string
  uraian: string
  faktor_penyebab: string
  lokasi: string
  klasifikasi: string
  tingkat_keparahan: string
}

interface SafetyAlertData {
  no: number
  what: string
  when: string
  where: string
  who: string
  why: string
  how: string
  howMuch: {
    people: string
    property: string
    security: string
    environment: string
  }
  followUp: string
  lessonLearned: {
    people: string
    paper: string
    place: string
  }
  sumber: string
}

const loading = ref(false)
const loadingInsiden = ref(false)
const loadingSafetyAlert = ref(false)
const loadingRekapK3l = ref(false)
const selectedYear = ref(2025) // Default year
const selectedMonthNum = ref(11) // Default to November
const selectedMonth = ref('2025-11') // Default to November 2025 where sample data exists
const selectedSafetyAlertModule = ref('all') // Filter for safety alert by module
const insidenData = ref<InsidenData[]>([])
const safetyAlertData = ref<SafetyAlertData[]>([])
const allSafetyAlertData = ref<SafetyAlertData[]>([]) // Store all data before filtering
const rekapK3lYear = ref(2024) // Default to 2024 for sample data
const rekapK3lMonth = ref(12) // Default to December 2024 for sample data
const rekapK3lUnit = ref<string>('all') // Default to all units
const rekapK3lData = ref<any[]>([])
const units = ref<any[]>([]) // List of units for filter

const programs = ref<ProgramData[]>([
  {
    id: 'safety_briefing',
    name: 'Safety Briefing',
    icon: '👥',
    realization: 0,
    target: 'Target: 1x/hari',
    isPercentage: false,
    color: '#1e40af'
  },
  {
    id: 'management_walkthrough',
    name: 'Management Walkthrough',
    icon: '🚶',
    realization: 0,
    target: 'Target: 1x/triwulan oleh BOD/BOD-1 bidang K3',
    isPercentage: false,
    color: '#1e40af'
  },
  {
    id: 'silent_inspection',
    name: 'Inspection',
    icon: '🔍',
    realization: 0,
    target: 'Target: 1x/triwulan oleh bidang K3',
    isPercentage: false,
    color: '#1e40af'
  },
  {
    id: 'audit',
    name: 'Pemenuhan Audit',
    icon: '📋',
    realization: '0%',
    target: 'Target: 100%/tahun terkait K3',
    isPercentage: true,
    color: '#1e40af'
  },
  {
    id: 'sarpras',
    name: 'Pengukuran Sarpras K3',
    icon: '🧯',
    realization: '0%',
    target: 'Target: 100%/tahun',
    isPercentage: true,
    color: '#1e40af'
  },
  {
    id: 'safety_forum',
    name: 'Safety Forum',
    icon: '💬',
    realization: 0,
    target: 'Target: 1x/triwulan',
    isPercentage: false,
    color: '#1e40af'
  },
  {
    id: 'safety_drill',
    name: 'Emergency Drill',
    icon: '🚨',
    realization: 0,
    target: 'Target: 2x/tahun',
    isPercentage: false,
    color: '#1e40af'
  },
  {
    id: 'health_risk',
    name: 'Health Risk Assessment',
    icon: '❤️',
    realization: '0%',
    target: 'Target: 100% unit/tahun',
    isPercentage: true,
    color: '#1e40af'
  },
  {
    id: 'evaluasi',
    name: 'Evaluasi Program K3L',
    icon: '📊',
    realization: 0,
    target: 'Target: 1x/semester',
    isPercentage: false,
    color: '#1e40af'
  },
  {
    id: 'safety_induction',
    name: 'Safety Induction',
    icon: '👷',
    realization: 0,
    target: 'Target: ~ orang/tahun',
    isPercentage: false,
    color: '#1e40af'
  }
])

async function loadData() {
  loading.value = true
  try {
    const startDate = `${selectedMonth.value}-01`
    const endDate = new Date(selectedMonth.value + '-01')
    endDate.setMonth(endDate.getMonth() + 1)
    const endDateStr = endDate.toISOString().slice(0, 10)
    
    const unitFilter = rekapK3lUnit.value

    // Fetch counts for each program with unit filter
    const [
      briefingCount,
      walkthroughCount,
      inspectionCount,
      forumCount,
      drillCount,
      inductionCount
    ] = await Promise.all([
      countRecords('safety_briefing', 'tanggal', startDate, endDateStr, unitFilter),
      countRecords('management_walkthrough', 'tanggal_walkthrough', startDate, endDateStr, unitFilter),
      countRecords('silent_inspection', 'tanggal', startDate, endDateStr, unitFilter),
      countRecords('safety_forum', 'tanggal_forum', startDate, endDateStr, unitFilter),
      countRecords('safety_drill', 'tanggal_drill', startDate, endDateStr, unitFilter),
      countRecords('safety_induction', 'tanggal_induction', startDate, endDateStr, unitFilter)
    ])

    // Update realizations
    const prog = programs.value
    prog[0]!.realization = briefingCount
    prog[1]!.realization = walkthroughCount
    prog[2]!.realization = inspectionCount
    prog[5]!.realization = forumCount
    prog[6]!.realization = drillCount
    prog[9]!.realization = inductionCount

    // Load insiden data
    await loadInsidenData(startDate, endDateStr, unitFilter)
    
    // Load safety alert data
    await loadSafetyAlertData(startDate, endDateStr, unitFilter)
    
    // Load rekap K3L data
    await loadRekapK3lData()
    
  } catch (error) {
    console.error('Error loading dashboard data:', error)
  } finally {
    loading.value = false
  }
}

async function loadInsidenData(startDate: string, endDate: string, unitFilter: string = 'all') {
  loadingInsiden.value = true
  try {
    const incidents: InsidenData[] = []
    let counter = 1

    // 1. Unsafe Action/Condition
    let unsafeQuery = supabase
      .from('unsafe_action_condition')
      .select('tanggal_kejadian, deskripsi_kejadian, penyebab_diduga, lokasi_kejadian, jenis_kejadian, prioritas, unit_id')
      .gte('tanggal_kejadian', startDate)
      .lt('tanggal_kejadian', endDate)
    
    if (unitFilter !== 'all') {
      unsafeQuery = unsafeQuery.eq('unit_id', unitFilter)
    }
    
    const { data: unsafeData } = await unsafeQuery
      .order('tanggal_kejadian', { ascending: false })

    if (unsafeData) {
      unsafeData.forEach((item: any) => {
        incidents.push({
          no: counter++,
          tanggal: item.tanggal_kejadian,
          uraian: item.deskripsi_kejadian || '-',
          faktor_penyebab: item.penyebab_diduga || '-',
          lokasi: item.lokasi_kejadian || '-',
          klasifikasi: item.jenis_kejadian === 'unsafe_action' ? 'Unsafe Action' : 'Unsafe Condition',
          tingkat_keparahan: item.prioritas || '-'
        })
      })
    }

    // 2. LTIFR - Kecelakaan Kerja
    const { data: ltifrData } = await supabase
      .from('ltifr_records')
      .select('periode_bulan, jumlah_lti, jumlah_fatality, deskripsi_kecelakaan, units(nama)')
      .gte('periode_bulan', startDate.substring(0, 7))
      .lte('periode_bulan', endDate.substring(0, 7))
      .order('periode_bulan', { ascending: false })

    if (ltifrData) {
      ltifrData.forEach((item: any) => {
        if (item.jumlah_lti > 0 || item.jumlah_fatality > 0) {
          const tanggalStr = `${item.periode_bulan}-01`
          incidents.push({
            no: counter++,
            tanggal: tanggalStr,
            uraian: item.deskripsi_kecelakaan || `LTI: ${item.jumlah_lti}, Fatality: ${item.jumlah_fatality}`,
            faktor_penyebab: 'Kecelakaan Kerja',
            lokasi: item.units?.nama || '-',
            klasifikasi: item.jumlah_fatality > 0 ? 'Fatality' : 'Lost Time Injury',
            tingkat_keparahan: item.jumlah_fatality > 0 ? 'Critical' : 'High'
          })
        }
      })
    }

    // 3. Safety Drill - Korban Simulasi
    const { data: drillData } = await supabase
      .from('safety_drill')
      .select('tanggal_drill, judul_drill, skenario, area_lokasi, units(nama), ada_korban_simulasi, detail_korban')
      .gte('tanggal_drill', startDate)
      .lt('tanggal_drill', endDate)
      .eq('ada_korban_simulasi', true)
      .order('tanggal_drill', { ascending: false })

    if (drillData) {
      drillData.forEach((item: any) => {
        incidents.push({
          no: counter++,
          tanggal: item.tanggal_drill,
          uraian: `Simulasi: ${item.judul_drill}`,
          faktor_penyebab: item.skenario || 'Latihan Emergency',
          lokasi: `${item.area_lokasi} - ${item.units?.nama || ''}`,
          klasifikasi: 'Simulasi Drill',
          tingkat_keparahan: 'Training'
        })
      })
    }

    // 4. Safety Patrol - Unsafe Condition
    const { data: patrolData } = await supabase
      .from('safety_patrol')
      .select('tanggal_patrol, area_patrol, temuan, tindakan_koreksi, units(nama)')
      .gte('tanggal_patrol', startDate)
      .lt('tanggal_patrol', endDate)
      .not('temuan', 'is', null)
      .order('tanggal_patrol', { ascending: false })

    if (patrolData) {
      patrolData.forEach((item: any) => {
        if (item.temuan && item.temuan.length > 0) {
          incidents.push({
            no: counter++,
            tanggal: item.tanggal_patrol,
            uraian: Array.isArray(item.temuan) ? item.temuan.join(', ') : item.temuan,
            faktor_penyebab: 'Temuan Patrol',
            lokasi: `${item.area_patrol} - ${item.units?.nama || ''}`,
            klasifikasi: 'Temuan Safety Patrol',
            tingkat_keparahan: 'Medium'
          })
        }
      })
    }

    // Sort by date descending
    incidents.sort((a, b) => new Date(b.tanggal).getTime() - new Date(a.tanggal).getTime())
    
    // Renumber after sorting
    incidents.forEach((item, index) => {
      item.no = index + 1
    })

    insidenData.value = incidents

  } catch (error) {
    console.error('Error loading insiden data:', error)
  } finally {
    loadingInsiden.value = false
  }
}

async function loadSafetyAlertData(startDate: string, endDate: string, unitFilter: string = 'all') {
  loadingSafetyAlert.value = true
  try {
    const alerts: SafetyAlertData[] = []
    let counter = 1
    
    console.log('Loading Safety Alert Data for:', startDate, 'to', endDate)

    // 1. Unsafe Action/Condition - Most complete source
    let unsafeQuery = supabase
      .from('unsafe_action_condition')
      .select(`
        tanggal_kejadian,
        deskripsi_kejadian,
        lokasi_kejadian,
        penyebab_diduga,
        jenis_kejadian,
        tindakan_segera,
        rekomendasi_koreksi,
        korban_ada,
        korban_jumlah,
        pelapor_nama,
        temuan_investigasi,
        prioritas,
        unit_kerja,
        unit_id
      `)
      .gte('tanggal_kejadian', startDate)
      .lt('tanggal_kejadian', endDate)
      .order('tanggal_kejadian', { ascending: false })
    
    if (unitFilter !== 'all') {
      unsafeQuery = unsafeQuery.eq('unit_id', unitFilter)
    }
    
    const { data: unsafeData } = await unsafeQuery

    console.log('Unsafe Action/Condition data:', unsafeData?.length || 0, 'records')
    
    if (unsafeData) {
      unsafeData.forEach((item: any) => {
        const rekomendasi = Array.isArray(item.rekomendasi_koreksi) 
          ? item.rekomendasi_koreksi.join('; ') 
          : item.rekomendasi_koreksi || ''
        
        alerts.push({
          no: counter++,
          what: item.deskripsi_kejadian || (item.jenis_kejadian === 'unsafe_action' ? 'Unsafe Action terdeteksi' : 'Unsafe Condition ditemukan'),
          when: item.tanggal_kejadian,
          where: item.lokasi_kejadian || item.unit_kerja || '-',
          who: item.korban_ada ? (item.pelapor_nama || `${item.korban_jumlah || 1} karyawan`) : 'Tidak ada korban',
          why: item.penyebab_diduga || '-',
          how: item.deskripsi_kejadian || '-',
          howMuch: {
            people: item.korban_ada ? `${item.korban_jumlah || 1} orang terdampak` : 'Tidak ada korban',
            property: item.prioritas === 'high' || item.prioritas === 'critical' ? 'Potensi kerusakan aset' : 'Tidak ada kerusakan',
            security: 'Tidak ada dampak security',
            environment: item.jenis_kejadian === 'unsafe_condition' ? 'Potensi dampak lingkungan' : 'Tidak ada dampak lingkungan'
          },
          followUp: `${item.tindakan_segera || ''} ${rekomendasi}`.trim() || 'Menunggu tindak lanjut',
          lessonLearned: {
            people: item.temuan_investigasi || 'Perlu peningkatan awareness keselamatan',
            paper: 'Review dan update prosedur K3',
            place: 'Perbaikan kondisi area kerja'
          },
          sumber: 'Unsafe Action/Condition'
        })
      })
    }

    // 2. LTIFR Records - Actual workplace accidents
    const { data: ltifrData } = await supabase
      .from('ltifr_records')
      .select('periode_bulan, jumlah_lti, jumlah_fatality, deskripsi_kecelakaan, tindakan_perbaikan, units(nama)')
      .gte('periode_bulan', startDate.substring(0, 7))
      .lte('periode_bulan', endDate.substring(0, 7))
      .order('periode_bulan', { ascending: false })

    console.log('LTIFR data:', ltifrData?.length || 0, 'records')
    
    if (ltifrData) {
      ltifrData.forEach((item: any) => {
        if (item.jumlah_lti > 0 || item.jumlah_fatality > 0) {
          const tanggalStr = `${item.periode_bulan}-01`
          alerts.push({
            no: counter++,
            what: item.jumlah_fatality > 0 ? 'Kecelakaan Kerja Fatal' : 'Kecelakaan Kerja dengan LTI',
            when: tanggalStr,
            where: item.units?.nama || '-',
            who: `${item.jumlah_lti + item.jumlah_fatality} karyawan`,
            why: 'Dalam investigasi',
            how: item.deskripsi_kecelakaan || `LTI: ${item.jumlah_lti}, Fatality: ${item.jumlah_fatality}`,
            howMuch: {
              people: `${item.jumlah_lti} LTI, ${item.jumlah_fatality} Fatality`,
              property: 'Evaluasi kerusakan aset',
              security: 'Tidak ada dampak security',
              environment: 'Tidak ada dampak lingkungan'
            },
            followUp: item.tindakan_perbaikan || 'Investigasi kecelakaan sedang berlangsung',
            lessonLearned: {
              people: 'Perlu pelatihan K3 komprehensif',
              paper: 'Review SOP dan JSA',
              place: 'Evaluasi kondisi tempat kerja'
            },
            sumber: 'LTIFR Records'
          })
        }
      })
    }

    // 3. Management Walkthrough - Leadership inspection findings
    const { data: walkthroughData } = await supabase
      .from('management_walkthrough')
      .select(`
        tanggal_walkthrough,
        area_inspeksi,
        ringkasan_observasi,
        rekomendasi,
        praktek_baik,
        catatan_khusus,
        units(nama)
      `)
      .gte('tanggal_walkthrough', startDate)
      .lt('tanggal_walkthrough', endDate)
      .not('ringkasan_observasi', 'is', null)
      .order('tanggal_walkthrough', { ascending: false })

    console.log('Management Walkthrough data:', walkthroughData?.length || 0, 'records')
    
    if (walkthroughData) {
      walkthroughData.forEach((item: any) => {
        if (item.ringkasan_observasi) {
          alerts.push({
            no: counter++,
            what: 'Temuan Management Walkthrough',
            when: item.tanggal_walkthrough,
            where: `${item.area_inspeksi} - ${item.units?.nama || ''}`,
            who: 'Tim Management',
            why: 'Inspeksi rutin manajemen',
            how: item.ringkasan_observasi,
            howMuch: {
              people: 'Potensi dampak ke karyawan',
              property: 'Evaluasi risiko aset',
              security: 'Tidak ada dampak security',
              environment: 'Evaluasi dampak lingkungan'
            },
            followUp: Array.isArray(item.rekomendasi) ? item.rekomendasi.join(', ') : item.rekomendasi || 'Rekomendasi perbaikan',
            lessonLearned: {
              people: item.catatan_khusus || 'Peningkatan kompetensi K3',
              paper: item.praktek_baik ? `Best Practice: ${Array.isArray(item.praktek_baik) ? item.praktek_baik.join(', ') : item.praktek_baik}` : 'Update prosedur',
              place: 'Perbaikan area kerja'
            },
            sumber: 'Management Walkthrough'
          })
        }
      })
    }

    // 4. Safety Patrol - Regular patrol findings
    const { data: patrolData } = await supabase
      .from('safety_patrol')
      .select(`
        tanggal_patrol,
        area_patrol,
        catatan_patrol,
        rekomendasi,
        units(nama)
      `)
      .gte('tanggal_patrol', startDate)
      .lt('tanggal_patrol', endDate)
      .not('catatan_patrol', 'is', null)
      .order('tanggal_patrol', { ascending: false })

    console.log('Safety Patrol data:', patrolData?.length || 0, 'records')
    
    if (patrolData) {
      patrolData.forEach((item: any) => {
        if (item.catatan_patrol) {
          alerts.push({
            no: counter++,
            what: 'Temuan Safety Patrol',
            when: item.tanggal_patrol,
            where: `${item.area_patrol} - ${item.units?.nama || ''}`,
            who: 'Tim Safety Patrol',
            why: 'Patrol rutin keselamatan',
            how: item.catatan_patrol,
            howMuch: {
              people: 'Potensi risiko karyawan',
              property: 'Evaluasi dampak aset',
              security: 'Tidak ada dampak security',
              environment: 'Tidak ada dampak lingkungan'
            },
            followUp: Array.isArray(item.rekomendasi) ? item.rekomendasi.join(', ') : item.rekomendasi || 'Tindakan koreksi',
            lessonLearned: {
              people: 'Awareness keselamatan',
              paper: 'Review prosedur patrol',
              place: 'Evaluasi area patrol'
            },
            sumber: 'Safety Patrol'
          })
        }
      })
    }

    // 5. Safety Drill - Emergency simulation with lessons
    const { data: drillData } = await supabase
      .from('safety_drill')
      .select(`
        tanggal_drill,
        judul_drill,
        skenario,
        area_lokasi,
        hasil_debriefing,
        rekomendasi,
        improvement_areas,
        catatan_next_drill,
        unit_id,
        unit_kerja
      `)
      .gte('tanggal_drill', startDate)
      .lt('tanggal_drill', endDate)
      .in('status', ['completed', 'in_progress'])
      .order('tanggal_drill', { ascending: false })

    console.log('Safety Drill data:', drillData?.length || 0, 'records')
    
    if (drillData) {
      drillData.forEach((item: any) => {
        const improvementText = Array.isArray(item.improvement_areas) 
          ? item.improvement_areas.join('; ') 
          : item.improvement_areas || ''
        const rekomendasiText = Array.isArray(item.rekomendasi)
          ? item.rekomendasi.join('; ')
          : item.rekomendasi || ''
          
        alerts.push({
          no: counter++,
          what: `Simulasi: ${item.judul_drill}`,
          when: item.tanggal_drill,
          where: `${item.area_lokasi} - ${item.unit_kerja || ''}`,
          who: 'Peserta Drill',
          why: 'Pelatihan kesiapsiagaan darurat',
          how: item.skenario || item.hasil_debriefing || '-',
          howMuch: {
            people: 'Simulasi training',
            property: 'Tidak ada kerusakan',
            security: 'Tidak ada dampak security',
            environment: 'Tidak ada dampak lingkungan'
          },
          followUp: rekomendasiText || item.catatan_next_drill || 'Drill berikutnya terjadwalkan',
          lessonLearned: {
            people: improvementText || 'Pembelajaran dari drill',
            paper: item.hasil_debriefing || 'Update prosedur emergency',
            place: 'Evaluasi kesiapan area'
          },
          sumber: 'Safety Drill'
        })
      })
    }

    // Sort by date descending
    alerts.sort((a, b) => new Date(b.when).getTime() - new Date(a.when).getTime())
    
    // Renumber after sorting
    alerts.forEach((item, index) => {
      item.no = index + 1
    })

    console.log('Total Safety Alert cards:', alerts.length)
    
    allSafetyAlertData.value = alerts
    safetyAlertData.value = alerts

  } catch (error) {
    console.error('Error loading safety alert data:', error)
  } finally {
    loadingSafetyAlert.value = false
  }
}

// Filter safety alert by selected module
function filterSafetyAlertByModule() {
  if (selectedSafetyAlertModule.value === 'all') {
    safetyAlertData.value = allSafetyAlertData.value
  } else {
    safetyAlertData.value = allSafetyAlertData.value.filter(
      alert => alert.sumber === selectedSafetyAlertModule.value
    )
  }
  
  // Renumber after filtering
  safetyAlertData.value.forEach((item, index) => {
    item.no = index + 1
  })
}

// Load units for filter dropdown
async function loadUnits() {
  try {
    const { data, error } = await supabase
      .from('units')
      .select('id, nama')
      .eq('aktif', true)
      .order('nama')
    
    if (error) throw error
    units.value = data || []
    console.log('Units loaded:', units.value.length, units.value)
  } catch (error) {
    console.error('Error loading units:', error)
    units.value = []
  }
}

// Load Rekap K3L data from all modules
async function loadRekapK3lData() {
  try {
    loadingRekapK3l.value = true
    
    // Use selectedMonth from main page filter
    const [yearStr, monthStr] = selectedMonth.value.split('-')
    const yearNum = parseInt(yearStr || '2024')
    const monthNum = parseInt(monthStr || '1')
    const unitFilter = rekapK3lUnit.value
    const startDate = `${yearNum}-${String(monthNum).padStart(2, '0')}-01`
    
    // Get last day of the month
    const lastDay = new Date(yearNum, monthNum, 0).getDate()
    const endDate = `${yearNum}-${String(monthNum).padStart(2, '0')}-${lastDay}`
    
    console.log('Loading Rekap K3L for:', { year: yearNum, month: monthNum, unit: unitFilter, startDate, endDate })
    
    const allData: any[] = []

    // 1. Safety Briefing
    try {
      let briefingQuery = supabase
        .from('safety_briefing')
        .select('tanggal, waktu_mulai, topik, petugas_id, jumlah_peserta, lokasi, unit_id')
        .gte('tanggal', startDate)
        .lte('tanggal', endDate)
      
      if (unitFilter !== 'all') {
        briefingQuery = briefingQuery.eq('unit_id', unitFilter)
      }
      
      const { data: briefingData, error: briefingError } = await briefingQuery
      
      console.log('Safety Briefing:', briefingData?.length || 0, 'records', briefingError)
      
      if (briefingData) {
        briefingData.forEach(item => {
          allData.push({
            tanggal: item.tanggal,
            modul: 'Safety Briefing',
            kegiatan: item.topik,
            dokumentasi: 'Tidak Ada',
            jam: item.waktu_mulai,
            pimpinan: '-',
            peserta: item.jumlah_peserta || 0,
            tempat: item.lokasi || '-',
            keterangan: '-'
          })
        })
      }
    } catch (e) {
      console.error('Error loading Safety Briefing:', e)
    }

    // 2. Safety Patrol
    try {
      let patrolQuery = supabase
        .from('safety_patrol')
        .select('tanggal_patrol, waktu_mulai, area_patrol, ketua_patrol, jumlah_anggota, unit_id')
        .gte('tanggal_patrol', startDate)
        .lte('tanggal_patrol', endDate)
      
      if (unitFilter !== 'all') {
        patrolQuery = patrolQuery.eq('unit_id', unitFilter)
      }
      
      const { data: patrolData, error: patrolError } = await patrolQuery
      
      console.log('Safety Patrol:', patrolData?.length || 0, 'records', patrolError)
      
      if (patrolData) {
        patrolData.forEach(item => {
          allData.push({
            tanggal: item.tanggal_patrol,
            modul: 'Safety Patrol',
            kegiatan: `Safety Patrol - ${item.area_patrol}`,
            dokumentasi: 'Tidak Ada',
            jam: item.waktu_mulai || '-',
            pimpinan: item.ketua_patrol || '-',
            peserta: item.jumlah_anggota || 0,
            tempat: item.area_patrol || '-',
            keterangan: '-'
          })
        })
      }
    } catch (e) {
      console.error('Error loading Safety Patrol:', e)
    }

    // 3. Safety Drill
    try {
      let drillQuery = supabase
        .from('safety_drill')
        .select('tanggal_drill, waktu_mulai, tujuan_drill, drill_commander, jumlah_peserta, area_lokasi, unit_id')
        .gte('tanggal_drill', startDate)
        .lte('tanggal_drill', endDate)
      
      if (unitFilter !== 'all') {
        drillQuery = drillQuery.eq('unit_id', unitFilter)
      }
      
      const { data: drillData, error: drillError } = await drillQuery
      
      console.log('Safety Drill:', drillData?.length || 0, 'records', drillError)
      
      if (drillData) {
        drillData.forEach(item => {
          allData.push({
            tanggal: item.tanggal_drill,
            modul: 'Safety Drill',
            kegiatan: item.tujuan_drill,
            dokumentasi: 'Tidak Ada',
            jam: item.waktu_mulai || '-',
            pimpinan: item.drill_commander || '-',
            peserta: item.jumlah_peserta || 0,
            tempat: item.area_lokasi || '-',
            keterangan: '-'
          })
        })
      }
    } catch (e) {
      console.error('Error loading Safety Drill:', e)
    }

    // 4. Safety Forum
    try {
      let forumQuery = supabase
        .from('safety_forum')
        .select('tanggal_forum, waktu_mulai, agenda_utama, jumlah_peserta, lokasi, unit_id')
        .gte('tanggal_forum', startDate)
        .lte('tanggal_forum', endDate)
      
      if (unitFilter !== 'all') {
        forumQuery = forumQuery.eq('unit_id', unitFilter)
      }
      
      const { data: forumData, error: forumError } = await forumQuery
      
      console.log('Safety Forum:', forumData?.length || 0, 'records', forumError)
      
      if (forumData) {
        forumData.forEach(item => {
          allData.push({
            tanggal: item.tanggal_forum,
            modul: 'Safety Forum',
            kegiatan: item.agenda_utama,
            dokumentasi: 'Tidak Ada',
            jam: item.waktu_mulai || '-',
            pimpinan: '-',
            peserta: item.jumlah_peserta || 0,
            tempat: item.lokasi || '-',
            keterangan: '-'
          })
        })
      }
    } catch (e) {
      console.error('Error loading Safety Forum:', e)
    }

    // 5. Safety Induction
    try {
      let inductionQuery = supabase
        .from('safety_induction')
        .select('tanggal_induction, waktu_mulai, nama_peserta, instruktur_utama, lokasi_induction, perusahaan, unit_id')
        .gte('tanggal_induction', startDate)
        .lte('tanggal_induction', endDate)
      
      if (unitFilter !== 'all') {
        inductionQuery = inductionQuery.eq('unit_id', unitFilter)
      }
      
      const { data: inductionData, error: inductionError } = await inductionQuery
      
      console.log('Safety Induction:', inductionData?.length || 0, 'records', inductionError)
      
      if (inductionData) {
        inductionData.forEach(item => {
          allData.push({
            tanggal: item.tanggal_induction,
            modul: 'Safety Induction',
            kegiatan: `Safety Induction - ${item.nama_peserta}`,
            dokumentasi: 'Tidak Ada',
            jam: item.waktu_mulai || '-',
            pimpinan: item.instruktur_utama || '-',
            peserta: 1,
            tempat: item.lokasi_induction || '-',
            keterangan: item.perusahaan || '-'
          })
        })
      }
    } catch (e) {
      console.error('Error loading Safety Induction:', e)
    }

    // 6. Silent Inspection
    try {
      let inspectionQuery = supabase
        .from('silent_inspection')
        .select('tanggal, waktu_mulai, area_inspeksi, tingkat_risiko, unit_id')
        .gte('tanggal', startDate)
        .lte('tanggal', endDate)
      
      if (unitFilter !== 'all') {
        inspectionQuery = inspectionQuery.eq('unit_id', unitFilter)
      }
      
      const { data: inspectionData, error: inspectionError } = await inspectionQuery
      
      console.log('Silent Inspection:', inspectionData?.length || 0, 'records', inspectionError)
      
      if (inspectionData) {
        inspectionData.forEach(item => {
          allData.push({
            tanggal: item.tanggal,
            modul: 'Silent Inspection',
            kegiatan: `Silent Inspection - ${item.area_inspeksi || 'Area'}`,
            dokumentasi: 'Tidak Ada',
            jam: item.waktu_mulai || '-',
            pimpinan: '-',
            peserta: 0,
            tempat: item.area_inspeksi || '-',
            keterangan: item.tingkat_risiko || '-'
          })
        })
      }
    } catch (e) {
      console.error('Error loading Silent Inspection:', e)
    }

    // 7. Management Walkthrough
    try {
      let walkthroughQuery = supabase
        .from('management_walkthrough')
        .select('tanggal_walkthrough, waktu_mulai, area_inspeksi, pimpinan_walkthrough, jumlah_tim, unit_id')
        .gte('tanggal_walkthrough', startDate)
        .lte('tanggal_walkthrough', endDate)
      
      if (unitFilter !== 'all') {
        walkthroughQuery = walkthroughQuery.eq('unit_id', unitFilter)
      }
      
      const { data: walkthroughData, error: walkthroughError } = await walkthroughQuery
      
      console.log('Management Walkthrough:', walkthroughData?.length || 0, 'records', walkthroughError)
      
      if (walkthroughData) {
        walkthroughData.forEach(item => {
          allData.push({
            tanggal: item.tanggal_walkthrough,
            modul: 'Management Walkthrough',
            kegiatan: `Management Walkthrough - ${item.area_inspeksi}`,
            dokumentasi: 'Tidak Ada',
            jam: item.waktu_mulai || '-',
            pimpinan: item.pimpinan_walkthrough || '-',
            peserta: item.jumlah_tim || 0,
            tempat: item.area_inspeksi || '-',
            keterangan: '-'
          })
        })
      }
    } catch (e) {
      console.error('Error loading Management Walkthrough:', e)
    }

    // Sort by date descending and add row numbers
    allData.sort((a, b) => new Date(b.tanggal).getTime() - new Date(a.tanggal).getTime())
    
    rekapK3lData.value = allData.map((item, index) => ({
      no: index + 1,
      modul: item.modul,
      kegiatan: item.kegiatan,
      dokumentasi: item.dokumentasi,
      hari_tanggal: item.tanggal,
      jam: item.jam,
      pimpinan: item.pimpinan,
      peserta: item.peserta,
      tempat: item.tempat,
      keterangan: item.keterangan
    }))

    console.log(`✅ Loaded ${rekapK3lData.value.length} total activities from all modules`)
    console.log('Module breakdown:', allData.reduce((acc, item) => {
      acc[item.modul] = (acc[item.modul] || 0) + 1
      return acc
    }, {} as Record<string, number>))
  } catch (error) {
    console.error('Error loading Rekap K3L data:', error)
    rekapK3lData.value = []
  } finally {
    loadingRekapK3l.value = false
  }
}

// Get month name in Bahasa Indonesia
function getMonthName(month: number): string {
  const months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ]
  return months[month - 1] || ''
}

// Helper to get formatted period display from selectedMonth
function getFormattedPeriod(): string {
  const [yearStr, monthStr] = selectedMonth.value.split('-')
  const monthNum = parseInt(monthStr || '1')
  const year = yearStr || '2024'
  return `[${getMonthName(monthNum)}] ${year}`
}

// Get badge color class for module
function getModuleBadgeClass(modul: string): string {
  switch (modul) {
    case 'Safety Briefing':
      return 'badge-blue'
    case 'Safety Patrol':
      return 'badge-green'
    case 'Safety Drill':
      return 'badge-red'
    case 'Safety Forum':
      return 'badge-orange'
    case 'Safety Induction':
      return 'badge-purple'
    case 'Silent Inspection':
      return 'badge-indigo'
    case 'Management Walkthrough':
      return 'badge-teal'
    default:
      return 'badge-gray'
  }
}

function formatDate(dateStr: string): string {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return date.toLocaleDateString('id-ID', { 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  })
}

function getKeparahanColor(tingkat: string): string {
  const colors: Record<string, string> = {
    'critical': 'bg-red-100 text-red-800',
    'high': 'bg-orange-100 text-orange-800',
    'medium': 'bg-yellow-100 text-yellow-800',
    'low': 'bg-green-100 text-green-800',
    'training': 'bg-blue-100 text-blue-800'
  }
  return colors[tingkat.toLowerCase()] || 'bg-gray-100 text-gray-800'
}

async function countRecords(
  tableName: string,
  dateColumn: string,
  startDate: string,
  endDate: string,
  unitFilter: string = 'all'
): Promise<number> {
  try {
    let query = supabase
      .from(tableName)
      .select('*', { count: 'exact', head: true })
      .gte(dateColumn, startDate)
      .lt(dateColumn, endDate)
    
    if (unitFilter !== 'all') {
      query = query.eq('unit_id', unitFilter)
    }

    const { count, error } = await query

    if (error) throw error
    return count || 0
  } catch (error) {
    console.error(`Error counting ${tableName}:`, error)
    return 0
  }
}

// Update selectedMonth when year or month changes
function updateSelectedMonth() {
  selectedMonth.value = `${selectedYear.value}-${String(selectedMonthNum.value).padStart(2, '0')}`
  loadData()
}

onMounted(async () => {
  await loadUnits() // Load units first
  await loadData()
})
</script>

<template>
  <div class="program-k3-dashboard">
    <!-- Header -->
    <div class="dashboard-header">
      <div class="header-content">
        <h1 class="title">
          Realisasi Program K3 
          <span class="subtitle">(s.d <span class="highlight">{{ new Date(selectedMonth).toLocaleDateString('id-ID', { month: 'long' }) }}</span> 2025)</span>
        </h1>
      </div>
      
      <!-- Unit & Month Filter -->
      <div class="filter-section">
        <div class="filter-group">
          <label for="unit">Unit:</label>
          <select 
            id="unit"
            v-model="rekapK3lUnit" 
            @change="loadData"
            class="filter-select"
          >
            <option value="all">Semua Unit</option>
            <option v-for="unit in units" :key="unit.id" :value="unit.id">
              {{ unit.nama }}
            </option>
          </select>
        </div>
        <div class="filter-group">
          <label for="year">Tahun:</label>
          <select 
            id="year"
            v-model="selectedYear" 
            @change="updateSelectedMonth"
            class="filter-select"
          >
            <option :value="2025">2025</option>
            <option :value="2024">2024</option>
            <option :value="2023">2023</option>
          </select>
        </div>
        <div class="filter-group">
          <label for="month">Bulan:</label>
          <select 
            id="month"
            v-model="selectedMonthNum" 
            @change="updateSelectedMonth"
            class="filter-select"
          >
            <option :value="1">Januari</option>
            <option :value="2">Februari</option>
            <option :value="3">Maret</option>
            <option :value="4">April</option>
            <option :value="5">Mei</option>
            <option :value="6">Juni</option>
            <option :value="7">Juli</option>
            <option :value="8">Agustus</option>
            <option :value="9">September</option>
            <option :value="10">Oktober</option>
            <option :value="11">November</option>
            <option :value="12">Desember</option>
          </select>
        </div>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="loading">
      <div class="spinner"></div>
      <p>Memuat data...</p>
    </div>

    <!-- Program Cards Grid -->
    <div v-else class="programs-grid">
      <div 
        v-for="program in programs" 
        :key="program.id" 
        class="program-card"
      >
        <div class="program-icon">{{ program.icon }}</div>
        <h3 class="program-name">{{ program.name }}</h3>
        <div class="realization-box">
          <span class="realization-value">{{ program.realization }}</span>
        </div>
        <p class="program-target">{{ program.target }}</p>
      </div>
    </div>

    <!-- Data Insiden Table -->
    <div v-if="!loading" class="insiden-section">
      <div class="insiden-header">
        <h2 class="insiden-title">Data Insiden (periode {{ new Date(selectedMonth).toLocaleDateString('id-ID', { month: 'long', year: 'numeric' }) }})</h2>
      </div>

      <div v-if="loadingInsiden" class="loading-insiden">
        <div class="spinner-small"></div>
        <p>Memuat data insiden...</p>
      </div>

      <div v-else-if="insidenData.length === 0" class="no-data">
        <p>Tidak ada data insiden untuk periode ini</p>
      </div>

      <div v-else class="table-container">
        <table class="insiden-table">
          <thead>
            <tr>
              <th class="th-no">NO</th>
              <th class="th-tanggal">TANGGAL</th>
              <th class="th-uraian">URAIAN</th>
              <th class="th-faktor">FAKTOR PENYEBAB</th>
              <th class="th-lokasi">LOKASI</th>
              <th class="th-klasifikasi">KLASIFIKASI I*</th>
              <th class="th-tingkat">TINGKAT KEPARAHAN*</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in insidenData" :key="item.no">
              <td class="text-center">{{ item.no }}</td>
              <td class="text-center">{{ formatDate(item.tanggal) }}</td>
              <td>{{ item.uraian }}</td>
              <td>{{ item.faktor_penyebab }}</td>
              <td>{{ item.lokasi }}</td>
              <td class="text-center">
                <span :class="['badge', getKeparahanColor(item.tingkat_keparahan)]">
                  {{ item.klasifikasi }}
                </span>
              </td>
              <td class="text-center">
                <span :class="['badge', getKeparahanColor(item.tingkat_keparahan)]">
                  {{ item.tingkat_keparahan }}
                </span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Safety Alert Section -->
    <div class="safety-alert-section">
      <div class="safety-alert-header">
        <div>
          <h2 class="safety-alert-title">SAFETY ALERT</h2>
          <p class="safety-alert-subtitle">Comprehensive Safety Information & Lesson Learned</p>
        </div>
        
        <!-- Filter Dropdown -->
        <div class="filter-container">
          <label for="module-filter" class="filter-label">Filter by Module:</label>
          <select 
            id="module-filter"
            v-model="selectedSafetyAlertModule" 
            @change="filterSafetyAlertByModule"
            class="filter-select"
          >
            <option value="all">Semua Modul ({{ allSafetyAlertData.length }})</option>
            <option value="Unsafe Action/Condition">Unsafe Action/Condition</option>
            <option value="LTIFR Records">LTIFR Records</option>
            <option value="Management Walkthrough">Management Walkthrough</option>
            <option value="Safety Patrol">Safety Patrol</option>
            <option value="Safety Drill">Safety Drill</option>
          </select>
          <span class="filter-count">{{ safetyAlertData.length }} data ditampilkan</span>
        </div>
      </div>

      <div v-if="loadingSafetyAlert" class="loading-insiden">
        <div class="spinner-small"></div>
        <p>Memuat data Safety Alert...</p>
      </div>

      <div v-else-if="safetyAlertData.length === 0" class="no-data">
        <p>Tidak ada data Safety Alert untuk periode ini</p>
      </div>

      <div v-else class="safety-alert-cards">
        <div v-for="alert in safetyAlertData" :key="alert.no" class="safety-alert-card">
          <div class="alert-header-row">
            <div class="alert-number">{{ alert.no }}</div>
            <div class="alert-source">{{ alert.sumber }}</div>
          </div>

          <div class="alert-content">
            <!-- Left Column: Main Info -->
            <div class="alert-main">
              <div class="alert-field">
                <div class="field-label">WHAT</div>
                <div class="field-value">{{ alert.what }}</div>
              </div>

              <div class="alert-field">
                <div class="field-label">WHEN</div>
                <div class="field-value">{{ formatDate(alert.when) }}</div>
              </div>

              <div class="alert-field">
                <div class="field-label">WHERE</div>
                <div class="field-value">{{ alert.where }}</div>
              </div>

              <div class="alert-field">
                <div class="field-label">WHO</div>
                <div class="field-value">{{ alert.who }}</div>
              </div>

              <div class="alert-field">
                <div class="field-label">WHY</div>
                <div class="field-value">{{ alert.why }}</div>
              </div>

              <div class="alert-field">
                <div class="field-label">HOW</div>
                <div class="field-value">{{ alert.how }}</div>
              </div>

              <div class="alert-field">
                <div class="field-label">HOW MUCH</div>
                <div class="field-value">
                  <div class="how-much-grid">
                    <div class="how-much-item">
                      <strong>People:</strong> {{ alert.howMuch.people }}
                    </div>
                    <div class="how-much-item">
                      <strong>Property:</strong> {{ alert.howMuch.property }}
                    </div>
                    <div class="how-much-item">
                      <strong>Security:</strong> {{ alert.howMuch.security }}
                    </div>
                    <div class="how-much-item">
                      <strong>Environment:</strong> {{ alert.howMuch.environment }}
                    </div>
                  </div>
                </div>
              </div>

              <div class="alert-field">
                <div class="field-label">FOLLOW UP</div>
                <div class="field-value">{{ alert.followUp }}</div>
              </div>
            </div>

            <!-- Right Column: Lesson Learned -->
            <div class="alert-lessons">
              <div class="lessons-header">LESSON LEARNED</div>
              
              <div class="lesson-item">
                <div class="lesson-label">
                  <span class="lesson-icon">👥</span>
                  PEOPLE
                </div>
                <div class="lesson-value">{{ alert.lessonLearned.people }}</div>
              </div>

              <div class="lesson-item">
                <div class="lesson-label">
                  <span class="lesson-icon">📄</span>
                  PAPER
                </div>
                <div class="lesson-value">{{ alert.lessonLearned.paper }}</div>
              </div>

              <div class="lesson-item">
                <div class="lesson-label">
                  <span class="lesson-icon">📍</span>
                  PLACE
                </div>
                <div class="lesson-value">{{ alert.lessonLearned.place }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Rekap Implementasi K3L Section -->
    <div class="rekap-k3l-section">
      <div class="rekap-k3l-header">
        <div>
          <h2 class="rekap-k3l-title">
            Rekan Implementasi K3L 
            <span class="periode-badge">(periode {{ getFormattedPeriod() }})</span>
          </h2>
        </div>
        
        <!-- Filter count only -->
        <div class="filter-container">
          <span class="filter-count">{{ rekapK3lData.length }} kegiatan</span>
        </div>
      </div>

      <div v-if="loadingRekapK3l" class="loading-insiden">
        <div class="spinner-small"></div>
        <p>Memuat data Rekap K3L...</p>
      </div>

      <div v-else-if="rekapK3lData.length === 0" class="no-data">
        <p>Tidak ada data Rekap K3L untuk tahun {{ rekapK3lYear }}</p>
      </div>

      <div v-else class="rekap-table-wrapper">
        <table class="rekap-table">
          <thead>
            <tr>
              <th class="col-no">NO</th>
              <th class="col-modul">MODUL</th>
              <th class="col-kegiatan">KEGIATAN</th>
              <th class="col-dokumentasi">DOKUMENTASI</th>
              <th class="col-uraian">URAIAN</th>
              <th class="col-keterangan">KETERANGAN</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in rekapK3lData" :key="item.no">
              <td class="text-center">{{ item.no }}</td>
              <td class="modul-cell">
                <span class="modul-badge" :class="getModuleBadgeClass(item.modul)">
                  {{ item.modul }}
                </span>
              </td>
              <td>{{ item.kegiatan }}</td>
              <td class="text-center">{{ item.dokumentasi }}</td>
              <td class="uraian-cell">
                <div class="uraian-content">
                  <div class="uraian-row"><strong>Hari/Tgl:</strong> {{ formatDate(item.hari_tanggal) }}</div>
                  <div class="uraian-row"><strong>Jam:</strong> {{ item.jam }}</div>
                  <div class="uraian-row"><strong>Pimpinan:</strong> {{ item.pimpinan }}</div>
                  <div class="uraian-row"><strong>Peserta:</strong> {{ item.peserta }}</div>
                  <div class="uraian-row"><strong>Tempat:</strong> {{ item.tempat }}</div>
                  <div class="uraian-row"><strong>Keterangan:</strong> {{ item.keterangan }}</div>
                </div>
              </td>
              <td class="text-center">{{ item.keterangan }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Footer Note -->
    <!-- <div class="footer-note">
      *Cek kesesuaian pada <strong>Dashboard Safira</strong>
    </div> -->
  </div>
</template>

<style scoped>
.program-k3-dashboard {
  padding: 1.5rem;
  background: linear-gradient(135deg, #0066cc 0%, #004c99 100%);
  min-height: 100vh;
}

.dashboard-header {
  text-align: center;
  margin-bottom: 2rem;
  color: white;
}

.header-content {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 2rem;
  margin-bottom: 1.5rem;
}

.logo {
  height: 60px;
}

.title {
  font-size: 2rem;
  font-weight: 700;
  margin: 0;
  color: white;
}

.subtitle {
  font-size: 1.25rem;
  font-weight: 600;
}

.highlight {
  color: #ff6b6b;
  font-weight: 700;
}

.filter-section {
  display: flex;
  align-items: flex-end;
  justify-content: center;
  gap: 1.5rem;
  margin-top: 1.5rem;
}

.filter-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.filter-section label {
  color: white;
  font-weight: 600;
  font-size: 0.95rem;
}

.filter-select {
  padding: 0.6rem 1rem;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-radius: 8px;
  background: white;
  color: #1e293b;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  min-width: 150px;
}

.filter-select:hover {
  border-color: rgba(255, 255, 255, 0.6);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.filter-select:focus {
  outline: none;
  border-color: white;
  box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.2);
}

.loading {
  text-align: center;
  padding: 4rem;
  color: white;
}

.spinner {
  width: 50px;
  height: 50px;
  border: 4px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 1rem;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.programs-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 1rem;
  max-width: 1200px;
  margin: 0 auto;
}

.program-card {
  background: white;
  border-radius: 10px;
  padding: 0.875rem 0.75rem;
  text-align: center;
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.program-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
}

.program-icon {
  font-size: 2rem;
  margin-bottom: 0.5rem;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
}

.program-name {
  font-size: 0.875rem;
  font-weight: 600;
  color: #1e40af;
  margin: 0 0 0.75rem 0;
  min-height: 2.2rem;
  display: flex;
  align-items: center;
  justify-content: center;
  line-height: 1.2;
}

.realization-box {
  background: #1e40af;
  border-radius: 6px;
  padding: 0.75rem;
  margin-bottom: 0.625rem;
  box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.1);
}

.realization-value {
  font-size: 1.625rem;
  font-weight: 700;
  color: white;
  display: block;
}

.program-target {
  font-size: 0.7rem;
  color: #64748b;
  margin: 0;
  line-height: 1.2;
}

/* Insiden Section */
.insiden-section {
  max-width: 1400px;
  margin: 3rem auto 2rem;
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.insiden-header {
  margin-bottom: 1.5rem;
  border-bottom: 3px solid #1e40af;
  padding-bottom: 1rem;
}

.insiden-title {
  font-size: 1.5rem;
  font-weight: 700;
  color: #1e40af;
  margin: 0;
}

.loading-insiden {
  text-align: center;
  padding: 2rem;
  color: #1e40af;
}

.spinner-small {
  width: 30px;
  height: 30px;
  border: 3px solid rgba(30, 64, 175, 0.3);
  border-top-color: #1e40af;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 0.5rem;
}

.no-data {
  text-align: center;
  padding: 2rem;
  color: #64748b;
  font-style: italic;
}

.table-container {
  overflow-x: auto;
  border-radius: 8px;
  border: 1px solid #e5e7eb;
}

.insiden-table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  font-size: 0.875rem;
}

.insiden-table thead {
  background: linear-gradient(135deg, #1e40af 0%, #1e3a8a 100%);
  color: white;
}

.insiden-table th {
  padding: 1rem 0.75rem;
  text-align: left;
  font-weight: 600;
  font-size: 0.75rem;
  letter-spacing: 0.5px;
  text-transform: uppercase;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.insiden-table .th-no {
  width: 50px;
  text-align: center;
}

.insiden-table .th-tanggal {
  width: 140px;
  text-align: center;
}

.insiden-table .th-uraian {
  min-width: 250px;
}

.insiden-table .th-faktor {
  min-width: 180px;
}

.insiden-table .th-lokasi {
  min-width: 150px;
}

.insiden-table .th-klasifikasi {
  width: 150px;
  text-align: center;
}

.insiden-table .th-tingkat {
  width: 150px;
  text-align: center;
}

.insiden-table tbody tr {
  border-bottom: 1px solid #e5e7eb;
  transition: background-color 0.2s;
}

.insiden-table tbody tr:hover {
  background-color: #f9fafb;
}

.insiden-table tbody tr:nth-child(even) {
  background-color: #f8fafc;
}

.insiden-table tbody tr:nth-child(even):hover {
  background-color: #f1f5f9;
}

.insiden-table td {
  padding: 0.875rem 0.75rem;
  border: 1px solid #e5e7eb;
  color: #374151;
  vertical-align: top;
}

.insiden-table .text-center {
  text-align: center;
}

.insiden-table .badge {
  display: inline-block;
  padding: 0.375rem 0.75rem;
  border-radius: 6px;
  font-size: 0.75rem;
  font-weight: 600;
  white-space: nowrap;
}

.footer-note {
  text-align: center;
  margin-top: 3rem;
  color: white;
  font-size: 1rem;
  font-style: italic;
}

.footer-note strong {
  font-weight: 700;
}

/* Safety Alert Section */
.safety-alert-section {
  max-width: 1400px;
  margin: 3rem auto 2rem;
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.safety-alert-header {
  margin-bottom: 1.5rem;
  border-bottom: 3px solid #dc2626;
  padding-bottom: 1rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem;
}

.safety-alert-header > div:first-child {
  flex: 1;
  min-width: 300px;
}

.filter-container {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  flex-wrap: wrap;
}

.filter-label {
  font-size: 0.95rem;
  font-weight: 600;
  color: #374151;
  white-space: nowrap;
}

.filter-select {
  padding: 0.5rem 1rem;
  border: 2px solid #dc2626;
  border-radius: 8px;
  font-size: 0.95rem;
  font-weight: 500;
  color: #374151;
  background-color: white;
  cursor: pointer;
  transition: all 0.3s ease;
  min-width: 220px;
}

.filter-select:hover {
  border-color: #b91c1c;
  box-shadow: 0 2px 8px rgba(220, 38, 38, 0.2);
}

.filter-select:focus {
  outline: none;
  border-color: #dc2626;
  box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.1);
}

.filter-count {
  font-size: 0.9rem;
  font-weight: 600;
  color: #dc2626;
  background-color: #fee2e2;
  padding: 0.4rem 0.8rem;
  border-radius: 6px;
}

.safety-alert-title {
  font-size: 1.75rem;
  font-weight: 700;
  color: #dc2626;
  margin: 0 0 0.5rem 0;
  text-transform: uppercase;
  letter-spacing: 1px;
  text-align: left;
}

.safety-alert-subtitle {
  font-size: 0.875rem;
  color: #64748b;
  margin: 0;
  text-align: left;
}

.safety-alert-cards {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.safety-alert-card {
  background: white;
  border: 2px solid #e5e7eb;
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
}

.safety-alert-card:hover {
  border-color: #dc2626;
  box-shadow: 0 4px 12px rgba(220, 38, 38, 0.15);
  transform: translateY(-2px);
}

.alert-header-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
  padding: 0.75rem 1.25rem;
  color: white;
}

.alert-number {
  font-size: 1.25rem;
  font-weight: 700;
  background: rgba(255, 255, 255, 0.2);
  padding: 0.25rem 0.75rem;
  border-radius: 6px;
}

.alert-source {
  font-size: 0.75rem;
  font-weight: 600;
  background: rgba(255, 255, 255, 0.2);
  padding: 0.375rem 0.75rem;
  border-radius: 6px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.alert-content {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: 1.5rem;
  padding: 1.5rem;
}

.alert-main {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  border-right: 2px solid #e5e7eb;
  padding-right: 1.5rem;
}

.alert-field {
  display: flex;
  gap: 1rem;
}

.field-label {
  font-weight: 700;
  color: #1e40af;
  min-width: 100px;
  font-size: 0.875rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.field-value {
  flex: 1;
  color: #374151;
  font-size: 0.875rem;
  line-height: 1.5;
}

.how-much-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 0.5rem;
}

.how-much-item {
  background: #f9fafb;
  padding: 0.5rem;
  border-radius: 4px;
  font-size: 0.8rem;
  border-left: 3px solid #1e40af;
}

.how-much-item strong {
  color: #1e40af;
  display: block;
  margin-bottom: 0.25rem;
}

.alert-lessons {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.lessons-header {
  font-size: 1.125rem;
  font-weight: 700;
  color: #dc2626;
  text-align: center;
  padding: 0.75rem;
  background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
  border-radius: 8px;
  text-transform: uppercase;
  letter-spacing: 1px;
  border: 2px solid #fecaca;
}

.lesson-item {
  background: #f9fafb;
  border-radius: 8px;
  padding: 1rem;
  border-left: 4px solid #dc2626;
  transition: all 0.2s ease;
}

.lesson-item:hover {
  background: #f3f4f6;
  border-left-width: 6px;
}

.lesson-label {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-weight: 700;
  color: #dc2626;
  font-size: 0.875rem;
  margin-bottom: 0.5rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.lesson-icon {
  font-size: 1.25rem;
}

.lesson-value {
  color: #374151;
  font-size: 0.875rem;
  line-height: 1.6;
  padding-left: 2rem;
}

/* Responsive */
@media (max-width: 768px) {
  .program-k3-dashboard {
    padding: 1rem;
  }

  .title {
    font-size: 1.5rem;
  }

  .subtitle {
    font-size: 1rem;
  }

  .programs-grid {
    grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
    gap: 0.75rem;
  }

  .program-card {
    padding: 0.75rem 0.5rem;
  }

  .program-icon {
    font-size: 1.5rem;
  }

  .program-name {
    font-size: 0.75rem;
    min-height: 1.8rem;
  }

  .realization-value {
    font-size: 1.25rem;
  }

  .program-target {
    font-size: 0.65rem;
  }

  .insiden-section {
    padding: 1rem;
    margin: 2rem 0.5rem 1rem;
  }

  .insiden-title {
    font-size: 1.25rem;
  }

  .insiden-table {
    font-size: 0.75rem;
  }

  .insiden-table th,
  .insiden-table td {
    padding: 0.5rem 0.375rem;
  }

  .insiden-table .badge {
    font-size: 0.65rem;
    padding: 0.25rem 0.5rem;
  }

  .safety-alert-section {
    padding: 1rem;
    margin: 2rem 0.5rem 1rem;
  }

  .safety-alert-title {
    font-size: 1.25rem;
  }

  .safety-alert-subtitle {
    font-size: 0.75rem;
  }

  .alert-content {
    grid-template-columns: 1fr;
    gap: 1rem;
  }

  .alert-main {
    border-right: none;
    border-bottom: 2px solid #e5e7eb;
    padding-right: 0;
    padding-bottom: 1rem;
  }

  .field-label {
    min-width: 80px;
    font-size: 0.75rem;
  }

  .field-value {
    font-size: 0.75rem;
  }

  .how-much-grid {
    grid-template-columns: 1fr;
  }

  .how-much-item {
    font-size: 0.7rem;
  }

  .lessons-header {
    font-size: 0.875rem;
    padding: 0.5rem;
  }

  .lesson-label {
    font-size: 0.75rem;
  }

  .lesson-value {
    font-size: 0.75rem;
    padding-left: 1.5rem;
  }

  .alert-header-row {
    padding: 0.5rem 1rem;
  }

  .alert-number {
    font-size: 1rem;
    padding: 0.25rem 0.5rem;
  }

  .alert-source {
    font-size: 0.65rem;
    padding: 0.25rem 0.5rem;
  }

  .safety-alert-header {
    flex-direction: column;
    align-items: flex-start;
  }

  .filter-container {
    width: 100%;
  }

  .filter-select {
    width: 100%;
    min-width: unset;
  }

  .filter-count {
    font-size: 0.8rem;
  }
}

/* Rekap K3L Section */
.rekap-k3l-section {
  background: white;
  padding: 2rem;
  margin: 2rem 1rem;
  border-radius: 20px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
}

.rekap-k3l-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  flex-wrap: wrap;
  gap: 1rem;
}

.rekap-k3l-title {
  font-size: 1.75rem;
  font-weight: 800;
  color: #1e3a8a;
  letter-spacing: 0.5px;
}

.rekap-k3l-title .periode-badge {
  color: #dc2626;
  font-weight: 700;
}

.filter-container {
  display: flex;
  align-items: center;
  gap: 1rem;
  flex-wrap: wrap;
}

.filter-group {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.filter-label {
  font-size: 0.875rem;
  font-weight: 600;
  color: #475569;
}

.filter-select {
  padding: 0.5rem 0.75rem;
  border: 2px solid #cbd5e1;
  border-radius: 8px;
  font-size: 0.875rem;
  font-weight: 500;
  color: #1e293b;
  background: white;
  cursor: pointer;
  transition: all 0.2s;
}

.filter-select:hover {
  border-color: #0066cc;
}

.filter-select:focus {
  outline: none;
  border-color: #0066cc;
  box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.1);
}

.filter-count {
  font-size: 0.875rem;
  color: #64748b;
  font-weight: 600;
  padding: 0.5rem 1rem;
  background: #f1f5f9;
  border-radius: 8px;
}

.rekap-table-wrapper {
  overflow-x: auto;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.rekap-table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  min-width: 800px;
}

.rekap-table thead {
  background: linear-gradient(135deg, #0066cc 0%, #004c99 100%);
  color: white;
}

.rekap-table th {
  padding: 1rem;
  text-align: center;
  font-weight: 700;
  font-size: 0.875rem;
  letter-spacing: 0.5px;
  border: 2px solid white;
}

.rekap-table .col-no {
  width: 4%;
}

.rekap-table .col-modul {
  width: 12%;
}

.rekap-table .col-kegiatan {
  width: 22%;
}

.rekap-table .col-dokumentasi {
  width: 12%;
}

.rekap-table .col-uraian {
  width: 38%;
}

.rekap-table .col-keterangan {
  width: 12%;
}

.rekap-table tbody tr {
  border-bottom: 2px solid #e5e7eb;
  transition: background 0.2s ease;
}

.rekap-table tbody tr:hover {
  background: #f0f9ff;
}

.rekap-table tbody tr:last-child {
  border-bottom: none;
}

.rekap-table td {
  padding: 1rem;
  font-size: 0.875rem;
  color: #1e293b;
  border: 1px solid #cbd5e1;
  vertical-align: top;
}

.rekap-table td.text-center {
  text-align: center;
  vertical-align: middle;
}

.rekap-table .uraian-cell {
  background: #f8fafc;
  padding: 0.75rem;
}

.rekap-table .uraian-content {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.rekap-table .uraian-row {
  font-size: 0.875rem;
  color: #334155;
  line-height: 1.5;
}

.rekap-table .uraian-row strong {
  color: #0f172a;
  font-weight: 600;
  min-width: 90px;
  display: inline-block;
}

.rekap-table .modul-cell {
  text-align: center;
  vertical-align: middle;
  padding: 0.5rem;
}

.rekap-table .modul-badge {
  display: inline-block;
  padding: 0.35rem 0.75rem;
  border-radius: 6px;
  font-size: 0.75rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.3px;
  white-space: nowrap;
}

.badge-blue {
  background: #dbeafe;
  color: #1e40af;
}

.badge-green {
  background: #d1fae5;
  color: #065f46;
}

.badge-red {
  background: #fee2e2;
  color: #991b1b;
}

.badge-orange {
  background: #ffedd5;
  color: #9a3412;
}

.badge-purple {
  background: #ede9fe;
  color: #5b21b6;
}

.badge-indigo {
  background: #e0e7ff;
  color: #3730a3;
}

.badge-teal {
  background: #ccfbf1;
  color: #115e59;
}

.badge-gray {
  background: #f1f5f9;
  color: #475569;
}

@media (max-width: 768px) {
  .rekap-k3l-section {
    padding: 1rem;
    margin: 2rem 0.5rem 1rem;
  }

  .rekap-k3l-header {
    flex-direction: column;
    align-items: flex-start;
  }

  .rekap-k3l-title {
    font-size: 1rem;
    line-height: 1.4;
  }

  .filter-container {
    width: 100%;
    justify-content: space-between;
  }

  .filter-group {
    flex: 1;
  }

  .filter-select {
    width: 100%;
    font-size: 0.75rem;
    padding: 0.4rem 0.5rem;
  }

  .filter-count {
    width: 100%;
    text-align: center;
    font-size: 0.75rem;
  }

  .rekap-table {
    font-size: 0.75rem;
  }

  .rekap-table th,
  .rekap-table td {
    padding: 0.5rem;
  }

  .rekap-table .uraian-row {
    font-size: 0.75rem;
  }

  .rekap-table .uraian-row strong {
    min-width: 70px;
    font-size: 0.7rem;
  }
}
</style>
