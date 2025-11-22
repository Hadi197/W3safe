<template>
  <div class="min-h-screen flex bg-gray-50">
    <!-- Sidebar -->
    <aside class="w-72 bg-gradient-to-b from-primary-900 to-primary-800 text-white shadow-2xl">
      <!-- Logo Section -->
      <div class="p-6 border-b border-primary-700">
        <div class="flex items-center space-x-3">
          <div class="w-10 h-10 bg-white rounded-xl flex items-center justify-center shadow-lg">
            <svg class="w-6 h-6 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
            </svg>
          </div>
          <div>
            <h1 class="text-2xl font-bold">W3Safe</h1>
            <p class="text-xs text-primary-200">Safety Management</p>
          </div>
        </div>
      </div>
      
      <!-- Navigation Menu -->
      <nav class="p-4 space-y-1 overflow-y-auto h-[calc(100vh-140px)]">
        <!-- Dashboard -->
        <router-link
          to="/dashboard"
          class="group flex items-center px-4 py-3 rounded-xl hover:bg-white/10 transition-all duration-200"
          active-class="bg-white/20 shadow-lg"
        >
          <svg class="w-5 h-5 mr-3 group-hover:scale-110 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
          </svg>
          <span class="font-medium">Dashboard</span>
        </router-link>

        <!-- Safety Programs Section -->
        <div class="pt-4 pb-2">
          <p class="px-4 text-xs font-semibold text-primary-300 uppercase tracking-wider">Program Keselamatan</p>
        </div>

        <router-link
          to="/safety-briefing"
          class="group flex items-center px-4 py-3 rounded-xl hover:bg-white/10 transition-all duration-200"
          active-class="bg-white/20 shadow-lg"
        >
          <svg class="w-5 h-5 mr-3 group-hover:scale-110 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
          </svg>
          <span class="font-medium">Safety Briefing</span>
        </router-link>

        <router-link
          to="/silent-inspection"
          class="group flex items-center px-4 py-3 rounded-xl hover:bg-white/10 transition-all duration-200"
          active-class="bg-white/20 shadow-lg"
        >
          <svg class="w-5 h-5 mr-3 group-hover:scale-110 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4" />
          </svg>
          <span class="font-medium">Silent Inspection</span>
        </router-link>

        <router-link
          to="/safety-forum"
          class="group flex items-center px-4 py-3 rounded-xl hover:bg-white/10 transition-all duration-200"
          active-class="bg-white/20 shadow-lg"
        >
          <svg class="w-5 h-5 mr-3 group-hover:scale-110 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
          </svg>
          <span class="font-medium">Safety Forum</span>
        </router-link>

        <router-link
          to="/management-walkthrough"
          class="group flex items-center px-4 py-3 rounded-xl hover:bg-white/10 transition-all duration-200"
          active-class="bg-white/20 shadow-lg"
        >
          <svg class="w-5 h-5 mr-3 group-hover:scale-110 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
          </svg>
          <span class="font-medium">Management Walkthrough</span>
        </router-link>

        <router-link
          to="/safety-patrol"
          class="group flex items-center px-4 py-3 rounded-xl hover:bg-white/10 transition-all duration-200"
          active-class="bg-white/20 shadow-lg"
        >
          <svg class="w-5 h-5 mr-3 group-hover:scale-110 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 15l-2 5L9 9l11 4-5 2zm0 0l5 5M7.188 2.239l.777 2.897M5.136 7.965l-2.898-.777M13.95 4.05l-2.122 2.122m-5.657 5.656l-2.12 2.122" />
          </svg>
          <span class="font-medium">Safety Patrol</span>
        </router-link>

        <router-link
          to="/safety-induction"
          class="group flex items-center px-4 py-3 rounded-xl hover:bg-white/10 transition-all duration-200"
          active-class="bg-white/20 shadow-lg"
        >
          <svg class="w-5 h-5 mr-3 group-hover:scale-110 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
          </svg>
          <span class="font-medium">Safety Induction</span>
        </router-link>

        <router-link
          to="/safety-drill"
          class="group flex items-center px-4 py-3 rounded-xl hover:bg-white/10 transition-all duration-200"
          active-class="bg-white/20 shadow-lg"
        >
          <svg class="w-5 h-5 mr-3 group-hover:scale-110 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 18.657A8 8 0 016.343 7.343S7 9 9 10c0-2 .5-5 2.986-7C14 5 16.09 5.777 17.656 7.343A7.975 7.975 0 0120 13a7.975 7.975 0 01-2.343 5.657z" />
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.879 16.121A3 3 0 1012.015 11L11 14H9c0 .768.293 1.536.879 2.121z" />
          </svg>
          <span class="font-medium">Safety Drill</span>
        </router-link>

        <!-- Master Data Section -->
        <div class="pt-6 pb-2">
          <p class="px-4 text-xs font-semibold text-primary-300 uppercase tracking-wider">Master Data</p>
        </div>

        <router-link
          to="/units"
          class="group flex items-center px-4 py-3 rounded-xl hover:bg-white/10 transition-all duration-200"
          active-class="bg-white/20 shadow-lg"
        >
          <svg class="w-5 h-5 mr-3 group-hover:scale-110 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
          </svg>
          <span class="font-medium">Master Palabuhan</span>
        </router-link>
      </nav>
    </aside>
    
    <!-- Main Content -->
    <div class="flex-1 flex flex-col min-h-screen">
      <!-- Header -->
      <header class="bg-white shadow-sm sticky top-0 z-40">
        <div class="flex items-center justify-between px-6 py-4">
          <h2 class="text-2xl font-bold text-gray-800">{{ pageTitle }}</h2>
          
          <div class="flex items-center space-x-4">
            <!-- User Menu -->
            <div class="relative">
              <button
                @click="showUserMenu = !showUserMenu"
                class="flex items-center space-x-3 hover:bg-gray-50 rounded-xl px-4 py-2 transition-colors"
              >
                <div class="w-10 h-10 bg-gradient-to-br from-primary-600 to-primary-700 rounded-xl flex items-center justify-center text-white font-bold shadow-md">
                  {{ userInitials }}
                </div>
                <div class="text-left hidden md:block">
                  <p class="text-sm font-semibold text-gray-800">{{ userName }}</p>
                  <p class="text-xs text-gray-500">Administrator</p>
                </div>
                <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                </svg>
              </button>
              
              <div
                v-if="showUserMenu"
                class="absolute right-0 mt-2 w-56 bg-white rounded-xl shadow-2xl py-2 z-50 border border-gray-100"
              >
                <router-link
                  to="/profile"
                  class="flex items-center px-4 py-3 text-sm text-gray-700 hover:bg-gray-50 transition-colors"
                >
                  <svg class="w-4 h-4 mr-3 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                  </svg>
                  Profile Saya
                </router-link>
                <hr class="my-2">
                <button
                  @click="handleLogout"
                  class="w-full flex items-center px-4 py-3 text-sm text-danger-600 hover:bg-danger-50 transition-colors"
                >
                  <svg class="w-4 h-4 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                  </svg>
                  Logout
                </button>
              </div>
            </div>
          </div>
        </div>
      </header>
      
      <!-- Page Content -->
      <main class="flex-1 p-8 overflow-auto">
        <router-view />
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const authStore = useAuthStore()
const showUserMenu = ref(false)

const userName = computed(() => authStore.user?.email?.split('@')[0] || 'User')
const userInitials = computed(() => {
  const name = userName.value
  return name.substring(0, 2).toUpperCase()
})

const pageTitle = computed(() => {
  return router.currentRoute.value.meta.title || 'Dashboard'
})

const handleLogout = async () => {
  await authStore.logout()
  router.push('/login')
}
</script>

<script lang="ts">
export default {
  name: 'DefaultLayout'
}
</script>
