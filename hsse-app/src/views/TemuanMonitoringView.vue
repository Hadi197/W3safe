<template>
  <div class="temuan-monitoring">
    <div class="page-header">
      <h1>Monitoring Temuan & Tindak Lanjut</h1>
      <p class="subtitle">Monitoring terpusat untuk semua temuan dan action items dari seluruh modul HSSE</p>
    </div>

    <!-- Filters -->
    <div class="filters-section">
      <el-card shadow="never">
        <el-form :inline="true" :model="filters">
          <el-form-item label="Periode">
            <el-date-picker
              v-model="dateRange"
              type="daterange"
              range-separator="s/d"
              start-placeholder="Tanggal Mulai"
              end-placeholder="Tanggal Selesai"
              format="DD/MM/YYYY"
              value-format="YYYY-MM-DD"
              @change="handleDateRangeChange"
            />
          </el-form-item>

          <el-form-item label="Unit">
            <el-select v-model="filters.unit_id" placeholder="Semua Unit" clearable @change="loadData">
              <el-option
                v-for="unit in units"
                :key="unit.id"
                :label="unit.nama"
                :value="unit.id"
              />
            </el-select>
          </el-form-item>

          <el-form-item label="Modul">
            <el-select v-model="filters.module" placeholder="Semua Modul" clearable @change="loadData">
              <el-option label="Safety Patrol" value="safety_patrol" />
              <el-option label="Management Walkthrough" value="management_walkthrough" />
              <el-option label="Silent Inspection" value="silent_inspection" />
              <el-option label="Safety Drill" value="safety_drill" />
              <el-option label="Safety Forum" value="safety_forum" />
            </el-select>
          </el-form-item>

          <el-form-item label="Prioritas">
            <el-select v-model="filters.prioritas" placeholder="Semua Prioritas" clearable @change="loadActionItems">
              <el-option label="Kritikal" value="kritikal">
                <el-tag type="danger" size="small">Kritikal</el-tag>
              </el-option>
              <el-option label="Tinggi" value="tinggi">
                <el-tag type="warning" size="small">Tinggi</el-tag>
              </el-option>
              <el-option label="Sedang" value="sedang">
                <el-tag type="info" size="small">Sedang</el-tag>
              </el-option>
              <el-option label="Rendah" value="rendah">
                <el-tag type="success" size="small">Rendah</el-tag>
              </el-option>
            </el-select>
          </el-form-item>

          <el-form-item label="Status">
            <el-select v-model="filters.status_action" placeholder="Semua Status" clearable @change="loadActionItems">
              <el-option label="Belum Mulai" value="belum_mulai" />
              <el-option label="Sedang Berjalan" value="sedang_berjalan" />
              <el-option label="Selesai" value="selesai" />
              <el-option label="Tertunda" value="tertunda" />
            </el-select>
          </el-form-item>

          <el-form-item>
            <el-checkbox v-model="filters.overdue_only" @change="loadActionItems">
              Hanya Overdue
            </el-checkbox>
          </el-form-item>

          <el-form-item>
            <el-button type="primary" :icon="RefreshRight" @click="loadData">Refresh</el-button>
          </el-form-item>
        </el-form>
      </el-card>
    </div>

    <!-- Statistics Cards -->
    <div class="statistics-cards">
      <el-row :gutter="20">
        <el-col :xs="24" :sm="12" :md="6">
          <el-card shadow="hover" class="stat-card">
            <div class="stat-content">
              <el-icon class="stat-icon" color="#409EFF"><Document /></el-icon>
              <div class="stat-info">
                <div class="stat-value">{{ statistics.total_inspeksi }}</div>
                <div class="stat-label">Total Inspeksi</div>
              </div>
            </div>
          </el-card>
        </el-col>

        <el-col :xs="24" :sm="12" :md="6">
          <el-card shadow="hover" class="stat-card">
            <div class="stat-content">
              <el-icon class="stat-icon" color="#F56C6C"><Warning /></el-icon>
              <div class="stat-info">
                <div class="stat-value">{{ statistics.total_temuan }}</div>
                <div class="stat-label">Total Temuan</div>
                <div class="stat-detail">
                  <el-tag type="danger" size="small">{{ statistics.temuan_kritis }} Kritis</el-tag>
                  <el-tag type="warning" size="small">{{ statistics.temuan_mayor }} Mayor</el-tag>
                  <el-tag type="info" size="small">{{ statistics.temuan_minor }} Minor</el-tag>
                </div>
              </div>
            </div>
          </el-card>
        </el-col>

        <el-col :xs="24" :sm="12" :md="6">
          <el-card shadow="hover" class="stat-card">
            <div class="stat-content">
              <el-icon class="stat-icon" color="#E6A23C"><Edit /></el-icon>
              <div class="stat-info">
                <div class="stat-value">{{ statistics.total_action_items }}</div>
                <div class="stat-label">Total Action Items</div>
                <div class="stat-detail">
                  <el-tag type="success" size="small">{{ statistics.action_items_completed }} Selesai</el-tag>
                  <el-tag type="info" size="small">{{ statistics.action_items_pending }} Pending</el-tag>
                </div>
              </div>
            </div>
          </el-card>
        </el-col>

        <el-col :xs="24" :sm="12" :md="6">
          <el-card shadow="hover" class="stat-card">
            <div class="stat-content">
              <el-icon class="stat-icon" :color="statistics.action_items_overdue > 0 ? '#F56C6C' : '#67C23A'">
                <Clock />
              </el-icon>
              <div class="stat-info">
                <div class="stat-value" :style="{ color: statistics.action_items_overdue > 0 ? '#F56C6C' : '#67C23A' }">
                  {{ statistics.action_items_overdue }}
                </div>
                <div class="stat-label">Overdue Items</div>
                <div class="stat-detail">
                  <el-progress 
                    :percentage="statistics.completion_rate" 
                    :color="getProgressColor(statistics.completion_rate)"
                  />
                </div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- Charts -->
    <el-row :gutter="20" class="charts-section">
      <el-col :xs="24" :md="12">
        <el-card shadow="never">
          <template #header>
            <div class="card-header">
              <span>Distribusi Prioritas</span>
            </div>
          </template>
          <div ref="priorityChartRef" style="height: 300px"></div>
        </el-card>
      </el-col>

      <el-col :xs="24" :md="12">
        <el-card shadow="never">
          <template #header>
            <div class="card-header">
              <span>Distribusi per Modul</span>
            </div>
          </template>
          <div ref="moduleChartRef" style="height: 300px"></div>
        </el-card>
      </el-col>
    </el-row>

    <!-- Unified Table -->
    <el-card shadow="never" class="data-section">
      <template #header>
        <div class="card-header">
          <span>Data Temuan & Tindak Lanjut</span>
          <el-button :icon="Download" @click="exportToExcel">Export Excel</el-button>
        </div>
      </template>

      <el-table 
        :data="paginatedTemuanList" 
        v-loading="loading"
        stripe
        border
        style="width: 100%"
        row-key="nomor"
        :row-class-name="getTemuanRowClass"
        :expand-row-keys="expandedRows"
        @expand-change="handleExpandChange"
        @row-click="handleRowClick"
        class="clickable-table"
      >
        <el-table-column type="expand">
          <template #default="{ row }">
            <div class="expansion-details">
              <!-- Temuan Details -->
              <div v-if="row.temuan_details && row.temuan_details.length > 0" class="detail-section">
                <h4>📋 Detail Temuan</h4>
                <el-table :data="row.temuan_details" border size="small">
                  <el-table-column type="index" label="#" width="50" align="center" />
                  <el-table-column label="Deskripsi Temuan" min-width="250">
                    <template #default="{ row: temuan }">
                      <div v-if="temuan.kondisi_tidak_aman">{{ temuan.kondisi_tidak_aman }}</div>
                      <div v-else-if="temuan.tindakan_tidak_aman">{{ temuan.tindakan_tidak_aman }}</div>
                      <div v-else-if="temuan.deskripsi">{{ temuan.deskripsi }}</div>
                      <div v-else-if="temuan.kategori_temuan">{{ temuan.kategori_temuan }}</div>
                      <div v-else>{{ temuan.temuan || '-' }}</div>
                    </template>
                  </el-table-column>
                  <el-table-column label="Lokasi" width="150">
                    <template #default="{ row: temuan }">
                      {{ temuan.lokasi || temuan.area || '-' }}
                    </template>
                  </el-table-column>
                  <el-table-column label="Kategori/Klasifikasi" width="150">
                    <template #default="{ row: temuan }">
                      {{ temuan.kategori || temuan.klasifikasi || temuan.tingkat_risiko || '-' }}
                    </template>
                  </el-table-column>
                  <el-table-column label="Prioritas" width="100" align="center">
                    <template #default="{ row: temuan }">
                      <el-tag v-if="temuan.prioritas" :type="getPrioritasTagType(temuan.prioritas)" size="small">
                        {{ getPrioritasLabel(temuan.prioritas) }}
                      </el-tag>
                      <span v-else>-</span>
                    </template>
                  </el-table-column>
                </el-table>
              </div>

              <!-- Action Items / Tindak Lanjut Details -->
              <div v-if="row.action_items && row.action_items.length > 0" class="detail-section">
                <h4>✅ Tindak Lanjut & Action Items</h4>
                <el-table 
                  :data="row.action_items" 
                  border
                  size="small"
                  :row-class-name="getActionItemRowClass"
                >
                  <el-table-column type="index" label="#" width="50" align="center" />
                  <el-table-column label="Temuan Terkait" min-width="200">
                    <template #default="{ row: item }">
                      {{ item.temuan || item.deskripsi_temuan || item.kondisi_tidak_aman || '-' }}
                    </template>
                  </el-table-column>
                  <el-table-column label="Tindakan/Rekomendasi" min-width="200">
                    <template #default="{ row: item }">
                      {{ item.tindakan || item.rekomendasi || item.tindak_lanjut || '-' }}
                    </template>
                  </el-table-column>
                  <el-table-column prop="pic" label="PIC" width="150" />
                  <el-table-column label="Target Date" width="130" align="center">
                    <template #default="{ row: item }">
                      <div v-if="item.target_date && item.target_date !== '-'">
                        <div>{{ formatDate(item.target_date) }}</div>
                        <el-tag 
                          v-if="item.daysUntilDue !== undefined"
                          :type="getDaysUntilDueTagType(item.daysUntilDue)"
                          size="small"
                          style="margin-top: 4px"
                        >
                          {{ getDaysUntilDueLabel(item.daysUntilDue) }}
                        </el-tag>
                      </div>
                      <span v-else>-</span>
                    </template>
                  </el-table-column>
                  <el-table-column label="Prioritas" width="100" align="center">
                    <template #default="{ row: item }">
                      <el-tag v-if="item.prioritas" :type="getPrioritasTagType(item.prioritas)" size="small">
                        {{ getPrioritasLabel(item.prioritas) }}
                      </el-tag>
                      <span v-else>-</span>
                    </template>
                  </el-table-column>
                  <el-table-column label="Status" width="140" align="center">
                    <template #default="{ row: item }">
                      <el-tag :type="getActionStatusTagType(item.status)" size="small">
                        {{ getActionStatusLabel(item.status) }}
                      </el-tag>
                      <el-tag v-if="item.overdue" type="danger" size="small" style="margin-left: 4px">
                        OVERDUE
                      </el-tag>
                    </template>
                  </el-table-column>
                </el-table>
              </div>

              <!-- No Data -->
              <div v-if="(!row.temuan_details || row.temuan_details.length === 0) && (!row.action_items || row.action_items.length === 0)" class="no-details">
                <el-empty description="Tidak ada detail temuan dan tindak lanjut" :image-size="60" />
              </div>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column prop="nomor" label="Nomor" width="180" fixed />
        <el-table-column prop="moduleLabel" label="Modul" width="160">
          <template #default="{ row }">
            <el-tag :type="getModuleTagType(row.module)">{{ row.moduleLabel }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="tanggal" label="Tanggal" width="120">
          <template #default="{ row }">
            {{ formatDate(row.tanggal) }}
          </template>
        </el-table-column>
        <el-table-column prop="unit" label="Unit" width="150" />
        <el-table-column prop="area" label="Area" width="180" show-overflow-tooltip />
        <el-table-column prop="deskripsi" label="Deskripsi" min-width="200" show-overflow-tooltip />
        <el-table-column label="Temuan" min-width="250" show-overflow-tooltip>
          <template #default="{ row }">
            {{ row.temuan_text || '-' }}
          </template>
        </el-table-column>
        <el-table-column label="Tindak Lanjut" min-width="250" show-overflow-tooltip>
          <template #default="{ row }">
            {{ row.tindak_lanjut_text || '-' }}
          </template>
        </el-table-column>
        <el-table-column prop="jumlah_temuan" label="Total Temuan" width="100" align="center" />
        <el-table-column label="Kritikal" width="80" align="center">
          <template #default="{ row }">
            <el-tag v-if="row.temuan_kritis > 0" type="danger" size="small">{{ row.temuan_kritis }}</el-tag>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column label="Mayor" width="80" align="center">
          <template #default="{ row }">
            <el-tag v-if="row.temuan_mayor > 0" type="warning" size="small">{{ row.temuan_mayor }}</el-tag>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column label="Minor" width="80" align="center">
          <template #default="{ row }">
            <el-tag v-if="row.temuan_minor > 0" type="info" size="small">{{ row.temuan_minor }}</el-tag>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column label="Action Items" width="110" align="center">
          <template #default="{ row }">
            <el-badge :value="row.action_items.length" :max="99" :type="row.action_items.length > 0 ? 'primary' : 'info'">
              <el-icon><List /></el-icon>
            </el-badge>
          </template>
        </el-table-column>
        <el-table-column prop="pic" label="PIC" width="150" show-overflow-tooltip />
        <el-table-column prop="status" label="Status" width="130" fixed="right">
          <template #default="{ row }">
            <el-tag :type="getStatusTagType(row.status)">
              {{ getStatusLabel(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination-container">
        <el-pagination
          v-model:current-page="currentPage"
          :page-size="pageSize"
          :total="temuanList.length"
          layout="total, prev, pager, next, jumper"
          @current-change="handlePageChange"
        />
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { 
  Document, Warning, Edit, Clock, Download, List, RefreshRight 
} from '@element-plus/icons-vue'
import * as echarts from 'echarts'
import * as XLSX from 'xlsx'
import { temuanMonitoringService, type TemuanItem, type ActionItemDetail, type TemuanStatistics } from '@/services/temuan-monitoring.service'
import { unitsService, type Unit } from '@/services/api/units.service'

// Router
const router = useRouter()

// Data
const loading = ref(false)
const units = ref<Unit[]>([])
const temuanList = ref<TemuanItem[]>([])
const actionItemsList = ref<ActionItemDetail[]>([])
const statistics = ref<TemuanStatistics>({
  total_inspeksi: 0,
  total_temuan: 0,
  temuan_kritis: 0,
  temuan_mayor: 0,
  temuan_minor: 0,
  total_action_items: 0,
  action_items_completed: 0,
  action_items_pending: 0,
  action_items_overdue: 0,
  completion_rate: 0
})

// Filters
const dateRange = ref<[string, string] | null>(null)
const filters = ref({
  start_date: undefined as string | undefined,
  end_date: undefined as string | undefined,
  unit_id: undefined as string | undefined,
  module: undefined as string | undefined,
  prioritas: undefined as string | undefined,
  status_action: undefined as string | undefined,
  overdue_only: false
})

// Pagination
const currentPage = ref(1)
const pageSize = ref(20)

// Expanded rows
const expandedRows = ref<string[]>([])

// Charts
const priorityChartRef = ref<HTMLElement>()
const moduleChartRef = ref<HTMLElement>()
let priorityChart: echarts.ECharts | null = null
let moduleChart: echarts.ECharts | null = null

// Computed
const paginatedTemuanList = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  const end = start + pageSize.value
  return temuanList.value.slice(start, end)
})

const paginatedActionItems = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  const end = start + pageSize.value
  return actionItemsList.value.slice(start, end)
})

// Methods
const loadUnits = async () => {
  try {
    units.value = await unitsService.getAll()
  } catch (error) {
    console.error('Error loading units:', error)
    ElMessage.error('Gagal memuat data unit')
  }
}

const loadData = async () => {
  loading.value = true
  try {
    console.log('Loading temuan data with filters:', filters.value)
    
    // Load temuan list
    temuanList.value = await temuanMonitoringService.getAllTemuan({
      start_date: filters.value.start_date,
      end_date: filters.value.end_date,
      unit_id: filters.value.unit_id,
      module: filters.value.module
    })

    console.log('Temuan data loaded:', temuanList.value.length, 'items')
    console.log('First 3 items:', temuanList.value.slice(0, 3))

    // Load action items
    await loadActionItems()

    // Load statistics
    statistics.value = await temuanMonitoringService.getStatistics({
      start_date: filters.value.start_date,
      end_date: filters.value.end_date,
      unit_id: filters.value.unit_id,
      module: filters.value.module
    })

    // Load charts
    await nextTick()
    loadCharts()

    ElMessage.success('Data berhasil dimuat')
  } catch (error) {
    console.error('Error loading data:', error)
    ElMessage.error('Gagal memuat data')
  } finally {
    loading.value = false
  }
}

const loadActionItems = async () => {
  try {
    actionItemsList.value = await temuanMonitoringService.getAllActionItems({
      start_date: filters.value.start_date,
      end_date: filters.value.end_date,
      unit_id: filters.value.unit_id,
      module: filters.value.module,
      prioritas: filters.value.prioritas,
      status: filters.value.status_action,
      overdue_only: filters.value.overdue_only
    })
  } catch (error) {
    console.error('Error loading action items:', error)
    throw error
  }
}

const loadCharts = async () => {
  try {
    // Priority Distribution Chart
    const priorityData = await temuanMonitoringService.getPriorityDistribution({
      start_date: filters.value.start_date,
      end_date: filters.value.end_date,
      unit_id: filters.value.unit_id,
      module: filters.value.module
    })

    if (priorityChartRef.value) {
      if (!priorityChart) {
        priorityChart = echarts.init(priorityChartRef.value)
      }

      priorityChart.setOption({
        tooltip: {
          trigger: 'item',
          formatter: '{b}: {c} ({d}%)'
        },
        legend: {
          bottom: '0%',
          left: 'center'
        },
        series: [
          {
            type: 'pie',
            radius: ['40%', '70%'],
            avoidLabelOverlap: false,
            itemStyle: {
              borderRadius: 10,
              borderColor: '#fff',
              borderWidth: 2
            },
            label: {
              show: false,
              position: 'center'
            },
            emphasis: {
              label: {
                show: true,
                fontSize: 20,
                fontWeight: 'bold'
              }
            },
            labelLine: {
              show: false
            },
            data: [
              { value: priorityData.find(d => d.prioritas === 'kritikal')?.count || 0, name: 'Kritikal', itemStyle: { color: '#F56C6C' } },
              { value: priorityData.find(d => d.prioritas === 'tinggi')?.count || 0, name: 'Tinggi', itemStyle: { color: '#E6A23C' } },
              { value: priorityData.find(d => d.prioritas === 'sedang')?.count || 0, name: 'Sedang', itemStyle: { color: '#409EFF' } },
              { value: priorityData.find(d => d.prioritas === 'rendah')?.count || 0, name: 'Rendah', itemStyle: { color: '#67C23A' } }
            ]
          }
        ]
      })
    }

    // Module Distribution Chart
    const moduleData = await temuanMonitoringService.getModuleDistribution({
      start_date: filters.value.start_date,
      end_date: filters.value.end_date,
      unit_id: filters.value.unit_id
    })

    if (moduleChartRef.value) {
      if (!moduleChart) {
        moduleChart = echarts.init(moduleChartRef.value)
      }

      moduleChart.setOption({
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'value'
        },
        yAxis: {
          type: 'category',
          data: moduleData.map(m => m.label)
        },
        series: [
          {
            type: 'bar',
            data: moduleData.map(m => m.count),
            itemStyle: {
              color: '#409EFF'
            },
            label: {
              show: true,
              position: 'right'
            }
          }
        ]
      })
    }
  } catch (error) {
    console.error('Error loading charts:', error)
  }
}

const handleDateRangeChange = (value: [string, string] | null) => {
  if (value) {
    filters.value.start_date = value[0]
    filters.value.end_date = value[1]
  } else {
    filters.value.start_date = undefined
    filters.value.end_date = undefined
  }
  loadData()
}

const handlePageChange = () => {
  // Pagination handled by computed property
}

const handleExpandChange = (row: TemuanItem, expandedRowsData: TemuanItem[]) => {
  expandedRows.value = expandedRowsData.map(r => r.nomor)
}

const handleRowClick = (row: TemuanItem) => {
  // Map module names to routes
  const moduleRoutes: Record<string, string> = {
    safety_patrol: '/safety-patrol',
    management_walkthrough: '/management-walkthrough',
    silent_inspection: '/silent-inspection',
    safety_drill: '/safety-drill',
    safety_forum: '/safety-forum'
  }

  const route = moduleRoutes[row.module]
  if (route) {
    // Navigate to the module with id as query parameter
    router.push({
      path: route,
      query: { id: row.id, mode: 'edit' }
    })
  } else {
    ElMessage.warning('Modul tidak ditemukan')
  }
}

const getTemuanRowClass = ({ row }: { row: TemuanItem }) => {
  // Highlight rows with overdue action items
  const hasOverdue = row.action_items.some(item => item.overdue)
  if (hasOverdue) return 'has-overdue-items'
  return ''
}

const handleSummaryPageChange = () => {
  // Removed - no longer needed
}

const handleActionItemsPageChange = () => {
  // Removed - no longer needed
}

const exportToExcel = () => {
  try {
    // Export unified data with action items
    const data: any[] = []
    
    temuanList.value.forEach(item => {
      if (item.action_items && item.action_items.length > 0) {
        // Add row for each action item
        item.action_items.forEach((actionItem, index) => {
          data.push({
            'Nomor': item.nomor,
            'Modul': item.moduleLabel,
            'Tanggal': formatDate(item.tanggal),
            'Unit': item.unit,
            'Area': item.area,
            'Total Temuan': item.jumlah_temuan,
            'Kritikal': item.temuan_kritis,
            'Mayor': item.temuan_mayor,
            'Minor': item.temuan_minor,
            'PIC Inspeksi': item.pic,
            'Status Inspeksi': getStatusLabel(item.status),
            'Action Item #': index + 1,
            'Temuan': actionItem.temuan,
            'Tindakan': actionItem.tindakan,
            'PIC Tindakan': actionItem.pic,
            'Target Date': actionItem.target_date !== '-' ? formatDate(actionItem.target_date) : '-',
            'Prioritas': getPrioritasLabel(actionItem.prioritas),
            'Status Tindakan': getActionStatusLabel(actionItem.status),
            'Overdue': actionItem.overdue ? 'YA' : 'TIDAK'
          })
        })
      } else {
        // Add row without action items
        data.push({
          'Nomor': item.nomor,
          'Modul': item.moduleLabel,
          'Tanggal': formatDate(item.tanggal),
          'Unit': item.unit,
          'Area': item.area,
          'Total Temuan': item.jumlah_temuan,
          'Kritikal': item.temuan_kritis,
          'Mayor': item.temuan_mayor,
          'Minor': item.temuan_minor,
          'PIC Inspeksi': item.pic,
          'Status Inspeksi': getStatusLabel(item.status),
          'Action Item #': '-',
          'Temuan': '-',
          'Tindakan': '-',
          'PIC Tindakan': '-',
          'Target Date': '-',
          'Prioritas': '-',
          'Status Tindakan': '-',
          'Overdue': '-'
        })
      }
    })

    const filename = `Temuan_Monitoring_${new Date().toISOString().split('T')[0]}.xlsx`
    const ws = XLSX.utils.json_to_sheet(data)
    const wb = XLSX.utils.book_new()
    XLSX.utils.book_append_sheet(wb, ws, 'Data')
    XLSX.writeFile(wb, filename)

    ElMessage.success('Data berhasil diexport')
  } catch (error) {
    console.error('Error exporting to Excel:', error)
    ElMessage.error('Gagal export data')
  }
}

// Helper methods
const formatDate = (dateString: string) => {
  if (!dateString || dateString === '-') return '-'
  const date = new Date(dateString)
  return date.toLocaleDateString('id-ID', { day: '2-digit', month: '2-digit', year: 'numeric' })
}

const getModuleTagType = (module: string) => {
  const types: Record<string, any> = {
    safety_patrol: 'primary',
    management_walkthrough: 'success',
    silent_inspection: 'warning',
    safety_drill: 'danger',
    safety_forum: 'info'
  }
  return types[module] || ''
}

const getStatusTagType = (status: string) => {
  const types: Record<string, any> = {
    completed: 'success',
    in_progress: 'warning',
    planned: 'info',
    cancelled: 'danger'
  }
  return types[status] || 'info'
}

const getStatusLabel = (status: string) => {
  const labels: Record<string, string> = {
    completed: 'Selesai',
    in_progress: 'Berjalan',
    planned: 'Direncanakan',
    cancelled: 'Dibatalkan'
  }
  return labels[status] || status
}

const getPrioritasTagType = (prioritas: string) => {
  const types: Record<string, any> = {
    kritikal: 'danger',
    tinggi: 'warning',
    sedang: 'info',
    rendah: 'success'
  }
  return types[prioritas] || 'info'
}

const getPrioritasLabel = (prioritas: string) => {
  const labels: Record<string, string> = {
    kritikal: 'Kritikal',
    tinggi: 'Tinggi',
    sedang: 'Sedang',
    rendah: 'Rendah'
  }
  return labels[prioritas] || prioritas
}

const getActionStatusTagType = (status: string) => {
  const types: Record<string, any> = {
    selesai: 'success',
    sedang_berjalan: 'warning',
    belum_mulai: 'info',
    tertunda: 'danger'
  }
  return types[status] || 'info'
}

const getActionStatusLabel = (status: string) => {
  const labels: Record<string, string> = {
    selesai: 'Selesai',
    sedang_berjalan: 'Berjalan',
    belum_mulai: 'Belum Mulai',
    tertunda: 'Tertunda'
  }
  return labels[status] || status
}

const getDaysUntilDueTagType = (days: number) => {
  if (days < 0) return 'danger'
  if (days <= 7) return 'warning'
  return 'success'
}

const getDaysUntilDueLabel = (days: number) => {
  if (days < 0) return `${Math.abs(days)} hari terlambat`
  if (days === 0) return 'Hari ini'
  if (days === 1) return 'Besok'
  return `${days} hari lagi`
}

const getActionItemRowClass = ({ row }: { row: ActionItemDetail }) => {
  if (row.overdue) return 'overdue-row'
  return ''
}

const getProgressColor = (percentage: number) => {
  if (percentage < 50) return '#F56C6C'
  if (percentage < 80) return '#E6A23C'
  return '#67C23A'
}

// Lifecycle
onMounted(async () => {
  await loadUnits()
  await loadData()

  // Handle window resize for charts
  window.addEventListener('resize', () => {
    priorityChart?.resize()
    moduleChart?.resize()
  })
})
</script>

<style scoped>
.temuan-monitoring {
  padding: 20px;
}

.page-header {
  margin-bottom: 20px;
}

.page-header h1 {
  margin: 0 0 8px 0;
  font-size: 28px;
  font-weight: bold;
}

.subtitle {
  color: #909399;
  margin: 0;
}

.filters-section {
  margin-bottom: 20px;
}

.statistics-cards {
  margin-bottom: 20px;
}

.stat-card {
  cursor: pointer;
  transition: transform 0.2s;
}

.stat-card:hover {
  transform: translateY(-4px);
}

.stat-content {
  display: flex;
  align-items: center;
  gap: 16px;
}

.stat-icon {
  font-size: 48px;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 32px;
  font-weight: bold;
  line-height: 1;
  margin-bottom: 8px;
}

.stat-label {
  color: #909399;
  font-size: 14px;
  margin-bottom: 8px;
}

.stat-detail {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.charts-section {
  margin-bottom: 20px;
}

.data-section {
  margin-bottom: 20px;
}

.table-actions {
  margin-bottom: 16px;
  display: flex;
  justify-content: flex-end;
}

.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}

:deep(.overdue-row) {
  background-color: #fef0f0 !important;
}

:deep(.el-table .overdue-row:hover > td) {
  background-color: #fde2e2 !important;
}

:deep(.has-overdue-items) {
  background-color: #fff7e6 !important;
}

:deep(.el-table .has-overdue-items:hover > td) {
  background-color: #fff0d1 !important;
}

/* Clickable table rows */
:deep(.clickable-table .el-table__row) {
  cursor: pointer;
  transition: background-color 0.2s;
}

:deep(.clickable-table .el-table__row:hover > td) {
  background-color: #f5f7fa !important;
}

.action-items-expansion {
  padding: 20px;
  background-color: #f5f7fa;
}

.action-items-expansion h4 {
  margin: 0 0 16px 0;
  font-size: 16px;
  color: #303133;
}

.expansion-details {
  padding: 20px;
  background-color: #f5f7fa;
}

.detail-section {
  margin-bottom: 24px;
}

.detail-section:last-child {
  margin-bottom: 0;
}

.detail-section h4 {
  margin: 0 0 12px 0;
  font-size: 15px;
  font-weight: 600;
  color: #303133;
  padding-bottom: 8px;
  border-bottom: 2px solid #409eff;
}

.no-details {
  padding: 20px;
  text-align: center;
}

.no-action-items {
  padding: 20px;
  text-align: center;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: bold;
  font-size: 16px;
}
</style>
