<template>
  <div class="space-y-6">
    <!-- Page Header -->
    <div class="bg-gradient-to-r from-indigo-600 to-purple-600 rounded-xl shadow-lg p-6 text-white">
      <div class="flex items-center justify-between">
        <div>
          <h1 class="text-3xl font-bold mb-2">Monitoring Input Data</h1>
          <p class="text-indigo-100">Pantau kelengkapan input data HSSE dari setiap unit</p>
        </div>
        <div class="bg-white/10 backdrop-blur-sm rounded-lg p-4">
          <p class="text-sm text-indigo-100">Periode</p>
          <p class="text-xl font-bold">{{ currentMonth }}</p>
        </div>
      </div>
    </div>

    <!-- Filter Section -->
    <div class="card">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Wilayah</label>
          <select v-model="filters.wilayahId" class="input-field" @change="onWilayahChange">
            <option value="">Semua Wilayah</option>
            <option v-for="wilayah in wilayahList" :key="wilayah.id" :value="wilayah.id">
              {{ wilayah.nama }}
            </option>
          </select>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Area</label>
          <select v-model="filters.areaId" class="input-field" @change="onAreaChange">
            <option value="">Semua Area</option>
            <option v-for="area in areaList" :key="area.id" :value="area.id">
              {{ area.nama }}
            </option>
          </select>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Bulan</label>
          <input v-model="filters.month" type="month" class="input-field" @change="loadData">
        </div>
      </div>
    </div>

    <!-- Summary Cards -->
    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
      <div class="bg-green-50 border-l-4 border-green-500 p-4 rounded-lg">
        <p class="text-sm text-green-600 font-medium">Unit Lengkap</p>
        <p class="text-3xl font-bold text-green-700">{{ summary.complete }}</p>
        <p class="text-xs text-green-600 mt-1">{{ summary.completePercentage }}%</p>
      </div>
      <div class="bg-yellow-50 border-l-4 border-yellow-500 p-4 rounded-lg">
        <p class="text-sm text-yellow-600 font-medium">Unit Parsial</p>
        <p class="text-3xl font-bold text-yellow-700">{{ summary.partial }}</p>
        <p class="text-xs text-yellow-600 mt-1">{{ summary.partialPercentage }}%</p>
      </div>
      <div class="bg-red-50 border-l-4 border-red-500 p-4 rounded-lg">
        <p class="text-sm text-red-600 font-medium">Unit Belum Input</p>
        <p class="text-3xl font-bold text-red-700">{{ summary.empty }}</p>
        <p class="text-xs text-red-600 mt-1">{{ summary.emptyPercentage }}%</p>
      </div>
      <div class="bg-blue-50 border-l-4 border-blue-500 p-4 rounded-lg">
        <p class="text-sm text-blue-600 font-medium">Total Unit</p>
        <p class="text-3xl font-bold text-blue-700">{{ summary.total }}</p>
        <p class="text-xs text-blue-600 mt-1">Dipantau</p>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="text-center py-12">
      <div class="inline-block animate-spin rounded-full h-12 w-12 border-4 border-indigo-600 border-t-transparent"></div>
      <p class="mt-4 text-gray-600">Memuat data monitoring...</p>
    </div>

    <!-- Monitoring Table -->
    <div v-else class="card overflow-hidden">
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider sticky left-0 bg-gray-50 z-10">
                Unit
              </th>
              <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                Safety Briefing
              </th>
              <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                Silent Inspection
              </th>
              <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                Safety Patrol
              </th>
              <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                Safety Forum
              </th>
              <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                Management Walkthrough
              </th>
              <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                Safety Drill
              </th>
              <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                Safety Induction
              </th>
              <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                Kelengkapan
              </th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <template v-if="monitoringData.length === 0">
              <tr>
                <td colspan="9" class="px-6 py-12 text-center text-gray-500">
                  <svg class="mx-auto h-12 w-12 text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
                  </svg>
                  <p class="text-lg font-medium">Tidak ada data unit</p>
                  <p class="text-sm mt-2">Silakan pilih filter atau periksa master pelabuhan</p>
                </td>
              </tr>
            </template>
            <tr v-for="item in monitoringData" :key="item.unit.id" class="hover:bg-gray-50">
              <td class="px-6 py-4 whitespace-nowrap sticky left-0 bg-white">
                <div class="text-sm font-medium text-gray-900">{{ item.unit.nama }}</div>
                <div class="text-sm text-gray-500">{{ item.area.nama }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-center">
                <span v-if="item.safetyBriefing > 0" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                  ✓ {{ item.safetyBriefing }}
                </span>
                <span v-else class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                  ✗ 0
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-center">
                <span v-if="item.silentInspection > 0" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                  ✓ {{ item.silentInspection }}
                </span>
                <span v-else class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                  ✗ 0
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-center">
                <span v-if="item.safetyPatrol > 0" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                  ✓ {{ item.safetyPatrol }}
                </span>
                <span v-else class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                  ✗ 0
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-center">
                <span v-if="item.safetyForum > 0" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                  ✓ {{ item.safetyForum }}
                </span>
                <span v-else class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                  ✗ 0
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-center">
                <span v-if="item.managementWalkthrough > 0" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                  ✓ {{ item.managementWalkthrough }}
                </span>
                <span v-else class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                  ✗ 0
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-center">
                <span v-if="item.safetyDrill > 0" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                  ✓ {{ item.safetyDrill }}
                </span>
                <span v-else class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                  ✗ 0
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-center">
                <span v-if="item.safetyInduction > 0" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                  ✓ {{ item.safetyInduction }}
                </span>
                <span v-else class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                  ✗ 0
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-center">
                <div class="w-full">
                  <div class="text-xs font-medium mb-1">{{ item.completionPercentage }}%</div>
                  <div class="w-full bg-gray-200 rounded-full h-2">
                    <div
                      :class="[
                        'h-2 rounded-full transition-all duration-300',
                        item.completionPercentage >= 80 ? 'bg-green-500' :
                        item.completionPercentage >= 50 ? 'bg-yellow-500' : 'bg-red-500'
                      ]"
                      :style="{ width: item.completionPercentage + '%' }"
                    ></div>
                  </div>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Legend -->
    <div class="card">
      <h3 class="text-sm font-medium text-gray-700 mb-3">Keterangan:</h3>
      <div class="grid grid-cols-2 md:grid-cols-3 gap-4 text-sm">
        <div class="flex items-center">
          <span class="inline-block w-4 h-4 bg-green-500 rounded mr-2"></span>
          <span class="text-gray-600">Sudah Input (Ada data)</span>
        </div>
        <div class="flex items-center">
          <span class="inline-block w-4 h-4 bg-red-500 rounded mr-2"></span>
          <span class="text-gray-600">Belum Input (Tidak ada data)</span>
        </div>
        <div class="flex items-center">
          <span class="inline-block w-4 h-4 bg-gray-300 rounded mr-2"></span>
          <span class="text-gray-600">Angka = Jumlah record</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { supabase } from '@/services/api/supabase'

interface MonitoringItem {
  unit: {
    id: string
    nama: string
    kode: string
  }
  area: {
    id: string
    nama: string
  }
  wilayah: {
    id: string
    nama: string
  }
  safetyBriefing: number
  silentInspection: number
  safetyPatrol: number
  safetyForum: number
  managementWalkthrough: number
  safetyDrill: number
  safetyInduction: number
  completionPercentage: number
}

const loading = ref(false)
const monitoringData = ref<MonitoringItem[]>([])
const wilayahList = ref<any[]>([])
const areaList = ref<any[]>([])
const allAreaList = ref<any[]>([])

const filters = reactive({
  wilayahId: '',
  areaId: '',
  month: new Date().toISOString().slice(0, 7) // YYYY-MM
})

const currentMonth = computed(() => {
  const date = new Date(filters.month + '-01')
  return date.toLocaleDateString('id-ID', { year: 'numeric', month: 'long' })
})

const summary = computed(() => {
  const total = monitoringData.value.length
  const complete = monitoringData.value.filter(item => item.completionPercentage === 100).length
  const partial = monitoringData.value.filter(item => item.completionPercentage > 0 && item.completionPercentage < 100).length
  const empty = monitoringData.value.filter(item => item.completionPercentage === 0).length

  return {
    total,
    complete,
    partial,
    empty,
    completePercentage: total > 0 ? Math.round((complete / total) * 100) : 0,
    partialPercentage: total > 0 ? Math.round((partial / total) * 100) : 0,
    emptyPercentage: total > 0 ? Math.round((empty / total) * 100) : 0
  }
})

async function loadWilayahAndAreas() {
  try {
    // Load wilayah
    const { data: wilayahData } = await supabase
      .from('wilayah')
      .select('id, nama, kode')
      .eq('aktif', true)
      .order('nama')
    
    wilayahList.value = wilayahData || []

    // Load all areas
    const { data: areasData } = await supabase
      .from('areas')
      .select('id, nama_area, kode_area, wilayah_id')
      .order('nama_area')
    
    allAreaList.value = (areasData || []).map(a => ({
      id: a.id,
      nama: a.nama_area,
      kode: a.kode_area,
      wilayah_id: a.wilayah_id
    }))

    areaList.value = allAreaList.value
  } catch (error) {
    console.error('Error loading wilayah/areas:', error)
  }
}

function onWilayahChange() {
  filters.areaId = ''
  if (filters.wilayahId) {
    areaList.value = allAreaList.value.filter(a => a.wilayah_id === filters.wilayahId)
  } else {
    areaList.value = allAreaList.value
  }
  loadData()
}

function onAreaChange() {
  loadData()
}

async function loadData() {
  loading.value = true
  try {
    // Get master pelabuhan units with filters
    let query = supabase
      .from('master_pelabuhan')
      .select(`
        id,
        unit_id,
        area_id,
        wilayah_id,
        units:unit_id(id, nama, kode),
        areas:area_id(id, nama_area),
        wilayah:wilayah_id(id, nama)
      `)
      .eq('aktif', true)

    if (filters.wilayahId) {
      query = query.eq('wilayah_id', filters.wilayahId)
    }
    if (filters.areaId) {
      query = query.eq('area_id', filters.areaId)
    }

    const { data: masterPelabuhanData, error } = await query

    if (error) throw error

    // Get date range for the selected month
    const startDate = `${filters.month}-01`
    const endDate = new Date(filters.month + '-01')
    endDate.setMonth(endDate.getMonth() + 1)
    const endDateStr = endDate.toISOString().slice(0, 10)

    // Get unit IDs
    const unitIds = (masterPelabuhanData || []).map((mp: any) => mp.unit_id)

    // Fetch all module data in parallel (7 queries instead of N x 7)
    const [
      safetyBriefingData,
      silentInspectionData,
      safetyPatrolData,
      safetyForumData,
      managementWalkthroughData,
      safetyDrillData,
      safetyInductionData
    ] = await Promise.all([
      countRecordsByUnits('safety_briefing', 'tanggal', unitIds, startDate, endDateStr),
      countRecordsByUnits('silent_inspection', 'tanggal', unitIds, startDate, endDateStr),
      countRecordsByUnits('safety_patrol', 'tanggal_patrol', unitIds, startDate, endDateStr),
      countRecordsByUnits('safety_forum', 'tanggal_forum', unitIds, startDate, endDateStr),
      countRecordsByUnits('management_walkthrough', 'tanggal_walkthrough', unitIds, startDate, endDateStr),
      countRecordsByUnits('safety_drill', 'tanggal_drill', unitIds, startDate, endDateStr),
      countRecordsByUnits('safety_induction', 'tanggal_induction', unitIds, startDate, endDateStr)
    ])

    // Build monitoring data from aggregated results
    monitoringData.value = (masterPelabuhanData || []).map((mp: any) => {
      const unitId = mp.unit_id
      
      const safetyBriefingCount = safetyBriefingData[unitId] || 0
      const silentInspectionCount = silentInspectionData[unitId] || 0
      const safetyPatrolCount = safetyPatrolData[unitId] || 0
      const safetyForumCount = safetyForumData[unitId] || 0
      const managementWalkthroughCount = managementWalkthroughData[unitId] || 0
      const safetyDrillCount = safetyDrillData[unitId] || 0
      const safetyInductionCount = safetyInductionData[unitId] || 0

      const totalModules = 7
      const completedModules = [
        safetyBriefingCount,
        silentInspectionCount,
        safetyPatrolCount,
        safetyForumCount,
        managementWalkthroughCount,
        safetyDrillCount,
        safetyInductionCount
      ].filter(count => count > 0).length

      return {
        unit: {
          id: mp.units.id,
          nama: mp.units.nama,
          kode: mp.units.kode
        },
        area: {
          id: mp.areas.id,
          nama: mp.areas.nama_area
        },
        wilayah: {
          id: mp.wilayah.id,
          nama: mp.wilayah.nama
        },
        safetyBriefing: safetyBriefingCount,
        silentInspection: silentInspectionCount,
        safetyPatrol: safetyPatrolCount,
        safetyForum: safetyForumCount,
        managementWalkthrough: managementWalkthroughCount,
        safetyDrill: safetyDrillCount,
        safetyInduction: safetyInductionCount,
        completionPercentage: Math.round((completedModules / totalModules) * 100)
      }
    })
    
    // Sort by completion percentage (ascending) then by unit name
    monitoringData.value.sort((a, b) => {
      if (a.completionPercentage !== b.completionPercentage) {
        return a.completionPercentage - b.completionPercentage
      }
      return a.unit.nama.localeCompare(b.unit.nama)
    })

  } catch (error) {
    console.error('Error loading monitoring data:', error)
  } finally {
    loading.value = false
  }
}

// New efficient function: fetch all units' counts in one query
async function countRecordsByUnits(
  tableName: string,
  dateColumn: string,
  unitIds: string[],
  startDate: string,
  endDate: string
): Promise<Record<string, number>> {
  try {
    if (unitIds.length === 0) return {}

    const { data, error } = await supabase
      .from(tableName)
      .select('unit_id')
      .in('unit_id', unitIds)
      .gte(dateColumn, startDate)
      .lt(dateColumn, endDate)

    if (error) {
      console.error(`Supabase error for ${tableName}:`, {
        message: error.message,
        details: error.details,
        hint: error.hint,
        code: error.code
      })
      throw error
    }

    // Count records per unit
    const countsMap: Record<string, number> = {}
    unitIds.forEach(id => countsMap[id] = 0)
    
    if (data) {
      data.forEach((row: any) => {
        if (row.unit_id) {
          countsMap[row.unit_id] = (countsMap[row.unit_id] || 0) + 1
        }
      })
    }

    return countsMap
  } catch (error: any) {
    console.error(`Error counting ${tableName}:`, {
      message: error?.message || 'Unknown error',
      tableName,
      dateColumn,
      error
    })
    return {}
  }
}

// Legacy function - kept for backward compatibility if needed
async function countRecords(
  tableName: string,
  unitId: string,
  startDate: string,
  endDate: string
): Promise<number> {
  try {
    // Map table names to their date column
    const dateColumnMap: Record<string, string> = {
      'safety_briefing': 'tanggal',
      'silent_inspection': 'tanggal',
      'safety_patrol': 'tanggal_patrol',
      'safety_forum': 'tanggal_forum',
      'management_walkthrough': 'tanggal_walkthrough',
      'safety_drill': 'tanggal_drill',
      'safety_induction': 'tanggal_induction'
    }

    const dateColumn = dateColumnMap[tableName] || 'created_at'

    const { count, error } = await supabase
      .from(tableName)
      .select('*', { count: 'exact', head: true })
      .eq('unit_id', unitId)
      .gte(dateColumn, startDate)
      .lt(dateColumn, endDate)

    if (error) {
      console.error(`Supabase error for ${tableName}:`, {
        message: error.message,
        details: error.details,
        hint: error.hint,
        code: error.code
      })
      throw error
    }
    return count || 0
  } catch (error: any) {
    console.error(`Error counting ${tableName}:`, {
      message: error?.message || 'Unknown error',
      unitId,
      startDate,
      endDate,
      error
    })
    return 0
  }
}

onMounted(() => {
  loadWilayahAndAreas()
  loadData()
})
</script>

<style scoped>
.sticky {
  position: sticky;
}
</style>
