<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { safetyInductionService, type SafetyInduction } from '@/services/hsse/safety-induction.service'
import { useUnitsStore } from '@/stores/units'

const unitsStore = useUnitsStore()

// State
const loading = ref(false)
const inductions = ref<SafetyInduction[]>([])
const selectedInduction = ref<SafetyInduction | null>(null)
const showDetailModal = ref(false)
const showFormModal = ref(false)
const formMode = ref<'create' | 'edit'>('create')
const activeTab = ref(1)

// Filters
const filters = ref({
  search: '',
  unit_id: '',
  jenis_peserta: '',
  status: '',
  perusahaan: ''
})

// Stats
const stats = ref({
  total: 0,
  bulan_ini: 0,
  passed: 0,
  failed: 0,
  scheduled: 0,
  expiring_soon: 0,
  avg_skor: 0,
  avg_rating_materi: 0,
  avg_rating_instruktur: 0
})

// Form data
const formData = ref<Partial<SafetyInduction>>({
  nomor_induction: '',
  nama_peserta: '',
  perusahaan: '',
  jenis_peserta: 'karyawan_baru',
  tanggal_induction: new Date().toISOString().split('T')[0],
  waktu_mulai: '',
  lokasi_induction: '',
  instruktur_utama: '',
  instruktur_pendamping: [],
  status: 'scheduled',
  materi_kebijakan_k3: false,
  materi_prosedur_emergency: false,
  materi_apd_wajib: false,
  materi_rambu_k3: false,
  materi_identifikasi_bahaya: false,
  materi_pelaporan_insiden: false,
  materi_permit_to_work: false,
  materi_housekeeping: false,
  materi_chemical_safety: false,
  materi_working_at_height: false,
  materi_confined_space: false,
  materi_loto: false,
  materi_fire_safety: false,
  materi_first_aid: false,
  materi_ergonomi: false,
  materi_tambahan: [],
  apd_diberikan: [],
  site_tour_dilakukan: false,
  area_dikunjungi: [],
  ujian_dilakukan: false,
  passing_grade: 80,
  sertifikat_diterbitkan: false,
  masa_berlaku_bulan: 12,
  akses_area: []
})

// Helper refs
const newInstruktur = ref('')
const newMateri = ref({ judul: '', durasi_menit: 0 })
const newAPD = ref<{ jenis_apd: string; ukuran: string; jumlah: number; nomor_aset: string; tanggal_serah: string }>({
  jenis_apd: '',
  ukuran: '',
  jumlah: 1,
  nomor_aset: '',
  tanggal_serah: new Date().toISOString().split('T')[0]!
})
const newArea = ref('')
const newAksesArea = ref('')// Load data
const loadInductions = async () => {
  try {
    loading.value = true
    const data = await safetyInductionService.getAll(filters.value)
    inductions.value = data
  } catch (error) {
    console.error('Error loading inductions:', error)
    alert('Gagal memuat data induction')
  } finally {
    loading.value = false
  }
}

const loadStats = async () => {
  try {
    const data = await safetyInductionService.getStatistics()
    stats.value = data
  } catch (error) {
    console.error('Error loading stats:', error)
  }
}

// Modal actions
const openDetailModal = (induction: SafetyInduction) => {
  selectedInduction.value = induction
  showDetailModal.value = true
}

const closeDetailModal = () => {
  showDetailModal.value = false
  selectedInduction.value = null
}

const openFormModal = (mode: 'create' | 'edit', induction?: SafetyInduction) => {
  formMode.value = mode
  activeTab.value = 1
  
  if (mode === 'edit' && induction) {
    formData.value = { ...induction }
  } else {
    formData.value = {
      nomor_induction: '',
      nama_peserta: '',
      perusahaan: '',
      jenis_peserta: 'karyawan_baru',
      tanggal_induction: new Date().toISOString().split('T')[0],
      waktu_mulai: '',
      lokasi_induction: '',
      instruktur_utama: '',
      instruktur_pendamping: [],
      status: 'scheduled',
      materi_kebijakan_k3: false,
      materi_prosedur_emergency: false,
      materi_apd_wajib: false,
      materi_rambu_k3: false,
      materi_identifikasi_bahaya: false,
      materi_pelaporan_insiden: false,
      materi_permit_to_work: false,
      materi_housekeeping: false,
      materi_chemical_safety: false,
      materi_working_at_height: false,
      materi_confined_space: false,
      materi_loto: false,
      materi_fire_safety: false,
      materi_first_aid: false,
      materi_ergonomi: false,
      materi_tambahan: [],
      apd_diberikan: [],
      site_tour_dilakukan: false,
      area_dikunjungi: [],
      ujian_dilakukan: false,
      passing_grade: 80,
      sertifikat_diterbitkan: false,
      masa_berlaku_bulan: 12,
      akses_area: []
    }
  }
  
  showFormModal.value = true
}

const closeFormModal = () => {
  showFormModal.value = false
  formMode.value = 'create'
  activeTab.value = 1
}

// CRUD operations
const handleSubmit = async () => {
  try {
    loading.value = true
    
    const dataToSave = { ...formData.value }

    if (formMode.value === 'create') {
      await safetyInductionService.create(dataToSave)
      alert('Induction berhasil dibuat')
    } else {
      if (!formData.value.id) {
        throw new Error('ID induction tidak ditemukan untuk update')
      }
      await safetyInductionService.update(formData.value.id, dataToSave)
      alert('Induction berhasil diupdate')
    }
    
    closeFormModal()
    loadInductions()
    loadStats()
  } catch (error) {
    console.error('Error saving induction:', error)
    alert('Gagal menyimpan induction')
  } finally {
    loading.value = false
  }
}

const deleteInduction = async (id: string) => {
  if (!confirm('Yakin ingin menghapus induction ini?')) return
  
  try {
    loading.value = true
    await safetyInductionService.delete(id)
    alert('Induction berhasil dihapus')
    loadInductions()
    loadStats()
  } catch (error) {
    console.error('Error deleting induction:', error)
    alert('Gagal menghapus induction')
  } finally {
    loading.value = false
  }
}

// Helper functions
const addInstruktur = () => {
  if (newInstruktur.value.trim()) {
    if (!formData.value.instruktur_pendamping) formData.value.instruktur_pendamping = []
    formData.value.instruktur_pendamping.push(newInstruktur.value.trim())
    newInstruktur.value = ''
  }
}

const removeInstruktur = (index: number) => {
  formData.value.instruktur_pendamping?.splice(index, 1)
}

const addMateri = () => {
  if (newMateri.value.judul.trim() && newMateri.value.durasi_menit > 0) {
    if (!formData.value.materi_tambahan) formData.value.materi_tambahan = []
    formData.value.materi_tambahan.push({ ...newMateri.value, disampaikan: false })
    newMateri.value = { judul: '', durasi_menit: 0 }
  }
}

const removeMateri = (index: number) => {
  formData.value.materi_tambahan?.splice(index, 1)
}

const addAPD = () => {
  if (newAPD.value.jenis_apd.trim()) {
    if (!formData.value.apd_diberikan) formData.value.apd_diberikan = []
    formData.value.apd_diberikan.push({
      jenis_apd: newAPD.value.jenis_apd,
      ukuran: newAPD.value.ukuran,
      jumlah: newAPD.value.jumlah,
      nomor_aset: newAPD.value.nomor_aset,
      tanggal_serah: newAPD.value.tanggal_serah
    })
    newAPD.value = { jenis_apd: '', ukuran: '', jumlah: 1, nomor_aset: '', tanggal_serah: new Date().toISOString().split('T')[0]! }
  }
}

const removeAPD = (index: number) => {
  formData.value.apd_diberikan?.splice(index, 1)
}

const addArea = () => {
  if (newArea.value.trim()) {
    if (!formData.value.area_dikunjungi) formData.value.area_dikunjungi = []
    formData.value.area_dikunjungi.push(newArea.value.trim())
    newArea.value = ''
  }
}

const removeArea = (index: number) => {
  formData.value.area_dikunjungi?.splice(index, 1)
}

const addAksesArea = () => {
  if (newAksesArea.value.trim()) {
    if (!formData.value.akses_area) formData.value.akses_area = []
    formData.value.akses_area.push(newAksesArea.value.trim())
    newAksesArea.value = ''
  }
}

const removeAksesArea = (index: number) => {
  formData.value.akses_area?.splice(index, 1)
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
    'scheduled': 'bg-blue-100 text-blue-800',
    'ongoing': 'bg-yellow-100 text-yellow-800',
    'completed': 'bg-green-100 text-green-800',
    'passed': 'bg-green-600 text-white',
    'failed': 'bg-red-600 text-white',
    'no_show': 'bg-gray-100 text-gray-800',
    'cancelled': 'bg-red-100 text-red-800',
    'rescheduled': 'bg-orange-100 text-orange-800'
  }
  return `inline-flex items-center px-2 py-0.5 rounded text-xs font-medium ${classes[status] || 'bg-gray-100 text-gray-800'}`
}

const getJenisBadgeClass = (jenis: string) => {
  const classes: Record<string, string> = {
    'karyawan_baru': 'bg-blue-100 text-blue-800',
    'karyawan_pindah': 'bg-cyan-100 text-cyan-800',
    'kontraktor': 'bg-orange-100 text-orange-800',
    'vendor': 'bg-purple-100 text-purple-800',
    'tamu': 'bg-gray-100 text-gray-800',
    'mahasiswa_pkl': 'bg-green-100 text-green-800',
    'tamu_vip': 'bg-yellow-100 text-yellow-800'
  }
  return `inline-flex items-center px-2 py-0.5 rounded text-xs font-medium ${classes[jenis] || 'bg-gray-100 text-gray-800'}`
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

const countMateriDisampaikan = () => {
  let count = 0
  if (formData.value.materi_kebijakan_k3) count++
  if (formData.value.materi_prosedur_emergency) count++
  if (formData.value.materi_apd_wajib) count++
  if (formData.value.materi_rambu_k3) count++
  if (formData.value.materi_identifikasi_bahaya) count++
  if (formData.value.materi_pelaporan_insiden) count++
  if (formData.value.materi_permit_to_work) count++
  if (formData.value.materi_housekeeping) count++
  if (formData.value.materi_chemical_safety) count++
  if (formData.value.materi_working_at_height) count++
  if (formData.value.materi_confined_space) count++
  if (formData.value.materi_loto) count++
  if (formData.value.materi_fire_safety) count++
  if (formData.value.materi_first_aid) count++
  if (formData.value.materi_ergonomi) count++
  const tambahan = formData.value.materi_tambahan?.filter(m => m.disampaikan).length || 0
  return count + tambahan
}

onMounted(() => {
  loadInductions()
  loadStats()
  unitsStore.fetchUnits()
})
</script>

<template>
  <div class="p-6">
    <!-- Header -->
    <div class="mb-6">
      <h1 class="text-2xl font-bold text-gray-900">Safety Induction</h1>
      <p class="text-gray-600">Kelola program orientasi keselamatan karyawan baru dan tamu</p>
    </div>

    <!-- Statistics Cards -->
    <div class="grid grid-cols-1 md:grid-cols-5 gap-4 mb-6">
      <div class="bg-white rounded-lg shadow p-4">
        <div class="text-sm text-gray-600">Total Induction</div>
        <div class="text-2xl font-bold text-gray-900">{{ stats.total }}</div>
      </div>
      <div class="bg-blue-50 rounded-lg shadow p-4">
        <div class="text-sm text-blue-600">Bulan Ini</div>
        <div class="text-2xl font-bold text-blue-900">{{ stats.bulan_ini }}</div>
      </div>
      <div class="bg-green-50 rounded-lg shadow p-4">
        <div class="text-sm text-green-600">Lulus</div>
        <div class="text-2xl font-bold text-green-900">{{ stats.passed }}</div>
      </div>
      <div class="bg-yellow-50 rounded-lg shadow p-4">
        <div class="text-sm text-yellow-600">Scheduled</div>
        <div class="text-2xl font-bold text-yellow-900">{{ stats.scheduled }}</div>
      </div>
      <div class="bg-red-50 rounded-lg shadow p-4">
        <div class="text-sm text-red-600">Expiring Soon</div>
        <div class="text-2xl font-bold text-red-900">{{ stats.expiring_soon }}</div>
      </div>
    </div>

    <!-- Filters & Actions -->
    <div class="bg-white rounded-lg shadow mb-6 p-4">
      <div class="grid grid-cols-1 md:grid-cols-6 gap-4">
        <div class="md:col-span-2">
          <input v-model="filters.search" type="text" placeholder="Cari nama, nomor, NIK..."
            @input="loadInductions"
            class="w-full px-4 py-2 border rounded-lg text-sm" />
        </div>
        <div>
          <select v-model="filters.unit_id" @change="loadInductions"
            class="w-full px-4 py-2 border rounded-lg text-sm">
            <option value="">Semua Unit</option>
            <option v-for="unit in unitsStore.units" :key="unit.id" :value="unit.id">
              {{ unit.nama }}
            </option>
          </select>
        </div>
        <div>
          <select v-model="filters.jenis_peserta" @change="loadInductions"
            class="w-full px-4 py-2 border rounded-lg text-sm">
            <option value="">Semua Jenis</option>
            <option value="karyawan_baru">Karyawan Baru</option>
            <option value="karyawan_pindah">Karyawan Pindah</option>
            <option value="kontraktor">Kontraktor</option>
            <option value="vendor">Vendor</option>
            <option value="tamu">Tamu</option>
            <option value="mahasiswa_pkl">Mahasiswa PKL</option>
            <option value="tamu_vip">Tamu VIP</option>
          </select>
        </div>
        <div>
          <select v-model="filters.status" @change="loadInductions"
            class="w-full px-4 py-2 border rounded-lg text-sm">
            <option value="">Semua Status</option>
            <option value="scheduled">Scheduled</option>
            <option value="ongoing">Ongoing</option>
            <option value="completed">Completed</option>
            <option value="passed">Passed</option>
            <option value="failed">Failed</option>
            <option value="no_show">No Show</option>
            <option value="cancelled">Cancelled</option>
          </select>
        </div>
        <div>
          <button @click="openFormModal('create')"
            class="w-full px-4 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700">
            + Induction Baru
          </button>
        </div>
      </div>
    </div>

    <!-- Table -->
    <div class="bg-white rounded-lg shadow overflow-hidden">
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Nomor</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tanggal</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Nama Peserta</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Perusahaan</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Jenis</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Instruktur</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Skor</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Aksi</th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-if="loading">
              <td colspan="9" class="px-6 py-4 text-center text-gray-500">Memuat data...</td>
            </tr>
            <tr v-else-if="inductions.length === 0">
              <td colspan="9" class="px-6 py-4 text-center text-gray-500">Tidak ada data</td>
            </tr>
            <tr v-else v-for="induction in inductions" :key="induction.id" class="hover:bg-gray-50">
              <td class="px-6 py-4 text-sm text-gray-900">{{ induction.nomor_induction }}</td>
              <td class="px-6 py-4 text-sm text-gray-600">{{ formatDate(induction.tanggal_induction) }}</td>
              <td class="px-6 py-4">
                <div class="text-sm font-medium text-gray-900">{{ induction.nama_peserta }}</div>
                <div class="text-xs text-gray-500">{{ induction.nik || '-' }}</div>
              </td>
              <td class="px-6 py-4 text-sm text-gray-600">{{ induction.perusahaan }}</td>
              <td class="px-6 py-4">
                <span :class="getJenisBadgeClass(induction.jenis_peserta)">
                  {{ induction.jenis_peserta.replace('_', ' ') }}
                </span>
              </td>
              <td class="px-6 py-4 text-sm text-gray-600">{{ induction.instruktur_utama }}</td>
              <td class="px-6 py-4 text-sm">
                <span v-if="induction.skor_ujian" class="font-medium"
                  :class="(induction.skor_ujian || 0) >= (induction.passing_grade || 80) ? 'text-green-600' : 'text-red-600'">
                  {{ induction.skor_ujian }}
                </span>
                <span v-else class="text-gray-400">-</span>
              </td>
              <td class="px-6 py-4">
                <span :class="getStatusBadgeClass(induction.status)">
                  {{ induction.status }}
                </span>
              </td>
              <td class="px-6 py-4 text-sm">
                <div class="flex gap-2">
                  <button @click="openDetailModal(induction)" 
                    class="text-blue-600 hover:text-blue-900" title="Detail">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                    </svg>
                  </button>
                  <button @click="openFormModal('edit', induction)"
                    class="text-yellow-600 hover:text-yellow-900" title="Edit">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                    </svg>
                  </button>
                  <button @click="deleteInduction(induction.id!)"
                    class="text-red-600 hover:text-red-900" title="Hapus">
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
    </div>

    <!-- Detail Modal -->
    <div v-if="showDetailModal" class="fixed inset-0 z-50 overflow-y-auto">
      <div class="flex items-center justify-center min-h-screen p-4">
        <div class="fixed inset-0 bg-black bg-opacity-50 transition-opacity" @click="closeDetailModal"></div>
        
        <div class="relative bg-white rounded-lg max-w-4xl w-full shadow-2xl">
          <!-- Modal header -->
          <div class="flex items-center justify-between p-6 border-b">
            <h2 class="text-xl font-bold text-gray-900">Detail Safety Induction</h2>
            <button @click="closeDetailModal" class="text-gray-400 hover:text-gray-600">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          
          <div class="p-6 overflow-y-auto max-h-[calc(90vh-120px)]">
            <div v-if="selectedInduction" class="space-y-6">
              <!-- 1. Data Peserta -->
              <div class="bg-gray-50 rounded-lg p-4">
                <h3 class="font-semibold text-lg mb-3 text-primary-600">Data Peserta</h3>
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <label class="text-sm text-gray-600">Nomor Induction</label>
                    <div class="font-medium">{{ selectedInduction.nomor_induction }}</div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">Status</label>
                    <div><span :class="getStatusBadgeClass(selectedInduction.status)">{{ selectedInduction.status }}</span></div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">Nama Peserta</label>
                    <div class="font-medium">{{ selectedInduction.nama_peserta }}</div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">NIK / No. Identitas</label>
                    <div class="font-medium">{{ selectedInduction.nik || selectedInduction.no_identitas || '-' }}</div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">Perusahaan</label>
                    <div class="font-medium">{{ selectedInduction.perusahaan }}</div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">Jabatan / Departemen</label>
                    <div class="font-medium">{{ selectedInduction.jabatan || '-' }} / {{ selectedInduction.departemen || '-' }}</div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">Jenis Peserta</label>
                    <div><span :class="getJenisBadgeClass(selectedInduction.jenis_peserta)">{{ selectedInduction.jenis_peserta }}</span></div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">Kategori Pekerjaan</label>
                    <div class="font-medium capitalize">{{ selectedInduction.kategori_pekerjaan || '-' }}</div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">No. Telepon</label>
                    <div class="font-medium">{{ selectedInduction.no_telepon || '-' }}</div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">Email</label>
                    <div class="font-medium">{{ selectedInduction.email || '-' }}</div>
                  </div>
                </div>
              </div>

              <!-- 2. Waktu & Lokasi -->
              <div class="bg-gray-50 rounded-lg p-4">
                <h3 class="font-semibold text-lg mb-3 text-primary-600">Waktu & Lokasi</h3>
                <div class="grid grid-cols-3 gap-4">
                  <div>
                    <label class="text-sm text-gray-600">Tanggal</label>
                    <div class="font-medium">{{ formatDate(selectedInduction.tanggal_induction) }}</div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">Waktu</label>
                    <div class="font-medium">{{ formatTime(selectedInduction.waktu_mulai) }} - {{ formatTime(selectedInduction.waktu_selesai) }}</div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">Durasi</label>
                    <div class="font-medium">{{ selectedInduction.durasi_menit || '-' }} menit</div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">Unit</label>
                    <div class="font-medium">{{ selectedInduction.unit?.nama || '-' }}</div>
                  </div>
                  <div class="col-span-2">
                    <label class="text-sm text-gray-600">Lokasi</label>
                    <div class="font-medium">{{ selectedInduction.lokasi_induction }} {{ selectedInduction.ruangan ? `- ${selectedInduction.ruangan}` : '' }}</div>
                  </div>
                </div>
              </div>

              <!-- 3. Instruktur -->
              <div class="bg-gray-50 rounded-lg p-4">
                <h3 class="font-semibold text-lg mb-3 text-primary-600">Instruktur & Penyelenggara</h3>
                <div class="space-y-2">
                  <div>
                    <label class="text-sm text-gray-600">Instruktur Utama</label>
                    <div class="font-medium">{{ selectedInduction.instruktur_utama }}</div>
                  </div>
                  <div v-if="parseJSON(selectedInduction.instruktur_pendamping).length > 0">
                    <label class="text-sm text-gray-600">Instruktur Pendamping</label>
                    <div class="flex flex-wrap gap-2 mt-1">
                      <span v-for="(instruktur, idx) in parseJSON(selectedInduction.instruktur_pendamping)" :key="idx"
                        class="px-2 py-1 bg-blue-100 text-blue-800 rounded text-sm">
                        {{ instruktur }}
                      </span>
                    </div>
                  </div>
                </div>
              </div>

              <!-- 4. Materi yang Disampaikan -->
              <div class="bg-blue-50 rounded-lg p-4">
                <h3 class="font-semibold text-lg mb-3 text-blue-700">Materi yang Disampaikan</h3>
                <div class="grid grid-cols-3 gap-2">
                  <div v-if="selectedInduction.materi_kebijakan_k3" class="flex items-center gap-2">
                    <span class="text-green-600">✓</span>
                    <span class="text-sm">Kebijakan K3</span>
                  </div>
                  <div v-if="selectedInduction.materi_prosedur_emergency" class="flex items-center gap-2">
                    <span class="text-green-600">✓</span>
                    <span class="text-sm">Prosedur Emergency</span>
                  </div>
                  <div v-if="selectedInduction.materi_apd_wajib" class="flex items-center gap-2">
                    <span class="text-green-600">✓</span>
                    <span class="text-sm">APD Wajib</span>
                  </div>
                  <div v-if="selectedInduction.materi_rambu_k3" class="flex items-center gap-2">
                    <span class="text-green-600">✓</span>
                    <span class="text-sm">Rambu K3</span>
                  </div>
                  <div v-if="selectedInduction.materi_identifikasi_bahaya" class="flex items-center gap-2">
                    <span class="text-green-600">✓</span>
                    <span class="text-sm">Identifikasi Bahaya</span>
                  </div>
                  <div v-if="selectedInduction.materi_pelaporan_insiden" class="flex items-center gap-2">
                    <span class="text-green-600">✓</span>
                    <span class="text-sm">Pelaporan Insiden</span>
                  </div>
                  <div v-if="selectedInduction.materi_permit_to_work" class="flex items-center gap-2">
                    <span class="text-green-600">✓</span>
                    <span class="text-sm">Permit to Work</span>
                  </div>
                  <div v-if="selectedInduction.materi_housekeeping" class="flex items-center gap-2">
                    <span class="text-green-600">✓</span>
                    <span class="text-sm">Housekeeping</span>
                  </div>
                  <div v-if="selectedInduction.materi_chemical_safety" class="flex items-center gap-2">
                    <span class="text-green-600">✓</span>
                    <span class="text-sm">Chemical Safety</span>
                  </div>
                  <div v-if="selectedInduction.materi_working_at_height" class="flex items-center gap-2">
                    <span class="text-green-600">✓</span>
                    <span class="text-sm">Working at Height</span>
                  </div>
                  <div v-if="selectedInduction.materi_confined_space" class="flex items-center gap-2">
                    <span class="text-green-600">✓</span>
                    <span class="text-sm">Confined Space</span>
                  </div>
                  <div v-if="selectedInduction.materi_loto" class="flex items-center gap-2">
                    <span class="text-green-600">✓</span>
                    <span class="text-sm">LOTO</span>
                  </div>
                  <div v-if="selectedInduction.materi_fire_safety" class="flex items-center gap-2">
                    <span class="text-green-600">✓</span>
                    <span class="text-sm">Fire Safety</span>
                  </div>
                  <div v-if="selectedInduction.materi_first_aid" class="flex items-center gap-2">
                    <span class="text-green-600">✓</span>
                    <span class="text-sm">First Aid</span>
                  </div>
                  <div v-if="selectedInduction.materi_ergonomi" class="flex items-center gap-2">
                    <span class="text-green-600">✓</span>
                    <span class="text-sm">Ergonomi</span>
                  </div>
                </div>
                <div v-if="parseJSON(selectedInduction.materi_tambahan).length > 0" class="mt-4">
                  <label class="text-sm font-medium text-gray-700">Materi Tambahan:</label>
                  <div class="mt-2 space-y-2">
                    <div v-for="(materi, idx) in parseJSON(selectedInduction.materi_tambahan)" :key="idx"
                      class="flex items-center justify-between p-2 bg-white rounded border">
                      <span class="text-sm">{{ materi.judul }}</span>
                      <div class="flex items-center gap-2">
                        <span class="text-xs text-gray-500">{{ materi.durasi_menit }} menit</span>
                        <span v-if="materi.disampaikan" class="text-green-600 text-xs">✓ Disampaikan</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- 5. Site Tour -->
              <div v-if="selectedInduction.site_tour_dilakukan" class="bg-gray-50 rounded-lg p-4">
                <h3 class="font-semibold text-lg mb-3 text-primary-600">Site Tour</h3>
                <div class="grid grid-cols-2 gap-4 mb-3">
                  <div>
                    <label class="text-sm text-gray-600">Durasi Tour</label>
                    <div class="font-medium">{{ selectedInduction.durasi_tour_menit || '-' }} menit</div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">Pemandu</label>
                    <div class="font-medium">{{ selectedInduction.pemandu_tour || '-' }}</div>
                  </div>
                </div>
                <div v-if="parseJSON(selectedInduction.area_dikunjungi).length > 0">
                  <label class="text-sm text-gray-600">Area yang Dikunjungi:</label>
                  <div class="flex flex-wrap gap-2 mt-2">
                    <span v-for="(area, idx) in parseJSON(selectedInduction.area_dikunjungi)" :key="idx"
                      class="px-2 py-1 bg-blue-100 text-blue-800 rounded text-sm">
                      {{ area }}
                    </span>
                  </div>
                </div>
              </div>

              <!-- 6. APD yang Diberikan -->
              <div v-if="parseJSON(selectedInduction.apd_diberikan).length > 0" class="bg-gray-50 rounded-lg p-4">
                <h3 class="font-semibold text-lg mb-3 text-primary-600">APD yang Diberikan</h3>
                <div class="overflow-x-auto">
                  <table class="min-w-full divide-y divide-gray-200">
                    <thead>
                      <tr class="bg-gray-100">
                        <th class="px-3 py-2 text-left text-xs font-medium text-gray-600">Jenis APD</th>
                        <th class="px-3 py-2 text-left text-xs font-medium text-gray-600">Ukuran</th>
                        <th class="px-3 py-2 text-left text-xs font-medium text-gray-600">Jumlah</th>
                        <th class="px-3 py-2 text-left text-xs font-medium text-gray-600">Nomor Aset</th>
                        <th class="px-3 py-2 text-left text-xs font-medium text-gray-600">Tanggal Serah</th>
                      </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                      <tr v-for="(apd, idx) in parseJSON(selectedInduction.apd_diberikan)" :key="idx">
                        <td class="px-3 py-2 text-sm">{{ apd.jenis_apd }}</td>
                        <td class="px-3 py-2 text-sm">{{ apd.ukuran }}</td>
                        <td class="px-3 py-2 text-sm">{{ apd.jumlah }}</td>
                        <td class="px-3 py-2 text-sm">{{ apd.nomor_aset }}</td>
                        <td class="px-3 py-2 text-sm">{{ formatDate(apd.tanggal_serah) }}</td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>

              <!-- 7. Kartu ID & Akses -->
              <div v-if="selectedInduction.kartu_id_diberikan" class="bg-gray-50 rounded-lg p-4">
                <h3 class="font-semibold text-lg mb-3 text-primary-600">Kartu ID & Hak Akses</h3>
                <div class="mb-3">
                  <label class="text-sm text-gray-600">Nomor Kartu ID</label>
                  <div class="font-medium">{{ selectedInduction.nomor_kartu_id || '-' }}</div>
                </div>
                <div v-if="parseJSON(selectedInduction.akses_area).length > 0">
                  <label class="text-sm text-gray-600">Hak Akses Area:</label>
                  <div class="flex flex-wrap gap-2 mt-2">
                    <span v-for="(area, idx) in parseJSON(selectedInduction.akses_area)" :key="idx"
                      class="px-2 py-1 bg-green-100 text-green-800 rounded text-sm">
                      {{ area }}
                    </span>
                  </div>
                </div>
              </div>

              <!-- 8. Assessment/Ujian -->
              <div v-if="selectedInduction.ujian_dilakukan" class="bg-yellow-50 rounded-lg p-4">
                <h3 class="font-semibold text-lg mb-3 text-yellow-700">Assessment / Ujian</h3>
                <div class="grid grid-cols-4 gap-4">
                  <div>
                    <label class="text-sm text-gray-600">Jenis Ujian</label>
                    <div class="font-medium capitalize">{{ selectedInduction.jenis_ujian || '-' }}</div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">Jumlah Soal</label>
                    <div class="font-medium">{{ selectedInduction.jumlah_soal || '-' }}</div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">Skor</label>
                    <div class="font-medium text-lg"
                      :class="(selectedInduction.skor_ujian || 0) >= (selectedInduction.passing_grade || 80) ? 'text-green-600' : 'text-red-600'">
                      {{ selectedInduction.skor_ujian || 0 }} / {{ selectedInduction.passing_grade || 80 }}
                    </div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">Status</label>
                    <div>
                      <span class="px-2 py-1 rounded text-xs font-medium"
                        :class="selectedInduction.status_ujian === 'lulus' ? 'bg-green-600 text-white' : 'bg-red-600 text-white'">
                        {{ selectedInduction.status_ujian }}
                      </span>
                    </div>
                  </div>
                </div>
              </div>

              <!-- 9. Sertifikat -->
              <div v-if="selectedInduction.sertifikat_diterbitkan" class="bg-green-50 rounded-lg p-4">
                <h3 class="font-semibold text-lg mb-3 text-green-700">Sertifikat</h3>
                <div class="grid grid-cols-3 gap-4">
                  <div>
                    <label class="text-sm text-gray-600">Nomor Sertifikat</label>
                    <div class="font-medium">{{ selectedInduction.nomor_sertifikat || '-' }}</div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">Tanggal Terbit</label>
                    <div class="font-medium">{{ formatDate(selectedInduction.tanggal_terbit_sertifikat || '') }}</div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">Tanggal Expired</label>
                    <div class="font-medium text-red-600">{{ formatDate(selectedInduction.tanggal_expired || '') }}</div>
                  </div>
                </div>
              </div>

              <!-- 10. Evaluasi -->
              <div class="bg-gray-50 rounded-lg p-4">
                <h3 class="font-semibold text-lg mb-3 text-primary-600">Evaluasi</h3>
                <div class="grid grid-cols-2 gap-4 mb-3">
                  <div>
                    <label class="text-sm text-gray-600">Pemahaman Peserta</label>
                    <div class="font-medium capitalize">{{ selectedInduction.evaluasi_pemahaman || '-' }}</div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">Keaktifan Peserta</label>
                    <div class="font-medium capitalize">{{ selectedInduction.evaluasi_keaktifan || '-' }}</div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">Rating Materi</label>
                    <div class="font-medium">{{ selectedInduction.rating_materi || '-' }} / 5 ⭐</div>
                  </div>
                  <div>
                    <label class="text-sm text-gray-600">Rating Instruktur</label>
                    <div class="font-medium">{{ selectedInduction.rating_instruktur || '-' }} / 5 ⭐</div>
                  </div>
                </div>
                <div v-if="selectedInduction.catatan_instruktur">
                  <label class="text-sm text-gray-600">Catatan Instruktur:</label>
                  <div class="text-sm text-gray-700 mt-1 p-3 bg-white rounded border">
                    {{ selectedInduction.catatan_instruktur }}
                  </div>
                </div>
                <div v-if="selectedInduction.feedback_peserta" class="mt-3">
                  <label class="text-sm text-gray-600">Feedback Peserta:</label>
                  <div class="text-sm text-gray-700 mt-1 p-3 bg-white rounded border">
                    {{ selectedInduction.feedback_peserta }}
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Footer -->
          <div class="border-t p-6 bg-gray-50">
            <button @click="closeDetailModal"
              class="px-6 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700">
              Tutup
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Form Modal -->
    <div v-if="showFormModal" class="fixed inset-0 z-50 overflow-y-auto">
      <div class="flex items-center justify-center min-h-screen p-4">
        <div class="fixed inset-0 bg-black bg-opacity-50 transition-opacity" @click="closeFormModal"></div>
        
        <div class="relative bg-white rounded-lg max-w-5xl w-full shadow-2xl">
          <!-- Modal header -->
          <div class="flex items-center justify-between p-6 border-b">
            <h2 class="text-xl font-bold text-gray-900">
              {{ formMode === 'create' ? 'Induction Baru' : 'Edit Induction' }}
            </h2>
            <button @click="closeFormModal" class="text-gray-400 hover:text-gray-600">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>

          <!-- Tabs -->
          <div class="border-b border-gray-200 px-6 pt-4">
            <div class="flex gap-4 overflow-x-auto">
              <button @click="activeTab = 1" 
                :class="activeTab === 1 ? 'border-primary-600 text-primary-600' : 'border-transparent text-gray-500 hover:text-gray-700'"
                class="px-4 py-2 border-b-2 font-medium text-sm whitespace-nowrap">
                1. Data Peserta
              </button>
              <button @click="activeTab = 2"
                :class="activeTab === 2 ? 'border-primary-600 text-primary-600' : 'border-transparent text-gray-500 hover:text-gray-700'"
                class="px-4 py-2 border-b-2 font-medium text-sm whitespace-nowrap">
                2. Jadwal & Lokasi
              </button>
              <button @click="activeTab = 3"
                :class="activeTab === 3 ? 'border-primary-600 text-primary-600' : 'border-transparent text-gray-500 hover:text-gray-700'"
                class="px-4 py-2 border-b-2 font-medium text-sm whitespace-nowrap">
                3. Materi & Site Tour
              </button>
              <button @click="activeTab = 4"
                :class="activeTab === 4 ? 'border-primary-600 text-primary-600' : 'border-transparent text-gray-500 hover:text-gray-700'"
                class="px-4 py-2 border-b-2 font-medium text-sm whitespace-nowrap">
                4. APD & Akses
              </button>
              <button @click="activeTab = 5"
                :class="activeTab === 5 ? 'border-primary-600 text-primary-600' : 'border-transparent text-gray-500 hover:text-gray-700'"
                class="px-4 py-2 border-b-2 font-medium text-sm whitespace-nowrap">
                5. Assessment & Evaluasi
              </button>
            </div>
          </div>

          <!-- Form Content -->
          <div class="p-6 overflow-y-auto max-h-[calc(90vh-220px)]">
            <!-- Tab 1: Data Peserta -->
            <div v-show="activeTab === 1" class="space-y-4">
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Nomor Induction *</label>
                  <input v-model="formData.nomor_induction" type="text" placeholder="Auto-generate"
                    class="w-full px-3 py-2 border rounded-lg" />
                  <p class="text-xs text-gray-500 mt-1">Kosongkan untuk auto-generate</p>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Status</label>
                  <select v-model="formData.status" class="w-full px-3 py-2 border rounded-lg">
                    <option value="scheduled">Scheduled</option>
                    <option value="ongoing">Ongoing</option>
                    <option value="completed">Completed</option>
                    <option value="passed">Passed</option>
                    <option value="failed">Failed</option>
                    <option value="no_show">No Show</option>
                    <option value="cancelled">Cancelled</option>
                    <option value="rescheduled">Rescheduled</option>
                  </select>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Nama Peserta *</label>
                  <input v-model="formData.nama_peserta" type="text" required
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">NIK</label>
                  <input v-model="formData.nik" type="text"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">No. Identitas (KTP/Passport)</label>
                  <input v-model="formData.no_identitas" type="text"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Perusahaan *</label>
                  <input v-model="formData.perusahaan" type="text" required
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Jabatan</label>
                  <input v-model="formData.jabatan" type="text"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Departemen</label>
                  <input v-model="formData.departemen" type="text"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">No. Telepon</label>
                  <input v-model="formData.no_telepon" type="tel"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Email</label>
                  <input v-model="formData.email" type="email"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Jenis Peserta *</label>
                  <select v-model="formData.jenis_peserta" class="w-full px-3 py-2 border rounded-lg">
                    <option value="karyawan_baru">Karyawan Baru</option>
                    <option value="karyawan_pindah">Karyawan Pindah</option>
                    <option value="kontraktor">Kontraktor</option>
                    <option value="vendor">Vendor</option>
                    <option value="tamu">Tamu</option>
                    <option value="mahasiswa_pkl">Mahasiswa PKL</option>
                    <option value="tamu_vip">Tamu VIP</option>
                  </select>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Kategori Pekerjaan</label>
                  <select v-model="formData.kategori_pekerjaan" class="w-full px-3 py-2 border rounded-lg">
                    <option value="">Pilih kategori...</option>
                    <option value="office">Office</option>
                    <option value="produksi">Produksi</option>
                    <option value="maintenance">Maintenance</option>
                    <option value="operator">Operator</option>
                    <option value="supervisor">Supervisor</option>
                    <option value="manager">Manager</option>
                    <option value="teknisi">Teknisi</option>
                    <option value="driver">Driver</option>
                    <option value="security">Security</option>
                    <option value="cleaning">Cleaning</option>
                  </select>
                </div>
              </div>
            </div>

            <!-- Tab 2: Jadwal & Lokasi -->
            <div v-show="activeTab === 2" class="space-y-4">
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Tanggal Induction *</label>
                  <input v-model="formData.tanggal_induction" type="date" required
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Unit</label>
                  <select v-model="formData.unit_id" class="w-full px-3 py-2 border rounded-lg">
                    <option value="">Pilih unit...</option>
                    <option v-for="unit in unitsStore.units" :key="unit.id" :value="unit.id">
                      {{ unit.nama }}
                    </option>
                  </select>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Waktu Mulai *</label>
                  <input v-model="formData.waktu_mulai" type="time" required
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Waktu Selesai</label>
                  <input v-model="formData.waktu_selesai" type="time"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Durasi (menit)</label>
                  <input v-model.number="formData.durasi_menit" type="number"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Lokasi Induction *</label>
                  <input v-model="formData.lokasi_induction" type="text" required
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Ruangan</label>
                  <input v-model="formData.ruangan" type="text"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Instruktur Utama *</label>
                  <input v-model="formData.instruktur_utama" type="text" required
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
              </div>

              <!-- Instruktur Pendamping -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Instruktur Pendamping</label>
                <div class="flex gap-2 mb-2">
                  <input v-model="newInstruktur" type="text" placeholder="Nama instruktur pendamping"
                    @keyup.enter="addInstruktur"
                    class="flex-1 px-3 py-2 border rounded-lg text-sm" />
                  <button type="button" @click="addInstruktur"
                    class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 text-sm">
                    Tambah
                  </button>
                </div>
                <div v-if="formData.instruktur_pendamping && formData.instruktur_pendamping.length > 0" class="flex flex-wrap gap-2">
                  <span v-for="(instruktur, idx) in formData.instruktur_pendamping" :key="idx"
                    class="inline-flex items-center gap-2 px-3 py-1 bg-blue-100 text-blue-800 rounded">
                    {{ instruktur }}
                    <button type="button" @click="removeInstruktur(idx)" class="text-red-600 hover:text-red-900">×</button>
                  </span>
                </div>
              </div>
            </div>

            <!-- Tab 3: Materi & Site Tour -->
            <div v-show="activeTab === 3" class="space-y-6">
              <!-- Materi Wajib -->
              <div>
                <h4 class="font-semibold text-gray-900 mb-3">Materi Wajib (Checklist)</h4>
                <div class="grid grid-cols-2 gap-3">
                  <label class="flex items-center gap-2">
                    <input v-model="formData.materi_kebijakan_k3" type="checkbox" class="w-4 h-4 text-primary-600 rounded" />
                    <span class="text-sm">Kebijakan K3</span>
                  </label>
                  <label class="flex items-center gap-2">
                    <input v-model="formData.materi_prosedur_emergency" type="checkbox" class="w-4 h-4 text-primary-600 rounded" />
                    <span class="text-sm">Prosedur Emergency</span>
                  </label>
                  <label class="flex items-center gap-2">
                    <input v-model="formData.materi_apd_wajib" type="checkbox" class="w-4 h-4 text-primary-600 rounded" />
                    <span class="text-sm">APD Wajib</span>
                  </label>
                  <label class="flex items-center gap-2">
                    <input v-model="formData.materi_rambu_k3" type="checkbox" class="w-4 h-4 text-primary-600 rounded" />
                    <span class="text-sm">Rambu K3</span>
                  </label>
                  <label class="flex items-center gap-2">
                    <input v-model="formData.materi_identifikasi_bahaya" type="checkbox" class="w-4 h-4 text-primary-600 rounded" />
                    <span class="text-sm">Identifikasi Bahaya</span>
                  </label>
                  <label class="flex items-center gap-2">
                    <input v-model="formData.materi_pelaporan_insiden" type="checkbox" class="w-4 h-4 text-primary-600 rounded" />
                    <span class="text-sm">Pelaporan Insiden</span>
                  </label>
                  <label class="flex items-center gap-2">
                    <input v-model="formData.materi_permit_to_work" type="checkbox" class="w-4 h-4 text-primary-600 rounded" />
                    <span class="text-sm">Permit to Work</span>
                  </label>
                  <label class="flex items-center gap-2">
                    <input v-model="formData.materi_housekeeping" type="checkbox" class="w-4 h-4 text-primary-600 rounded" />
                    <span class="text-sm">Housekeeping</span>
                  </label>
                  <label class="flex items-center gap-2">
                    <input v-model="formData.materi_chemical_safety" type="checkbox" class="w-4 h-4 text-primary-600 rounded" />
                    <span class="text-sm">Chemical Safety</span>
                  </label>
                  <label class="flex items-center gap-2">
                    <input v-model="formData.materi_working_at_height" type="checkbox" class="w-4 h-4 text-primary-600 rounded" />
                    <span class="text-sm">Working at Height</span>
                  </label>
                  <label class="flex items-center gap-2">
                    <input v-model="formData.materi_confined_space" type="checkbox" class="w-4 h-4 text-primary-600 rounded" />
                    <span class="text-sm">Confined Space</span>
                  </label>
                  <label class="flex items-center gap-2">
                    <input v-model="formData.materi_loto" type="checkbox" class="w-4 h-4 text-primary-600 rounded" />
                    <span class="text-sm">LOTO</span>
                  </label>
                  <label class="flex items-center gap-2">
                    <input v-model="formData.materi_fire_safety" type="checkbox" class="w-4 h-4 text-primary-600 rounded" />
                    <span class="text-sm">Fire Safety</span>
                  </label>
                  <label class="flex items-center gap-2">
                    <input v-model="formData.materi_first_aid" type="checkbox" class="w-4 h-4 text-primary-600 rounded" />
                    <span class="text-sm">First Aid</span>
                  </label>
                  <label class="flex items-center gap-2">
                    <input v-model="formData.materi_ergonomi" type="checkbox" class="w-4 h-4 text-primary-600 rounded" />
                    <span class="text-sm">Ergonomi</span>
                  </label>
                </div>
                <div class="mt-3 text-sm text-gray-600">
                  Total materi: {{ countMateriDisampaikan() }}
                </div>
              </div>

              <!-- Materi Tambahan -->
              <div>
                <h4 class="font-semibold text-gray-900 mb-3">Materi Tambahan (Spesifik)</h4>
                <div class="flex gap-2 mb-3">
                  <input v-model="newMateri.judul" type="text" placeholder="Judul materi"
                    class="flex-1 px-3 py-2 border rounded-lg text-sm" />
                  <input v-model.number="newMateri.durasi_menit" type="number" placeholder="Durasi (menit)"
                    class="w-32 px-3 py-2 border rounded-lg text-sm" />
                  <button type="button" @click="addMateri"
                    class="px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 text-sm">
                    Tambah
                  </button>
                </div>
                <div v-if="formData.materi_tambahan && formData.materi_tambahan.length > 0" class="space-y-2">
                  <div v-for="(materi, idx) in formData.materi_tambahan" :key="idx"
                    class="flex items-center justify-between p-2 bg-white rounded border">
                    <div class="flex items-center gap-3 flex-1">
                      <input v-model="materi.disampaikan" type="checkbox" class="w-4 h-4 text-purple-600 rounded" />
                      <span class="text-sm">{{ materi.judul }} ({{ materi.durasi_menit }} menit)</span>
                    </div>
                    <button type="button" @click="removeMateri(idx)"
                      class="text-red-600 hover:text-red-900 text-sm">×</button>
                  </div>
                </div>
              </div>

              <!-- Site Tour -->
              <div class="border-t pt-4">
                <div class="flex items-center gap-2 mb-3">
                  <input v-model="formData.site_tour_dilakukan" type="checkbox" class="w-4 h-4 text-primary-600 rounded" />
                  <label class="font-semibold text-gray-900">Site Tour Dilakukan</label>
                </div>
                <div v-if="formData.site_tour_dilakukan" class="space-y-3">
                  <div class="grid grid-cols-2 gap-4">
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-2">Durasi Tour (menit)</label>
                      <input v-model.number="formData.durasi_tour_menit" type="number"
                        class="w-full px-3 py-2 border rounded-lg" />
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-2">Pemandu Tour</label>
                      <input v-model="formData.pemandu_tour" type="text"
                        class="w-full px-3 py-2 border rounded-lg" />
                    </div>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Area yang Dikunjungi</label>
                    <div class="flex gap-2 mb-2">
                      <input v-model="newArea" type="text" placeholder="Nama area"
                        @keyup.enter="addArea"
                        class="flex-1 px-3 py-2 border rounded-lg text-sm" />
                      <button type="button" @click="addArea"
                        class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 text-sm">
                        Tambah
                      </button>
                    </div>
                    <div v-if="formData.area_dikunjungi && formData.area_dikunjungi.length > 0" class="flex flex-wrap gap-2">
                      <span v-for="(area, idx) in formData.area_dikunjungi" :key="idx"
                        class="inline-flex items-center gap-2 px-3 py-1 bg-blue-100 text-blue-800 rounded">
                        {{ area }}
                        <button type="button" @click="removeArea(idx)" class="text-red-600 hover:text-red-900">×</button>
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Tab 4: APD & Akses -->
            <div v-show="activeTab === 4" class="space-y-6">
              <!-- APD yang Diberikan -->
              <div>
                <h4 class="font-semibold text-gray-900 mb-3">APD yang Diberikan</h4>
                <div class="grid grid-cols-5 gap-2 mb-3">
                  <input v-model="newAPD.jenis_apd" type="text" placeholder="Jenis APD"
                    class="px-3 py-2 border rounded-lg text-sm" />
                  <input v-model="newAPD.ukuran" type="text" placeholder="Ukuran"
                    class="px-3 py-2 border rounded-lg text-sm" />
                  <input v-model.number="newAPD.jumlah" type="number" placeholder="Jumlah"
                    class="px-3 py-2 border rounded-lg text-sm" />
                  <input v-model="newAPD.nomor_aset" type="text" placeholder="No. Aset"
                    class="px-3 py-2 border rounded-lg text-sm" />
                  <button type="button" @click="addAPD"
                    class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 text-sm">
                    Tambah
                  </button>
                </div>
                <div v-if="formData.apd_diberikan && formData.apd_diberikan.length > 0" class="overflow-x-auto">
                  <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                      <tr>
                        <th class="px-3 py-2 text-left text-xs font-medium text-gray-600">Jenis APD</th>
                        <th class="px-3 py-2 text-left text-xs font-medium text-gray-600">Ukuran</th>
                        <th class="px-3 py-2 text-left text-xs font-medium text-gray-600">Jumlah</th>
                        <th class="px-3 py-2 text-left text-xs font-medium text-gray-600">Nomor Aset</th>
                        <th class="px-3 py-2 text-left text-xs font-medium text-gray-600">Aksi</th>
                      </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                      <tr v-for="(apd, idx) in formData.apd_diberikan" :key="idx">
                        <td class="px-3 py-2 text-sm">{{ apd.jenis_apd }}</td>
                        <td class="px-3 py-2 text-sm">{{ apd.ukuran }}</td>
                        <td class="px-3 py-2 text-sm">{{ apd.jumlah }}</td>
                        <td class="px-3 py-2 text-sm">{{ apd.nomor_aset }}</td>
                        <td class="px-3 py-2 text-sm">
                          <button type="button" @click="removeAPD(idx)" class="text-red-600 hover:text-red-900">×</button>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>

              <!-- Kartu ID -->
              <div class="border-t pt-4">
                <div class="flex items-center gap-2 mb-3">
                  <input v-model="formData.kartu_id_diberikan" type="checkbox" class="w-4 h-4 text-primary-600 rounded" />
                  <label class="font-semibold text-gray-900">Kartu ID Diberikan</label>
                </div>
                <div v-if="formData.kartu_id_diberikan">
                  <label class="block text-sm font-medium text-gray-700 mb-2">Nomor Kartu ID</label>
                  <input v-model="formData.nomor_kartu_id" type="text"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
              </div>

              <!-- Hak Akses Area -->
              <div class="border-t pt-4">
                <h4 class="font-semibold text-gray-900 mb-3">Hak Akses Area</h4>
                <div class="flex gap-2 mb-2">
                  <input v-model="newAksesArea" type="text" placeholder="Nama area akses"
                    @keyup.enter="addAksesArea"
                    class="flex-1 px-3 py-2 border rounded-lg text-sm" />
                  <button type="button" @click="addAksesArea"
                    class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 text-sm">
                    Tambah
                  </button>
                </div>
                <div v-if="formData.akses_area && formData.akses_area.length > 0" class="flex flex-wrap gap-2">
                  <span v-for="(area, idx) in formData.akses_area" :key="idx"
                    class="inline-flex items-center gap-2 px-3 py-1 bg-green-100 text-green-800 rounded">
                    {{ area }}
                    <button type="button" @click="removeAksesArea(idx)" class="text-red-600 hover:text-red-900">×</button>
                  </span>
                </div>
              </div>
            </div>

            <!-- Tab 5: Assessment & Evaluasi -->
            <div v-show="activeTab === 5" class="space-y-6">
              <!-- Ujian/Assessment -->
              <div>
                <div class="flex items-center gap-2 mb-3">
                  <input v-model="formData.ujian_dilakukan" type="checkbox" class="w-4 h-4 text-primary-600 rounded" />
                  <label class="font-semibold text-gray-900">Ujian/Assessment Dilakukan</label>
                </div>
                <div v-if="formData.ujian_dilakukan" class="space-y-3">
                  <div class="grid grid-cols-2 gap-4">
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-2">Jenis Ujian</label>
                      <select v-model="formData.jenis_ujian" class="w-full px-3 py-2 border rounded-lg">
                        <option value="tertulis">Tertulis</option>
                        <option value="lisan">Lisan</option>
                        <option value="praktek">Praktek</option>
                        <option value="online">Online</option>
                        <option value="campuran">Campuran</option>
                      </select>
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-2">Jumlah Soal</label>
                      <input v-model.number="formData.jumlah_soal" type="number"
                        class="w-full px-3 py-2 border rounded-lg" />
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-2">Passing Grade (%)</label>
                      <input v-model.number="formData.passing_grade" type="number" min="0" max="100"
                        class="w-full px-3 py-2 border rounded-lg" />
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-2">Skor Ujian</label>
                      <input v-model.number="formData.skor_ujian" type="number" min="0" max="100"
                        class="w-full px-3 py-2 border rounded-lg" />
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-2">Status Ujian</label>
                      <select v-model="formData.status_ujian" class="w-full px-3 py-2 border rounded-lg">
                        <option value="belum_ujian">Belum Ujian</option>
                        <option value="lulus">Lulus</option>
                        <option value="tidak_lulus">Tidak Lulus</option>
                        <option value="remedial">Remedial</option>
                      </select>
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-2">Tanggal Ujian</label>
                      <input v-model="formData.tanggal_ujian" type="date"
                        class="w-full px-3 py-2 border rounded-lg" />
                    </div>
                  </div>
                </div>
              </div>

              <!-- Sertifikat -->
              <div class="border-t pt-4">
                <div class="flex items-center gap-2 mb-3">
                  <input v-model="formData.sertifikat_diterbitkan" type="checkbox" class="w-4 h-4 text-primary-600 rounded" />
                  <label class="font-semibold text-gray-900">Sertifikat Diterbitkan</label>
                </div>
                <div v-if="formData.sertifikat_diterbitkan" class="space-y-3">
                  <div class="grid grid-cols-2 gap-4">
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-2">Nomor Sertifikat</label>
                      <input v-model="formData.nomor_sertifikat" type="text"
                        class="w-full px-3 py-2 border rounded-lg" />
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-2">Tanggal Terbit</label>
                      <input v-model="formData.tanggal_terbit_sertifikat" type="date"
                        class="w-full px-3 py-2 border rounded-lg" />
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-2">Masa Berlaku (bulan)</label>
                      <input v-model.number="formData.masa_berlaku_bulan" type="number"
                        class="w-full px-3 py-2 border rounded-lg" />
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-2">Tanggal Expired</label>
                      <input v-model="formData.tanggal_expired" type="date" disabled
                        class="w-full px-3 py-2 border rounded-lg bg-gray-100" />
                      <p class="text-xs text-gray-500 mt-1">Auto-calculate from terbit date + masa berlaku</p>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Evaluasi Instruktur -->
              <div class="border-t pt-4">
                <h4 class="font-semibold text-gray-900 mb-3">Evaluasi Instruktur</h4>
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Pemahaman Peserta</label>
                    <select v-model="formData.evaluasi_pemahaman" class="w-full px-3 py-2 border rounded-lg">
                      <option value="">Pilih...</option>
                      <option value="sangat_baik">Sangat Baik</option>
                      <option value="baik">Baik</option>
                      <option value="cukup">Cukup</option>
                      <option value="kurang">Kurang</option>
                    </select>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Keaktifan Peserta</label>
                    <select v-model="formData.evaluasi_keaktifan" class="w-full px-3 py-2 border rounded-lg">
                      <option value="">Pilih...</option>
                      <option value="sangat_aktif">Sangat Aktif</option>
                      <option value="aktif">Aktif</option>
                      <option value="cukup">Cukup</option>
                      <option value="pasif">Pasif</option>
                    </select>
                  </div>
                </div>
                <div class="mt-3">
                  <label class="block text-sm font-medium text-gray-700 mb-2">Catatan Instruktur</label>
                  <textarea v-model="formData.catatan_instruktur" rows="3"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
                <div class="mt-3">
                  <label class="block text-sm font-medium text-gray-700 mb-2">Rekomendasi Khusus</label>
                  <textarea v-model="formData.rekomendasi_khusus" rows="2"
                    class="w-full px-3 py-2 border rounded-lg" />
                </div>
              </div>

              <!-- Feedback Peserta -->
              <div class="border-t pt-4">
                <h4 class="font-semibold text-gray-900 mb-3">Feedback Peserta</h4>
                <div class="grid grid-cols-2 gap-4 mb-3">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Rating Materi (1-5)</label>
                    <input v-model.number="formData.rating_materi" type="number" min="1" max="5"
                      class="w-full px-3 py-2 border rounded-lg" />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Rating Instruktur (1-5)</label>
                    <input v-model.number="formData.rating_instruktur" type="number" min="1" max="5"
                      class="w-full px-3 py-2 border rounded-lg" />
                  </div>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Feedback Peserta</label>
                  <textarea v-model="formData.feedback_peserta" rows="3"
                    placeholder="Feedback dan saran dari peserta"
                    class="w-full px-3 py-2 border rounded-lg" />
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
              <button v-if="activeTab < 5" type="button" @click="activeTab++"
                class="px-6 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700">
                Selanjutnya →
              </button>
              <button v-if="activeTab === 5" type="button" @click="handleSubmit"
                class="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700">
                💾 Simpan
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
