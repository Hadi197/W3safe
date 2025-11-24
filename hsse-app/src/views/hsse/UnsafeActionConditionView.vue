<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-4">
      <div>
        <h1 class="text-2xl md:text-3xl font-bold text-gray-900">Unsafe Action/Condition</h1>
        <p class="text-gray-600 mt-1">Laporan real-time untuk unsafe action dan unsafe condition</p>
      </div>
      <button
        @click="showForm = true; selectedIncident = null"
        class="bg-primary-600 hover:bg-primary-700 active:bg-primary-800 text-white px-6 py-4 rounded-lg font-medium transition-colors duration-200 flex items-center justify-center space-x-2 w-full sm:w-auto min-h-[48px] touch-manipulation shadow-lg border-2 border-primary-500"
      >
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
        </svg>
        <span>Laporan Baru</span>
      </button>
    </div>

    <!-- Statistics Cards -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 md:gap-6">
      <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-4 md:p-6">
        <div class="flex items-center justify-between">
          <div class="flex-1 min-w-0">
            <p class="text-xs md:text-sm font-medium text-gray-600 truncate">Total Laporan</p>
            <p class="text-2xl md:text-3xl font-bold text-gray-900">{{ stats.total_incidents }}</p>
          </div>
          <div class="w-10 h-10 md:w-12 md:h-12 bg-blue-100 rounded-lg flex items-center justify-center flex-shrink-0 ml-3">
            <svg class="w-5 h-5 md:w-6 md:h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
          </div>
        </div>
      </div>

      <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-4 md:p-6">
        <div class="flex items-center justify-between">
          <div class="flex-1 min-w-0">
            <p class="text-xs md:text-sm font-medium text-gray-600 truncate">Unsafe Action</p>
            <p class="text-2xl md:text-3xl font-bold text-red-600">{{ stats.by_type.unsafe_action }}</p>
          </div>
          <div class="w-10 h-10 md:w-12 md:h-12 bg-red-100 rounded-lg flex items-center justify-center flex-shrink-0 ml-3">
            <svg class="w-5 h-5 md:w-6 md:h-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L4.082 16.5c-.77.833.192 2.5 1.732 2.5z" />
            </svg>
          </div>
        </div>
      </div>

      <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-4 md:p-6">
        <div class="flex items-center justify-between">
          <div class="flex-1 min-w-0">
            <p class="text-xs md:text-sm font-medium text-gray-600 truncate">Unsafe Condition</p>
            <p class="text-2xl md:text-3xl font-bold text-orange-600">{{ stats.by_type.unsafe_condition }}</p>
          </div>
          <div class="w-10 h-10 md:w-12 md:h-12 bg-orange-100 rounded-lg flex items-center justify-center flex-shrink-0 ml-3">
            <svg class="w-5 h-5 md:w-6 md:h-6 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
            </svg>
          </div>
        </div>
      </div>

      <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-4 md:p-6">
        <div class="flex items-center justify-between">
          <div class="flex-1 min-w-0">
            <p class="text-xs md:text-sm font-medium text-gray-600 truncate">7 Hari Terakhir</p>
            <p class="text-2xl md:text-3xl font-bold text-green-600">{{ stats.recent_incidents }}</p>
          </div>
          <div class="w-10 h-10 md:w-12 md:h-12 bg-green-100 rounded-lg flex items-center justify-center flex-shrink-0 ml-3">
            <svg class="w-5 h-5 md:w-6 md:h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
        </div>
      </div>
    </div>

    <!-- Filters -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-4 md:p-6">
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Cari</label>
          <input
            v-model="filters.search"
            type="text"
            placeholder="Deskripsi, lokasi, pelapor..."
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 text-sm"
          >
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Jenis Kejadian</label>
          <select
            v-model="filters.jenis_kejadian"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 text-sm"
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
      <div class="overflow-x-auto scrollbar-thin scrollbar-thumb-gray-400 scrollbar-track-gray-100 scrollbar-thumb-rounded-full scrollbar-track-rounded-full scroll-smooth">
        <div class="min-w-max">
          <table class="w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
              <tr>
                <th class="px-4 md:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider whitespace-nowrap">Tanggal</th>
                <th class="px-4 md:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider whitespace-nowrap">Jenis</th>
                <th class="px-4 md:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider whitespace-nowrap">Lokasi</th>
              <th class="px-4 md:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider whitespace-nowrap">Pelapor</th>
              <th class="px-4 md:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider whitespace-nowrap">Prioritas</th>
              <th class="px-4 md:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider whitespace-nowrap">Status</th>
              <th class="px-4 md:px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider whitespace-nowrap">Aksi</th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr v-for="incident in incidents" :key="incident.id" class="hover:bg-gray-50">
              <td class="px-4 md:px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                <div>
                  <div class="font-medium">{{ formatDate(incident.tanggal_kejadian) }}</div>
                  <div class="text-gray-500">{{ incident.waktu_kejadian }}</div>
                </div>
              </td>
              <td class="px-4 md:px-6 py-4 whitespace-nowrap">
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
              <td class="px-4 md:px-6 py-4 whitespace-nowrap text-sm text-gray-900">
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
              <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                <div class="flex items-center space-x-3">
                  <button
                    @click="viewIncident(incident)"
                    class="text-primary-600 hover:text-primary-900 p-1 rounded-md hover:bg-primary-50 transition-colors duration-200"
                    title="Lihat Detail"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                    </svg>
                  </button>
                  <button
                    @click="editIncident(incident)"
                    class="text-blue-600 hover:text-blue-900 p-1 rounded-md hover:bg-blue-50 transition-colors duration-200"
                    title="Edit"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                    </svg>
                  </button>
                  <button
                    @click="deleteIncident(incident.id)"
                    class="text-red-600 hover:text-red-900 p-1 rounded-md hover:bg-red-50 transition-colors duration-200"
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
      class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50 p-2 md:p-4"
      @click.self="showForm = false"
    >
      <div class="relative top-4 md:top-20 mx-auto p-4 md:p-5 border w-full max-w-4xl shadow-lg rounded-md bg-white max-h-[90vh] overflow-y-auto">
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
                  <option 
                    v-for="unit in units" 
                    :key="unit.id" 
                    :value="unit.nama_unit"
                  >
                    {{ unit.nama_unit }}
                  </option>
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

    <!-- View Modal -->
    <div
      v-if="showViewModal"
      class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50"
      @click.self="showViewModal = false"
    >
      <div class="relative top-20 mx-auto p-5 border w-11/12 max-w-4xl shadow-lg rounded-md bg-white max-h-[90vh] overflow-y-auto">
        <div class="mt-3">
          <div class="flex justify-between items-center mb-4">
            <h3 class="text-lg font-medium text-gray-900">
              Detail Laporan Unsafe Action/Condition
            </h3>
            <button
              @click="showViewModal = false"
              class="text-gray-400 hover:text-gray-600"
            >
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>

          <div v-if="viewIncidentData" class="space-y-6">
            <!-- Incident Details -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Tanggal Kejadian</label>
                <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg">{{ viewIncidentData.tanggal_kejadian }}</p>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Waktu Kejadian</label>
                <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg">{{ viewIncidentData.waktu_kejadian }}</p>
              </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Lokasi Kejadian</label>
                <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg">{{ viewIncidentData.lokasi_kejadian }}</p>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Unit Kerja</label>
                <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg">{{ viewIncidentData.unit_kerja }}</p>
              </div>
            </div>

            <!-- Incident Classification -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Jenis Kejadian</label>
                <span
                  class="inline-flex px-3 py-2 rounded-lg text-sm font-medium"
                  :class="viewIncidentData.jenis_kejadian === 'unsafe_action' ? 'bg-red-100 text-red-800' : 'bg-orange-100 text-orange-800'"
                >
                  {{ viewIncidentData.jenis_kejadian === 'unsafe_action' ? 'Unsafe Action' : 'Unsafe Condition' }}
                </span>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Kategori</label>
                <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg">{{ viewIncidentData.kategori }}</p>
              </div>
            </div>

            <div v-if="viewIncidentData.sub_kategori" class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div class="md:col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-2">Sub Kategori</label>
                <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg">{{ viewIncidentData.sub_kategori }}</p>
              </div>
            </div>

            <!-- Description and Analysis -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Deskripsi Kejadian</label>
              <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg whitespace-pre-wrap">{{ viewIncidentData.deskripsi_kejadian }}</p>
            </div>

            <div v-if="viewIncidentData.penyebab_diduga" class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Penyebab Diduga</label>
                <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg whitespace-pre-wrap">{{ viewIncidentData.penyebab_diduga }}</p>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Potensi Risiko</label>
                <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg whitespace-pre-wrap">{{ viewIncidentData.potensi_risiko }}</p>
              </div>
            </div>

            <!-- Reporter Information -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Pelapor</label>
                <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg">{{ viewIncidentData.pelapor_nama }}</p>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Jabatan</label>
                <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg">{{ viewIncidentData.pelapor_jabatan || '-' }}</p>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Kontak</label>
                <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg">{{ viewIncidentData.pelapor_kontak || '-' }}</p>
              </div>
            </div>

            <!-- Immediate Actions and Status -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Tindakan Segera</label>
                <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg whitespace-pre-wrap">{{ viewIncidentData.tindakan_segera || '-' }}</p>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Area Diamankan</label>
                <span
                  class="inline-flex px-3 py-2 rounded-lg text-sm font-medium"
                  :class="viewIncidentData.area_diamankan ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'"
                >
                  {{ viewIncidentData.area_diamankan ? 'Ya' : 'Tidak' }}
                </span>
              </div>
            </div>

            <!-- Victim Information -->
            <div v-if="viewIncidentData.korban_ada" class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Korban Ada</label>
                <span class="inline-flex px-3 py-2 rounded-lg text-sm font-medium bg-red-100 text-red-800">
                  Ya
                </span>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Jumlah Korban</label>
                <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg">{{ viewIncidentData.korban_jumlah || 0 }}</p>
              </div>
            </div>

            <!-- Status and Priority -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Status</label>
                <span
                  class="inline-flex px-3 py-2 rounded-lg text-sm font-medium"
                  :class="{
                    'bg-gray-100 text-gray-800': viewIncidentData.status === 'draft',
                    'bg-blue-100 text-blue-800': viewIncidentData.status === 'reported',
                    'bg-yellow-100 text-yellow-800': viewIncidentData.status === 'investigating',
                    'bg-green-100 text-green-800': viewIncidentData.status === 'resolved',
                    'bg-purple-100 text-purple-800': viewIncidentData.status === 'closed'
                  }"
                >
                  {{ viewIncidentData.status }}
                </span>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Prioritas</label>
                <span
                  class="inline-flex px-3 py-2 rounded-lg text-sm font-medium"
                  :class="{
                    'bg-green-100 text-green-800': viewIncidentData.prioritas === 'low',
                    'bg-yellow-100 text-yellow-800': viewIncidentData.prioritas === 'medium',
                    'bg-orange-100 text-orange-800': viewIncidentData.prioritas === 'high',
                    'bg-red-100 text-red-800': viewIncidentData.prioritas === 'critical'
                  }"
                >
                  {{ viewIncidentData.prioritas }}
                </span>
              </div>
            </div>

            <!-- Investigation Results (if available) -->
            <div v-if="viewIncidentData.investigasi_dilakukan" class="border-t pt-6">
              <h4 class="text-lg font-medium text-gray-900 mb-4">Hasil Investigasi</h4>
              <div class="space-y-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Temuan Investigasi</label>
                  <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg whitespace-pre-wrap">{{ viewIncidentData.temuan_investigasi || '-' }}</p>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Rekomendasi Koreksi</label>
                  <div v-if="viewIncidentData.rekomendasi_koreksi && viewIncidentData.rekomendasi_koreksi.length > 0" class="space-y-2">
                    <p v-for="(rek, index) in viewIncidentData.rekomendasi_koreksi" :key="index" class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg">
                      {{ index + 1 }}. {{ rek }}
                    </p>
                  </div>
                  <p v-else class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg">-</p>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Target Penyelesaian</label>
                    <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg">{{ viewIncidentData.target_penyelesaian || '-' }}</p>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Aktual Penyelesaian</label>
                    <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg">{{ viewIncidentData.aktual_penyelesaian || '-' }}</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Media Documentation -->
            <div v-if="(viewIncidentData.foto_kejadian && viewIncidentData.foto_kejadian.length > 0) || (viewIncidentData.video_kejadian && viewIncidentData.video_kejadian.length > 0)" class="border-t pt-6">
              <h4 class="text-lg font-medium text-gray-900 mb-4">📸 Dokumentasi Foto/Video</h4>

              <div v-if="viewIncidentData.foto_kejadian && viewIncidentData.foto_kejadian.length > 0" class="mb-4">
                <h5 class="text-sm font-medium text-gray-700 mb-2">Foto:</h5>
                <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                  <div v-for="(photo, index) in viewIncidentData.foto_kejadian" :key="index">
                    <img :src="photo" :alt="`Foto ${index + 1}`" class="w-full h-24 object-cover rounded-lg border cursor-pointer" @click="openMediaModal(photo, 'image')">
                  </div>
                </div>
              </div>

              <div v-if="viewIncidentData.video_kejadian && viewIncidentData.video_kejadian.length > 0" class="mb-4">
                <h5 class="text-sm font-medium text-gray-700 mb-2">Video:</h5>
                <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                  <div v-for="(video, index) in viewIncidentData.video_kejadian" :key="index">
                    <video :src="video" class="w-full h-24 object-cover rounded-lg border cursor-pointer" controls @click="openMediaModal(video, 'video')"></video>
                  </div>
                </div>
              </div>
            </div>

            <!-- GPS Information (if available) -->
            <div v-if="viewIncidentData.latitude && viewIncidentData.longitude" class="border-t pt-6">
              <h4 class="text-lg font-medium text-gray-900 mb-4">📍 Lokasi GPS</h4>
              <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Latitude</label>
                  <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg">{{ viewIncidentData.latitude }}</p>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Longitude</label>
                  <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg">{{ viewIncidentData.longitude }}</p>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Akurasi GPS</label>
                  <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg">{{ viewIncidentData.gps_accuracy ? viewIncidentData.gps_accuracy + 'm' : '-' }}</p>
                </div>
              </div>
            </div>

            <!-- Timestamps -->
            <div class="border-t pt-6">
              <h4 class="text-lg font-medium text-gray-900 mb-4">⏰ Informasi Waktu</h4>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Dibuat Pada</label>
                  <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg">{{ formatDate(viewIncidentData.created_at) }}</p>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Terakhir Diupdate</label>
                  <p class="px-3 py-2 bg-gray-50 border border-gray-300 rounded-lg">{{ formatDate(viewIncidentData.updated_at) }}</p>
                </div>
              </div>
            </div>
          </div>

          <!-- Modal Actions -->
          <div class="flex justify-end space-x-3 pt-6 border-t mt-6">
            <button
              @click="exportToPDF"
              class="px-6 py-2 bg-green-600 hover:bg-green-700 text-white rounded-lg font-medium transition-colors duration-200 flex items-center space-x-2"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
              <span>Save to PDF</span>
            </button>
            <button
              @click="showViewModal = false"
              class="px-6 py-2 bg-primary-600 hover:bg-primary-700 text-white rounded-lg font-medium transition-colors duration-200"
            >
              Tutup
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Media Modal for viewing full-size images/videos -->
    <div
      v-if="showMediaModal"
      class="fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-50"
      @click.self="showMediaModal = false"
    >
      <div class="relative max-w-4xl max-h-full p-4">
        <button
          @click="showMediaModal = false"
          class="absolute -top-12 right-0 text-white hover:text-gray-300 text-2xl"
        >
          ×
        </button>
        <div v-if="mediaType === 'image'" class="max-h-full overflow-auto">
          <img :src="currentMedia" class="max-w-full max-h-full object-contain" />
        </div>
        <div v-if="mediaType === 'video'" class="max-h-full overflow-auto">
          <video :src="currentMedia" controls class="max-w-full max-h-full object-contain"></video>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, watch, onMounted } from 'vue'
import { UnsafeActionConditionService } from '@/services/hsse/unsafe-action-condition.service'
import { unitsService } from '@/services/api/units.service'
import jsPDF from 'jspdf'

// Reactive data
const incidents = ref<any[]>([])
const units = ref<any[]>([])
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
const showViewModal = ref(false)
const viewIncidentData = ref<any>(null)
const showMediaModal = ref(false)
const currentMedia = ref('')
const mediaType = ref('')

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

const loadUnits = async () => {
  try {
    units.value = await unitsService.getActive()
  } catch (error) {
    console.error('Error loading units:', error)
  }
}

const viewIncident = async (incident: any) => {
  viewIncidentData.value = incident

  // Generate PDF preview
  const pdf = new jsPDF()
  const pageWidth = pdf.internal.pageSize.getWidth()
  const pageHeight = pdf.internal.pageSize.getHeight()
  const margin = 20
  let yPosition = margin

  // Helper functions
  const addText = (text: string, x: number, y: number, options: any = {}) => {
    pdf.setFontSize(options.fontSize || 10)
    pdf.setFont(options.font || 'helvetica', options.style || 'normal')
    if (options.color) pdf.setTextColor(options.color[0], options.color[1], options.color[2])
    if (options.align === 'center') {
      pdf.text(text, pageWidth / 2, y, { align: 'center' })
    } else if (options.align === 'right') {
      pdf.text(text, pageWidth - margin, y, { align: 'right' })
    } else {
      pdf.text(text, x, y)
    }
    if (options.color) pdf.setTextColor(0, 0, 0) // Reset to black
  }

  const addLine = (x1: number, y1: number, x2: number, y2: number) => {
    pdf.line(x1, y1, x2, y2)
  }

  const addColoredRect = (x: number, y: number, width: number, height: number, color: [number, number, number]) => {
    pdf.setFillColor(color[0], color[1], color[2])
    pdf.rect(x, y, width, height, 'F')
  }

  const checkPageBreak = (requiredHeight: number) => {
    if (yPosition + requiredHeight > pageHeight - margin) {
      pdf.addPage()
      yPosition = margin
      return true
    }
    return false
  }

  // Load image as base64
  const loadImageAsBase64 = (url: string): Promise<string> => {
    return new Promise((resolve, reject) => {
      const img = new Image()
      img.crossOrigin = 'anonymous'
      img.onload = () => {
        const canvas = document.createElement('canvas')
        const ctx = canvas.getContext('2d')
        if (!ctx) {
          reject(new Error('Could not get canvas context'))
          return
        }

        // Calculate dimensions to fit in PDF (max width 150px, maintain aspect ratio)
        const maxWidth = 150
        const aspectRatio = img.width / img.height
        const width = Math.min(maxWidth, img.width)
        const height = width / aspectRatio

        canvas.width = width
        canvas.height = height

        ctx.drawImage(img, 0, 0, width, height)
        const base64 = canvas.toDataURL('image/jpeg', 0.8)
        resolve(base64)
      }
      img.onerror = () => reject(new Error('Failed to load image'))
      img.src = url
    })
  }

  try {
    // Header with colored background
    addColoredRect(0, 0, pageWidth, 30, [41, 128, 185]) // Blue header
    pdf.setTextColor(255, 255, 255) // White text
    pdf.setFontSize(20)
    pdf.setFont('helvetica', 'bold')
    addText('LAPORAN UNSAFE ACTION/CONDITION', pageWidth / 2, 18, { fontSize: 20, align: 'center' })
    pdf.setTextColor(0, 0, 0) // Reset to black
    yPosition = 40

    // Separator line
    addLine(margin, yPosition, pageWidth - margin, yPosition)
    yPosition += 10

    // Incident Details Section with colored header
    addColoredRect(margin, yPosition - 5, pageWidth - 2 * margin, 12, [52, 152, 219]) // Light blue
    pdf.setTextColor(255, 255, 255)
    pdf.setFontSize(12)
    pdf.setFont('helvetica', 'bold')
    addText('DETAIL KEJADIAN', margin + 5, yPosition + 2)
    pdf.setTextColor(0, 0, 0)
    yPosition += 15

    pdf.setFont('helvetica', 'normal')
    pdf.setFontSize(10)

    // Create a table-like structure with alternating colors
    const details = [
      ['Tanggal Kejadian', incident.tanggal_kejadian || '-'],
      ['Waktu Kejadian', incident.waktu_kejadian || '-'],
      ['Lokasi Kejadian', incident.lokasi_kejadian || '-'],
      ['Unit Kerja', incident.unit_kerja || '-'],
      ['Jenis Kejadian', incident.jenis_kejadian === 'unsafe_action' ? 'Unsafe Action' : 'Unsafe Condition'],
      ['Kategori', incident.kategori || '-'],
      ['Sub Kategori', incident.sub_kategori || '-'],
      ['Prioritas', incident.prioritas || '-'],
      ['Status', incident.status || '-']
    ]

    let isAlternate = false
    details.forEach(([label, value]) => {
      checkPageBreak(8)
      if (isAlternate) {
        addColoredRect(margin, yPosition - 2, pageWidth - 2 * margin, 6, [245, 245, 245]) // Light gray background
      }
      addText(`${label}:`, margin, yPosition)
      addText(value, margin + 50, yPosition)
      yPosition += 6
      isAlternate = !isAlternate
    })

    yPosition += 5

    // Description Section with colored header
    checkPageBreak(20)
    addColoredRect(margin, yPosition - 5, pageWidth - 2 * margin, 12, [46, 204, 113]) // Green
    pdf.setTextColor(255, 255, 255)
    pdf.setFont('helvetica', 'bold')
    addText('DESKRIPSI KEJADIAN', margin + 5, yPosition + 2)
    pdf.setTextColor(0, 0, 0)
    yPosition += 15

    pdf.setFont('helvetica', 'normal')
    const description = incident.deskripsi_kejadian || '-'
    const descLines = pdf.splitTextToSize(description, pageWidth - 2 * margin)
    descLines.forEach((line: string) => {
      checkPageBreak(6)
      addText(line, margin, yPosition)
      yPosition += 6
    })

    yPosition += 5

    // Photos Section
    if (incident.foto_kejadian && incident.foto_kejadian.length > 0) {
      checkPageBreak(30)
      addColoredRect(margin, yPosition - 5, pageWidth - 2 * margin, 12, [155, 89, 182]) // Purple
      pdf.setTextColor(255, 255, 255)
      pdf.setFont('helvetica', 'bold')
      addText('FOTO KEJADIAN', margin + 5, yPosition + 2)
      pdf.setTextColor(0, 0, 0)
      yPosition += 15

      for (let i = 0; i < incident.foto_kejadian.length; i++) {
        const photoUrl = incident.foto_kejadian[i]
        try {
          const base64Image = await loadImageAsBase64(photoUrl)
          checkPageBreak(80)

          // Add image
          pdf.addImage(base64Image, 'JPEG', margin, yPosition, 150, 100)
          yPosition += 110

          // Add caption
          pdf.setFontSize(8)
          pdf.setFont('helvetica', 'italic')
          addText(`Foto ${i + 1}`, margin, yPosition)
          yPosition += 10
        } catch (error) {
          console.warn(`Failed to load image ${i + 1}:`, error)
          checkPageBreak(15)
          addText(`Foto ${i + 1}: Gagal memuat gambar`, margin, yPosition)
          yPosition += 10
        }
      }
      yPosition += 5
    }

    // Cause and Risk Section with colored header
    if (incident.penyebab_diduga || incident.potensi_risiko) {
      checkPageBreak(20)
      addColoredRect(margin, yPosition - 5, pageWidth - 2 * margin, 12, [230, 126, 34]) // Orange
      pdf.setTextColor(255, 255, 255)
      pdf.setFont('helvetica', 'bold')
      addText('PENYEBAB & RISIKO', margin + 5, yPosition + 2)
      pdf.setTextColor(0, 0, 0)
      yPosition += 15

      pdf.setFont('helvetica', 'normal')

      if (incident.penyebab_diduga) {
        checkPageBreak(15)
        addText('Penyebab Diduga:', margin, yPosition)
        yPosition += 6
        const causeLines = pdf.splitTextToSize(incident.penyebab_diduga, pageWidth - 2 * margin - 10)
        causeLines.forEach((line: string) => {
          checkPageBreak(6)
          addText(line, margin + 10, yPosition)
          yPosition += 6
        })
        yPosition += 3
      }

      if (incident.potensi_risiko) {
        checkPageBreak(15)
        addText('Potensi Risiko:', margin, yPosition)
        yPosition += 6
        const riskLines = pdf.splitTextToSize(incident.potensi_risiko, pageWidth - 2 * margin - 10)
        riskLines.forEach((line: string) => {
          checkPageBreak(6)
          addText(line, margin + 10, yPosition)
          yPosition += 6
        })
        yPosition += 3
      }
    }

    // Reporter Information with colored header
    checkPageBreak(20)
    addColoredRect(margin, yPosition - 5, pageWidth - 2 * margin, 12, [52, 73, 94]) // Dark gray
    pdf.setTextColor(255, 255, 255)
    pdf.setFont('helvetica', 'bold')
    addText('INFORMASI PELAPOR', margin + 5, yPosition + 2)
    pdf.setTextColor(0, 0, 0)
    yPosition += 15

    pdf.setFont('helvetica', 'normal')
    const reporterInfo = [
      ['Nama Pelapor', incident.pelapor_nama || '-'],
      ['Jabatan', incident.pelapor_jabatan || '-'],
      ['Kontak', incident.pelapor_kontak || '-']
    ]

    reporterInfo.forEach(([label, value]) => {
      checkPageBreak(6)
      addText(`${label}:`, margin, yPosition)
      addText(value, margin + 50, yPosition)
      yPosition += 6
    })

    yPosition += 5

    // Immediate Actions with colored header
    if (incident.tindakan_segera) {
      checkPageBreak(20)
      addColoredRect(margin, yPosition - 5, pageWidth - 2 * margin, 12, [231, 76, 60]) // Red
      pdf.setTextColor(255, 255, 255)
      pdf.setFont('helvetica', 'bold')
      addText('TINDAKAN SEGERA', margin + 5, yPosition + 2)
      pdf.setTextColor(0, 0, 0)
      yPosition += 15

      pdf.setFont('helvetica', 'normal')
      const actionLines = pdf.splitTextToSize(incident.tindakan_segera, pageWidth - 2 * margin)
      actionLines.forEach((line: string) => {
        checkPageBreak(6)
        addText(line, margin, yPosition)
        yPosition += 6
      })
      yPosition += 5
    }

    // Safety Status with colored header
    checkPageBreak(15)
    addColoredRect(margin, yPosition - 5, pageWidth - 2 * margin, 12, [149, 165, 166]) // Light gray
    pdf.setTextColor(255, 255, 255)
    pdf.setFont('helvetica', 'bold')
    addText('STATUS KESELAMATAN', margin + 5, yPosition + 2)
    pdf.setTextColor(0, 0, 0)
    yPosition += 15

    pdf.setFont('helvetica', 'normal')
    addText(`Area Diamankan: ${incident.area_diamankan ? 'Ya' : 'Tidak'}`, margin, yPosition)
    yPosition += 6

    if (incident.korban_ada) {
      addText(`Jumlah Korban: ${incident.korban_jumlah || 0}`, margin, yPosition)
      yPosition += 6
    }

    yPosition += 5

    // Investigation Section with colored header
    if (incident.investigasi_dilakukan) {
      checkPageBreak(20)
      addColoredRect(margin, yPosition - 5, pageWidth - 2 * margin, 12, [44, 62, 80]) // Dark blue
      pdf.setTextColor(255, 255, 255)
      pdf.setFont('helvetica', 'bold')
      addText('HASIL INVESTIGASI', margin + 5, yPosition + 2)
      pdf.setTextColor(0, 0, 0)
      yPosition += 15

      pdf.setFont('helvetica', 'normal')

      if (incident.temuan_investigasi) {
        checkPageBreak(15)
        addText('Temuan Investigasi:', margin, yPosition)
        yPosition += 6
        const findingLines = pdf.splitTextToSize(incident.temuan_investigasi, pageWidth - 2 * margin - 10)
        findingLines.forEach((line: string) => {
          checkPageBreak(6)
          addText(line, margin + 10, yPosition)
          yPosition += 6
        })
        yPosition += 3
      }

      if (incident.rekomendasi_koreksi && incident.rekomendasi_koreksi.length > 0) {
        checkPageBreak(15)
        addText('Rekomendasi Koreksi:', margin, yPosition)
        yPosition += 6
        incident.rekomendasi_koreksi.forEach((rek: string, index: number) => {
          checkPageBreak(8)
          addText(`${index + 1}. ${rek}`, margin + 10, yPosition)
          yPosition += 6
        })
        yPosition += 3
      }

      if (incident.target_penyelesaian) {
        checkPageBreak(12)
        addText(`Target Penyelesaian: ${incident.target_penyelesaian}`, margin, yPosition)
        yPosition += 6
      }

      if (incident.aktual_penyelesaian) {
        checkPageBreak(6)
        addText(`Aktual Penyelesaian: ${incident.aktual_penyelesaian}`, margin, yPosition)
        yPosition += 6
      }
    }

    // GPS Information with colored header
    if (incident.latitude && incident.longitude) {
      checkPageBreak(20)
      addColoredRect(margin, yPosition - 5, pageWidth - 2 * margin, 12, [39, 174, 96]) // Green
      pdf.setTextColor(255, 255, 255)
      pdf.setFont('helvetica', 'bold')
      addText('INFORMASI GPS', margin + 5, yPosition + 2)
      pdf.setTextColor(0, 0, 0)
      yPosition += 15

      pdf.setFont('helvetica', 'normal')
      addText(`Latitude: ${incident.latitude}`, margin, yPosition)
      yPosition += 6
      addText(`Longitude: ${incident.longitude}`, margin, yPosition)
      yPosition += 6
      if (incident.gps_accuracy) {
        addText(`Akurasi: ${incident.gps_accuracy}m`, margin, yPosition)
        yPosition += 6
      }
    }

    // Footer with colored background
    checkPageBreak(20)
    yPosition = pageHeight - 30

    addColoredRect(0, yPosition - 5, pageWidth, 25, [44, 62, 80]) // Dark blue footer
    pdf.setTextColor(255, 255, 255)
    addLine(margin, yPosition, pageWidth - margin, yPosition)
    yPosition += 8

    pdf.setFontSize(8)
    pdf.setFont('helvetica', 'italic')
    addText(`Dibuat pada: ${formatDate(incident.created_at)}`, margin, yPosition)
    addText(`Terakhir diupdate: ${formatDate(incident.updated_at)}`, pageWidth - margin, yPosition, { align: 'right' })

    yPosition += 4
    addText(`ID Laporan: ${incident.id}`, margin, yPosition)
    pdf.setTextColor(0, 0, 0)

    // Generate PDF blob and open in new window for preview
    const pdfBlob = pdf.output('blob')
    const pdfUrl = URL.createObjectURL(pdfBlob)
    window.open(pdfUrl, '_blank')

  } catch (error) {
    console.error('❌ Error generating PDF preview:', error)
    alert('Gagal menampilkan preview PDF. Silakan coba lagi.')
  }
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

const openMediaModal = (mediaUrl: string, type: string) => {
  currentMedia.value = mediaUrl
  mediaType.value = type
  showMediaModal.value = true
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

// PDF Export Function - Professional Format
const exportToPDF = async () => {
  if (!viewIncidentData.value) return

  const pdf = new jsPDF()
  const pageWidth = pdf.internal.pageSize.getWidth()
  const pageHeight = pdf.internal.pageSize.getHeight()
  const margin = 20
  let yPosition = margin

  // Helper functions
  const addText = (text: string, x: number, y: number, options: any = {}) => {
    pdf.setFontSize(options.fontSize || 10)
    pdf.setFont(options.font || 'helvetica', options.style || 'normal')
    if (options.color) pdf.setTextColor(options.color[0], options.color[1], options.color[2])
    if (options.align === 'center') {
      pdf.text(text, pageWidth / 2, y, { align: 'center' })
    } else if (options.align === 'right') {
      pdf.text(text, pageWidth - margin, y, { align: 'right' })
    } else {
      pdf.text(text, x, y)
    }
    if (options.color) pdf.setTextColor(0, 0, 0) // Reset to black
  }

  const addLine = (x1: number, y1: number, x2: number, y2: number) => {
    pdf.line(x1, y1, x2, y2)
  }

  const addColoredRect = (x: number, y: number, width: number, height: number, color: [number, number, number]) => {
    pdf.setFillColor(color[0], color[1], color[2])
    pdf.rect(x, y, width, height, 'F')
  }

  const checkPageBreak = (requiredHeight: number) => {
    if (yPosition + requiredHeight > pageHeight - margin) {
      pdf.addPage()
      yPosition = margin
      return true
    }
    return false
  }

  // Load image as base64
  const loadImageAsBase64 = (url: string): Promise<string> => {
    return new Promise((resolve, reject) => {
      const img = new Image()
      img.crossOrigin = 'anonymous'
      img.onload = () => {
        const canvas = document.createElement('canvas')
        const ctx = canvas.getContext('2d')
        if (!ctx) {
          reject(new Error('Could not get canvas context'))
          return
        }

        // Calculate dimensions to fit in PDF (max width 150px, maintain aspect ratio)
        const maxWidth = 150
        const aspectRatio = img.width / img.height
        const width = Math.min(maxWidth, img.width)
        const height = width / aspectRatio

        canvas.width = width
        canvas.height = height

        ctx.drawImage(img, 0, 0, width, height)
        const base64 = canvas.toDataURL('image/jpeg', 0.8)
        resolve(base64)
      }
      img.onerror = () => reject(new Error('Failed to load image'))
      img.src = url
    })
  }

  try {
    // Header with colored background
    addColoredRect(0, 0, pageWidth, 30, [41, 128, 185]) // Blue header
    pdf.setTextColor(255, 255, 255) // White text
    pdf.setFontSize(20)
    pdf.setFont('helvetica', 'bold')
    addText('LAPORAN UNSAFE ACTION/CONDITION', pageWidth / 2, 18, { fontSize: 20, align: 'center' })
    pdf.setTextColor(0, 0, 0) // Reset to black
    yPosition = 40

    // Separator line
    addLine(margin, yPosition, pageWidth - margin, yPosition)
    yPosition += 10

    // Incident Details Section with colored header
    addColoredRect(margin, yPosition - 5, pageWidth - 2 * margin, 12, [52, 152, 219]) // Light blue
    pdf.setTextColor(255, 255, 255)
    pdf.setFontSize(12)
    pdf.setFont('helvetica', 'bold')
    addText('DETAIL KEJADIAN', margin + 5, yPosition + 2)
    pdf.setTextColor(0, 0, 0)
    yPosition += 15

    pdf.setFont('helvetica', 'normal')
    pdf.setFontSize(10)

    // Create a table-like structure with alternating colors
    const details = [
      ['Tanggal Kejadian', viewIncidentData.value.tanggal_kejadian || '-'],
      ['Waktu Kejadian', viewIncidentData.value.waktu_kejadian || '-'],
      ['Lokasi Kejadian', viewIncidentData.value.lokasi_kejadian || '-'],
      ['Unit Kerja', viewIncidentData.value.unit_kerja || '-'],
      ['Jenis Kejadian', viewIncidentData.value.jenis_kejadian === 'unsafe_action' ? 'Unsafe Action' : 'Unsafe Condition'],
      ['Kategori', viewIncidentData.value.kategori || '-'],
      ['Sub Kategori', viewIncidentData.value.sub_kategori || '-'],
      ['Prioritas', viewIncidentData.value.prioritas || '-'],
      ['Status', viewIncidentData.value.status || '-']
    ]

    let isAlternate = false
    details.forEach(([label, value]) => {
      checkPageBreak(8)
      if (isAlternate) {
        addColoredRect(margin, yPosition - 2, pageWidth - 2 * margin, 6, [245, 245, 245]) // Light gray background
      }
      addText(`${label}:`, margin, yPosition)
      addText(value, margin + 50, yPosition)
      yPosition += 6
      isAlternate = !isAlternate
    })

    yPosition += 5

    // Description Section with colored header
    checkPageBreak(20)
    addColoredRect(margin, yPosition - 5, pageWidth - 2 * margin, 12, [46, 204, 113]) // Green
    pdf.setTextColor(255, 255, 255)
    pdf.setFont('helvetica', 'bold')
    addText('DESKRIPSI KEJADIAN', margin + 5, yPosition + 2)
    pdf.setTextColor(0, 0, 0)
    yPosition += 15

    pdf.setFont('helvetica', 'normal')
    const description = viewIncidentData.value.deskripsi_kejadian || '-'
    const descLines = pdf.splitTextToSize(description, pageWidth - 2 * margin)
    descLines.forEach((line: string) => {
      checkPageBreak(6)
      addText(line, margin, yPosition)
      yPosition += 6
    })

    yPosition += 5

    // Photos Section
    if (viewIncidentData.value.foto_kejadian && viewIncidentData.value.foto_kejadian.length > 0) {
      checkPageBreak(30)
      addColoredRect(margin, yPosition - 5, pageWidth - 2 * margin, 12, [155, 89, 182]) // Purple
      pdf.setTextColor(255, 255, 255)
      pdf.setFont('helvetica', 'bold')
      addText('FOTO KEJADIAN', margin + 5, yPosition + 2)
      pdf.setTextColor(0, 0, 0)
      yPosition += 15

      for (let i = 0; i < viewIncidentData.value.foto_kejadian.length; i++) {
        const photoUrl = viewIncidentData.value.foto_kejadian[i]
        try {
          const base64Image = await loadImageAsBase64(photoUrl)
          checkPageBreak(80)

          // Add image
          pdf.addImage(base64Image, 'JPEG', margin, yPosition, 150, 100)
          yPosition += 110

          // Add caption
          pdf.setFontSize(8)
          pdf.setFont('helvetica', 'italic')
          addText(`Foto ${i + 1}`, margin, yPosition)
          yPosition += 10
        } catch (error) {
          console.warn(`Failed to load image ${i + 1}:`, error)
          checkPageBreak(15)
          addText(`Foto ${i + 1}: Gagal memuat gambar`, margin, yPosition)
          yPosition += 10
        }
      }
      yPosition += 5
    }

    // Cause and Risk Section with colored header
    if (viewIncidentData.value.penyebab_diduga || viewIncidentData.value.potensi_risiko) {
      checkPageBreak(20)
      addColoredRect(margin, yPosition - 5, pageWidth - 2 * margin, 12, [230, 126, 34]) // Orange
      pdf.setTextColor(255, 255, 255)
      pdf.setFont('helvetica', 'bold')
      addText('PENYEBAB & RISIKO', margin + 5, yPosition + 2)
      pdf.setTextColor(0, 0, 0)
      yPosition += 15

      pdf.setFont('helvetica', 'normal')

      if (viewIncidentData.value.penyebab_diduga) {
        checkPageBreak(15)
        addText('Penyebab Diduga:', margin, yPosition)
        yPosition += 6
        const causeLines = pdf.splitTextToSize(viewIncidentData.value.penyebab_diduga, pageWidth - 2 * margin - 10)
        causeLines.forEach((line: string) => {
          checkPageBreak(6)
          addText(line, margin + 10, yPosition)
          yPosition += 6
        })
        yPosition += 3
      }

      if (viewIncidentData.value.potensi_risiko) {
        checkPageBreak(15)
        addText('Potensi Risiko:', margin, yPosition)
        yPosition += 6
        const riskLines = pdf.splitTextToSize(viewIncidentData.value.potensi_risiko, pageWidth - 2 * margin - 10)
        riskLines.forEach((line: string) => {
          checkPageBreak(6)
          addText(line, margin + 10, yPosition)
          yPosition += 6
        })
        yPosition += 3
      }
    }

    // Reporter Information with colored header
    checkPageBreak(20)
    addColoredRect(margin, yPosition - 5, pageWidth - 2 * margin, 12, [52, 73, 94]) // Dark gray
    pdf.setTextColor(255, 255, 255)
    pdf.setFont('helvetica', 'bold')
    addText('INFORMASI PELAPOR', margin + 5, yPosition + 2)
    pdf.setTextColor(0, 0, 0)
    yPosition += 15

    pdf.setFont('helvetica', 'normal')
    const reporterInfo = [
      ['Nama Pelapor', viewIncidentData.value.pelapor_nama || '-'],
      ['Jabatan', viewIncidentData.value.pelapor_jabatan || '-'],
      ['Kontak', viewIncidentData.value.pelapor_kontak || '-']
    ]

    reporterInfo.forEach(([label, value]) => {
      checkPageBreak(6)
      addText(`${label}:`, margin, yPosition)
      addText(value, margin + 50, yPosition)
      yPosition += 6
    })

    yPosition += 5

    // Immediate Actions with colored header
    if (viewIncidentData.value.tindakan_segera) {
      checkPageBreak(20)
      addColoredRect(margin, yPosition - 5, pageWidth - 2 * margin, 12, [231, 76, 60]) // Red
      pdf.setTextColor(255, 255, 255)
      pdf.setFont('helvetica', 'bold')
      addText('TINDAKAN SEGERA', margin + 5, yPosition + 2)
      pdf.setTextColor(0, 0, 0)
      yPosition += 15

      pdf.setFont('helvetica', 'normal')
      const actionLines = pdf.splitTextToSize(viewIncidentData.value.tindakan_segera, pageWidth - 2 * margin)
      actionLines.forEach((line: string) => {
        checkPageBreak(6)
        addText(line, margin, yPosition)
        yPosition += 6
      })
      yPosition += 5
    }

    // Safety Status with colored header
    checkPageBreak(15)
    addColoredRect(margin, yPosition - 5, pageWidth - 2 * margin, 12, [149, 165, 166]) // Light gray
    pdf.setTextColor(255, 255, 255)
    pdf.setFont('helvetica', 'bold')
    addText('STATUS KESELAMATAN', margin + 5, yPosition + 2)
    pdf.setTextColor(0, 0, 0)
    yPosition += 15

    pdf.setFont('helvetica', 'normal')
    addText(`Area Diamankan: ${viewIncidentData.value.area_diamankan ? 'Ya' : 'Tidak'}`, margin, yPosition)
    yPosition += 6

    if (viewIncidentData.value.korban_ada) {
      addText(`Jumlah Korban: ${viewIncidentData.value.korban_jumlah || 0}`, margin, yPosition)
      yPosition += 6
    }

    yPosition += 5

    // Investigation Section with colored header
    if (viewIncidentData.value.investigasi_dilakukan) {
      checkPageBreak(20)
      addColoredRect(margin, yPosition - 5, pageWidth - 2 * margin, 12, [44, 62, 80]) // Dark blue
      pdf.setTextColor(255, 255, 255)
      pdf.setFont('helvetica', 'bold')
      addText('HASIL INVESTIGASI', margin + 5, yPosition + 2)
      pdf.setTextColor(0, 0, 0)
      yPosition += 15

      pdf.setFont('helvetica', 'normal')

      if (viewIncidentData.value.temuan_investigasi) {
        checkPageBreak(15)
        addText('Temuan Investigasi:', margin, yPosition)
        yPosition += 6
        const findingLines = pdf.splitTextToSize(viewIncidentData.value.temuan_investigasi, pageWidth - 2 * margin - 10)
        findingLines.forEach((line: string) => {
          checkPageBreak(6)
          addText(line, margin + 10, yPosition)
          yPosition += 6
        })
        yPosition += 3
      }

      if (viewIncidentData.value.rekomendasi_koreksi && viewIncidentData.value.rekomendasi_koreksi.length > 0) {
        checkPageBreak(15)
        addText('Rekomendasi Koreksi:', margin, yPosition)
        yPosition += 6
        viewIncidentData.value.rekomendasi_koreksi.forEach((rek: string, index: number) => {
          checkPageBreak(8)
          addText(`${index + 1}. ${rek}`, margin + 10, yPosition)
          yPosition += 6
        })
        yPosition += 3
      }

      if (viewIncidentData.value.target_penyelesaian) {
        checkPageBreak(12)
        addText(`Target Penyelesaian: ${viewIncidentData.value.target_penyelesaian}`, margin, yPosition)
        yPosition += 6
      }

      if (viewIncidentData.value.aktual_penyelesaian) {
        checkPageBreak(6)
        addText(`Aktual Penyelesaian: ${viewIncidentData.value.aktual_penyelesaian}`, margin, yPosition)
        yPosition += 6
      }
    }

    // GPS Information with colored header
    if (viewIncidentData.value.latitude && viewIncidentData.value.longitude) {
      checkPageBreak(20)
      addColoredRect(margin, yPosition - 5, pageWidth - 2 * margin, 12, [39, 174, 96]) // Green
      pdf.setTextColor(255, 255, 255)
      pdf.setFont('helvetica', 'bold')
      addText('INFORMASI GPS', margin + 5, yPosition + 2)
      pdf.setTextColor(0, 0, 0)
      yPosition += 15

      pdf.setFont('helvetica', 'normal')
      addText(`Latitude: ${viewIncidentData.value.latitude}`, margin, yPosition)
      yPosition += 6
      addText(`Longitude: ${viewIncidentData.value.longitude}`, margin, yPosition)
      yPosition += 6
      if (viewIncidentData.value.gps_accuracy) {
        addText(`Akurasi: ${viewIncidentData.value.gps_accuracy}m`, margin, yPosition)
        yPosition += 6
      }
    }

    // Footer with colored background
    checkPageBreak(20)
    yPosition = pageHeight - 30

    addColoredRect(0, yPosition - 5, pageWidth, 25, [44, 62, 80]) // Dark blue footer
    pdf.setTextColor(255, 255, 255)
    addLine(margin, yPosition, pageWidth - margin, yPosition)
    yPosition += 8

    pdf.setFontSize(8)
    pdf.setFont('helvetica', 'italic')
    addText(`Dibuat pada: ${formatDate(viewIncidentData.value.created_at)}`, margin, yPosition)
    addText(`Terakhir diupdate: ${formatDate(viewIncidentData.value.updated_at)}`, pageWidth - margin, yPosition, { align: 'right' })

    yPosition += 4
    addText(`ID Laporan: ${viewIncidentData.value.id}`, margin, yPosition)
    pdf.setTextColor(0, 0, 0)

    // Save the PDF
    const filename = `laporan-unsafe-${viewIncidentData.value.jenis_kejadian}-${viewIncidentData.value.id}.pdf`
    pdf.save(filename)
    console.log('✅ PDF berhasil diekspor dengan format profesional dan foto')

  } catch (error) {
    console.error('❌ Error exporting PDF:', error)
    alert('Gagal mengekspor PDF. Silakan coba lagi.')
  }
}

// Lifecycle
onMounted(async () => {
  await loadIncidents()
  await loadStats()
  await loadUnits()
})

// Watchers
watch(filters, () => {
  loadIncidents(1)
}, { deep: true })
</script>

<style scoped>
/* Custom styles for camera/video elements */
</style>
