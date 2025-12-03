<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-4">
      <div>
        <h1 class="text-2xl md:text-3xl font-bold text-gray-900">Safety Briefing</h1>
        <p class="text-gray-600 mt-1">Kelola data safety briefing harian</p>
      </div>
      <button @click="openModal" class="btn-primary flex items-center justify-center w-full sm:w-auto">
        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
        Tambah Safety Briefing
      </button>
    </div>

    <!-- Filters -->
    <div class="card p-4">
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <div>
          <label class="label">Cari</label>
          <input 
            v-model="searchQuery" 
            @input="applyFilters"
            type="text" 
            placeholder="Cari topik..."
            class="input-field"
          />
        </div>
        <div>
          <label class="label">Unit</label>
          <select v-model="filterUnit" @change="applyFilters" class="input-field">
            <option value="">Semua Unit</option>
            <option v-for="unit in units" :key="unit.id" :value="unit.id">
              {{ unit.nama }}
            </option>
          </select>
        </div>
        <div>
          <label class="label">Status</label>
          <select v-model="filterStatus" @change="applyFilters" class="input-field">
            <option value="">Semua Status</option>
            <option value="draft">Draft</option>
            <option value="submitted">Submitted</option>
            <option value="approved">Approved</option>
          </select>
        </div>
        <div>
          <label class="label">Bulan</label>
          <input v-model="filterMonth" @change="applyFilters" type="month" class="input-field" />
        </div>
      </div>
    </div>

    <!-- Table -->
    <div class="card">
      <div v-if="loading" class="text-center py-12">
        <div class="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600"></div>
        <p class="mt-2 text-gray-600">Memuat data...</p>
      </div>

      <div v-else-if="items.length === 0" class="text-center py-12">
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
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Foto</th>
              <th class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase">Aksi</th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-for="item in items" :key="item.id" class="hover:bg-gray-50">
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
                <div class="flex gap-2 justify-end">
                  <button
                    @click="viewItem(item)"
                    class="text-blue-600 hover:text-blue-900"
                    title="Detail"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                    </svg>
                  </button>
                  <button
                    @click="editItem(item)"
                    class="text-green-600 hover:text-green-900"
                    title="Edit"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                    </svg>
                  </button>
                  <button
                    @click="confirmDelete(item)"
                    class="text-red-600 hover:text-red-900"
                    title="Hapus"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>

        <!-- Pagination Controls -->
        <div v-if="items.length > 0" class="px-6 py-4 border-t border-gray-200 bg-gray-50">
          <div class="flex flex-col sm:flex-row justify-between items-center gap-4">
            <!-- Info -->
            <div class="text-sm text-gray-700">
              {{ paginationInfo }}
            </div>

            <!-- Page Size Selector -->
            <div class="flex items-center gap-2">
              <label class="text-sm text-gray-700">Items per page:</label>
              <select 
                v-model.number="pageSize" 
                @change="changePageSize(pageSize)"
                class="input-field py-1 pr-8"
              >
                <option :value="10">10</option>
                <option :value="25">25</option>
                <option :value="50">50</option>
                <option :value="100">100</option>
              </select>
            </div>

            <!-- Page Navigation -->
            <div class="flex items-center gap-2">
              <button
                @click="prevPage"
                :disabled="currentPage === 1"
                class="px-3 py-1 rounded border text-sm disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-100"
              >
                Previous
              </button>

              <button
                v-for="page in pageNumbers"
                :key="page"
                @click="goToPage(page)"
                :class="[
                  'px-3 py-1 rounded border text-sm',
                  page === currentPage
                    ? 'bg-primary-600 text-white border-primary-600'
                    : 'hover:bg-gray-100'
                ]"
              >
                {{ page }}
              </button>

              <button
                @click="nextPage"
                :disabled="currentPage === totalPages"
                class="px-3 py-1 rounded border text-sm disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-100"
              >
                Next
              </button>
            </div>
          </div>
        </div>
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
                <div class="flex items-center gap-4">
                  <!-- File input dari galeri -->
                  <input type="file" accept="image/*" multiple @change="handleFileSelect" class="hidden" ref="fileInputBriefing" />
                  <!-- File input dari kamera -->
                  <input type="file" accept="image/*" capture="environment" @change="handleFileSelect" class="hidden" ref="cameraInputBriefing" />
                  <div class="flex gap-2 flex-1">
                    <button type="button" @click="($refs.cameraInputBriefing as any)?.click()" class="flex-1 btn-secondary flex items-center justify-center gap-2">
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                      </svg>
                      Ambil Foto
                    </button>
                    <button type="button" @click="($refs.fileInputBriefing as any)?.click()" class="flex-1 btn-secondary flex items-center justify-center gap-2">
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                      </svg>
                      Pilih dari Galeri
                    </button>
                  </div>
                  <span class="text-sm text-gray-500">📸 Foto akan dikompres otomatis jika >1MB</span>
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
import { useImageCompression } from '@/composables/useImageCompression'
import { 
  safetyBriefingService, 
  type SafetyBriefing,
  type CreateSafetyBriefingDto,
  type PaginationParams,
  type PaginatedResponse
} from '@/services/api/safety-briefing.service'
import { unitsService } from '@/services/api/units.service'

// Types
interface FileWithPreview extends File {
  preview: string
}

const { compressSingleImage, formatFileSize } = useImageCompression()

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

// Pagination
const currentPage = ref(1)
const pageSize = ref(10)
const totalRecords = ref(0)
const totalPages = ref(0)

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
  status: 'draft' as 'draft' | 'submitted' | 'approved',
  catatan: ''
})

// Computed
const paginationInfo = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value + 1
  const end = Math.min(currentPage.value * pageSize.value, totalRecords.value)
  return `Menampilkan ${start}-${end} dari ${totalRecords.value} data`
})

const pageNumbers = computed(() => {
  const pages = []
  const maxVisible = 5
  let startPage = Math.max(1, currentPage.value - Math.floor(maxVisible / 2))
  let endPage = Math.min(totalPages.value, startPage + maxVisible - 1)

  if (endPage - startPage + 1 < maxVisible) {
    startPage = Math.max(1, endPage - maxVisible + 1)
  }

  for (let i = startPage; i <= endPage; i++) {
    pages.push(i)
  }
  return pages
})

// Methods
const fetchData = async () => {
  loading.value = true
  try {
    const params: PaginationParams = {
      page: currentPage.value,
      pageSize: pageSize.value
    }

    const filters = {
      searchQuery: searchQuery.value || undefined,
      unitId: filterUnit.value || undefined,
      status: filterStatus.value as 'draft' | 'submitted' | 'approved' | undefined,
      month: filterMonth.value || undefined
    }

    const response: PaginatedResponse<SafetyBriefing> = await safetyBriefingService.getPaginated(params, filters)
    console.log('Safety Briefing Response:', response.data)
    console.log('First item unit:', response.data[0]?.unit)
    items.value = response.data
    totalRecords.value = response.count
    totalPages.value = response.totalPages
  } catch (error) {
    console.error('Error fetching data:', error)
  } finally {
    loading.value = false
  }
}

const fetchUnits = async () => {
  try {
    // Use service method that gets all active units including wilayah and areas
    units.value = await unitsService.getAllActiveHierarchical()
    console.log('✅ Loaded units:', units.value.length)
    console.log('📋 Units:', units.value.map(u => `${u.nama} (${u.tipe || 'unknown'})`))
  } catch (error) {
    console.error('❌ Error fetching units:', error)
    units.value = []
  }
}

const goToPage = (page: number) => {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
    fetchData()
  }
}

const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++
    fetchData()
  }
}

const prevPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--
    fetchData()
  }
}

const changePageSize = (newSize: number) => {
  pageSize.value = newSize
  currentPage.value = 1
  fetchData()
}

const applyFilters = () => {
  currentPage.value = 1
  fetchData()
}

const handleFileSelect = async (event: Event) => {
  const target = event.target as HTMLInputElement
  const files = target.files
  
  if (files) {
    for (const file of Array.from(files)) {
      // Auto-compress if >1MB
      const result = await compressSingleImage(file)
      const compressedFile = result.file
      
      if (result.wasCompressed) {
        console.log(`📸 ${file.name}: ${formatFileSize(result.originalSize)} → ${formatFileSize(result.compressedSize)} (${Math.round((1 - result.compressedSize / result.originalSize) * 100)}% lebih kecil)`)
      }

      const reader = new FileReader()
      reader.onload = (e) => {
        const fileWithPreview = compressedFile as FileWithPreview
        fileWithPreview.preview = e.target?.result as string
        selectedFiles.value.push(fileWithPreview)
      }
      reader.readAsDataURL(compressedFile)
    }
  }
  target.value = ''
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
      try {
        photoUrls = await safetyBriefingService.uploadPhotos(
          selectedFiles.value,
          currentItemId.value || undefined
        )
      } catch (photoError) {
        console.warn('Photo upload failed, continuing without photos:', photoError)
        alert('Peringatan: Upload foto gagal, data akan disimpan tanpa foto')
      }
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
      catatan: form.value.catatan || undefined
    }

    console.log('📤 Sending DTO:', JSON.stringify(dto, null, 2))
    console.log('Status value:', form.value.status, 'Type:', typeof form.value.status)

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
    submitted: 'bg-blue-100 text-blue-800',
    approved: 'bg-green-100 text-green-800'
  }
  return classes[status] || 'bg-gray-100 text-gray-800'
}

const getStatusLabel = (status: string) => {
  const labels: Record<string, string> = {
    draft: 'Draft',
    submitted: 'Submitted',
    approved: 'Approved'
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
