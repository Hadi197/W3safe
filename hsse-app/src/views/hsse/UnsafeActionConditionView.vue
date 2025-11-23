<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex justify-between items-center">
      <div>
        <h1 class="text-3xl font-bold text-gray-900">Unsafe Action/Condition</h1>
        <p class="text-gray-600 mt-1">Laporan real-time untuk unsafe action dan unsafe condition</p>
      </div>
      <button
        @click="showForm = true; selectedIncident = null"
        class="bg-primary-600 hover:bg-primary-700 text-white px-6 py-3 rounded-lg font-medium transition-colors duration-200 flex items-center space-x-2"
      >
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
        </svg>
        <span>Laporan Baru</span>
      </button>
    </div>

    <!-- Statistics Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
      <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-sm font-medium text-gray-600">Total Laporan</p>
            <p class="text-3xl font-bold text-gray-900">{{ stats.total_incidents }}</p>
          </div>
          <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
            <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
          </div>
        </div>
      </div>

      <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-sm font-medium text-gray-600">Unsafe Action</p>
            <p class="text-3xl font-bold text-red-600">{{ stats.by_type.unsafe_action }}</p>
          </div>
          <div class="w-12 h-12 bg-red-100 rounded-lg flex items-center justify-center">
            <svg class="w-6 h-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L4.082 16.5c-.77.833.192 2.5 1.732 2.5z" />
            </svg>
          </div>
        </div>
      </div>

      <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-sm font-medium text-gray-600">Unsafe Condition</p>
            <p class="text-3xl font-bold text-orange-600">{{ stats.by_type.unsafe_condition }}</p>
          </div>
          <div class="w-12 h-12 bg-orange-100 rounded-lg flex items-center justify-center">
            <svg class="w-6 h-6 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
            </svg>
          </div>
        </div>
      </div>

      <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-sm font-medium text-gray-600">7 Hari Terakhir</p>
            <p class="text-3xl font-bold text-green-600">{{ stats.recent_incidents }}</p>
          </div>
          <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
            <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
        </div>
      </div>
    </div>

    <!-- Filters -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Cari</label>
          <input
            v-model="filters.search"
            type="text"
            placeholder="Deskripsi, lokasi, pelapor..."
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Jenis Kejadian</label>
          <select
            v-model="filters.jenis_kejadian"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
            <option value="">Semua</option>
            <option value="unsafe_action">Unsafe Action</option>
            <option value="unsafe_condition">Unsafe Condition</option>
          </select>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Status</label>
          <select
            v-model="filters.status"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
            <option value="">Semua</option>
            <option value="draft">Draft</option>
            <option value="reported">Reported</option>
            <option value="investigating">Investigating</option>
            <option value="resolved">Resolved</option>
            <option value="closed">Closed</option>
          </select>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Prioritas</label>
          <select
            v-model="filters.prioritas"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
          >
            <option value="">Semua</option>
            <option value="low">Low</option>
            <option value="medium">Medium</option>
            <option value="high">High</option>
            <option value="critical">Critical</option>
          </select>
        </div>
      </div>
    </div>

    <!-- Incidents Table -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tanggal</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Jenis</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Lokasi</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Pelapor</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Prioritas</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-for="incident in incidents" :key="incident.id" class="hover:bg-gray-50">
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                <div>
                  <div class="font-medium">{{ formatDate(incident.tanggal_kejadian) }}</div>
                  <div class="text-gray-500">{{ incident.waktu_kejadian }}</div>
                </div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span
                  :class="[
                    'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium',
                    incident.jenis_kejadian === 'unsafe_action'
                      ? 'bg-red-100 text-red-800'
                      : 'bg-orange-100 text-orange-800'
                  ]"
                >
                  {{ incident.jenis_kejadian === 'unsafe_action' ? 'Unsafe Action' : 'Unsafe Condition' }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                <div>
                  <div class="font-medium">{{ incident.lokasi_kejadian }}</div>
                  <div class="text-gray-500">{{ incident.unit_kerja }}</div>
                </div>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                {{ incident.pelapor_nama }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span
                  :class="[
                    'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium',
                    {
                      'bg-gray-100 text-gray-800': incident.prioritas === 'low',
                      'bg-yellow-100 text-yellow-800': incident.prioritas === 'medium',
                      'bg-orange-100 text-orange-800': incident.prioritas === 'high',
                      'bg-red-100 text-red-800': incident.prioritas === 'critical'
                    }
                  ]"
                >
                  {{ incident.prioritas }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap">
                <span
                  :class="[
                    'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium',
                    {
                      'bg-gray-100 text-gray-800': incident.status === 'draft',
                      'bg-blue-100 text-blue-800': incident.status === 'reported',
                      'bg-yellow-100 text-yellow-800': incident.status === 'investigating',
                      'bg-green-100 text-green-800': incident.status === 'resolved',
                      'bg-purple-100 text-purple-800': incident.status === 'closed'
                    }
                  ]"
                >
                  {{ incident.status }}
                </span>
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                <button
                  @click="viewIncident(incident)"
                  class="text-primary-600 hover:text-primary-900"
                >
                  Lihat
                </button>
                <button
                  @click="editIncident(incident)"
                  class="text-blue-600 hover:text-blue-900"
                >
                  Edit
                </button>
                <button
                  @click="deleteIncident(incident.id)"
                  class="text-red-600 hover:text-red-900"
                >
                  Hapus
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Pagination -->
      <div class="bg-white px-4 py-3 flex items-center justify-between border-t border-gray-200">
        <div class="flex-1 flex justify-between sm:hidden">
          <button
            @click="loadIncidents(currentPage - 1)"
            :disabled="currentPage === 1"
            class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50"
          >
            Previous
          </button>
          <button
            @click="loadIncidents(currentPage + 1)"
            :disabled="currentPage === totalPages"
            class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50"
          >
            Next
          </button>
        </div>
        <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
          <div>
            <p class="text-sm text-gray-700">
              Menampilkan <span class="font-medium">{{ (currentPage - 1) * 20 + 1 }}</span> sampai <span class="font-medium">{{ Math.min(currentPage * 20, totalIncidents) }}</span> dari <span class="font-medium">{{ totalIncidents }}</span> hasil
            </p>
          </div>
          <div>
            <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px">
              <button
                @click="loadIncidents(currentPage - 1)"
                :disabled="currentPage === 1"
                class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50"
              >
                <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
                </svg>
              </button>
              <button
                v-for="page in visiblePages"
                :key="page"
                @click="loadIncidents(page)"
                :class="[
                  'relative inline-flex items-center px-4 py-2 border text-sm font-medium',
                  page === currentPage
                    ? 'z-10 bg-primary-50 border-primary-500 text-primary-600'
                    : 'bg-white border-gray-300 text-gray-500 hover:bg-gray-50'
                ]"
              >
                {{ page }}
              </button>
              <button
                @click="loadIncidents(currentPage + 1)"
                :disabled="currentPage === totalPages"
                class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50"
              >
                <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 011.414 0z" clip-rule="evenodd" />
                </svg>
              </button>
            </nav>
          </div>
        </div>
      </div>
    </div>

    <!-- Form Modal -->
    <div
      v-if="showForm"
      class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50"
      @click.self="showForm = false"
    >
      <div class="relative top-20 mx-auto p-5 border w-11/12 max-w-4xl shadow-lg rounded-md bg-white">
        <div class="mt-3">
          <h3 class="text-lg font-medium text-gray-900 mb-4">
            {{ selectedIncident ? 'Edit' : 'Tambah' }} Laporan Unsafe Action/Condition
          </h3>

          <form @submit.prevent="saveIncident" class="space-y-6">
            <!-- Incident Details -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Tanggal Kejadian *</label>
                <input
                  v-model="formData.tanggal_kejadian"
                  type="date"
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                >
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Waktu Kejadian *</label>
                <input
                  v-model="formData.waktu_kejadian"
                  type="time"
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                >
              </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Lokasi Kejadian *</label>
                <input
                  v-model="formData.lokasi_kejadian"
                  type="text"
                  required
                  placeholder="Contoh: Dermaga Utama, Gudang B3"
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                >
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Unit Kerja *</label>
                <select
                  v-model="formData.unit_kerja"
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                >
                  <option value="">Pilih Unit Kerja</option>
                  <option value="Unit Banjarmasin">Unit Banjarmasin</option>
                  <option value="Unit Batulicin">Unit Batulicin</option>
                  <option value="Unit Benoa">Unit Benoa</option>
                  <option value="Unit Celukan Bawang">Unit Celukan Bawang</option>
                  <option value="Unit Gresik">Unit Gresik</option>
                </select>
              </div>
            </div>

            <!-- Incident Classification -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Jenis Kejadian *</label>
                <select
                  v-model="formData.jenis_kejadian"
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                >
                  <option value="">Pilih Jenis Kejadian</option>
                  <option value="unsafe_action">Unsafe Action</option>
                  <option value="unsafe_condition">Unsafe Condition</option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Kategori *</label>
                <select
                  v-model="formData.kategori"
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                >
                  <option value="">Pilih Kategori</option>
                  <optgroup v-if="formData.jenis_kejadian === 'unsafe_action'" label="Unsafe Action">
                    <option value="Tidak Menggunakan APD">Tidak Menggunakan APD</option>
                    <option value="Bekerja di Ketinggian Tanpa Pengaman">Bekerja di Ketinggian Tanpa Pengaman</option>
                    <option value="Menggunakan Peralatan Rusak">Menggunakan Peralatan Rusak</option>
                    <option value="Melakukan Shortcut">Melakukan Shortcut</option>
                    <option value="Bekerja Dalam Kondisi Lelah">Bekerja Dalam Kondisi Lelah</option>
                    <option value="Mengabaikan Prosedur">Mengabaikan Prosedur</option>
                    <option value="Lainnya">Lainnya</option>
                  </optgroup>
                  <optgroup v-if="formData.jenis_kejadian === 'unsafe_condition'" label="Unsafe Condition">
                    <option value="Pencahayaan Kurang">Pencahayaan Kurang</option>
                    <option value="Ventilasi Buruk">Ventilasi Buruk</option>
                    <option value="Lantai Licin/Basah">Lantai Licin/Basah</option>
                    <option value="Akses Terhalang">Akses Terhalang</option>
                    <option value="Kabel/Kabel Listrik Terbuka">Kabel/Kabel Listrik Terbuka</option>
                    <option value="Material Berbahaya Tidak Diberi Label">Material Berbahaya Tidak Diberi Label</option>
                    <option value="Housekeeping Buruk">Housekeeping Buruk</option>
                    <option value="Lainnya">Lainnya</option>
                  </optgroup>
                </select>
              </div>
            </div>

            <!-- Description -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Deskripsi Kejadian *</label>
              <textarea
                v-model="formData.deskripsi_kejadian"
                required
                rows="4"
                placeholder="Jelaskan detail kejadian yang terjadi..."
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              ></textarea>
            </div>

            <!-- Reporter Info -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Nama Pelapor *</label>
                <input
                  v-model="formData.pelapor_nama"
                  type="text"
                  required
                  placeholder="Nama lengkap pelapor"
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                >
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Jabatan Pelapor</label>
                <input
                  v-model="formData.pelapor_jabatan"
                  type="text"
                  placeholder="Contoh: Safety Officer, Supervisor"
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                >
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Kontak Pelapor</label>
                <input
                  v-model="formData.pelapor_kontak"
                  type="tel"
                  placeholder="No. telepon/email"
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                >
              </div>
            </div>

            <!-- Priority and Immediate Actions -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Prioritas</label>
                <select
                  v-model="formData.prioritas"
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                >
                  <option value="low">Low</option>
                  <option value="medium" selected>Medium</option>
                  <option value="high">High</option>
                  <option value="critical">Critical</option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Severity Level (1-5)</label>
                <input
                  v-model.number="formData.severity_level"
                  type="number"
                  min="1"
                  max="5"
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
                >
              </div>
            </div>

            <!-- Immediate Actions -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Tindakan Segera</label>
              <textarea
                v-model="formData.tindakan_segera"
                rows="3"
                placeholder="Tindakan yang telah dilakukan untuk menangani kejadian..."
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500"
              ></textarea>
            </div>

            <!-- Photo Capture Section -->
            <div class="border-t pt-6">
              <h4 class="text-lg font-medium text-gray-900 mb-4">📸 Dokumentasi Foto/Video</h4>

              <!-- Camera Controls -->
              <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                <button
                  type="button"
                  @click="capturePhoto"
                  class="flex items-center justify-center px-4 py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-lg font-medium transition-colors duration-200"
                >
                  <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                  </svg>
                  Ambil Foto
                </button>

                <button
                  type="button"
                  @click="selectFile('photo')"
                  class="flex items-center justify-center px-4 py-3 bg-green-600 hover:bg-green-700 text-white rounded-lg font-medium transition-colors duration-200"
                >
                  <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
                  </svg>
                  Upload Foto
                </button>

                <button
                  type="button"
                  @click="selectFile('video')"
                  class="flex items-center justify-center px-4 py-3 bg-purple-600 hover:bg-purple-700 text-white rounded-lg font-medium transition-colors duration-200"
                >
                  <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z" />
                  </svg>
                  Upload Video
                </button>
              </div>

              <!-- Hidden file inputs -->
              <input
                ref="photoInput"
                type="file"
                accept="image/*"
                @change="handleFileUpload('photo', $event)"
                class="hidden"
              >
              <input
                ref="videoInput"
                type="file"
                accept="video/*"
                @change="handleFileUpload('video', $event)"
                class="hidden"
              >

              <!-- Photo/Video Preview -->
              <div v-if="formData.foto_kejadian && formData.foto_kejadian.length > 0" class="mb-4">
                <h5 class="text-sm font-medium text-gray-700 mb-2">Foto Terupload:</h5>
                <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                  <div v-for="(photo, index) in formData.foto_kejadian" :key="index" class="relative">
                    <img :src="photo" :alt="`Foto ${index + 1}`" class="w-full h-24 object-cover rounded-lg border">
                    <button
                      type="button"
                      @click="removeMedia('foto_kejadian', index)"
                      class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-xs"
                    >
                      ×
                    </button>
                  </div>
                </div>
              </div>

              <div v-if="formData.video_kejadian && formData.video_kejadian.length > 0" class="mb-4">
                <h5 class="text-sm font-medium text-gray-700 mb-2">Video Terupload:</h5>
                <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                  <div v-for="(video, index) in formData.video_kejadian" :key="index" class="relative">
                    <video :src="video" class="w-full h-24 object-cover rounded-lg border" controls></video>
                    <button
                      type="button"
                      @click="removeMedia('video_kejadian', index)"
                      class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-xs"
                    >
                      ×
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <!-- Form Actions -->
            <div class="flex justify-end space-x-3 pt-6 border-t">
              <button
                type="button"
                @click="showForm = false"
                class="px-6 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors duration-200"
              >
                Batal
              </button>
              <button
                type="submit"
                :disabled="saving"
                class="px-6 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg font-medium transition-colors duration-200 disabled:opacity-50"
              >
                {{ saving ? 'Menyimpan...' : 'Simpan' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, watch, onMounted } from 'vue'
import { UnsafeActionConditionService } from '@/services/hsse/unsafe-action-condition.service'

// Reactive data
const incidents = ref<any[]>([])
const stats = reactive({
  total_incidents: 0,
  by_type: { unsafe_action: 0, unsafe_condition: 0 },
  by_status: { draft: 0, reported: 0, investigating: 0, resolved: 0, closed: 0 },
  by_priority: { low: 0, medium: 0, high: 0, critical: 0 },
  recent_incidents: 0
})

const filters = reactive({
  search: '',
  jenis_kejadian: '',
  status: '',
  prioritas: ''
})

const currentPage = ref(1)
const totalPages = ref(1)
const totalIncidents = ref(0)
const showForm = ref(false)
const selectedIncident = ref(null)
const saving = ref(false)

// Form data
const formData = reactive({
  tanggal_kejadian: new Date().toISOString().split('T')[0],
  waktu_kejadian: new Date().toTimeString().slice(0, 5),
  lokasi_kejadian: '',
  unit_kerja: '',
  jenis_kejadian: '',
  kategori: '',
  sub_kategori: '',
  deskripsi_kejadian: '',
  penyebab_diduga: '',
  potensi_risiko: '',
  pelapor_nama: '',
  pelapor_jabatan: '',
  pelapor_kontak: '',
  tindakan_segera: '',
  area_diamankan: false,
  korban_ada: false,
  korban_jumlah: 0,
  foto_kejadian: [],
  video_kejadian: [],
  audio_catatan: '',
  prioritas: 'medium',
  severity_level: null,
  latitude: null,
  longitude: null,
  gps_accuracy: null
})

// Refs for file inputs
const photoInput = ref()
const videoInput = ref()

// Methods
const loadIncidents = async (page = 1) => {
  try {
    currentPage.value = page
    const result = await UnsafeActionConditionService.getAll({
      ...filters,
      page,
      limit: 20
    })
    incidents.value = result.data
    totalIncidents.value = result.total
    totalPages.value = result.totalPages
  } catch (error) {
    console.error('Error loading incidents:', error)
  }
}

const loadStats = async () => {
  try {
    const result = await UnsafeActionConditionService.getStatistics()
    Object.assign(stats, result)
  } catch (error) {
    console.error('Error loading stats:', error)
  }
}

const viewIncident = (incident: any) => {
  // TODO: Implement view modal
  console.log('View incident:', incident)
}

const editIncident = (incident: any) => {
  selectedIncident.value = incident
  Object.assign(formData, incident)
  showForm.value = true
}

const deleteIncident = async (id: string) => {
  if (!confirm('Apakah Anda yakin ingin menghapus laporan ini?')) return

  try {
    await UnsafeActionConditionService.delete(id)
    await loadIncidents(currentPage.value)
    await loadStats()
  } catch (error) {
    console.error('Error deleting incident:', error)
    alert('Gagal menghapus laporan')
  }
}

const saveIncident = async () => {
  saving.value = true
  try {
    if (selectedIncident.value) {
      await UnsafeActionConditionService.update((selectedIncident.value as any).id, formData as any)
    } else {
      await UnsafeActionConditionService.create(formData as any)
    }

    showForm.value = false
    resetForm()
    await loadIncidents(1)
    await loadStats()
  } catch (error) {
    console.error('Error saving incident:', error)
    alert('Gagal menyimpan laporan')
  } finally {
    saving.value = false
  }
}

const resetForm = () => {
  selectedIncident.value = null
  Object.assign(formData, {
    tanggal_kejadian: new Date().toISOString().split('T')[0],
    waktu_kejadian: new Date().toTimeString().slice(0, 5),
    lokasi_kejadian: '',
    unit_kerja: '',
    jenis_kejadian: '',
    kategori: '',
    sub_kategori: '',
    deskripsi_kejadian: '',
    penyebab_diduga: '',
    potensi_risiko: '',
    pelapor_nama: '',
    pelapor_jabatan: '',
    pelapor_kontak: '',
    tindakan_segera: '',
    area_diamankan: false,
    korban_ada: false,
    korban_jumlah: 0,
    foto_kejadian: [],
    video_kejadian: [],
    audio_catatan: '',
    prioritas: 'medium',
    severity_level: null,
    latitude: null,
    longitude: null,
    gps_accuracy: null
  })
}

const capturePhoto = async () => {
  try {
    // Check if device supports camera
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
      alert('Kamera tidak didukung pada perangkat ini')
      return
    }

    const stream = await navigator.mediaDevices.getUserMedia({
      video: { facingMode: 'environment' } // Use back camera if available
    })

    // Create video element to capture from
    const video = document.createElement('video')
    video.srcObject = stream
    video.play()

    // Create canvas to capture image
    const canvas = document.createElement('canvas')
    const ctx = canvas.getContext('2d')

    if (!ctx) {
      alert('Canvas context not available')
      return
    }

    // Wait for video to be ready
    video.onloadedmetadata = () => {
      canvas.width = video.videoWidth
      canvas.height = video.videoHeight

      // Draw video frame to canvas
      ctx.drawImage(video, 0, 0)

      // Convert to blob
      canvas.toBlob(async (blob) => {
        if (blob) {
          const file = new File([blob], `photo_${Date.now()}.jpg`, { type: 'image/jpeg' })
          await handlePhotoUpload(file)
        }

        // Stop camera
        stream.getTracks().forEach(track => track.stop())
      }, 'image/jpeg', 0.8)
    }
  } catch (error) {
    console.error('Error capturing photo:', error)
    alert('Gagal mengambil foto. Pastikan memberikan izin akses kamera.')
  }
}

const selectFile = (type: string) => {
  if (type === 'photo') {
    photoInput.value.click()
  } else if (type === 'video') {
    videoInput.value.click()
  }
}

const handleFileUpload = async (type: string, event: any) => {
  const file = event.target.files[0]
  if (!file) return

  try {
    if (type === 'photo') {
      await handlePhotoUpload(file)
    } else if (type === 'video') {
      await handleVideoUpload(file)
    }
  } catch (error) {
    console.error(`Error uploading ${type}:`, error)
    alert(`Gagal mengupload ${type}`)
  }
}

const handlePhotoUpload = async (file: File) => {
  // Check file size - only compress if > 1MB (1,048,576 bytes)
  const maxSizeInBytes = 1 * 1024 * 1024 // 1MB
  let fileToUpload = file

  if (file.size > maxSizeInBytes) {
    console.log(`📸 File size ${(file.size / (1024 * 1024)).toFixed(2)}MB > 1MB, compressing...`)
    fileToUpload = await compressImage(file)
    console.log(`✅ Compressed to ${(fileToUpload.size / (1024 * 1024)).toFixed(2)}MB`)
  } else {
    console.log(`📸 File size ${(file.size / (1024 * 1024)).toFixed(2)}MB <= 1MB, uploading as-is`)
  }

  const url = await UnsafeActionConditionService.uploadPhoto(fileToUpload, 'temp')

  if (!formData.foto_kejadian) formData.foto_kejadian = []
  ;(formData.foto_kejadian as string[]).push(url)
}

const handleVideoUpload = async (file: File) => {
  const url = await UnsafeActionConditionService.uploadVideo(file, 'temp')

  if (!formData.video_kejadian) formData.video_kejadian = []
  ;(formData.video_kejadian as string[]).push(url)
}

const compressImage = (file: File) => {
  return new Promise<File>((resolve) => {
    const canvas = document.createElement('canvas')
    const ctx = canvas.getContext('2d')
    const img = new Image()

    if (!ctx) {
      resolve(file) // Return original file if canvas not available
      return
    }

    img.onload = () => {
      // Calculate new dimensions (max 1920px width/height)
      const maxSize = 1920
      let { width, height } = img

      if (width > height) {
        if (width > maxSize) {
          height = (height * maxSize) / width
          width = maxSize
        }
      } else {
        if (height > maxSize) {
          width = (width * maxSize) / height
          height = maxSize
        }
      }

      canvas.width = width
      canvas.height = height

      ctx.drawImage(img, 0, 0, width, height)

      canvas.toBlob((blob) => {
        if (blob) {
          resolve(new File([blob], `compressed_${Date.now()}.jpg`, { type: 'image/jpeg' }))
        } else {
          resolve(file)
        }
      }, 'image/jpeg', 0.8)
    }

    img.src = URL.createObjectURL(file)
  })
}

const removeMedia = (field: string, index: number) => {
  ;(formData as any)[field].splice(index, 1)
}

const formatDate = (dateString: string) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('id-ID', {
    day: '2-digit',
    month: 'short',
    year: 'numeric'
  })
}

// Computed
const visiblePages = computed(() => {
  const pages = []
  const start = Math.max(1, currentPage.value - 2)
  const end = Math.min(totalPages.value, currentPage.value + 2)

  for (let i = start; i <= end; i++) {
    pages.push(i)
  }

  return pages
})

// Lifecycle
onMounted(async () => {
  await loadIncidents()
  await loadStats()
})

// Watchers
watch(filters, () => {
  loadIncidents(1)
}, { deep: true })
</script>

<style scoped>
/* Custom styles for camera/video elements */
</style>
