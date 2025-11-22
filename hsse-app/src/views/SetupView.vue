<template>
  <div class="min-h-screen bg-gradient-to-br from-primary-600 to-primary-800 flex items-center justify-center p-4">
    <div class="w-full max-w-2xl">
      <div class="bg-white rounded-2xl shadow-2xl p-8">
        <div class="text-center mb-8">
          <div class="w-16 h-16 bg-warning-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <svg class="w-8 h-8 text-warning-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
          </div>
          <h1 class="text-3xl font-bold text-gray-900 mb-2">Supabase Setup Required</h1>
          <p class="text-gray-600">Please configure your Supabase connection to continue</p>
        </div>
        
        <div class="space-y-6">
          <!-- Step 1 -->
          <div class="bg-gray-50 rounded-lg p-6">
            <div class="flex items-start">
              <div class="flex-shrink-0">
                <div class="w-8 h-8 bg-primary-600 text-white rounded-full flex items-center justify-center font-bold">
                  1
                </div>
              </div>
              <div class="ml-4 flex-1">
                <h3 class="text-lg font-semibold text-gray-900 mb-2">Create Supabase Project</h3>
                <p class="text-gray-600 mb-3">
                  If you don't have a Supabase account yet, create one and set up a new project.
                </p>
                <a 
                  href="https://app.supabase.com/" 
                  target="_blank"
                  class="inline-flex items-center text-primary-600 hover:text-primary-700 font-medium"
                >
                  Open Supabase Dashboard
                  <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                  </svg>
                </a>
              </div>
            </div>
          </div>
          
          <!-- Step 2 -->
          <div class="bg-gray-50 rounded-lg p-6">
            <div class="flex items-start">
              <div class="flex-shrink-0">
                <div class="w-8 h-8 bg-primary-600 text-white rounded-full flex items-center justify-center font-bold">
                  2
                </div>
              </div>
              <div class="ml-4 flex-1">
                <h3 class="text-lg font-semibold text-gray-900 mb-2">Get Your Credentials</h3>
                <p class="text-gray-600 mb-3">
                  In your Supabase project, go to <strong>Settings → API</strong> to find:
                </p>
                <ul class="list-disc list-inside text-gray-600 space-y-1 mb-3">
                  <li><strong>Project URL</strong> - Your project's API URL</li>
                  <li><strong>anon/public key</strong> - Your anonymous API key</li>
                </ul>
              </div>
            </div>
          </div>
          
          <!-- Step 3 -->
          <div class="bg-gray-50 rounded-lg p-6">
            <div class="flex items-start">
              <div class="flex-shrink-0">
                <div class="w-8 h-8 bg-primary-600 text-white rounded-full flex items-center justify-center font-bold">
                  3
                </div>
              </div>
              <div class="ml-4 flex-1">
                <h3 class="text-lg font-semibold text-gray-900 mb-2">Run Database Migrations</h3>
                <p class="text-gray-600 mb-3">
                  In Supabase SQL Editor, run the migration scripts from:
                </p>
                <code class="block bg-gray-800 text-green-400 p-3 rounded text-sm mb-3">
                  ../07_MIGRATION_SQL.md
                </code>
                <p class="text-sm text-gray-500">
                  Execute all 8 migrations in order to create the database schema.
                </p>
              </div>
            </div>
          </div>
          
          <!-- Step 4 -->
          <div class="bg-gray-50 rounded-lg p-6">
            <div class="flex items-start">
              <div class="flex-shrink-0">
                <div class="w-8 h-8 bg-primary-600 text-white rounded-full flex items-center justify-center font-bold">
                  4
                </div>
              </div>
              <div class="ml-4 flex-1">
                <h3 class="text-lg font-semibold text-gray-900 mb-2">Update Environment Variables</h3>
                <p class="text-gray-600 mb-3">
                  Edit the <code class="bg-gray-200 px-2 py-1 rounded">.env.local</code> file:
                </p>
                <div class="bg-gray-800 text-green-400 p-4 rounded text-sm font-mono">
                  <div>VITE_SUPABASE_URL=https://xxxxx.supabase.co</div>
                  <div>VITE_SUPABASE_ANON_KEY=your_anon_key_here</div>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Step 5 -->
          <div class="bg-gray-50 rounded-lg p-6">
            <div class="flex items-start">
              <div class="flex-shrink-0">
                <div class="w-8 h-8 bg-primary-600 text-white rounded-full flex items-center justify-center font-bold">
                  5
                </div>
              </div>
              <div class="ml-4 flex-1">
                <h3 class="text-lg font-semibold text-gray-900 mb-2">Restart Development Server</h3>
                <p class="text-gray-600 mb-3">
                  After updating .env.local, restart the development server:
                </p>
                <code class="block bg-gray-800 text-green-400 p-3 rounded text-sm">
                  npm run dev
                </code>
              </div>
            </div>
          </div>
        </div>
        
        <div class="mt-8 p-4 bg-blue-50 border border-blue-200 rounded-lg">
          <div class="flex">
            <svg class="w-5 h-5 text-blue-600 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <div class="ml-3">
              <h4 class="text-sm font-semibold text-blue-900 mb-1">Need Help?</h4>
              <p class="text-sm text-blue-700">
                Check the <code class="bg-blue-100 px-2 py-0.5 rounded">README.md</code> file for detailed setup instructions.
              </p>
            </div>
          </div>
        </div>
        
        <div class="mt-6 text-center">
          <button
            @click="checkConnection"
            :disabled="checking"
            class="btn-primary"
          >
            {{ checking ? 'Checking...' : 'Check Connection' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { isSupabaseConfigured } from '@/services/api/supabase'

const checking = ref(false)

const checkConnection = () => {
  checking.value = true
  
  setTimeout(() => {
    if (isSupabaseConfigured) {
      window.location.reload()
    } else {
      alert('⚠️ Supabase still not configured. Please update .env.local and restart the dev server.')
    }
    checking.value = false
  }, 1000)
}
</script>
