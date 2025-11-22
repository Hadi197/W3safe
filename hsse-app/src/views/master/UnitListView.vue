<template>
  <div class="space-y-6">
    <!-- Page Header -->
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-3xl font-bold text-gray-900">Master Unit</h1>
        <p class="mt-2 text-gray-600">Kelola data unit berdasarkan wilayah dan area</p>
      </div>
      <button 
        @click="showModal = true; resetForm()" 
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
            <p class="text-3xl font-bold mt-1">{{ unitsStore.units.length }}</p>
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
            <p class="text-3xl font-bold mt-1">{{ unitsStore.activeUnits.length }}</p>
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
            <p class="text-3xl font-bold mt-1">{{ unitsStore.wilayahList.length }}</p>
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

      <div v-if="unitsStore.loading" class="text-center py-12">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-4 border-primary-600 border-t-transparent"></div>
        <p class="mt-4 text-gray-600">Loading data...</p>
      </div>

      <div v-else-if="unitsStore.error" class="text-center py-12">
        <p class="text-red-600">{{ unitsStore.error }}</p>
        <button @click="loadData" class="btn-primary mt-4">Coba Lagi</button>
      </div>

      <div v-else-if="filteredUnits.length === 0" class="text-center py-12">
        <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
        </svg>
        <p class="mt-4 text-gray-600">Belum ada data unit</p>
        <button @click="showModal = true; resetForm()" class="btn-primary mt-4">Tambah Unit Pertama</button>
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
                <div class="text-sm font-medium text-gray-900">
                  {{ unit.area?.nama || (unit.tipe === 'area' ? unit.nama : '-') }}
                </div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm font-medium text-gray-900">
                  {{ unit.tipe === 'unit' ? unit.nama : '-' }}
                </div>
                <div class="text-sm text-gray-500">{{ unit.tipe === 'unit' ? unit.kode : '' }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span :class="unit.aktif ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'" 
                      class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full">
                  {{ unit.aktif ? 'Aktif' : 'Nonaktif' }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                <button @click="editUnit(unit)" class="text-primary-600 hover:text-primary-900 mr-3">
                  Edit
                </button>
                <button @click="confirmDelete(unit)" class="text-red-600 hover:text-red-900">
                  Hapus
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Modal Form -->
    <div v-if="showModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50" @click.self="showModal = false">
      <div class="relative top-20 mx-auto p-8 border w-full max-w-2xl shadow-2xl rounded-2xl bg-white">
        <div class="flex items-center justify-between mb-6">
          <h3 class="text-2xl font-bold text-gray-900">
            {{ editMode ? 'Edit Unit' : 'Tambah Unit Baru' }}
          </h3>
          <button @click="showModal = false" class="text-gray-400 hover:text-gray-600">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <form @submit.prevent="handleSubmit" class="space-y-6">
          <div>
            <label class="label">Wilayah <span class="text-red-500">*</span></label>
            <BaseSelect 
              v-model="form.wilayah_id"
              :options="unitsStore.wilayahList"
              value-key="id"
              label-key="nama"
              placeholder="Pilih Wilayah"
              :error="errors.wilayah_id"
              required
            />
            <p v-if="errors.wilayah_id" class="mt-1 text-sm text-red-600">{{ errors.wilayah_id }}</p>
          </div>

          <div>
            <label class="label">Kode <span class="text-red-500">*</span></label>
            <BaseInput 
              v-model="form.kode"
              placeholder="Contoh: PKG-01"
              :error="errors.kode"
              required
            />
            <p v-if="errors.kode" class="mt-1 text-sm text-red-600">{{ errors.kode }}</p>
          </div>

          <div>
            <label class="label">Nama Palabuhan <span class="text-red-500">*</span></label>
            <BaseInput 
              v-model="form.nama"
              placeholder="Contoh: Pelabuhan Tanjung Priok"
              :error="errors.nama"
              required
            />
            <p v-if="errors.nama" class="mt-1 text-sm text-red-600">{{ errors.nama }}</p>
          </div>

          <div>
            <label class="label">Tipe</label>
            <BaseSelect
              v-model="form.tipe"
              :options="[
                { value: 'unit', label: 'Unit' },
                { value: 'departemen', label: 'Departemen' },
                { value: 'divisi', label: 'Divisi' }
              ]"
            />
          </div>

          <div class="flex items-center">
            <input 
              v-model="form.aktif" 
              type="checkbox" 
              id="aktif"
              class="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
            />
            <label for="aktif" class="ml-2 block text-sm text-gray-900">
              Aktif
            </label>
          </div>

          <div class="flex items-center justify-end space-x-3 pt-4 border-t">
            <button type="button" @click="showModal = false" class="btn-secondary">
              Batal
            </button>
            <button type="submit" :disabled="submitting" class="btn-primary disabled:opacity-50">
              <span v-if="submitting">Menyimpan...</span>
              <span v-else>{{ editMode ? 'Update' : 'Simpan' }}</span>
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Delete Modal -->
    <div v-if="showDeleteModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50" @click.self="showDeleteModal = false">
      <div class="relative top-40 mx-auto p-8 border w-full max-w-md shadow-2xl rounded-2xl bg-white">
        <div class="text-center">
          <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100 mb-4">
            <svg class="h-6 w-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
          </div>
          <h3 class="text-lg font-bold text-gray-900 mb-2">Hapus Unit</h3>
          <p class="text-gray-600 mb-6">
            Apakah Anda yakin ingin menghapus unit <strong>{{ unitToDelete?.nama }}</strong>?
          </p>
          <div class="flex space-x-3">
            <button @click="showDeleteModal = false" class="flex-1 btn-secondary">
              Batal
            </button>
            <button @click="handleDelete" :disabled="deleting" class="flex-1 btn-danger disabled:opacity-50">
              <span v-if="deleting">Menghapus...</span>
              <span v-else>Hapus</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useUnitsStore } from '@/stores/units'
import type { Unit } from '@/services/api/units.service'
import BaseInput from '@/components/base/BaseInput.vue'
import BaseSelect from '@/components/base/BaseSelect.vue'

const unitsStore = useUnitsStore()

const showModal = ref(false)
const showDeleteModal = ref(false)
const editMode = ref(false)
const submitting = ref(false)
const deleting = ref(false)
const searchQuery = ref('')
const unitToDelete = ref<Unit | null>(null)

const form = ref({
  wilayah_id: '',
  kode: '',
  nama: '',
  tipe: 'unit',
  aktif: true
})

const errors = ref<Record<string, string>>({})

const filteredUnits = computed(() => {
  if (!searchQuery.value) return unitsStore.units
  
  const query = searchQuery.value.toLowerCase()
  return unitsStore.units.filter(unit => 
    unit.nama.toLowerCase().includes(query) ||
    unit.kode.toLowerCase().includes(query) ||
    unit.wilayah?.nama.toLowerCase().includes(query)
  )
})

function resetForm() {
  form.value = {
    wilayah_id: '',
    kode: '',
    nama: '',
    tipe: 'unit',
    aktif: true
  }
  errors.value = {}
  editMode.value = false
}

function validateForm(): boolean {
  errors.value = {}
  
  if (!form.value.wilayah_id) errors.value.wilayah_id = 'Wilayah harus dipilih'
  if (!form.value.kode.trim()) errors.value.kode = 'Kode harus diisi'
  if (!form.value.nama.trim()) errors.value.nama = 'Nama harus diisi'
  
  return Object.keys(errors.value).length === 0
}

async function handleSubmit() {
  if (!validateForm()) return
  
  submitting.value = true
  try {
    if (editMode.value && unitToDelete.value) {
      await unitsStore.updateUnit(unitToDelete.value.id, form.value)
    } else {
      await unitsStore.createUnit(form.value)
    }
    showModal.value = false
    resetForm()
  } catch (error: any) {
    alert('Error: ' + (error.message || 'Gagal menyimpan data'))
  } finally {
    submitting.value = false
  }
}

function editUnit(unit: Unit) {
  form.value = {
    wilayah_id: unit.wilayah_id || '',
    kode: unit.kode,
    nama: unit.nama,
    tipe: unit.tipe || 'unit',
    aktif: unit.aktif
  }
  unitToDelete.value = unit
  editMode.value = true
  showModal.value = true
}

function confirmDelete(unit: Unit) {
  unitToDelete.value = unit
  showDeleteModal.value = true
}

async function handleDelete() {
  if (!unitToDelete.value) return
  
  deleting.value = true
  try {
    await unitsStore.deleteUnit(unitToDelete.value.id)
    showDeleteModal.value = false
    unitToDelete.value = null
  } catch (error: any) {
    alert('Error: ' + (error.message || 'Gagal menghapus data'))
  } finally {
    deleting.value = false
  }
}

async function loadData() {
  await Promise.all([
    unitsStore.fetchUnits(),
    unitsStore.fetchWilayahList()
  ])
}

onMounted(() => {
  loadData()
})
</script>
