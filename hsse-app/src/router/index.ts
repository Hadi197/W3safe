import { createRouter, createWebHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { isSupabaseConfigured } from '@/services/api/supabase'
import AuthLayout from '@/components/layout/AuthLayout.vue'
import DefaultLayout from '@/components/layout/DefaultLayout.vue'

const routes: RouteRecordRaw[] = [
  // Setup route (for unconfigured Supabase)
  {
    path: '/setup',
    name: 'setup',
    component: () => import('@/views/SetupView.vue'),
    meta: { public: true }
  },
  
  // Auth routes
  {
    path: '/login',
    component: AuthLayout,
    children: [
      {
        path: '',
        name: 'login',
        component: () => import('@/views/auth/LoginView.vue'),
        meta: { requiresGuest: true }
      }
    ]
  },
  
  // Protected routes
  {
    path: '/',
    component: DefaultLayout,
    meta: { requiresAuth: true },
    children: [
      {
        path: '',
        redirect: '/dashboard'
      },
      {
        path: 'dashboard',
        name: 'dashboard',
        component: () => import('@/views/DashboardView.vue'),
        meta: { title: 'Dashboard' }
      },
      // Master Data
      {
        path: 'units',
        name: 'units',
        component: () => import('@/views/master/UnitListView.vue'),
        meta: { title: 'Unit' }
      },
      {
        path: 'wilayah',
        name: 'wilayah',
        component: () => import('@/views/master/WilayahListView.vue'),
        meta: { title: 'Wilayah' }
      },
      {
        path: 'pegawai',
        name: 'pegawai',
        component: () => import('@/views/master/PegawaiListView.vue'),
        meta: { title: 'Pegawai' }
      },
      // HSSE Modules
      {
        path: 'safety-briefing',
        name: 'safety-briefing',
        component: () => import('@/views/hsse/SafetyBriefingView.vue'),
        meta: { title: 'Safety Briefing' }
      },
      {
        path: 'silent-inspection',
        name: 'silent-inspection',
        component: () => import('@/views/hsse/SilentInspectionView.vue'),
        meta: { title: 'Silent Inspection' }
      },
      {
        path: 'safety-forum',
        name: 'safety-forum',
        component: () => import('@/views/hsse/SafetyForumView.vue'),
        meta: { title: 'Safety Forum' }
      },
      {
        path: 'management-walkthrough',
        name: 'management-walkthrough',
        component: () => import('@/views/ManagementWalkthroughView.vue'),
        meta: { title: 'Management Walkthrough' }
      },
      {
        path: 'safety-patrol',
        name: 'safety-patrol',
        component: () => import('@/views/hsse/SafetyPatrolView.vue'),
        meta: { title: 'Safety Patrol' }
      },
      {
        path: 'safety-induction',
        name: 'safety-induction',
        component: () => import('@/views/hsse/SafetyInductionView.vue'),
        meta: { title: 'Safety Induction' }
      },
      {
        path: 'safety-drill',
        name: 'safety-drill',
        component: () => import('@/views/hsse/SafetyDrillView.vue'),
        meta: { title: 'Safety Drill' }
      },
      // Profile
      {
        path: 'profile',
        name: 'profile',
        component: () => import('@/views/ProfileView.vue'),
        meta: { title: 'Profile' }
      }
    ]
  },
  
  // 404
  {
    path: '/:pathMatch(.*)*',
    name: 'not-found',
    component: () => import('@/views/NotFoundView.vue')
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

// Navigation guards
router.beforeEach(async (to, from, next) => {
  // Check if Supabase is configured
  if (!isSupabaseConfigured && to.path !== '/setup') {
    next('/setup')
    return
  }
  
  // If configured and on setup page, redirect to login
  if (isSupabaseConfigured && to.path === '/setup') {
    next('/login')
    return
  }
  
  // Skip auth checks for public routes
  if (to.meta.public) {
    next()
    return
  }
  
  const authStore = useAuthStore()
  
  // Initialize auth state if not already done
  if (!authStore.session && !authStore.loading) {
    await authStore.initialize()
  }
  
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth)
  const requiresGuest = to.matched.some(record => record.meta.requiresGuest)
  
  if (requiresAuth && !authStore.isAuthenticated) {
    next('/login')
  } else if (requiresGuest && authStore.isAuthenticated) {
    next('/dashboard')
  } else {
    next()
  }
})

export default router
