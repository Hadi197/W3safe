<template>
  <div class="min-h-screen bg-gray-50">
    <UnsafeActionConditionView />
    <PWAInstallPrompt />
  </div>
</template>

<script setup lang="ts">
import UnsafeActionConditionView from '@/views/hsse/UnsafeActionConditionView.vue'
import PWAInstallPrompt from '@/components/PWAInstallPrompt.vue'
</script>