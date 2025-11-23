<template>
  <div class="space-y-6">
    <!-- Page Header -->
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-3xl font-bold text-gray-900">Master Pegawai</h1>
        <p class="mt-2 text-gray-600">Kelola data pegawai perusahaan</p>
      </div>
      <button
        @click="showFormModal = true; selectedPegawai = null; resetForm()"
        class="btn-primary flex items-center space-x-2"
      >
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
        <span>Tambah Pegawai</span>
      </button>
    </div>

    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
      <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl shadow-lg p-6 text-white">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-blue-100 text-sm">Total Pegawai</p>
            <p class="text-3xl font-bold mt-1">{{ stats.total }}</p>
          </div>
          <div class="bg-white/20 rounded-lg p-3">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
            </svg>
          </div>
        </div>
      </div>

      <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-xl shadow-lg p-6 text-white">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-green-100 text-sm">Pegawai Aktif</p>
            <p class="text-3xl font-bold mt-1">{{ stats.aktif }}</p>
          </div>
          <div class="bg-white/20 rounded-lg p-3">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
        </div>
      </div>

      <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-xl shadow-lg p-6 text-white">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-purple-100 text-sm">Unit Kerja</p>
            <p class="text-3xl font-bold mt-1">{{ stats.units }}</p>
          </div>
          <div class="bg-white/20 rounded-lg p-3">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
            </svg>
          </div>
        </div>
      </div>

      <div class="bg-gradient-to-br from-orange-500 to-orange-600 rounded-xl shadow-lg p-6 text-white">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-orange-100 text-sm">Jabatan</p>
            <p class="text-3xl font-bold mt-1">{{ stats.jabatans }}</p>
          </div>
          <div class="bg-white/20 rounded-lg p-3">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m8 0V8a2 2 0 01-2 2H8a2 2 0 01-2-2V6m8 0H8m0 0V4" />
            </svg>
          </div>
        </div>
      </div>
    </div>

    <!-- Search and Filters -->
    <div class="card">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Cari</label>
          <input
            v-model="filters.search"
            @input="applyFilters"
            type="text"
            placeholder="Nama, NIPP, Jabatan..."
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Unit Kerja</label>
          <select
            v-model="filters.unit_kerja"
            @change="applyFilters"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">Semua Unit</option>
            <option v-for="unit in availableUnits" :key="unit" :value="unit">{{ unit }}</option>
          </select>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Jabatan</label>
          <select
            v-model="filters.jabatan"
            @change="applyFilters"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">Semua Jabatan</option>
            <option v-for="jabatan in availableJabatans" :key="jabatan" :value="jabatan">{{ jabatan }}</option>
          </select>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
          <select
            v-model="filters.status"
            @change="applyFilters"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">Semua Status</option>
            <option value="aktif">Aktif</option>
            <option value="non_aktif">Non Aktif</option>
            <option value="resign">Resign</option>
            <option value="pensiun">Pensiun</option>
          </select>
        </div>
      </div>

      <!-- Table -->
      <div v-if="loading" class="text-center py-12">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-4 border-blue-600 border-t-transparent"></div>
        <p class="mt-4 text-gray-600">Loading data...</p>
      </div>

      <div v-else-if="filteredPegawai.length === 0" class="text-center py-12">
        <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
        </svg>
        <p class="mt-4 text-gray-600">Belum ada data pegawai</p>
        <button @click="showFormModal = true; selectedPegawai = null; resetForm()" class="btn-primary mt-4">
          Tambah Pegawai Pertama
        </button>
      </div>

      <div v-else class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">NIPP</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Jabatan</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Unit Kerja</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-for="pegawai in paginatedPegawai" :key="pegawai.id" class="hover:bg-gray-50">
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm font-medium text-gray-900">{{ pegawai.nama }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm text-gray-900">{{ pegawai.nipp }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm text-gray-900">{{ pegawai.jabatan }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm text-gray-900">{{ pegawai.unit_kerja }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span :class="getStatusBadge(pegawai.status)">
                  {{ getStatusText(pegawai.status) }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                <button
                  @click="editPegawai(pegawai)"
                  class="text-blue-600 hover:text-blue-900 mr-3"
                >
                  Edit
                </button>
                <button
                  @click="deletePegawai(pegawai)"
                  class="text-red-600 hover:text-red-900"
                >
                  Hapus
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Pagination -->
      <div v-if="totalPages > 1" class="flex items-center justify-between mt-6">
        <div class="text-sm text-gray-700">
          Menampilkan {{ (currentPage - 1) * pageSize + 1 }} sampai {{ Math.min(currentPage * pageSize, totalItems) }} dari {{ totalItems }} hasil
        </div>
        <div class="flex space-x-2">
          <button
            @click="currentPage--"
            :disabled="currentPage <= 1"
            class="px-3 py-1 border border-gray-300 rounded-md text-sm disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-50"
          >
            Previous
          </button>
          <button
            v-for="page in visiblePages"
            :key="page"
            @click="currentPage = page"
            :class="page === currentPage ? 'bg-blue-600 text-white' : 'bg-white text-gray-700 hover:bg-gray-50'"
            class="px-3 py-1 border border-gray-300 rounded-md text-sm"
          >
            {{ page }}
          </button>
          <button
            @click="currentPage++"
            :disabled="currentPage >= totalPages"
            class="px-3 py-1 border border-gray-300 rounded-md text-sm disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-50"
          >
            Next
          </button>
        </div>
      </div>
    </div>

    <!-- Form Modal -->
    <div v-if="showFormModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div class="bg-white rounded-lg shadow-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div class="p-6">
          <h2 class="text-2xl font-bold text-gray-900 mb-6">
            {{ selectedPegawai ? 'Edit Pegawai' : 'Tambah Pegawai' }}
          </h2>

          <form @submit.prevent="savePegawai" class="space-y-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Nama *</label>
                <input
                  v-model="formData.nama"
                  type="text"
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">NIPP *</label>
                <input
                  v-model="formData.nipp"
                  type="text"
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Jabatan *</label>
                <input
                  v-model="formData.jabatan"
                  type="text"
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Unit Kerja *</label>
                <input
                  v-model="formData.unit_kerja"
                  type="text"
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                <input
                  v-model="formData.email"
                  type="email"
                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">No. Telepon</label>
                <input
                  v-model="formData.no_telepon"
                  type="tel"
                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Lahir</label>
                <input
                  v-model="formData.tanggal_lahir"
                  type="date"
                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                <select
                  v-model="formData.status"
                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                >
                  <option value="aktif">Aktif</option>
                  <option value="non_aktif">Non Aktif</option>
                  <option value="resign">Resign</option>
                  <option value="pensiun">Pensiun</option>
                </select>
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Alamat</label>
              <textarea
                v-model="formData.alamat"
                rows="3"
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              ></textarea>
            </div>

            <div class="flex justify-end space-x-3 pt-6 border-t">
              <button
                type="button"
                @click="showFormModal = false"
                class="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50"
              >
                Batal
              </button>
              <button
                type="submit"
                :disabled="saving"
                class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:opacity-50"
              >
                {{ saving ? 'Menyimpan...' : 'Simpan' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { masterPegawaiService, type MasterPegawai } from '@/services/master-pegawai.service'

// Data
const pegawai = ref<MasterPegawai[]>([])
const availableUnits = ref<string[]>([])
const availableJabatans = ref<string[]>([])
const loading = ref(false)
const saving = ref(false)
const showFormModal = ref(false)
const selectedPegawai = ref<MasterPegawai | null>(null)

// Pagination
const currentPage = ref(1)
const pageSize = ref(10)
const totalItems = ref(0)

// Filters
const filters = ref({
  search: '',
  unit_kerja: '',
  jabatan: '',
  status: ''
})

// Form data
const formData = ref<Partial<MasterPegawai>>({
  nama: '',
  nipp: '',
  jabatan: '',
  unit_kerja: '',
  email: '',
  no_telepon: '',
  tanggal_lahir: '',
  alamat: '',
  status: 'aktif'
})

// Computed
const filteredPegawai = computed(() => {
  let result = pegawai.value

  if (filters.value.search) {
    const search = filters.value.search.toLowerCase()
    result = result.filter(p =>
      p.nama?.toLowerCase().includes(search) ||
      p.nipp?.toLowerCase().includes(search) ||
      p.jabatan?.toLowerCase().includes(search)
    )
  }

  if (filters.value.unit_kerja) {
    result = result.filter(p => p.unit_kerja === filters.value.unit_kerja)
  }

  if (filters.value.jabatan) {
    result = result.filter(p => p.jabatan === filters.value.jabatan)
  }

  if (filters.value.status) {
    result = result.filter(p => p.status === filters.value.status)
  }

  return result
})

const totalPages = computed(() => Math.ceil(filteredPegawai.value.length / pageSize.value))

const paginatedPegawai = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  const end = start + pageSize.value
  return filteredPegawai.value.slice(start, end)
})

const visiblePages = computed(() => {
  const pages = []
  const start = Math.max(1, currentPage.value - 2)
  const end = Math.min(totalPages.value, currentPage.value + 2)

  for (let i = start; i <= end; i++) {
    pages.push(i)
  }

  return pages
})

const stats = computed(() => {
  const total = pegawai.value.length
  const aktif = pegawai.value.filter(p => p.status === 'aktif').length
  const units = new Set(pegawai.value.map(p => p.unit_kerja)).size
  const jabatans = new Set(pegawai.value.map(p => p.jabatan)).size

  return { total, aktif, units, jabatans }
})

// Methods
const loadPegawai = async () => {
  loading.value = true
  try {
    const result = await masterPegawaiService.getAll(filters.value)
    pegawai.value = result.data
    totalItems.value = result.count

    // Load available units and jabatans
    availableUnits.value = await masterPegawaiService.getUnits()
    availableJabatans.value = await masterPegawaiService.getJabatans()
  } catch (error) {
    console.error('Error loading pegawai:', error)
    alert('Gagal memuat data pegawai')
  } finally {
    loading.value = false
  }
}

const applyFilters = () => {
  currentPage.value = 1
  loadPegawai()
}

const resetForm = () => {
  formData.value = {
    nama: '',
    nipp: '',
    jabatan: '',
    unit_kerja: '',
    email: '',
    no_telepon: '',
    tanggal_lahir: '',
    alamat: '',
    status: 'aktif'
  }
}

const editPegawai = (pegawai: MasterPegawai) => {
  selectedPegawai.value = pegawai
  formData.value = { ...pegawai }
  showFormModal.value = true
}

const savePegawai = async () => {
  saving.value = true
  try {
    if (selectedPegawai.value) {
      await masterPegawaiService.update(selectedPegawai.value.id!, formData.value)
      alert('Pegawai berhasil diupdate')
    } else {
      await masterPegawaiService.create(formData.value as Omit<MasterPegawai, 'id' | 'created_at' | 'updated_at'>)
      alert('Pegawai berhasil ditambahkan')
    }

    showFormModal.value = false
    loadPegawai()
  } catch (error: any) {
    console.error('Error saving pegawai:', error)
    alert('Gagal menyimpan pegawai: ' + error.message)
  } finally {
    saving.value = false
  }
}

const deletePegawai = async (pegawai: MasterPegawai) => {
  if (!confirm(`Apakah Anda yakin ingin menghapus pegawai ${pegawai.nama}?`)) {
    return
  }

  try {
    await masterPegawaiService.delete(pegawai.id!)
    alert('Pegawai berhasil dihapus')
    loadPegawai()
  } catch (error) {
    console.error('Error deleting pegawai:', error)
    alert('Gagal menghapus pegawai')
  }
}

const getStatusBadge = (status?: string) => {
  const baseClasses = 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium'

  switch (status) {
    case 'aktif':
      return baseClasses + ' bg-green-100 text-green-800'
    case 'non_aktif':
      return baseClasses + ' bg-yellow-100 text-yellow-800'
    case 'resign':
      return baseClasses + ' bg-red-100 text-red-800'
    case 'pensiun':
      return baseClasses + ' bg-gray-100 text-gray-800'
    default:
      return baseClasses + ' bg-gray-100 text-gray-800'
  }
}

const getStatusText = (status?: string) => {
  switch (status) {
    case 'aktif':
      return 'Aktif'
    case 'non_aktif':
      return 'Non Aktif'
    case 'resign':
      return 'Resign'
    case 'pensiun':
      return 'Pensiun'
    default:
      return 'Unknown'
  }
}

// Lifecycle
onMounted(() => {
  loadPegawai()
})
</script>