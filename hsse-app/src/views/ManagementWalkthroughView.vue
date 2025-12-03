<template>
  <div class="management-walkthrough-view">
    <!-- Header -->
    <div class="mb-6">
      <h1 class="text-3xl font-bold text-gray-900 mb-2">Management Walkthrough</h1>
      <p class="text-gray-600">Inspeksi keselamatan lapangan oleh manajemen untuk identifikasi bahaya dan observasi perilaku kerja</p>
    </div>

    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
      <div class="bg-white rounded-lg shadow p-4">
        <div class="text-sm text-gray-600 mb-1">Total Walkthrough</div>
        <div class="text-2xl font-bold text-gray-900">{{ stats.total }}</div>
      </div>
      <div class="bg-white rounded-lg shadow p-4">
        <div class="text-sm text-gray-600 mb-1">Temuan Kritis</div>
        <div class="text-2xl font-bold text-red-600">{{ stats.temuanKritis }}</div>
      </div>
      <div class="bg-white rounded-lg shadow p-4">
        <div class="text-sm text-gray-600 mb-1">Temuan Mayor</div>
        <div class="text-2xl font-bold text-orange-600">{{ stats.temuanMayor }}</div>
      </div>
      <div class="bg-white rounded-lg shadow p-4">
        <div class="text-sm text-gray-600 mb-1">Perlu Follow-up</div>
        <div class="text-2xl font-bold text-blue-600">{{ followUpCount }}</div>
      </div>
    </div>

    <!-- Filters & Actions -->
    <div class="bg-white rounded-lg shadow p-4 mb-6">
      <div class="grid grid-cols-1 md:grid-cols-6 gap-4">
        <!-- Search -->
        <div class="md:col-span-2">
          <input
            v-model="filters.search"
            type="text"
            placeholder="Cari nomor, area, pimpinan..."
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <!-- Unit Filter -->
        <div>
          <select
            v-model="filters.unit_id"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">Semua Unit</option>
            <option v-for="unit in units" :key="unit.id" :value="unit.id">
              {{ unit.nama }}
            </option>
          </select>
        </div>

        <!-- Jenis Filter -->
        <div>
          <select
            v-model="filters.jenis"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">Semua Jenis</option>
            <option value="rutin">Rutin</option>
            <option value="terjadwal">Terjadwal</option>
            <option value="insidental">Insidental</option>
            <option value="follow_up">Follow Up</option>
            <option value="khusus">Khusus</option>
          </select>
        </div>

        <!-- Status Filter -->
        <div>
          <select
            v-model="filters.status"
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">Semua Status</option>
            <option value="draft">Draft</option>
            <option value="in_progress">In Progress</option>
            <option value="completed">Completed</option>
            <option value="cancelled">Cancelled</option>
          </select>
        </div>

        <!-- Add Button -->
        <div>
          <button
            @click="openFormModal('create')"
            class="w-full px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            + Walkthrough Baru
          </button>
        </div>
      </div>
    </div>

    <!-- Loading -->
    <div v-if="loading" class="text-center py-8">
      <div class="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
      <p class="mt-2 text-gray-600">Memuat data...</p>
    </div>

    <!-- Table -->
    <div v-else class="bg-white rounded-lg shadow overflow-hidden">
      <div class="table-responsive">
        <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
          <tr>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nomor</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tanggal</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Area</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Pimpinan</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Temuan</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Jenis</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          <tr v-for="walkthrough in walkthroughs" :key="walkthrough.id" class="hover:bg-gray-50">
            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
              {{ walkthrough.nomor_walkthrough }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
              {{ formatDate(walkthrough.tanggal_walkthrough) }}
            </td>
            <td class="px-6 py-4 text-sm text-gray-900">
              <div>{{ walkthrough.area_inspeksi }}</div>
              <div class="text-xs text-gray-500">{{ walkthrough.unit?.nama || '-' }}</div>
            </td>
            <td class="px-6 py-4 text-sm text-gray-900">
              {{ walkthrough.pimpinan_walkthrough }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm">
              <div class="flex gap-1">
                <span v-if="(walkthrough.temuan_kritis || 0) > 0" class="px-2 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-800">
                  {{ walkthrough.temuan_kritis }} Kritis
                </span>
                <span v-if="(walkthrough.temuan_mayor || 0) > 0" class="px-2 py-1 text-xs font-semibold rounded-full bg-orange-100 text-orange-800">
                  {{ walkthrough.temuan_mayor }} Mayor
                </span>
                <span v-if="(walkthrough.temuan_minor || 0) > 0" class="px-2 py-1 text-xs font-semibold rounded-full bg-yellow-100 text-yellow-800">
                  {{ walkthrough.temuan_minor }} Minor
                </span>
              </div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm">
              <span :class="getJenisBadgeClass(walkthrough.jenis_walkthrough)">
                {{ formatJenis(walkthrough.jenis_walkthrough) }}
              </span>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm">
              <span :class="getStatusBadgeClass(walkthrough.status)">
                {{ formatStatus(walkthrough.status) }}
              </span>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
              <div class="flex gap-2">
                <button
                  @click="openDetailModal(walkthrough)"
                  class="text-blue-600 hover:text-blue-900"
                  title="Detail"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                  </svg>
                </button>
                <button
                  @click="openFormModal('edit', walkthrough)"
                  class="text-green-600 hover:text-green-900"
                  title="Edit"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                  </svg>
                </button>
                <button
                  @click="deleteWalkthrough(walkthrough)"
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

      <!-- Empty State -->
      <div v-if="!walkthroughs.length" class="text-center py-8 text-gray-500">
        Tidak ada data walkthrough
      </div>
    </div>

    <!-- Pagination Controls -->
    <div v-if="walkthroughs.length" class="bg-white rounded-lg shadow p-4 mt-4">
      <div class="flex flex-col sm:flex-row items-center justify-between gap-4">
        <!-- Pagination Info -->
        <div class="text-sm text-gray-600">
          {{ paginationInfo }}
        </div>

        <!-- Page Numbers -->
        <div class="flex items-center gap-2">
          <!-- Previous Button -->
          <button
            @click="prevPage"
            :disabled="currentPage === 1"
            class="px-3 py-1 rounded border border-gray-300 text-sm hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            ← Prev
          </button>

          <!-- First Page -->
          <button
            v-if="(pageNumbers[0] ?? 0) > 1"
            @click="goToPage(1)"
            class="px-3 py-1 rounded border border-gray-300 text-sm hover:bg-gray-50"
          >
            1
          </button>
          <span v-if="(pageNumbers[0] ?? 0) > 2" class="text-gray-400">...</span>

          <!-- Page Numbers -->
          <button
            v-for="page in pageNumbers"
            :key="page"
            @click="goToPage(page)"
            :class="[
              'px-3 py-1 rounded border text-sm',
              currentPage === page
                ? 'bg-blue-600 text-white border-blue-600'
                : 'border-gray-300 hover:bg-gray-50'
            ]"
          >
            {{ page }}
          </button>

          <!-- Last Page -->
          <span v-if="(pageNumbers[pageNumbers.length - 1] ?? 0) < totalPages - 1" class="text-gray-400">...</span>
          <button
            v-if="(pageNumbers[pageNumbers.length - 1] ?? 0) < totalPages"
            @click="goToPage(totalPages)"
            class="px-3 py-1 rounded border border-gray-300 text-sm hover:bg-gray-50"
          >
            {{ totalPages }}
          </button>

          <!-- Next Button -->
          <button
            @click="nextPage"
            :disabled="currentPage === totalPages"
            class="px-3 py-1 rounded border border-gray-300 text-sm hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Next →
          </button>
        </div>

        <!-- Page Size Selector -->
        <div class="flex items-center gap-2">
          <label class="text-sm text-gray-600">Per halaman:</label>
          <select
            :value="pageSize"
            @change="changePageSize(Number(($event.target as HTMLSelectElement).value))"
            class="px-2 py-1 border border-gray-300 rounded text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option :value="10">10</option>
            <option :value="20">20</option>
            <option :value="50">50</option>
            <option :value="100">100</option>
          </select>
        </div>
      </div>
    </div>

    <!-- Detail Modal -->
    <div v-if="showDetailModal && selectedWalkthrough" class="fixed inset-0 z-50 overflow-y-auto" @click.self="closeDetailModal">
      <div class="flex items-center justify-center min-h-screen px-4">
        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"></div>
        <div class="relative bg-white rounded-lg max-w-6xl w-full max-h-[90vh] overflow-y-auto">
          <div class="p-6">
            <!-- Header -->
            <div class="flex justify-between items-start mb-6">
              <div>
                <h2 class="text-2xl font-bold text-gray-900">{{ selectedWalkthrough.nomor_walkthrough }}</h2>
                <p class="text-gray-600">{{ selectedWalkthrough.area_inspeksi }}</p>
              </div>
              <button @click="closeDetailModal" class="text-gray-400 hover:text-gray-600">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>

            <!-- 1. Data Dasar -->
            <div class="mb-6 bg-gray-50 rounded-lg p-4">
              <h3 class="text-lg font-semibold text-gray-900 mb-3">Data Dasar</h3>
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="text-sm text-gray-600">Tanggal</label>
                  <p class="font-medium">{{ formatDate(selectedWalkthrough.tanggal_walkthrough) }}</p>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Waktu</label>
                  <p class="font-medium">{{ selectedWalkthrough.waktu_mulai }} - {{ selectedWalkthrough.waktu_selesai || '-' }}</p>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Unit</label>
                  <p class="font-medium">{{ selectedWalkthrough.unit?.nama || '-' }}</p>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Departemen</label>
                  <p class="font-medium">{{ selectedWalkthrough.departemen || '-' }}</p>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Jenis Walkthrough</label>
                  <p><span :class="getJenisBadgeClass(selectedWalkthrough.jenis_walkthrough)">{{ formatJenis(selectedWalkthrough.jenis_walkthrough) }}</span></p>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Status</label>
                  <p><span :class="getStatusBadgeClass(selectedWalkthrough.status)">{{ formatStatus(selectedWalkthrough.status) }}</span></p>
                </div>
              </div>
            </div>

            <!-- 2. Tim Inspeksi -->
            <div class="mb-6 bg-gray-50 rounded-lg p-4">
              <h3 class="text-lg font-semibold text-gray-900 mb-3">Tim Inspeksi</h3>
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="text-sm text-gray-600">Pimpinan Walkthrough</label>
                  <p class="font-medium">{{ selectedWalkthrough.pimpinan_walkthrough }}</p>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Jumlah Tim</label>
                  <p class="font-medium">{{ selectedWalkthrough.jumlah_tim || 0 }} orang</p>
                </div>
                <div class="col-span-2">
                  <label class="text-sm text-gray-600">Anggota Tim</label>
                  <div class="flex flex-wrap gap-2 mt-1">
                    <span v-for="(member, idx) in selectedWalkthrough.anggota_tim" :key="idx" class="px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm">
                      {{ member }}
                    </span>
                  </div>
                </div>
                <div class="col-span-2">
                  <label class="text-sm text-gray-600">Tujuan Walkthrough</label>
                  <p class="font-medium">{{ selectedWalkthrough.tujuan_walkthrough || '-' }}</p>
                </div>
                <div class="col-span-2">
                  <label class="text-sm text-gray-600">Fokus Area</label>
                  <div class="flex flex-wrap gap-2 mt-1">
                    <span v-for="(focus, idx) in selectedWalkthrough.fokus_area" :key="idx" class="px-3 py-1 bg-green-100 text-green-800 rounded-full text-sm">
                      {{ focus }}
                    </span>
                  </div>
                </div>
              </div>
            </div>

            <!-- 3. Observasi Kondisi -->
            <div class="mb-6 bg-gray-50 rounded-lg p-4">
              <h3 class="text-lg font-semibold text-gray-900 mb-3">Observasi Kondisi Fisik</h3>
              <div class="grid grid-cols-4 gap-4">
                <div>
                  <label class="text-sm text-gray-600">Housekeeping</label>
                  <p><span :class="getKondisiBadge(selectedWalkthrough.kondisi_housekeeping)">{{ selectedWalkthrough.kondisi_housekeeping || '-' }}</span></p>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Pencahayaan</label>
                  <p><span :class="getKondisiBadge(selectedWalkthrough.kondisi_pencahayaan)">{{ selectedWalkthrough.kondisi_pencahayaan || '-' }}</span></p>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Ventilasi</label>
                  <p><span :class="getKondisiBadge(selectedWalkthrough.kondisi_ventilasi)">{{ selectedWalkthrough.kondisi_ventilasi || '-' }}</span></p>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Akses Jalan</label>
                  <p><span :class="getKondisiBadge(selectedWalkthrough.kondisi_akses_jalan)">{{ selectedWalkthrough.kondisi_akses_jalan || '-' }}</span></p>
                </div>
              </div>
            </div>

            <!-- 4. Observasi APD -->
            <div class="mb-6 bg-gray-50 rounded-lg p-4">
              <h3 class="text-lg font-semibold text-gray-900 mb-3">Observasi APD</h3>
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="text-sm text-gray-600">Tingkat Kepatuhan APD</label>
                  <div class="flex items-center gap-2">
                    <div class="flex-1 bg-gray-200 rounded-full h-4">
                      <div class="bg-blue-600 h-4 rounded-full" :style="`width: ${selectedWalkthrough.kepatuhan_apd || 0}%`"></div>
                    </div>
                    <span class="font-bold text-lg">{{ selectedWalkthrough.kepatuhan_apd || 0 }}%</span>
                  </div>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Status APD</label>
                  <div class="flex gap-2">
                    <span :class="selectedWalkthrough.apd_tersedia ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'" class="px-2 py-1 rounded text-sm">
                      {{ selectedWalkthrough.apd_tersedia ? 'Tersedia' : 'Tidak Tersedia' }}
                    </span>
                    <span :class="selectedWalkthrough.apd_kondisi_baik ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'" class="px-2 py-1 rounded text-sm">
                      {{ selectedWalkthrough.apd_kondisi_baik ? 'Kondisi Baik' : 'Kondisi Buruk' }}
                    </span>
                    <span :class="selectedWalkthrough.apd_digunakan_benar ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'" class="px-2 py-1 rounded text-sm">
                      {{ selectedWalkthrough.apd_digunakan_benar ? 'Digunakan Benar' : 'Tidak Benar' }}
                    </span>
                  </div>
                </div>
                <div class="col-span-2" v-if="selectedWalkthrough.apd_tidak_sesuai?.length">
                  <label class="text-sm text-gray-600">APD Tidak Sesuai</label>
                  <ul class="list-disc list-inside mt-1">
                    <li v-for="(item, idx) in selectedWalkthrough.apd_tidak_sesuai" :key="idx" class="text-sm">{{ item }}</li>
                  </ul>
                </div>
              </div>
            </div>

            <!-- 5. Observasi Perilaku -->
            <div class="mb-6 bg-gray-50 rounded-lg p-4">
              <h3 class="text-lg font-semibold text-gray-900 mb-3">Observasi Perilaku Kerja</h3>
              <div class="grid grid-cols-3 gap-4 mb-3">
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-gray-900">{{ selectedWalkthrough.pekerja_diamati || 0 }}</div>
                  <div class="text-sm text-gray-600">Pekerja Diamati</div>
                </div>
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-green-600">{{ selectedWalkthrough.perilaku_aman || 0 }}</div>
                  <div class="text-sm text-gray-600">Perilaku Aman</div>
                </div>
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-red-600">{{ selectedWalkthrough.perilaku_tidak_aman || 0 }}</div>
                  <div class="text-sm text-gray-600">Perilaku Tidak Aman</div>
                </div>
              </div>
              <div v-if="selectedWalkthrough.perilaku_tidak_aman_detail">
                <label class="text-sm text-gray-600">Detail Perilaku Tidak Aman</label>
                <pre class="text-xs bg-white p-2 rounded mt-1">{{ JSON.stringify(selectedWalkthrough.perilaku_tidak_aman_detail, null, 2) }}</pre>
              </div>
            </div>

            <!-- 6. Interaksi Pekerja -->
            <div class="mb-6 bg-gray-50 rounded-lg p-4">
              <h3 class="text-lg font-semibold text-gray-900 mb-3">Interaksi dengan Pekerja</h3>
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="text-sm text-gray-600">Jumlah Diwawancara</label>
                  <p class="font-medium">{{ selectedWalkthrough.jumlah_pekerja_diwawancara || 0 }} orang</p>
                </div>
                <div>
                  <label class="text-sm text-gray-600">Awareness Prosedur K3</label>
                  <p><span :class="selectedWalkthrough.pekerja_aware_prosedur ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'" class="px-2 py-1 rounded text-sm">
                    {{ selectedWalkthrough.pekerja_aware_prosedur ? 'Paham' : 'Tidak Paham' }}
                  </span></p>
                </div>
                <div class="col-span-2" v-if="selectedWalkthrough.feedback_pekerja?.length">
                  <label class="text-sm text-gray-600">Feedback Pekerja</label>
                  <ul class="list-disc list-inside mt-1">
                    <li v-for="(item, idx) in selectedWalkthrough.feedback_pekerja" :key="idx" class="text-sm">{{ item }}</li>
                  </ul>
                </div>
                <div class="col-span-2" v-if="selectedWalkthrough.saran_pekerja?.length">
                  <label class="text-sm text-gray-600">Saran Pekerja</label>
                  <ul class="list-disc list-inside mt-1">
                    <li v-for="(item, idx) in selectedWalkthrough.saran_pekerja" :key="idx" class="text-sm">{{ item }}</li>
                  </ul>
                </div>
              </div>
            </div>

            <!-- 7. Temuan Bahaya -->
            <div class="mb-6 bg-gray-50 rounded-lg p-4">
              <h3 class="text-lg font-semibold text-gray-900 mb-3">Temuan Bahaya</h3>
              <div class="grid grid-cols-4 gap-3 mb-4">
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-gray-900">{{ selectedWalkthrough.jumlah_temuan || 0 }}</div>
                  <div class="text-xs text-gray-600">Total Temuan</div>
                </div>
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-red-600">{{ selectedWalkthrough.temuan_kritis || 0 }}</div>
                  <div class="text-xs text-gray-600">Kritis</div>
                </div>
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-orange-600">{{ selectedWalkthrough.temuan_mayor || 0 }}</div>
                  <div class="text-xs text-gray-600">Mayor</div>
                </div>
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-yellow-600">{{ selectedWalkthrough.temuan_minor || 0 }}</div>
                  <div class="text-xs text-gray-600">Minor</div>
                </div>
              </div>
              <div v-if="selectedWalkthrough.temuan_bahaya" class="space-y-2">
                <div v-for="(temuan, idx) in parseJSON(selectedWalkthrough.temuan_bahaya)" :key="idx" class="bg-white p-3 rounded border-l-4" :class="getRiskBorderClass(temuan.tingkat_risiko)">
                  <div class="flex justify-between items-start">
                    <div class="flex-1">
                      <div class="font-medium">{{ temuan.deskripsi }}</div>
                      <div class="text-sm text-gray-600 mt-1">
                        <span class="font-medium">Kategori:</span> {{ temuan.kategori }} | 
                        <span class="font-medium">Lokasi:</span> {{ temuan.lokasi }}
                      </div>
                      
                      <!-- Foto bukti temuan -->
                      <div v-if="temuan.foto_urls && temuan.foto_urls.length" class="mt-2">
                        <div class="text-xs text-gray-600 mb-1">Foto Bukti:</div>
                        <div class="grid grid-cols-4 gap-2">
                          <div v-for="(foto, photoIdx) in temuan.foto_urls" :key="photoIdx" class="relative group cursor-pointer" @click="openPhotoViewer(temuan.foto_urls, photoIdx)">
                            <img :src="foto" class="w-full h-20 object-cover rounded border hover:opacity-75 transition" />
                            <div class="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-30 transition rounded flex items-center justify-center">
                              <svg class="w-6 h-6 text-white opacity-0 group-hover:opacity-100 transition" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM10 7v3m0 0v3m0-3h3m-3 0H7" />
                              </svg>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                    <span :class="getRiskBadge(temuan.tingkat_risiko)" class="ml-2">{{ temuan.tingkat_risiko }}</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- 8. Pelanggaran & Positive Findings -->
            <div class="mb-6 grid grid-cols-2 gap-4">
              <div class="bg-red-50 rounded-lg p-4">
                <h3 class="text-lg font-semibold text-gray-900 mb-3">Pelanggaran</h3>
                <div v-if="selectedWalkthrough.pelanggaran_prosedur?.length">
                  <label class="text-sm text-gray-600">Pelanggaran Prosedur</label>
                  <ul class="list-disc list-inside mt-1">
                    <li v-for="(item, idx) in selectedWalkthrough.pelanggaran_prosedur" :key="idx" class="text-sm">{{ item }}</li>
                  </ul>
                </div>
              </div>
              <div class="bg-green-50 rounded-lg p-4">
                <h3 class="text-lg font-semibold text-gray-900 mb-3">Positive Findings</h3>
                <div v-if="selectedWalkthrough.praktek_baik?.length">
                  <label class="text-sm text-gray-600">Praktek Baik</label>
                  <ul class="list-disc list-inside mt-1">
                    <li v-for="(item, idx) in selectedWalkthrough.praktek_baik" :key="idx" class="text-sm">{{ item }}</li>
                  </ul>
                </div>
              </div>
            </div>

            <!-- 9. Action Items -->
            <div class="mb-6 bg-gray-50 rounded-lg p-4">
              <h3 class="text-lg font-semibold text-gray-900 mb-3">Action Items</h3>
              <div class="grid grid-cols-4 gap-3 mb-4">
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-gray-900">{{ selectedWalkthrough.jumlah_action_item || 0 }}</div>
                  <div class="text-xs text-gray-600">Total Action</div>
                </div>
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-green-600">{{ selectedWalkthrough.action_selesai || 0 }}</div>
                  <div class="text-xs text-gray-600">Selesai</div>
                </div>
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-blue-600">{{ selectedWalkthrough.action_progress || 0 }}</div>
                  <div class="text-xs text-gray-600">In Progress</div>
                </div>
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-gray-600">{{ selectedWalkthrough.action_belum_mulai || 0 }}</div>
                  <div class="text-xs text-gray-600">Belum Mulai</div>
                </div>
              </div>
              <div v-if="selectedWalkthrough.action_items" class="space-y-2">
                <div v-for="(action, idx) in parseJSON(selectedWalkthrough.action_items)" :key="idx" class="bg-white p-3 rounded">
                  <div class="flex justify-between items-start">
                    <div class="flex-1">
                      <div class="font-medium">{{ action.tindakan }}</div>
                      <div class="text-sm text-gray-600 mt-1">
                        <span class="font-medium">PIC:</span> {{ action.pic }} | 
                        <span class="font-medium">Target:</span> {{ action.target }}
                      </div>
                    </div>
                    <span :class="getActionStatusBadge(action.status)" class="ml-2">{{ action.status }}</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- 10. Ringkasan & Scoring -->
            <div class="mb-6 bg-gray-50 rounded-lg p-4">
              <h3 class="text-lg font-semibold text-gray-900 mb-3">Ringkasan & Scoring</h3>
              <div class="grid grid-cols-4 gap-3 mb-4">
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-blue-600">{{ selectedWalkthrough.skor_keseluruhan || 0 }}</div>
                  <div class="text-xs text-gray-600">Overall</div>
                </div>
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-purple-600">{{ selectedWalkthrough.skor_housekeeping || 0 }}</div>
                  <div class="text-xs text-gray-600">Housekeeping</div>
                </div>
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-green-600">{{ selectedWalkthrough.skor_apd || 0 }}</div>
                  <div class="text-xs text-gray-600">APD</div>
                </div>
                <div class="text-center p-3 bg-white rounded">
                  <div class="text-2xl font-bold text-orange-600">{{ selectedWalkthrough.skor_perilaku || 0 }}</div>
                  <div class="text-xs text-gray-600">Perilaku</div>
                </div>
              </div>
              <div v-if="selectedWalkthrough.ringkasan_observasi">
                <label class="text-sm text-gray-600">Ringkasan Observasi</label>
                <p class="text-sm mt-1">{{ selectedWalkthrough.ringkasan_observasi }}</p>
              </div>
              <div v-if="selectedWalkthrough.rekomendasi?.length" class="mt-3">
                <label class="text-sm text-gray-600">Rekomendasi</label>
                <ul class="list-disc list-inside mt-1">
                  <li v-for="(item, idx) in selectedWalkthrough.rekomendasi" :key="idx" class="text-sm">{{ item }}</li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Form Modal -->
    <div v-if="showFormModal" class="fixed inset-0 z-50 overflow-y-auto" @click.self="closeFormModal">
      <div class="flex items-center justify-center min-h-screen px-4">
        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"></div>
        <div class="relative bg-white rounded-lg max-w-6xl w-full max-h-[90vh] overflow-y-auto">
          <div class="p-6">
            <!-- Header -->
            <div class="flex justify-between items-start mb-6">
              <h2 class="text-2xl font-bold text-gray-900">{{ formMode === 'create' ? 'Buat' : 'Edit' }} Walkthrough</h2>
              <button @click="closeFormModal" class="text-gray-400 hover:text-gray-600">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>

            <!-- Tabs -->
            <div class="border-b border-gray-200 mb-6">
              <nav class="-mb-px flex space-x-4 overflow-x-auto">
                <button
                  v-for="tab in formTabs"
                  :key="tab.id"
                  @click="activeFormTab = tab.id"
                  :class="[
                    'whitespace-nowrap py-3 px-4 border-b-2 font-medium text-sm',
                    activeFormTab === tab.id
                      ? 'border-blue-500 text-blue-600'
                      : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
                  ]"
                >
                  {{ tab.label }}
                </button>
              </nav>
            </div>

            <!-- Form Content -->
            <form @submit.prevent="handleSubmit">
              <!-- Tab 1: Data Dasar -->
              <div v-show="activeFormTab === 'dasar'" class="space-y-4">
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Nomor Walkthrough *</label>
                    <input
                      v-model="formData.nomor_walkthrough"
                      type="text"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="Auto-generate jika kosong"
                    />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal *</label>
                    <input
                      v-model="formData.tanggal_walkthrough"
                      type="date"
                      required
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Waktu Mulai *</label>
                    <input
                      v-model="formData.waktu_mulai"
                      type="time"
                      required
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Waktu Selesai</label>
                    <input
                      v-model="formData.waktu_selesai"
                      type="time"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Unit</label>
                    <select
                      v-model="formData.unit_id"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    >
                      <option value="">Pilih Unit</option>
                      <option v-for="unit in units" :key="unit.id" :value="unit.id">{{ unit.nama }}</option>
                    </select>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Departemen</label>
                    <input
                      v-model="formData.departemen"
                      type="text"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                  <div class="col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Area Inspeksi *</label>
                    <input
                      v-model="formData.area_inspeksi"
                      type="text"
                      required
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Jenis Walkthrough</label>
                    <select
                      v-model="formData.jenis_walkthrough"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    >
                      <option value="rutin">Rutin</option>
                      <option value="terjadwal">Terjadwal</option>
                      <option value="insidental">Insidental</option>
                      <option value="follow_up">Follow Up</option>
                      <option value="khusus">Khusus</option>
                    </select>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                    <select
                      v-model="formData.status"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    >
                      <option value="draft">Draft</option>
                      <option value="in_progress">In Progress</option>
                      <option value="completed">Completed</option>
                      <option value="cancelled">Cancelled</option>
                    </select>
                  </div>
                </div>
              </div>

              <!-- Tab 2: Tim Inspeksi -->
              <div v-show="activeFormTab === 'tim'" class="space-y-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Pimpinan Walkthrough *</label>
                  <input
                    v-model="formData.pimpinan_walkthrough"
                    type="text"
                    required
                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Anggota Tim (pisahkan dengan enter)</label>
                  <textarea
                    v-model="anggotaTimText"
                    rows="4"
                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Nama Anggota 1&#10;Nama Anggota 2&#10;Nama Anggota 3"
                  ></textarea>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Tujuan Walkthrough</label>
                  <textarea
                    v-model="formData.tujuan_walkthrough"
                    rows="3"
                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  ></textarea>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Fokus Area (pisahkan dengan enter)</label>
                  <textarea
                    v-model="fokusAreaText"
                    rows="3"
                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    placeholder="Housekeeping&#10;APD&#10;Ergonomi"
                  ></textarea>
                </div>
              </div>

              <!-- Tab 3: Observasi Kondisi -->
              <div v-show="activeFormTab === 'kondisi'" class="space-y-4">
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Kondisi Housekeeping</label>
                    <select
                      v-model="formData.kondisi_housekeeping"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    >
                      <option value="">Pilih</option>
                      <option value="baik">Baik</option>
                      <option value="cukup">Cukup</option>
                      <option value="kurang">Kurang</option>
                      <option value="buruk">Buruk</option>
                    </select>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Kondisi Pencahayaan</label>
                    <select
                      v-model="formData.kondisi_pencahayaan"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    >
                      <option value="">Pilih</option>
                      <option value="baik">Baik</option>
                      <option value="cukup">Cukup</option>
                      <option value="kurang">Kurang</option>
                      <option value="buruk">Buruk</option>
                    </select>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Kondisi Ventilasi</label>
                    <select
                      v-model="formData.kondisi_ventilasi"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    >
                      <option value="">Pilih</option>
                      <option value="baik">Baik</option>
                      <option value="cukup">Cukup</option>
                      <option value="kurang">Kurang</option>
                      <option value="buruk">Buruk</option>
                    </select>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Kondisi Akses Jalan</label>
                    <select
                      v-model="formData.kondisi_akses_jalan"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    >
                      <option value="">Pilih</option>
                      <option value="baik">Baik</option>
                      <option value="cukup">Cukup</option>
                      <option value="kurang">Kurang</option>
                      <option value="buruk">Buruk</option>
                    </select>
                  </div>
                </div>
              </div>

              <!-- Tab 4: Observasi APD -->
              <div v-show="activeFormTab === 'apd'" class="space-y-4">
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Kepatuhan APD (%)</label>
                    <input
                      v-model.number="formData.kepatuhan_apd"
                      type="number"
                      min="0"
                      max="100"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                  <div class="col-span-2 space-y-2">
                    <label class="flex items-center">
                      <input v-model="formData.apd_tersedia" type="checkbox" class="mr-2" />
                      <span class="text-sm">APD Tersedia</span>
                    </label>
                    <label class="flex items-center">
                      <input v-model="formData.apd_kondisi_baik" type="checkbox" class="mr-2" />
                      <span class="text-sm">APD Kondisi Baik</span>
                    </label>
                    <label class="flex items-center">
                      <input v-model="formData.apd_digunakan_benar" type="checkbox" class="mr-2" />
                      <span class="text-sm">APD Digunakan Benar</span>
                    </label>
                  </div>
                  <div class="col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-1">APD Tidak Sesuai (pisahkan dengan enter)</label>
                    <textarea
                      v-model="apdTidakSesuaiText"
                      rows="3"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    ></textarea>
                  </div>
                </div>
              </div>

              <!-- Tab 5: Perilaku Kerja -->
              <div v-show="activeFormTab === 'perilaku'" class="space-y-4">
                <div class="grid grid-cols-3 gap-4">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Pekerja Diamati</label>
                    <input
                      v-model.number="formData.pekerja_diamati"
                      type="number"
                      min="0"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Perilaku Aman</label>
                    <input
                      v-model.number="formData.perilaku_aman"
                      type="number"
                      min="0"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Perilaku Tidak Aman</label>
                    <input
                      v-model.number="formData.perilaku_tidak_aman"
                      type="number"
                      min="0"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Jumlah Diwawancara</label>
                  <input
                    v-model.number="formData.jumlah_pekerja_diwawancara"
                    type="number"
                    min="0"
                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label class="flex items-center">
                    <input v-model="formData.pekerja_aware_prosedur" type="checkbox" class="mr-2" />
                    <span class="text-sm">Pekerja Aware Prosedur K3</span>
                  </label>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Feedback Pekerja (pisahkan dengan enter)</label>
                  <textarea
                    v-model="feedbackPekerjaText"
                    rows="3"
                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  ></textarea>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Saran Pekerja (pisahkan dengan enter)</label>
                  <textarea
                    v-model="saranPekerjaText"
                    rows="3"
                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  ></textarea>
                </div>
              </div>

              <!-- Tab 6: Temuan Bahaya -->
              <div v-show="activeFormTab === 'temuan'" class="space-y-4">
                <div class="flex justify-between items-center mb-3">
                  <h4 class="font-medium">Daftar Temuan Bahaya</h4>
                  <button
                    type="button"
                    @click="addTemuan"
                    class="px-3 py-1 bg-blue-600 text-white text-sm rounded hover:bg-blue-700"
                  >
                    + Tambah Temuan
                  </button>
                </div>
                <div v-for="(temuan, idx) in formData.temuan_bahaya" :key="idx" class="border rounded p-3 space-y-3">
                  <div class="flex justify-between items-center">
                    <span class="font-medium">Temuan #{{ idx + 1 }}</span>
                    <button
                      type="button"
                      @click="removeTemuan(idx)"
                      class="text-red-600 hover:text-red-800 text-sm"
                    >
                      Hapus
                    </button>
                  </div>
                  <div class="grid grid-cols-2 gap-3">
                    <div>
                      <label class="block text-sm text-gray-700 mb-1">Kategori</label>
                      <select
                        v-model="temuan.kategori"
                        class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm"
                      >
                        <option value="fisik">Fisik</option>
                        <option value="mekanik">Mekanik</option>
                        <option value="elektrik">Elektrik</option>
                        <option value="kimia">Kimia</option>
                        <option value="ergonomi">Ergonomi</option>
                        <option value="biological">Biological</option>
                        <option value="psikososial">Psikososial</option>
                      </select>
                    </div>
                    <div>
                      <label class="block text-sm text-gray-700 mb-1">Tingkat Risiko</label>
                      <select
                        v-model="temuan.tingkat_risiko"
                        class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm"
                      >
                        <option value="kritis">Kritis</option>
                        <option value="tinggi">Tinggi</option>
                        <option value="sedang">Sedang</option>
                        <option value="rendah">Rendah</option>
                      </select>
                    </div>
                    <div class="col-span-2">
                      <label class="block text-sm text-gray-700 mb-1">Deskripsi</label>
                      <textarea
                        v-model="temuan.deskripsi"
                        rows="2"
                        class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm"
                      ></textarea>
                    </div>
                    <div class="col-span-2">
                      <label class="block text-sm text-gray-700 mb-1">Lokasi</label>
                      <input
                        v-model="temuan.lokasi"
                        type="text"
                        class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm"
                      />
                    </div>
                    <div class="col-span-2">
                      <label class="block text-sm text-gray-700 mb-1">Foto Bukti Temuan</label>
                      <!-- File input dari galeri -->
                      <input
                        :ref="el => temuanPhotoInputs[idx] = el as HTMLInputElement"
                        type="file"
                        accept="image/*"
                        multiple
                        class="hidden"
                        @change="handleTemuanPhotoUpload($event, idx)"
                      />
                      <!-- File input dari kamera -->
                      <input
                        type="file"
                        accept="image/*"
                        capture="environment"
                        class="hidden"
                        :ref="el => temuanCameraInputs[idx] = el as HTMLInputElement"
                        @change="handleTemuanPhotoUpload($event, idx)"
                      />
                      <div class="flex gap-2">
                        <button
                          type="button"
                          @click="temuanCameraInputs[idx]?.click()"
                          class="flex-1 px-3 py-2 bg-green-600 text-white text-sm rounded hover:bg-green-700 flex items-center justify-center gap-2"
                        >
                          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                          </svg>
                          Ambil Foto
                        </button>
                        <button
                          type="button"
                          @click="temuanPhotoInputs[idx]?.click()"
                          class="flex-1 px-3 py-2 bg-blue-600 text-white text-sm rounded hover:bg-blue-700 flex items-center justify-center gap-2"
                        >
                          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                          </svg>
                          Pilih dari Galeri
                        </button>
                      </div>
                      <p class="text-xs text-gray-500 mt-1">📸 Foto akan dikompres otomatis jika >1MB</p>
                      <button
                        type="button"
                        @click="temuanPhotoInputs[idx]?.click()"
                        class="w-full px-3 py-2 border-2 border-dashed border-gray-300 rounded-md text-sm text-gray-600 hover:border-blue-500 hover:text-blue-600"
                      >
                        📷 Upload Foto (Max 5MB per foto)
                      </button>
                      
                      <!-- Preview uploaded photos -->
                      <div v-if="temuan.foto_urls && temuan.foto_urls.length" class="mt-2 grid grid-cols-3 gap-2">
                        <div v-for="(foto, photoIdx) in temuan.foto_urls" :key="photoIdx" class="relative">
                          <img :src="foto" class="w-full h-20 object-cover rounded border" />
                          <button
                            type="button"
                            @click="removeTemuanPhoto(idx, photoIdx)"
                            class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full w-5 h-5 text-xs hover:bg-red-600"
                          >
                            ×
                          </button>
                        </div>
                      </div>
                      
                      <!-- Upload progress -->
                      <div v-if="temuan.uploading" class="mt-2 text-sm text-blue-600">
                        Uploading foto...
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Tab 7: Action Items -->
              <div v-show="activeFormTab === 'action'" class="space-y-4">
                <div class="flex justify-between items-center mb-3">
                  <h4 class="font-medium">Daftar Action Items</h4>
                  <button
                    type="button"
                    @click="addActionItem"
                    class="px-3 py-1 bg-blue-600 text-white text-sm rounded hover:bg-blue-700"
                  >
                    + Tambah Action
                  </button>
                </div>
                <div v-for="(action, idx) in formData.action_items" :key="idx" class="border rounded p-3 space-y-3">
                  <div class="flex justify-between items-center">
                    <span class="font-medium">Action #{{ idx + 1 }}</span>
                    <button
                      type="button"
                      @click="removeActionItem(idx)"
                      class="text-red-600 hover:text-red-800 text-sm"
                    >
                      Hapus
                    </button>
                  </div>
                  <div class="grid grid-cols-2 gap-3">
                    <div class="col-span-2">
                      <label class="block text-sm text-gray-700 mb-1">Tindakan</label>
                      <textarea
                        v-model="action.tindakan"
                        rows="2"
                        class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm"
                      ></textarea>
                    </div>
                    <div>
                      <label class="block text-sm text-gray-700 mb-1">PIC</label>
                      <input
                        v-model="action.pic"
                        type="text"
                        class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm"
                      />
                    </div>
                    <div>
                      <label class="block text-sm text-gray-700 mb-1">Target Selesai</label>
                      <input
                        v-model="action.target"
                        type="date"
                        class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm"
                      />
                    </div>
                    <div>
                      <label class="block text-sm text-gray-700 mb-1">Prioritas</label>
                      <select
                        v-model="action.prioritas"
                        class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm"
                      >
                        <option value="kritis">Kritis</option>
                        <option value="tinggi">Tinggi</option>
                        <option value="sedang">Sedang</option>
                        <option value="rendah">Rendah</option>
                      </select>
                    </div>
                    <div>
                      <label class="block text-sm text-gray-700 mb-1">Status</label>
                      <select
                        v-model="action.status"
                        class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm"
                      >
                        <option value="belum_mulai">Belum Mulai</option>
                        <option value="progress">In Progress</option>
                        <option value="selesai">Selesai</option>
                      </select>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Tab 8: Scoring & Ringkasan -->
              <div v-show="activeFormTab === 'scoring'" class="space-y-4">
                <div class="grid grid-cols-4 gap-4">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Skor Keseluruhan</label>
                    <input
                      v-model.number="formData.skor_keseluruhan"
                      type="number"
                      min="0"
                      max="100"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Skor Housekeeping</label>
                    <input
                      v-model.number="formData.skor_housekeeping"
                      type="number"
                      min="0"
                      max="100"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Skor APD</label>
                    <input
                      v-model.number="formData.skor_apd"
                      type="number"
                      min="0"
                      max="100"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Skor Perilaku</label>
                    <input
                      v-model.number="formData.skor_perilaku"
                      type="number"
                      min="0"
                      max="100"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  </div>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Ringkasan Observasi</label>
                  <textarea
                    v-model="formData.ringkasan_observasi"
                    rows="4"
                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  ></textarea>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Rekomendasi (pisahkan dengan enter)</label>
                  <textarea
                    v-model="rekomendasiText"
                    rows="4"
                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  ></textarea>
                </div>
              </div>

              <!-- Form Actions -->
              <div class="mt-6 flex justify-end space-x-3">
                <button
                  type="button"
                  @click="closeFormModal"
                  class="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50"
                >
                  Batal
                </button>
                <button
                  type="submit"
                  class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
                >
                  {{ formMode === 'create' ? 'Simpan' : 'Update' }}
                </button>
              </div>
            </form>
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

        <!-- Thumbnail Strip -->
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
import { ref, reactive, onMounted, onUnmounted, watch, computed } from 'vue'
import { useRoute } from 'vue-router'
import { managementWalkthroughService, type ManagementWalkthrough } from '@/services/management-walkthrough.service'
import { unitsService } from '@/services/api/units.service'
import { useImageCompression } from '@/composables/useImageCompression'

const route = useRoute()

const { compressSingleImage, formatFileSize } = useImageCompression()

// State
const loading = ref(false)
const walkthroughs = ref<ManagementWalkthrough[]>([])
const units = ref<any[]>([])
const stats = ref({
  total: 0,
  temuanKritis: 0,
  temuanMayor: 0,
  byStatus: {
    draft: 0,
    in_progress: 0,
    completed: 0,
    cancelled: 0
  },
  byUrgensi: {
    rendah: 0,
    normal: 0,
    tinggi: 0,
    kritis: 0
  }
})
const followUpCount = ref(0)

const filters = reactive({
  search: '',
  unit_id: '',
  jenis: '',
  status: ''
})

const showDetailModal = ref(false)
const showFormModal = ref(false)
const showPhotoModal = ref(false)
const formMode = ref<'create' | 'edit'>('create')
const selectedWalkthrough = ref<ManagementWalkthrough | null>(null)
const currentPhotos = ref<string[]>([])
const currentPhotoIndex = ref(0)
const activeFormTab = ref('dasar')

// Form tabs
const formTabs = [
  { id: 'dasar', label: 'Data Dasar' },
  { id: 'tim', label: 'Tim Inspeksi' },
  { id: 'kondisi', label: 'Kondisi' },
  { id: 'apd', label: 'APD' },
  { id: 'perilaku', label: 'Perilaku' },
  { id: 'temuan', label: 'Temuan' },
  { id: 'action', label: 'Action Items' },
  { id: 'scoring', label: 'Scoring' }
]

// Pagination
const currentPage = ref(1)
const pageSize = ref(20)
const totalRecords = ref(0)
const totalPages = ref(0)

// Form data
const formData = ref<any>({
  nomor_walkthrough: '',
  tanggal_walkthrough: '',
  waktu_mulai: '',
  waktu_selesai: '',
  unit_id: '',
  area_inspeksi: '',
  departemen: '',
  pimpinan_walkthrough: '',
  jenis_walkthrough: 'rutin',
  status: 'draft',
  kondisi_housekeeping: '',
  kondisi_pencahayaan: '',
  kondisi_ventilasi: '',
  kondisi_akses_jalan: '',
  kepatuhan_apd: 0,
  apd_tersedia: true,
  apd_kondisi_baik: true,
  apd_digunakan_benar: true,
  pekerja_diamati: 0,
  perilaku_aman: 0,
  perilaku_tidak_aman: 0,
  jumlah_pekerja_diwawancara: 0,
  pekerja_aware_prosedur: true,
  temuan_bahaya: [],
  action_items: [],
  skor_keseluruhan: 0,
  skor_housekeeping: 0,
  skor_apd: 0,
  skor_perilaku: 0,
  ringkasan_observasi: ''
})

// Text fields for arrays
const anggotaTimText = ref('')
const fokusAreaText = ref('')
const apdTidakSesuaiText = ref('')
const feedbackPekerjaText = ref('')
const saranPekerjaText = ref('')
const rekomendasiText = ref('')

// Photo upload refs
const temuanPhotoInputs = ref<(HTMLInputElement | null)[]>([])
const temuanCameraInputs = ref<(HTMLInputElement | null)[]>([])

// Methods
const loadWalkthroughs = async (page = currentPage.value) => {
  try {
    loading.value = true
    currentPage.value = page
    const response = await managementWalkthroughService.getPaginated(filters, {
      page: currentPage.value,
      pageSize: pageSize.value
    })
    walkthroughs.value = response.data
    totalRecords.value = response.count
    totalPages.value = response.totalPages
  } catch (error) {
    console.error('Error loading walkthroughs:', error)
    alert('Gagal memuat data walkthrough')
  } finally {
    loading.value = false
  }
}

const loadStats = async () => {
  try {
    stats.value = await managementWalkthroughService.getStatistics()
    const followUpData = await managementWalkthroughService.getFollowUpNeeded()
    followUpCount.value = followUpData.length
  } catch (error) {
    console.error('Error loading stats:', error)
  }
}

const loadUnits = async () => {
  try {
    units.value = await unitsService.getAllActiveHierarchical()
  } catch (error) {
    console.error('Error loading units:', error)
  }
}

const openDetailModal = (walkthrough: ManagementWalkthrough) => {
  selectedWalkthrough.value = walkthrough
  showDetailModal.value = true
}

const closeDetailModal = () => {
  showDetailModal.value = false
  selectedWalkthrough.value = null
}

const openFormModal = (mode: 'create' | 'edit', walkthrough?: ManagementWalkthrough) => {
  formMode.value = mode
  activeFormTab.value = 'dasar'
  
  if (mode === 'edit' && walkthrough) {
    selectedWalkthrough.value = walkthrough
    // Populate form
    Object.assign(formData.value, walkthrough)
    
    // Convert arrays to text
    anggotaTimText.value = walkthrough.anggota_tim?.join('\n') || ''
    fokusAreaText.value = walkthrough.fokus_area?.join('\n') || ''
    apdTidakSesuaiText.value = walkthrough.apd_tidak_sesuai?.join('\n') || ''
    feedbackPekerjaText.value = walkthrough.feedback_pekerja?.join('\n') || ''
    saranPekerjaText.value = walkthrough.saran_pekerja?.join('\n') || ''
    rekomendasiText.value = walkthrough.rekomendasi?.join('\n') || ''
    
    // Parse JSONB fields
    formData.value.temuan_bahaya = parseJSON(walkthrough.temuan_bahaya)
    formData.value.action_items = parseJSON(walkthrough.action_items)
  } else {
    selectedWalkthrough.value = null
    resetFormData()
  }
  showFormModal.value = true
}

const closeFormModal = () => {
  showFormModal.value = false
  selectedWalkthrough.value = null
  resetFormData()
}

const resetFormData = () => {
  formData.value = {
    nomor_walkthrough: '',
    tanggal_walkthrough: new Date().toISOString().split('T')[0],
    waktu_mulai: '',
    waktu_selesai: '',
    unit_id: '',
    area_inspeksi: '',
    departemen: '',
    pimpinan_walkthrough: '',
    jenis_walkthrough: 'rutin',
    status: 'draft',
    kondisi_housekeeping: '',
    kondisi_pencahayaan: '',
    kondisi_ventilasi: '',
    kondisi_akses_jalan: '',
    kepatuhan_apd: 0,
    apd_tersedia: true,
    apd_kondisi_baik: true,
    apd_digunakan_benar: true,
    pekerja_diamati: 0,
    perilaku_aman: 0,
    perilaku_tidak_aman: 0,
    jumlah_pekerja_diwawancara: 0,
    pekerja_aware_prosedur: true,
    temuan_bahaya: [],
    action_items: [],
    skor_keseluruhan: 0,
    skor_housekeeping: 0,
    skor_apd: 0,
    skor_perilaku: 0,
    ringkasan_observasi: ''
  }
  anggotaTimText.value = ''
  fokusAreaText.value = ''
  apdTidakSesuaiText.value = ''
  feedbackPekerjaText.value = ''
  saranPekerjaText.value = ''
  rekomendasiText.value = ''
}

const addTemuan = () => {
  formData.value.temuan_bahaya.push({
    no: formData.value.temuan_bahaya.length + 1,
    kategori: 'fisik',
    deskripsi: '',
    lokasi: '',
    tingkat_risiko: 'sedang',
    status: 'open',
    foto_urls: [],
    uploading: false
  })
}

const removeTemuan = (index: number) => {
  formData.value.temuan_bahaya.splice(index, 1)
}

const handleTemuanPhotoUpload = async (event: Event, temuanIndex: number) => {
  const target = event.target as HTMLInputElement
  const files = target.files
  if (!files || files.length === 0) return

  const temuan = formData.value.temuan_bahaya[temuanIndex]
  temuan.uploading = true

  try {
    // Generate temporary ID for upload path
    const tempId = formMode.value === 'edit' ? selectedWalkthrough.value?.id : `temp_${Date.now()}`
    
    for (let i = 0; i < files.length; i++) {
      const file = files[i]
      if (!file) continue
      
      // Auto-compress if >1MB
      const result = await compressSingleImage(file)
      const compressedFile = result.file
      
      if (result.wasCompressed) {
        console.log(`📸 ${file.name}: ${formatFileSize(result.originalSize)} → ${formatFileSize(result.compressedSize)} (${Math.round((1 - result.compressedSize / result.originalSize) * 100)}% lebih kecil)`)
      }

      // Upload to storage
      const photoUrl = await managementWalkthroughService.uploadPhoto(compressedFile, tempId || 'temp')
      
      // Add to foto_urls array
      if (!temuan.foto_urls) {
        temuan.foto_urls = []
      }
      temuan.foto_urls.push(photoUrl)
    }
  } catch (error) {
    console.error('Error uploading photo:', error)
    alert('Gagal upload foto: ' + (error as Error).message)
  } finally {
    temuan.uploading = false
    // Reset input
    target.value = ''
  }
}

const removeTemuanPhoto = (temuanIndex: number, photoIndex: number) => {
  const temuan = formData.value.temuan_bahaya[temuanIndex]
  if (temuan.foto_urls) {
    temuan.foto_urls.splice(photoIndex, 1)
  }
}

const openPhotoViewer = (photos: string[], startIndex: number) => {
  currentPhotos.value = photos
  currentPhotoIndex.value = startIndex
  showPhotoModal.value = true
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

const addActionItem = () => {
  formData.value.action_items.push({
    no: formData.value.action_items.length + 1,
    tindakan: '',
    pic: '',
    target: '',
    prioritas: 'sedang',
    status: 'belum_mulai'
  })
}

const removeActionItem = (index: number) => {
  formData.value.action_items.splice(index, 1)
}

const handleSubmit = async () => {
  try {
    // Convert text fields to arrays
    const dataToSave: any = { ...formData.value }
    
    dataToSave.anggota_tim = anggotaTimText.value.split('\n').filter(x => x.trim())
    dataToSave.jumlah_tim = dataToSave.anggota_tim.length
    dataToSave.fokus_area = fokusAreaText.value.split('\n').filter(x => x.trim())
    dataToSave.apd_tidak_sesuai = apdTidakSesuaiText.value.split('\n').filter(x => x.trim())
    dataToSave.feedback_pekerja = feedbackPekerjaText.value.split('\n').filter(x => x.trim())
    dataToSave.saran_pekerja = saranPekerjaText.value.split('\n').filter(x => x.trim())
    dataToSave.rekomendasi = rekomendasiText.value.split('\n').filter(x => x.trim())
    
    // Calculate counts
    dataToSave.jumlah_temuan = dataToSave.temuan_bahaya.length
    dataToSave.temuan_kritis = dataToSave.temuan_bahaya.filter((t: any) => t.tingkat_risiko === 'kritis').length
    dataToSave.temuan_mayor = dataToSave.temuan_bahaya.filter((t: any) => t.tingkat_risiko === 'tinggi').length
    dataToSave.temuan_minor = dataToSave.temuan_bahaya.filter((t: any) => t.tingkat_risiko === 'sedang').length
    dataToSave.temuan_observasi = dataToSave.temuan_bahaya.filter((t: any) => t.tingkat_risiko === 'rendah').length
    
    dataToSave.jumlah_action_item = dataToSave.action_items.length
    dataToSave.action_selesai = dataToSave.action_items.filter((a: any) => a.status === 'selesai').length
    dataToSave.action_progress = dataToSave.action_items.filter((a: any) => a.status === 'progress').length
    dataToSave.action_belum_mulai = dataToSave.action_items.filter((a: any) => a.status === 'belum_mulai').length
    
    // Remove unit object if exists (same issue as safety forum)
    delete dataToSave.unit

    // Convert empty string UUID fields to null
    if (dataToSave.unit_id === '') dataToSave.unit_id = null
    if (dataToSave.created_by === '') dataToSave.created_by = null
    if (dataToSave.approved_by === '') dataToSave.approved_by = null

    // Convert empty kondisi fields to null (to avoid check constraint violations)
    // Database accepts null for these optional fields, but not empty strings or invalid values
    if (!dataToSave.kondisi_housekeeping || dataToSave.kondisi_housekeeping === '') {
      dataToSave.kondisi_housekeeping = null
    }
    if (!dataToSave.kondisi_pencahayaan || dataToSave.kondisi_pencahayaan === '') {
      dataToSave.kondisi_pencahayaan = null
    }
    if (!dataToSave.kondisi_ventilasi || dataToSave.kondisi_ventilasi === '') {
      dataToSave.kondisi_ventilasi = null
    }
    if (!dataToSave.kondisi_akses_jalan || dataToSave.kondisi_akses_jalan === '') {
      dataToSave.kondisi_akses_jalan = null
    }
    
    if (formMode.value === 'create') {
      await managementWalkthroughService.create(dataToSave)
      alert('Walkthrough berhasil dibuat')
    } else {
      await managementWalkthroughService.update(selectedWalkthrough.value!.id!, dataToSave)
      alert('Walkthrough berhasil diupdate')
    }
    
    closeFormModal()
    loadWalkthroughs()
    loadStats()
  } catch (error) {
    console.error('Error saving walkthrough:', error)
    alert('Gagal menyimpan walkthrough: ' + (error as Error).message)
  }
}

const deleteWalkthrough = async (walkthrough: ManagementWalkthrough) => {
  if (!confirm(`Hapus walkthrough ${walkthrough.nomor_walkthrough}?`)) return

  try {
    await managementWalkthroughService.delete(walkthrough.id!)
    alert('Walkthrough berhasil dihapus')
    loadWalkthroughs()
    loadStats()
  } catch (error) {
    console.error('Error deleting walkthrough:', error)
    alert('Gagal menghapus walkthrough')
  }
}

// Formatters
const formatDate = (dateStr: string) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return date.toLocaleDateString('id-ID', { day: '2-digit', month: 'short', year: 'numeric' })
}

const formatJenis = (jenis?: string) => {
  const map: Record<string, string> = {
    rutin: 'Rutin',
    terjadwal: 'Terjadwal',
    insidental: 'Insidental',
    follow_up: 'Follow Up',
    khusus: 'Khusus'
  }
  return map[jenis || ''] || jenis || '-'
}

const formatStatus = (status?: string) => {
  const map: Record<string, string> = {
    draft: 'Draft',
    in_progress: 'In Progress',
    completed: 'Completed',
    cancelled: 'Cancelled'
  }
  return map[status || ''] || status || '-'
}

const getJenisBadgeClass = (jenis?: string) => {
  const baseClass = 'px-2 py-1 text-xs font-semibold rounded-full'
  const map: Record<string, string> = {
    rutin: 'bg-blue-100 text-blue-800',
    terjadwal: 'bg-green-100 text-green-800',
    insidental: 'bg-orange-100 text-orange-800',
    follow_up: 'bg-purple-100 text-purple-800',
    khusus: 'bg-pink-100 text-pink-800'
  }
  return `${baseClass} ${map[jenis || ''] || 'bg-gray-100 text-gray-800'}`
}

const getStatusBadgeClass = (status?: string) => {
  const baseClass = 'px-2 py-1 text-xs font-semibold rounded-full'
  const map: Record<string, string> = {
    draft: 'bg-gray-100 text-gray-800',
    in_progress: 'bg-blue-100 text-blue-800',
    completed: 'bg-green-100 text-green-800',
    cancelled: 'bg-red-100 text-red-800'
  }
  return `${baseClass} ${map[status || ''] || 'bg-gray-100 text-gray-800'}`
}

const getKondisiBadge = (kondisi?: string) => {
  const baseClass = 'px-2 py-1 text-xs font-semibold rounded'
  const map: Record<string, string> = {
    baik: 'bg-green-100 text-green-800',
    cukup: 'bg-blue-100 text-blue-800',
    kurang: 'bg-yellow-100 text-yellow-800',
    buruk: 'bg-red-100 text-red-800'
  }
  return `${baseClass} ${map[kondisi || ''] || 'bg-gray-100 text-gray-800'}`
}

const getRiskBorderClass = (risk?: string) => {
  const map: Record<string, string> = {
    kritis: 'border-red-500',
    tinggi: 'border-orange-500',
    sedang: 'border-yellow-500',
    rendah: 'border-green-500'
  }
  return map[risk || ''] || 'border-gray-300'
}

const getRiskBadge = (risk?: string) => {
  const baseClass = 'px-2 py-1 text-xs font-semibold rounded'
  const map: Record<string, string> = {
    kritis: 'bg-red-100 text-red-800',
    tinggi: 'bg-orange-100 text-orange-800',
    sedang: 'bg-yellow-100 text-yellow-800',
    rendah: 'bg-green-100 text-green-800'
  }
  return `${baseClass} ${map[risk || ''] || 'bg-gray-100 text-gray-800'}`
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

const getActionStatusBadge = (status?: string) => {
  const baseClass = 'px-2 py-1 text-xs font-semibold rounded'
  const map: Record<string, string> = {
    selesai: 'bg-green-100 text-green-800',
    progress: 'bg-blue-100 text-blue-800',
    belum_mulai: 'bg-gray-100 text-gray-800'
  }
  return `${baseClass} ${map[status || ''] || 'bg-gray-100 text-gray-800'}`
}

const parseJSON = (data: any) => {
  if (Array.isArray(data)) return data
  if (typeof data === 'string') {
    try {
      return JSON.parse(data)
    } catch {
      return []
    }
  }
  return data || []
}

// Pagination methods
const goToPage = async (page: number) => {
  if (page >= 1 && page <= totalPages.value) {
    await loadWalkthroughs(page)
  }
}

const nextPage = async () => {
  if (currentPage.value < totalPages.value) {
    await loadWalkthroughs(currentPage.value + 1)
  }
}

const prevPage = async () => {
  if (currentPage.value > 1) {
    await loadWalkthroughs(currentPage.value - 1)
  }
}

const changePageSize = async (newSize: number) => {
  pageSize.value = newSize
  currentPage.value = 1
  await loadWalkthroughs(1)
}

const applyFilters = async () => {
  currentPage.value = 1
  await loadWalkthroughs(1)
}

const paginationInfo = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value + 1
  const end = Math.min(currentPage.value * pageSize.value, totalRecords.value)
  return `Menampilkan ${start} - ${end} dari ${totalRecords.value} data`
})

const pageNumbers = computed(() => {
  const pages: number[] = []
  const maxVisible = 5
  let start = Math.max(1, currentPage.value - 2)
  let end = Math.min(totalPages.value, start + maxVisible - 1)
  
  if (end - start < maxVisible - 1) {
    start = Math.max(1, end - maxVisible + 1)
  }
  
  for (let i = start; i <= end; i++) {
    pages.push(i)
  }
  
  return pages
})

// Watchers
watch(filters, () => {
  applyFilters()
}, { deep: true })

// Lifecycle
onMounted(async () => {
  await loadWalkthroughs()
  loadStats()
  loadUnits()
  
  // Add keyboard event listener for photo viewer
  window.addEventListener('keydown', handleKeyPress)
  
  // Check if opened from monitoring table with id parameter
  const id = route.query.id as string
  const mode = route.query.mode as string
  if (id && mode === 'edit') {
    try {
      let item = walkthroughs.value.find(i => i.id === id)
      if (!item) {
        // If not in current page, fetch directly
        const fetchedItem = await managementWalkthroughService.getById(id)
        if (fetchedItem) {
          item = fetchedItem
        }
      }
      if (item) {
        openFormModal('edit', item)
      }
    } catch (error) {
      console.error('Error loading management walkthrough for edit:', error)
    }
  }
})

// Cleanup
onUnmounted(() => {
  window.removeEventListener('keydown', handleKeyPress)
})
</script>

<style scoped>
.management-walkthrough-view {
  padding: 1.5rem;
  max-width: 1400px;
  margin: 0 auto;
}
</style>
