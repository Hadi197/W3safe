<template>
  <div>
    <h1 class="text-3xl font-bold text-gray-900 mb-6">Profile</h1>
    
    <div class="card">
      <h2 class="text-xl font-semibold mb-4">User Information</h2>
      <p class="text-gray-600">Email: {{ authStore.user?.email }}</p>
      <p class="text-gray-600 mt-2">Role: {{ authStore.userRole }}</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()
</script>
