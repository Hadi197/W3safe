<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex justify-between items-center">
      <div>
        <h1 class="text-2xl font-bold text-gray-900">Safety Briefing</h1>
        <p class="text-gray-600 mt-1">Kelola data safety briefing harian</p>
      </div>
      <button @click="openModal" class="btn-primary">
        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
        Tambah Safety Briefing
      </button>
    </div>

    <!-- Filters -->
    <div class="card p-4">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div>
          <label class="label">Cari</label>
          <input 
            v-model="searchQuery" 
            type="text" 
            placeholder="Cari topik..."
            class="input-field"
          />
        </div>
        <div>
          <label class="label">Unit</label>
          <select v-model="filterUnit" class="input-field">
            <option value="">Semua Unit</option>
            <option v-for="unit in units" :key="unit.id" :value="unit.id">
              {{ unit.nama }}
            </option>
          </select>
        </div>
        <div>
          <label class="label">Status</label>
          <select v-model="filterStatus" class="input-field">
            <option value="">Semua Status</option>
            <option value="draft">Draft</option>
            <option value="approved">Approved</option>
            <option value="rejected">Rejected</option>
          </select>
        </div>
        <div>
          <label class="label">Bulan</label>
          <input v-model="filterMonth" type="month" class="input-field" />
        </div>
      </div>
    </div>

    <!-- Table -->
    <div class="card">
      <div v-if="loading" class="text-center py-12">
        <div class="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600"></div>
        <p class="mt-2 text-gray-600">Memuat data...</p>
      </div>

      <div v-else-if="filteredItems.length === 0" class="text-center py-12">
        <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
        </svg>
        <p class="mt-4 text-gray-600">Belum ada data safety briefing</p>
        <button @click="openModal" class="btn-primary mt-4">Tambah Data Pertama</button>
      </div>

      <div v-else class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tanggal</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Topik</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Unit</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Peserta</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Foto</th>
              <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Aksi</th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-for="item in filteredItems" :key="item.id" class="hover:bg-gray-50">
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm font-medium text-gray-900">{{ formatDate(item.tanggal) }}</div>
                <div class="text-sm text-gray-500">{{ item.waktu_mulai }} - {{ item.waktu_selesai || '-' }}</div>
              </td>
              <td class="px-6 py-4">
                <div class="text-sm font-medium text-gray-900">{{ item.topik }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm text-gray-900">{{ item.unit?.nama || '-' }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                {{ item.jumlah_peserta || 0 }} orang
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span :class="getStatusClass(item.status)" class="px-2 py-1 text-xs font-semibold rounded-full">
                  {{ getStatusLabel(item.status) }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm">
                <button 
                  v-if="item.foto_dokumentasi && item.foto_dokumentasi.length > 0" 
                  @click="viewPhotos(item)"
                  class="text-primary-600 hover:text-primary-900 font-medium"
                >
                  📷 {{ item.foto_dokumentasi.length }} foto
                </button>
                <span v-else class="text-gray-400">-</span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                <button @click="viewItem(item)" class="text-primary-600 hover:text-primary-900 mr-3">
                  Detail
                </button>
                <button @click="editItem(item)" class="text-primary-600 hover:text-primary-900 mr-3">
                  Edit
                </button>
                <button @click="confirmDelete(item)" class="text-danger-600 hover:text-danger-900">
                  Hapus
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Modal Form -->
    <div v-if="showModal" class="fixed inset-0 z-50 overflow-y-auto">
      <div class="flex items-center justify-center min-h-screen px-4">
        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" @click="closeModal"></div>
        
        <div class="relative bg-white rounded-lg max-w-4xl w-full max-h-[90vh] overflow-y-auto">
          <div class="sticky top-0 bg-white border-b px-6 py-4 flex justify-between items-center z-10">
            <h3 class="text-lg font-bold text-gray-900">
              {{ isEditMode ? 'Edit Safety Briefing' : 'Tambah Safety Briefing' }}
            </h3>
            <button @click="closeModal" class="text-gray-400 hover:text-gray-600">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>

          <form @submit.prevent="handleSubmit" class="p-6 space-y-6">
            <!-- Basic Info -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="label">Tanggal <span class="text-red-500">*</span></label>
                <input v-model="form.tanggal" type="date" class="input-field" required />
              </div>
              
              <div>
                <label class="label">Unit <span class="text-red-500">*</span></label>
                <select v-model="form.unit_id" class="input-field" required>
                  <option value="">Pilih Unit</option>
                  <option v-for="unit in units" :key="unit.id" :value="unit.id">
                    {{ unit.nama }}
                  </option>
                </select>
              </div>

              <div>
                <label class="label">Waktu Mulai <span class="text-red-500">*</span></label>
                <input v-model="form.waktu_mulai" type="time" class="input-field" required />
              </div>

              <div>
                <label class="label">Waktu Selesai</label>
                <input v-model="form.waktu_selesai" type="time" class="input-field" />
              </div>
            </div>

            <div>
              <label class="label">Topik <span class="text-red-500">*</span></label>
              <input v-model="form.topik" type="text" placeholder="Contoh: Bahaya Listrik di Area Kerja" class="input-field" required />
            </div>

            <div>
              <label class="label">Materi</label>
              <textarea v-model="form.materi" rows="4" placeholder="Penjelasan materi briefing..." class="input-field"></textarea>
            </div>

            <div>
              <label class="label">Jumlah Peserta</label>
              <input v-model.number="form.jumlah_peserta" type="number" min="0" class="input-field" />
            </div>

            <!-- Upload Foto -->
            <div>
              <label class="label">Foto Dokumentasi</label>
              <div class="space-y-3">
                <div class="flex items-center space-x-3">
                  <label class="btn-secondary cursor-pointer">
                    <svg class="w-5 h-5 mr-2 inline" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                    Pilih Foto (Single/Batch)
                    <input 
                      type="file" 
                      accept="image/*" 
                      multiple 
                      @change="handleFileSelect"
                      class="hidden"
                    />
                  </label>
                  <span class="text-sm text-gray-500">Maksimal 1MB per file</span>
                </div>

                <!-- Preview Selected Files -->
                <div v-if="selectedFiles.length > 0" class="grid grid-cols-2 md:grid-cols-4 gap-3">
                  <div v-for="(file, index) in selectedFiles" :key="index" class="relative group">
                    <img :src="file.preview" :alt="file.name" class="w-full h-32 object-cover rounded-lg border" />
                    <button 
                      @click="removeFile(index)"
                      type="button"
                      class="absolute top-1 right-1 bg-red-500 text-white rounded-full p-1 opacity-0 group-hover:opacity-100 transition-opacity"
                    >
                      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                      </svg>
                    </button>
                    <p class="text-xs text-gray-600 mt-1 truncate">{{ file.name }}</p>
                  </div>
                </div>

                <!-- Existing Photos (Edit Mode) -->
                <div v-if="form.foto_dokumentasi && form.foto_dokumentasi.length > 0" class="border-t pt-3">
                  <p class="text-sm font-medium text-gray-700 mb-2">Foto yang sudah ada:</p>
                  <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
                    <div v-for="(url, index) in form.foto_dokumentasi" :key="index" class="relative group">
                      <img :src="url" alt="Existing photo" class="w-full h-32 object-cover rounded-lg border" />
                      <button 
                        @click="removeExistingPhoto(index)"
                        type="button"
                        class="absolute top-1 right-1 bg-red-500 text-white rounded-full p-1 opacity-0 group-hover:opacity-100 transition-opacity"
                      >
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div>
              <label class="label">Catatan</label>
              <textarea v-model="form.catatan" rows="3" placeholder="Catatan tambahan..." class="input-field"></textarea>
            </div>

            <div>
              <label class="label">Status</label>
              <select v-model="form.status" class="input-field">
                <option value="draft">Draft</option>
                <option value="approved">Approved</option>
                <option value="rejected">Rejected</option>
              </select>
            </div>

            <!-- Actions -->
            <div class="flex justify-end space-x-3 pt-4 border-t">
              <button type="button" @click="closeModal" class="btn-secondary">
                Batal
              </button>
              <button type="submit" :disabled="submitting" class="btn-primary disabled:opacity-50">
                <span v-if="submitting">Menyimpan...</span>
                <span v-else>{{ isEditMode ? 'Update' : 'Simpan' }}</span>
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div v-if="showDeleteModal" class="fixed inset-0 z-50 overflow-y-auto">
      <div class="flex items-center justify-center min-h-screen px-4">
        <div class="fixed inset-0 bg-gray-500 bg-opacity-75" @click="showDeleteModal = false"></div>
        
        <div class="relative bg-white rounded-lg max-w-md w-full p-6">
          <div class="text-center">
            <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100 mb-4">
              <svg class="h-6 w-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
              </svg>
            </div>
            <h3 class="text-lg font-bold text-gray-900 mb-2">Hapus Safety Briefing</h3>
            <p class="text-gray-600 mb-6">
              Apakah Anda yakin ingin menghapus data briefing: <strong>{{ itemToDelete?.topik }}</strong>?
            </p>
            <div class="flex space-x-3">
              <button @click="showDeleteModal = false" class="flex-1 btn-secondary">
                Batal
              </button>
              <button @click="handleDelete" :disabled="deleting" class="flex-1 btn-danger disabled:opacity-50">
                <span v-if="deleting">Menghapus...</span>
                <span v-else>Hapus</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Photo Viewer Modal -->
    <div v-if="showPhotoModal" class="fixed inset-0 z-50 overflow-y-auto bg-black bg-opacity-90">
      <div class="flex items-center justify-center min-h-screen p-4">
        <!-- Close Button -->
        <button 
          @click="closePhotoModal" 
          class="absolute top-4 right-4 text-white hover:text-gray-300 z-50"
        >
          <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>

        <!-- Previous Button -->
        <button 
          v-if="currentPhotos.length > 1 && currentPhotoIndex > 0"
          @click="prevPhoto" 
          class="absolute left-4 top-1/2 transform -translate-y-1/2 text-white hover:text-gray-300 bg-black bg-opacity-50 rounded-full p-3 z-50"
        >
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
          </svg>
        </button>

        <!-- Photo Display -->
        <div class="relative max-w-6xl w-full">
          <img 
            :src="currentPhotos[currentPhotoIndex]" 
            :alt="`Photo ${currentPhotoIndex + 1}`"
            class="w-full h-auto max-h-[85vh] object-contain rounded-lg"
          />
          
          <!-- Photo Counter -->
          <div class="absolute bottom-4 left-1/2 transform -translate-x-1/2 bg-black bg-opacity-70 text-white px-4 py-2 rounded-full text-sm">
            {{ currentPhotoIndex + 1 }} / {{ currentPhotos.length }}
          </div>
        </div>

        <!-- Next Button -->
        <button 
          v-if="currentPhotos.length > 1 && currentPhotoIndex < currentPhotos.length - 1"
          @click="nextPhoto" 
          class="absolute right-4 top-1/2 transform -translate-y-1/2 text-white hover:text-gray-300 bg-black bg-opacity-50 rounded-full p-3 z-50"
        >
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </button>

        <!-- Thumbnail Strip (optional) -->
        <div v-if="currentPhotos.length > 1" class="absolute bottom-20 left-1/2 transform -translate-x-1/2 flex space-x-2 max-w-4xl overflow-x-auto pb-2">
          <button
            v-for="(photo, index) in currentPhotos"
            :key="index"
            @click="currentPhotoIndex = index"
            :class="[
              'flex-shrink-0 w-16 h-16 rounded border-2 overflow-hidden',
              currentPhotoIndex === index ? 'border-white' : 'border-transparent opacity-60 hover:opacity-100'
            ]"
          >
            <img :src="photo" :alt="`Thumbnail ${index + 1}`" class="w-full h-full object-cover" />
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { format } from 'date-fns'
import { 
  safetyBriefingService, 
  type SafetyBriefing,
  type CreateSafetyBriefingDto 
} from '@/services/api/safety-briefing.service'
import { unitsService } from '@/services/api/units.service'

// Types
interface FileWithPreview extends File {
  preview: string
}

// State
const items = ref<SafetyBriefing[]>([])
const units = ref<any[]>([])
const loading = ref(false)
const showModal = ref(false)
const showDeleteModal = ref(false)
const showPhotoModal = ref(false)
const isEditMode = ref(false)
const submitting = ref(false)
const deleting = ref(false)
const itemToDelete = ref<SafetyBriefing | null>(null)
const selectedFiles = ref<FileWithPreview[]>([])
const currentItemId = ref<string | null>(null)
const currentPhotos = ref<string[]>([])
const currentPhotoIndex = ref(0)

// Filters
const searchQuery = ref('')
const filterUnit = ref('')
const filterStatus = ref('')
const filterMonth = ref('')

// Form
const form = ref({
  tanggal: '',
  waktu_mulai: '',
  waktu_selesai: '',
  unit_id: '',
  topik: '',
  materi: '',
  jumlah_peserta: 0,
  foto_dokumentasi: [] as string[],
  status: 'draft' as 'draft' | 'approved' | 'rejected',
  catatan: ''
})

// Computed
const filteredItems = computed(() => {
  let result = items.value

  if (searchQuery.value) {
    result = result.filter(item => 
      item.topik.toLowerCase().includes(searchQuery.value.toLowerCase())
    )
  }

  if (filterUnit.value) {
    result = result.filter(item => item.unit_id === filterUnit.value)
  }

  if (filterStatus.value) {
    result = result.filter(item => item.status === filterStatus.value)
  }

  if (filterMonth.value) {
    result = result.filter(item => item.tanggal.startsWith(filterMonth.value))
  }

  return result
})

// Methods
const fetchData = async () => {
  loading.value = true
  try {
    items.value = await safetyBriefingService.getAll()
  } catch (error) {
    console.error('Error fetching data:', error)
  } finally {
    loading.value = false
  }
}

const fetchUnits = async () => {
  try {
    units.value = await unitsService.getActive()
  } catch (error) {
    console.error('Error fetching units:', error)
  }
}

const handleFileSelect = (event: Event) => {
  const target = event.target as HTMLInputElement
  const files = target.files
  
  if (files) {
    Array.from(files).forEach(file => {
      if (file.size > 1 * 1024 * 1024) {
        alert(`File ${file.name} terlalu besar (maksimal 1MB)`)
        return
      }

      const reader = new FileReader()
      reader.onload = (e) => {
        const fileWithPreview = file as FileWithPreview
        fileWithPreview.preview = e.target?.result as string
        selectedFiles.value.push(fileWithPreview)
      }
      reader.readAsDataURL(file)
    })
  }
}

const removeFile = (index: number) => {
  selectedFiles.value.splice(index, 1)
}

const removeExistingPhoto = (index: number) => {
  form.value.foto_dokumentasi.splice(index, 1)
}

const openModal = () => {
  isEditMode.value = false
  currentItemId.value = null
  resetForm()
  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
  currentItemId.value = null
  resetForm()
  selectedFiles.value = []
}

const resetForm = () => {
  form.value = {
    tanggal: format(new Date(), 'yyyy-MM-dd'),
    waktu_mulai: '',
    waktu_selesai: '',
    unit_id: '',
    topik: '',
    materi: '',
    jumlah_peserta: 0,
    foto_dokumentasi: [],
    status: 'draft',
    catatan: ''
  }
}

const editItem = (item: SafetyBriefing) => {
  isEditMode.value = true
  currentItemId.value = item.id
  form.value = {
    tanggal: item.tanggal,
    waktu_mulai: item.waktu_mulai,
    waktu_selesai: item.waktu_selesai || '',
    unit_id: item.unit_id || '',
    topik: item.topik,
    materi: item.materi || '',
    jumlah_peserta: item.jumlah_peserta || 0,
    foto_dokumentasi: item.foto_dokumentasi ? [...item.foto_dokumentasi] : [],
    status: item.status,
    catatan: item.catatan || ''
  }
  showModal.value = true
}

const viewPhotos = (item: SafetyBriefing) => {
  if (item.foto_dokumentasi && item.foto_dokumentasi.length > 0) {
    currentPhotos.value = item.foto_dokumentasi
    currentPhotoIndex.value = 0
    showPhotoModal.value = true
  }
}

const nextPhoto = () => {
  if (currentPhotoIndex.value < currentPhotos.value.length - 1) {
    currentPhotoIndex.value++
  }
}

const prevPhoto = () => {
  if (currentPhotoIndex.value > 0) {
    currentPhotoIndex.value--
  }
}

const closePhotoModal = () => {
  showPhotoModal.value = false
  currentPhotos.value = []
  currentPhotoIndex.value = 0
}

const viewItem = (item: SafetyBriefing) => {
  viewPhotos(item)
}

const handleSubmit = async () => {
  submitting.value = true
  try {
    let photoUrls: string[] = []

    // Upload new photos if any
    if (selectedFiles.value.length > 0) {
      photoUrls = await safetyBriefingService.uploadPhotos(
        selectedFiles.value,
        currentItemId.value || undefined
      )
    }

    // Combine with existing photos (for edit mode)
    const allPhotoUrls = [...form.value.foto_dokumentasi, ...photoUrls]

    const dto: CreateSafetyBriefingDto = {
      tanggal: form.value.tanggal,
      waktu_mulai: form.value.waktu_mulai,
      waktu_selesai: form.value.waktu_selesai || undefined,
      unit_id: form.value.unit_id || undefined,
      topik: form.value.topik,
      materi: form.value.materi || undefined,
      jumlah_peserta: form.value.jumlah_peserta,
      foto_dokumentasi: allPhotoUrls.length > 0 ? allPhotoUrls : undefined,
      status: form.value.status,
      catatan: form.value.catatan || undefined
    }

    if (isEditMode.value && currentItemId.value) {
      await safetyBriefingService.update(currentItemId.value, dto)
    } else {
      await safetyBriefingService.create(dto)
    }

    alert('Data berhasil disimpan!')
    closeModal()
    await fetchData()
  } catch (error) {
    console.error('Error saving data:', error)
    alert('Gagal menyimpan data')
  } finally {
    submitting.value = false
  }
}

const confirmDelete = (item: SafetyBriefing) => {
  itemToDelete.value = item
  showDeleteModal.value = true
}

const handleDelete = async () => {
  if (!itemToDelete.value) return
  
  deleting.value = true
  try {
    await safetyBriefingService.delete(itemToDelete.value.id)
    alert('Data berhasil dihapus!')
    showDeleteModal.value = false
    await fetchData()
  } catch (error) {
    console.error('Error deleting:', error)
    alert('Gagal menghapus data')
  } finally {
    deleting.value = false
  }
}

const formatDate = (date: string) => {
  return format(new Date(date), 'dd MMM yyyy')
}

const getStatusClass = (status: string) => {
  const classes: Record<string, string> = {
    draft: 'bg-gray-100 text-gray-800',
    approved: 'bg-green-100 text-green-800',
    rejected: 'bg-red-100 text-red-800'
  }
  return classes[status] || 'bg-gray-100 text-gray-800'
}

const getStatusLabel = (status: string) => {
  const labels: Record<string, string> = {
    draft: 'Draft',
    approved: 'Approved',
    rejected: 'Rejected'
  }
  return labels[status] || status
}

// Keyboard navigation for photo viewer
const handleKeyPress = (event: KeyboardEvent) => {
  if (!showPhotoModal.value) return
  
  if (event.key === 'ArrowLeft') {
    prevPhoto()
  } else if (event.key === 'ArrowRight') {
    nextPhoto()
  } else if (event.key === 'Escape') {
    closePhotoModal()
  }
}

// Lifecycle
onMounted(() => {
  fetchData()
  fetchUnits()
  
  // Add keyboard event listener
  window.addEventListener('keydown', handleKeyPress)
})

// Cleanup
onUnmounted(() => {
  window.removeEventListener('keydown', handleKeyPress)
})
</script>
