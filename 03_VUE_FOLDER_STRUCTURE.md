# 📁 Vue.js Folder Structure - Aplikasi Implementasi HSSE

## Complete Project Structure

```
hsse-app/
├── public/
│   ├── favicon.ico
│   └── logo.png
│
├── src/
│   ├── assets/
│   │   ├── images/
│   │   │   ├── logo.svg
│   │   │   ├── icons/
│   │   │   │   ├── briefing.svg
│   │   │   │   ├── inspection.svg
│   │   │   │   ├── forum.svg
│   │   │   │   ├── walkthrough.svg
│   │   │   │   ├── patrol.svg
│   │   │   │   ├── induction.svg
│   │   │   │   └── drill.svg
│   │   │   └── illustrations/
│   │   │       ├── empty-state.svg
│   │   │       └── error.svg
│   │   │
│   │   └── styles/
│   │       ├── main.css
│   │       ├── variables.css
│   │       ├── typography.css
│   │       └── utilities.css
│   │
│   ├── components/
│   │   ├── common/
│   │   │   ├── AppHeader.vue
│   │   │   ├── AppSidebar.vue
│   │   │   ├── AppFooter.vue
│   │   │   ├── AppBreadcrumb.vue
│   │   │   ├── LoadingSpinner.vue
│   │   │   ├── EmptyState.vue
│   │   │   ├── ErrorMessage.vue
│   │   │   └── ConfirmDialog.vue
│   │   │
│   │   ├── forms/
│   │   │   ├── BaseInput.vue
│   │   │   ├── BaseTextarea.vue
│   │   │   ├── BaseSelect.vue
│   │   │   ├── BaseCheckbox.vue
│   │   │   ├── BaseDatePicker.vue
│   │   │   ├── BaseTimePicker.vue
│   │   │   ├── BaseFileUpload.vue
│   │   │   └── BaseMultiSelect.vue
│   │   │
│   │   ├── hsse/
│   │   │   ├── HSSECard.vue
│   │   │   ├── HSSEForm.vue
│   │   │   ├── HSSEList.vue
│   │   │   ├── HSSEDetail.vue
│   │   │   ├── HSSEStatusBadge.vue
│   │   │   ├── HSSEFilterBar.vue
│   │   │   ├── HSSESearchBar.vue
│   │   │   ├── HSSEPagination.vue
│   │   │   ├── HSSEExportButton.vue
│   │   │   └── HSSEApprovalFlow.vue
│   │   │
│   │   ├── dashboard/
│   │   │   ├── DashboardStats.vue
│   │   │   ├── DashboardChart.vue
│   │   │   ├── DashboardTrendChart.vue
│   │   │   ├── DashboardPieChart.vue
│   │   │   ├── DashboardRecentActivity.vue
│   │   │   └── DashboardComplianceRate.vue
│   │   │
│   │   └── layouts/
│   │       ├── DefaultLayout.vue
│   │       ├── AuthLayout.vue
│   │       └── PrintLayout.vue
│   │
│   ├── views/
│   │   ├── auth/
│   │   │   ├── LoginView.vue
│   │   │   ├── ForgotPasswordView.vue
│   │   │   └── ResetPasswordView.vue
│   │   │
│   │   ├── dashboard/
│   │   │   └── DashboardView.vue
│   │   │
│   │   ├── hsse/
│   │   │   ├── safety-briefing/
│   │   │   │   ├── SafetyBriefingList.vue
│   │   │   │   ├── SafetyBriefingCreate.vue
│   │   │   │   ├── SafetyBriefingEdit.vue
│   │   │   │   └── SafetyBriefingDetail.vue
│   │   │   │
│   │   │   ├── silent-inspection/
│   │   │   │   ├── SilentInspectionList.vue
│   │   │   │   ├── SilentInspectionCreate.vue
│   │   │   │   ├── SilentInspectionEdit.vue
│   │   │   │   └── SilentInspectionDetail.vue
│   │   │   │
│   │   │   ├── safety-forum/
│   │   │   │   ├── SafetyForumList.vue
│   │   │   │   ├── SafetyForumCreate.vue
│   │   │   │   ├── SafetyForumEdit.vue
│   │   │   │   └── SafetyForumDetail.vue
│   │   │   │
│   │   │   ├── management-walkthrough/
│   │   │   │   ├── ManagementWalkthroughList.vue
│   │   │   │   ├── ManagementWalkthroughCreate.vue
│   │   │   │   ├── ManagementWalkthroughEdit.vue
│   │   │   │   └── ManagementWalkthroughDetail.vue
│   │   │   │
│   │   │   ├── safety-patrol/
│   │   │   │   ├── SafetyPatrolList.vue
│   │   │   │   ├── SafetyPatrolCreate.vue
│   │   │   │   ├── SafetyPatrolEdit.vue
│   │   │   │   └── SafetyPatrolDetail.vue
│   │   │   │
│   │   │   ├── safety-induction/
│   │   │   │   ├── SafetyInductionList.vue
│   │   │   │   ├── SafetyInductionCreate.vue
│   │   │   │   ├── SafetyInductionEdit.vue
│   │   │   │   ├── SafetyInductionDetail.vue
│   │   │   │   └── SafetyInductionExpiry.vue
│   │   │   │
│   │   │   └── safety-drill/
│   │   │       ├── SafetyDrillList.vue
│   │   │       ├── SafetyDrillCreate.vue
│   │   │       ├── SafetyDrillEdit.vue
│   │   │       └── SafetyDrillDetail.vue
│   │   │
│   │   ├── master/
│   │   │   ├── units/
│   │   │   │   ├── UnitList.vue
│   │   │   │   ├── UnitCreate.vue
│   │   │   │   └── UnitEdit.vue
│   │   │   │
│   │   │   ├── wilayah/
│   │   │   │   ├── WilayahList.vue
│   │   │   │   ├── WilayahCreate.vue
│   │   │   │   └── WilayahEdit.vue
│   │   │   │
│   │   │   ├── pegawai/
│   │   │   │   ├── PegawaiList.vue
│   │   │   │   ├── PegawaiCreate.vue
│   │   │   │   ├── PegawaiEdit.vue
│   │   │   │   └── PegawaiDetail.vue
│   │   │   │
│   │   │   └── tamu/
│   │   │       ├── TamuList.vue
│   │   │       └── TamuCreate.vue
│   │   │
│   │   ├── reports/
│   │   │   ├── ReportDashboard.vue
│   │   │   ├── ReportBriefing.vue
│   │   │   ├── ReportInspection.vue
│   │   │   ├── ReportPatrol.vue
│   │   │   └── ReportCompliance.vue
│   │   │
│   │   ├── profile/
│   │   │   └── ProfileView.vue
│   │   │
│   │   └── NotFoundView.vue
│   │
│   ├── router/
│   │   ├── index.js
│   │   ├── guards.js
│   │   └── routes/
│   │       ├── auth.js
│   │       ├── dashboard.js
│   │       ├── hsse.js
│   │       ├── master.js
│   │       └── reports.js
│   │
│   ├── stores/
│   │   ├── index.js
│   │   ├── auth.js
│   │   ├── user.js
│   │   ├── units.js
│   │   ├── wilayah.js
│   │   ├── pegawai.js
│   │   ├── safetyBriefing.js
│   │   ├── silentInspection.js
│   │   ├── safetyForum.js
│   │   ├── managementWalkthrough.js
│   │   ├── safetyPatrol.js
│   │   ├── safetyInduction.js
│   │   ├── safetyDrill.js
│   │   └── dashboard.js
│   │
│   ├── services/
│   │   ├── api/
│   │   │   ├── supabase.js
│   │   │   ├── auth.service.js
│   │   │   ├── units.service.js
│   │   │   ├── wilayah.service.js
│   │   │   ├── pegawai.service.js
│   │   │   ├── tamu.service.js
│   │   │   ├── safetyBriefing.service.js
│   │   │   ├── silentInspection.service.js
│   │   │   ├── safetyForum.service.js
│   │   │   ├── managementWalkthrough.service.js
│   │   │   ├── safetyPatrol.service.js
│   │   │   ├── safetyInduction.service.js
│   │   │   ├── safetyDrill.service.js
│   │   │   └── storage.service.js
│   │   │
│   │   └── utils/
│   │       ├── validation.js
│   │       ├── formatting.js
│   │       └── export.js
│   │
│   ├── composables/
│   │   ├── useAuth.js
│   │   ├── useForm.js
│   │   ├── usePagination.js
│   │   ├── useFilter.js
│   │   ├── useFileUpload.js
│   │   ├── useNotification.js
│   │   ├── useConfirm.js
│   │   └── useChart.js
│   │
│   ├── utils/
│   │   ├── constants.js
│   │   ├── helpers.js
│   │   ├── date.js
│   │   ├── validators.js
│   │   └── formatters.js
│   │
│   ├── plugins/
│   │   ├── chart.js
│   │   ├── toast.js
│   │   └── directives.js
│   │
│   ├── App.vue
│   └── main.js
│
├── .env.example
├── .env.local
├── .gitignore
├── package.json
├── vite.config.js
├── index.html
└── README.md
```

---

## Detailed File Descriptions

### 1. Main Entry Points

#### `src/main.js`
```javascript
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import './assets/styles/main.css'

// Plugins
import chartPlugin from './plugins/chart'
import toastPlugin from './plugins/toast'
import directivesPlugin from './plugins/directives'

const app = createApp(App)
const pinia = createPinia()

app.use(pinia)
app.use(router)
app.use(chartPlugin)
app.use(toastPlugin)
app.use(directivesPlugin)

app.mount('#app')
```

#### `src/App.vue`
```vue
<template>
  <router-view />
</template>

<script setup>
import { onMounted } from 'vue'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()

onMounted(async () => {
  await authStore.initAuth()
})
</script>
```

---

### 2. Router Configuration

#### `src/router/index.js`
```javascript
import { createRouter, createWebHistory } from 'vue-router'
import { authGuard, roleGuard } from './guards'

// Import route modules
import authRoutes from './routes/auth'
import dashboardRoutes from './routes/dashboard'
import hsseRoutes from './routes/hsse'
import masterRoutes from './routes/master'
import reportRoutes from './routes/reports'

const routes = [
  {
    path: '/',
    redirect: '/dashboard'
  },
  ...authRoutes,
  ...dashboardRoutes,
  ...hsseRoutes,
  ...masterRoutes,
  ...reportRoutes,
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: () => import('@/views/NotFoundView.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// Global navigation guard
router.beforeEach(authGuard)

export default router
```

#### `src/router/guards.js`
```javascript
import { useAuthStore } from '@/stores/auth'

export const authGuard = async (to, from, next) => {
  const authStore = useAuthStore()
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth)

  if (requiresAuth && !authStore.isAuthenticated) {
    next({ name: 'Login', query: { redirect: to.fullPath } })
  } else {
    next()
  }
}

export const roleGuard = (requiredRoles) => {
  return (to, from, next) => {
    const authStore = useAuthStore()
    const userRole = authStore.user?.role

    if (requiredRoles.includes(userRole)) {
      next()
    } else {
      next({ name: 'NotFound' })
    }
  }
}
```

#### `src/router/routes/hsse.js`
```javascript
export default [
  {
    path: '/hsse',
    component: () => import('@/components/layouts/DefaultLayout.vue'),
    meta: { requiresAuth: true },
    children: [
      // Safety Briefing
      {
        path: 'safety-briefing',
        name: 'SafetyBriefingList',
        component: () => import('@/views/hsse/safety-briefing/SafetyBriefingList.vue')
      },
      {
        path: 'safety-briefing/create',
        name: 'SafetyBriefingCreate',
        component: () => import('@/views/hsse/safety-briefing/SafetyBriefingCreate.vue')
      },
      {
        path: 'safety-briefing/:id/edit',
        name: 'SafetyBriefingEdit',
        component: () => import('@/views/hsse/safety-briefing/SafetyBriefingEdit.vue')
      },
      {
        path: 'safety-briefing/:id',
        name: 'SafetyBriefingDetail',
        component: () => import('@/views/hsse/safety-briefing/SafetyBriefingDetail.vue')
      },
      
      // Silent Inspection
      {
        path: 'silent-inspection',
        name: 'SilentInspectionList',
        component: () => import('@/views/hsse/silent-inspection/SilentInspectionList.vue')
      },
      // ... other inspection routes
      
      // Safety Forum
      {
        path: 'safety-forum',
        name: 'SafetyForumList',
        component: () => import('@/views/hsse/safety-forum/SafetyForumList.vue')
      },
      // ... other forum routes
      
      // Management Walkthrough
      {
        path: 'management-walkthrough',
        name: 'ManagementWalkthroughList',
        component: () => import('@/views/hsse/management-walkthrough/ManagementWalkthroughList.vue')
      },
      // ... other walkthrough routes
      
      // Safety Patrol
      {
        path: 'safety-patrol',
        name: 'SafetyPatrolList',
        component: () => import('@/views/hsse/safety-patrol/SafetyPatrolList.vue')
      },
      // ... other patrol routes
      
      // Safety Induction
      {
        path: 'safety-induction',
        name: 'SafetyInductionList',
        component: () => import('@/views/hsse/safety-induction/SafetyInductionList.vue')
      },
      {
        path: 'safety-induction/expiry',
        name: 'SafetyInductionExpiry',
        component: () => import('@/views/hsse/safety-induction/SafetyInductionExpiry.vue')
      },
      // ... other induction routes
      
      // Safety Drill
      {
        path: 'safety-drill',
        name: 'SafetyDrillList',
        component: () => import('@/views/hsse/safety-drill/SafetyDrillList.vue')
      },
      // ... other drill routes
    ]
  }
]
```

---

### 3. Stores (Pinia)

#### `src/stores/auth.js`
```javascript
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { authService } from '@/services/api/auth.service'

export const useAuthStore = defineStore('auth', () => {
  const user = ref(null)
  const session = ref(null)
  const loading = ref(false)

  const isAuthenticated = computed(() => !!user.value)
  const isAdmin = computed(() => user.value?.role === 'admin')
  const isManager = computed(() => user.value?.role === 'manager')

  const initAuth = async () => {
    loading.value = true
    try {
      const { data } = await authService.getCurrentUser()
      if (data) {
        user.value = data.user
        session.value = data.session
      }
    } catch (error) {
      console.error('Init auth error:', error)
    } finally {
      loading.value = false
    }
  }

  const login = async (email, password) => {
    loading.value = true
    try {
      const { data, error } = await authService.login(email, password)
      if (error) throw error
      
      user.value = data.user
      session.value = data.session
      return { success: true }
    } catch (error) {
      return { success: false, error: error.message }
    } finally {
      loading.value = false
    }
  }

  const logout = async () => {
    await authService.logout()
    user.value = null
    session.value = null
  }

  return {
    user,
    session,
    loading,
    isAuthenticated,
    isAdmin,
    isManager,
    initAuth,
    login,
    logout
  }
})
```

#### `src/stores/safetyBriefing.js`
```javascript
import { defineStore } from 'pinia'
import { ref } from 'vue'
import { safetyBriefingService } from '@/services/api/safetyBriefing.service'

export const useSafetyBriefingStore = defineStore('safetyBriefing', () => {
  const briefings = ref([])
  const currentBriefing = ref(null)
  const loading = ref(false)
  const error = ref(null)
  const pagination = ref({
    page: 1,
    pageSize: 20,
    totalCount: 0
  })

  const fetchBriefings = async (filters = {}) => {
    loading.value = true
    error.value = null
    try {
      const { data, count } = await safetyBriefingService.getAll(filters, pagination.value)
      briefings.value = data
      pagination.value.totalCount = count
    } catch (e) {
      error.value = e.message
    } finally {
      loading.value = false
    }
  }

  const fetchBriefingById = async (id) => {
    loading.value = true
    error.value = null
    try {
      const { data } = await safetyBriefingService.getById(id)
      currentBriefing.value = data
    } catch (e) {
      error.value = e.message
    } finally {
      loading.value = false
    }
  }

  const createBriefing = async (briefingData) => {
    loading.value = true
    error.value = null
    try {
      const { data } = await safetyBriefingService.create(briefingData)
      return { success: true, data }
    } catch (e) {
      error.value = e.message
      return { success: false, error: e.message }
    } finally {
      loading.value = false
    }
  }

  const updateBriefing = async (id, briefingData) => {
    loading.value = true
    error.value = null
    try {
      const { data } = await safetyBriefingService.update(id, briefingData)
      return { success: true, data }
    } catch (e) {
      error.value = e.message
      return { success: false, error: e.message }
    } finally {
      loading.value = false
    }
  }

  const deleteBriefing = async (id) => {
    loading.value = true
    error.value = null
    try {
      await safetyBriefingService.delete(id)
      return { success: true }
    } catch (e) {
      error.value = e.message
      return { success: false, error: e.message }
    } finally {
      loading.value = false
    }
  }

  const approveBriefing = async (id) => {
    loading.value = true
    error.value = null
    try {
      const { data } = await safetyBriefingService.approve(id)
      return { success: true, data }
    } catch (e) {
      error.value = e.message
      return { success: false, error: e.message }
    } finally {
      loading.value = false
    }
  }

  return {
    briefings,
    currentBriefing,
    loading,
    error,
    pagination,
    fetchBriefings,
    fetchBriefingById,
    createBriefing,
    updateBriefing,
    deleteBriefing,
    approveBriefing
  }
})
```

---

### 4. Services

#### `src/services/api/supabase.js`
```javascript
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY

export const supabase = createClient(supabaseUrl, supabaseKey)
```

#### `src/services/api/safetyBriefing.service.js`
```javascript
import { supabase } from './supabase'

export const safetyBriefingService = {
  async getAll(filters = {}, pagination = {}) {
    let query = supabase
      .from('safety_briefing')
      .select(`
        *,
        unit:units!unit_id(id, kode_unit, nama_unit),
        wilayah:wilayah!wilayah_id(id, kode_wilayah, nama_wilayah),
        petugas:pegawai!petugas_id(id, nama_lengkap, nip)
      `, { count: 'exact' })

    // Apply filters
    if (filters.tanggalDari) {
      query = query.gte('tanggal', filters.tanggalDari)
    }
    if (filters.tanggalSampai) {
      query = query.lte('tanggal', filters.tanggalSampai)
    }
    if (filters.unitId) {
      query = query.eq('unit_id', filters.unitId)
    }
    if (filters.wilayahId) {
      query = query.eq('wilayah_id', filters.wilayahId)
    }
    if (filters.status) {
      query = query.eq('status', filters.status)
    }

    // Apply pagination
    const { page = 1, pageSize = 20 } = pagination
    const from = (page - 1) * pageSize
    const to = from + pageSize - 1

    const { data, error, count } = await query
      .order('tanggal', { ascending: false })
      .range(from, to)

    if (error) throw error
    return { data, count }
  },

  async getById(id) {
    const { data, error } = await supabase
      .from('safety_briefing')
      .select(`
        *,
        unit:units!unit_id(*),
        wilayah:wilayah!wilayah_id(*),
        petugas:pegawai!petugas_id(*),
        approved_by_user:pegawai!approved_by(*),
        created_by_user:pegawai!created_by(*)
      `)
      .eq('id', id)
      .single()

    if (error) throw error
    return { data }
  },

  async create(briefingData) {
    const { data, error } = await supabase
      .from('safety_briefing')
      .insert(briefingData)
      .select()
      .single()

    if (error) throw error
    return { data }
  },

  async update(id, briefingData) {
    const { data, error } = await supabase
      .from('safety_briefing')
      .update(briefingData)
      .eq('id', id)
      .select()
      .single()

    if (error) throw error
    return { data }
  },

  async delete(id) {
    const { error } = await supabase
      .from('safety_briefing')
      .delete()
      .eq('id', id)

    if (error) throw error
  },

  async approve(id) {
    const { data, error } = await supabase
      .from('safety_briefing')
      .update({
        status: 'approved',
        approved_by: (await supabase.auth.getUser()).data.user.id,
        approved_at: new Date().toISOString()
      })
      .eq('id', id)
      .select()
      .single()

    if (error) throw error
    return { data }
  },

  async getStats(filters = {}) {
    const { unitId, wilayahId, tanggalDari, tanggalSampai } = filters
    
    let query = supabase
      .from('safety_briefing')
      .select('*', { count: 'exact', head: true })

    if (unitId) query = query.eq('unit_id', unitId)
    if (wilayahId) query = query.eq('wilayah_id', wilayahId)
    if (tanggalDari) query = query.gte('tanggal', tanggalDari)
    if (tanggalSampai) query = query.lte('tanggal', tanggalSampai)

    const { count, error } = await query
    if (error) throw error
    return { count }
  }
}
```

#### `src/services/api/storage.service.js`
```javascript
import { supabase } from './supabase'

export const storageService = {
  async uploadFile(bucket, file, path) {
    const fileExt = file.name.split('.').pop()
    const fileName = `${Date.now()}_${Math.random().toString(36).substring(7)}.${fileExt}`
    const filePath = `${path}/${fileName}`

    const { data, error } = await supabase.storage
      .from(bucket)
      .upload(filePath, file)

    if (error) throw error

    const { data: { publicUrl } } = supabase.storage
      .from(bucket)
      .getPublicUrl(filePath)

    return publicUrl
  },

  async deleteFile(bucket, filePath) {
    const { error } = await supabase.storage
      .from(bucket)
      .remove([filePath])

    if (error) throw error
  },

  getPublicUrl(bucket, filePath) {
    const { data: { publicUrl } } = supabase.storage
      .from(bucket)
      .getPublicUrl(filePath)

    return publicUrl
  }
}
```

---

### 5. Composables

#### `src/composables/useForm.js`
```javascript
import { ref, computed } from 'vue'

export function useForm(initialValues = {}) {
  const formData = ref({ ...initialValues })
  const errors = ref({})
  const touched = ref({})
  const isSubmitting = ref(false)

  const resetForm = () => {
    formData.value = { ...initialValues }
    errors.value = {}
    touched.value = {}
  }

  const setFieldValue = (field, value) => {
    formData.value[field] = value
    touched.value[field] = true
  }

  const setFieldError = (field, error) => {
    errors.value[field] = error
  }

  const validateField = (field, rules) => {
    const value = formData.value[field]
    let error = null

    for (const rule of rules) {
      const result = rule(value)
      if (result !== true) {
        error = result
        break
      }
    }

    errors.value[field] = error
    return !error
  }

  const isValid = computed(() => {
    return Object.keys(errors.value).every(key => !errors.value[key])
  })

  return {
    formData,
    errors,
    touched,
    isSubmitting,
    isValid,
    resetForm,
    setFieldValue,
    setFieldError,
    validateField
  }
}
```

#### `src/composables/usePagination.js`
```javascript
import { ref, computed } from 'vue'

export function usePagination(initialPageSize = 20) {
  const page = ref(1)
  const pageSize = ref(initialPageSize)
  const totalCount = ref(0)

  const totalPages = computed(() => {
    return Math.ceil(totalCount.value / pageSize.value)
  })

  const hasNextPage = computed(() => {
    return page.value < totalPages.value
  })

  const hasPrevPage = computed(() => {
    return page.value > 1
  })

  const nextPage = () => {
    if (hasNextPage.value) {
      page.value++
    }
  }

  const prevPage = () => {
    if (hasPrevPage.value) {
      page.value--
    }
  }

  const goToPage = (pageNumber) => {
    if (pageNumber >= 1 && pageNumber <= totalPages.value) {
      page.value = pageNumber
    }
  }

  const reset = () => {
    page.value = 1
  }

  return {
    page,
    pageSize,
    totalCount,
    totalPages,
    hasNextPage,
    hasPrevPage,
    nextPage,
    prevPage,
    goToPage,
    reset
  }
}
```

#### `src/composables/useFileUpload.js`
```javascript
import { ref } from 'vue'
import { storageService } from '@/services/api/storage.service'

export function useFileUpload() {
  const uploading = ref(false)
  const progress = ref(0)
  const error = ref(null)

  const uploadFile = async (bucket, file, path) => {
    uploading.value = true
    progress.value = 0
    error.value = null

    try {
      const url = await storageService.uploadFile(bucket, file, path)
      progress.value = 100
      return url
    } catch (e) {
      error.value = e.message
      throw e
    } finally {
      uploading.value = false
    }
  }

  const deleteFile = async (bucket, filePath) => {
    try {
      await storageService.deleteFile(bucket, filePath)
    } catch (e) {
      error.value = e.message
      throw e
    }
  }

  return {
    uploading,
    progress,
    error,
    uploadFile,
    deleteFile
  }
}
```

---

### 6. Utils

#### `src/utils/constants.js`
```javascript
export const STATUS_OPTIONS = {
  DRAFT: 'draft',
  SUBMITTED: 'submitted',
  APPROVED: 'approved',
  CLOSED: 'closed'
}

export const STATUS_LABELS = {
  draft: 'Draft',
  submitted: 'Diajukan',
  approved: 'Disetujui',
  closed: 'Selesai'
}

export const STATUS_COLORS = {
  draft: 'gray',
  submitted: 'blue',
  approved: 'green',
  closed: 'purple'
}

export const ROLE_OPTIONS = {
  ADMIN: 'admin',
  MANAGER: 'manager',
  USER: 'user'
}

export const KATEGORI_TEMUAN = {
  CRITICAL: 'critical',
  MAJOR: 'major',
  MINOR: 'minor',
  NONE: 'none'
}

export const JENIS_DRILL = {
  FIRE: 'fire',
  EARTHQUAKE: 'earthquake',
  EVACUATION: 'evacuation',
  EMERGENCY_RESPONSE: 'emergency_response',
  OTHER: 'other'
}

export const TIPE_PESERTA = {
  PEGAWAI: 'pegawai',
  TAMU_EKSTERNAL: 'tamu_eksternal'
}

export const STORAGE_BUCKETS = {
  PHOTOS: 'hsse-photos',
  DOCUMENTS: 'hsse-documents',
  VIDEOS: 'hsse-videos',
  CERTIFICATES: 'hsse-certificates',
  PROFILES: 'profile-photos'
}
```

#### `src/utils/validators.js`
```javascript
export const required = (message = 'Field ini wajib diisi') => {
  return (value) => {
    if (!value || (typeof value === 'string' && !value.trim())) {
      return message
    }
    return true
  }
}

export const email = (message = 'Format email tidak valid') => {
  return (value) => {
    if (!value) return true
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return emailRegex.test(value) ? true : message
  }
}

export const minLength = (min, message) => {
  return (value) => {
    if (!value) return true
    return value.length >= min ? true : (message || `Minimal ${min} karakter`)
  }
}

export const maxLength = (max, message) => {
  return (value) => {
    if (!value) return true
    return value.length <= max ? true : (message || `Maksimal ${max} karakter`)
  }
}

export const numeric = (message = 'Harus berupa angka') => {
  return (value) => {
    if (!value) return true
    return !isNaN(value) ? true : message
  }
}

export const minValue = (min, message) => {
  return (value) => {
    if (!value) return true
    return Number(value) >= min ? true : (message || `Minimal ${min}`)
  }
}

export const maxValue = (max, message) => {
  return (value) => {
    if (!value) return true
    return Number(value) <= max ? true : (message || `Maksimal ${max}`)
  }
}
```

---

### 7. Environment Variables

#### `.env.example`
```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
VITE_APP_NAME=HSSE App
VITE_APP_VERSION=1.0.0
```

---

### 8. Package.json

#### `package.json`
```json
{
  "name": "hsse-app",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "lint": "eslint . --ext .vue,.js,.jsx,.cjs,.mjs --fix --ignore-path .gitignore"
  },
  "dependencies": {
    "vue": "^3.4.0",
    "vue-router": "^4.3.0",
    "pinia": "^2.1.7",
    "@supabase/supabase-js": "^2.39.0",
    "chart.js": "^4.4.1",
    "vue-chartjs": "^5.3.0",
    "date-fns": "^3.0.6",
    "vue-toastification": "^2.0.0-rc.5",
    "@vueuse/core": "^10.7.2"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.0.3",
    "vite": "^5.0.11",
    "autoprefixer": "^10.4.17",
    "postcss": "^8.4.33",
    "tailwindcss": "^3.4.1",
    "eslint": "^8.56.0",
    "eslint-plugin-vue": "^9.20.1"
  }
}
```

---

## Summary

**Total Folders**: ~30 folders organized by feature

**Key Structure**:
- ✅ **views/**: Page-level components (28+ views)
- ✅ **components/**: Reusable UI components (20+ components)
- ✅ **stores/**: State management with Pinia (12 stores)
- ✅ **services/**: API integration layer (13 services)
- ✅ **composables/**: Reusable composition functions (8 composables)
- ✅ **router/**: Vue Router configuration with guards
- ✅ **utils/**: Helper functions and constants

**Next**: Form Templates untuk Semua Modul (04_FORM_TEMPLATES.md)
