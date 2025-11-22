# 📝 Form Templates - Aplikasi Implementasi HSSE

Dokumentasi lengkap template form untuk semua modul HSSE dengan validation, file upload, dan integration ke Supabase.

---

## 1. Base Form Components

### 1.1 BaseInput.vue
```vue
<template>
  <div class="form-group">
    <label v-if="label" :for="id" class="form-label">
      {{ label }}
      <span v-if="required" class="text-red-500">*</span>
    </label>
    
    <input
      :id="id"
      :type="type"
      :value="modelValue"
      :placeholder="placeholder"
      :disabled="disabled"
      :class="[
        'form-input',
        { 'border-red-500': error },
        { 'bg-gray-100': disabled }
      ]"
      @input="$emit('update:modelValue', $event.target.value)"
      @blur="$emit('blur')"
    />
    
    <p v-if="error" class="text-red-500 text-sm mt-1">{{ error }}</p>
    <p v-else-if="hint" class="text-gray-500 text-sm mt-1">{{ hint }}</p>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  modelValue: [String, Number],
  label: String,
  type: {
    type: String,
    default: 'text'
  },
  placeholder: String,
  required: Boolean,
  disabled: Boolean,
  error: String,
  hint: String
})

const emit = defineEmits(['update:modelValue', 'blur'])

const id = computed(() => `input-${Math.random().toString(36).substr(2, 9)}`)
</script>

<style scoped>
.form-input {
  @apply w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500;
}
</style>
```

### 1.2 BaseTextarea.vue
```vue
<template>
  <div class="form-group">
    <label v-if="label" :for="id" class="form-label">
      {{ label }}
      <span v-if="required" class="text-red-500">*</span>
    </label>
    
    <textarea
      :id="id"
      :value="modelValue"
      :placeholder="placeholder"
      :disabled="disabled"
      :rows="rows"
      :class="[
        'form-textarea',
        { 'border-red-500': error },
        { 'bg-gray-100': disabled }
      ]"
      @input="$emit('update:modelValue', $event.target.value)"
      @blur="$emit('blur')"
    ></textarea>
    
    <p v-if="error" class="text-red-500 text-sm mt-1">{{ error }}</p>
    <p v-else-if="hint" class="text-gray-500 text-sm mt-1">{{ hint }}</p>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  modelValue: String,
  label: String,
  placeholder: String,
  required: Boolean,
  disabled: Boolean,
  rows: {
    type: Number,
    default: 4
  },
  error: String,
  hint: String
})

const emit = defineEmits(['update:modelValue', 'blur'])

const id = computed(() => `textarea-${Math.random().toString(36).substr(2, 9)}`)
</script>

<style scoped>
.form-textarea {
  @apply w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 resize-y;
}
</style>
```

### 1.3 BaseSelect.vue
```vue
<template>
  <div class="form-group">
    <label v-if="label" :for="id" class="form-label">
      {{ label }}
      <span v-if="required" class="text-red-500">*</span>
    </label>
    
    <select
      :id="id"
      :value="modelValue"
      :disabled="disabled"
      :class="[
        'form-select',
        { 'border-red-500': error },
        { 'bg-gray-100': disabled }
      ]"
      @change="$emit('update:modelValue', $event.target.value)"
      @blur="$emit('blur')"
    >
      <option value="" disabled>{{ placeholder || 'Pilih...' }}</option>
      <option
        v-for="option in options"
        :key="option[valueKey]"
        :value="option[valueKey]"
      >
        {{ option[labelKey] }}
      </option>
    </select>
    
    <p v-if="error" class="text-red-500 text-sm mt-1">{{ error }}</p>
    <p v-else-if="hint" class="text-gray-500 text-sm mt-1">{{ hint }}</p>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  modelValue: [String, Number],
  label: String,
  options: {
    type: Array,
    default: () => []
  },
  valueKey: {
    type: String,
    default: 'value'
  },
  labelKey: {
    type: String,
    default: 'label'
  },
  placeholder: String,
  required: Boolean,
  disabled: Boolean,
  error: String,
  hint: String
})

const emit = defineEmits(['update:modelValue', 'blur'])

const id = computed(() => `select-${Math.random().toString(36).substr(2, 9)}`)
</script>

<style scoped>
.form-select {
  @apply w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500;
}
</style>
```

### 1.4 BaseDatePicker.vue
```vue
<template>
  <div class="form-group">
    <label v-if="label" :for="id" class="form-label">
      {{ label }}
      <span v-if="required" class="text-red-500">*</span>
    </label>
    
    <input
      :id="id"
      type="date"
      :value="modelValue"
      :min="min"
      :max="max"
      :disabled="disabled"
      :class="[
        'form-input',
        { 'border-red-500': error },
        { 'bg-gray-100': disabled }
      ]"
      @input="$emit('update:modelValue', $event.target.value)"
      @blur="$emit('blur')"
    />
    
    <p v-if="error" class="text-red-500 text-sm mt-1">{{ error }}</p>
    <p v-else-if="hint" class="text-gray-500 text-sm mt-1">{{ hint }}</p>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  modelValue: String,
  label: String,
  min: String,
  max: String,
  required: Boolean,
  disabled: Boolean,
  error: String,
  hint: String
})

const emit = defineEmits(['update:modelValue', 'blur'])

const id = computed(() => `date-${Math.random().toString(36).substr(2, 9)}`)
</script>
```

### 1.5 BaseFileUpload.vue
```vue
<template>
  <div class="form-group">
    <label v-if="label" class="form-label">
      {{ label }}
      <span v-if="required" class="text-red-500">*</span>
    </label>
    
    <div class="file-upload-container">
      <!-- Preview existing file -->
      <div v-if="modelValue && !preview" class="file-preview mb-2">
        <div class="flex items-center justify-between bg-gray-50 p-3 rounded">
          <div class="flex items-center">
            <svg class="w-5 h-5 text-gray-500 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
            <span class="text-sm text-gray-700">File sudah diupload</span>
          </div>
          <button
            type="button"
            class="text-red-500 hover:text-red-700"
            @click="handleRemove"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
      </div>
      
      <!-- Preview new file -->
      <div v-if="preview" class="file-preview mb-2">
        <img v-if="isImage" :src="preview" alt="Preview" class="max-w-xs rounded" />
        <div v-else class="flex items-center bg-gray-50 p-3 rounded">
          <svg class="w-5 h-5 text-gray-500 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
          <span class="text-sm text-gray-700">{{ fileName }}</span>
        </div>
      </div>
      
      <!-- Upload button -->
      <div class="relative">
        <input
          ref="fileInput"
          type="file"
          :accept="accept"
          :disabled="disabled || uploading"
          class="hidden"
          @change="handleFileChange"
        />
        
        <button
          type="button"
          :disabled="disabled || uploading"
          class="btn-upload"
          @click="$refs.fileInput.click()"
        >
          <svg v-if="!uploading" class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
          </svg>
          <span v-if="uploading">Uploading...</span>
          <span v-else>{{ buttonText }}</span>
        </button>
      </div>
      
      <!-- Progress bar -->
      <div v-if="uploading" class="mt-2">
        <div class="w-full bg-gray-200 rounded-full h-2">
          <div
            class="bg-blue-600 h-2 rounded-full transition-all duration-300"
            :style="{ width: `${progress}%` }"
          ></div>
        </div>
      </div>
    </div>
    
    <p v-if="error" class="text-red-500 text-sm mt-1">{{ error }}</p>
    <p v-else-if="hint" class="text-gray-500 text-sm mt-1">{{ hint }}</p>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useFileUpload } from '@/composables/useFileUpload'

const props = defineProps({
  modelValue: String, // URL of uploaded file
  label: String,
  accept: {
    type: String,
    default: 'image/*'
  },
  bucket: {
    type: String,
    required: true
  },
  path: {
    type: String,
    required: true
  },
  buttonText: {
    type: String,
    default: 'Pilih File'
  },
  required: Boolean,
  disabled: Boolean,
  error: String,
  hint: String
})

const emit = defineEmits(['update:modelValue', 'uploading', 'uploaded'])

const fileInput = ref(null)
const preview = ref(null)
const fileName = ref('')
const { uploading, progress, uploadFile } = useFileUpload()

const isImage = computed(() => {
  return props.accept.includes('image')
})

const handleFileChange = async (event) => {
  const file = event.target.files[0]
  if (!file) return

  fileName.value = file.name

  // Create preview
  if (isImage.value) {
    const reader = new FileReader()
    reader.onload = (e) => {
      preview.value = e.target.result
    }
    reader.readAsDataURL(file)
  } else {
    preview.value = 'file'
  }

  // Upload file
  try {
    emit('uploading', true)
    const url = await uploadFile(props.bucket, file, props.path)
    emit('update:modelValue', url)
    emit('uploaded', url)
  } catch (error) {
    console.error('Upload error:', error)
    preview.value = null
  } finally {
    emit('uploading', false)
  }
}

const handleRemove = () => {
  preview.value = null
  fileName.value = ''
  emit('update:modelValue', '')
  if (fileInput.value) {
    fileInput.value.value = ''
  }
}
</script>

<style scoped>
.btn-upload {
  @apply inline-flex items-center px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed;
}
</style>
```

---

## 2. Safety Briefing Form

### SafetyBriefingForm.vue
```vue
<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <!-- Unit atau Wilayah -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <BaseSelect
        v-model="formData.unit_id"
        label="Unit"
        :options="units"
        value-key="id"
        label-key="nama_unit"
        placeholder="Pilih Unit"
        :error="errors.unit_id"
        @blur="validateField('unit_id')"
      />
      
      <BaseSelect
        v-model="formData.wilayah_id"
        label="Wilayah"
        :options="wilayah"
        value-key="id"
        label-key="nama_wilayah"
        placeholder="Pilih Wilayah"
        :error="errors.wilayah_id"
        @blur="validateField('wilayah_id')"
      />
    </div>

    <!-- Tanggal & Waktu -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <BaseDatePicker
        v-model="formData.tanggal"
        label="Tanggal"
        required
        :max="today"
        :error="errors.tanggal"
        @blur="validateField('tanggal')"
      />
      
      <BaseInput
        v-model="formData.waktu_mulai"
        type="time"
        label="Waktu Mulai"
        required
        :error="errors.waktu_mulai"
        @blur="validateField('waktu_mulai')"
      />
      
      <BaseInput
        v-model="formData.waktu_selesai"
        type="time"
        label="Waktu Selesai"
        :error="errors.waktu_selesai"
      />
    </div>

    <!-- Petugas & Lokasi -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <BaseSelect
        v-model="formData.petugas_id"
        label="Petugas"
        required
        :options="pegawai"
        value-key="id"
        label-key="nama_lengkap"
        placeholder="Pilih Petugas"
        :error="errors.petugas_id"
        @blur="validateField('petugas_id')"
      />
      
      <BaseInput
        v-model="formData.lokasi"
        label="Lokasi"
        placeholder="Contoh: Ruang Meeting A"
        :error="errors.lokasi"
      />
    </div>

    <!-- Topik -->
    <BaseInput
      v-model="formData.topik"
      label="Topik Briefing"
      required
      placeholder="Topik pembahasan safety briefing"
      :error="errors.topik"
      @blur="validateField('topik')"
    />

    <!-- Materi -->
    <BaseTextarea
      v-model="formData.materi"
      label="Materi"
      :rows="6"
      placeholder="Detail materi yang dibahas dalam briefing"
      :error="errors.materi"
    />

    <!-- Jumlah Peserta -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <BaseInput
        v-model.number="formData.jumlah_peserta"
        type="number"
        label="Jumlah Peserta"
        min="0"
        placeholder="0"
        :error="errors.jumlah_peserta"
      />
    </div>

    <!-- Temuan & Tindak Lanjut -->
    <BaseTextarea
      v-model="formData.temuan"
      label="Temuan"
      :rows="4"
      placeholder="Issue atau temuan yang dibahas (jika ada)"
      :error="errors.temuan"
    />

    <BaseTextarea
      v-model="formData.tindak_lanjut"
      label="Tindak Lanjut"
      :rows="4"
      placeholder="Tindak lanjut yang diperlukan (jika ada)"
      :error="errors.tindak_lanjut"
    />

    <!-- File Upload -->
    <BaseFileUpload
      v-model="formData.lampiran_url"
      label="Lampiran (Foto/Dokumen)"
      accept="image/*,.pdf"
      bucket="hsse-photos"
      :path="`safety_briefing/${currentYear}/${currentMonth}`"
      button-text="Upload Lampiran"
      hint="Format: JPG, PNG, PDF. Max 10MB"
      :error="errors.lampiran_url"
      @uploading="isUploading = $event"
    />

    <!-- Status -->
    <BaseSelect
      v-model="formData.status"
      label="Status"
      required
      :options="statusOptions"
      value-key="value"
      label-key="label"
      :error="errors.status"
    />

    <!-- Actions -->
    <div class="flex justify-end space-x-3 pt-4 border-t">
      <button
        type="button"
        class="btn-secondary"
        @click="$emit('cancel')"
      >
        Batal
      </button>
      
      <button
        type="submit"
        class="btn-primary"
        :disabled="isSubmitting || isUploading"
      >
        <span v-if="isSubmitting">Menyimpan...</span>
        <span v-else>Simpan</span>
      </button>
    </div>
  </form>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useForm } from '@/composables/useForm'
import { required, minValue } from '@/utils/validators'
import { useUnitsStore } from '@/stores/units'
import { useWilayahStore } from '@/stores/wilayah'
import { usePegawaiStore } from '@/stores/pegawai'

const props = defineProps({
  initialData: {
    type: Object,
    default: () => ({
      unit_id: '',
      wilayah_id: '',
      tanggal: '',
      waktu_mulai: '',
      waktu_selesai: '',
      petugas_id: '',
      lokasi: '',
      topik: '',
      materi: '',
      jumlah_peserta: 0,
      temuan: '',
      tindak_lanjut: '',
      lampiran_url: '',
      status: 'draft'
    })
  }
})

const emit = defineEmits(['submit', 'cancel'])

const unitsStore = useUnitsStore()
const wilayahStore = useWilayahStore()
const pegawaiStore = usePegawaiStore()

const { formData, errors, isSubmitting, validateField } = useForm(props.initialData)
const isUploading = ref(false)

const units = computed(() => unitsStore.units)
const wilayah = computed(() => wilayahStore.wilayah)
const pegawai = computed(() => pegawaiStore.pegawai)

const today = computed(() => new Date().toISOString().split('T')[0])
const currentYear = computed(() => new Date().getFullYear())
const currentMonth = computed(() => String(new Date().getMonth() + 1).padStart(2, '0'))

const statusOptions = [
  { value: 'draft', label: 'Draft' },
  { value: 'submitted', label: 'Diajukan' },
  { value: 'approved', label: 'Disetujui' }
]

// Validation rules
const rules = {
  tanggal: [required('Tanggal wajib diisi')],
  waktu_mulai: [required('Waktu mulai wajib diisi')],
  petugas_id: [required('Petugas wajib dipilih')],
  topik: [required('Topik wajib diisi')],
  status: [required('Status wajib dipilih')]
}

const handleSubmit = async () => {
  // Validate all fields
  let isValid = true
  Object.keys(rules).forEach(field => {
    if (!validateField(field, rules[field])) {
      isValid = false
    }
  })

  // Validate unit or wilayah
  if (!formData.value.unit_id && !formData.value.wilayah_id) {
    errors.value.unit_id = 'Unit atau Wilayah harus dipilih'
    isValid = false
  }

  if (!isValid) return

  isSubmitting.value = true
  try {
    await emit('submit', formData.value)
  } finally {
    isSubmitting.value = false
  }
}

onMounted(async () => {
  await Promise.all([
    unitsStore.fetchUnits(),
    wilayahStore.fetchWilayah(),
    pegawaiStore.fetchPegawai()
  ])
})
</script>

<style scoped>
.btn-primary {
  @apply px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed;
}

.btn-secondary {
  @apply px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-gray-500;
}
</style>
```

---

## 3. Silent Inspection Form

### SilentInspectionForm.vue
```vue
<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <!-- Basic Info -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <BaseSelect
        v-model="formData.unit_id"
        label="Unit"
        :options="units"
        value-key="id"
        label-key="nama_unit"
        placeholder="Pilih Unit"
        :error="errors.unit_id"
      />
      
      <BaseSelect
        v-model="formData.wilayah_id"
        label="Wilayah"
        :options="wilayah"
        value-key="id"
        label-key="nama_wilayah"
        placeholder="Pilih Wilayah"
        :error="errors.wilayah_id"
      />
    </div>

    <!-- Tanggal & Period -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <BaseDatePicker
        v-model="formData.tanggal"
        label="Tanggal Inspeksi"
        required
        :error="errors.tanggal"
        @blur="validateField('tanggal')"
      />
      
      <BaseSelect
        v-model.number="formData.triwulan"
        label="Triwulan"
        required
        :options="triwulanOptions"
        value-key="value"
        label-key="label"
        :error="errors.triwulan"
        @blur="validateField('triwulan')"
      />
      
      <BaseInput
        v-model.number="formData.tahun"
        type="number"
        label="Tahun"
        required
        :min="2020"
        :max="2050"
        :error="errors.tahun"
        @blur="validateField('tahun')"
      />
    </div>

    <!-- Inspector & Area -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <BaseSelect
        v-model="formData.inspector_id"
        label="Inspector"
        required
        :options="pegawai"
        value-key="id"
        label-key="nama_lengkap"
        placeholder="Pilih Inspector"
        :error="errors.inspector_id"
        @blur="validateField('inspector_id')"
      />
      
      <BaseInput
        v-model="formData.area_inspeksi"
        label="Area Inspeksi"
        required
        placeholder="Area yang diinspeksi"
        :error="errors.area_inspeksi"
        @blur="validateField('area_inspeksi')"
      />
    </div>

    <!-- Checklist -->
    <div class="space-y-2">
      <label class="form-label">
        Checklist Inspeksi
        <span class="text-red-500">*</span>
      </label>
      
      <div
        v-for="(item, index) in formData.checklist"
        :key="index"
        class="border rounded-md p-4 space-y-3"
      >
        <div class="flex justify-between items-start">
          <span class="font-medium">Item {{ index + 1 }}</span>
          <button
            v-if="formData.checklist.length > 1"
            type="button"
            class="text-red-500 hover:text-red-700"
            @click="removeChecklistItem(index)"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
        
        <BaseInput
          v-model="item.item"
          label="Item Checklist"
          placeholder="Contoh: APD lengkap tersedia"
        />
        
        <div class="grid grid-cols-2 gap-4">
          <BaseSelect
            v-model="item.status"
            label="Status"
            :options="checklistStatusOptions"
            value-key="value"
            label-key="label"
          />
          
          <BaseInput
            v-model="item.catatan"
            label="Catatan"
            placeholder="Catatan tambahan"
          />
        </div>
      </div>
      
      <button
        type="button"
        class="btn-secondary text-sm"
        @click="addChecklistItem"
      >
        + Tambah Item
      </button>
    </div>

    <!-- Skor & Kategori -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <BaseInput
        v-model.number="formData.skor_total"
        type="number"
        label="Skor Total"
        min="0"
        max="100"
        step="0.01"
        placeholder="0-100"
        :error="errors.skor_total"
      />
      
      <BaseSelect
        v-model="formData.kategori_temuan"
        label="Kategori Temuan"
        :options="kategoriTemuanOptions"
        value-key="value"
        label-key="label"
        :error="errors.kategori_temuan"
      />
    </div>

    <!-- Temuan & Rekomendasi -->
    <BaseTextarea
      v-model="formData.temuan"
      label="Temuan"
      :rows="4"
      placeholder="Deskripsi temuan inspeksi"
      :error="errors.temuan"
    />

    <BaseTextarea
      v-model="formData.rekomendasi"
      label="Rekomendasi"
      :rows="4"
      placeholder="Rekomendasi perbaikan"
      :error="errors.rekomendasi"
    />

    <!-- PIC & Target -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <BaseSelect
        v-model="formData.pic_perbaikan_id"
        label="PIC Perbaikan"
        :options="pegawai"
        value-key="id"
        label-key="nama_lengkap"
        placeholder="Pilih PIC"
        :error="errors.pic_perbaikan_id"
      />
      
      <BaseDatePicker
        v-model="formData.target_selesai"
        label="Target Selesai"
        :min="formData.tanggal"
        :error="errors.target_selesai"
      />
    </div>

    <!-- File Upload -->
    <BaseFileUpload
      v-model="formData.lampiran_url"
      label="Lampiran (Foto/Dokumen)"
      accept="image/*,.pdf"
      bucket="hsse-photos"
      :path="`silent_inspection/${currentYear}/${currentQuarter}`"
      button-text="Upload Lampiran"
      hint="Format: JPG, PNG, PDF. Max 10MB"
      :error="errors.lampiran_url"
      @uploading="isUploading = $event"
    />

    <!-- Status -->
    <BaseSelect
      v-model="formData.status"
      label="Status"
      required
      :options="statusOptions"
      value-key="value"
      label-key="label"
      :error="errors.status"
      @blur="validateField('status')"
    />

    <!-- Actions -->
    <div class="flex justify-end space-x-3 pt-4 border-t">
      <button type="button" class="btn-secondary" @click="$emit('cancel')">
        Batal
      </button>
      
      <button
        type="submit"
        class="btn-primary"
        :disabled="isSubmitting || isUploading"
      >
        <span v-if="isSubmitting">Menyimpan...</span>
        <span v-else>Simpan</span>
      </button>
    </div>
  </form>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useForm } from '@/composables/useForm'
import { required } from '@/utils/validators'

const props = defineProps({
  initialData: {
    type: Object,
    default: () => ({
      unit_id: '',
      wilayah_id: '',
      tanggal: '',
      triwulan: null,
      tahun: new Date().getFullYear(),
      inspector_id: '',
      area_inspeksi: '',
      checklist: [
        { item: '', status: '', catatan: '' }
      ],
      skor_total: null,
      kategori_temuan: '',
      temuan: '',
      rekomendasi: '',
      pic_perbaikan_id: '',
      target_selesai: '',
      lampiran_url: '',
      status: 'draft'
    })
  }
})

const emit = defineEmits(['submit', 'cancel'])

const { formData, errors, isSubmitting, validateField } = useForm(props.initialData)
const isUploading = ref(false)

const currentYear = computed(() => new Date().getFullYear())
const currentQuarter = computed(() => `Q${Math.floor((new Date().getMonth() + 3) / 3)}`)

const triwulanOptions = [
  { value: 1, label: 'Triwulan 1 (Jan-Mar)' },
  { value: 2, label: 'Triwulan 2 (Apr-Jun)' },
  { value: 3, label: 'Triwulan 3 (Jul-Sep)' },
  { value: 4, label: 'Triwulan 4 (Okt-Des)' }
]

const checklistStatusOptions = [
  { value: 'ok', label: 'OK' },
  { value: 'not_ok', label: 'Not OK' }
]

const kategoriTemuanOptions = [
  { value: 'none', label: 'Tidak Ada' },
  { value: 'minor', label: 'Minor' },
  { value: 'major', label: 'Major' },
  { value: 'critical', label: 'Critical' }
]

const statusOptions = [
  { value: 'draft', label: 'Draft' },
  { value: 'submitted', label: 'Diajukan' },
  { value: 'approved', label: 'Disetujui' },
  { value: 'closed', label: 'Selesai' }
]

const addChecklistItem = () => {
  formData.value.checklist.push({ item: '', status: '', catatan: '' })
}

const removeChecklistItem = (index) => {
  formData.value.checklist.splice(index, 1)
}

const handleSubmit = async () => {
  // Validation
  const rules = {
    tanggal: [required()],
    triwulan: [required()],
    tahun: [required()],
    inspector_id: [required()],
    area_inspeksi: [required()],
    status: [required()]
  }

  let isValid = true
  Object.keys(rules).forEach(field => {
    if (!validateField(field, rules[field])) {
      isValid = false
    }
  })

  if (!isValid) return

  isSubmitting.value = true
  try {
    await emit('submit', formData.value)
  } finally {
    isSubmitting.value = false
  }
}

// Load master data on mount
// ... similar to SafetyBriefingForm
</script>
```

---

## 4. Reusable HSSE List Component

### HSSEList.vue
```vue
<template>
  <div class="hsse-list">
    <!-- Header -->
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-2xl font-bold">{{ title }}</h2>
      
      <button
        v-if="canCreate"
        class="btn-primary"
        @click="$emit('create')"
      >
        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
        Tambah Baru
      </button>
    </div>

    <!-- Filter Bar -->
    <HSSEFilterBar
      v-model:filters="filters"
      :show-unit-filter="showUnitFilter"
      :show-wilayah-filter="showWilayahFilter"
      :show-status-filter="showStatusFilter"
      :show-date-range="showDateRange"
      @search="handleSearch"
      @reset="handleReset"
    />

    <!-- Loading -->
    <LoadingSpinner v-if="loading" class="py-12" />

    <!-- Empty State -->
    <EmptyState
      v-else-if="!items.length"
      title="Tidak ada data"
      message="Belum ada data yang tersedia"
    />

    <!-- Table -->
    <div v-else class="overflow-x-auto">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
          <tr>
            <th
              v-for="column in columns"
              :key="column.key"
              class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
            >
              {{ column.label }}
            </th>
            <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
              Aksi
            </th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          <tr v-for="item in items" :key="item.id" class="hover:bg-gray-50">
            <td
              v-for="column in columns"
              :key="column.key"
              class="px-6 py-4 whitespace-nowrap text-sm"
            >
              <component
                :is="column.component"
                v-if="column.component"
                :value="getNestedValue(item, column.key)"
                :item="item"
              />
              <span v-else>{{ getNestedValue(item, column.key) }}</span>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
              <button
                class="text-blue-600 hover:text-blue-900 mr-3"
                @click="$emit('view', item)"
              >
                Detail
              </button>
              <button
                v-if="canEdit(item)"
                class="text-green-600 hover:text-green-900 mr-3"
                @click="$emit('edit', item)"
              >
                Edit
              </button>
              <button
                v-if="canDelete(item)"
                class="text-red-600 hover:text-red-900"
                @click="$emit('delete', item)"
              >
                Hapus
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <HSSEPagination
      v-if="!loading && items.length"
      v-model:page="pagination.page"
      :page-size="pagination.pageSize"
      :total-count="pagination.totalCount"
      @change="handlePageChange"
    />
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useAuthStore } from '@/stores/auth'

const props = defineProps({
  title: {
    type: String,
    required: true
  },
  items: {
    type: Array,
    default: () => []
  },
  columns: {
    type: Array,
    required: true
  },
  loading: Boolean,
  pagination: {
    type: Object,
    default: () => ({
      page: 1,
      pageSize: 20,
      totalCount: 0
    })
  },
  showUnitFilter: Boolean,
  showWilayahFilter: Boolean,
  showStatusFilter: Boolean,
  showDateRange: Boolean,
  canCreate: {
    type: Boolean,
    default: true
  }
})

const emit = defineEmits(['create', 'view', 'edit', 'delete', 'filter', 'page-change'])

const authStore = useAuthStore()
const filters = ref({})

const getNestedValue = (obj, path) => {
  return path.split('.').reduce((acc, part) => acc && acc[part], obj)
}

const canEdit = (item) => {
  return (
    item.status === 'draft' || 
    item.status === 'submitted' || 
    authStore.isAdmin ||
    authStore.isManager
  )
}

const canDelete = (item) => {
  return (
    item.status === 'draft' || 
    authStore.isAdmin
  )
}

const handleSearch = () => {
  emit('filter', filters.value)
}

const handleReset = () => {
  filters.value = {}
  emit('filter', {})
}

const handlePageChange = (page) => {
  emit('page-change', page)
}
</script>
```

---

## Summary

**Form Components Created**:
1. ✅ **Base Components** (5): Input, Textarea, Select, DatePicker, FileUpload
2. ✅ **Safety Briefing Form**: Complete form dengan validation
3. ✅ **Silent Inspection Form**: Dengan dynamic checklist
4. ✅ **Reusable List Component**: Generic list dengan filter & pagination

**Features**:
- Form validation dengan custom validators
- File upload dengan progress indicator
- Image preview
- Error handling
- Loading states
- Responsive layout (Grid untuk desktop, Stack untuk mobile)

**Next**: Dashboard dengan Chart (05_DASHBOARD_CHART.md)
