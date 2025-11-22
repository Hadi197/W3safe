<template>
  <DefaultLayout>
    <div class="container mx-auto px-4 py-8">
      <!-- Header -->
      <div class="flex justify-between items-center mb-6">
        <div>
          <h1 class="text-3xl font-bold text-gray-800">Safety Forum</h1>
          <p class="text-gray-600 mt-1">Manajemen Forum Keselamatan Kerja & Notulensi</p>
        </div>
        <button
          @click="openFormModal()"
          class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg shadow-md flex items-center gap-2 transition-all"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
          </svg>
          Tambah Forum Baru
        </button>
      </div>

      <!-- Filters -->
      <div class="bg-white rounded-lg shadow-md p-6 mb-6">
        <div class="grid grid-cols-1 md:grid-cols-5 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Cari Agenda/Nomor</label>
            <input
              v-model="filters.search"
              type="text"
              placeholder="Cari..."
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Unit</label>
            <select
              v-model="filters.unit_id"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
            >
              <option value="">Semua Unit</option>
              <option v-for="unit in units" :key="unit.id" :value="unit.id">{{ unit.nama_unit }}</option>
            </select>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Jenis Forum</label>
            <select
              v-model="filters.jenis"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
            >
              <option value="">Semua Jenis</option>
              <option value="rutin">Rutin</option>
              <option value="bulanan">Bulanan</option>
              <option value="mingguan">Mingguan</option>
              <option value="tahunan">Tahunan</option>
              <option value="insidental">Insidental</option>
              <option value="darurat">Darurat</option>
            </select>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Status</label>
            <select
              v-model="filters.status"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
            >
              <option value="">Semua Status</option>
              <option value="draft">Draft</option>
              <option value="scheduled">Terjadwal</option>
              <option value="in_progress">Sedang Berlangsung</option>
              <option value="completed">Selesai</option>
              <option value="cancelled">Dibatalkan</option>
            </select>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Bulan/Tahun</label>
            <input
              v-model="filters.month"
              type="month"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
            />
          </div>
        </div>
      </div>

      <!-- Table -->
      <div class="bg-white rounded-lg shadow-md overflow-hidden">
        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Nomor & Tanggal
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Agenda Utama
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Unit/Lokasi
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Jenis
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Peserta
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Action Items
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Status
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Aksi
                </th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <tr v-for="forum in filteredForums" :key="forum.id" class="hover:bg-gray-50">
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm font-medium text-gray-900">{{ forum.nomor_forum }}</div>
                  <div class="text-sm text-gray-500">{{ formatDate(forum.tanggal_forum) }}</div>
                  <div class="text-xs text-gray-400">{{ forum.waktu_mulai }} - {{ forum.waktu_selesai || '-' }}</div>
                </td>
                <td class="px-6 py-4">
                  <div class="text-sm text-gray-900">{{ forum.agenda_utama }}</div>
                  <div class="text-xs text-gray-500 mt-1">{{ forum.periode || '-' }}</div>
                  <div class="text-xs text-gray-500">Kategori: {{ forum.kategori_forum || '-' }}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm text-gray-900">{{ forum.unit?.nama_unit || '-' }}</div>
                  <div class="text-xs text-gray-500">{{ forum.lokasi }}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <span :class="getJenisForumBadgeClass(forum.jenis_forum)">
                    {{ forum.jenis_forum }}
                  </span>
                  <div v-if="forum.tingkat_urgensi !== 'normal'" class="mt-1">
                    <span :class="getUrgensiClass(forum.tingkat_urgensi)">
                      {{ forum.tingkat_urgensi }}
                    </span>
                  </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                  <div>Hadir: {{ forum.jumlah_peserta || 0 }}</div>
                  <div class="text-xs text-gray-500">
                    Ketua: {{ forum.ketua?.nama_lengkap || '-' }}
                  </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm">
                    <div class="font-medium">Total: {{ forum.jumlah_action_item || 0 }}</div>
                    <div class="text-xs text-green-600">Selesai: {{ forum.action_selesai || 0 }}</div>
                    <div class="text-xs text-yellow-600">Progress: {{ forum.action_progress || 0 }}</div>
                    <div class="text-xs text-gray-500">Belum: {{ forum.action_belum_mulai || 0 }}</div>
                  </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <span :class="getStatusBadgeClass(forum.status)">
                    {{ getStatusLabel(forum.status) }}
                  </span>
                  <div v-if="forum.status_notulen" class="mt-1">
                    <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-gray-100 text-gray-800">
                      Notulen: {{ getNotulenLabel(forum.status_notulen) }}
                    </span>
                  </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                  <div class="flex gap-2">
                    <button
                      @click="openDetailModal(forum)"
                      class="text-blue-600 hover:text-blue-900"
                      title="Detail"
                    >
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                      </svg>
                    </button>
                    <button
                      @click="openFormModal(forum)"
                      class="text-green-600 hover:text-green-900"
                      title="Edit"
                    >
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                      </svg>
                    </button>
                    <button
                      @click="confirmDelete(forum)"
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
        
        <div v-if="filteredForums.length === 0" class="text-center py-12">
          <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
          <h3 class="mt-2 text-sm font-medium text-gray-900">Belum ada data forum</h3>
          <p class="mt-1 text-sm text-gray-500">Mulai dengan menambahkan forum baru.</p>
        </div>
      </div>

      <!-- Form Modal (akan dibuat di part 2) -->
      <!-- Detail Modal (akan dibuat di part 3) -->
    </div>
  </DefaultLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import DefaultLayout from '@/components/layout/DefaultLayout.vue'
import { safetyForumService, type SafetyForumDTO } from '@/services/api/safety-forum.service'
import { unitsService } from '@/services/api/units.service'

const forums = ref<any[]>([])
const units = ref<any[]>([])
const loading = ref(false)

const filters = ref({
  search: '',
  unit_id: '',
  jenis: '',
  status: '',
  month: ''
})

// Computed: filtered forums
const filteredForums = computed(() => {
  let result = forums.value

  if (filters.value.search) {
    const search = filters.value.search.toLowerCase()
    result = result.filter(f => 
      f.nomor_forum?.toLowerCase().includes(search) ||
      f.agenda_utama?.toLowerCase().includes(search) ||
      f.lokasi?.toLowerCase().includes(search)
    )
  }

  if (filters.value.unit_id) {
    result = result.filter(f => f.unit_id === filters.value.unit_id)
  }

  if (filters.value.jenis) {
    result = result.filter(f => f.jenis_forum === filters.value.jenis)
  }

  if (filters.value.status) {
    result = result.filter(f => f.status === filters.value.status)
  }

  if (filters.value.month) {
    const [year, month] = filters.value.month.split('-')
    if (year && month) {
      result = result.filter(f => {
        const forumDate = new Date(f.tanggal_forum)
        return forumDate.getFullYear() === parseInt(year) && 
               (forumDate.getMonth() + 1) === parseInt(month)
      })
    }
  }

  return result
})

// Load data
const loadForums = async () => {
  try {
    loading.value = true
    const data = await safetyForumService.getAll()
    forums.value = data || []
  } catch (error) {
    console.error('Error loading forums:', error)
    alert('Gagal memuat data forum')
  } finally {
    loading.value = false
  }
}

const loadUnits = async () => {
  try {
    const data = await unitsService.getAll()
    units.value = data || []
  } catch (error) {
    console.error('Error loading units:', error)
  }
}

// Format helpers
const formatDate = (dateStr: string) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return date.toLocaleDateString('id-ID', { 
    weekday: 'short',
    year: 'numeric', 
    month: 'short', 
    day: 'numeric' 
  })
}

const getStatusLabel = (status: string) => {
  const labels: Record<string, string> = {
    draft: 'Draft',
    scheduled: 'Terjadwal',
    in_progress: 'Berlangsung',
    completed: 'Selesai',
    cancelled: 'Dibatalkan',
    rescheduled: 'Dijadwalkan Ulang'
  }
  return labels[status] || status
}

const getNotulenLabel = (status: string) => {
  const labels: Record<string, string> = {
    belum_dibuat: 'Belum',
    draft: 'Draft',
    review: 'Review',
    approved: 'Approved',
    rejected: 'Ditolak'
  }
  return labels[status] || status
}

const getStatusBadgeClass = (status: string) => {
  const classes: Record<string, string> = {
    draft: 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800',
    scheduled: 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800',
    in_progress: 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800',
    completed: 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800',
    cancelled: 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800',
    rescheduled: 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-purple-100 text-purple-800'
  }
  return classes[status] || classes.draft
}

const getJenisForumBadgeClass = (jenis: string) => {
  const classes: Record<string, string> = {
    rutin: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-800',
    bulanan: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-green-100 text-green-800',
    mingguan: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-purple-100 text-purple-800',
    tahunan: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-indigo-100 text-indigo-800',
    insidental: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-yellow-100 text-yellow-800',
    darurat: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-red-100 text-red-800'
  }
  return classes[jenis] || classes.rutin
}

const getUrgensiClass = (urgensi: string) => {
  const classes: Record<string, string> = {
    rendah: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-gray-100 text-gray-700',
    normal: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-700',
    tinggi: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-orange-100 text-orange-700',
    kritis: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-red-100 text-red-700'
  }
  return classes[urgensi] || classes.normal
}

// Modal handlers
const openFormModal = (forum?: any) => {
  // TODO: Implement form modal
  console.log('Open form modal', forum)
}

const openDetailModal = (forum: any) => {
  // TODO: Implement detail modal
  console.log('Open detail modal', forum)
}

const confirmDelete = async (forum: any) => {
  if (!confirm(`Yakin ingin menghapus forum ${forum.nomor_forum}?`)) return
  
  try {
    await safetyForumService.delete(forum.id)
    alert('Forum berhasil dihapus')
    await loadForums()
  } catch (error) {
    console.error('Error deleting forum:', error)
    alert('Gagal menghapus forum')
  }
}

// Lifecycle
onMounted(() => {
  loadForums()
  loadUnits()
})
</script>
