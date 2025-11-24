<template>
  <div class="container mx-auto px-4 py-8">
    <!-- Header -->
    <div class="mb-6">
      <h1 class="text-3xl font-bold text-gray-800 flex items-center gap-3">
        <svg class="w-8 h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
        </svg>
        Monitoring Aktivitas HSSE
      </h1>
      <p class="text-gray-600 mt-2">Dashboard aktivitas input data dari semua modul HSSE</p>
    </div>

    <!-- Filters -->
    <div class="bg-white rounded-lg shadow-md p-6 mb-6">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Tanggal Mulai</label>
          <input
            v-model="filters.startDate"
            type="date"
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
          />
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Tanggal Akhir</label>
          <input
            v-model="filters.endDate"
            type="date"
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Modul</label>
          <select
            v-model="filters.module"
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
          >
            <option value="">Semua Modul</option>
            <option value="safety_patrol">Safety Patrol</option>
            <option value="safety_drill">Safety Drill</option>
            <option value="safety_briefing">Safety Briefing</option>
            <option value="safety_induction">Safety Induction</option>
            <option value="safety_forum">Safety Forum</option>
            <option value="silent_inspection">Silent Inspection</option>
            <option value="management_walkthrough">Management Walkthrough</option>
          </select>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Unit</label>
          <select
            v-model="filters.unit"
            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
          >
            <option value="">Semua Unit</option>
            <option v-for="unit in units" :key="unit.id" :value="unit.id">{{ unit.nama }}</option>
          </select>
        </div>
      </div>
      
      <div class="flex gap-3 mt-4">
        <button
          @click="loadActivities"
          class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 flex items-center gap-2"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
          </svg>
          Filter
        </button>
        <button
          @click="resetFilters"
          class="px-6 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300"
        >
          Reset
        </button>
        <button
          @click="exportToExcel"
          class="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 flex items-center gap-2 ml-auto"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
          Export Excel
        </button>
      </div>
    </div>

    <!-- Statistics Cards -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-6">
      <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-lg shadow-lg p-6 text-white">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-blue-100 text-sm font-medium">Total Aktivitas</p>
            <p class="text-3xl font-bold mt-2">{{ stats.total }}</p>
          </div>
          <div class="bg-blue-400 bg-opacity-30 rounded-full p-3">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
          </div>
        </div>
      </div>

      <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-lg shadow-lg p-6 text-white">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-green-100 text-sm font-medium">Hari Ini</p>
            <p class="text-3xl font-bold mt-2">{{ stats.today }}</p>
          </div>
          <div class="bg-green-400 bg-opacity-30 rounded-full p-3">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
            </svg>
          </div>
        </div>
      </div>

      <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-lg shadow-lg p-6 text-white">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-purple-100 text-sm font-medium">Minggu Ini</p>
            <p class="text-3xl font-bold mt-2">{{ stats.thisWeek }}</p>
          </div>
          <div class="bg-purple-400 bg-opacity-30 rounded-full p-3">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
            </svg>
          </div>
        </div>
      </div>

      <div class="bg-gradient-to-br from-orange-500 to-orange-600 rounded-lg shadow-lg p-6 text-white">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-orange-100 text-sm font-medium">Bulan Ini</p>
            <p class="text-3xl font-bold mt-2">{{ stats.thisMonth }}</p>
          </div>
          <div class="bg-orange-400 bg-opacity-30 rounded-full p-3">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
            </svg>
          </div>
        </div>
      </div>
    </div>

    <!-- Activity by Module Chart -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
      <div class="bg-white rounded-lg shadow-md p-6">
        <h3 class="text-lg font-semibold text-gray-800 mb-4">Aktivitas per Modul</h3>
        <div class="space-y-3">
          <div v-for="module in moduleStats" :key="module.name" class="flex items-center">
            <div class="w-32 text-sm text-gray-600">{{ module.label }}</div>
            <div class="flex-1 mx-3">
              <div class="bg-gray-200 rounded-full h-6 overflow-hidden">
                <div
                  class="h-full rounded-full flex items-center justify-end pr-2 text-xs text-white font-medium"
                  :class="module.color"
                  :style="{ width: `${(module.count / stats.total * 100) || 0}%` }"
                >
                  <span v-if="module.count > 0">{{ module.count }}</span>
                </div>
              </div>
            </div>
            <div class="w-16 text-right text-sm font-semibold text-gray-700">
              {{ ((module.count / stats.total * 100) || 0).toFixed(1) }}%
            </div>
          </div>
        </div>
      </div>

      <div class="bg-white rounded-lg shadow-md p-6">
        <h3 class="text-lg font-semibold text-gray-800 mb-4">Top 5 User Aktif</h3>
        <div class="space-y-3">
          <div v-for="(user, idx) in topUsers" :key="user.id" class="flex items-center gap-3">
            <div class="flex-shrink-0 w-8 h-8 rounded-full bg-gradient-to-br from-blue-500 to-purple-600 flex items-center justify-center text-white font-bold text-sm">
              {{ idx + 1 }}
            </div>
            <div class="flex-1">
              <p class="text-sm font-medium text-gray-800">{{ user.name }}</p>
              <p class="text-xs text-gray-500">{{ user.unit }}</p>
            </div>
            <div class="text-right">
              <p class="text-lg font-bold text-blue-600">{{ user.count }}</p>
              <p class="text-xs text-gray-500">aktivitas</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Activities Table -->
    <div class="bg-white rounded-lg shadow-md overflow-hidden">
      <div class="px-6 py-4 border-b border-gray-200 flex items-center justify-between">
        <h3 class="text-lg font-semibold text-gray-800">Riwayat Aktivitas</h3>
        <div class="flex items-center gap-3">
          <span class="text-sm text-gray-600">{{ filteredActivities.length }} aktivitas</span>
        </div>
      </div>
      
      <div v-if="loading" class="p-12 text-center">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        <p class="text-gray-600 mt-4">Memuat data...</p>
      </div>

      <div v-else-if="filteredActivities.length === 0" class="p-12 text-center">
        <svg class="w-16 h-16 mx-auto text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
        </svg>
        <p class="text-gray-600 mt-4">Tidak ada aktivitas ditemukan</p>
      </div>

      <div v-else class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Tanggal & Waktu
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Modul
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Tipe Aktivitas
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                User
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Unit
              </th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Deskripsi
              </th>
              <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                Aksi
              </th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-for="activity in paginatedActivities" :key="activity.id" class="hover:bg-gray-50">
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                <div>{{ formatDate(activity.created_at) }}</div>
                <div class="text-xs text-gray-500">{{ formatTime(activity.created_at) }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full" :class="getModuleBadgeClass(activity.module)">
                  {{ getModuleLabel(activity.module) }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span class="px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full" :class="getActivityTypeBadgeClass(activity.activity_type)">
                  {{ getActivityTypeLabel(activity.activity_type) }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                {{ activity.user_name }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                {{ activity.unit_name }}
              </td>
              <td class="px-6 py-4 text-sm text-gray-600 max-w-xs truncate">
                {{ activity.description }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-center text-sm font-medium">
                <button
                  @click="viewDetail(activity)"
                  class="text-blue-600 hover:text-blue-900"
                >
                  Detail
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Pagination -->
      <div v-if="filteredActivities.length > 0" class="px-6 py-4 border-t border-gray-200 flex items-center justify-between">
        <div class="text-sm text-gray-700">
          Menampilkan {{ ((currentPage - 1) * pageSize) + 1 }} - {{ Math.min(currentPage * pageSize, filteredActivities.length) }} dari {{ filteredActivities.length }} aktivitas
        </div>
        <div class="flex gap-2">
          <button
            @click="currentPage--"
            :disabled="currentPage === 1"
            class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Previous
          </button>
          <button
            v-for="page in totalPages"
            :key="page"
            @click="currentPage = page"
            class="px-4 py-2 border rounded-lg"
            :class="currentPage === page ? 'bg-blue-600 text-white border-blue-600' : 'border-gray-300 hover:bg-gray-50'"
          >
            {{ page }}
          </button>
          <button
            @click="currentPage++"
            :disabled="currentPage === totalPages"
            class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Next
          </button>
        </div>
      </div>
    </div>

    <!-- Detail Modal -->
    <div v-if="showDetailModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div class="bg-white rounded-lg shadow-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
          <h3 class="text-xl font-semibold text-gray-800">Detail Aktivitas</h3>
          <button @click="showDetailModal = false" class="text-gray-400 hover:text-gray-600">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
        
        <div v-if="selectedActivity" class="p-6 space-y-4">
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="text-sm font-medium text-gray-500">Tanggal & Waktu</label>
              <p class="text-gray-900 mt-1">{{ formatDateTime(selectedActivity.created_at) }}</p>
            </div>
            <div>
              <label class="text-sm font-medium text-gray-500">Modul</label>
              <p class="text-gray-900 mt-1">{{ getModuleLabel(selectedActivity.module) }}</p>
            </div>
            <div>
              <label class="text-sm font-medium text-gray-500">Tipe Aktivitas</label>
              <p class="text-gray-900 mt-1">{{ getActivityTypeLabel(selectedActivity.activity_type) }}</p>
            </div>
            <div>
              <label class="text-sm font-medium text-gray-500">User</label>
              <p class="text-gray-900 mt-1">{{ selectedActivity.user_name }}</p>
            </div>
            <div>
              <label class="text-sm font-medium text-gray-500">Unit</label>
              <p class="text-gray-900 mt-1">{{ selectedActivity.unit_name }}</p>
            </div>
          </div>
          
          <div>
            <label class="text-sm font-medium text-gray-500">Deskripsi</label>
            <p class="text-gray-900 mt-1">{{ selectedActivity.description }}</p>
          </div>

          <div v-if="selectedActivity.metadata" class="bg-gray-50 rounded-lg p-4">
            <label class="text-sm font-medium text-gray-500 mb-2 block">Metadata</label>
            <pre class="text-xs text-gray-700 overflow-x-auto">{{ JSON.stringify(selectedActivity.metadata, null, 2) }}</pre>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { format, startOfDay, endOfDay, startOfWeek, endOfWeek, startOfMonth, endOfMonth, isToday, isThisWeek, isThisMonth } from 'date-fns'
import { id as localeId } from 'date-fns/locale'
import { supabase } from '@/services/api/supabase'

interface Activity {
  id: string
  created_at: string
  module: string
  activity_type: string
  user_id: string
  user_name: string
  unit_id: string
  unit_name: string
  description: string
  metadata?: any
}

const activities = ref<Activity[]>([])
const units = ref<any[]>([])
const loading = ref(false)
const showDetailModal = ref(false)
const selectedActivity = ref<Activity | null>(null)

const filters = ref({
  startDate: '',
  endDate: '',
  module: '',
  unit: ''
})

const currentPage = ref(1)
const pageSize = 20

// Statistics
const stats = computed(() => {
  return {
    total: activities.value.length,
    today: activities.value.filter(a => isToday(new Date(a.created_at))).length,
    thisWeek: activities.value.filter(a => isThisWeek(new Date(a.created_at), { locale: localeId })).length,
    thisMonth: activities.value.filter(a => isThisMonth(new Date(a.created_at))).length
  }
})

// Module statistics
const moduleStats = computed(() => {
  const modules = [
    { name: 'safety_patrol', label: 'Safety Patrol', color: 'bg-blue-500' },
    { name: 'safety_drill', label: 'Safety Drill', color: 'bg-green-500' },
    { name: 'safety_briefing', label: 'Safety Briefing', color: 'bg-purple-500' },
    { name: 'safety_induction', label: 'Safety Induction', color: 'bg-yellow-500' },
    { name: 'safety_forum', label: 'Safety Forum', color: 'bg-red-500' },
    { name: 'silent_inspection', label: 'Silent Inspection', color: 'bg-indigo-500' },
    { name: 'management_walkthrough', label: 'Management Walkthrough', color: 'bg-pink-500' }
  ]

  return modules.map(module => ({
    ...module,
    count: activities.value.filter(a => a.module === module.name).length
  }))
})

// Top users
const topUsers = computed(() => {
  const userMap = new Map()
  
  activities.value.forEach(activity => {
    if (!userMap.has(activity.user_id)) {
      userMap.set(activity.user_id, {
        id: activity.user_id,
        name: activity.user_name,
        unit: activity.unit_name,
        count: 0
      })
    }
    userMap.get(activity.user_id).count++
  })

  return Array.from(userMap.values())
    .sort((a, b) => b.count - a.count)
    .slice(0, 5)
})

// Filtered activities
const filteredActivities = computed(() => {
  let result = activities.value

  if (filters.value.startDate) {
    const start = startOfDay(new Date(filters.value.startDate))
    result = result.filter(a => new Date(a.created_at) >= start)
  }

  if (filters.value.endDate) {
    const end = endOfDay(new Date(filters.value.endDate))
    result = result.filter(a => new Date(a.created_at) <= end)
  }

  if (filters.value.module) {
    result = result.filter(a => a.module === filters.value.module)
  }

  if (filters.value.unit) {
    result = result.filter(a => a.unit_id === filters.value.unit)
  }

  return result.sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())
})

// Pagination
const totalPages = computed(() => Math.ceil(filteredActivities.value.length / pageSize))

const paginatedActivities = computed(() => {
  const start = (currentPage.value - 1) * pageSize
  const end = start + pageSize
  return filteredActivities.value.slice(start, end)
})

// Methods
const loadActivities = async () => {
  loading.value = true
  try {
    const allActivities: Activity[] = []
    
    // Load from all HSSE tables
    const tables = [
      { name: 'safety_briefing', label: 'Safety Briefing', titleField: 'topik' },
      { name: 'silent_inspection', label: 'Silent Inspection', titleField: 'hasil_inspeksi' },
      { name: 'safety_patrol', label: 'Safety Patrol', titleField: 'lokasi_patrol' },
      { name: 'safety_forum', label: 'Safety Forum', titleField: 'topik' },
      { name: 'management_walkthrough', label: 'Management Walkthrough', titleField: 'area_inspeksi' },
      { name: 'safety_drill', label: 'Safety Drill', titleField: 'jenis_drill' },
      { name: 'safety_induction', label: 'Safety Induction', titleField: 'materi_induction' }
    ]

    for (const table of tables) {
      const { data, error } = await supabase
        .from(table.name)
        .select(`
          id,
          created_at,
          updated_at,
          tanggal,
          unit_id,
          created_by,
          ${table.titleField},
          unit:units!unit_id(id, nama, kode)
        `)
        .order('created_at', { ascending: false })
        .limit(100)

      if (!error && data) {
        data.forEach((record: any) => {
          // Create activity
          allActivities.push({
            id: record.id,
            created_at: record.created_at,
            module: table.name,
            activity_type: 'create',
            user_id: record.created_by || 'system',
            user_name: 'User',
            unit_id: record.unit_id || '',
            unit_name: record.unit?.nama || '-',
            description: record[table.titleField] || `${table.label} pada ${formatDate(record.tanggal)}`
          })
          
          // If updated, add update activity
          if (record.updated_at && record.updated_at !== record.created_at) {
            allActivities.push({
              id: `${record.id}-update`,
              created_at: record.updated_at,
              module: table.name,
              activity_type: 'update',
              user_id: record.created_by || 'system',
              user_name: 'User',
              unit_id: record.unit_id || '',
              unit_name: record.unit?.nama || '-',
              description: record[table.titleField] || `${table.label} diupdate`
            })
          }
        })
      }
    }

    // Sort by created_at desc
    activities.value = allActivities.sort((a, b) => 
      new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
    )
  } catch (error) {
    console.error('Error loading activities:', error)
  } finally {
    loading.value = false
  }
}

const loadUnits = async () => {
  try {
    const { data, error } = await supabase
      .from('units')
      .select('id, nama, kode')
      .eq('aktif', true)
      .order('nama')

    if (error) throw error
    units.value = data || []
  } catch (error) {
    console.error('Error loading units:', error)
  }
}

const resetFilters = () => {
  filters.value = {
    startDate: '',
    endDate: '',
    module: '',
    unit: ''
  }
  currentPage.value = 1
  loadActivities()
}

const viewDetail = (activity: Activity) => {
  selectedActivity.value = activity
  showDetailModal.value = true
}

const exportToExcel = () => {
  // TODO: Implement Excel export
  alert('Fitur export Excel akan segera tersedia')
}

// Helper functions
const formatDate = (dateString: string) => {
  return format(new Date(dateString), 'dd MMM yyyy', { locale: localeId })
}

const formatTime = (dateString: string) => {
  return format(new Date(dateString), 'HH:mm', { locale: localeId })
}

const formatDateTime = (dateString: string) => {
  return format(new Date(dateString), 'dd MMM yyyy HH:mm', { locale: localeId })
}

const getModuleLabel = (module: string) => {
  const labels: Record<string, string> = {
    safety_patrol: 'Safety Patrol',
    safety_drill: 'Safety Drill',
    safety_briefing: 'Safety Briefing',
    safety_induction: 'Safety Induction',
    safety_forum: 'Safety Forum',
    silent_inspection: 'Silent Inspection',
    management_walkthrough: 'Management Walkthrough'
  }
  return labels[module] || module
}

const getModuleBadgeClass = (module: string) => {
  const classes: Record<string, string> = {
    safety_patrol: 'bg-blue-100 text-blue-800',
    safety_drill: 'bg-green-100 text-green-800',
    safety_briefing: 'bg-purple-100 text-purple-800',
    safety_induction: 'bg-yellow-100 text-yellow-800',
    safety_forum: 'bg-red-100 text-red-800',
    silent_inspection: 'bg-indigo-100 text-indigo-800',
    management_walkthrough: 'bg-pink-100 text-pink-800'
  }
  return classes[module] || 'bg-gray-100 text-gray-800'
}

const getActivityTypeLabel = (type: string) => {
  const labels: Record<string, string> = {
    create: 'Buat',
    update: 'Update',
    delete: 'Hapus',
    approve: 'Approve',
    reject: 'Reject'
  }
  return labels[type] || type
}

const getActivityTypeBadgeClass = (type: string) => {
  const classes: Record<string, string> = {
    create: 'bg-green-100 text-green-800',
    update: 'bg-blue-100 text-blue-800',
    delete: 'bg-red-100 text-red-800',
    approve: 'bg-emerald-100 text-emerald-800',
    reject: 'bg-orange-100 text-orange-800'
  }
  return classes[type] || 'bg-gray-100 text-gray-800'
}

onMounted(() => {
  loadActivities()
  loadUnits()
})
</script>
