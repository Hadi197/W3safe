<template>
  <div class="space-y-6">
    <!-- Page Header with Welcome Message -->
    <div class="bg-gradient-to-r from-primary-600 to-primary-800 rounded-2xl shadow-xl p-8 text-white">
      <div class="flex items-center justify-between">
        <div>
          <h1 class="text-4xl font-bold mb-2">Selamat Datang di W3Safe! 👋</h1>
          <p class="text-primary-100 text-lg">{{ currentGreeting }}, mari pantau implementasi keselamatan kerja hari ini</p>
        </div>
        <div class="hidden lg:block">
          <div class="bg-white/10 backdrop-blur-sm rounded-xl p-4 text-center">
            <p class="text-sm text-primary-100">Tanggal</p>
            <p class="text-2xl font-bold">{{ currentDate }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Statistics Cards with Gradients -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
      <!-- Safety Briefing Card -->
      <div 
        @click="openMonthlyTable('safety_briefing', 'Safety Briefing')"
        class="group relative overflow-hidden bg-gradient-to-br from-blue-500 to-blue-700 rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 hover:-translate-y-2 cursor-pointer">
        <div class="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -mr-16 -mt-16"></div>
        <div class="relative p-6 text-white">
          <div class="flex items-center justify-between mb-4">
            <div class="bg-white/20 backdrop-blur-sm rounded-xl p-3">
              <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
            </div>
            <div class="text-right">
              <p class="text-3xl font-bold">{{ stats.safetyBriefing }}</p>
            </div>
          </div>
          <h3 class="text-lg font-semibold mb-1">Safety Briefing</h3>
          <p class="text-blue-100 text-sm">Bulan ini</p>
        </div>
      </div>

      <!-- Silent Inspection Card -->
      <div 
        @click="openMonthlyTable('silent_inspection', 'Silent Inspection')"
        class="group relative overflow-hidden bg-gradient-to-br from-purple-500 to-purple-700 rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 hover:-translate-y-2 cursor-pointer">
        <div class="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -mr-16 -mt-16"></div>
        <div class="relative p-6 text-white">
          <div class="flex items-center justify-between mb-4">
            <div class="bg-white/20 backdrop-blur-sm rounded-xl p-3">
              <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </div>
            <div class="text-right">
              <p class="text-3xl font-bold">{{ stats.silentInspection }}</p>
            </div>
          </div>
          <h3 class="text-lg font-semibold mb-1">Silent Inspection</h3>
          <p class="text-purple-100 text-sm">Kuartal ini</p>
        </div>
      </div>

      <!-- Safety Patrol Card -->
      <div 
        @click="openMonthlyTable('safety_patrol', 'Safety Patrol')"
        class="group relative overflow-hidden bg-gradient-to-br from-green-500 to-green-700 rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 hover:-translate-y-2 cursor-pointer">
        <div class="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -mr-16 -mt-16"></div>
        <div class="relative p-6 text-white">
          <div class="flex items-center justify-between mb-4">
            <div class="bg-white/20 backdrop-blur-sm rounded-xl p-3">
              <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
              </svg>
            </div>
            <div class="text-right">
              <p class="text-3xl font-bold">{{ stats.safetyPatrol }}</p>
            </div>
          </div>
          <h3 class="text-lg font-semibold mb-1">Safety Patrol</h3>
          <p class="text-green-100 text-sm">Bulan ini</p>
        </div>
      </div>

      <!-- Safety Forum Card -->
      <div 
        @click="openMonthlyTable('safety_forum', 'Safety Forum')"
        class="group relative overflow-hidden bg-gradient-to-br from-red-500 to-red-700 rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 hover:-translate-y-2 cursor-pointer">
        <div class="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -mr-16 -mt-16"></div>
        <div class="relative p-6 text-white">
          <div class="flex items-center justify-between mb-4">
            <div class="bg-white/20 backdrop-blur-sm rounded-xl p-3">
              <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8h2a2 2 0 012 2v6a2 2 0 01-2 2h-2v4l-4-4H9a1.994 1.994 0 01-1.414-.586m0 0L11 14h4a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2v4l.586-.586z" />
              </svg>
            </div>
            <div class="text-right">
              <p class="text-3xl font-bold">{{ stats.safetyForum }}</p>
            </div>
          </div>
          <h3 class="text-lg font-semibold mb-1">Safety Forum</h3>
          <p class="text-red-100 text-sm">Bulan ini</p>
        </div>
      </div>
    </div>

    <!-- Quick Actions -->
    <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-7 gap-4">
      <div 
        v-for="action in quickActions" 
        :key="action.name"
        @click="openMonthlyTable(action.module, action.name)"
        class="group bg-white rounded-xl shadow hover:shadow-lg transition-all duration-300 p-4 text-center hover:-translate-y-1 border-2 border-transparent hover:border-primary-500 cursor-pointer"
      >
        <div class="bg-gray-100 group-hover:bg-primary-50 rounded-lg p-3 mb-3 inline-block transition-colors duration-300">
          <div v-html="action.icon" class="w-6 h-6 text-gray-600 group-hover:text-primary-600 transition-colors duration-300"></div>
        </div>
        <p class="text-sm font-medium text-gray-700 group-hover:text-primary-700">{{ action.name }}</p>
      </div>
    </div>

    <!-- Charts Section -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- Trend Chart - Takes 2 columns -->
      <div class="lg:col-span-2 bg-white rounded-2xl shadow-lg p-6 hover:shadow-xl transition-shadow duration-300">
        <div class="flex items-center justify-between mb-6">
          <h3 class="text-xl font-bold text-gray-900">📈 Trend Aktivitas Keselamatan</h3>
          <select class="px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500 focus:border-transparent">
            <option>6 Bulan Terakhir</option>
            <option>3 Bulan Terakhir</option>
            <option>1 Tahun</option>
          </select>
        </div>
        <div class="h-80">
          <Line :data="trendChartData" :options="trendChartOptions" />
        </div>
      </div>

      <!-- Pie Chart - Takes 1 column -->
      <div class="bg-white rounded-2xl shadow-lg p-6 hover:shadow-xl transition-shadow duration-300">
        <h3 class="text-xl font-bold text-gray-900 mb-6">🎯 Temuan by Kategori</h3>
        <div class="h-80 flex items-center justify-center">
          <Doughnut :data="categoryChartData" :options="categoryChartOptions" />
        </div>
      </div>
    </div>

    <!-- Recent Activities -->
    <div class="bg-white rounded-2xl shadow-lg p-6 hover:shadow-xl transition-shadow duration-300">
      <h3 class="text-xl font-bold text-gray-900 mb-6">🕒 Aktivitas Terbaru</h3>
      <div class="space-y-4">
        <div 
          v-for="activity in recentActivities" 
          :key="activity.id"
          class="flex items-start space-x-4 p-4 rounded-xl hover:bg-gray-50 transition-colors duration-200 cursor-pointer border border-gray-100"
        >
          <div :class="`flex-shrink-0 w-12 h-12 rounded-full flex items-center justify-center ${activity.color}`">
            <span class="text-xl">{{ activity.icon }}</span>
          </div>
          <div class="flex-1 min-w-0">
            <p class="text-sm font-medium text-gray-900">{{ activity.title }}</p>
            <p class="text-sm text-gray-500 mt-1">{{ activity.description }}</p>
            <p class="text-xs text-gray-400 mt-1">{{ activity.time }}</p>
          </div>
          <span :class="`px-3 py-1 rounded-full text-xs font-medium ${activity.badgeColor}`">
            {{ activity.status }}
          </span>
        </div>
      </div>
    </div>

    <!-- Monthly Table Modal -->
    <div v-if="showMonthlyTableModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div class="bg-white rounded-lg shadow-2xl w-full max-w-[95vw] h-[90vh] flex flex-col">
        <!-- Modal Header -->
        <div class="px-6 py-4 border-b border-gray-200 bg-gradient-to-r from-blue-600 to-blue-700 text-white rounded-t-lg">
          <div class="flex items-center justify-between mb-3">
            <div>
              <h2 class="text-2xl font-bold">{{ selectedModuleName }}</h2>
              <p class="text-blue-100 text-sm mt-1">Data Aktivitas Bulanan per Unit</p>
            </div>
            <button 
              @click="showMonthlyTableModal = false"
              class="text-white hover:bg-white/20 rounded-lg p-2 transition-colors"
            >
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          <!-- Month Filter -->
          <div class="flex items-center gap-3">
            <label class="text-white text-sm font-medium">Filter Bulan:</label>
            <input 
              v-model="selectedMonth"
              @change="loadMonthlyData"
              type="month" 
              class="px-3 py-2 rounded-lg text-gray-900 text-sm focus:ring-2 focus:ring-white"
            />
            <span class="text-blue-100 text-sm ml-2">
              Total: {{ calculateTotalInputs() }} input data
            </span>
          </div>
        </div>

        <!-- Modal Content -->
        <div class="flex-1 overflow-auto p-6">
          <div class="overflow-x-auto">
            <table class="min-w-full border-collapse">
              <thead class="sticky top-0 z-10">
                <tr>
                  <th class="px-4 py-3 bg-gray-100 border border-gray-300 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider sticky left-0 z-20">
                    Unit
                  </th>
                  <th 
                    v-for="day in daysInMonth" 
                    :key="day"
                    class="px-3 py-3 bg-gray-100 border border-gray-300 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider min-w-[50px]"
                  >
                    {{ day }}
                  </th>
                  <th class="px-4 py-3 bg-blue-100 border border-gray-300 text-center text-xs font-semibold text-blue-700 uppercase tracking-wider sticky right-0 z-20">
                    Total
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="unitData in monthlyData" :key="unitData.unit_id" class="hover:bg-gray-50">
                  <td class="px-4 py-3 border border-gray-300 text-sm font-medium text-gray-900 sticky left-0 bg-white z-10">
                    {{ unitData.unit_name }}
                  </td>
                  <td 
                    v-for="day in daysInMonth" 
                    :key="day"
                    class="px-3 py-3 border border-gray-300 text-center"
                    :class="hasData(unitData, day) ? 'bg-green-100' : 'bg-white'"
                  >
                    <svg v-if="hasData(unitData, day)" class="w-6 h-6 text-green-700 mx-auto drop-shadow-md" fill="currentColor" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7" />
                    </svg>
                    <svg v-else class="w-5 h-5 text-gray-300 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </td>
                  <td class="px-4 py-3 border border-gray-300 text-center text-sm font-bold text-blue-700 bg-blue-50 sticky right-0 z-10">
                    {{ countInputs(unitData) }}/31
                  </td>
                </tr>
                <!-- Total Row -->
                <tr class="bg-gray-50 font-semibold">
                  <td class="px-4 py-3 border border-gray-300 text-sm text-gray-900 sticky left-0 bg-gray-100 z-10">
                    Total Unit Input
                  </td>
                  <td 
                    v-for="day in daysInMonth" 
                    :key="day"
                    class="px-3 py-3 border border-gray-300 text-center text-sm text-gray-700 bg-gray-100"
                  >
                    {{ countUnitsWithDataOnDay(day) }}/{{ monthlyData.length }}
                  </td>
                  <td class="px-4 py-3 border border-gray-300 text-center text-sm font-bold text-blue-700 bg-blue-100 sticky right-0 z-10">
                    {{ calculateTotalInputs() }}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Modal Footer -->
        <div class="px-6 py-4 border-t border-gray-200 bg-gray-50 rounded-b-lg flex items-center justify-between">
          <div class="flex items-center gap-6 text-sm">
            <div class="flex items-center gap-2">
              <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>
              <span class="text-gray-600">Sudah Input Data</span>
            </div>
            <div class="flex items-center gap-2">
              <svg class="w-5 h-5 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
              <span class="text-gray-600">Belum Input Data</span>
            </div>
          </div>
          <button
            @click="showMonthlyTableModal = false"
            class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
          >
            Tutup
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { Line, Doughnut } from 'vue-chartjs'
import { supabase } from '@/services/api/supabase'
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  ArcElement,
  Title,
  Tooltip,
  Legend,
  Filler
} from 'chart.js'

// Register ChartJS components
ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  ArcElement,
  Title,
  Tooltip,
  Legend,
  Filler
)

// Stats data
const stats = ref({
  safetyBriefing: 24,
  silentInspection: 8,
  safetyPatrol: 156,
  safetyForum: 12,
  totalTemuan: 42
})

// Monthly table modal - Initialize with current month
const now = new Date()
const defaultMonth = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`
const selectedMonth = ref(defaultMonth)
// Monthly table modal
const showMonthlyTableModal = ref(false)
const selectedModule = ref('')
const selectedModuleName = ref('')
const units = ref<any[]>([])
const monthlyData = ref<any[]>([])

// Generate days 1-31
const daysInMonth = Array.from({ length: 31 }, (_, i) => i + 1)

const openMonthlyTable = async (module: string, moduleName: string) => {
  selectedModule.value = module
  selectedModuleName.value = moduleName
  showMonthlyTableModal.value = true
  await loadMonthlyData()
}

const loadMonthlyData = async () => {
  try {
    // Load units
    const { data: unitsData } = await supabase
      .from('units')
      .select('*')
      .order('nama')
    
    units.value = unitsData || []
    
    // Parse selected month
    const [yearStr, monthStr] = selectedMonth.value.split('-')
    const year = parseInt(yearStr!)
    const month = parseInt(monthStr!)
    
    // Calculate days in selected month
    const daysInSelectedMonth = new Date(year, month, 0).getDate()
    
    // Get first and last day of selected month
    const startDate = `${year}-${String(month).padStart(2, '0')}-01`
    const endDate = `${year}-${String(month).padStart(2, '0')}-${String(daysInSelectedMonth).padStart(2, '0')}`
    
    // Get table name and date field based on module
    let tableName = ''
    let dateField = 'created_at'
    
    switch(selectedModule.value) {
      case 'safety_briefing':
        tableName = 'safety_briefing'
        dateField = 'tanggal'
        break
      case 'safety_patrol':
        tableName = 'safety_patrol'
        dateField = 'tanggal_patrol'
        break
      case 'safety_drill':
        tableName = 'safety_drill'
        dateField = 'tanggal_drill'
        break
      case 'safety_forum':
        tableName = 'safety_forum'
        dateField = 'tanggal_forum'
        break
      case 'safety_induction':
        tableName = 'safety_induction'
        dateField = 'tanggal_induction'
        break
      case 'silent_inspection':
        tableName = 'silent_inspection'
        dateField = 'tanggal'
        break
      case 'management_walkthrough':
        tableName = 'management_walkthrough'
        dateField = 'tanggal_walkthrough'
        break
      default:
        tableName = selectedModule.value
    }
    
    // Query data for selected month
    const { data: moduleData, error: queryError } = await supabase
      .from(tableName)
      .select(`unit_id, ${dateField}`)
      .gte(dateField, startDate)
      .lte(dateField, endDate)
    
    if (queryError) {
      console.error('Query Error:', queryError)
    }
    
    // Debug for Management Walkthrough
    if (selectedModule.value === 'management_walkthrough') {
      console.log('=== MANAGEMENT WALKTHROUGH DEBUG ===')
      console.log('Date Range:', startDate, 'to', endDate)
      console.log('Data Count:', moduleData?.length || 0)
      console.log('=====================================')
    }
    
    if (queryError) {
      console.error('Query Error:', queryError)
    }
    
    // Build checklist data
    monthlyData.value = units.value.map(unit => {
      const data: any = { unit_id: unit.id, unit_name: unit.nama }
      
      // Initialize all days as false (use actual days in month)
      for (let day = 1; day <= daysInSelectedMonth; day++) {
        data[`day_${day}`] = false
      }
      
      // Mark days that have data
      if (moduleData) {
        const unitRecords = moduleData.filter((item: any) => item.unit_id === unit.id)
        
        unitRecords.forEach((item: any) => {
            const dateValue = item[dateField]
            
            if (dateValue) {
              const date = new Date(dateValue)
              const day = date.getDate()
              
              if (day >= 1 && day <= 31) {
                data[`day_${day}`] = true
              }
            }
          })
      }
      
      return data
    })
  } catch (error) {
    console.error('Error loading monthly data:', error)
  }
}

// Helper functions for checklist table
const hasData = (unitData: any, day: number) => {
  return unitData[`day_${day}`] === true || unitData[`day_${day}`] > 0
}

const countInputs = (unitData: any) => {
  return daysInMonth.filter(day => hasData(unitData, day)).length
}

const countUnitsWithDataOnDay = (day: number) => {
  return monthlyData.value.filter(unit => hasData(unit, day)).length
}

const calculateTotalInputs = () => {
  return monthlyData.value.reduce((total, unit) => {
    return total + countInputs(unit)
  }, 0)
}

const getCellValue = (unitData: any, day: number) => {
  return unitData[`day_${day}`] || 0
}

const getCellClass = (value: number) => {
  if (value === 0) return 'bg-gray-50 text-gray-400'
  if (value <= 2) return 'bg-green-100 text-green-800 font-semibold'
  if (value <= 4) return 'bg-yellow-100 text-yellow-800 font-semibold'
  return 'bg-red-100 text-red-800 font-semibold'
}

// Current date and greeting
const currentDate = computed(() => {
  const options: Intl.DateTimeFormatOptions = { 
    weekday: 'long', 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  }
  return new Date().toLocaleDateString('id-ID', options)
})

const currentGreeting = computed(() => {
  const hour = new Date().getHours()
  if (hour < 12) return 'Selamat Pagi'
  if (hour < 15) return 'Selamat Siang'
  if (hour < 18) return 'Selamat Sore'
  return 'Selamat Malam'
})

// Quick actions with SVG icons
const quickActions = [
  { 
    name: 'Safety Briefing',
    module: 'safety_briefing',
    route: '/hsse/safety-briefing', 
    icon: '<svg class="w-full h-full" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" /></svg>'
  },
  { 
    name: 'Silent Inspection',
    module: 'silent_inspection',
    route: '/hsse/silent-inspection', 
    icon: '<svg class="w-full h-full" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" /></svg>'
  },
  { 
    name: 'Safety Forum',
    module: 'safety_forum',
    route: '/hsse/safety-forum', 
    icon: '<svg class="w-full h-full" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8h2a2 2 0 012 2v6a2 2 0 01-2 2h-2v4l-4-4H9a1.994 1.994 0 01-1.414-.586m0 0L11 14h4a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2v4l.586-.586z" /></svg>'
  },
  { 
    name: 'Walkthrough',
    module: 'management_walkthrough',
    route: '/hsse/management-walkthrough', 
    icon: '<svg class="w-full h-full" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" /></svg>'
  },
  { 
    name: 'Safety Patrol',
    module: 'safety_patrol',
    route: '/hsse/safety-patrol', 
    icon: '<svg class="w-full h-full" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" /></svg>'
  },
  { 
    name: 'Safety Induction',
    module: 'safety_induction',
    route: '/hsse/safety-induction', 
    icon: '<svg class="w-full h-full" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" /></svg>'
  },
  { 
    name: 'Safety Drill',
    module: 'safety_drill',
    route: '/hsse/safety-drill', 
    icon: '<svg class="w-full h-full" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 18.657A8 8 0 016.343 7.343S7 9 9 10c0-2 .5-5 2.986-7C14 5 16.09 5.777 17.656 7.343A7.975 7.975 0 0120 13a7.975 7.975 0 01-2.343 5.657z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.879 16.121A3 3 0 1012.015 11L11 14H9c0 .768.293 1.536.879 2.121z" /></svg>'
  }
]

// Recent activities
const recentActivities = ref([
  {
    id: 1,
    icon: '📝',
    title: 'Safety Briefing Selesai',
    description: 'Unit Produksi A - Topik: Pencegahan Kebakaran',
    time: '5 menit yang lalu',
    status: 'Selesai',
    color: 'bg-blue-100',
    badgeColor: 'bg-green-100 text-green-800'
  },
  {
    id: 2,
    icon: '⚠️',
    title: 'Temuan Baru - Safety Patrol',
    description: 'Area Warehouse - Kabel listrik terkelupas',
    time: '15 menit yang lalu',
    status: 'Perlu Tindakan',
    color: 'bg-red-100',
    badgeColor: 'bg-red-100 text-red-800'
  },
  {
    id: 3,
    icon: '🔍',
    title: 'Silent Inspection Dijadwalkan',
    description: 'Unit Produksi B - Tanggal: 25 Nov 2025',
    time: '1 jam yang lalu',
    status: 'Terjadwal',
    color: 'bg-purple-100',
    badgeColor: 'bg-blue-100 text-blue-800'
  },
  {
    id: 4,
    icon: '✅',
    title: 'Tindakan Korektif Selesai',
    description: 'Perbaikan pagar pembatas area produksi',
    time: '2 jam yang lalu',
    status: 'Selesai',
    color: 'bg-green-100',
    badgeColor: 'bg-green-100 text-green-800'
  }
])

// Trend Chart Data
const trendChartData = computed(() => ({
  labels: ['Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov'],
  datasets: [
    {
      label: 'Safety Briefing',
      data: [18, 22, 20, 25, 23, 24],
      borderColor: '#3B82F6',
      backgroundColor: 'rgba(59, 130, 246, 0.1)',
      fill: true,
      tension: 0.4,
      borderWidth: 3
    },
    {
      label: 'Safety Patrol',
      data: [120, 135, 148, 152, 145, 156],
      borderColor: '#10B981',
      backgroundColor: 'rgba(16, 185, 129, 0.1)',
      fill: true,
      tension: 0.4,
      borderWidth: 3
    },
    {
      label: 'Temuan',
      data: [35, 42, 38, 45, 40, 42],
      borderColor: '#EF4444',
      backgroundColor: 'rgba(239, 68, 68, 0.1)',
      fill: true,
      tension: 0.4,
      borderWidth: 3
    }
  ]
}))

const trendChartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      display: true,
      position: 'bottom' as const,
      labels: {
        usePointStyle: true,
        padding: 15,
        font: {
          size: 13,
          weight: 500
        }
      }
    },
    tooltip: {
      mode: 'index' as const,
      intersect: false,
      backgroundColor: 'rgba(0, 0, 0, 0.8)',
      padding: 12,
      cornerRadius: 8
    }
  },
  scales: {
    y: {
      beginAtZero: true,
      grid: {
        color: 'rgba(0, 0, 0, 0.05)',
        drawBorder: false
      },
      ticks: {
        font: {
          size: 12
        }
      }
    },
    x: {
      grid: {
        display: false
      },
      ticks: {
        font: {
          size: 12
        }
      }
    }
  }
}

// Category Chart Data
const categoryChartData = computed(() => ({
  labels: ['Unsafe Act', 'Unsafe Condition', 'Near Miss', 'Incident'],
  datasets: [
    {
      data: [15, 18, 6, 3],
      backgroundColor: [
        '#EF4444',
        '#F59E0B',
        '#3B82F6',
        '#8B5CF6'
      ],
      borderWidth: 0,
      hoverOffset: 10
    }
  ]
}))

const categoryChartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      position: 'bottom' as const,
      labels: {
        padding: 15,
        usePointStyle: true,
        font: {
          size: 13,
          weight: 500
        }
      }
    },
    tooltip: {
      backgroundColor: 'rgba(0, 0, 0, 0.8)',
      padding: 12,
      cornerRadius: 8
    }
  }
}
</script>
