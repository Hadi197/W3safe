<template>
  <div class="form-group">
    <label v-if="label" class="label">
      {{ label }}
      <span v-if="required" class="text-danger-500">*</span>
    </label>
    
    <div class="mt-2">
      <!-- File Input (hidden) -->
      <input
        ref="fileInputRef"
        type="file"
        :accept="accept"
        :multiple="multiple"
        :disabled="disabled"
        class="hidden"
        @change="handleFileChange"
      />
      
      <!-- Upload Button -->
      <button
        type="button"
        :disabled="disabled || uploading"
        class="btn-secondary"
        @click="fileInputRef?.click()"
      >
        <svg class="w-5 h-5 mr-2 inline" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
        </svg>
        {{ uploading ? 'Uploading...' : 'Pilih File' }}
      </button>
      
      <!-- Progress Bar -->
      <div v-if="uploading" class="mt-2">
        <div class="w-full bg-gray-200 rounded-full h-2">
          <div
            class="bg-primary-600 h-2 rounded-full transition-all duration-300"
            :style="{ width: `${uploadProgress}%` }"
          />
        </div>
        <p class="text-sm text-gray-600 mt-1">{{ uploadProgress }}%</p>
      </div>
      
      <!-- File Preview -->
      <div v-if="files.length > 0" class="mt-4 space-y-2">
        <div
          v-for="(file, index) in files"
          :key="index"
          class="flex items-center justify-between p-3 bg-gray-50 rounded-lg"
        >
          <div class="flex items-center space-x-3">
            <!-- Image Preview -->
            <img
              v-if="file.preview"
              :src="file.preview"
              class="w-12 h-12 object-cover rounded"
              alt="Preview"
            />
            <!-- File Icon -->
            <svg v-else class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
            </svg>
            
            <div>
              <p class="text-sm font-medium text-gray-900">{{ file.name }}</p>
              <p class="text-xs text-gray-500">{{ formatFileSize(file.size) }}</p>
            </div>
          </div>
          
          <button
            type="button"
            :disabled="disabled"
            class="text-danger-600 hover:text-danger-800"
            @click="removeFile(index)"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
      </div>
    </div>
    
    <p v-if="error" class="mt-1 text-sm text-danger-600">{{ error }}</p>
    <p v-if="hint && !error" class="mt-1 text-sm text-gray-500">{{ hint }}</p>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

interface FileWithPreview extends File {
  preview?: string
}

interface Props {
  label?: string
  accept?: string
  multiple?: boolean
  disabled?: boolean
  required?: boolean
  error?: string
  hint?: string
  maxSize?: number // in bytes
}

const props = withDefaults(defineProps<Props>(), {
  accept: '*/*',
  multiple: false,
  disabled: false,
  required: false,
  maxSize: 10 * 1024 * 1024 // 10MB
})

const emit = defineEmits<{
  (e: 'update:files', files: File[]): void
  (e: 'error', message: string): void
}>()

const fileInputRef = ref<HTMLInputElement>()
const files = ref<FileWithPreview[]>([])
const uploading = ref(false)
const uploadProgress = ref(0)

const handleFileChange = (event: Event) => {
  const target = event.target as HTMLInputElement
  const selectedFiles = Array.from(target.files || []) as FileWithPreview[]
  
  // Validate file size
  const invalidFiles = selectedFiles.filter(file => file.size > props.maxSize)
  if (invalidFiles.length > 0) {
    emit('error', `File terlalu besar. Maksimal ${formatFileSize(props.maxSize)}`)
    return
  }
  
  // Add preview for images
  selectedFiles.forEach(file => {
    if (file.type.startsWith('image/')) {
      const reader = new FileReader()
      reader.onload = (e) => {
        file.preview = e.target?.result as string
      }
      reader.readAsDataURL(file)
    }
  })
  
  if (props.multiple) {
    files.value = [...files.value, ...selectedFiles]
  } else {
    files.value = selectedFiles
  }
  
  emit('update:files', files.value)
  
  // Reset input
  if (target) {
    target.value = ''
  }
}

const removeFile = (index: number) => {
  files.value.splice(index, 1)
  emit('update:files', files.value)
}

const formatFileSize = (bytes: number): string => {
  if (bytes === 0) return '0 Bytes'
  const k = 1024
  const sizes = ['Bytes', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + ' ' + sizes[i]
}

// Expose methods for parent component
defineExpose({
  clearFiles: () => {
    files.value = []
    emit('update:files', [])
  }
})
</script>
