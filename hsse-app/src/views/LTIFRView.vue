<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { supabase } from '@/services/api/supabase'
import { useAuthStore } from '@/stores/auth'

interface LTIFRRecord {
  id?: string
  periode_bulan: string
  unit_id?: string
  unit?: {
    nama: string
  }
  // Data Kecelakaan
  jumlah_lti: number  // Lost Time Injury
  jumlah_fatality: number  // Kecelakaan Fatal
  jumlah_near_miss: number  // Nyaris Celaka
  
  // Data Jam Kerja
  jumlah_pekerja: number
  hari_kerja: number
  jam_kerja_per_hari: number
  total_jam_kerja: number  // Calculated: jumlah_pekerja × hari_kerja × jam_kerja_per_hari
  
  // Hasil Perhitungan
  ltifr: number  // Calculated: (jumlah_lti × 1.000.000) / total_jam_kerja
  
  // Detail
  deskripsi_kecelakaan?: string
  tindakan_perbaikan?: string
  pic_penanggung_jawab?: string
  created_at?: string
}

const authStore = useAuthStore()
const records = ref<LTIFRRecord[]>([])
const loading = ref(false)
const showModal = ref(false)
const modalMode = ref<'add' | 'edit' | 'detail'>('add')
const selectedRecord = ref<LTIFRRecord | null>(null)
const units = ref<any[]>([])

// Filter
const filterMonth = ref('')
const filterUnit = ref('')

// Form data
const formData = ref<LTIFRRecord>({
  periode_bulan: '2025-01',
  jumlah_lti: 0,
  jumlah_fatality: 0,
  jumlah_near_miss: 0,
  jumlah_pekerja: 0,
  hari_kerja: 0,
  jam_kerja_per_hari: 8,
  total_jam_kerja: 0,
  ltifr: 0
})

// Computed
const filteredRecords = computed(() => {
  let result = records.value
  console.log('All records:', records.value.length)
  console.log('Filter month:', filterMonth.value)
  console.log('Filter unit:', filterUnit.value)
  
  if (filterMonth.value) {
    result = result.filter(r => r.periode_bulan === filterMonth.value)
  }
  
  if (filterUnit.value) {
    result = result.filter(r => r.unit_id === filterUnit.value)
  }
  
  console.log('Filtered records:', result.length)
  return result
})

const totalLTI = computed(() => 
  filteredRecords.value.reduce((sum, r) => sum + r.jumlah_lti, 0)
)

const totalFatality = computed(() => 
  filteredRecords.value.reduce((sum, r) => sum + r.jumlah_fatality, 0)
)

const totalJamKerja = computed(() => 
  filteredRecords.value.reduce((sum, r) => sum + r.total_jam_kerja, 0)
)

const averageLTIFR = computed(() => {
  if (totalJamKerja.value === 0) return 0
  return ((totalLTI.value * 1000000) / totalJamKerja.value).toFixed(2)
})

// Auto calculate
const calculateTotalJamKerja = () => {
  formData.value.total_jam_kerja = 
    formData.value.jumlah_pekerja * 
    formData.value.hari_kerja * 
    formData.value.jam_kerja_per_hari
  calculateLTIFR()
}

const calculateLTIFR = () => {
  if (formData.value.total_jam_kerja === 0) {
    formData.value.ltifr = 0
    return
  }
  formData.value.ltifr = 
    (formData.value.jumlah_lti * 1000000) / formData.value.total_jam_kerja
}

// CRUD Operations
async function loadData() {
  loading.value = true
  try {
    console.log('Loading LTIFR data...')
    const { data, error } = await supabase
      .from('ltifr_records')
      .select('*, unit:units(nama)')
      .order('periode_bulan', { ascending: false })
    
    console.log('LTIFR data response:', { data, error })
    
    if (error) throw error
    records.value = data || []
    console.log('Records loaded:', records.value.length)
  } catch (error: any) {
    console.error('Error loading LTIFR data:', error)
    alert('Gagal memuat data: ' + error.message)
  } finally {
    loading.value = false
  }
}

async function loadUnits() {
  try {
    const { data, error } = await supabase
      .from('units')
      .select('id, nama')
      .order('nama')
    
    if (error) throw error
    units.value = data || []
  } catch (error) {
    console.error('Error loading units:', error)
  }
}

function openModal(mode: 'add' | 'edit' | 'detail', record?: LTIFRRecord) {
  modalMode.value = mode
  selectedRecord.value = record || null
  
  if (mode === 'add') {
    formData.value = {
      periode_bulan: '2025-01',
      unit_id: authStore.unitId || '',
      jumlah_lti: 0,
      jumlah_fatality: 0,
      jumlah_near_miss: 0,
      jumlah_pekerja: 0,
      hari_kerja: 0,
      jam_kerja_per_hari: 8,
      total_jam_kerja: 0,
      ltifr: 0
    }
  } else if (record) {
    formData.value = { ...record }
  }
  
  showModal.value = true
}

function closeModal() {
  showModal.value = false
  selectedRecord.value = null
}

async function saveRecord() {
  try {
    calculateTotalJamKerja()
    
    const dataToSave = {
      periode_bulan: formData.value.periode_bulan,
      unit_id: formData.value.unit_id || null,
      jumlah_lti: formData.value.jumlah_lti,
      jumlah_fatality: formData.value.jumlah_fatality,
      jumlah_near_miss: formData.value.jumlah_near_miss,
      jumlah_pekerja: formData.value.jumlah_pekerja,
      hari_kerja: formData.value.hari_kerja,
      jam_kerja_per_hari: formData.value.jam_kerja_per_hari,
      total_jam_kerja: formData.value.total_jam_kerja,
      ltifr: formData.value.ltifr,
      deskripsi_kecelakaan: formData.value.deskripsi_kecelakaan,
      tindakan_perbaikan: formData.value.tindakan_perbaikan,
      pic_penanggung_jawab: formData.value.pic_penanggung_jawab
    }
    
    if (modalMode.value === 'edit' && selectedRecord.value?.id) {
      const { error } = await supabase
        .from('ltifr_records')
        .update(dataToSave)
        .eq('id', selectedRecord.value.id)
      
      if (error) throw error
      alert('Data berhasil diupdate')
    } else {
      const { error } = await supabase
        .from('ltifr_records')
        .insert([dataToSave])
      
      if (error) throw error
      alert('Data berhasil ditambahkan')
    }
    
    closeModal()
    loadData()
  } catch (error) {
    console.error('Error saving record:', error)
    alert('Gagal menyimpan data')
  }
}

async function deleteRecord(record: LTIFRRecord) {
  if (!confirm('Yakin ingin menghapus data ini?')) return
  
  try {
    const { error } = await supabase
      .from('ltifr_records')
      .delete()
      .eq('id', record.id)
    
    if (error) throw error
    alert('Data berhasil dihapus')
    loadData()
  } catch (error) {
    console.error('Error deleting record:', error)
    alert('Gagal menghapus data')
  }
}

function formatMonth(month: string) {
  const date = new Date(month + '-01')
  return date.toLocaleDateString('id-ID', { year: 'numeric', month: 'long' })
}

onMounted(() => {
  loadData()
  loadUnits()
})
</script>

<template>
  <div class="ltifr-view">
    <!-- Header -->
    <div class="flex justify-between items-center mb-6">
      <div>
        <h1 class="text-2xl font-bold text-gray-800">Laporan LTIFR</h1>
        <p class="text-sm text-gray-600 mt-1">Lost Time Injury Frequency Rate</p>
      </div>
      <button
        @click="openModal('add')"
        class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 flex items-center gap-2"
      >
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
        Tambah Data
      </button>
    </div>

    <!-- Statistics Cards -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
      <div class="bg-blue-50 rounded-lg p-4 border border-blue-200">
        <p class="text-sm text-blue-600 font-medium">Total LTI</p>
        <p class="text-3xl font-bold text-blue-700">{{ totalLTI }}</p>
      </div>
      <div class="bg-red-50 rounded-lg p-4 border border-red-200">
        <p class="text-sm text-red-600 font-medium">Total Fatality</p>
        <p class="text-3xl font-bold text-red-700">{{ totalFatality }}</p>
      </div>
      <div class="bg-green-50 rounded-lg p-4 border border-green-200">
        <p class="text-sm text-green-600 font-medium">Total Jam Kerja</p>
        <p class="text-3xl font-bold text-green-700">{{ totalJamKerja.toLocaleString() }}</p>
      </div>
      <div class="bg-purple-50 rounded-lg p-4 border border-purple-200">
        <p class="text-sm text-purple-600 font-medium">Rata-rata LTIFR</p>
        <p class="text-3xl font-bold text-purple-700">{{ averageLTIFR }}</p>
      </div>
    </div>

    <!-- Filters -->
    <div class="bg-white rounded-lg shadow p-4 mb-6">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Periode Bulan</label>
          <input
            type="month"
            v-model="filterMonth"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Unit</label>
          <select
            v-model="filterUnit"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          >
            <option value="">Semua Unit</option>
            <option v-for="unit in units" :key="unit.id" :value="unit.id">
              {{ unit.nama }}
            </option>
          </select>
        </div>
        <div class="flex items-end">
          <button
            @click="filterMonth = ''; filterUnit = ''"
            class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50"
          >
            Reset Filter
          </button>
        </div>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="text-center py-12">
      <div class="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
      <p class="mt-2 text-gray-600">Memuat data...</p>
    </div>

    <!-- Table -->
    <div v-else class="bg-white rounded-lg shadow overflow-hidden">
      <div class="table-responsive">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Periode</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Unit</th>
              <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase">LTI</th>
              <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase">Fatality</th>
              <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase">Near Miss</th>
              <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Total Jam Kerja</th>
              <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase">LTIFR</th>
              <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase">Aksi</th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-for="record in filteredRecords" :key="record.id" class="hover:bg-gray-50">
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                {{ formatMonth(record.periode_bulan) }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                {{ record.unit?.nama || 'Semua Unit' }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-center">
                <span class="px-2 py-1 bg-blue-100 text-blue-800 rounded-full font-semibold">
                  {{ record.jumlah_lti }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-center">
                <span class="px-2 py-1 bg-red-100 text-red-800 rounded-full font-semibold">
                  {{ record.jumlah_fatality }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-center">
                <span class="px-2 py-1 bg-yellow-100 text-yellow-800 rounded-full font-semibold">
                  {{ record.jumlah_near_miss }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 text-right font-mono">
                {{ record.total_jam_kerja.toLocaleString() }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-center">
                <span class="px-3 py-1 bg-purple-100 text-purple-800 rounded-full font-bold">
                  {{ record.ltifr.toFixed(2) }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-center">
                <div class="flex justify-center gap-2">
                  <button
                    @click="openModal('detail', record)"
                    class="text-blue-600 hover:text-blue-900"
                    title="Detail"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                    </svg>
                  </button>
                  <button
                    @click="openModal('edit', record)"
                    class="text-green-600 hover:text-green-900"
                    title="Edit"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                    </svg>
                  </button>
                  <button
                    @click="deleteRecord(record)"
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

      <!-- Empty State -->
      <div v-if="!filteredRecords.length" class="text-center py-12 text-gray-500">
        Tidak ada data LTIFR
      </div>
    </div>

    <!-- Modal -->
    <div v-if="showModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div class="bg-white rounded-lg max-w-3xl w-full max-h-[90vh] overflow-y-auto">
        <!-- Modal Header -->
        <div class="sticky top-0 bg-white border-b px-6 py-4 flex justify-between items-center">
          <h2 class="text-xl font-bold text-gray-800">
            {{ modalMode === 'add' ? 'Tambah Data LTIFR' : modalMode === 'edit' ? 'Edit Data LTIFR' : 'Detail Data LTIFR' }}
          </h2>
          <button @click="closeModal" class="text-gray-500 hover:text-gray-700">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <!-- Modal Body -->
        <div class="p-6">
          <div class="space-y-4">
            <!-- Periode & Unit -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Periode Bulan *</label>
                <input
                  type="month"
                  v-model="formData.periode_bulan"
                  :disabled="modalMode === 'detail'"
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  required
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Unit</label>
                <select
                  v-model="formData.unit_id"
                  :disabled="modalMode === 'detail' || !authStore.isAdmin"
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                >
                  <option value="">Semua Unit</option>
                  <option v-for="unit in units" :key="unit.id" :value="unit.id">
                    {{ unit.nama }}
                  </option>
                </select>
              </div>
            </div>

            <!-- Divider -->
            <div class="border-t pt-4">
              <h3 class="font-semibold text-gray-700 mb-3">Data Kecelakaan</h3>
            </div>

            <!-- Data Kecelakaan -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Jumlah LTI *</label>
                <input
                  type="number"
                  v-model.number="formData.jumlah_lti"
                  @input="calculateLTIFR"
                  :disabled="modalMode === 'detail'"
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  min="0"
                  required
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Jumlah Fatality</label>
                <input
                  type="number"
                  v-model.number="formData.jumlah_fatality"
                  :disabled="modalMode === 'detail'"
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  min="0"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Jumlah Near Miss</label>
                <input
                  type="number"
                  v-model.number="formData.jumlah_near_miss"
                  :disabled="modalMode === 'detail'"
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  min="0"
                />
              </div>
            </div>

            <!-- Divider -->
            <div class="border-t pt-4">
              <h3 class="font-semibold text-gray-700 mb-3">Data Jam Kerja</h3>
            </div>

            <!-- Data Jam Kerja -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Jumlah Pekerja *</label>
                <input
                  type="number"
                  v-model.number="formData.jumlah_pekerja"
                  @input="calculateTotalJamKerja"
                  :disabled="modalMode === 'detail'"
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  min="0"
                  required
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Hari Kerja *</label>
                <input
                  type="number"
                  v-model.number="formData.hari_kerja"
                  @input="calculateTotalJamKerja"
                  :disabled="modalMode === 'detail'"
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  min="0"
                  required
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Jam Kerja/Hari *</label>
                <input
                  type="number"
                  v-model.number="formData.jam_kerja_per_hari"
                  @input="calculateTotalJamKerja"
                  :disabled="modalMode === 'detail'"
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                  min="0"
                  step="0.5"
                  required
                />
              </div>
            </div>

            <!-- Hasil Perhitungan -->
            <div class="bg-gray-50 rounded-lg p-4 space-y-2">
              <div class="flex justify-between items-center">
                <span class="text-sm font-medium text-gray-700">Total Jam Kerja:</span>
                <span class="text-lg font-bold text-blue-600">{{ formData.total_jam_kerja.toLocaleString() }}</span>
              </div>
              <div class="flex justify-between items-center">
                <span class="text-sm font-medium text-gray-700">LTIFR:</span>
                <span class="text-2xl font-bold text-purple-600">{{ formData.ltifr.toFixed(2) }}</span>
              </div>
              <p class="text-xs text-gray-500 mt-2">
                Formula: (Jumlah LTI × 1.000.000) / Total Jam Kerja
              </p>
            </div>

            <!-- Deskripsi -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Deskripsi Kecelakaan</label>
              <textarea
                v-model="formData.deskripsi_kecelakaan"
                :disabled="modalMode === 'detail'"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                rows="3"
                placeholder="Jelaskan detail kecelakaan yang terjadi..."
              ></textarea>
            </div>

            <!-- Tindakan Perbaikan -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Tindakan Perbaikan</label>
              <textarea
                v-model="formData.tindakan_perbaikan"
                :disabled="modalMode === 'detail'"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                rows="3"
                placeholder="Jelaskan tindakan perbaikan yang dilakukan..."
              ></textarea>
            </div>

            <!-- PIC Penanggung Jawab -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">PIC Penanggung Jawab</label>
              <input
                type="text"
                v-model="formData.pic_penanggung_jawab"
                :disabled="modalMode === 'detail'"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
                placeholder="Nama penanggung jawab yang menangani..."
              />
            </div>
          </div>
        </div>

        <!-- Modal Footer -->
        <div class="sticky bottom-0 bg-gray-50 px-6 py-4 flex justify-end gap-3">
          <button
            @click="closeModal"
            class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-100"
          >
            {{ modalMode === 'detail' ? 'Tutup' : 'Batal' }}
          </button>
          <button
            v-if="modalMode !== 'detail'"
            @click="saveRecord"
            class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
          >
            Simpan
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.ltifr-view {
  padding: 1.5rem;
}

.table-responsive {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

@media (max-width: 768px) {
  .ltifr-view {
    padding: 1rem;
  }
}
</style>
