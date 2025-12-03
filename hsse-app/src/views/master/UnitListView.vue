<template>
  <div class="space-y-6">
    <!-- Page Header -->
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-3xl font-bold text-gray-900">Master Unit</h1>
        <p class="mt-2 text-gray-600">Kelola data unit berdasarkan wilayah dan area</p>
      </div>
      <button 
        @click="openAddUnitModal"
        class="btn-primary flex items-center space-x-2"
      >
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
        <span>Tambah Unit</span>
      </button>
    </div>

    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl shadow-lg p-6 text-white">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-blue-100 text-sm">Total Unit</p>
            <p class="text-3xl font-bold mt-1">{{ masterPelabuhanStore.masterPelabuhan.length }}</p>
          </div>
          <div class="bg-white/20 rounded-lg p-3">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
            </svg>
          </div>
        </div>
      </div>

      <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-xl shadow-lg p-6 text-white">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-green-100 text-sm">Unit Aktif</p>
            <p class="text-3xl font-bold mt-1">{{ masterPelabuhanStore.activeMasterPelabuhan.length }}</p>
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
            <p class="text-purple-100 text-sm">Wilayah</p>
            <p class="text-3xl font-bold mt-1">{{ new Set(masterPelabuhanStore.masterPelabuhan.map(mp => mp.wilayah?.nama)).size }}</p>
          </div>
          <div class="bg-white/20 rounded-lg p-3">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
        </div>
      </div>
    </div>

    <!-- Search and Table -->
    <div class="card">
      <div class="mb-4">
        <input 
          v-model="searchQuery" 
          type="text" 
          placeholder="Cari unit, area, atau wilayah..."
          class="input-field max-w-md"
        />
      </div>

      <div v-if="masterPelabuhanStore.loading" class="text-center py-12">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-4 border-primary-600 border-t-transparent"></div>
        <p class="mt-4 text-gray-600">Loading data...</p>
      </div>

      <div v-else-if="masterPelabuhanStore.error" class="text-center py-12">
        <p class="text-red-600">{{ masterPelabuhanStore.error }}</p>
        <button @click="loadData" class="btn-primary mt-4">Coba Lagi</button>
      </div>

      <div v-else-if="filteredUnits.length === 0" class="text-center py-12">
        <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
        </svg>
        <p class="mt-4 text-gray-600">Belum ada data master pelabuhan</p>
        <p class="mt-2 text-sm text-gray-500">Data akan muncul setelah konfigurasi master pelabuhan selesai</p>
      </div>

      <div v-else class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Wilayah</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Area</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Unit</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
              <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-for="unit in filteredUnits" :key="unit.id" class="hover:bg-gray-50">
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm font-medium text-gray-900">{{ unit.wilayah?.nama || '-' }}</div>
                <div class="text-sm text-gray-500">{{ unit.wilayah?.kode || '-' }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm font-medium text-gray-900">{{ unit.area?.nama || '-' }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm font-medium text-gray-900">{{ unit.unit?.nama || '-' }}</div>
                <div class="text-sm text-gray-500">{{ unit.unit?.kode || '' }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span :class="unit.aktif ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'" 
                      class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full">
                  {{ unit.aktif ? 'Aktif' : 'Nonaktif' }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                <div class="flex gap-2 justify-end">
                  <button
                    @click="openEditUnitModal(unit)"
                    class="text-indigo-600 hover:text-indigo-900"
                    title="Edit unit"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                    </svg>
                  </button>
                  <button
                    @click="confirmDelete(unit)"
                    class="text-red-600 hover:text-red-900"
                    title="Hapus unit"
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
    </div>

    <!-- Add/Edit Unit Modal -->
    <div v-if="showModal" @click="closeModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
      <div @click.stop class="relative top-20 mx-auto p-5 border w-full max-w-2xl shadow-lg rounded-md bg-white">
        <div class="flex items-center justify-between mb-4">
          <h3 class="text-xl font-bold text-gray-900">
            {{ editingUnit ? 'Edit Unit' : 'Tambah Unit Baru' }}
          </h3>
          <button @click="closeModal" class="text-gray-400 hover:text-gray-600">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <form @submit.prevent="saveUnit" class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Wilayah *</label>
            <select v-model="formData.wilayah_id" required class="input-field">
              <option value="">Pilih Wilayah</option>
              <option v-for="wilayah in availableWilayah" :key="wilayah.id" :value="wilayah.id">
                {{ wilayah.nama }} ({{ wilayah.kode }})
              </option>
            </select>
            <p v-if="availableWilayah.length === 0" class="text-xs text-red-500 mt-1">
              Tidak ada data wilayah. Pastikan tabel wilayah sudah terisi.
            </p>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Area *</label>
            <select v-model="formData.area_id" required class="input-field" :disabled="!formData.wilayah_id">
              <option value="">Pilih Area</option>
              <option v-for="area in availableAreas" :key="area.id" :value="area.id">
                {{ area.nama }}
              </option>
            </select>
            <p v-if="formData.wilayah_id && availableAreas.length === 0" class="text-xs text-red-500 mt-1">
              Tidak ada area untuk wilayah ini.
            </p>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Unit *</label>
            <select v-model="formData.unit_id" required class="input-field" :disabled="!formData.area_id">
              <option value="">Pilih Unit</option>
              <option v-for="unit in availableUnits" :key="unit.id" :value="unit.id">
                {{ unit.nama }} ({{ unit.kode }})
              </option>
            </select>
            <p v-if="formData.area_id && availableUnits.length === 0" class="text-xs text-red-500 mt-1">
              Tidak ada unit untuk area ini.
            </p>
          </div>

          <div class="flex items-center">
            <input 
              v-model="formData.aktif" 
              type="checkbox" 
              id="aktif"
              class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
            />
            <label for="aktif" class="ml-2 block text-sm text-gray-900">
              Unit Aktif
            </label>
          </div>

          <div class="flex justify-end space-x-3 pt-4">
            <button type="button" @click="closeModal" class="btn-secondary">
              Batal
            </button>
            <button type="submit" :disabled="saving" class="btn-primary">
              {{ saving ? 'Menyimpan...' : 'Simpan' }}
            </button>
          </div>
        </form>
      </div>
    </div>

  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useMasterPelabuhanStore } from '@/stores/master-pelabuhan'
import { supabase } from '@/services/api/supabase'

const masterPelabuhanStore = useMasterPelabuhanStore()
const searchQuery = ref('')
const showModal = ref(false)
const editingUnit = ref(null)
const saving = ref(false)

const formData = ref({
  wilayah_id: '',
  area_id: '',
  unit_id: '',
  aktif: true
})

const availableWilayah = ref([])
const allAreas = ref([])
const allUnits = ref([])

// Filtered areas based on selected wilayah
const availableAreas = computed(() => {
  if (!formData.value.wilayah_id) return allAreas.value
  return allAreas.value.filter(area => area.wilayah_id === formData.value.wilayah_id)
})

// Filtered units based on selected area
const availableUnits = computed(() => {
  if (!formData.value.area_id) return allUnits.value
  return allUnits.value.filter(unit => unit.area_id === formData.value.area_id)
})

// Watch wilayah change to reset area and unit
watch(() => formData.value.wilayah_id, (newVal, oldVal) => {
  if (newVal !== oldVal && !editingUnit.value) {
    formData.value.area_id = ''
    formData.value.unit_id = ''
  }
})

// Watch area change to reset unit
watch(() => formData.value.area_id, (newVal, oldVal) => {
  if (newVal !== oldVal && !editingUnit.value) {
    formData.value.unit_id = ''
  }
})

const filteredUnits = computed(() => {
  if (!searchQuery.value) return masterPelabuhanStore.masterPelabuhan
  
  const query = searchQuery.value.toLowerCase()
  return masterPelabuhanStore.masterPelabuhan.filter(mp => 
    mp.unit?.nama.toLowerCase().includes(query) ||
    mp.unit?.kode.toLowerCase().includes(query) ||
    mp.wilayah?.nama.toLowerCase().includes(query) ||
    mp.area?.nama.toLowerCase().includes(query)
  )
})

async function loadData() {
  await masterPelabuhanStore.fetchMasterPelabuhan()
  await loadMasterData()
}

async function loadMasterData() {
  try {
    // Load wilayah
    const { data: wilayahData, error: wilayahError } = await supabase
      .from('wilayah')
      .select('*')
      .eq('aktif', true)
      .order('nama')
    
    if (wilayahError) throw wilayahError
    availableWilayah.value = wilayahData || []
    console.log('✅ Loaded wilayah:', wilayahData?.length)

    // Load all areas
    const { data: areasData, error: areasError } = await supabase
      .from('areas')
      .select('*')
      .eq('aktif', true)
      .order('nama')
    
    if (areasError) throw areasError
    allAreas.value = areasData || []
    console.log('✅ Loaded areas:', areasData?.length)

    // Load all units
    const { data: unitsData, error: unitsError } = await supabase
      .from('units')
      .select('*')
      .eq('aktif', true)
      .order('nama')
    
    if (unitsError) throw unitsError
    allUnits.value = unitsData || []
    console.log('✅ Loaded units:', unitsData?.length)
  } catch (error) {
    console.error('❌ Error loading master data:', error)
    alert('Gagal memuat data master: ' + error.message)
  }
}

function openAddUnitModal() {
  editingUnit.value = null
  formData.value = {
    wilayah_id: '',
    area_id: '',
    unit_id: '',
    aktif: true
  }
  console.log('➕ Opening add modal')
  console.log('Available Wilayah:', availableWilayah.value.length)
  console.log('All Areas:', allAreas.value.length)
  console.log('All Units:', allUnits.value.length)
  showModal.value = true
}

function openEditUnitModal(unit: any) {
  editingUnit.value = unit
  formData.value = {
    wilayah_id: unit.wilayah_id || '',
    area_id: unit.area_id || '',
    unit_id: unit.unit_id || '',
    aktif: unit.aktif ?? true
  }
  console.log('📝 Editing unit:', unit.unit?.nama, 'FormData:', formData.value)
  showModal.value = true
}

function closeModal() {
  showModal.value = false
  editingUnit.value = null
}

async function saveUnit() {
  saving.value = true
  try {
    console.log('💾 Saving unit with data:', formData.value)
    
    const dataToSave = {
      wilayah_id: formData.value.wilayah_id,
      area_id: formData.value.area_id,
      unit_id: formData.value.unit_id,
      aktif: formData.value.aktif,
      updated_at: new Date().toISOString()
    }

    if (editingUnit.value) {
      // Update existing unit
      console.log('📝 Updating unit ID:', editingUnit.value.id)
      const { data, error } = await supabase
        .from('master_pelabuhan')
        .update(dataToSave)
        .eq('id', editingUnit.value.id)
        .select()

      if (error) {
        console.error('❌ Update error:', error)
        throw error
      }
      console.log('✅ Updated successfully:', data)
      alert('Unit berhasil diupdate!')
    } else {
      // Create new unit
      console.log('➕ Creating new unit')
      const { data, error } = await supabase
        .from('master_pelabuhan')
        .insert({
          ...dataToSave,
          created_at: new Date().toISOString()
        })
        .select()

      if (error) {
        console.error('❌ Insert error:', error)
        throw error
      }
      console.log('✅ Created successfully:', data)
      alert('Unit berhasil ditambahkan!')
    }

    closeModal()
    await loadData()
  } catch (error) {
    console.error('❌ Error saving unit:', error)
    alert('Gagal menyimpan unit: ' + (error.message || error))
  } finally {
    saving.value = false
  }
}

async function confirmDelete(unit: any) {
  const unitName = unit.unit?.nama || 'unit ini'
  if (!confirm(`Apakah Anda yakin ingin menghapus ${unitName}?`)) {
    return
  }

  try {
    console.log('🗑️ Deleting unit ID:', unit.id)
    const { error } = await supabase
      .from('master_pelabuhan')
      .delete()
      .eq('id', unit.id)

    if (error) {
      console.error('❌ Delete error:', error)
      throw error
    }
    
    console.log('✅ Deleted successfully')
    alert('Unit berhasil dihapus!')
    await loadData()
  } catch (error) {
    console.error('❌ Error deleting unit:', error)
    alert('Gagal menghapus unit: ' + (error.message || error))
  }
}

onMounted(() => {
  loadData()
})
</script>
