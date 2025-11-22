<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { safetyDrillService, type SafetyDrill, type DrillFilters } from '@/services/safety-drill.service'

// State
const drills = ref<SafetyDrill[]>([])
const loading = ref(false)
const showDetailModal = ref(false)
const showFormModal = ref(false)
const selectedDrill = ref<SafetyDrill | null>(null)
const isEditing = ref(false)

// Statistics
const stats = ref({
  total: 0,
  bulan_ini: 0,
  completed: 0,
  planned: 0,
  ongoing: 0,
  avg_score: 0,
  grade_a: 0,
  grade_b: 0
})

// Pagination
const currentPage = ref(1)
const pageSize = ref(20)
const totalRecords = ref(0)
const totalPages = ref(0)

// Filters
const filters = ref<DrillFilters>({
  search: '',
  jenis_drill: '',
  kategori_drill: '',
  status: '',
  unit_kerja: '',
  grade: ''
})

// Form Data
const formData = ref<SafetyDrill>({
  nomor_drill: '',
  jenis_drill: 'fire_drill',
  kategori_drill: 'planned',
  tingkat_drill: 'plant_wide',
  judul_drill: '',
  deskripsi: '',
  unit_kerja: '',
  area_lokasi: '',
  titik_kumpul: '',
  tanggal_drill: '',
  waktu_mulai: '',
  tujuan_drill: '',
  skenario: '',
  drill_commander: '',
  safety_officer: '',
  jumlah_peserta: 0,
  status: 'planned',
  created_by: 'Current User'
})

// Options
const jenisOptions = [
  { value: 'fire_drill', label: 'Kebakaran' },
  { value: 'earthquake_drill', label: 'Gempa Bumi' },
  { value: 'evacuation_drill', label: 'Evakuasi Umum' },
  { value: 'chemical_spill', label: 'Tumpahan Kimia' },
  { value: 'medical_emergency', label: 'Kedaruratan Medis' },
  { value: 'bomb_threat', label: 'Ancaman Bom' },
  { value: 'gas_leak', label: 'Kebocoran Gas' },
  { value: 'confined_space', label: 'Ruang Terbatas' },
  { value: 'height_rescue', label: 'Penyelamatan Ketinggian' },
  { value: 'water_rescue', label: 'Penyelamatan Air' },
  { value: 'severe_weather', label: 'Cuaca Ekstrem' },
  { value: 'security_breach', label: 'Pelanggaran Keamanan' },
  { value: 'power_outage', label: 'Pemadaman Listrik' },
  { value: 'active_shooter', label: 'Penembak Aktif' },
  { value: 'full_scale', label: 'Drill Skala Penuh' }
]

const kategoriOptions = [
  { value: 'planned', label: 'Terencana' },
  { value: 'unannounced', label: 'Tanpa Pemberitahuan' },
  { value: 'tabletop', label: 'Simulasi Meja' },
  { value: 'functional', label: 'Fungsional' },
  { value: 'full_scale', label: 'Skala Penuh' }
]

const tingkatOptions = [
  { value: 'plant_wide', label: 'Seluruh Pabrik' },
  { value: 'area_specific', label: 'Area Tertentu' },
  { value: 'department', label: 'Departemen' },
  { value: 'shift_based', label: 'Per Shift' },
  { value: 'team_based', label: 'Per Tim' }
]

const statusOptions = [
  { value: 'planned', label: 'Direncanakan', color: 'blue' },
  { value: 'ongoing', label: 'Sedang Berlangsung', color: 'yellow' },
  { value: 'completed', label: 'Selesai', color: 'green' },
  { value: 'cancelled', label: 'Dibatalkan', color: 'red' },
  { value: 'postponed', label: 'Ditunda', color: 'orange' }
]

// Active tab for form modal
const activeTab = ref(0)
const formTabs = ['Data Dasar', 'Tim & Peserta', 'Pelaksanaan', 'Evaluasi', 'Dokumentasi']

// Helpers for dynamic arrays
const newObserver = ref('')
const newERTMember = ref('')
const newSasaran = ref('')
const newKriteria = ref('')
const newAreaTerdampak = ref('')
const newTemuan = ref({ kategori: 'Minor', deskripsi: '', lokasi: '', severity: 'Low' })
const newActionItem = ref({ item: '', pic: '', target_date: '', status: 'Open', priority: 'Medium' })
const newKorban = ref({ nama: '', kondisi: '', tindakan: '', waktu_rescue: '' })

// Photo/Document Upload State
const showImagePreview = ref(false)
const previewImageUrl = ref('')

// Methods
const loadDrills = async () => {
  loading.value = true
  try {
    const response = await safetyDrillService.getPaginated(
      filters.value,
      { page: currentPage.value, pageSize: pageSize.value }
    )
    drills.value = response.data
    totalRecords.value = response.count
    totalPages.value = response.totalPages
  } catch (error) {
    console.error('Error loading drills:', error)
  } finally {
    loading.value = false
  }
}

const loadStats = async () => {
  try {
    stats.value = await safetyDrillService.getStatistics()
  } catch (error) {
    console.error('Error loading statistics:', error)
  }
}

const viewDetail = (drill: SafetyDrill) => {
  selectedDrill.value = drill
  showDetailModal.value = true
}

const openFormModal = (drill?: SafetyDrill) => {
  if (drill) {
    isEditing.value = true
    formData.value = { ...drill }
  } else {
    isEditing.value = false
    resetForm()
  }
  activeTab.value = 0
  showFormModal.value = true
}

const closeFormModal = () => {
  showFormModal.value = false
  resetForm()
}

const resetForm = () => {
  formData.value = {
    nomor_drill: '',
    jenis_drill: 'fire_drill',
    kategori_drill: 'planned',
    tingkat_drill: 'plant_wide',
    judul_drill: '',
    deskripsi: '',
    unit_kerja: '',
    area_lokasi: '',
    titik_kumpul: '',
    tanggal_drill: '',
    waktu_mulai: '',
    tujuan_drill: '',
    skenario: '',
    drill_commander: '',
    safety_officer: '',
    jumlah_peserta: 0,
    status: 'planned',
    created_by: 'Current User'
  }
}

const handleSubmit = async () => {
  loading.value = true
  try {
    if (isEditing.value && formData.value.id) {
      await safetyDrillService.update(formData.value.id, formData.value)
    } else {
      await safetyDrillService.create(formData.value)
    }
    closeFormModal()
    await loadDrills()
    await loadStats()
  } catch (error) {
    console.error('Error saving drill:', error)
    alert('Gagal menyimpan data drill')
  } finally {
    loading.value = false
  }
}

const deleteDrill = async (id: string) => {
  if (!confirm('Apakah Anda yakin ingin menghapus drill ini?')) return
  
  loading.value = true
  try {
    await safetyDrillService.delete(id)
    await loadDrills()
    await loadStats()
  } catch (error) {
    console.error('Error deleting drill:', error)
    alert('Gagal menghapus data drill')
  } finally {
    loading.value = false
  }
}

// Helper methods for arrays
const addObserver = () => {
  if (newObserver.value.trim()) {
    if (!formData.value.observer) formData.value.observer = []
    formData.value.observer.push(newObserver.value.trim())
    newObserver.value = ''
  }
}

const removeObserver = (index: number) => {
  formData.value.observer?.splice(index, 1)
}

const addERTMember = () => {
  if (newERTMember.value.trim()) {
    if (!formData.value.ert_members) formData.value.ert_members = []
    formData.value.ert_members.push(newERTMember.value.trim())
    newERTMember.value = ''
  }
}

const removeERTMember = (index: number) => {
  formData.value.ert_members?.splice(index, 1)
}

const addSasaran = () => {
  if (newSasaran.value.trim()) {
    if (!formData.value.sasaran_drill) formData.value.sasaran_drill = []
    formData.value.sasaran_drill.push(newSasaran.value.trim())
    newSasaran.value = ''
  }
}

const removeSasaran = (index: number) => {
  formData.value.sasaran_drill?.splice(index, 1)
}

const addKriteria = () => {
  if (newKriteria.value.trim()) {
    if (!formData.value.kriteria_keberhasilan) formData.value.kriteria_keberhasilan = []
    formData.value.kriteria_keberhasilan.push(newKriteria.value.trim())
    newKriteria.value = ''
  }
}

const removeKriteria = (index: number) => {
  formData.value.kriteria_keberhasilan?.splice(index, 1)
}

const addAreaTerdampak = () => {
  if (newAreaTerdampak.value.trim()) {
    if (!formData.value.area_terdampak) formData.value.area_terdampak = []
    formData.value.area_terdampak.push(newAreaTerdampak.value.trim())
    newAreaTerdampak.value = ''
  }
}

const removeAreaTerdampak = (index: number) => {
  formData.value.area_terdampak?.splice(index, 1)
}

const addTemuan = () => {
  if (newTemuan.value.deskripsi.trim()) {
    if (!formData.value.detail_temuan) formData.value.detail_temuan = []
    formData.value.detail_temuan.push({ ...newTemuan.value })
    newTemuan.value = { kategori: 'Minor', deskripsi: '', lokasi: '', severity: 'Low' }
  }
}

const removeTemuan = (index: number) => {
  formData.value.detail_temuan?.splice(index, 1)
}

const addActionItem = () => {
  if (newActionItem.value.item.trim()) {
    if (!formData.value.action_items) formData.value.action_items = []
    formData.value.action_items.push({ ...newActionItem.value })
    newActionItem.value = { item: '', pic: '', target_date: '', status: 'Open', priority: 'Medium' }
  }
}

const removeActionItem = (index: number) => {
  formData.value.action_items?.splice(index, 1)
}

const addKorban = () => {
  if (newKorban.value.nama.trim()) {
    if (!formData.value.detail_korban) formData.value.detail_korban = []
    formData.value.detail_korban.push({ ...newKorban.value })
    newKorban.value = { nama: '', kondisi: '', tindakan: '', waktu_rescue: '' }
  }
}

const removeKorban = (index: number) => {
  formData.value.detail_korban?.splice(index, 1)
}

// Photo Upload Handlers
const handlePhotoUpload = (event: Event) => {
  const input = event.target as HTMLInputElement
  if (input.files && input.files.length > 0) {
    const file = input.files[0]
    if (!file) return
    
    const reader = new FileReader()
    
    reader.onload = (e) => {
      const result = e.target?.result as string
      if (!formData.value.foto_dokumentasi) {
        formData.value.foto_dokumentasi = []
      }
      formData.value.foto_dokumentasi.push(result)
    }
    
    reader.readAsDataURL(file)
    input.value = ''
  }
}

const removePhoto = (index: number) => {
  formData.value.foto_dokumentasi?.splice(index, 1)
}

const viewImage = (url: string) => {
  previewImageUrl.value = url
  showImagePreview.value = true
}

const handleDocumentUpload = (event: Event) => {
  const input = event.target as HTMLInputElement
  if (input.files && input.files.length > 0) {
    const file = input.files[0]
    if (!file) return
    
    const reader = new FileReader()
    
    reader.onload = (e) => {
      const result = e.target?.result as string
      if (!formData.value.dokumen_pendukung) {
        formData.value.dokumen_pendukung = []
      }
      formData.value.dokumen_pendukung.push(result)
    }
    
    reader.readAsDataURL(file)
    input.value = ''
  }
}

const removeDocument = (index: number) => {
  formData.value.dokumen_pendukung?.splice(index, 1)
}

const handleVideoUpload = (event: Event) => {
  const input = event.target as HTMLInputElement
  if (input.files && input.files.length > 0) {
    const file = input.files[0]
    if (!file) return
    
    const reader = new FileReader()
    
    reader.onload = (e) => {
      const result = e.target?.result as string
      if (!formData.value.video_dokumentasi) {
        formData.value.video_dokumentasi = []
      }
      formData.value.video_dokumentasi.push(result)
    }
    
    reader.readAsDataURL(file)
    input.value = ''
  }
}

const removeVideo = (index: number) => {
  formData.value.video_dokumentasi?.splice(index, 1)
}

// Formatters
const formatDate = (dateStr: string) => {
  if (!dateStr) return '-'
  return new Date(dateStr).toLocaleDateString('id-ID', { 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  })
}

const formatTime = (timeStr: string) => {
  if (!timeStr) return '-'
  return timeStr.substring(0, 5)
}

const getStatusColor = (status: string) => {
  const statusObj = statusOptions.find(s => s.value === status)
  return statusObj?.color || 'gray'
}

const getGradeColor = (grade: string) => {
  const colors: Record<string, string> = {
    'A': 'green',
    'B': 'blue',
    'C': 'yellow',
    'D': 'orange',
    'E': 'red'
  }
  return colors[grade] || 'gray'
}

const getJenisLabel = (value: string) => {
  return jenisOptions.find(o => o.value === value)?.label || value
}

const getKategoriLabel = (value: string) => {
  return kategoriOptions.find(o => o.value === value)?.label || value
}

const getTingkatLabel = (value: string) => {
  return tingkatOptions.find(o => o.value === value)?.label || value
}

// Pagination Methods
const goToPage = (page: number) => {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
    loadDrills()
  }
}

const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++
    loadDrills()
  }
}

const prevPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--
    loadDrills()
  }
}

const changePageSize = (newSize: number) => {
  pageSize.value = newSize
  currentPage.value = 1
  loadDrills()
}

// Computed for pagination display
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

// Watch filters to reset pagination
const applyFilters = () => {
  currentPage.value = 1
  loadDrills()
}

// Computed
const filteredDrills = computed(() => {
  return drills.value
})

// Lifecycle
onMounted(() => {
  loadDrills()
  loadStats()
})
</script>

<template>
  <div class="p-6">
    <!-- Header -->
    <div class="mb-6">
      <h1 class="text-2xl font-bold text-gray-800">Safety Drill Management</h1>
      <p class="text-gray-600">Manajemen drill keselamatan dan latihan tanggap darurat</p>
    </div>

    <!-- Statistics Cards -->
    <div class="grid grid-cols-1 md:grid-cols-5 gap-4 mb-6">
      <div class="bg-white rounded-lg shadow p-4">
        <div class="text-sm text-gray-600">Total Drill</div>
        <div class="text-2xl font-bold text-gray-800">{{ stats.total }}</div>
      </div>
      <div class="bg-white rounded-lg shadow p-4">
        <div class="text-sm text-gray-600">Bulan Ini</div>
        <div class="text-2xl font-bold text-blue-600">{{ stats.bulan_ini }}</div>
      </div>
      <div class="bg-white rounded-lg shadow p-4">
        <div class="text-sm text-gray-600">Completed</div>
        <div class="text-2xl font-bold text-green-600">{{ stats.completed }}</div>
      </div>
      <div class="bg-white rounded-lg shadow p-4">
        <div class="text-sm text-gray-600">Planned</div>
        <div class="text-2xl font-bold text-yellow-600">{{ stats.planned }}</div>
      </div>
      <div class="bg-white rounded-lg shadow p-4">
        <div class="text-sm text-gray-600">Avg Score</div>
        <div class="text-2xl font-bold text-purple-600">{{ stats.avg_score.toFixed(1) }}%</div>
      </div>
    </div>

    <!-- Filters & Actions -->
    <div class="bg-white rounded-lg shadow p-4 mb-6">
      <div class="grid grid-cols-1 md:grid-cols-6 gap-4">
        <input
          v-model="filters.search"
          @input="loadDrills"
          type="text"
          placeholder="Cari nomor drill, judul..."
          class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
        />
        
        <select
          v-model="filters.jenis_drill"
          @change="applyFilters"
          class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
        >
          <option value="">Semua Jenis</option>
          <option v-for="option in jenisOptions" :key="option.value" :value="option.value">
            {{ option.label }}
          </option>
        </select>

        <select
          v-model="filters.kategori_drill"
          @change="applyFilters"
          class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
        >
          <option value="">Semua Kategori</option>
          <option v-for="option in kategoriOptions" :key="option.value" :value="option.value">
            {{ option.label }}
          </option>
        </select>

        <select
          v-model="filters.status"
          @change="applyFilters"
          class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
        >
          <option value="">Semua Status</option>
          <option v-for="option in statusOptions" :key="option.value" :value="option.value">
            {{ option.label }}
          </option>
        </select>

        <select
          v-model="filters.grade"
          @change="applyFilters"
          class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
        >
          <option value="">Semua Grade</option>
          <option value="A">Grade A</option>
          <option value="B">Grade B</option>
          <option value="C">Grade C</option>
          <option value="D">Grade D</option>
          <option value="E">Grade E</option>
        </select>

        <button
          @click="openFormModal()"
          class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center justify-center gap-2"
        >
          <span>+</span>
          <span>Drill Baru</span>
        </button>
      </div>
    </div>

    <!-- Drills Table -->
    <div class="bg-white rounded-lg shadow overflow-hidden">
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nomor Drill</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tanggal</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Jenis</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Kategori</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Judul</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Commander</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Grade</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-if="loading">
              <td colspan="9" class="px-6 py-4 text-center text-gray-500">
                Loading...
              </td>
            </tr>
            <tr v-else-if="filteredDrills.length === 0">
              <td colspan="9" class="px-6 py-4 text-center text-gray-500">
                Tidak ada data drill
              </td>
            </tr>
            <tr v-else v-for="drill in filteredDrills" :key="drill.id" class="hover:bg-gray-50">
              <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                {{ drill.nomor_drill }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                {{ formatDate(drill.tanggal_drill) }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                {{ getJenisLabel(drill.jenis_drill) }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                {{ getKategoriLabel(drill.kategori_drill) }}
              </td>
              <td class="px-6 py-4 text-sm text-gray-900">
                {{ drill.judul_drill }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                {{ drill.drill_commander }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span v-if="drill.grade" :class="`inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-${getGradeColor(drill.grade)}-100 text-${getGradeColor(drill.grade)}-800`">
                  {{ drill.grade }}
                </span>
                <span v-else class="text-gray-400">-</span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span :class="`inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-${getStatusColor(drill.status)}-100 text-${getStatusColor(drill.status)}-800`">
                  {{ statusOptions.find(s => s.value === drill.status)?.label }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                <button @click="viewDetail(drill)" class="text-blue-600 hover:text-blue-900 mr-3" title="Detail">
                  👁️
                </button>
                <button @click="openFormModal(drill)" class="text-green-600 hover:text-green-900 mr-3" title="Edit">
                  ✏️
                </button>
                <button @click="deleteDrill(drill.id!)" class="text-red-600 hover:text-red-900" title="Delete">
                  🗑️
                </button>
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
            <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
              <button 
                @click="prevPage" 
                :disabled="currentPage === 1"
                class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                <span class="sr-only">Previous</span>
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
                <span class="sr-only">Next</span>
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
      <div class="bg-white rounded-lg shadow-xl max-w-5xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b px-6 py-4 flex justify-between items-center">
          <h2 class="text-xl font-bold text-gray-800">Detail Safety Drill</h2>
          <button @click="showDetailModal = false" class="text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
        </div>
        
        <div class="p-6 space-y-6">
          <!-- Section 1: Informasi Dasar -->
          <div class="border-b pb-4">
            <h3 class="text-lg font-semibold text-gray-800 mb-3">Informasi Dasar</h3>
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="text-sm font-medium text-gray-600">Nomor Drill</label>
                <p class="text-gray-900">{{ selectedDrill?.nomor_drill }}</p>
              </div>
              <div>
                <label class="text-sm font-medium text-gray-600">Status</label>
                <p>
                  <span :class="`inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-${getStatusColor(selectedDrill?.status || '')}-100 text-${getStatusColor(selectedDrill?.status || '')}-800`">
                    {{ statusOptions.find(s => s.value === selectedDrill?.status)?.label }}
                  </span>
                </p>
              </div>
              <div>
                <label class="text-sm font-medium text-gray-600">Jenis Drill</label>
                <p class="text-gray-900">{{ getJenisLabel(selectedDrill?.jenis_drill || '') }}</p>
              </div>
              <div>
                <label class="text-sm font-medium text-gray-600">Kategori</label>
                <p class="text-gray-900">{{ getKategoriLabel(selectedDrill?.kategori_drill || '') }}</p>
              </div>
              <div>
                <label class="text-sm font-medium text-gray-600">Tingkat Drill</label>
                <p class="text-gray-900">{{ getTingkatLabel(selectedDrill?.tingkat_drill || '') }}</p>
              </div>
              <div>
                <label class="text-sm font-medium text-gray-600">Tanggal Drill</label>
                <p class="text-gray-900">{{ formatDate(selectedDrill?.tanggal_drill || '') }}</p>
              </div>
              <div class="col-span-2">
                <label class="text-sm font-medium text-gray-600">Judul Drill</label>
                <p class="text-gray-900">{{ selectedDrill?.judul_drill }}</p>
              </div>
              <div class="col-span-2">
                <label class="text-sm font-medium text-gray-600">Deskripsi</label>
                <p class="text-gray-900">{{ selectedDrill?.deskripsi || '-' }}</p>
              </div>
            </div>
          </div>

          <!-- Section 2: Lokasi & Waktu -->
          <div class="border-b pb-4">
            <h3 class="text-lg font-semibold text-gray-800 mb-3">Lokasi & Waktu</h3>
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="text-sm font-medium text-gray-600">Unit Kerja</label>
                <p class="text-gray-900">{{ selectedDrill?.unit_kerja }}</p>
              </div>
              <div>
                <label class="text-sm font-medium text-gray-600">Area Lokasi</label>
                <p class="text-gray-900">{{ selectedDrill?.area_lokasi }}</p>
              </div>
              <div>
                <label class="text-sm font-medium text-gray-600">Titik Kumpul</label>
                <p class="text-gray-900">{{ selectedDrill?.titik_kumpul }}</p>
              </div>
              <div>
                <label class="text-sm font-medium text-gray-600">Waktu Mulai</label>
                <p class="text-gray-900">{{ formatTime(selectedDrill?.waktu_mulai || '') }}</p>
              </div>
              <div v-if="selectedDrill?.area_terdampak && selectedDrill.area_terdampak.length > 0" class="col-span-2">
                <label class="text-sm font-medium text-gray-600">Area Terdampak</label>
                <div class="flex flex-wrap gap-2 mt-1">
                  <span v-for="(area, idx) in selectedDrill.area_terdampak" :key="idx" class="px-2 py-1 bg-gray-100 text-gray-700 text-sm rounded">
                    {{ area }}
                  </span>
                </div>
              </div>
            </div>
          </div>

          <!-- Section 3: Tim Drill -->
          <div class="border-b pb-4">
            <h3 class="text-lg font-semibold text-gray-800 mb-3">Tim Drill</h3>
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="text-sm font-medium text-gray-600">Drill Commander</label>
                <p class="text-gray-900">{{ selectedDrill?.drill_commander }}</p>
                <p class="text-sm text-gray-500">{{ selectedDrill?.jabatan_commander || '-' }}</p>
              </div>
              <div>
                <label class="text-sm font-medium text-gray-600">Safety Officer</label>
                <p class="text-gray-900">{{ selectedDrill?.safety_officer }}</p>
                <p class="text-sm text-gray-500">{{ selectedDrill?.jabatan_safety || '-' }}</p>
              </div>
              <div>
                <label class="text-sm font-medium text-gray-600">ERT Leader</label>
                <p class="text-gray-900">{{ selectedDrill?.ert_leader || '-' }}</p>
              </div>
              <div>
                <label class="text-sm font-medium text-gray-600">Jumlah Peserta</label>
                <p class="text-gray-900">{{ selectedDrill?.jumlah_peserta || 0 }} orang</p>
                <p class="text-sm text-gray-500">
                  Karyawan: {{ selectedDrill?.jumlah_karyawan || 0 }}, 
                  Kontraktor: {{ selectedDrill?.jumlah_kontraktor || 0 }}
                </p>
              </div>
            </div>
          </div>

          <!-- Section 4: Pelaksanaan & Response Time -->
          <div class="border-b pb-4" v-if="selectedDrill?.status === 'completed'">
            <h3 class="text-lg font-semibold text-gray-800 mb-3">Pelaksanaan Drill</h3>
            <div class="grid grid-cols-3 gap-4">
              <div>
                <label class="text-sm font-medium text-gray-600">Waktu Deteksi</label>
                <p class="text-gray-900">{{ formatTime(selectedDrill?.waktu_deteksi || '') }}</p>
              </div>
              <div>
                <label class="text-sm font-medium text-gray-600">Waktu Alarm</label>
                <p class="text-gray-900">{{ formatTime(selectedDrill?.waktu_alarm_berbunyi || '') }}</p>
              </div>
              <div>
                <label class="text-sm font-medium text-gray-600">Waktu Evakuasi</label>
                <p class="text-gray-900">{{ formatTime(selectedDrill?.waktu_mulai_evakuasi || '') }}</p>
              </div>
              <div>
                <label class="text-sm font-medium text-gray-600">Selesai Evakuasi</label>
                <p class="text-gray-900">{{ formatTime(selectedDrill?.waktu_selesai_evakuasi || '') }}</p>
              </div>
              <div>
                <label class="text-sm font-medium text-gray-600">Total Waktu</label>
                <p class="text-gray-900 font-semibold">{{ selectedDrill?.total_waktu_evakuasi || 0 }} detik</p>
              </div>
              <div>
                <label class="text-sm font-medium text-gray-600">Target vs Aktual</label>
                <p :class="selectedDrill?.target_tercapai ? 'text-green-600' : 'text-red-600'" class="font-semibold">
                  {{ selectedDrill?.target_tercapai ? '✓ Tercapai' : '✗ Tidak Tercapai' }}
                </p>
              </div>
            </div>
          </div>

          <!-- Section 5: Penilaian & Scoring -->
          <div class="border-b pb-4" v-if="selectedDrill?.status === 'completed' && selectedDrill?.grade">
            <h3 class="text-lg font-semibold text-gray-800 mb-3">Penilaian & Scoring</h3>
            <div class="grid grid-cols-4 gap-4">
              <div class="text-center">
                <label class="text-sm font-medium text-gray-600">Kesiapan</label>
                <p class="text-2xl font-bold text-blue-600">{{ selectedDrill?.penilaian_kesiapan || '-' }}</p>
              </div>
              <div class="text-center">
                <label class="text-sm font-medium text-gray-600">Response</label>
                <p class="text-2xl font-bold text-blue-600">{{ selectedDrill?.penilaian_response || '-' }}</p>
              </div>
              <div class="text-center">
                <label class="text-sm font-medium text-gray-600">Koordinasi</label>
                <p class="text-2xl font-bold text-blue-600">{{ selectedDrill?.penilaian_koordinasi || '-' }}</p>
              </div>
              <div class="text-center">
                <label class="text-sm font-medium text-gray-600">Evakuasi</label>
                <p class="text-2xl font-bold text-blue-600">{{ selectedDrill?.penilaian_evakuasi || '-' }}</p>
              </div>
              <div class="col-span-2 text-center border-t pt-4">
                <label class="text-sm font-medium text-gray-600">Skor Total</label>
                <p class="text-3xl font-bold text-purple-600">{{ selectedDrill?.skor_total || 0 }}/{{ selectedDrill?.skor_maksimal || 100 }}</p>
              </div>
              <div class="col-span-2 text-center border-t pt-4">
                <label class="text-sm font-medium text-gray-600">Grade</label>
                <p class="text-3xl font-bold" :class="`text-${getGradeColor(selectedDrill?.grade || '')}-600`">
                  {{ selectedDrill?.grade }} ({{ selectedDrill?.persentase_keberhasilan?.toFixed(1) }}%)
                </p>
              </div>
            </div>
          </div>

          <!-- Section 6: Temuan -->
          <div class="border-b pb-4" v-if="selectedDrill?.jumlah_temuan && selectedDrill.jumlah_temuan > 0">
            <h3 class="text-lg font-semibold text-gray-800 mb-3">Temuan ({{ selectedDrill?.jumlah_temuan }})</h3>
            <div class="grid grid-cols-3 gap-4 mb-4">
              <div class="bg-red-50 p-3 rounded">
                <p class="text-sm text-gray-600">Kritis</p>
                <p class="text-2xl font-bold text-red-600">{{ selectedDrill?.temuan_kritis || 0 }}</p>
              </div>
              <div class="bg-yellow-50 p-3 rounded">
                <p class="text-sm text-gray-600">Mayor</p>
                <p class="text-2xl font-bold text-yellow-600">{{ selectedDrill?.temuan_mayor || 0 }}</p>
              </div>
              <div class="bg-blue-50 p-3 rounded">
                <p class="text-sm text-gray-600">Minor</p>
                <p class="text-2xl font-bold text-blue-600">{{ selectedDrill?.temuan_minor || 0 }}</p>
              </div>
            </div>
            <div v-if="selectedDrill?.detail_temuan && selectedDrill.detail_temuan.length > 0" class="space-y-2">
              <div v-for="(temuan, idx) in selectedDrill.detail_temuan" :key="idx" class="border-l-4 border-yellow-400 pl-3 py-2 bg-gray-50">
                <p class="font-medium text-gray-900">{{ temuan.deskripsi }}</p>
                <p class="text-sm text-gray-600">Lokasi: {{ temuan.lokasi }} | Severity: {{ temuan.severity }}</p>
              </div>
            </div>
          </div>

          <!-- Section 7: Observasi -->
          <div class="border-b pb-4" v-if="selectedDrill?.status === 'completed'">
            <h3 class="text-lg font-semibold text-gray-800 mb-3">Observasi</h3>
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="text-sm font-medium text-green-600">Observasi Positif</label>
                <ul v-if="selectedDrill?.observasi_positif && selectedDrill.observasi_positif.length > 0" class="list-disc list-inside text-sm text-gray-700 space-y-1">
                  <li v-for="(obs, idx) in selectedDrill.observasi_positif" :key="idx">{{ obs }}</li>
                </ul>
                <p v-else class="text-gray-500">-</p>
              </div>
              <div>
                <label class="text-sm font-medium text-red-600">Observasi Negatif</label>
                <ul v-if="selectedDrill?.observasi_negatif && selectedDrill.observasi_negatif.length > 0" class="list-disc list-inside text-sm text-gray-700 space-y-1">
                  <li v-for="(obs, idx) in selectedDrill.observasi_negatif" :key="idx">{{ obs }}</li>
                </ul>
                <p v-else class="text-gray-500">-</p>
              </div>
            </div>
          </div>

          <!-- Section 8: Rekomendasi & Action Items -->
          <div class="border-b pb-4" v-if="selectedDrill?.rekomendasi || selectedDrill?.action_items">
            <h3 class="text-lg font-semibold text-gray-800 mb-3">Rekomendasi & Action Items</h3>
            <div v-if="selectedDrill?.rekomendasi && selectedDrill.rekomendasi.length > 0" class="mb-4">
              <label class="text-sm font-medium text-gray-600">Rekomendasi</label>
              <ul class="list-disc list-inside text-sm text-gray-700 space-y-1">
                <li v-for="(rek, idx) in selectedDrill.rekomendasi" :key="idx">{{ rek }}</li>
              </ul>
            </div>
            <div v-if="selectedDrill?.action_items && selectedDrill.action_items.length > 0">
              <label class="text-sm font-medium text-gray-600">Action Items</label>
              <div class="space-y-2 mt-2">
                <div v-for="(item, idx) in selectedDrill.action_items" :key="idx" class="border p-3 rounded bg-gray-50">
                  <p class="font-medium text-gray-900">{{ item.item }}</p>
                  <p class="text-sm text-gray-600">PIC: {{ item.pic }} | Target: {{ item.target_date }} | Status: {{ item.status }}</p>
                </div>
              </div>
            </div>
          </div>

          <!-- Section 9: Dokumentasi -->
          <div v-if="selectedDrill?.foto_dokumentasi && selectedDrill.foto_dokumentasi.length > 0">
            <h3 class="text-lg font-semibold text-gray-800 mb-3">Foto Dokumentasi</h3>
            <div class="grid grid-cols-4 gap-3">
              <div v-for="(foto, idx) in selectedDrill.foto_dokumentasi" :key="idx" class="cursor-pointer" @click="viewImage(foto)">
                <img 
                  :src="foto" 
                  alt="Dokumentasi" 
                  loading="lazy"
                  class="w-full h-24 object-cover rounded-lg border border-gray-200 hover:border-blue-500 transition-colors" 
                />
              </div>
            </div>
          </div>
        </div>

        <div class="border-t px-6 py-4 flex justify-end">
          <button @click="showDetailModal = false" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300">
            Tutup
          </button>
        </div>
      </div>
    </div>

    <!-- Image Preview Modal -->
    <div v-if="showImagePreview" class="fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-50 p-4" @click="showImagePreview = false">
      <div class="relative max-w-4xl max-h-[90vh]">
        <button @click="showImagePreview = false" class="absolute -top-10 right-0 text-white text-2xl hover:text-gray-300">&times;</button>
        <img :src="previewImageUrl" alt="Preview" class="max-w-full max-h-[90vh] rounded-lg" @click.stop />
      </div>
    </div>

    <!-- Form Modal -->
    <div v-if="showFormModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div class="bg-white rounded-lg shadow-xl max-w-6xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b px-6 py-4 flex justify-between items-center">
          <h2 class="text-xl font-bold text-gray-800">{{ isEditing ? 'Edit' : 'Tambah' }} Safety Drill</h2>
          <button @click="closeFormModal" class="text-gray-500 hover:text-gray-700 text-2xl">&times;</button>
        </div>

        <!-- Tabs -->
        <div class="border-b">
          <nav class="flex space-x-4 px-6">
            <button
              v-for="(tab, index) in formTabs"
              :key="index"
              @click="activeTab = index"
              :class="[
                'py-4 px-1 border-b-2 font-medium text-sm transition-colors',
                activeTab === index
                  ? 'border-blue-500 text-blue-600'
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
              ]"
            >
              {{ tab }}
            </button>
          </nav>
        </div>

        <form @submit.prevent="handleSubmit" class="p-6">
          <!-- Tab 1: Data Dasar -->
          <div v-show="activeTab === 0" class="space-y-4">
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Jenis Drill *</label>
                <select v-model="formData.jenis_drill" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500">
                  <option v-for="option in jenisOptions" :key="option.value" :value="option.value">{{ option.label }}</option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Kategori Drill *</label>
                <select v-model="formData.kategori_drill" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500">
                  <option v-for="option in kategoriOptions" :key="option.value" :value="option.value">{{ option.label }}</option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Tingkat Drill *</label>
                <select v-model="formData.tingkat_drill" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500">
                  <option v-for="option in tingkatOptions" :key="option.value" :value="option.value">{{ option.label }}</option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Status *</label>
                <select v-model="formData.status" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500">
                  <option v-for="option in statusOptions" :key="option.value" :value="option.value">{{ option.label }}</option>
                </select>
              </div>
              <div class="col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-1">Judul Drill *</label>
                <input v-model="formData.judul_drill" type="text" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div class="col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-1">Deskripsi</label>
                <textarea v-model="formData.deskripsi" rows="3" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"></textarea>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Unit Kerja *</label>
                <input v-model="formData.unit_kerja" type="text" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Area Lokasi *</label>
                <input v-model="formData.area_lokasi" type="text" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Titik Kumpul *</label>
                <input v-model="formData.titik_kumpul" type="text" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Drill *</label>
                <input v-model="formData.tanggal_drill" type="date" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Waktu Mulai *</label>
                <input v-model="formData.waktu_mulai" type="time" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Shift</label>
                <input v-model="formData.shift" type="text" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div class="col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-1">Area Terdampak</label>
                <div class="flex gap-2 mb-2">
                  <input v-model="newAreaTerdampak" type="text" @keyup.enter="addAreaTerdampak" placeholder="Tambah area..." class="flex-1 px-3 py-2 border border-gray-300 rounded-lg" />
                  <button type="button" @click="addAreaTerdampak" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">Tambah</button>
                </div>
                <div class="flex flex-wrap gap-2">
                  <span v-for="(area, idx) in formData.area_terdampak" :key="idx" class="inline-flex items-center gap-1 px-3 py-1 bg-gray-100 rounded-full">
                    {{ area }}
                    <button type="button" @click="removeAreaTerdampak(idx)" class="text-red-600 hover:text-red-800">&times;</button>
                  </span>
                </div>
              </div>
              <div class="col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-1">Tujuan Drill *</label>
                <textarea v-model="formData.tujuan_drill" rows="2" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"></textarea>
              </div>
              <div class="col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-1">Skenario *</label>
                <textarea v-model="formData.skenario" rows="3" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"></textarea>
              </div>
              <div class="col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-1">Sasaran Drill</label>
                <div class="flex gap-2 mb-2">
                  <input v-model="newSasaran" type="text" @keyup.enter="addSasaran" placeholder="Tambah sasaran..." class="flex-1 px-3 py-2 border border-gray-300 rounded-lg" />
                  <button type="button" @click="addSasaran" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">Tambah</button>
                </div>
                <div class="space-y-1">
                  <div v-for="(sasaran, idx) in formData.sasaran_drill" :key="idx" class="flex items-center gap-2">
                    <span class="flex-1 text-sm">{{ idx + 1 }}. {{ sasaran }}</span>
                    <button type="button" @click="removeSasaran(idx)" class="text-red-600 hover:text-red-800">🗑️</button>
                  </div>
                </div>
              </div>
              <div class="col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-1">Kriteria Keberhasilan</label>
                <div class="flex gap-2 mb-2">
                  <input v-model="newKriteria" type="text" @keyup.enter="addKriteria" placeholder="Tambah kriteria..." class="flex-1 px-3 py-2 border border-gray-300 rounded-lg" />
                  <button type="button" @click="addKriteria" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">Tambah</button>
                </div>
                <div class="space-y-1">
                  <div v-for="(kriteria, idx) in formData.kriteria_keberhasilan" :key="idx" class="flex items-center gap-2">
                    <span class="flex-1 text-sm">{{ idx + 1 }}. {{ kriteria }}</span>
                    <button type="button" @click="removeKriteria(idx)" class="text-red-600 hover:text-red-800">🗑️</button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Tab 2: Tim & Peserta -->
          <div v-show="activeTab === 1" class="space-y-4">
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Drill Commander *</label>
                <input v-model="formData.drill_commander" type="text" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Jabatan Commander</label>
                <input v-model="formData.jabatan_commander" type="text" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Safety Officer *</label>
                <input v-model="formData.safety_officer" type="text" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Jabatan Safety</label>
                <input v-model="formData.jabatan_safety" type="text" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">ERT Leader</label>
                <input v-model="formData.ert_leader" type="text" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Jumlah Peserta *</label>
                <input v-model.number="formData.jumlah_peserta" type="number" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Jumlah Karyawan</label>
                <input v-model.number="formData.jumlah_karyawan" type="number" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Jumlah Kontraktor</label>
                <input v-model.number="formData.jumlah_kontraktor" type="number" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div class="col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-1">Observer</label>
                <div class="flex gap-2 mb-2">
                  <input v-model="newObserver" type="text" @keyup.enter="addObserver" placeholder="Nama - Jabatan" class="flex-1 px-3 py-2 border border-gray-300 rounded-lg" />
                  <button type="button" @click="addObserver" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">Tambah</button>
                </div>
                <div class="flex flex-wrap gap-2">
                  <span v-for="(observer, idx) in formData.observer" :key="idx" class="inline-flex items-center gap-1 px-3 py-1 bg-blue-100 rounded-full">
                    {{ observer }}
                    <button type="button" @click="removeObserver(idx)" class="text-red-600 hover:text-red-800">&times;</button>
                  </span>
                </div>
              </div>
              <div class="col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-1">Anggota ERT</label>
                <div class="flex gap-2 mb-2">
                  <input v-model="newERTMember" type="text" @keyup.enter="addERTMember" placeholder="Nama anggota ERT" class="flex-1 px-3 py-2 border border-gray-300 rounded-lg" />
                  <button type="button" @click="addERTMember" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">Tambah</button>
                </div>
                <div class="flex flex-wrap gap-2">
                  <span v-for="(member, idx) in formData.ert_members" :key="idx" class="inline-flex items-center gap-1 px-3 py-1 bg-green-100 rounded-full">
                    {{ member }}
                    <button type="button" @click="removeERTMember(idx)" class="text-red-600 hover:text-red-800">&times;</button>
                  </span>
                </div>
              </div>
            </div>
          </div>

          <!-- Tab 3: Pelaksanaan -->
          <div v-show="activeTab === 2" class="space-y-4">
            <div class="grid grid-cols-3 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Waktu Deteksi</label>
                <input v-model="formData.waktu_deteksi" type="time" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Waktu Alarm</label>
                <input v-model="formData.waktu_alarm_berbunyi" type="time" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Jenis Alarm</label>
                <input v-model="formData.jenis_alarm" type="text" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Waktu Mulai Evakuasi</label>
                <input v-model="formData.waktu_mulai_evakuasi" type="time" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Waktu Selesai Evakuasi</label>
                <input v-model="formData.waktu_selesai_evakuasi" type="time" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Total Waktu (detik)</label>
                <input v-model.number="formData.total_waktu_evakuasi" type="number" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Target Waktu (detik)</label>
                <input v-model.number="formData.target_waktu_evakuasi" type="number" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div class="flex items-center">
                <label class="flex items-center gap-2">
                  <input v-model="formData.alarm_activated" type="checkbox" class="w-4 h-4" />
                  <span class="text-sm font-medium text-gray-700">Alarm Activated</span>
                </label>
              </div>
              <div class="flex items-center">
                <label class="flex items-center gap-2">
                  <input v-model="formData.target_tercapai" type="checkbox" class="w-4 h-4" />
                  <span class="text-sm font-medium text-gray-700">Target Tercapai</span>
                </label>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">APAR Digunakan</label>
                <input v-model.number="formData.apar_digunakan" type="number" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Hydrant Digunakan</label>
                <input v-model.number="formData.hydrant_digunakan" type="number" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Kondisi Cuaca</label>
                <input v-model="formData.kondisi_cuaca" type="text" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500" />
              </div>
              <div class="col-span-3">
                <label class="block text-sm font-medium text-gray-700 mb-1">Perilaku Peserta</label>
                <textarea v-model="formData.perilaku_peserta" rows="2" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"></textarea>
              </div>
            </div>

            <!-- Korban Simulasi -->
            <div class="border-t pt-4">
              <div class="flex items-center gap-2 mb-3">
                <input v-model="formData.ada_korban_simulasi" type="checkbox" class="w-4 h-4" />
                <label class="text-sm font-medium text-gray-700">Ada Korban Simulasi</label>
              </div>
              <div v-if="formData.ada_korban_simulasi">
                <div class="grid grid-cols-4 gap-2 mb-2">
                  <input v-model="newKorban.nama" type="text" placeholder="Nama" class="px-3 py-2 border rounded-lg" />
                  <input v-model="newKorban.kondisi" type="text" placeholder="Kondisi" class="px-3 py-2 border rounded-lg" />
                  <input v-model="newKorban.tindakan" type="text" placeholder="Tindakan" class="px-3 py-2 border rounded-lg" />
                  <button type="button" @click="addKorban" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">Tambah</button>
                </div>
                <div v-if="formData.detail_korban && formData.detail_korban.length > 0" class="space-y-2">
                  <div v-for="(korban, idx) in formData.detail_korban" :key="idx" class="border p-2 rounded bg-gray-50 flex justify-between items-center">
                    <div>
                      <p class="font-medium">{{ korban.nama }}</p>
                      <p class="text-sm text-gray-600">{{ korban.kondisi }} - {{ korban.tindakan }}</p>
                    </div>
                    <button type="button" @click="removeKorban(idx)" class="text-red-600 hover:text-red-800">🗑️</button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Tab 4: Evaluasi -->
          <div v-show="activeTab === 3" class="space-y-4">
            <div class="grid grid-cols-2 gap-4">
              <div class="col-span-2 border-b pb-3">
                <h3 class="font-semibold text-gray-800">Checklist Evaluasi</h3>
              </div>
              <label class="flex items-center gap-2">
                <input v-model="formData.evakuasi_teratur" type="checkbox" class="w-4 h-4" />
                <span class="text-sm">Evakuasi Teratur</span>
              </label>
              <label class="flex items-center gap-2">
                <input v-model="formData.rute_evakuasi_jelas" type="checkbox" class="w-4 h-4" />
                <span class="text-sm">Rute Evakuasi Jelas</span>
              </label>
              <label class="flex items-center gap-2">
                <input v-model="formData.pintu_darurat_berfungsi" type="checkbox" class="w-4 h-4" />
                <span class="text-sm">Pintu Darurat Berfungsi</span>
              </label>
              <label class="flex items-center gap-2">
                <input v-model="formData.lampu_darurat_berfungsi" type="checkbox" class="w-4 h-4" />
                <span class="text-sm">Lampu Darurat Berfungsi</span>
              </label>
              <label class="flex items-center gap-2">
                <input v-model="formData.alat_pemadam_siap" type="checkbox" class="w-4 h-4" />
                <span class="text-sm">Alat Pemadam Siap</span>
              </label>
              <label class="flex items-center gap-2">
                <input v-model="formData.komunikasi_efektif" type="checkbox" class="w-4 h-4" />
                <span class="text-sm">Komunikasi Efektif</span>
              </label>

              <div class="col-span-2 border-t pt-3 mt-3">
                <h3 class="font-semibold text-gray-800 mb-3">Penilaian (1-5)</h3>
                <div class="grid grid-cols-3 gap-4">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Kesiapan</label>
                    <input v-model.number="formData.penilaian_kesiapan" type="number" min="1" max="5" class="w-full px-3 py-2 border rounded-lg" />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Response</label>
                    <input v-model.number="formData.penilaian_response" type="number" min="1" max="5" class="w-full px-3 py-2 border rounded-lg" />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Koordinasi</label>
                    <input v-model.number="formData.penilaian_koordinasi" type="number" min="1" max="5" class="w-full px-3 py-2 border rounded-lg" />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Komunikasi</label>
                    <input v-model.number="formData.penilaian_komunikasi" type="number" min="1" max="5" class="w-full px-3 py-2 border rounded-lg" />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Evakuasi</label>
                    <input v-model.number="formData.penilaian_evakuasi" type="number" min="1" max="5" class="w-full px-3 py-2 border rounded-lg" />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Peralatan</label>
                    <input v-model.number="formData.penilaian_peralatan" type="number" min="1" max="5" class="w-full px-3 py-2 border rounded-lg" />
                  </div>
                </div>
              </div>

              <div class="col-span-2 border-t pt-3 mt-3">
                <h3 class="font-semibold text-gray-800 mb-3">Scoring</h3>
                <div class="grid grid-cols-3 gap-4">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Skor Total</label>
                    <input v-model.number="formData.skor_total" type="number" class="w-full px-3 py-2 border rounded-lg" />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Persentase (%)</label>
                    <input v-model.number="formData.persentase_keberhasilan" type="number" step="0.01" class="w-full px-3 py-2 border rounded-lg" />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Grade</label>
                    <select v-model="formData.grade" class="w-full px-3 py-2 border rounded-lg">
                      <option value="">-</option>
                      <option value="A">A</option>
                      <option value="B">B</option>
                      <option value="C">C</option>
                      <option value="D">D</option>
                      <option value="E">E</option>
                    </select>
                  </div>
                </div>
              </div>

              <div class="col-span-2 border-t pt-3 mt-3">
                <h3 class="font-semibold text-gray-800 mb-3">Temuan</h3>
                <div class="grid grid-cols-5 gap-2 mb-2">
                  <select v-model="newTemuan.kategori" class="px-3 py-2 border rounded-lg">
                    <option value="Kritis">Kritis</option>
                    <option value="Mayor">Mayor</option>
                    <option value="Minor">Minor</option>
                  </select>
                  <input v-model="newTemuan.deskripsi" type="text" placeholder="Deskripsi" class="px-3 py-2 border rounded-lg col-span-2" />
                  <input v-model="newTemuan.lokasi" type="text" placeholder="Lokasi" class="px-3 py-2 border rounded-lg" />
                  <button type="button" @click="addTemuan" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">Tambah</button>
                </div>
                <div v-if="formData.detail_temuan && formData.detail_temuan.length > 0" class="space-y-2">
                  <div v-for="(temuan, idx) in formData.detail_temuan" :key="idx" class="border-l-4 border-yellow-400 pl-3 py-2 bg-gray-50 flex justify-between items-center">
                    <div>
                      <p class="font-medium">{{ temuan.deskripsi }}</p>
                      <p class="text-sm text-gray-600">{{ temuan.kategori }} - {{ temuan.lokasi }}</p>
                    </div>
                    <button type="button" @click="removeTemuan(idx)" class="text-red-600 hover:text-red-800">🗑️</button>
                  </div>
                </div>
              </div>

              <div class="col-span-2 border-t pt-3 mt-3">
                <h3 class="font-semibold text-gray-800 mb-3">Action Items</h3>
                <div class="grid grid-cols-5 gap-2 mb-2">
                  <input v-model="newActionItem.item" type="text" placeholder="Action item" class="px-3 py-2 border rounded-lg col-span-2" />
                  <input v-model="newActionItem.pic" type="text" placeholder="PIC" class="px-3 py-2 border rounded-lg" />
                  <input v-model="newActionItem.target_date" type="date" class="px-3 py-2 border rounded-lg" />
                  <button type="button" @click="addActionItem" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">Tambah</button>
                </div>
                <div v-if="formData.action_items && formData.action_items.length > 0" class="space-y-2">
                  <div v-for="(item, idx) in formData.action_items" :key="idx" class="border p-2 rounded bg-gray-50 flex justify-between items-center">
                    <div>
                      <p class="font-medium">{{ item.item }}</p>
                      <p class="text-sm text-gray-600">PIC: {{ item.pic }} | Target: {{ item.target_date }}</p>
                    </div>
                    <button type="button" @click="removeActionItem(idx)" class="text-red-600 hover:text-red-800">🗑️</button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Tab 5: Dokumentasi -->
          <div v-show="activeTab === 4" class="space-y-4">
            <div class="grid grid-cols-2 gap-4">
              <div class="col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-1">Hasil Debriefing</label>
                <textarea v-model="formData.hasil_debriefing" rows="4" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"></textarea>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Debriefing</label>
                <input v-model="formData.tanggal_debriefing" type="date" class="w-full px-3 py-2 border rounded-lg" />
              </div>
              <div class="flex items-center">
                <label class="flex items-center gap-2">
                  <input v-model="formData.debriefing_dilakukan" type="checkbox" class="w-4 h-4" />
                  <span class="text-sm font-medium text-gray-700">Debriefing Sudah Dilakukan</span>
                </label>
              </div>
              <div class="col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-1">Catatan Next Drill</label>
                <textarea v-model="formData.catatan_next_drill" rows="3" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"></textarea>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Next Drill</label>
                <input v-model="formData.tanggal_next_drill" type="date" class="w-full px-3 py-2 border rounded-lg" />
              </div>
              <div class="flex items-center">
                <label class="flex items-center gap-2">
                  <input v-model="formData.next_drill_scheduled" type="checkbox" class="w-4 h-4" />
                  <span class="text-sm font-medium text-gray-700">Next Drill Sudah Dijadwalkan</span>
                </label>
              </div>
              <div class="flex items-center">
                <label class="flex items-center gap-2">
                  <input v-model="formData.pihak_eksternal_terlibat" type="checkbox" class="w-4 h-4" />
                  <span class="text-sm font-medium text-gray-700">Pihak Eksternal Terlibat</span>
                </label>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Compliance Status</label>
                <select v-model="formData.compliance_status" class="w-full px-3 py-2 border rounded-lg">
                  <option value="compliant">Compliant</option>
                  <option value="partially_compliant">Partially Compliant</option>
                  <option value="non_compliant">Non Compliant</option>
                  <option value="not_applicable">Not Applicable</option>
                </select>
              </div>

              <!-- Foto Dokumentasi -->
              <div class="col-span-2 border-t pt-4 mt-4">
                <h3 class="font-semibold text-gray-800 mb-3">Foto Dokumentasi</h3>
                <div class="mb-3">
                  <label class="flex items-center justify-center w-full px-4 py-3 border-2 border-dashed border-gray-300 rounded-lg cursor-pointer hover:border-blue-500 hover:bg-blue-50 transition-colors">
                    <span class="text-sm text-gray-600">📷 Klik untuk upload foto</span>
                    <input type="file" accept="image/*" @change="handlePhotoUpload" class="hidden" />
                  </label>
                </div>
                <div v-if="formData.foto_dokumentasi && formData.foto_dokumentasi.length > 0" class="grid grid-cols-4 gap-3">
                  <div v-for="(foto, idx) in formData.foto_dokumentasi" :key="idx" class="relative group">
                    <img 
                      :src="foto" 
                      alt="Foto" 
                      loading="lazy"
                      class="w-full h-24 object-cover rounded-lg border border-gray-200" 
                    />
                    <div class="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-50 transition-all rounded-lg flex items-center justify-center gap-2">
                      <button type="button" @click="viewImage(foto)" class="opacity-0 group-hover:opacity-100 text-white bg-blue-600 px-2 py-1 rounded text-xs">
                        👁️ Lihat
                      </button>
                      <button type="button" @click="removePhoto(idx)" class="opacity-0 group-hover:opacity-100 text-white bg-red-600 px-2 py-1 rounded text-xs">
                        🗑️ Hapus
                      </button>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Video Dokumentasi -->
              <div class="col-span-2 border-t pt-4 mt-4">
                <h3 class="font-semibold text-gray-800 mb-3">Video Dokumentasi</h3>
                <div class="mb-3">
                  <label class="flex items-center justify-center w-full px-4 py-3 border-2 border-dashed border-gray-300 rounded-lg cursor-pointer hover:border-blue-500 hover:bg-blue-50 transition-colors">
                    <span class="text-sm text-gray-600">🎥 Klik untuk upload video</span>
                    <input type="file" accept="video/*" @change="handleVideoUpload" class="hidden" />
                  </label>
                </div>
                <div v-if="formData.video_dokumentasi && formData.video_dokumentasi.length > 0" class="space-y-2">
                  <div v-for="(video, idx) in formData.video_dokumentasi" :key="idx" class="flex items-center justify-between border p-3 rounded-lg bg-gray-50">
                    <span class="text-sm text-gray-700">🎥 Video {{ idx + 1 }}</span>
                    <button type="button" @click="removeVideo(idx)" class="text-red-600 hover:text-red-800 text-sm">🗑️ Hapus</button>
                  </div>
                </div>
              </div>

              <!-- Dokumen Pendukung -->
              <div class="col-span-2 border-t pt-4 mt-4">
                <h3 class="font-semibold text-gray-800 mb-3">Dokumen Pendukung</h3>
                <div class="mb-3">
                  <label class="flex items-center justify-center w-full px-4 py-3 border-2 border-dashed border-gray-300 rounded-lg cursor-pointer hover:border-blue-500 hover:bg-blue-50 transition-colors">
                    <span class="text-sm text-gray-600">📄 Klik untuk upload dokumen (PDF, Excel, Word)</span>
                    <input type="file" accept=".pdf,.doc,.docx,.xls,.xlsx" @change="handleDocumentUpload" class="hidden" />
                  </label>
                </div>
                <div v-if="formData.dokumen_pendukung && formData.dokumen_pendukung.length > 0" class="space-y-2">
                  <div v-for="(doc, idx) in formData.dokumen_pendukung" :key="idx" class="flex items-center justify-between border p-3 rounded-lg bg-gray-50">
                    <span class="text-sm text-gray-700">📄 Dokumen {{ idx + 1 }}</span>
                    <button type="button" @click="removeDocument(idx)" class="text-red-600 hover:text-red-800 text-sm">🗑️ Hapus</button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Form Actions -->
          <div class="flex justify-between mt-6 pt-4 border-t">
            <button type="button" @click="closeFormModal" class="px-6 py-2 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300">
              Batal
            </button>
            <div class="flex gap-2">
              <button
                v-if="activeTab > 0"
                type="button"
                @click="activeTab--"
                class="px-6 py-2 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300"
              >
                Previous
              </button>
              <button
                v-if="activeTab < formTabs.length - 1"
                type="button"
                @click="activeTab++"
                class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
              >
                Next
              </button>
              <button
                v-if="activeTab === formTabs.length - 1"
                type="submit"
                :disabled="loading"
                class="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 disabled:bg-gray-400"
              >
                {{ loading ? 'Menyimpan...' : 'Simpan' }}
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>
