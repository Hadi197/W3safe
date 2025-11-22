<template>
  <div>
    <h2 class="text-2xl font-bold text-gray-900 mb-6">Login</h2>
    
    <form @submit.prevent="handleSubmit">
      <div v-if="authStore.error" class="mb-4 p-3 bg-danger-50 border border-danger-200 rounded-lg">
        <p class="text-sm text-danger-600">{{ authStore.error }}</p>
      </div>
      
      <BaseInput
        v-model="form.email"
        type="email"
        label="Email"
        placeholder="Masukkan email"
        required
        :error="errors.email"
      />
      
      <BaseInput
        v-model="form.password"
        type="password"
        label="Password"
        placeholder="Masukkan password"
        required
        :error="errors.password"
        class="mt-4"
      />
      
      <button
        type="submit"
        :disabled="authStore.loading"
        class="btn-primary w-full mt-6"
      >
        {{ authStore.loading ? 'Loading...' : 'Login' }}
      </button>
    </form>
  </div>
</template>

<script setup lang="ts">
import { reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import BaseInput from '@/components/base/BaseInput.vue'

const router = useRouter()
const authStore = useAuthStore()

const form = reactive({
  email: '',
  password: ''
})

const errors = reactive({
  email: '',
  password: ''
})

const handleSubmit = async () => {
  // Reset errors
  errors.email = ''
  errors.password = ''
  
  // Validation
  if (!form.email) {
    errors.email = 'Email wajib diisi'
    return
  }
  if (!form.password) {
    errors.password = 'Password wajib diisi'
    return
  }
  
  // Login
  const success = await authStore.login(form.email, form.password)
  if (success) {
    router.push('/dashboard')
  }
}
</script>
