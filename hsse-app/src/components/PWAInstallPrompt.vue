<template>
  <div v-if="showInstallButton" class="fixed bottom-4 right-4 z-50">
    <button
      @click="installPWA"
      class="bg-primary-600 hover:bg-primary-700 text-white px-4 py-2 rounded-lg shadow-lg flex items-center space-x-2 transition-colors duration-200"
    >
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
      </svg>
      <span>Install App</span>
    </button>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'

const showInstallButton = ref(false)
let deferredPrompt: any = null

onMounted(() => {
  // Listen for the beforeinstallprompt event
  window.addEventListener('beforeinstallprompt', (e) => {
    e.preventDefault()
    deferredPrompt = e
    showInstallButton.value = true
  })

  // Hide button if already installed
  window.addEventListener('appinstalled', () => {
    showInstallButton.value = false
    deferredPrompt = null
  })
})

const installPWA = async () => {
  if (!deferredPrompt) return

  // Show the install prompt
  deferredPrompt.prompt()

  // Wait for the user to respond to the prompt
  const { outcome } = await deferredPrompt.userChoice

  // Reset the deferred prompt
  deferredPrompt = null
  showInstallButton.value = false

  // Optionally, send analytics event with outcome
  console.log(`User response to install prompt: ${outcome}`)
}
</script>