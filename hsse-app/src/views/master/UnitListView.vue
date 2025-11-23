<template>
  <div class="space-y-6">
    <!-- Page Header -->
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-3xl font-bold text-gray-900">Master Unit</h1>
        <p class="mt-2 text-gray-600">Kelola data unit berdasarkan wilayah dan area</p>
      </div>
      <button 
        class="btn-primary flex items-center space-x-2 opacity-50 cursor-not-allowed"
        disabled
      >
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
        <span>Tambah Unit (Coming Soon)</span>
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
                    class="text-gray-400 cursor-not-allowed opacity-50"
                    disabled
                    title="Edit disabled - Read-only view"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                    </svg>
                  </button>
                  <button
                    class="text-gray-400 cursor-not-allowed opacity-50"
                    disabled
                    title="Delete disabled - Read-only view"
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

  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useMasterPelabuhanStore } from '@/stores/master-pelabuhan'

const masterPelabuhanStore = useMasterPelabuhanStore()
const searchQuery = ref('')

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
}

onMounted(() => {
  loadData()
})
</script>
