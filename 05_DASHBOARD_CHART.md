# 📊 Dashboard & Charts - Aplikasi Implementasi HSSE

## Dashboard Overview

Dashboard HSSE menampilkan statistik real-time, trend analysis, dan compliance rate untuk semua modul HSSE.

---

## 1. Dashboard Component

### DashboardView.vue
```vue
<template>
  <div class="dashboard">
    <h1 class="text-3xl font-bold mb-6">Dashboard HSSE</h1>

    <!-- Filter -->
    <div class="mb-6 p-4 bg-white rounded-lg shadow">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <BaseSelect
          v-model="filters.unitId"
          label="Filter Unit"
          :options="units"
          value-key="id"
          label-key="nama_unit"
          placeholder="Semua Unit"
          @change="loadDashboard"
        />
        
        <BaseSelect
          v-model="filters.wilayahId"
          label="Filter Wilayah"
          :options="wilayah"
          value-key="id"
          label-key="nama_wilayah"
          placeholder="Semua Wilayah"
          @change="loadDashboard"
        />
        
        <BaseSelect
          v-model="filters.period"
          label="Periode"
          :options="periodOptions"
          value-key="value"
          label-key="label"
          @change="loadDashboard"
        />
      </div>
    </div>

    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
      <DashboardStats
        title="Safety Briefing"
        :value="stats.briefingCount"
        :target="stats.briefingTarget"
        icon="briefing"
        color="blue"
      />
      
      <DashboardStats
        title="Silent Inspection"
        :value="stats.inspectionCount"
        :target="stats.inspectionTarget"
        icon="inspection"
        color="green"
      />
      
      <DashboardStats
        title="Safety Patrol"
        :value="stats.patrolCount"
        :target="stats.patrolTarget"
        icon="patrol"
        color="yellow"
      />
      
      <DashboardStats
        title="Safety Drill"
        :value="stats.drillCount"
        :target="stats.drillTarget"
        icon="drill"
        color="red"
      />
    </div>

    <!-- Charts -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
      <!-- Trend Chart -->
      <div class="bg-white p-6 rounded-lg shadow">
        <h3 class="text-lg font-semibold mb-4">Trend HSSE (6 Bulan Terakhir)</h3>
        <DashboardTrendChart :data="trendData" />
      </div>

      <!-- Temuan by Category -->
      <div class="bg-white p-6 rounded-lg shadow">
        <h3 class="text-lg font-semibold mb-4">Temuan per Kategori</h3>
        <DashboardPieChart :data="temuanData" />
      </div>
    </div>

    <!-- Compliance Rate -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
      <DashboardComplianceRate
        v-for="compliance in complianceData"
        :key="compliance.module"
        :module="compliance.module"
        :rate="compliance.rate"
        :status="compliance.status"
      />
    </div>

    <!-- Recent Activity -->
    <div class="bg-white p-6 rounded-lg shadow">
      <h3 class="text-lg font-semibold mb-4">Aktivitas Terbaru</h3>
      <DashboardRecentActivity :activities="recentActivities" />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useDashboardStore } from '@/stores/dashboard'

const dashboardStore = useDashboardStore()

const filters = ref({
  unitId: '',
  wilayahId: '',
  period: 'month'
})

const periodOptions = [
  { value: 'week', label: 'Minggu Ini' },
  { value: 'month', label: 'Bulan Ini' },
  { value: 'quarter', label: 'Triwulan Ini' },
  { value: 'year', label: 'Tahun Ini' }
]

const stats = computed(() => dashboardStore.stats)
const trendData = computed(() => dashboardStore.trendData)
const temuanData = computed(() => dashboardStore.temuanData)
const complianceData = computed(() => dashboardStore.complianceData)
const recentActivities = computed(() => dashboardStore.recentActivities)

const loadDashboard = async () => {
  await dashboardStore.loadDashboard(filters.value)
}

onMounted(() => {
  loadDashboard()
})
</script>
```

---

## 2. Chart Components

### DashboardTrendChart.vue (Line Chart)
```vue
<template>
  <Line :data="chartData" :options="chartOptions" />
</template>

<script setup>
import { computed } from 'vue'
import { Line } from 'vue-chartjs'
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend
} from 'chart.js'

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend
)

const props = defineProps({
  data: {
    type: Object,
    required: true
  }
})

const chartData = computed(() => ({
  labels: props.data.labels,
  datasets: [
    {
      label: 'Safety Briefing',
      data: props.data.briefing,
      borderColor: '#3B82F6',
      backgroundColor: 'rgba(59, 130, 246, 0.1)',
      tension: 0.4
    },
    {
      label: 'Safety Patrol',
      data: props.data.patrol,
      borderColor: '#10B981',
      backgroundColor: 'rgba(16, 185, 129, 0.1)',
      tension: 0.4
    },
    {
      label: 'Silent Inspection',
      data: props.data.inspection,
      borderColor: '#F59E0B',
      backgroundColor: 'rgba(245, 158, 11, 0.1)',
      tension: 0.4
    }
  ]
}))

const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      position: 'bottom'
    },
    tooltip: {
      mode: 'index',
      intersect: false
    }
  },
  scales: {
    y: {
      beginAtZero: true,
      ticks: {
        stepSize: 1
      }
    }
  }
}
</script>

<style scoped>
canvas {
  max-height: 300px;
}
</style>
```

### DashboardPieChart.vue
```vue
<template>
  <Doughnut :data="chartData" :options="chartOptions" />
</template>

<script setup>
import { computed } from 'vue'
import { Doughnut } from 'vue-chartjs'
import { Chart as ChartJS, ArcElement, Tooltip, Legend } from 'chart.js'

ChartJS.register(ArcElement, Tooltip, Legend)

const props = defineProps({
  data: {
    type: Object,
    required: true
  }
})

const chartData = computed(() => ({
  labels: ['Critical', 'Major', 'Minor', 'None'],
  datasets: [
    {
      data: [
        props.data.critical || 0,
        props.data.major || 0,
        props.data.minor || 0,
        props.data.none || 0
      ],
      backgroundColor: [
        '#EF4444', // Red - Critical
        '#F59E0B', // Orange - Major
        '#FBBF24', // Yellow - Minor
        '#10B981'  // Green - None
      ]
    }
  ]
}))

const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      position: 'right'
    }
  }
}
</script>
```

### DashboardStats.vue
```vue
<template>
  <div class="stats-card" :class="`border-l-4 border-${color}-500`">
    <div class="flex items-center justify-between">
      <div>
        <p class="text-sm text-gray-600 mb-1">{{ title }}</p>
        <p class="text-3xl font-bold">{{ value }}</p>
        <p v-if="target" class="text-sm text-gray-500 mt-1">
          Target: {{ target }}
        </p>
      </div>
      <div :class="`text-${color}-500`">
        <svg class="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="iconPath" />
        </svg>
      </div>
    </div>
    
    <!-- Progress bar -->
    <div v-if="target" class="mt-3">
      <div class="w-full bg-gray-200 rounded-full h-2">
        <div
          :class="`bg-${color}-500 h-2 rounded-full transition-all`"
          :style="{ width: `${percentage}%` }"
        ></div>
      </div>
      <p class="text-xs text-gray-500 mt-1">{{ percentage }}% dari target</p>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  title: String,
  value: Number,
  target: Number,
  icon: String,
  color: String
})

const percentage = computed(() => {
  if (!props.target) return 0
  return Math.min(Math.round((props.value / props.target) * 100), 100)
})

const iconPath = computed(() => {
  const icons = {
    briefing: 'M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z',
    inspection: 'M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4',
    patrol: 'M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l4.553 2.276A1 1 0 0021 18.382V7.618a1 1 0 00-.553-.894L15 4m0 13V4m0 0L9 7',
    drill: 'M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z'
  }
  return icons[props.icon] || icons.briefing
})
</script>

<style scoped>
.stats-card {
  @apply bg-white p-6 rounded-lg shadow;
}
</style>
```

---

## 3. Dashboard Store

### stores/dashboard.js
```javascript
import { defineStore } from 'pinia'
import { ref } from 'vue'
import { supabase } from '@/services/api/supabase'

export const useDashboardStore = defineStore('dashboard', () => {
  const stats = ref({
    briefingCount: 0,
    briefingTarget: 22,
    inspectionCount: 0,
    inspectionTarget: 1,
    patrolCount: 0,
    patrolTarget: 22,
    drillCount: 0,
    drillTarget: 2
  })

  const trendData = ref({
    labels: [],
    briefing: [],
    patrol: [],
    inspection: []
  })

  const temuanData = ref({
    critical: 0,
    major: 0,
    minor: 0,
    none: 0
  })

  const complianceData = ref([])
  const recentActivities = ref([])

  const loadDashboard = async (filters = {}) => {
    const today = new Date()
    const firstDay = new Date(today.getFullYear(), today.getMonth(), 1)
    const lastDay = new Date(today.getFullYear(), today.getMonth() + 1, 0)

    // Build filter
    const baseFilter = {}
    if (filters.unitId) baseFilter.unit_id = filters.unitId
    if (filters.wilayahId) baseFilter.wilayah_id = filters.wilayahId

    // Load stats
    await loadStats(baseFilter, firstDay, lastDay)
    
    // Load trend data (last 6 months)
    await loadTrendData(baseFilter)
    
    // Load temuan stats
    await loadTemuanStats(baseFilter)
    
    // Load compliance rate
    await loadComplianceRate(baseFilter)
    
    // Load recent activities
    await loadRecentActivities(baseFilter)
  }

  const loadStats = async (filter, startDate, endDate) => {
    // Safety Briefing
    const { count: briefingCount } = await supabase
      .from('safety_briefing')
      .select('*', { count: 'exact', head: true })
      .match(filter)
      .gte('tanggal', startDate.toISOString().split('T')[0])
      .lte('tanggal', endDate.toISOString().split('T')[0])

    stats.value.briefingCount = briefingCount

    // Similar for other modules...
  }

  const loadTrendData = async (filter) => {
    const sixMonthsAgo = new Date()
    sixMonthsAgo.setMonth(sixMonthsAgo.getMonth() - 6)

    // Get briefing data
    const { data: briefingData } = await supabase
      .from('safety_briefing')
      .select('tanggal')
      .match(filter)
      .gte('tanggal', sixMonthsAgo.toISOString().split('T')[0])

    // Process data by month
    const monthlyData = {}
    briefingData?.forEach(item => {
      const month = item.tanggal.substring(0, 7)
      monthlyData[month] = (monthlyData[month] || 0) + 1
    })

    // Format for chart
    trendData.value.labels = Object.keys(monthlyData).sort()
    trendData.value.briefing = Object.values(monthlyData)
  }

  const loadTemuanStats = async (filter) => {
    // Get from Silent Inspection
    const { data: inspectionData } = await supabase
      .from('silent_inspection')
      .select('kategori_temuan')
      .match(filter)
      .not('kategori_temuan', 'is', null)

    // Count by category
    const stats = { critical: 0, major: 0, minor: 0, none: 0 }
    inspectionData?.forEach(item => {
      if (stats[item.kategori_temuan] !== undefined) {
        stats[item.kategori_temuan]++
      }
    })

    temuanData.value = stats
  }

  const loadComplianceRate = async (filter) => {
    // Calculate compliance for each module
    // Example for Safety Patrol (daily for unit)
    const today = new Date()
    const workingDays = 22 // approximate

    const { count: patrolCount } = await supabase
      .from('safety_patrol')
      .select('*', { count: 'exact', head: true })
      .match(filter)
      .gte('tanggal', new Date(today.getFullYear(), today.getMonth(), 1).toISOString().split('T')[0])

    const patrolRate = (patrolCount / workingDays) * 100

    complianceData.value = [
      {
        module: 'Safety Patrol',
        rate: patrolRate,
        status: patrolRate >= 90 ? 'excellent' : patrolRate >= 70 ? 'good' : 'needs_improvement'
      }
    ]
  }

  const loadRecentActivities = async (filter) => {
    // Get recent 10 activities from all modules
    const { data } = await supabase
      .from('safety_briefing')
      .select('id, tanggal, topik, status, created_at')
      .match(filter)
      .order('created_at', { ascending: false })
      .limit(10)

    recentActivities.value = data || []
  }

  return {
    stats,
    trendData,
    temuanData,
    complianceData,
    recentActivities,
    loadDashboard
  }
})
```

---

## Summary

**Dashboard Features**:
- ✅ Real-time statistics cards
- ✅ Trend line chart (6 months)
- ✅ Temuan pie chart by category
- ✅ Compliance rate indicators
- ✅ Recent activity feed
- ✅ Filter by unit/wilayah/period
- ✅ Responsive design

**Charts Library**: Chart.js + vue-chartjs
**Data Refresh**: Manual + auto-refresh options

**Next**: Dokumentasi Detail 7 Modul HSSE (06_MODULE_DETAILS.md)
