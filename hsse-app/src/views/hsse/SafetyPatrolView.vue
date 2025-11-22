<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { safetyPatrolService, type SafetyPatrol } from '@/services/hsse/safety-patrol.service'
import { useUnitsStore } from '@/stores/units'
import { useImageCompression } from '@/composables/useImageCompression'

const unitsStore = useUnitsStore()
const { compressSingleImage, formatFileSize } = useImageCompression()

// State
const loading = ref(false)
const patrols = ref<SafetyPatrol[]>([])
const selectedPatrol = ref<SafetyPatrol | null>(null)
const showDetailModal = ref(false)
const showFormModal = ref(false)
const formMode = ref<'create' | 'edit'>('create')
const showImageModal = ref(false)
const selectedImageUrl = ref('')

// Filters
const filters = ref({
  search: '',
  unit_id: '',
  jenis: '',
  status: '',
  shift: ''
})

// Stats
const stats = ref({
  total_patrol: 0,
  patrol_bulan_ini: 0,
  temuan_kritikal: 0,
  temuan_belum_selesai: 0,
  avg_skor: 0
})

// Pagination
const currentPage = ref(1)
const pageSize = ref(20)
const totalRecords = ref(0)
const totalPages = ref(0)

// Form data
const formData = ref<Partial<SafetyPatrol>>({
  nomor_patrol: '',
  tanggal_patrol: new Date().toISOString().split('T')[0],
  waktu_mulai: '',
  waktu_selesai: '',
  shift: 'pagi',
  unit_id: '',
  area_patrol: '',
  lokasi_spesifik: '',
  ketua_patrol: '',
  anggota_patrol: [],
  jumlah_anggota: 0,
  jenis_patrol: 'rutin',
  tujuan_patrol: '',
  fokus_patrol: [],
  cuaca: 'cerah',
  kondisi_pencahayaan: 'baik',
  kondisi_ventilasi: 'baik',
  unsafe_condition: [],
  unsafe_act: [],
  pekerja_diamati: 0,
  pekerja_patuh_apd: 0,
  pekerja_tidak_patuh_apd: 0,
  jalur_evakuasi_bebas: true,
  pintu_darurat_berfungsi: true,
  apar_tersedia: true,
  rekomendasi: [],
  action_items: [],
  status: 'draft'
})

const newAnggota = ref('')
const newRekomendasi = ref('')
const activeTab = ref(1)

// Computed
const filteredPatrols = computed(() => {
  return patrols.value
})

const patrolData = computed(() => selectedPatrol.value as any)

// Pagination methods
const goToPage = (page: number) => {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
    loadPatrols()
  }
}

const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++
    loadPatrols()
  }
}

const prevPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--
    loadPatrols()
  }
}

const changePageSize = (newSize: number) => {
  pageSize.value = newSize
  currentPage.value = 1
  loadPatrols()
}

const applyFilters = () => {
  currentPage.value = 1
  loadPatrols()
}

// Computed for pagination
const paginationInfo = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value + 1
  const end = Math.min(currentPage.value * pageSize.value, totalRecords.value)
  return `Menampilkan ${start}-${end} dari ${totalRecords.value} records`
})

const pageNumbers = computed(() => {
  const pages = []
  const maxVisible = 5
  let startPage = Math.max(1, currentPage.value - Math.floor(maxVisible / 2))
  let endPage = Math.min(totalPages.value, startPage + maxVisible - 1)
  
  if (endPage - startPage < maxVisible - 1) {
    startPage = Math.max(1, endPage - maxVisible + 1)
  }
  
  for (let i = startPage; i <= endPage; i++) {
    pages.push(i)
  }
  
  return pages
})

// Methods
const loadPatrols = async () => {
  loading.value = true
  try {
    const response = await safetyPatrolService.getPaginated(
      filters.value,
      { page: currentPage.value, pageSize: pageSize.value }
    )
    patrols.value = response.data
    totalRecords.value = response.count
    totalPages.value = response.totalPages
  } catch (error) {
    console.error('Error loading patrols:', error)
    alert('Gagal memuat data patrol')
  } finally {
    loading.value = false
  }
}

const loadStats = async () => {
  try {
    const data = await safetyPatrolService.getStatistics()
    stats.value = data
  } catch (error) {
    console.error('Error loading stats:', error)
  }
}

const openDetailModal = (patrol: SafetyPatrol) => {
  selectedPatrol.value = patrol
  showDetailModal.value = true
}

const closeDetailModal = () => {
  showDetailModal.value = false
  selectedPatrol.value = null
}

const openFormModal = (mode: 'create' | 'edit', patrol?: SafetyPatrol) => {
  formMode.value = mode
  if (mode === 'edit' && patrol) {
    formData.value = { ...patrol }
  } else {
    formData.value = {
      nomor_patrol: '',
      tanggal_patrol: new Date().toISOString().split('T')[0],
      waktu_mulai: '',
      shift: 'pagi',
      jenis_patrol: 'rutin',
      status: 'draft',
      unsafe_condition: [],
      unsafe_act: [],
      rekomendasi: [],
      action_items: [],
      anggota_patrol: [],
      fokus_patrol: []
    }
  }
  activeTab.value = 1
  showFormModal.value = true
}

const closeFormModal = () => {
  showFormModal.value = false
  formData.value = {}
}

const handleSubmit = async () => {
  try {
    const dataToSave = { ...formData.value }
    
    // Calculate counts
    dataToSave.jumlah_unsafe_condition = dataToSave.unsafe_condition?.length || 0
    dataToSave.jumlah_unsafe_act = dataToSave.unsafe_act?.length || 0
    dataToSave.total_temuan = (dataToSave.jumlah_unsafe_condition || 0) + (dataToSave.jumlah_unsafe_act || 0)
    dataToSave.jumlah_anggota = dataToSave.anggota_patrol?.length || 0
    dataToSave.jumlah_action_item = dataToSave.action_items?.length || 0
    dataToSave.action_belum_mulai = dataToSave.action_items?.filter((a: any) => a.status === 'belum_mulai').length || 0
    
    // Calculate APD
    if (dataToSave.pekerja_diamati && dataToSave.pekerja_diamati > 0) {
      dataToSave.persentase_kepatuhan_apd = Math.round(
        ((dataToSave.pekerja_patuh_apd || 0) / dataToSave.pekerja_diamati) * 100
      )
    }
    
    // Classify findings
    dataToSave.temuan_kritikal = [
      ...(dataToSave.unsafe_condition || []),
      ...(dataToSave.unsafe_act || [])
    ].filter((t: any) => t.tingkat_risiko === 'kritikal').length
    
    dataToSave.temuan_mayor = [
      ...(dataToSave.unsafe_condition || []),
      ...(dataToSave.unsafe_act || [])
    ].filter((t: any) => t.tingkat_risiko === 'tinggi').length
    
    dataToSave.temuan_minor = [
      ...(dataToSave.unsafe_condition || []),
      ...(dataToSave.unsafe_act || [])
    ].filter((t: any) => t.tingkat_risiko === 'sedang' || t.tingkat_risiko === 'rendah').length
    
    // Remove unit object
    delete dataToSave.unit
    
    // Convert empty UUID to null
    if (dataToSave.unit_id === '') (dataToSave as any).unit_id = null
    if (dataToSave.created_by === '') (dataToSave as any).created_by = null
    if (dataToSave.reviewed_by === '') (dataToSave as any).reviewed_by = null
    
    if (formMode.value === 'create') {
      await safetyPatrolService.create(dataToSave)
      alert('Patrol berhasil dibuat')
    } else {
      if (!formData.value.id) {
        throw new Error('ID patrol tidak ditemukan untuk update')
      }
      await safetyPatrolService.update(formData.value.id, dataToSave)
      alert('Patrol berhasil diupdate')
    }
    
    closeFormModal()
    loadPatrols()
    loadStats()
  } catch (error) {
    console.error('Error saving patrol:', error)
    alert('Gagal menyimpan patrol: ' + (error as Error).message)
  }
}

const deletePatrol = async (patrol: SafetyPatrol) => {
  if (!confirm(`Hapus patrol ${patrol.nomor_patrol}?`)) return
  
  try {
    await safetyPatrolService.delete(patrol.id!)
    alert('Patrol berhasil dihapus')
    loadPatrols()
    loadStats()
  } catch (error) {
    console.error('Error deleting patrol:', error)
    alert('Gagal menghapus patrol')
  }
}

// Unsafe Condition Methods
const addUnsafeCondition = () => {
  if (!formData.value.unsafe_condition) formData.value.unsafe_condition = []
  formData.value.unsafe_condition.push({
    no: formData.value.unsafe_condition.length + 1,
    kategori: '',
    deskripsi: '',
    lokasi: '',
    tingkat_risiko: 'sedang',
    foto_urls: [],
    tindakan: ''
  })
}

const removeUnsafeCondition = (index: number) => {
  formData.value.unsafe_condition?.splice(index, 1)
}

const handleUnsafeConditionPhotoUpload = async (event: Event, conditionIndex: number) => {
  const target = event.target as HTMLInputElement
  const files = target.files
  if (!files || files.length === 0) return

  const condition = formData.value.unsafe_condition?.[conditionIndex]
  if (!condition) return

  if (!condition.foto_urls) condition.foto_urls = []

  for (let i = 0; i < files.length; i++) {
    const file = files[i]
    if (!file) continue

    // Validate file type
    if (!file.type.startsWith('image/')) {
      alert(`File ${file.name} bukan gambar`)
      continue
    }

    try {
      // Auto-compress if >1MB
      const result = await compressSingleImage(file)
      const compressedFile = result.file
      
      if (result.wasCompressed) {
        console.log(`📸 ${file.name}: ${formatFileSize(result.originalSize)} → ${formatFileSize(result.compressedSize)} (${Math.round((1 - result.compressedSize / result.originalSize) * 100)}% lebih kecil)`)
      }

      // Create preview using FileReader for immediate display
      const reader = new FileReader()
      reader.onload = (e) => {
        const dataUrl = e.target?.result as string
        condition.foto_urls.push(dataUrl)
      }
      reader.readAsDataURL(compressedFile)

      // Note: Actual upload to Supabase storage will happen on form submit
      // For now we just show preview with data URL
    } catch (error) {
      console.error('Error reading file:', error)
      alert('Gagal membaca file')
    }
  }

  // Reset input
  target.value = ''
}

const removeUnsafeConditionPhoto = (conditionIndex: number, photoIndex: number) => {
  const condition = formData.value.unsafe_condition?.[conditionIndex]
  if (condition && condition.foto_urls) {
    condition.foto_urls.splice(photoIndex, 1)
  }
}

// Unsafe Act Methods
const addUnsafeAct = () => {
  if (!formData.value.unsafe_act) formData.value.unsafe_act = []
  formData.value.unsafe_act.push({
    no: formData.value.unsafe_act.length + 1,
    deskripsi: '',
    pekerja: '',
    lokasi: '',
    tingkat_risiko: 'sedang',
    tindakan_langsung: ''
  })
}

const removeUnsafeAct = (index: number) => {
  formData.value.unsafe_act?.splice(index, 1)
}

// Action Item Methods
const addActionItem = () => {
  if (!formData.value.action_items) formData.value.action_items = []
  formData.value.action_items.push({
    no: formData.value.action_items.length + 1,
    temuan: '',
    tindakan: '',
    pic: '',
    target_date: '',
    prioritas: 'sedang',
    status: 'belum_mulai'
  })
}

const removeActionItem = (index: number) => {
  formData.value.action_items?.splice(index, 1)
}

// Helper methods
const calculateAPDCompliance = () => {
  const total = formData.value.pekerja_diamati || 0
  const patuh = formData.value.pekerja_patuh_apd || 0
  if (total > 0) {
    formData.value.persentase_kepatuhan_apd = Math.round((patuh / total) * 100)
  } else {
    formData.value.persentase_kepatuhan_apd = 0
  }
  formData.value.pekerja_tidak_patuh_apd = total - patuh
}

const getAPDDetail = (jenis: string) => {
  if (!formData.value.detail_apd) formData.value.detail_apd = []
  const existing = formData.value.detail_apd.find((d: any) => d.jenis_apd === jenis)
  if (existing) return existing
  return { jenis_apd: jenis, wajib: false, patuh: 0, tidak_patuh: 0 }
}

const updateAPDDetail = (jenis: string, field: string, value: any) => {
  if (!formData.value.detail_apd) formData.value.detail_apd = []
  const existing = formData.value.detail_apd.find((d: any) => d.jenis_apd === jenis)
  if (existing) {
    (existing as any)[field] = value
  } else {
    formData.value.detail_apd.push({
      jenis_apd: jenis,
      wajib: field === 'wajib' ? value : false,
      patuh: field === 'patuh' ? value : 0,
      tidak_patuh: field === 'tidak_patuh' ? value : 0
    })
  }
}

const addAnggota = () => {
  if (newAnggota.value.trim()) {
    if (!formData.value.anggota_patrol) formData.value.anggota_patrol = []
    formData.value.anggota_patrol.push(newAnggota.value.trim())
    newAnggota.value = ''
  }
}

const removeAnggota = (index: number) => {
  formData.value.anggota_patrol?.splice(index, 1)
}

const addRekomendasi = () => {
  if (newRekomendasi.value.trim()) {
    if (!formData.value.rekomendasi) formData.value.rekomendasi = []
    formData.value.rekomendasi.push(newRekomendasi.value.trim())
    newRekomendasi.value = ''
  }
}

const removeRekomendasi = (index: number) => {
  formData.value.rekomendasi?.splice(index, 1)
}

// Formatters
const formatDate = (dateStr: string) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return date.toLocaleDateString('id-ID', { day: '2-digit', month: 'short', year: 'numeric' })
}

const formatTime = (timeStr: string | undefined) => {
  if (!timeStr) return '-'
  return timeStr.substring(0, 5)
}

const getStatusBadgeClass = (status: string) => {
  const classes: Record<string, string> = {
    'draft': 'bg-gray-100 text-gray-800',
    'submitted': 'bg-blue-100 text-blue-800',
    'reviewed': 'bg-green-100 text-green-800',
    'closed': 'bg-purple-100 text-purple-800',
    'cancelled': 'bg-red-100 text-red-800'
  }
  return `inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${classes[status] || classes.draft}`
}

const formatStatus = (status: string) => {
  const labels: Record<string, string> = {
    'draft': 'Draft',
    'submitted': 'Submitted',
    'reviewed': 'Reviewed',
    'closed': 'Closed',
    'cancelled': 'Cancelled'
  }
  return labels[status] || status
}

const getGradeBadge = (grade: string) => {
  const classes: Record<string, string> = {
    'A': 'bg-green-500 text-white',
    'B': 'bg-blue-500 text-white',
    'C': 'bg-yellow-500 text-white',
    'D': 'bg-orange-500 text-white',
    'E': 'bg-red-500 text-white'
  }
  return `inline-flex items-center justify-center w-8 h-8 rounded-full text-sm font-bold ${classes[grade] || 'bg-gray-500 text-white'}`
}

const getRiskBadge = (risk: string) => {
  const classes: Record<string, string> = {
    'kritikal': 'bg-red-600 text-white',
    'tinggi': 'bg-orange-500 text-white',
    'sedang': 'bg-yellow-500 text-white',
    'rendah': 'bg-green-500 text-white'
  }
  return `inline-flex items-center px-2 py-0.5 rounded text-xs font-medium ${classes[risk] || 'bg-gray-500 text-white'}`
}

const parseJSON = (data: any) => {
  if (!data) return []
  if (typeof data === 'string') {
    try {
      return JSON.parse(data)
    } catch {
      return []
    }
  }
  return Array.isArray(data) ? data : []
}

// Image modal
const openImageModal = (url: string) => {
  selectedImageUrl.value = url
  showImageModal.value = true
}

const closeImageModal = () => {
  showImageModal.value = false
  selectedImageUrl.value = ''
}

onMounted(() => {
  loadPatrols()
  loadStats()
  unitsStore.fetchUnits()
})
</script>

<template>
  <div class="p-6">
    <!-- Header -->
    <div class="mb-6">
      <h1 class="text-2xl font-bold text-gray-900">Safety Patrol</h1>
      <p class="text-gray-600">Kelola aktivitas patrol keselamatan dan temuan</p>
    </div>

    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-5 gap-4 mb-6">
      <div class="bg-white rounded-lg shadow p-4">
        <div class="text-sm text-gray-600">Total Patrol</div>
        <div class="text-2xl font-bold text-gray-900">{{ stats.total_patrol }}</div>
      </div>
      <div class="bg-white rounded-lg shadow p-4">
        <div class="text-sm text-gray-600">Bulan Ini</div>
        <div class="text-2xl font-bold text-blue-600">{{ stats.patrol_bulan_ini }}</div>
      </div>
      <div class="bg-white rounded-lg shadow p-4">
        <div class="text-sm text-gray-600">Temuan Kritikal</div>
        <div class="text-2xl font-bold text-red-600">{{ stats.temuan_kritikal }}</div>
      </div>
      <div class="bg-white rounded-lg shadow p-4">
        <div class="text-sm text-gray-600">Belum Selesai</div>
        <div class="text-2xl font-bold text-orange-600">{{ stats.temuan_belum_selesai }}</div>
      </div>
      <div class="bg-white rounded-lg shadow p-4">
        <div class="text-sm text-gray-600">Avg Score</div>
        <div class="text-2xl font-bold text-green-600">{{ stats.avg_skor }}</div>
      </div>
    </div>

    <!-- Filters & Actions -->
    <div class="bg-white rounded-lg shadow mb-6 p-4">
      <div class="grid grid-cols-1 md:grid-cols-6 gap-4">
        <input
          v-model="filters.search"
          type="text"
          placeholder="Cari nomor, area, ketua..."
          class="px-4 py-2 border rounded-lg"
          @input="loadPatrols"
        />
        <select v-model="filters.unit_id" class="px-4 py-2 border rounded-lg" @change="applyFilters">
          <option value="">Semua Unit</option>
          <option v-for="unit in unitsStore.units" :key="unit.id" :value="unit.id">
            {{ unit.nama }}
          </option>
        </select>
        <select v-model="filters.jenis" class="px-4 py-2 border rounded-lg" @change="applyFilters">
          <option value="">Semua Jenis</option>
          <option value="rutin">Rutin</option>
          <option value="insidental">Insidental</option>
          <option value="khusus">Khusus</option>
          <option value="emergency">Emergency</option>
        </select>
        <select v-model="filters.shift" class="px-4 py-2 border rounded-lg" @change="applyFilters">
          <option value="">Semua Shift</option>
          <option value="pagi">Pagi</option>
          <option value="siang">Siang</option>
          <option value="malam">Malam</option>
        </select>
        <select v-model="filters.status" class="px-4 py-2 border rounded-lg" @change="applyFilters">
          <option value="">Semua Status</option>
          <option value="draft">Draft</option>
          <option value="submitted">Submitted</option>
          <option value="reviewed">Reviewed</option>
          <option value="closed">Closed</option>
        </select>
        <button
          @click="openFormModal('create')"
          class="px-4 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700"
        >
          + Patrol Baru
        </button>
      </div>
    </div>

    <!-- Table -->
    <div class="bg-white rounded-lg shadow overflow-hidden">
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nomor</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tanggal</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Area</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Ketua</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Temuan</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Score</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-if="loading">
              <td colspan="8" class="px-6 py-4 text-center text-gray-500">Loading...</td>
            </tr>
            <tr v-else-if="filteredPatrols.length === 0">
              <td colspan="8" class="px-6 py-4 text-center text-gray-500">Tidak ada data</td>
            </tr>
            <tr v-else v-for="patrol in filteredPatrols" :key="patrol.id" class="hover:bg-gray-50">
              <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                {{ patrol.nomor_patrol }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                <div>{{ formatDate(patrol.tanggal_patrol) }}</div>
                <div class="text-xs text-gray-500">{{ patrol.shift }}</div>
              </td>
              <td class="px-6 py-4 text-sm text-gray-900">
                <div class="font-medium">{{ patrol.area_patrol }}</div>
                <div class="text-xs text-gray-500">{{ patrol.unit?.nama || '-' }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                {{ patrol.ketua_patrol }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm">
                <div class="flex gap-1">
                  <span v-if="patrol.temuan_kritikal" class="px-2 py-0.5 bg-red-100 text-red-800 rounded text-xs">
                    K: {{ patrol.temuan_kritikal }}
                  </span>
                  <span v-if="patrol.temuan_mayor" class="px-2 py-0.5 bg-orange-100 text-orange-800 rounded text-xs">
                    M: {{ patrol.temuan_mayor }}
                  </span>
                  <span v-if="patrol.temuan_minor" class="px-2 py-0.5 bg-yellow-100 text-yellow-800 rounded text-xs">
                    m: {{ patrol.temuan_minor }}
                  </span>
                </div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm">
                <div class="flex items-center gap-2">
                  <span v-if="patrol.grade" :class="getGradeBadge(patrol.grade)">{{ patrol.grade }}</span>
                  <span class="text-gray-600">{{ patrol.skor_keseluruhan || '-' }}</span>
                </div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm">
                <span :class="getStatusBadgeClass(patrol.status || 'draft')">
                  {{ formatStatus(patrol.status || 'draft') }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                <div class="flex gap-2">
                  <button
                    @click="openDetailModal(patrol)"
                    class="text-blue-600 hover:text-blue-900"
                    title="Detail"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                    </svg>
                  </button>
                  <button
                    @click="openFormModal('edit', patrol)"
                    class="text-green-600 hover:text-green-900"
                    title="Edit"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                    </svg>
                  </button>
                  <button
                    @click="deletePatrol(patrol)"
                    class="text-red-600 hover:text-red-900"
                    title="Hapus"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Pagination Controls -->
      <div class="mt-4 flex items-center justify-between px-4 py-3 bg-white border-t border-gray-200 sm:px-6">
        <div class="flex-1 flex justify-between sm:hidden">
          <button 
            @click="prevPage" 
            :disabled="currentPage === 1"
            class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Previous
          </button>
          <button 
            @click="nextPage" 
            :disabled="currentPage === totalPages"
            class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Next
          </button>
        </div>
        <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
          <div>
            <p class="text-sm text-gray-700">
              {{ paginationInfo }}
            </p>
          </div>
          <div class="flex items-center gap-2">
            <label class="text-sm text-gray-700">Per halaman:</label>
            <select 
              v-model.number="pageSize" 
              @change="changePageSize(pageSize)"
              class="border border-gray-300 rounded-md text-sm px-2 py-1"
            >
              <option :value="10">10</option>
              <option :value="20">20</option>
              <option :value="50">50</option>
              <option :value="100">100</option>
            </select>
          </div>
          <div>
            <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px">
              <button 
                @click="prevPage" 
                :disabled="currentPage === 1"
                class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
                </svg>
              </button>
              
              <button 
                v-if="pageNumbers.length > 0 && pageNumbers[0]! > 1"
                @click="goToPage(1)"
                class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50"
              >
                1
              </button>
              <span v-if="pageNumbers.length > 0 && pageNumbers[0]! > 2" class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700">
                ...
              </span>
              
              <button 
                v-for="page in pageNumbers" 
                :key="page"
                @click="goToPage(page)"
                :class="[
                  'relative inline-flex items-center px-4 py-2 border text-sm font-medium',
                  page === currentPage 
                    ? 'z-10 bg-primary-600 border-primary-600 text-white' 
                    : 'bg-white border-gray-300 text-gray-700 hover:bg-gray-50'
                ]"
              >
                {{ page }}
              </button>
              
              <span v-if="pageNumbers.length > 0 && pageNumbers[pageNumbers.length - 1]! < totalPages - 1" class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700">
                ...
              </span>
              <button 
                v-if="pageNumbers.length > 0 && pageNumbers[pageNumbers.length - 1]! < totalPages"
                @click="goToPage(totalPages)"
                class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50"
              >
                {{ totalPages }}
              </button>
              
              <button 
                @click="nextPage" 
                :disabled="currentPage === totalPages"
                class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                </svg>
              </button>
            </nav>
          </div>
        </div>
      </div>
    </div>

    <!-- Detail Modal -->
    <div v-if="showDetailModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div class="bg-white rounded-lg shadow-xl max-w-6xl w-full max-h-[90vh] overflow-hidden">
        <div class="flex justify-between items-center p-6 border-b sticky top-0 bg-white z-10">
          <h2 class="text-xl font-bold">Detail Safety Patrol</h2>
          <button @click="closeDetailModal" class="text-gray-500 hover:text-gray-700">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
        
        <div class="p-6 overflow-y-auto max-h-[calc(90vh-120px)]">
          <div v-if="selectedPatrol" class="space-y-6">
            <!-- 1. Data Dasar -->
            <div class="bg-gray-50 rounded-lg p-4">
              <h3 class="font-semibold text-lg mb-3 text-primary-600">Data Dasar</h3>
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="text-sm text-gray-600">Nomor Patrol</label>
                  <div class="font-medium">{{ selectedPatrol.nomor_patrol }}</div>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Tanggal</label>
                  <div class="font-medium">{{ formatDate(selectedPatrol.tanggal_patrol) }}</div>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Waktu</label>
                  <div class="font-medium">{{ formatTime(selectedPatrol.waktu_mulai) }} - {{ formatTime(selectedPatrol.waktu_selesai) }}</div>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Shift</label>
                  <div class="font-medium capitalize">{{ selectedPatrol.shift }}</div>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Unit</label>
                  <div class="font-medium">{{ selectedPatrol.unit?.nama || '-' }}</div>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Jenis Patrol</label>
                  <div class="font-medium capitalize">{{ selectedPatrol.jenis_patrol }}</div>
                </div>
                <div class="col-span-2">
                  <label class="text-sm text-gray-600">Area Patrol</label>
                  <div class="font-medium">{{ selectedPatrol.area_patrol }}</div>
                </div>
                <div class="col-span-2">
                  <label class="text-sm text-gray-600">Lokasi Spesifik</label>
                  <div class="font-medium">{{ selectedPatrol.lokasi_spesifik || '-' }}</div>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Ketua Patrol</label>
                  <div class="font-medium">{{ selectedPatrol.ketua_patrol }}</div>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Jumlah Anggota</label>
                  <div class="font-medium">{{ selectedPatrol.jumlah_anggota || 0 }}</div>
                </div>
                <div class="col-span-2" v-if="selectedPatrol.anggota_patrol?.length">
                  <label class="text-sm text-gray-600">Anggota Tim</label>
                  <div class="flex flex-wrap gap-2 mt-1">
                    <span v-for="(anggota, idx) in parseJSON(selectedPatrol.anggota_patrol)" :key="idx"
                      class="px-2 py-1 bg-blue-100 text-blue-800 rounded text-sm">
                      {{ anggota }}
                    </span>
                  </div>
                </div>
              </div>
            </div>

            <!-- 2. Kondisi Lingkungan -->
            <div class="bg-gray-50 rounded-lg p-4">
              <h3 class="font-semibold text-lg mb-3 text-primary-600">Kondisi Lingkungan</h3>
              <div class="grid grid-cols-3 gap-4">
                <div>
                  <label class="text-sm text-gray-600">Cuaca</label>
                  <div class="font-medium capitalize">{{ selectedPatrol.cuaca || '-' }}</div>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Suhu</label>
                  <div class="font-medium">{{ patrolData.suhu ? patrolData.suhu + '°C' : '-' }}</div>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Pencahayaan</label>
                  <div class="font-medium capitalize">{{ selectedPatrol.kondisi_pencahayaan || '-' }}</div>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Ventilasi</label>
                  <div class="font-medium capitalize">{{ selectedPatrol.kondisi_ventilasi || '-' }}</div>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Tingkat Kebisingan</label>
                  <div class="font-medium">{{ selectedPatrol.tingkat_kebisingan ? selectedPatrol.tingkat_kebisingan + ' dB' : '-' }}</div>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Kondisi Lantai</label>
                  <div class="font-medium capitalize">{{ patrolData.kondisi_lantai || '-' }}</div>
                </div>
              </div>
            </div>

            <!-- 3. Unsafe Condition -->
            <div class="bg-red-50 rounded-lg p-4">
              <h3 class="font-semibold text-lg mb-3 text-red-700">Kondisi Tidak Aman</h3>
              <div v-if="parseJSON(selectedPatrol.unsafe_condition).length > 0">
                <div v-for="(item, idx) in parseJSON(selectedPatrol.unsafe_condition)" :key="idx" class="mb-4 p-3 bg-white rounded border-l-4 border-red-500">
                  <div class="flex justify-between items-start mb-2">
                    <div class="font-semibold text-gray-900">{{ item.kategori }}</div>
                    <span :class="getRiskBadge(item.tingkat_risiko)">{{ item.tingkat_risiko }}</span>
                  </div>
                  <div class="text-sm text-gray-700 mb-2">{{ item.deskripsi }}</div>
                  <div class="text-sm text-gray-600">
                    <span class="font-medium">Lokasi:</span> {{ item.lokasi }}
                  </div>
                  <div v-if="item.tindakan" class="text-sm text-gray-600 mt-2">
                    <span class="font-medium">Tindakan:</span> {{ item.tindakan }}
                  </div>
                  <!-- Foto Dokumentasi -->
                  <div v-if="item.foto_urls && item.foto_urls.length > 0" class="mt-3">
                    <div class="text-sm font-medium text-gray-700 mb-2">📷 Foto Dokumentasi:</div>
                    <div class="grid grid-cols-4 gap-2">
                      <div v-for="(url, photoIdx) in item.foto_urls" :key="photoIdx" class="relative">
                        <img :src="url" :alt="`Foto ${photoIdx + 1}`" loading="lazy" class="w-full h-24 object-cover rounded border border-gray-300 cursor-pointer hover:opacity-80 transition-opacity" @click="openImageModal(url)" />
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div v-else class="text-gray-500 text-center py-4">Tidak ada kondisi tidak aman</div>
            </div>

            <!-- 4. Unsafe Act -->
            <div class="bg-orange-50 rounded-lg p-4">
              <h3 class="font-semibold text-lg mb-3 text-orange-700">Tindakan Tidak Aman</h3>
              <div v-if="parseJSON(selectedPatrol.unsafe_act).length > 0">
                <div v-for="(item, idx) in parseJSON(selectedPatrol.unsafe_act)" :key="idx" class="mb-4 p-3 bg-white rounded border-l-4 border-orange-500">
                  <div class="flex justify-between items-start mb-2">
                    <div class="font-semibold text-gray-900">{{ item.pekerja }}</div>
                    <span :class="getRiskBadge(item.tingkat_risiko)">{{ item.tingkat_risiko }}</span>
                  </div>
                  <div class="text-sm text-gray-700 mb-2">{{ item.deskripsi }}</div>
                  <div class="text-sm text-gray-600">
                    <span class="font-medium">Lokasi:</span> {{ item.lokasi }}
                  </div>
                  <div v-if="item.tindakan_langsung" class="text-sm text-gray-600 mt-2">
                    <span class="font-medium">Tindakan Langsung:</span> {{ item.tindakan_langsung }}
                  </div>
                </div>
              </div>
              <div v-else class="text-gray-500 text-center py-4">Tidak ada tindakan tidak aman</div>
            </div>

            <!-- 5. Kepatuhan APD -->
            <div class="bg-green-50 rounded-lg p-4">
              <h3 class="font-semibold text-lg mb-3 text-green-700">Kepatuhan APD</h3>
              <div class="grid grid-cols-4 gap-4 mb-4">
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-gray-900">{{ selectedPatrol.pekerja_diamati || 0 }}</div>
                  <div class="text-xs text-gray-600">Pekerja Diamati</div>
                </div>
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-green-600">{{ selectedPatrol.pekerja_patuh_apd || 0 }}</div>
                  <div class="text-xs text-gray-600">Patuh APD</div>
                </div>
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-red-600">{{ selectedPatrol.pekerja_tidak_patuh_apd || 0 }}</div>
                  <div class="text-xs text-gray-600">Tidak Patuh</div>
                </div>
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-blue-600">{{ selectedPatrol.persentase_kepatuhan_apd || 0 }}%</div>
                  <div class="text-xs text-gray-600">Persentase</div>
                </div>
              </div>
              <div v-if="parseJSON(selectedPatrol.detail_apd).length > 0" class="overflow-x-auto">
                <table class="min-w-full text-sm">
                  <thead class="bg-white">
                    <tr>
                      <th class="px-3 py-2 text-left">Jenis APD</th>
                      <th class="px-3 py-2 text-center">Wajib</th>
                      <th class="px-3 py-2 text-center">Patuh</th>
                      <th class="px-3 py-2 text-center">Tidak Patuh</th>
                    </tr>
                  </thead>
                  <tbody class="bg-white divide-y">
                    <tr v-for="(item, idx) in parseJSON(selectedPatrol.detail_apd)" :key="idx">
                      <td class="px-3 py-2">{{ item.jenis_apd }}</td>
                      <td class="px-3 py-2 text-center">{{ item.wajib ? '✓' : '-' }}</td>
                      <td class="px-3 py-2 text-center text-green-600">{{ item.patuh || 0 }}</td>
                      <td class="px-3 py-2 text-center text-red-600">{{ item.tidak_patuh || 0 }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <!-- 6. Housekeeping -->
            <div class="bg-blue-50 rounded-lg p-4">
              <h3 class="font-semibold text-lg mb-3 text-blue-700">Housekeeping</h3>
              <div class="grid grid-cols-3 gap-4">
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-3xl font-bold text-blue-600">{{ selectedPatrol.skor_housekeeping || 0 }}</div>
                  <div class="text-xs text-gray-600">Skor Housekeeping</div>
                </div>
                <div class="col-span-2">
                  <div class="mb-2">
                    <label class="text-sm text-gray-600">Kondisi</label>
                    <div class="font-medium capitalize">{{ selectedPatrol.kondisi_housekeeping || '-' }}</div>
                  </div>
                  <div class="mb-2" v-if="selectedPatrol.area_kotor">
                    <label class="text-sm text-gray-600">Area Kotor</label>
                    <div class="font-medium">{{ selectedPatrol.area_kotor }}</div>
                  </div>
                  <div v-if="selectedPatrol.area_rapi">
                    <label class="text-sm text-gray-600">Area Rapi</label>
                    <div class="font-medium">{{ selectedPatrol.area_rapi }}</div>
                  </div>
                </div>
              </div>
            </div>

            <!-- 7. Peralatan & Mesin -->
            <div class="bg-purple-50 rounded-lg p-4">
              <h3 class="font-semibold text-lg mb-3 text-purple-700">Peralatan & Mesin</h3>
              <div class="grid grid-cols-3 gap-4 mb-4">
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-gray-900">{{ selectedPatrol.jumlah_mesin_diperiksa || 0 }}</div>
                  <div class="text-xs text-gray-600">Diperiksa</div>
                </div>
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-green-600">{{ selectedPatrol.mesin_kondisi_baik || 0 }}</div>
                  <div class="text-xs text-gray-600">Baik</div>
                </div>
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-red-600">{{ selectedPatrol.mesin_perlu_perbaikan || 0 }}</div>
                  <div class="text-xs text-gray-600">Perlu Perbaikan</div>
                </div>
              </div>
              <div v-if="parseJSON(selectedPatrol.detail_mesin).length > 0" class="overflow-x-auto">
                <table class="min-w-full text-sm">
                  <thead class="bg-white">
                    <tr>
                      <th class="px-3 py-2 text-left">Nama Mesin</th>
                      <th class="px-3 py-2 text-left">Lokasi</th>
                      <th class="px-3 py-2 text-center">Kondisi</th>
                      <th class="px-3 py-2 text-left">Masalah</th>
                    </tr>
                  </thead>
                  <tbody class="bg-white divide-y">
                    <tr v-for="(item, idx) in parseJSON(selectedPatrol.detail_mesin)" :key="idx">
                      <td class="px-3 py-2">{{ item.nama_mesin }}</td>
                      <td class="px-3 py-2">{{ item.lokasi }}</td>
                      <td class="px-3 py-2 text-center">
                        <span :class="item.kondisi === 'baik' ? 'text-green-600' : 'text-red-600'">
                          {{ item.kondisi }}
                        </span>
                      </td>
                      <td class="px-3 py-2">{{ item.masalah || '-' }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <!-- 8. Emergency Facilities -->
            <div class="bg-yellow-50 rounded-lg p-4">
              <h3 class="font-semibold text-lg mb-3 text-yellow-800">Fasilitas Darurat</h3>
              <div class="grid grid-cols-3 gap-4">
                <div>
                  <label class="text-sm text-gray-600">Jalur Evakuasi</label>
                  <div :class="selectedPatrol.jalur_evakuasi_bebas ? 'text-green-600' : 'text-red-600'" class="font-medium">
                    {{ selectedPatrol.jalur_evakuasi_bebas ? 'Bebas' : 'Terhalang' }}
                  </div>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Pintu Darurat</label>
                  <div :class="selectedPatrol.pintu_darurat_berfungsi ? 'text-green-600' : 'text-red-600'" class="font-medium">
                    {{ selectedPatrol.pintu_darurat_berfungsi ? 'Berfungsi' : 'Rusak' }}
                  </div>
                </div>
                <div>
                  <label class="text-sm text-gray-600">APAR</label>
                  <div :class="selectedPatrol.apar_tersedia ? 'text-green-600' : 'text-red-600'" class="font-medium">
                    {{ selectedPatrol.apar_tersedia ? 'Tersedia' : 'Tidak Tersedia' }}
                  </div>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Jumlah APAR</label>
                  <div class="font-medium">{{ patrolData.jumlah_apar || 0 }}</div>
                </div>
                <div>
                  <label class="text-sm text-gray-600">APAR Expired</label>
                  <div class="font-medium text-red-600">{{ patrolData.apar_expired || 0 }}</div>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Lampu Darurat</label>
                  <div :class="patrolData.lampu_darurat_berfungsi ? 'text-green-600' : 'text-red-600'" class="font-medium">
                    {{ patrolData.lampu_darurat_berfungsi ? 'Berfungsi' : 'Rusak' }}
                  </div>
                </div>
              </div>
            </div>

            <!-- 9. Action Items -->
            <div class="bg-indigo-50 rounded-lg p-4">
              <h3 class="font-semibold text-lg mb-3 text-indigo-700">Action Items</h3>
              <div v-if="parseJSON(selectedPatrol.action_items).length > 0" class="overflow-x-auto">
                <table class="min-w-full text-sm">
                  <thead class="bg-white">
                    <tr>
                      <th class="px-3 py-2 text-left">No</th>
                      <th class="px-3 py-2 text-left">Temuan</th>
                      <th class="px-3 py-2 text-left">Tindakan</th>
                      <th class="px-3 py-2 text-left">PIC</th>
                      <th class="px-3 py-2 text-center">Target</th>
                      <th class="px-3 py-2 text-center">Status</th>
                    </tr>
                  </thead>
                  <tbody class="bg-white divide-y">
                    <tr v-for="(item, idx) in parseJSON(selectedPatrol.action_items)" :key="idx">
                      <td class="px-3 py-2">{{ item.no }}</td>
                      <td class="px-3 py-2">{{ item.temuan }}</td>
                      <td class="px-3 py-2">{{ item.tindakan }}</td>
                      <td class="px-3 py-2">{{ item.pic }}</td>
                      <td class="px-3 py-2 text-center">{{ formatDate(item.target_date) }}</td>
                      <td class="px-3 py-2 text-center">
                        <span :class="getStatusBadgeClass(item.status)">{{ item.status }}</span>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <div v-else class="text-gray-500 text-center py-4">Tidak ada action items</div>
            </div>

            <!-- 10. Scoring & Grade -->
            <div class="bg-gradient-to-r from-purple-50 to-pink-50 rounded-lg p-4">
              <h3 class="font-semibold text-lg mb-3 text-purple-700">Scoring & Grade</h3>
              <div class="grid grid-cols-5 gap-4 mb-4">
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-3xl font-bold text-purple-600">{{ selectedPatrol.skor_keseluruhan || 0 }}</div>
                  <div class="text-xs text-gray-600">Skor Keseluruhan</div>
                </div>
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-green-600">{{ selectedPatrol.skor_apd || 0 }}</div>
                  <div class="text-xs text-gray-600">Skor APD</div>
                </div>
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-blue-600">{{ selectedPatrol.skor_kondisi_area || 0 }}</div>
                  <div class="text-xs text-gray-600">Kondisi Area</div>
                </div>
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-orange-600">{{ selectedPatrol.skor_peralatan || 0 }}</div>
                  <div class="text-xs text-gray-600">Peralatan</div>
                </div>
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-4xl" :class="getGradeBadge(selectedPatrol.grade || 'C')">{{ selectedPatrol.grade || '-' }}</div>
                  <div class="text-xs text-gray-600 mt-2">Grade</div>
                </div>
              </div>
              <div v-if="patrolData.rekomendasi_umum" class="mt-4 p-3 bg-white rounded">
                <label class="text-sm text-gray-600 font-medium">Rekomendasi</label>
                <div class="text-sm text-gray-700 mt-1">{{ patrolData.rekomendasi_umum }}</div>
              </div>
            </div>

            <!-- 11. Stop Work Authority (if issued) -->
            <div v-if="selectedPatrol.stop_work_issued" class="bg-red-100 border-2 border-red-500 rounded-lg p-4">
              <h3 class="font-semibold text-lg mb-3 text-red-700 flex items-center gap-2">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                </svg>
                STOP WORK AUTHORITY ISSUED
              </h3>
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="text-sm text-gray-600 font-medium">Area yang Dihentikan</label>
                  <div class="font-bold text-red-700">{{ selectedPatrol.stop_work_area }}</div>
                </div>
                <div>
                  <label class="text-sm text-gray-600 font-medium">Waktu Dihentikan</label>
                  <div class="font-bold text-red-700">{{ formatDate(patrolData.stop_work_waktu) }}</div>
                </div>
                <div class="col-span-2">
                  <label class="text-sm text-gray-600 font-medium">Alasan</label>
                  <div class="font-medium text-red-700">{{ selectedPatrol.stop_work_alasan }}</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Form Modal -->
    <div v-if="showFormModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div class="bg-white rounded-lg shadow-xl max-w-6xl w-full max-h-[90vh] overflow-hidden">
        <div class="flex justify-between items-center p-6 border-b sticky top-0 bg-white z-10">
          <h2 class="text-xl font-bold">{{ formMode === 'create' ? 'Buat' : 'Edit' }} Safety Patrol</h2>
          <button @click="closeFormModal" class="text-gray-500 hover:text-gray-700">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <!-- Tabs -->
        <div class="border-b px-6">
          <div class="flex space-x-4 overflow-x-auto">
            <button
              v-for="tab in 8" :key="tab"
              @click="activeTab = tab"
              :class="[
                'py-3 px-4 font-medium text-sm whitespace-nowrap border-b-2 transition-colors',
                activeTab === tab
                  ? 'border-primary-600 text-primary-600'
                  : 'border-transparent text-gray-600 hover:text-gray-900'
              ]"
            >
              {{ ['Data Dasar', 'Kondisi Lingkungan', 'Unsafe Condition', 'Unsafe Act', 'Kepatuhan APD', 'Housekeeping & Peralatan', 'Emergency & Positif', 'Action Items'][tab - 1] }}
            </button>
          </div>
        </div>

        <div class="p-6 overflow-y-auto max-h-[calc(90vh-200px)]">
          <!-- Tab 1: Data Dasar -->
          <div v-if="activeTab === 1" class="space-y-4">
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Nomor Patrol</label>
                <input v-model="formData.nomor_patrol" type="text" readonly
                  class="w-full px-3 py-2 border rounded-lg bg-gray-100"
                  placeholder="Auto-generated" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal *</label>
                <input v-model="formData.tanggal_patrol" type="date" required
                  class="w-full px-3 py-2 border rounded-lg" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Waktu Mulai *</label>
                <input v-model="formData.waktu_mulai" type="time" required
                  class="w-full px-3 py-2 border rounded-lg" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Waktu Selesai</label>
                <input v-model="formData.waktu_selesai" type="time"
                  class="w-full px-3 py-2 border rounded-lg" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Shift *</label>
                <select v-model="formData.shift" required class="w-full px-3 py-2 border rounded-lg">
                  <option value="pagi">Pagi</option>
                  <option value="siang">Siang</option>
                  <option value="malam">Malam</option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Unit *</label>
                <select v-model="formData.unit_id" required class="w-full px-3 py-2 border rounded-lg">
                  <option value="">Pilih Unit</option>
                  <option v-for="unit in unitsStore.units" :key="unit.id" :value="unit.id">
                    {{ unit.nama }}
                  </option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Jenis Patrol *</label>
                <select v-model="formData.jenis_patrol" required class="w-full px-3 py-2 border rounded-lg">
                  <option value="rutin">Rutin</option>
                  <option value="insidental">Insidental</option>
                  <option value="khusus">Khusus</option>
                  <option value="emergency">Emergency</option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Ketua Patrol *</label>
                <input v-model="formData.ketua_patrol" type="text" required
                  class="w-full px-3 py-2 border rounded-lg" />
              </div>
              <div class="col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-1">Area Patrol *</label>
                <input v-model="formData.area_patrol" type="text" required
                  class="w-full px-3 py-2 border rounded-lg" />
              </div>
              <div class="col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-1">Lokasi Spesifik</label>
                <input v-model="formData.lokasi_spesifik" type="text"
                  class="w-full px-3 py-2 border rounded-lg" />
              </div>
              <div class="col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-1">Tujuan Patrol</label>
                <textarea v-model="formData.tujuan_patrol" rows="2"
                  class="w-full px-3 py-2 border rounded-lg"></textarea>
              </div>
              <div class="col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-2">Anggota Patrol</label>
                <div class="flex gap-2 mb-2">
                  <input v-model="newAnggota" type="text" placeholder="Nama anggota"
                    @keyup.enter="addAnggota"
                    class="flex-1 px-3 py-2 border rounded-lg" />
                  <button type="button" @click="addAnggota"
                    class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                    Tambah
                  </button>
                </div>
                <div class="flex flex-wrap gap-2">
                  <span v-for="(anggota, idx) in formData.anggota_patrol" :key="idx"
                    class="inline-flex items-center gap-2 px-3 py-1 bg-blue-100 text-blue-800 rounded-full">
                    {{ anggota }}
                    <button type="button" @click="removeAnggota(idx)" class="text-blue-600 hover:text-blue-900">×</button>
                  </span>
                </div>
              </div>
            </div>
          </div>

          <!-- Tab 2: Kondisi Lingkungan -->
          <div v-if="activeTab === 2" class="space-y-4">
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Cuaca</label>
                <select v-model="formData.cuaca" class="w-full px-3 py-2 border rounded-lg">
                  <option value="cerah">Cerah</option>
                  <option value="berawan">Berawan</option>
                  <option value="hujan">Hujan</option>
                  <option value="gerimis">Gerimis</option>
                  <option value="badai">Badai</option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Suhu (°C)</label>
                <input v-model.number="(formData as any).suhu" type="number" step="0.1"
                  class="w-full px-3 py-2 border rounded-lg" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Pencahayaan</label>
                <select v-model="formData.kondisi_pencahayaan" class="w-full px-3 py-2 border rounded-lg">
                  <option value="baik">Baik</option>
                  <option value="kurang">Kurang</option>
                  <option value="gelap">Gelap</option>
                  <option value="silau">Silau</option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Ventilasi</label>
                <select v-model="formData.kondisi_ventilasi" class="w-full px-3 py-2 border rounded-lg">
                  <option value="baik">Baik</option>
                  <option value="kurang">Kurang</option>
                  <option value="pengap">Pengap</option>
                  <option value="berbau">Berbau</option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Tingkat Kebisingan (dB)</label>
                <input v-model.number="formData.tingkat_kebisingan" type="number"
                  class="w-full px-3 py-2 border rounded-lg" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Kondisi Lantai</label>
                <select v-model="(formData as any).kondisi_lantai" class="w-full px-3 py-2 border rounded-lg">
                  <option value="kering">Kering</option>
                  <option value="basah">Basah</option>
                  <option value="licin">Licin</option>
                  <option value="berminyak">Berminyak</option>
                  <option value="tidak_rata">Tidak Rata</option>
                </select>
              </div>
            </div>
          </div>

          <!-- Tab 3: Unsafe Condition -->
          <div v-if="activeTab === 3" class="space-y-4">
            <div class="flex justify-between items-center mb-4">
              <h3 class="font-semibold text-lg">Kondisi Tidak Aman</h3>
              <button type="button" @click="addUnsafeCondition"
                class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700">
                + Tambah Kondisi
              </button>
            </div>
            <div v-if="formData.unsafe_condition && formData.unsafe_condition.length > 0" class="space-y-4">
              <div v-for="(item, idx) in formData.unsafe_condition" :key="idx"
                class="p-4 border-2 border-red-200 rounded-lg bg-red-50">
                <div class="flex justify-between items-start mb-3">
                  <h4 class="font-medium">Kondisi #{{ idx + 1 }}</h4>
                  <button type="button" @click="removeUnsafeCondition(idx)"
                    class="text-red-600 hover:text-red-900">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                  </button>
                </div>
                <div class="grid grid-cols-2 gap-3">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Kategori</label>
                    <select v-model="item.kategori" class="w-full px-3 py-2 border rounded-lg">
                      <option value="listrik">Listrik</option>
                      <option value="mekanik">Mekanik</option>
                      <option value="kimia">Kimia</option>
                      <option value="fisik">Fisik</option>
                      <option value="ergonomi">Ergonomi</option>
                      <option value="lingkungan">Lingkungan</option>
                    </select>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Tingkat Risiko</label>
                    <select v-model="item.tingkat_risiko" class="w-full px-3 py-2 border rounded-lg">
                      <option value="kritikal">Kritikal</option>
                      <option value="tinggi">Tinggi</option>
                      <option value="sedang">Sedang</option>
                      <option value="rendah">Rendah</option>
                    </select>
                  </div>
                  <div class="col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Deskripsi</label>
                    <textarea v-model="item.deskripsi" rows="2"
                      class="w-full px-3 py-2 border rounded-lg"></textarea>
                  </div>
                  <div class="col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Lokasi</label>
                    <input v-model="item.lokasi" type="text"
                      class="w-full px-3 py-2 border rounded-lg" />
                  </div>
                  <div class="col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Tindakan</label>
                    <textarea v-model="item.tindakan" rows="2"
                      class="w-full px-3 py-2 border rounded-lg"></textarea>
                  </div>
                  <div class="col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Foto Bukti</label>
                    <input type="file" accept="image/*" multiple
                      @change="handleUnsafeConditionPhotoUpload($event, idx)"
                      class="hidden"
                      :ref="`fileInput-unsafe-${idx}`"
                    />
                    <button type="button"
                      @click="($refs[`fileInput-unsafe-${idx}`] as any)?.[0]?.click()"
                      class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 text-sm">
                      📷 Upload Foto
                    </button>
                    <p class="text-xs text-gray-500 mt-1">Foto akan dikompres otomatis jika >1MB</p>
                    
                    <!-- Preview Foto -->
                    <div v-if="item.foto_urls && item.foto_urls.length > 0" class="grid grid-cols-4 gap-2 mt-3">
                      <div v-for="(url, photoIdx) in item.foto_urls" :key="photoIdx"
                        class="relative group">
                        <img :src="url" alt="Foto" loading="lazy" class="w-full h-24 object-cover rounded border" />
                        <button type="button"
                          @click="removeUnsafeConditionPhoto(idx, photoIdx)"
                          class="absolute top-1 right-1 bg-red-600 text-white rounded-full w-6 h-6 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
                          ×
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div v-else class="text-center text-gray-500 py-8">
              Belum ada kondisi tidak aman. Klik "Tambah Kondisi" untuk menambahkan.
            </div>
          </div>

          <!-- Tab 4: Unsafe Act -->
          <div v-if="activeTab === 4" class="space-y-4">
            <div class="flex justify-between items-center mb-4">
              <h3 class="font-semibold text-lg">Tindakan Tidak Aman</h3>
              <button type="button" @click="addUnsafeAct"
                class="px-4 py-2 bg-orange-600 text-white rounded-lg hover:bg-orange-700">
                + Tambah Tindakan
              </button>
            </div>
            <div v-if="formData.unsafe_act && formData.unsafe_act.length > 0" class="space-y-4">
              <div v-for="(item, idx) in formData.unsafe_act" :key="idx"
                class="p-4 border-2 border-orange-200 rounded-lg bg-orange-50">
                <div class="flex justify-between items-start mb-3">
                  <h4 class="font-medium">Tindakan #{{ idx + 1 }}</h4>
                  <button type="button" @click="removeUnsafeAct(idx)"
                    class="text-orange-600 hover:text-orange-900">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                  </button>
                </div>
                <div class="grid grid-cols-2 gap-3">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Nama Pekerja</label>
                    <input v-model="item.pekerja" type="text"
                      class="w-full px-3 py-2 border rounded-lg" />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Tingkat Risiko</label>
                    <select v-model="item.tingkat_risiko" class="w-full px-3 py-2 border rounded-lg">
                      <option value="kritikal">Kritikal</option>
                      <option value="tinggi">Tinggi</option>
                      <option value="sedang">Sedang</option>
                      <option value="rendah">Rendah</option>
                    </select>
                  </div>
                  <div class="col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Deskripsi</label>
                    <textarea v-model="item.deskripsi" rows="2"
                      class="w-full px-3 py-2 border rounded-lg"></textarea>
                  </div>
                  <div class="col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Lokasi</label>
                    <input v-model="item.lokasi" type="text"
                      class="w-full px-3 py-2 border rounded-lg" />
                  </div>
                  <div class="col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Tindakan Langsung</label>
                    <textarea v-model="item.tindakan_langsung" rows="2"
                      class="w-full px-3 py-2 border rounded-lg" 
                      placeholder="Teguran/koreksi yang diberikan langsung"></textarea>
                  </div>
                </div>
              </div>
            </div>
            <div v-else class="text-center text-gray-500 py-8">
              Belum ada tindakan tidak aman. Klik "Tambah Tindakan" untuk menambahkan.
            </div>
          </div>

          <!-- Tab 5: Kepatuhan APD -->
          <div v-if="activeTab === 5" class="space-y-4">
            <h3 class="font-semibold text-lg mb-4">Observasi Kepatuhan APD</h3>
            <div class="grid grid-cols-3 gap-4 mb-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Pekerja Diamati</label>
                <input v-model.number="formData.pekerja_diamati" type="number" min="0"
                  @input="calculateAPDCompliance"
                  class="w-full px-3 py-2 border rounded-lg" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Patuh APD</label>
                <input v-model.number="formData.pekerja_patuh_apd" type="number" min="0"
                  @input="calculateAPDCompliance"
                  class="w-full px-3 py-2 border rounded-lg" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Persentase Kepatuhan</label>
                <div class="text-2xl font-bold text-green-600 text-center py-2">
                  {{ formData.persentase_kepatuhan_apd || 0 }}%
                </div>
              </div>
            </div>
            
            <div class="p-4 bg-blue-50 rounded-lg">
              <h4 class="font-medium mb-3">Detail APD per Jenis</h4>
              <div class="space-y-2">
                <div v-for="(apd, idx) in ['Helm', 'Safety Shoes', 'Safety Glasses', 'Sarung Tangan', 'Ear Plug', 'Masker', 'Rompi', 'Harness']" :key="apd"
                  class="grid grid-cols-4 gap-2 items-center">
                  <div class="font-medium">{{ apd }}</div>
                  <div>
                    <label class="flex items-center gap-2">
                      <input type="checkbox" :checked="getAPDDetail(apd).wajib" 
                        @change="updateAPDDetail(apd, 'wajib', ($event.target as HTMLInputElement).checked)"
                        class="rounded" />
                      <span class="text-sm">Wajib</span>
                    </label>
                  </div>
                  <div>
                    <input type="number" min="0" :value="getAPDDetail(apd).patuh"
                      @input="updateAPDDetail(apd, 'patuh', parseInt(($event.target as HTMLInputElement).value) || 0)"
                      placeholder="Patuh"
                      class="w-full px-2 py-1 border rounded text-sm" />
                  </div>
                  <div>
                    <input type="number" min="0" :value="getAPDDetail(apd).tidak_patuh"
                      @input="updateAPDDetail(apd, 'tidak_patuh', parseInt(($event.target as HTMLInputElement).value) || 0)"
                      placeholder="Tidak Patuh"
                      class="w-full px-2 py-1 border rounded text-sm" />
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Tab 6: Housekeeping & Peralatan -->
          <div v-if="activeTab === 6" class="space-y-6">
            <!-- Housekeeping -->
            <div class="p-4 bg-blue-50 rounded-lg">
              <h3 class="font-semibold text-lg mb-4">Housekeeping</h3>
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Skor (0-100)</label>
                  <input v-model.number="formData.skor_housekeeping" type="number" min="0" max="100"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Kondisi</label>
                  <select v-model="formData.kondisi_housekeeping" class="w-full px-3 py-2 border rounded-lg">
                    <option value="sangat_baik">Sangat Baik</option>
                    <option value="baik">Baik</option>
                    <option value="cukup">Cukup</option>
                    <option value="kurang">Kurang</option>
                    <option value="buruk">Buruk</option>
                  </select>
                </div>
                <div class="col-span-2">
                  <label class="block text-sm font-medium text-gray-700 mb-1">Area Kotor/Berantakan</label>
                  <textarea v-model="formData.area_kotor" rows="2"
                    class="w-full px-3 py-2 border rounded-lg"></textarea>
                </div>
                <div class="col-span-2">
                  <label class="block text-sm font-medium text-gray-700 mb-1">Area Rapi/Bersih</label>
                  <textarea v-model="formData.area_rapi" rows="2"
                    class="w-full px-3 py-2 border rounded-lg"></textarea>
                </div>
              </div>
            </div>

            <!-- Peralatan & Mesin -->
            <div class="p-4 bg-purple-50 rounded-lg">
              <h3 class="font-semibold text-lg mb-4">Peralatan & Mesin</h3>
              <div class="grid grid-cols-3 gap-4 mb-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Diperiksa</label>
                  <input v-model.number="formData.jumlah_mesin_diperiksa" type="number" min="0"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Kondisi Baik</label>
                  <input v-model.number="formData.mesin_kondisi_baik" type="number" min="0"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Perlu Perbaikan</label>
                  <input v-model.number="formData.mesin_perlu_perbaikan" type="number" min="0"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
              </div>
            </div>
          </div>

          <!-- Tab 7: Emergency & Positif -->
          <div v-if="activeTab === 7" class="space-y-6">
            <!-- Emergency Facilities -->
            <div class="p-4 bg-yellow-50 rounded-lg">
              <h3 class="font-semibold text-lg mb-4">Fasilitas Darurat</h3>
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="flex items-center gap-2">
                    <input v-model="formData.jalur_evakuasi_bebas" type="checkbox" class="rounded" />
                    <span class="text-sm font-medium">Jalur Evakuasi Bebas</span>
                  </label>
                </div>
                <div>
                  <label class="flex items-center gap-2">
                    <input v-model="formData.pintu_darurat_berfungsi" type="checkbox" class="rounded" />
                    <span class="text-sm font-medium">Pintu Darurat Berfungsi</span>
                  </label>
                </div>
                <div>
                  <label class="flex items-center gap-2">
                    <input v-model="formData.apar_tersedia" type="checkbox" class="rounded" />
                    <span class="text-sm font-medium">APAR Tersedia</span>
                  </label>
                </div>
                <div>
                  <label class="flex items-center gap-2">
                    <input v-model="(formData as any).lampu_darurat_berfungsi" type="checkbox" class="rounded" />
                    <span class="text-sm font-medium">Lampu Darurat Berfungsi</span>
                  </label>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Jumlah APAR</label>
                  <input v-model.number="(formData as any).jumlah_apar" type="number" min="0"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">APAR Expired</label>
                  <input v-model.number="formData.apar_expire" type="number" min="0"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div class="col-span-2">
                  <label class="flex items-center gap-2">
                    <input v-model="(formData as any).signage_darurat_jelas" type="checkbox" class="rounded" />
                    <span class="text-sm font-medium">Signage Darurat Jelas & Terlihat</span>
                  </label>
                </div>
              </div>
            </div>

            <!-- Stop Work Authority -->
            <div class="p-4 bg-red-50 border-2 border-red-300 rounded-lg">
              <h3 class="font-semibold text-lg mb-4 text-red-700">Stop Work Authority</h3>
              <div class="space-y-3">
                <div>
                  <label class="flex items-center gap-2">
                    <input v-model="formData.stop_work_issued" type="checkbox" class="rounded" />
                    <span class="text-sm font-medium">Pekerjaan Dihentikan (Stop Work Issued)</span>
                  </label>
                </div>
                <div v-if="formData.stop_work_issued" class="space-y-3 pl-6 border-l-4 border-red-500">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Area yang Dihentikan *</label>
                    <input v-model="formData.stop_work_area" type="text"
                      class="w-full px-3 py-2 border rounded-lg" />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Alasan Stop Work *</label>
                    <textarea v-model="formData.stop_work_alasan" rows="3"
                      class="w-full px-3 py-2 border rounded-lg"></textarea>
                  </div>
                </div>
              </div>
            </div>

            <!-- Temuan Positif -->
            <div class="p-4 bg-green-50 rounded-lg">
              <h3 class="font-semibold text-lg mb-4">Temuan Positif</h3>
              <div class="space-y-3">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Praktik Baik yang Ditemukan</label>
                  <textarea v-model="(formData as any).praktik_baik" rows="3"
                    class="w-full px-3 py-2 border rounded-lg"
                    placeholder="Contoh: Pekerja menggunakan APD lengkap meskipun tidak dipantau"></textarea>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Area dengan Kondisi Excellent</label>
                  <textarea v-model="(formData as any).area_excellent" rows="2"
                    class="w-full px-3 py-2 border rounded-lg"></textarea>
                </div>
              </div>
            </div>
          </div>

          <!-- Tab 8: Action Items & Scoring -->
          <div v-if="activeTab === 8" class="space-y-6">
            <!-- Action Items -->
            <div class="p-4 bg-indigo-50 rounded-lg">
              <div class="flex justify-between items-center mb-4">
                <h3 class="font-semibold text-lg">Action Items</h3>
                <button type="button" @click="addActionItem"
                  class="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 text-sm">
                  + Tambah Action
                </button>
              </div>
              <div v-if="formData.action_items && formData.action_items.length > 0" class="space-y-3">
                <div v-for="(item, idx) in formData.action_items" :key="idx"
                  class="p-3 bg-white border rounded-lg">
                  <div class="flex justify-between items-start mb-3">
                    <h4 class="font-medium text-sm">Action #{{ idx + 1 }}</h4>
                    <button type="button" @click="removeActionItem(idx)"
                      class="text-red-600 hover:text-red-900 text-sm">×</button>
                  </div>
                  <div class="grid grid-cols-2 gap-3">
                    <div class="col-span-2">
                      <label class="block text-xs font-medium text-gray-700 mb-1">Temuan</label>
                      <textarea v-model="item.temuan" rows="2"
                        class="w-full px-2 py-1 border rounded text-sm"></textarea>
                    </div>
                    <div class="col-span-2">
                      <label class="block text-xs font-medium text-gray-700 mb-1">Tindakan</label>
                      <textarea v-model="item.tindakan" rows="2"
                        class="w-full px-2 py-1 border rounded text-sm"></textarea>
                    </div>
                    <div>
                      <label class="block text-xs font-medium text-gray-700 mb-1">PIC</label>
                      <input v-model="item.pic" type="text"
                        class="w-full px-2 py-1 border rounded text-sm" />
                    </div>
                    <div>
                      <label class="block text-xs font-medium text-gray-700 mb-1">Target Date</label>
                      <input v-model="item.target_date" type="date"
                        class="w-full px-2 py-1 border rounded text-sm" />
                    </div>
                    <div>
                      <label class="block text-xs font-medium text-gray-700 mb-1">Prioritas</label>
                      <select v-model="item.prioritas" class="w-full px-2 py-1 border rounded text-sm">
                        <option value="kritikal">Kritikal</option>
                        <option value="tinggi">Tinggi</option>
                        <option value="sedang">Sedang</option>
                        <option value="rendah">Rendah</option>
                      </select>
                    </div>
                    <div>
                      <label class="block text-xs font-medium text-gray-700 mb-1">Status</label>
                      <select v-model="item.status" class="w-full px-2 py-1 border rounded text-sm">
                        <option value="belum_mulai">Belum Mulai</option>
                        <option value="sedang_berjalan">Sedang Berjalan</option>
                        <option value="selesai">Selesai</option>
                        <option value="tertunda">Tertunda</option>
                      </select>
                    </div>
                  </div>
                </div>
              </div>
              <div v-else class="text-center text-gray-500 py-4 text-sm">
                Belum ada action items
              </div>
            </div>

            <!-- Scoring & Rekomendasi -->
            <div class="p-4 bg-purple-50 rounded-lg">
              <h3 class="font-semibold text-lg mb-4">Scoring & Rekomendasi</h3>
              <div class="grid grid-cols-4 gap-4 mb-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Skor APD</label>
                  <input v-model.number="formData.skor_apd" type="number" min="0" max="100"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Skor Kondisi Area</label>
                  <input v-model.number="formData.skor_kondisi_area" type="number" min="0" max="100"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Skor Peralatan</label>
                  <input v-model.number="formData.skor_peralatan" type="number" min="0" max="100"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Skor Keseluruhan</label>
                  <input v-model.number="formData.skor_keseluruhan" type="number" min="0" max="100"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Grade</label>
                  <select v-model="formData.grade" class="w-full px-3 py-2 border rounded-lg">
                    <option value="A">A (90-100)</option>
                    <option value="B">B (80-89)</option>
                    <option value="C">C (70-79)</option>
                    <option value="D">D (60-69)</option>
                    <option value="E">E (<60)</option>
                  </select>
                </div>
                <div class="col-span-3">
                  <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                  <select v-model="formData.status" class="w-full px-3 py-2 border rounded-lg">
                    <option value="draft">Draft</option>
                    <option value="submitted">Submitted</option>
                    <option value="reviewed">Reviewed</option>
                    <option value="closed">Closed</option>
                  </select>
                </div>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Rekomendasi Umum</label>
                <div class="flex gap-2 mb-2">
                  <input v-model="newRekomendasi" type="text" placeholder="Tambah rekomendasi"
                    @keyup.enter="addRekomendasi"
                    class="flex-1 px-3 py-2 border rounded-lg text-sm" />
                  <button type="button" @click="addRekomendasi"
                    class="px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 text-sm">
                    Tambah
                  </button>
                </div>
                <div v-if="formData.rekomendasi && formData.rekomendasi.length > 0" class="space-y-1">
                  <div v-for="(rek, idx) in formData.rekomendasi" :key="idx"
                    class="flex items-start gap-2 p-2 bg-white rounded border">
                    <span class="flex-1 text-sm">{{ idx + 1 }}. {{ rek }}</span>
                    <button type="button" @click="removeRekomendasi(idx)"
                      class="text-red-600 hover:text-red-900 text-sm">×</button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Footer Actions -->
        <div class="border-t p-6 bg-gray-50 flex justify-between">
          <button type="button" @click="closeFormModal"
            class="px-6 py-2 border border-gray-300 rounded-lg hover:bg-gray-100">
            Batal
          </button>
          <div class="flex gap-2">
            <button v-if="activeTab > 1" type="button" @click="activeTab--"
              class="px-6 py-2 border border-primary-600 text-primary-600 rounded-lg hover:bg-primary-50">
              ← Sebelumnya
            </button>
            <button v-if="activeTab < 8" type="button" @click="activeTab++"
              class="px-6 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700">
              Selanjutnya →
            </button>
            <button v-if="activeTab === 8" type="button" @click="handleSubmit"
              class="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700">
              💾 Simpan
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Image Modal -->
    <div v-if="showImageModal" class="fixed inset-0 z-[60] overflow-y-auto">
      <div class="flex items-center justify-center min-h-screen p-4">
        <div class="fixed inset-0 bg-black bg-opacity-75 transition-opacity" @click="closeImageModal"></div>
        
        <div class="relative bg-white rounded-lg max-w-4xl w-full max-h-[90vh] overflow-hidden shadow-2xl">
          <!-- Close button -->
          <button @click="closeImageModal" 
            class="absolute top-4 right-4 z-10 p-2 bg-white rounded-full shadow-lg hover:bg-gray-100 transition-colors">
            <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>

          <!-- Image container -->
          <div class="flex items-center justify-center p-4 bg-gray-100">
            <img :src="selectedImageUrl" alt="Preview" class="max-w-full max-h-[85vh] object-contain" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
