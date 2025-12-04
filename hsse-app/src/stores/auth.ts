import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import { authService } from '@/services/api/auth.service'
import type { User, Session } from '@supabase/supabase-js'

export const useAuthStore = defineStore('auth', () => {
  const user = ref<User | null>(null)
  const session = ref<Session | null>(null)
  const loading = ref(false)
  const error = ref<string | null>(null)

  const isAuthenticated = computed(() => !!session.value)
  const userRole = computed(() => user.value?.user_metadata?.role || 'user')
  const isAdmin = computed(() => user.value?.email === 'admin2@w3safe.com' || userRole.value === 'admin')
  const unitId = computed(() => user.value?.user_metadata?.unit_id || null)
  const unitKode = computed(() => user.value?.user_metadata?.unit_kode || null)
  const unitNama = computed(() => user.value?.user_metadata?.unit_nama || '')
  const userName = computed(() => user.value?.user_metadata?.username || user.value?.email || '')
  const userName = computed(() => user.value?.user_metadata?.username || user.value?.email || '')

  // Initialize auth state
  const initialize = async () => {
    loading.value = true
    try {
      session.value = await authService.getSession()
      if (session.value) {
        user.value = await authService.getCurrentUser()
      }
    } catch (e: any) {
      error.value = e.message
    } finally {
      loading.value = false
    }
  }

  // Login
  const login = async (email: string, password: string) => {
    loading.value = true
    error.value = null
    try {
      const { session: newSession, user: newUser } = await authService.login({ email, password })
      session.value = newSession
      user.value = newUser
      return true
    } catch (e: any) {
      error.value = e.message
      return false
    } finally {
      loading.value = false
    }
  }

  // Logout
  const logout = async () => {
    loading.value = true
    try {
      await authService.logout()
      session.value = null
      user.value = null
    } catch (e: any) {
      error.value = e.message
    } finally {
      loading.value = false
    }
  }

  // Sign up
  const signUp = async (email: string, password: string, fullName: string) => {
    loading.value = true
    error.value = null
    try {
      await authService.signUp({ email, password, full_name: fullName })
      return true
    } catch (e: any) {
      error.value = e.message
      return false
    } finally {
      loading.value = false
    }
  }

  // Update password
  const updatePassword = async (newPassword: string) => {
    loading.value = true
    error.value = null
    try {
      await authService.updatePassword(newPassword)
      return true
    } catch (e: any) {
      error.value = e.message
      return false
    } finally {
      loading.value = false
    }
  }

  return {
    user,
    session,
    loading,
    error,
    isAuthenticated,
    userRole,
    isAdmin,
    unitId,
    unitKode,
    unitNama,
    userName,
    initialize,
    login,
    logout,
    signUp,
    updatePassword
  }
})
