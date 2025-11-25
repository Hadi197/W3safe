<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { supabase } from '@/services/api/supabase'

interface ProgramData {
  id: string
  name: string
  icon: string
  realization: number | string
  target: string
  isPercentage: boolean
  color: string
}

const loading = ref(false)
const selectedMonth = ref(new Date().toISOString().slice(0, 7))
const programs = ref<ProgramData[]>([
  {
    id: 'safety_briefing',
    name: 'Safety Briefing',
    icon: '👥',
    realization: 0,
    target: 'Target: 1x/hari',
    isPercentage: false,
    color: '#1e40af'
  },
  {
    id: 'management_walkthrough',
    name: 'Management Walkthrough',
    icon: '🚶',
    realization: 0,
    target: 'Target: 1x/triwulan oleh BOD/BOD-1 bidang K3',
    isPercentage: false,
    color: '#1e40af'
  },
  {
    id: 'silent_inspection',
    name: 'Inspection',
    icon: '🔍',
    realization: 0,
    target: 'Target: 1x/triwulan oleh bidang K3',
    isPercentage: false,
    color: '#1e40af'
  },
  {
    id: 'audit',
    name: 'Pemenuhan Audit',
    icon: '📋',
    realization: '0%',
    target: 'Target: 100%/tahun terkait K3',
    isPercentage: true,
    color: '#1e40af'
  },
  {
    id: 'sarpras',
    name: 'Pengukuran Sarpras K3',
    icon: '🧯',
    realization: '0%',
    target: 'Target: 100%/tahun',
    isPercentage: true,
    color: '#1e40af'
  },
  {
    id: 'safety_forum',
    name: 'Safety Forum',
    icon: '💬',
    realization: 0,
    target: 'Target: 1x/triwulan',
    isPercentage: false,
    color: '#1e40af'
  },
  {
    id: 'safety_drill',
    name: 'Emergency Drill',
    icon: '🚨',
    realization: 0,
    target: 'Target: 2x/tahun',
    isPercentage: false,
    color: '#1e40af'
  },
  {
    id: 'health_risk',
    name: 'Health Risk Assessment',
    icon: '❤️',
    realization: '0%',
    target: 'Target: 100% unit/tahun',
    isPercentage: true,
    color: '#1e40af'
  },
  {
    id: 'evaluasi',
    name: 'Evaluasi Program K3L',
    icon: '📊',
    realization: 0,
    target: 'Target: 1x/semester',
    isPercentage: false,
    color: '#1e40af'
  },
  {
    id: 'safety_induction',
    name: 'Safety Induction',
    icon: '👷',
    realization: 0,
    target: 'Target: ~ orang/tahun',
    isPercentage: false,
    color: '#1e40af'
  }
])

async function loadData() {
  loading.value = true
  try {
    const startDate = `${selectedMonth.value}-01`
    const endDate = new Date(selectedMonth.value + '-01')
    endDate.setMonth(endDate.getMonth() + 1)
    const endDateStr = endDate.toISOString().slice(0, 10)

    // Fetch counts for each program
    const [
      briefingCount,
      walkthroughCount,
      inspectionCount,
      forumCount,
      drillCount,
      inductionCount
    ] = await Promise.all([
      countRecords('safety_briefing', 'tanggal', startDate, endDateStr),
      countRecords('management_walkthrough', 'tanggal_walkthrough', startDate, endDateStr),
      countRecords('silent_inspection', 'tanggal', startDate, endDateStr),
      countRecords('safety_forum', 'tanggal_forum', startDate, endDateStr),
      countRecords('safety_drill', 'tanggal_drill', startDate, endDateStr),
      countRecords('safety_induction', 'tanggal_induction', startDate, endDateStr)
    ])

    // Update realizations
    const prog = programs.value
    prog[0]!.realization = briefingCount
    prog[1]!.realization = walkthroughCount
    prog[2]!.realization = inspectionCount
    prog[5]!.realization = forumCount
    prog[6]!.realization = drillCount
    prog[9]!.realization = inductionCount

    // For percentage-based programs (audit, sarpras, health risk)
    // These would need different calculation logic based on requirements
    
  } catch (error) {
    console.error('Error loading dashboard data:', error)
  } finally {
    loading.value = false
  }
}

async function countRecords(
  tableName: string,
  dateColumn: string,
  startDate: string,
  endDate: string
): Promise<number> {
  try {
    const { count, error } = await supabase
      .from(tableName)
      .select('*', { count: 'exact', head: true })
      .gte(dateColumn, startDate)
      .lt(dateColumn, endDate)

    if (error) throw error
    return count || 0
  } catch (error) {
    console.error(`Error counting ${tableName}:`, error)
    return 0
  }
}

onMounted(() => {
  loadData()
})
</script>

<template>
  <div class="program-k3-dashboard">
    <!-- Header -->
    <div class="dashboard-header">
      <div class="header-content">
        <h1 class="title">
          Realisasi Program K3 
          <span class="subtitle">(s.d <span class="highlight">{{ new Date(selectedMonth).toLocaleDateString('id-ID', { month: 'long' }) }}</span> 2025)</span>
        </h1>
      </div>
      
      <!-- Month Filter -->
      <div class="filter-section">
        <label for="month">Pilih Bulan:</label>
        <input 
          type="month" 
          id="month"
          v-model="selectedMonth" 
          @change="loadData"
          class="month-input"
        />
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="loading">
      <div class="spinner"></div>
      <p>Memuat data...</p>
    </div>

    <!-- Program Cards Grid -->
    <div v-else class="programs-grid">
      <div 
        v-for="program in programs" 
        :key="program.id" 
        class="program-card"
      >
        <div class="program-icon">{{ program.icon }}</div>
        <h3 class="program-name">{{ program.name }}</h3>
        <div class="realization-box">
          <span class="realization-value">{{ program.realization }}</span>
        </div>
        <p class="program-target">{{ program.target }}</p>
      </div>
    </div>

    <!-- Footer Note -->
    <!-- <div class="footer-note">
      *Cek kesesuaian pada <strong>Dashboard Safira</strong>
    </div> -->
  </div>
</template>

<style scoped>
.program-k3-dashboard {
  padding: 1.5rem;
  background: linear-gradient(135deg, #0066cc 0%, #004c99 100%);
  min-height: 100vh;
}

.dashboard-header {
  text-align: center;
  margin-bottom: 2rem;
  color: white;
}

.header-content {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 2rem;
  margin-bottom: 1.5rem;
}

.logo {
  height: 60px;
}

.title {
  font-size: 2rem;
  font-weight: 700;
  margin: 0;
  color: white;
}

.subtitle {
  font-size: 1.25rem;
  font-weight: 600;
}

.highlight {
  color: #ff6b6b;
  font-weight: 700;
}

.filter-section {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  margin-top: 1.5rem;
}

.filter-section label {
  color: white;
  font-weight: 500;
}

.month-input {
  padding: 0.5rem 1rem;
  border: 2px solid white;
  border-radius: 8px;
  background: white;
  font-size: 1rem;
  cursor: pointer;
}

.loading {
  text-align: center;
  padding: 4rem;
  color: white;
}

.spinner {
  width: 50px;
  height: 50px;
  border: 4px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 1rem;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.programs-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 1.25rem;
  max-width: 1200px;
  margin: 0 auto;
}

.program-card {
  background: white;
  border-radius: 12px;
  padding: 1.25rem 1rem;
  text-align: center;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.program-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
}

.program-icon {
  font-size: 2.5rem;
  margin-bottom: 0.75rem;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
}

.program-name {
  font-size: 1rem;
  font-weight: 600;
  color: #1e40af;
  margin: 0 0 1rem 0;
  min-height: 2.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  line-height: 1.3;
}

.realization-box {
  background: #1e40af;
  border-radius: 8px;
  padding: 1rem;
  margin-bottom: 0.75rem;
  box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.1);
}

.realization-value {
  font-size: 2rem;
  font-weight: 700;
  color: white;
  display: block;
}

.program-target {
  font-size: 0.8rem;
  color: #64748b;
  margin: 0;
  line-height: 1.3;
}

.footer-note {
  text-align: center;
  margin-top: 3rem;
  color: white;
  font-size: 1rem;
  font-style: italic;
}

.footer-note strong {
  font-weight: 700;
}

/* Responsive */
@media (max-width: 768px) {
  .program-k3-dashboard {
    padding: 1rem;
  }

  .title {
    font-size: 1.5rem;
  }

  .subtitle {
    font-size: 1rem;
  }

  .programs-grid {
    grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
    gap: 1rem;
  }

  .program-card {
    padding: 1rem 0.75rem;
  }

  .program-icon {
    font-size: 2rem;
  }

  .program-name {
    font-size: 0.875rem;
    min-height: 2rem;
  }

  .realization-value {
    font-size: 1.5rem;
  }

  .program-target {
    font-size: 0.75rem;
  }
}
</style>
