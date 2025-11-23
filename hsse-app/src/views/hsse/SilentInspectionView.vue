<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex justify-between items-center">
      <div>
        <h1 class="text-2xl font-bold text-gray-900">Silent Inspection</h1>
        <p class="text-gray-600 mt-1">Kelola inspeksi keselamatan diam-diam di lokasi kerja</p>
      </div>
      <button @click="openModal" class="btn-primary">
        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
        Tambah Inspeksi
      </button>
    </div>

    <!-- Filters -->
    <div class="card p-4">
      <div class="grid grid-cols-1 md:grid-cols-5 gap-4">
        <div>
          <label class="label">Cari</label>
          <input 
            v-model="searchQuery" 
            type="text" 
            placeholder="Cari area..."
            class="input-field"
            @change="applyFilters"
          />
        </div>
        <div>
          <label class="label">Unit</label>
          <select v-model="filterUnit" class="input-field" @change="applyFilters">
            <option value="">Semua Unit</option>
            <option v-for="unit in units" :key="unit.id" :value="unit.id">
              {{ unit.nama }}
            </option>
          </select>
        </div>
        <div>
          <label class="label">Tingkat Risiko</label>
          <select v-model="filterRisk" class="input-field" @change="applyFilters">
            <option value="">Semua Risiko</option>
            <option value="rendah">Rendah</option>
            <option value="sedang">Sedang</option>
            <option value="tinggi">Tinggi</option>
            <option value="sangat_tinggi">Sangat Tinggi</option>
          </select>
        </div>
        <div>
          <label class="label">Status</label>
          <select v-model="filterStatus" class="input-field" @change="applyFilters">
            <option value="">Semua Status</option>
            <option value="draft">Draft</option>
            <option value="submitted">Submitted</option>
            <option value="verified">Verified</option>
            <option value="closed">Closed</option>
          </select>
        </div>
        <div>
          <label class="label">Bulan</label>
          <input v-model="filterMonth" type="month" class="input-field" @change="applyFilters" />
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
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
        </svg>
        <p class="mt-4 text-gray-600">Belum ada data silent inspection</p>
        <button @click="openModal" class="btn-primary mt-4">Tambah Data Pertama</button>
      </div>

      <div v-else class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Tanggal</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Area</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Unit</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Temuan</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Risiko</th>
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
                <div class="text-sm font-medium text-gray-900">{{ item.area_inspeksi || '-' }}</div>
                <div class="text-sm text-gray-500">{{ item.inspector?.nama || '-' }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm text-gray-900">{{ item.unit?.nama || '-' }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <div class="text-sm font-medium text-gray-900">Total: {{ item.jumlah_temuan }}</div>
                <div class="text-xs text-red-600">Critical: {{ item.temuan_critical }}</div>
                <div class="text-xs text-orange-600">Major: {{ item.temuan_major }}</div>
                <div class="text-xs text-yellow-600">Minor: {{ item.temuan_minor }}</div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span :class="getRiskClass(item.tingkat_risiko)" class="px-2 py-1 text-xs font-semibold rounded-full">
                  {{ getRiskLabel(item.tingkat_risiko) }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span :class="getStatusClass(item.status)" class="px-2 py-1 text-xs font-semibold rounded-full">
                  {{ getStatusLabel(item.status) }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm">

                <button
                  v-if="item.foto_kondisi_unsafe?.length || item.foto_perilaku_unsafe?.length"
                  @click="viewPhotos(item)"
                  class="text-primary-600 hover:text-primary-800 flex items-center gap-1"
                  title="Lihat Foto"
                >
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                  </svg>
                  {{ (item.foto_kondisi_unsafe?.length || 0) + (item.foto_perilaku_unsafe?.length || 0) }} foto
                </button>
                <span v-else class="text-gray-400">
                  - {{ item.foto_kondisi_unsafe?.length || 0 }}-{{ item.foto_perilaku_unsafe?.length || 0 }} -
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                <div class="flex gap-2 justify-end">
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
                    @click="deleteItem(item)"
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
      </div>

      <!-- Pagination Controls -->
      <div class="mt-4 flex items-center justify-between px-4 py-3 bg-white border-t border-gray-200 sm:px-6">
        <div class="flex-1 flex justify-between sm:hidden">
          <button @click="prevPage" :disabled="currentPage === 1" class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed">Previous</button>
          <button @click="nextPage" :disabled="currentPage === totalPages" class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed">Next</button>
        </div>
        <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
          <div><p class="text-sm text-gray-700">{{ paginationInfo }}</p></div>
          <div class="flex items-center gap-2">
            <label class="text-sm text-gray-700">Per halaman:</label>
            <select v-model.number="pageSize" @change="changePageSize(pageSize)" class="border border-gray-300 rounded-md text-sm px-2 py-1"><option :value="10">10</option><option :value="20">20</option><option :value="50">50</option><option :value="100">100</option></select>
          </div>
          <div>
            <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px">
              <button @click="prevPage" :disabled="currentPage === 1" class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"><svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" /></svg></button>
              <button v-if="pageNumbers.length > 0 && pageNumbers[0]! > 1" @click="goToPage(1)" class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50">1</button>
              <span v-if="pageNumbers.length > 0 && pageNumbers[0]! > 2" class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700">...</span>
              <button v-for="page in pageNumbers" :key="page" @click="goToPage(page)" :class="['relative inline-flex items-center px-4 py-2 border text-sm font-medium', page === currentPage ? 'z-10 bg-primary-600 border-primary-600 text-white' : 'bg-white border-gray-300 text-gray-700 hover:bg-gray-50']">{{ page }}</button>
              <span v-if="pageNumbers.length > 0 && pageNumbers[pageNumbers.length - 1]! < totalPages - 1" class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700">...</span>
              <button v-if="pageNumbers.length > 0 && pageNumbers[pageNumbers.length - 1]! < totalPages" @click="goToPage(totalPages)" class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50">{{ totalPages }}</button>
              <button @click="nextPage" :disabled="currentPage === totalPages" class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"><svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" /></svg></button>
            </nav>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal Form -->
    <div v-if="showModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
      <div class="bg-white rounded-lg max-w-4xl w-full max-h-[90vh] overflow-y-auto">
        <div class="sticky top-0 bg-white border-b px-6 py-4 flex justify-between items-center">
          <h2 class="text-xl font-bold">{{ isEdit ? 'Edit' : 'Tambah' }} Silent Inspection</h2>
          <button @click="closeModal" class="text-gray-400 hover:text-gray-600">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <form @submit.prevent="handleSubmit" class="p-6 space-y-6">
          <!-- Data Dasar -->
          <div>
            <h3 class="text-lg font-semibold mb-4 flex items-center">
              <svg class="w-5 h-5 mr-2 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
              Data Dasar Inspeksi
            </h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="label">Tanggal Inspeksi <span class="text-red-500">*</span></label>
                <input v-model="form.tanggal" type="date" required class="input-field" />
              </div>
              <div>
                <label class="label">Unit <span class="text-red-500">*</span></label>
                <select v-model="form.unit_id" required class="input-field">
                  <option value="">Pilih Unit</option>
                  <option v-for="unit in units" :key="unit.id" :value="unit.id">
                    {{ unit.nama }}
                  </option>
                </select>
              </div>
              <div>
                <label class="label">Waktu Mulai <span class="text-red-500">*</span></label>
                <input v-model="form.waktu_mulai" type="time" required class="input-field" />
              </div>
              <div>
                <label class="label">Waktu Selesai</label>
                <input v-model="form.waktu_selesai" type="time" class="input-field" />
              </div>
              <div class="md:col-span-2">
                <label class="label">Area Inspeksi</label>
                <input v-model="form.area_inspeksi" type="text" placeholder="Contoh: Dermaga 1, Gudang A, Workshop" class="input-field" />
              </div>
              <div>
                <label class="label">Kategori Bahaya</label>
                <select v-model="form.kategori_bahaya" class="input-field">
                  <option value="">Pilih Kategori</option>
                  <option value="fisik_mekanik">Fisik & Mekanik</option>
                  <option value="kimia">Kimia</option>
                  <option value="biologis">Biologis</option>
                  <option value="ergonomi">Ergonomi</option>
                  <option value="psikososial">Psikososial</option>
                  <option value="kombinasi">Kombinasi</option>
                </select>
              </div>
            </div>
          </div>

          <!-- Temuan -->
          <div>
            <h3 class="text-lg font-semibold mb-4 flex items-center">
              <svg class="w-5 h-5 mr-2 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
              </svg>
              Temuan Inspeksi
            </h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="label">Temuan Critical</label>
                <input v-model.number="form.temuan_critical" type="number" min="0" class="input-field" />
              </div>
              <div>
                <label class="label">Temuan Major</label>
                <input v-model.number="form.temuan_major" type="number" min="0" class="input-field" />
              </div>
              <div>
                <label class="label">Temuan Minor</label>
                <input v-model.number="form.temuan_minor" type="number" min="0" class="input-field" />
              </div>
              <div>
                <label class="label">Total Temuan</label>
                <input v-model.number="form.jumlah_temuan" type="number" min="0" class="input-field bg-gray-50" readonly />
              </div>
              <div class="md:col-span-2">
                <label class="label">Deskripsi Temuan</label>
                <textarea v-model="form.deskripsi_temuan" rows="3" placeholder="Detail temuan kondisi dan perilaku tidak aman..." class="input-field"></textarea>
              </div>
            </div>
          </div>

          <!-- Penilaian -->
          <div>
            <h3 class="text-lg font-semibold mb-4 flex items-center">
              <svg class="w-5 h-5 mr-2 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              Penilaian
            </h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label class="label">Skor Kepatuhan (%)</label>
                <input v-model.number="form.skor_kepatuhan" type="number" min="0" max="100" step="0.1" class="input-field" />
              </div>
              <div>
                <label class="label">Tingkat Risiko</label>
                <select v-model="form.tingkat_risiko" class="input-field">
                  <option value="">Pilih Tingkat Risiko</option>
                  <option value="rendah">Rendah</option>
                  <option value="sedang">Sedang</option>
                  <option value="tinggi">Tinggi</option>
                  <option value="sangat_tinggi">Sangat Tinggi</option>
                </select>
              </div>
              <div>
                <label class="label">Kondisi Housekeeping</label>
                <select v-model="form.kondisi_housekeeping" class="input-field">
                  <option value="">Pilih Kondisi</option>
                  <option value="baik">Baik</option>
                  <option value="cukup">Cukup</option>
                  <option value="buruk">Buruk</option>
                </select>
              </div>
              <div>
                <label class="label">Penggunaan APD</label>
                <select v-model="form.penggunaan_apd" class="input-field">
                  <option value="">Pilih Kondisi</option>
                  <option value="baik">Baik</option>
                  <option value="cukup">Cukup</option>
                  <option value="buruk">Buruk</option>
                </select>
              </div>
            </div>
          </div>

          <!-- Tindak Lanjut -->
          <div>
            <h3 class="text-lg font-semibold mb-4 flex items-center">
              <svg class="w-5 h-5 mr-2 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4" />
              </svg>
              Tindak Lanjut
            </h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div class="md:col-span-2">
                <label class="label">Rekomendasi</label>
                <textarea v-model="form.rekomendasi" rows="2" placeholder="Rekomendasi perbaikan..." class="input-field"></textarea>
              </div>
              <div class="md:col-span-2">
                <label class="label">Tindakan Korektif</label>
                <textarea v-model="form.tindakan_korektif" rows="2" placeholder="Tindakan yang harus dilakukan..." class="input-field"></textarea>
              </div>
              <div>
                <label class="label">PIC Tindak Lanjut</label>
                <input v-model="form.pic_tindak_lanjut" type="text" placeholder="Nama penanggung jawab" class="input-field" />
              </div>
              <div>
                <label class="label">Target Penyelesaian</label>
                <input v-model="form.target_penyelesaian" type="date" class="input-field" />
              </div>
              <div>
                <label class="label">Status Tindak Lanjut</label>
                <select v-model="form.status_tindak_lanjut" class="input-field">
                  <option value="open">Open</option>
                  <option value="in_progress">In Progress</option>
                  <option value="closed">Closed</option>
                </select>
              </div>
              <div>
                <label class="label">Status Laporan</label>
                <select v-model="form.status" class="input-field">
                  <option value="draft">Draft</option>
                  <option value="submitted">Submitted</option>
                  <option value="verified">Verified</option>
                  <option value="closed">Closed</option>
                </select>
              </div>
            </div>
          </div>

          <!-- Upload Foto Kondisi Unsafe -->
          <div>
            <h3 class="text-lg font-semibold mb-4 flex items-center">
              <svg class="w-5 h-5 mr-2 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
              Foto Kondisi Unsafe
            </h3>
            <div>
              <label class="label">Upload Foto</label>
              <!-- File input dari galeri -->
              <input type="file" accept="image/*" multiple @change="handleFileSelectKondisi" class="hidden" ref="fileInputKondisi" />
              <!-- File input dari kamera -->
              <input type="file" accept="image/*" capture="environment" @change="handleFileSelectKondisi" class="hidden" ref="cameraInputKondisi" />
              <div class="flex gap-2">
                <button type="button" @click="($refs.cameraInputKondisi as any)?.click()" class="flex-1 px-3 py-2 bg-green-600 text-white text-sm rounded hover:bg-green-700 flex items-center justify-center gap-2">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                  </svg>
                  Ambil Foto
                </button>
                <button type="button" @click="($refs.fileInputKondisi as any)?.click()" class="flex-1 px-3 py-2 bg-blue-600 text-white text-sm rounded hover:bg-blue-700 flex items-center justify-center gap-2">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                  </svg>
                  Pilih dari Galeri
                </button>
              </div>
              <p class="text-sm text-gray-500 mt-1">📸 Foto akan dikompres otomatis jika >1MB</p>
            </div>

            <!-- Preview Foto Kondisi Baru -->
            <div v-if="newPhotosKondisi.length > 0" class="mt-4">
              <h4 class="font-semibold mb-2">Preview ({{ newPhotosKondisi.length }} foto)</h4>
              <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div v-for="(photo, index) in newPhotosKondisi" :key="index" class="relative">
                  <img :src="photo.preview" class="w-full h-32 object-cover rounded-lg border" />
                  <button 
                    type="button"
                    @click="removeFileKondisi(index)" 
                    class="absolute top-1 right-1 bg-red-500 text-white rounded-full p-1 hover:bg-red-600"
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>
              </div>
            </div>

            <!-- Foto Kondisi yang Sudah Ada -->
            <div v-if="form.foto_kondisi_unsafe && form.foto_kondisi_unsafe.length > 0" class="mt-4">
              <h4 class="font-semibold mb-2">Foto Tersimpan ({{ form.foto_kondisi_unsafe.length }} foto)</h4>
              <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div v-for="(photo, index) in form.foto_kondisi_unsafe" :key="index" class="relative">
                  <img :src="photo" class="w-full h-32 object-cover rounded-lg border" />
                  <button 
                    type="button"
                    @click="removeExistingPhotoKondisi(index)" 
                    class="absolute top-1 right-1 bg-red-500 text-white rounded-full p-1 hover:bg-red-600"
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>
              </div>
            </div>
          </div>

          <!-- Upload Foto Perilaku Unsafe -->
          <div>
            <h3 class="text-lg font-semibold mb-4 flex items-center">
              <svg class="w-5 h-5 mr-2 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
              Foto Perilaku Unsafe
            </h3>
            <div>
              <label class="label">Upload Foto</label>
              <!-- File input dari galeri -->
              <input type="file" accept="image/*" multiple @change="handleFileSelectPerilaku" class="hidden" ref="fileInputPerilaku" />
              <!-- File input dari kamera -->
              <input type="file" accept="image/*" capture="environment" @change="handleFileSelectPerilaku" class="hidden" ref="cameraInputPerilaku" />
              <div class="flex gap-2">
                <button type="button" @click="($refs.cameraInputPerilaku as any)?.click()" class="flex-1 px-3 py-2 bg-green-600 text-white text-sm rounded hover:bg-green-700 flex items-center justify-center gap-2">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                  </svg>
                  Ambil Foto
                </button>
                <button type="button" @click="($refs.fileInputPerilaku as any)?.click()" class="flex-1 px-3 py-2 bg-blue-600 text-white text-sm rounded hover:bg-blue-700 flex items-center justify-center gap-2">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                  </svg>
                  Pilih dari Galeri
                </button>
              </div>
              <p class="text-sm text-gray-500 mt-1">📸 Foto akan dikompres otomatis jika >1MB</p>
            </div>

            <!-- Preview Foto Perilaku Baru -->
            <div v-if="newPhotosPerilaku.length > 0" class="mt-4">
              <h4 class="font-semibold mb-2">Preview ({{ newPhotosPerilaku.length }} foto)</h4>
              <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div v-for="(photo, index) in newPhotosPerilaku" :key="index" class="relative">
                  <img :src="photo.preview" class="w-full h-32 object-cover rounded-lg border" />
                  <button 
                    type="button"
                    @click="removeFilePerilaku(index)" 
                    class="absolute top-1 right-1 bg-red-500 text-white rounded-full p-1 hover:bg-red-600"
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>
              </div>
            </div>

            <!-- Foto Perilaku yang Sudah Ada -->
            <div v-if="form.foto_perilaku_unsafe && form.foto_perilaku_unsafe.length > 0" class="mt-4">
              <h4 class="font-semibold mb-2">Foto Tersimpan ({{ form.foto_perilaku_unsafe.length }} foto)</h4>
              <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div v-for="(photo, index) in form.foto_perilaku_unsafe" :key="index" class="relative">
                  <img :src="photo" class="w-full h-32 object-cover rounded-lg border" />
                  <button 
                    type="button"
                    @click="removeExistingPhotoPerilaku(index)" 
                    class="absolute top-1 right-1 bg-red-500 text-white rounded-full p-1 hover:bg-red-600"
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>
              </div>
            </div>
          </div>

          <!-- Catatan -->
          <div>
            <label class="label">Catatan Tambahan</label>
            <textarea v-model="form.catatan" rows="3" placeholder="Catatan lainnya..." class="input-field"></textarea>
          </div>

          <!-- Actions -->
          <div class="flex justify-end gap-3 pt-4 border-t">
            <button type="button" @click="closeModal" class="btn-secondary">Batal</button>
            <button type="submit" :disabled="submitting" class="btn-primary">
              <span v-if="submitting">Menyimpan...</span>
              <span v-else>{{ isEdit ? 'Update' : 'Simpan' }}</span>
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Photo Viewer Modal -->
    <div v-if="showPhotoModal" class="fixed inset-0 bg-black bg-opacity-90 flex items-center justify-center z-50" @click="closePhotoModal">
      <button @click="closePhotoModal" class="absolute top-4 right-4 text-white hover:text-gray-300 z-10">
        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>

      <button v-if="currentPhotoIndex > 0" @click.stop="prevPhoto" class="absolute left-4 text-white hover:text-gray-300">
        <svg class="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
        </svg>
      </button>

      <div class="max-w-6xl max-h-[85vh] px-16" @click.stop>
        <img :src="currentPhotos[currentPhotoIndex]" class="max-w-full max-h-[85vh] object-contain" />
        <div class="text-white text-center mt-4">
          {{ currentPhotoIndex + 1 }} / {{ currentPhotos.length }}
        </div>

        <!-- Thumbnail Strip -->
        <div class="flex justify-center gap-2 mt-4 overflow-x-auto pb-2">
          <img 
            v-for="(photo, index) in currentPhotos" 
            :key="index"
            :src="photo"
            @click="currentPhotoIndex = index"
            :class="['w-16 h-16 object-cover rounded cursor-pointer border-2', index === currentPhotoIndex ? 'border-white' : 'border-transparent opacity-60 hover:opacity-100']"
          />
        </div>
      </div>

      <button v-if="currentPhotoIndex < currentPhotos.length - 1" @click.stop="nextPhoto" class="absolute right-4 text-white hover:text-gray-300">
        <svg class="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
        </svg>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted, watch } from 'vue'
import { format } from 'date-fns'
import { useImageCompression } from '@/composables/useImageCompression'
import { silentInspectionService, type SilentInspection, type CreateSilentInspectionDto, type PaginatedResponse } from '@/services/api/silent-inspection.service'
import { unitsService, type Unit } from '@/services/api/units.service'

const { compressSingleImage, formatFileSize } = useImageCompression()

// State
const items = ref<SilentInspection[]>([])
const units = ref<Unit[]>([])
const loading = ref(true)
const submitting = ref(false)
const showModal = ref(false)
const isEdit = ref(false)
const editId = ref<string | null>(null)

// Filters
const searchQuery = ref('')
const filterUnit = ref('')
const filterRisk = ref('')
const filterStatus = ref('')
const filterMonth = ref('')

// Pagination
const currentPage = ref(1)
const pageSize = ref(20)
const totalRecords = ref(0)
const totalPages = ref(0)

// Form
const form = ref<CreateSilentInspectionDto>({
  tanggal: format(new Date(), 'yyyy-MM-dd'),
  waktu_mulai: '',
  waktu_selesai: '',
  unit_id: '',
  area_inspeksi: '',
  kategori_bahaya: '',
  jumlah_temuan: 0,
  temuan_critical: 0,
  temuan_major: 0,
  temuan_minor: 0,
  deskripsi_temuan: '',
  foto_kondisi_unsafe: [],
  foto_perilaku_unsafe: [],
  skor_kepatuhan: 0,
  tingkat_risiko: '',
  kondisi_housekeeping: '',
  penggunaan_apd: '',
  rekomendasi: '',
  tindakan_korektif: '',
  pic_tindak_lanjut: '',
  target_penyelesaian: '',
  status_tindak_lanjut: 'open',
  status: 'draft',
  catatan: ''
})

// Photo handling
const newPhotosKondisi = ref<{ file: File; preview: string }[]>([])
const newPhotosPerilaku = ref<{ file: File; preview: string }[]>([])
const showPhotoModal = ref(false)
const currentPhotos = ref<string[]>([])
const currentPhotoIndex = ref(0)

// Watch temuan untuk auto calculate total
watch([() => form.value.temuan_critical, () => form.value.temuan_major, () => form.value.temuan_minor], () => {
  form.value.jumlah_temuan = (form.value.temuan_critical || 0) + (form.value.temuan_major || 0) + (form.value.temuan_minor || 0)
})

// Computed
const filteredItems = computed(() => {
  return items.value
})

const paginationInfo = computed(() => {
  const start = totalRecords.value === 0 ? 0 : (currentPage.value - 1) * pageSize.value + 1
  const end = Math.min(currentPage.value * pageSize.value, totalRecords.value)
  return `Menampilkan ${start} - ${end} dari ${totalRecords.value} data`
})

const pageNumbers = computed(() => {
  const pages: number[] = []
  const maxVisible = 5
  let start = Math.max(1, currentPage.value - Math.floor(maxVisible / 2))
  let end = Math.min(totalPages.value, start + maxVisible - 1)
  if (end - start + 1 < maxVisible) {
    start = Math.max(1, end - maxVisible + 1)
  }
  for (let i = start; i <= end; i++) {
    pages.push(i)
  }
  return pages
})

// Methods
const loadData = async () => {
  try {
    loading.value = true

    // Build filters
    const filters: any = {}
    if (searchQuery.value) filters.search = searchQuery.value
    if (filterUnit.value) filters.unit_id = filterUnit.value
    if (filterRisk.value) filters.tingkat_risiko = filterRisk.value
    if (filterStatus.value) filters.status = filterStatus.value
    if (filterMonth.value) {
      const [year, month] = filterMonth.value.split('-')
      filters.tanggal_dari = `${year}-${month}-01`
      const lastDay = new Date(parseInt(year || '2024'), parseInt(month || '1'), 0).getDate()
      filters.tanggal_sampai = `${year}-${month}-${lastDay}`
    }

    const [result, unitsData] = await Promise.all([
      silentInspectionService.getPaginated(filters, { page: currentPage.value, pageSize: pageSize.value }),
      unitsService.getActive()
    ])
    
    items.value = result.data

    totalRecords.value = result.count
    totalPages.value = result.totalPages
    units.value = unitsData
  } catch (error) {
    console.error('Error loading data:', error)
    alert('Gagal memuat data')
  } finally {
    loading.value = false
  }
}

// Pagination methods
const goToPage = (page: number) => {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
    loadData()
  }
}

const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++
    loadData()
  }
}

const prevPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--
    loadData()
  }
}

const changePageSize = (newSize: number) => {
  pageSize.value = newSize
  currentPage.value = 1
  loadData()
}

const applyFilters = () => {
  currentPage.value = 1
  loadData()
}

const openModal = () => {
  isEdit.value = false
  editId.value = null
  resetForm()
  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
  resetForm()
}

const resetForm = () => {
  form.value = {
    tanggal: format(new Date(), 'yyyy-MM-dd'),
    waktu_mulai: '',
    waktu_selesai: '',
    unit_id: '',
    area_inspeksi: '',
    kategori_bahaya: '',
    jumlah_temuan: 0,
    temuan_critical: 0,
    temuan_major: 0,
    temuan_minor: 0,
    deskripsi_temuan: '',
    foto_kondisi_unsafe: [],
    foto_perilaku_unsafe: [],
    skor_kepatuhan: 0,
    tingkat_risiko: '',
    kondisi_housekeeping: '',
    penggunaan_apd: '',
    rekomendasi: '',
    tindakan_korektif: '',
    pic_tindak_lanjut: '',
    target_penyelesaian: '',
    status_tindak_lanjut: 'open',
    status: 'draft',
    catatan: ''
  }
  newPhotosKondisi.value = []
  newPhotosPerilaku.value = []
}

const editItem = async (item: SilentInspection) => {
  isEdit.value = true
  editId.value = item.id
  form.value = {
    tanggal: item.tanggal,
    waktu_mulai: item.waktu_mulai,
    waktu_selesai: item.waktu_selesai,
    unit_id: item.unit_id,
    area_inspeksi: item.area_inspeksi,
    kategori_bahaya: item.kategori_bahaya,
    jumlah_temuan: item.jumlah_temuan,
    temuan_critical: item.temuan_critical,
    temuan_major: item.temuan_major,
    temuan_minor: item.temuan_minor,
    deskripsi_temuan: item.deskripsi_temuan,
    foto_kondisi_unsafe: item.foto_kondisi_unsafe || [],
    foto_perilaku_unsafe: item.foto_perilaku_unsafe || [],
    skor_kepatuhan: item.skor_kepatuhan,
    tingkat_risiko: item.tingkat_risiko,
    kondisi_housekeeping: item.kondisi_housekeeping,
    penggunaan_apd: item.penggunaan_apd,
    rekomendasi: item.rekomendasi,
    tindakan_korektif: item.tindakan_korektif,
    pic_tindak_lanjut: item.pic_tindak_lanjut,
    target_penyelesaian: item.target_penyelesaian,
    status_tindak_lanjut: item.status_tindak_lanjut,
    status: item.status,
    catatan: item.catatan
  }
  showModal.value = true
}

const handleFileSelectKondisi = async (event: Event) => {
  const target = event.target as HTMLInputElement
  if (!target.files) return

  const files = Array.from(target.files)
  for (const file of files) {
    // Auto-compress if >1MB
    const result = await compressSingleImage(file)
    const compressedFile = result.file
    
    if (result.wasCompressed) {
      console.log(`📸 ${file.name}: ${formatFileSize(result.originalSize)} → ${formatFileSize(result.compressedSize)} (${Math.round((1 - result.compressedSize / result.originalSize) * 100)}% lebih kecil)`)
    }

    const reader = new FileReader()
    reader.onload = (e) => {
      newPhotosKondisi.value.push({
        file: compressedFile,
        preview: e.target?.result as string
      })
    }
    reader.readAsDataURL(compressedFile)
  }

  target.value = ''
}

const handleFileSelectPerilaku = async (event: Event) => {
  const target = event.target as HTMLInputElement
  if (!target.files) return

  const files = Array.from(target.files)
  for (const file of files) {
    // Auto-compress if >1MB
    const result = await compressSingleImage(file)
    const compressedFile = result.file
    
    if (result.wasCompressed) {
      console.log(`📸 ${file.name}: ${formatFileSize(result.originalSize)} → ${formatFileSize(result.compressedSize)} (${Math.round((1 - result.compressedSize / result.originalSize) * 100)}% lebih kecil)`)
    }

    const reader = new FileReader()
    reader.onload = (e) => {
      newPhotosPerilaku.value.push({
        file: compressedFile,
        preview: e.target?.result as string
      })
    }
    reader.readAsDataURL(compressedFile)
  }

  target.value = ''
}

const removeFileKondisi = (index: number) => {
  newPhotosKondisi.value.splice(index, 1)
}

const removeFilePerilaku = (index: number) => {
  newPhotosPerilaku.value.splice(index, 1)
}

const removeExistingPhotoKondisi = async (index: number) => {
  if (!confirm('Hapus foto ini?')) return
  
  if (!form.value.foto_kondisi_unsafe || !form.value.foto_kondisi_unsafe[index]) return
  
  const photoUrl = form.value.foto_kondisi_unsafe[index]
  try {
    await silentInspectionService.deletePhoto(photoUrl)
    form.value.foto_kondisi_unsafe.splice(index, 1)
  } catch (error) {
    console.error('Error deleting photo:', error)
    alert('Gagal menghapus foto')
  }
}

const removeExistingPhotoPerilaku = async (index: number) => {
  if (!confirm('Hapus foto ini?')) return
  
  if (!form.value.foto_perilaku_unsafe || !form.value.foto_perilaku_unsafe[index]) return
  
  const photoUrl = form.value.foto_perilaku_unsafe[index]
  try {
    await silentInspectionService.deletePhoto(photoUrl)
    form.value.foto_perilaku_unsafe.splice(index, 1)
  } catch (error) {
    console.error('Error deleting photo:', error)
    alert('Gagal menghapus foto')
  }
}

const handleSubmit = async () => {
  try {
    submitting.value = true

    let inspectionId = editId.value

    // Upload new photos kondisi
    if (newPhotosKondisi.value.length > 0) {
      try {
        const tempId = inspectionId || 'temp_' + Date.now()
        const files = newPhotosKondisi.value.map(p => p.file)
        console.log(`📤 Uploading ${files.length} kondisi unsafe photos...`)
        const uploadedUrls = await silentInspectionService.uploadPhotos(files, tempId)
        form.value.foto_kondisi_unsafe = [...(form.value.foto_kondisi_unsafe || []), ...uploadedUrls]
        console.log('✅ Kondisi unsafe photos uploaded successfully')
      } catch (photoError) {
        console.warn('❌ Photo upload failed for kondisi unsafe:', photoError)
        const errorMessage = photoError instanceof Error ? photoError.message : 'Unknown error'
        alert('Peringatan: Upload foto kondisi unsafe gagal, data akan disimpan tanpa foto.\n\nError: ' + errorMessage)
      }
    }

    // Upload new photos perilaku
    if (newPhotosPerilaku.value.length > 0) {
      try {
        const tempId = inspectionId || 'temp_' + Date.now()
        const files = newPhotosPerilaku.value.map(p => p.file)
        console.log(`📤 Uploading ${files.length} perilaku unsafe photos...`)
        const uploadedUrls = await silentInspectionService.uploadPhotos(files, tempId)
        form.value.foto_perilaku_unsafe = [...(form.value.foto_perilaku_unsafe || []), ...uploadedUrls]
        console.log('✅ Perilaku unsafe photos uploaded successfully')
      } catch (photoError) {
        console.warn('❌ Photo upload failed for perilaku unsafe:', photoError)
        const errorMessage = photoError instanceof Error ? photoError.message : 'Unknown error'
        alert('Peringatan: Upload foto perilaku unsafe gagal, data akan disimpan tanpa foto.\n\nError: ' + errorMessage)
      }
    }

    if (isEdit.value && inspectionId) {
      await silentInspectionService.update(inspectionId, form.value)
      alert('Data berhasil diupdate')
    } else {
      await silentInspectionService.create(form.value)
      alert('Data berhasil disimpan')
    }

    closeModal()
    await loadData()
  } catch (error) {
    console.error('Error saving data:', error)
    alert('Gagal menyimpan data')
  } finally {
    submitting.value = false
  }
}

const deleteItem = async (item: SilentInspection) => {
  if (!confirm(`Hapus inspeksi di ${item.area_inspeksi}?`)) return

  try {
    await silentInspectionService.delete(item.id)
    alert('Data berhasil dihapus')
    await loadData()
  } catch (error) {
    console.error('Error deleting item:', error)
    alert('Gagal menghapus data')
  }
}

const viewPhotos = (item: SilentInspection) => {
  const allPhotos = [
    ...(item.foto_kondisi_unsafe || []),
    ...(item.foto_perilaku_unsafe || [])
  ]

  if (allPhotos.length === 0) return

  currentPhotos.value = allPhotos
  currentPhotoIndex.value = 0
  showPhotoModal.value = true
}

const closePhotoModal = () => {
  showPhotoModal.value = false
  currentPhotos.value = []
  currentPhotoIndex.value = 0
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

const handleKeyPress = (event: KeyboardEvent) => {
  if (!showPhotoModal.value) return
  
  if (event.key === 'ArrowRight') {
    nextPhoto()
  } else if (event.key === 'ArrowLeft') {
    prevPhoto()
  } else if (event.key === 'Escape') {
    closePhotoModal()
  }
}

// Helpers
const formatDate = (dateString: string) => {
  return format(new Date(dateString), 'dd MMM yyyy')
}

const getRiskClass = (risk?: string) => {
  switch (risk) {
    case 'rendah': return 'bg-green-100 text-green-800'
    case 'sedang': return 'bg-yellow-100 text-yellow-800'
    case 'tinggi': return 'bg-orange-100 text-orange-800'
    case 'sangat_tinggi': return 'bg-red-100 text-red-800'
    default: return 'bg-gray-100 text-gray-800'
  }
}

const getRiskLabel = (risk?: string) => {
  switch (risk) {
    case 'rendah': return 'Rendah'
    case 'sedang': return 'Sedang'
    case 'tinggi': return 'Tinggi'
    case 'sangat_tinggi': return 'Sangat Tinggi'
    default: return '-'
  }
}

const getStatusClass = (status: string) => {
  switch (status) {
    case 'draft': return 'bg-gray-100 text-gray-800'
    case 'submitted': return 'bg-blue-100 text-blue-800'
    case 'verified': return 'bg-green-100 text-green-800'
    case 'closed': return 'bg-purple-100 text-purple-800'
    default: return 'bg-gray-100 text-gray-800'
  }
}

const getStatusLabel = (status: string) => {
  switch (status) {
    case 'draft': return 'Draft'
    case 'submitted': return 'Submitted'
    case 'verified': return 'Verified'
    case 'closed': return 'Closed'
    default: return status
  }
}

// Lifecycle
onMounted(() => {
  loadData()
  window.addEventListener('keydown', handleKeyPress)
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeyPress)
})
</script>
