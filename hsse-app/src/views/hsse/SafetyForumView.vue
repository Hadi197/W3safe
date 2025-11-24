<template>
  <div class="container mx-auto px-4 py-8">
    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-4 mb-6">
      <div>
        <h1 class="text-2xl md:text-3xl font-bold text-gray-800">Safety Forum</h1>
        <p class="text-gray-600 mt-1">Manajemen Forum Keselamatan Kerja & Notulensi</p>
      </div>
      <button
        @click="openFormModal()"
        class="bg-blue-600 hover:bg-blue-700 text-white px-4 md:px-6 py-3 md:py-3 rounded-lg shadow-md flex items-center justify-center gap-2 transition-all w-full sm:w-auto min-h-[44px] touch-manipulation"
      >
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
        Tambah Forum Baru
      </button>
    </div>

      <!-- Filters -->
      <div class="bg-white rounded-lg shadow-md p-4 md:p-6 mb-6">
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Cari Agenda/Nomor</label>
            <input
              v-model="filters.search"
              type="text"
              placeholder="Cari..."
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Unit</label>
            <select
              v-model="filters.unit_id"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
            >
              <option value="">Semua Unit</option>
              <option v-for="unit in units" :key="unit.id" :value="unit.id">{{ unit.nama }}</option>
            </select>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Jenis Forum</label>
            <select
              v-model="filters.jenis"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
            >
              <option value="">Semua Jenis</option>
              <option value="rutin">Rutin</option>
              <option value="bulanan">Bulanan</option>
              <option value="mingguan">Mingguan</option>
              <option value="tahunan">Tahunan</option>
              <option value="insidental">Insidental</option>
              <option value="darurat">Darurat</option>
            </select>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Status</label>
            <select
              v-model="filters.status"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
            >
              <option value="">Semua Status</option>
              <option value="draft">Draft</option>
              <option value="scheduled">Terjadwal</option>
              <option value="in_progress">Sedang Berlangsung</option>
              <option value="completed">Selesai</option>
              <option value="cancelled">Dibatalkan</option>
            </select>
          </div>

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Bulan/Tahun</label>
            <input
              v-model="filters.month"
              type="month"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
            />
          </div>
        </div>
      </div>

      <!-- Table -->
      <div class="bg-white rounded-lg shadow-md overflow-hidden">
        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Nomor & Tanggal
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Agenda Utama
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Unit/Lokasi
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Jenis
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Peserta
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Action Items
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Status
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Aksi
                </th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <tr v-for="forum in filteredForums" :key="forum.id" class="hover:bg-gray-50">
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm font-medium text-gray-900">{{ forum.nomor_forum }}</div>
                  <div class="text-sm text-gray-500">{{ formatDate(forum.tanggal_forum) }}</div>
                  <div class="text-xs text-gray-400">{{ forum.waktu_mulai }} - {{ forum.waktu_selesai || '-' }}</div>
                </td>
                <td class="px-6 py-4">
                  <div class="text-sm text-gray-900">{{ forum.agenda_utama }}</div>
                  <div class="text-xs text-gray-500 mt-1">{{ forum.periode || '-' }}</div>
                  <div class="text-xs text-gray-500">Kategori: {{ forum.kategori_forum || '-' }}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm text-gray-900">{{ forum.unit?.nama || '-' }}</div>
                  <div class="text-xs text-gray-500">{{ forum.lokasi }}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <span :class="getJenisForumBadgeClass(forum.jenis_forum)">
                    {{ forum.jenis_forum }}
                  </span>
                  <div v-if="forum.tingkat_urgensi !== 'normal'" class="mt-1">
                    <span :class="getUrgensiClass(forum.tingkat_urgensi)">
                      {{ forum.tingkat_urgensi }}
                    </span>
                  </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                  <div>Hadir: {{ forum.jumlah_peserta || 0 }}</div>
                  <div class="text-xs text-gray-500">
                    Total wajib: {{ forum.peserta_wajib?.length || 0 }}
                  </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm">
                    <div class="font-medium">Total: {{ forum.jumlah_action_item || 0 }}</div>
                    <div class="text-xs text-green-600">Selesai: {{ forum.action_selesai || 0 }}</div>
                    <div class="text-xs text-yellow-600">Progress: {{ forum.action_progress || 0 }}</div>
                    <div class="text-xs text-gray-500">Belum: {{ forum.action_belum_mulai || 0 }}</div>
                  </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <span :class="getStatusBadgeClass(forum.status)">
                    {{ getStatusLabel(forum.status) }}
                  </span>
                  <div v-if="forum.status_notulen" class="mt-1">
                    <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-gray-100 text-gray-800">
                      Notulen: {{ getNotulenLabel(forum.status_notulen) }}
                    </span>
                  </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                  <div class="flex gap-2">
                    <button
                      @click="openDetailModal(forum)"
                      class="text-blue-600 hover:text-blue-900"
                      title="Detail"
                    >
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                      </svg>
                    </button>
                    <button
                      @click="openFormModal(forum)"
                      class="text-green-600 hover:text-green-900"
                      title="Edit"
                    >
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                      </svg>
                    </button>
                    <button
                      @click="confirmDelete(forum)"
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
        
        <div v-if="filteredForums.length === 0" class="text-center py-12">
          <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
          <h3 class="mt-2 text-sm font-medium text-gray-900">Belum ada data forum</h3>
          <p class="mt-1 text-sm text-gray-500">Mulai dengan menambahkan forum baru.</p>
        </div>
      </div>

      <!-- Detail Modal -->
      <div v-if="showDetailModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
        <div class="bg-white rounded-lg shadow-xl max-w-6xl w-full max-h-[90vh] overflow-hidden">
          <!-- Modal Header -->
          <div class="bg-gradient-to-r from-blue-600 to-blue-700 text-white px-6 py-4 flex justify-between items-center">
            <div>
              <h2 class="text-xl font-bold">Detail Safety Forum</h2>
              <p class="text-sm text-blue-100 mt-1">{{ selectedForum?.nomor_forum }}</p>
            </div>
            <button @click="closeDetailModal" class="text-white hover:text-gray-200">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>

          <!-- Modal Body -->
          <div class="p-6 overflow-y-auto max-h-[calc(90vh-80px)]">
            <div v-if="selectedForum" class="space-y-6">
              <!-- Informasi Dasar -->
              <div class="bg-gray-50 rounded-lg p-4">
                <h3 class="font-bold text-lg mb-3 text-gray-800">Informasi Dasar</h3>
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <label class="text-sm font-medium text-gray-600">Tanggal Forum</label>
                    <p class="text-gray-900">{{ formatDate(selectedForum.tanggal_forum) }}</p>
                  </div>
                  <div>
                    <label class="text-sm font-medium text-gray-600">Waktu</label>
                    <p class="text-gray-900">{{ selectedForum.waktu_mulai }} - {{ selectedForum.waktu_selesai || '-' }}</p>
                  </div>
                  <div>
                    <label class="text-sm font-medium text-gray-600">Lokasi</label>
                    <p class="text-gray-900">{{ selectedForum.lokasi }}</p>
                  </div>
                  <div>
                    <label class="text-sm font-medium text-gray-600">Unit</label>
                    <p class="text-gray-900">{{ selectedForum.unit?.nama || '-' }}</p>
                  </div>
                  <div>
                    <label class="text-sm font-medium text-gray-600">Jenis Forum</label>
                    <p><span :class="getJenisForumBadgeClass(selectedForum.jenis_forum)">{{ selectedForum.jenis_forum }}</span></p>
                  </div>
                  <div>
                    <label class="text-sm font-medium text-gray-600">Kategori</label>
                    <p class="text-gray-900">{{ selectedForum.kategori_forum || '-' }}</p>
                  </div>
                  <div>
                    <label class="text-sm font-medium text-gray-600">Periode</label>
                    <p class="text-gray-900">{{ selectedForum.periode || '-' }}</p>
                  </div>
                  <div>
                    <label class="text-sm font-medium text-gray-600">Tingkat Urgensi</label>
                    <p><span :class="getUrgensiClass(selectedForum.tingkat_urgensi)">{{ selectedForum.tingkat_urgensi }}</span></p>
                  </div>
                </div>
              </div>

              <!-- Agenda -->
              <div class="bg-white border rounded-lg p-4">
                <h3 class="font-bold text-lg mb-3 text-gray-800">Agenda</h3>
                <div class="space-y-3">
                  <div>
                    <label class="text-sm font-medium text-gray-600">Agenda Utama</label>
                    <p class="text-gray-900 text-lg">{{ selectedForum.agenda_utama }}</p>
                  </div>
                  <div v-if="selectedForum.latar_belakang">
                    <label class="text-sm font-medium text-gray-600">Latar Belakang</label>
                    <p class="text-gray-900 whitespace-pre-wrap">{{ selectedForum.latar_belakang }}</p>
                  </div>
                  <div v-if="selectedForum.tujuan_forum">
                    <label class="text-sm font-medium text-gray-600">Tujuan Forum</label>
                    <p class="text-gray-900 whitespace-pre-wrap">{{ selectedForum.tujuan_forum }}</p>
                  </div>
                </div>
              </div>

              <!-- Topik Pembahasan -->
              <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
                <h3 class="font-bold text-lg mb-3 text-gray-800">Topik Pembahasan</h3>
                <div class="grid grid-cols-2 gap-4">
                  <div v-if="selectedForum.topik_bahaya?.length">
                    <label class="text-sm font-medium text-gray-600">Topik Bahaya</label>
                    <ul class="list-disc list-inside text-gray-900 space-y-1">
                      <li v-for="(topik, i) in selectedForum.topik_bahaya" :key="i">{{ topik }}</li>
                    </ul>
                  </div>
                  <div v-if="selectedForum.topik_kecelakaan?.length">
                    <label class="text-sm font-medium text-gray-600">Topik Kecelakaan</label>
                    <ul class="list-disc list-inside text-gray-900 space-y-1">
                      <li v-for="(topik, i) in selectedForum.topik_kecelakaan" :key="i">{{ topik }}</li>
                    </ul>
                  </div>
                  <div v-if="selectedForum.topik_incident?.length">
                    <label class="text-sm font-medium text-gray-600">Topik Incident</label>
                    <ul class="list-disc list-inside text-gray-900 space-y-1">
                      <li v-for="(topik, i) in selectedForum.topik_incident" :key="i">{{ topik }}</li>
                    </ul>
                  </div>
                  <div v-if="selectedForum.topik_observasi?.length">
                    <label class="text-sm font-medium text-gray-600">Topik Observasi</label>
                    <ul class="list-disc list-inside text-gray-900 space-y-1">
                      <li v-for="(topik, i) in selectedForum.topik_observasi" :key="i">{{ topik }}</li>
                    </ul>
                  </div>
                </div>
              </div>

              <!-- Hasil Pembahasan -->
              <div v-if="selectedForum.ringkasan_pembahasan" class="bg-blue-50 border border-blue-200 rounded-lg p-4">
                <h3 class="font-bold text-lg mb-3 text-gray-800">Hasil Pembahasan</h3>
                <p class="text-gray-900 whitespace-pre-wrap">{{ selectedForum.ringkasan_pembahasan }}</p>
              </div>

              <!-- Masalah Teridentifikasi -->
              <div v-if="selectedForum.masalah_teridentifikasi?.length" class="bg-red-50 border border-red-200 rounded-lg p-4">
                <h3 class="font-bold text-lg mb-3 text-gray-800">Masalah Teridentifikasi</h3>
                <ul class="list-disc list-inside text-gray-900 space-y-1">
                  <li v-for="(masalah, i) in selectedForum.masalah_teridentifikasi" :key="i">{{ masalah }}</li>
                </ul>
              </div>

              <!-- Rekomendasi -->
              <div v-if="selectedForum.rekomendasi?.length" class="bg-green-50 border border-green-200 rounded-lg p-4">
                <h3 class="font-bold text-lg mb-3 text-gray-800">Rekomendasi</h3>
                <ul class="list-disc list-inside text-gray-900 space-y-1">
                  <li v-for="(rek, i) in selectedForum.rekomendasi" :key="i">{{ rek }}</li>
                </ul>
              </div>

              <!-- Action Items -->
              <div v-if="selectedForum.action_items?.length" class="bg-purple-50 border border-purple-200 rounded-lg p-4">
                <h3 class="font-bold text-lg mb-3 text-gray-800">Action Items</h3>
                <div class="overflow-x-auto">
                  <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                      <tr>
                        <th class="px-4 py-2 text-left text-xs font-medium text-gray-500">No</th>
                        <th class="px-4 py-2 text-left text-xs font-medium text-gray-500">Tindakan</th>
                        <th class="px-4 py-2 text-left text-xs font-medium text-gray-500">PIC</th>
                        <th class="px-4 py-2 text-left text-xs font-medium text-gray-500">Target</th>
                        <th class="px-4 py-2 text-left text-xs font-medium text-gray-500">Prioritas</th>
                        <th class="px-4 py-2 text-left text-xs font-medium text-gray-500">Status</th>
                      </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                      <tr v-for="item in selectedForum.action_items" :key="item.no">
                        <td class="px-4 py-2 text-sm text-gray-900">{{ item.no }}</td>
                        <td class="px-4 py-2 text-sm text-gray-900">{{ item.tindakan }}</td>
                        <td class="px-4 py-2 text-sm text-gray-900">{{ item.pic }}</td>
                        <td class="px-4 py-2 text-sm text-gray-900">{{ item.target }}</td>
                        <td class="px-4 py-2 text-sm">
                          <span :class="getPrioritasClass(item.prioritas)">{{ item.prioritas }}</span>
                        </td>
                        <td class="px-4 py-2 text-sm">
                          <span :class="getActionStatusClass(item.status)">{{ getActionStatusLabel(item.status) }}</span>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>

              <!-- Peserta -->
              <div class="bg-gray-50 rounded-lg p-4">
                <h3 class="font-bold text-lg mb-3 text-gray-800">Informasi Peserta</h3>
                <div class="grid grid-cols-3 gap-4">
                  <div class="text-center">
                    <div class="text-3xl font-bold text-blue-600">{{ selectedForum.jumlah_peserta || 0 }}</div>
                    <div class="text-sm text-gray-600">Total Hadir</div>
                  </div>
                  <div class="text-center">
                    <div class="text-3xl font-bold text-gray-600">{{ selectedForum.peserta_wajib?.length || 0 }}</div>
                    <div class="text-sm text-gray-600">Wajib Hadir</div>
                  </div>
                  <div class="text-center">
                    <div class="text-3xl font-bold text-red-600">{{ selectedForum.peserta_tidak_hadir?.length || 0 }}</div>
                    <div class="text-sm text-gray-600">Tidak Hadir</div>
                  </div>
                </div>
              </div>

              <!-- Status -->
              <div class="bg-gray-50 rounded-lg p-4">
                <h3 class="font-bold text-lg mb-3 text-gray-800">Status</h3>
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <label class="text-sm font-medium text-gray-600">Status Forum</label>
                    <p><span :class="getStatusBadgeClass(selectedForum.status)">{{ getStatusLabel(selectedForum.status) }}</span></p>
                  </div>
                  <div>
                    <label class="text-sm font-medium text-gray-600">Status Notulen</label>
                    <p><span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">{{ getNotulenLabel(selectedForum.status_notulen) }}</span></p>
                  </div>
                </div>
              </div>

              <!-- Dokumentasi -->
              <div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
                <h3 class="font-bold text-lg mb-3 text-gray-800">Dokumentasi</h3>
                
                <!-- Notulen PDF -->
                <div v-if="selectedForum.notulen_file_url" class="mb-3">
                  <label class="text-sm font-medium text-gray-600 block mb-2">File Notulen</label>
                  <a 
                    :href="selectedForum.notulen_file_url" 
                    target="_blank"
                    class="inline-flex items-center px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700"
                  >
                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                    </svg>
                    Lihat Notulen (PDF)
                  </a>
                </div>

                <!-- Daftar Hadir -->
                <div v-if="selectedForum.daftar_hadir_url" class="mb-3">
                  <label class="text-sm font-medium text-gray-600 block mb-2">Daftar Hadir</label>
                  <a 
                    :href="selectedForum.daftar_hadir_url" 
                    target="_blank"
                    class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
                  >
                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                    </svg>
                    Lihat Daftar Hadir
                  </a>
                </div>

                <!-- Foto Forum -->
                <div v-if="selectedForum.foto_forum?.length > 0">
                  <label class="text-sm font-medium text-gray-600 block mb-2">Foto Forum ({{ selectedForum.foto_forum.length }})</label>
                  <div class="grid grid-cols-4 gap-2">
                    <div
                      v-for="(foto, idx) in selectedForum.foto_forum"
                      :key="idx"
                      class="relative group cursor-pointer"
                      @click="openPhotoViewer(selectedForum.foto_forum, idx)"
                    >
                      <img
                        :src="foto"
                        :alt="`Foto ${idx + 1}`"
                        class="w-full h-24 object-cover rounded-lg border-2 border-gray-200 hover:border-blue-500 transition-colors"
                      />
                      <div class="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-30 transition-opacity rounded-lg flex items-center justify-center">
                        <svg class="w-8 h-8 text-white opacity-0 group-hover:opacity-100 transition-opacity" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0zM10 7v3m0 0v3m0-3h3m-3 0H7" />
                        </svg>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Dokumen Pendukung -->
                <div v-if="selectedForum.dokumen_pendukung?.length > 0" class="mt-4">
                  <label class="text-sm font-medium text-gray-600 block mb-2">Dokumen Pendukung ({{ selectedForum.dokumen_pendukung.length }})</label>
                  <div class="space-y-2">
                    <div
                      v-for="(dokumen, idx) in selectedForum.dokumen_pendukung"
                      :key="idx"
                      class="flex items-center p-3 bg-gray-50 rounded-lg border border-gray-200 hover:bg-gray-100 transition-colors"
                    >
                      <svg class="w-8 h-8 text-blue-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                      </svg>
                      <div class="flex-1">
                        <p class="text-sm font-medium text-gray-900">{{ getFileName(dokumen) }}</p>
                        <p class="text-xs text-gray-500">{{ getFileExtension(dokumen) }}</p>
                      </div>
                      <a
                        :href="dokumen"
                        target="_blank"
                        class="text-blue-600 hover:text-blue-800 text-sm font-medium"
                      >
                        Download
                      </a>
                    </div>
                  </div>
                </div>

                <!-- Notulen & Daftar Hadir -->
                <div v-if="selectedForum.notulen_file_url || selectedForum.daftar_hadir_url" class="mt-4 grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div v-if="selectedForum.notulen_file_url" class="flex items-center p-3 bg-green-50 rounded-lg border border-green-200">
                    <svg class="w-8 h-8 text-green-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                    </svg>
                    <div class="flex-1">
                      <p class="text-sm font-medium text-gray-900">Notulen Rapat</p>
                      <p class="text-xs text-gray-500">{{ getFileName(selectedForum.notulen_file_url) }}</p>
                    </div>
                    <a
                      :href="selectedForum.notulen_file_url"
                      target="_blank"
                      class="text-green-600 hover:text-green-800 text-sm font-medium"
                    >
                      Download
                    </a>
                  </div>

                  <div v-if="selectedForum.daftar_hadir_url" class="flex items-center p-3 bg-purple-50 rounded-lg border border-purple-200">
                    <svg class="w-8 h-8 text-purple-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                    </svg>
                    <div class="flex-1">
                      <p class="text-sm font-medium text-gray-900">Daftar Hadir</p>
                      <p class="text-xs text-gray-500">{{ getFileName(selectedForum.daftar_hadir_url) }}</p>
                    </div>
                    <a
                      :href="selectedForum.daftar_hadir_url"
                      target="_blank"
                      class="text-purple-600 hover:text-purple-800 text-sm font-medium"
                    >
                      Download
                    </a>
                  </div>
                </div>

                <p v-if="!selectedForum.notulen_file_url && !selectedForum.daftar_hadir_url && (!selectedForum.foto_forum || selectedForum.foto_forum.length === 0) && (!selectedForum.dokumen_pendukung || selectedForum.dokumen_pendukung.length === 0)" class="text-sm text-gray-500 text-center py-4">
                  Belum ada dokumentasi
                </p>
              </div>
            </div>
          </div>

          <!-- Modal Footer -->
          <div class="bg-gray-50 px-6 py-4 flex justify-end gap-3">
            <button
              @click="closeDetailModal"
              class="px-4 py-2 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300"
            >
              Tutup
            </button>
            <button
              @click="openFormModal(selectedForum)"
              class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
            >
              Edit Forum
            </button>
          </div>
        </div>
      </div>

      <!-- Photo Viewer Modal -->
      <div v-if="showPhotoViewer" class="fixed inset-0 bg-black bg-opacity-90 flex items-center justify-center z-[60]" @click="closePhotoViewer">
        <button @click="closePhotoViewer" class="absolute top-4 right-4 text-white hover:text-gray-300 z-10">
          <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>

        <!-- Previous Button -->
        <button 
          v-if="photoViewerPhotos.length > 1"
          @click.stop="previousPhoto" 
          class="absolute left-4 text-white hover:text-gray-300"
        >
          <svg class="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
          </svg>
        </button>

        <!-- Photo -->
        <div class="max-w-5xl max-h-[90vh] p-4" @click.stop>
          <img 
            :src="photoViewerPhotos[currentPhotoIndex]" 
            :alt="`Foto ${currentPhotoIndex + 1}`"
            class="max-w-full max-h-[85vh] object-contain rounded-lg"
          />
          <div class="text-center text-white mt-4">
            <p class="text-lg">{{ currentPhotoIndex + 1 }} / {{ photoViewerPhotos.length }}</p>
          </div>
        </div>

        <!-- Next Button -->
        <button 
          v-if="photoViewerPhotos.length > 1"
          @click.stop="nextPhoto" 
          class="absolute right-4 text-white hover:text-gray-300"
        >
          <svg class="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </button>
      </div>

      <!-- Form Modal -->
      <div v-if="showFormModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
        <div class="bg-white rounded-lg shadow-xl max-w-7xl w-full max-h-[90vh] overflow-hidden">
          <!-- Modal Header -->
          <div class="bg-gradient-to-r from-green-600 to-green-700 text-white px-6 py-4 flex justify-between items-center">
            <div>
              <h2 class="text-xl font-bold">{{ formData.id ? 'Edit Safety Forum' : 'Tambah Safety Forum Baru' }}</h2>
              <p class="text-sm text-green-100 mt-1">{{ formData.nomor_forum || 'Nomor akan digenerate otomatis' }}</p>
            </div>
            <button @click="closeFormModal" class="text-white hover:text-gray-200">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>

          <!-- Modal Body with Tabs -->
          <div class="flex h-[calc(90vh-140px)]">
            <!-- Sidebar Tabs -->
            <div class="w-56 bg-gray-50 border-r overflow-y-auto">
              <div class="p-4 space-y-1">
                <button
                  v-for="tab in formTabs"
                  :key="tab.id"
                  @click="activeFormTab = tab.id"
                  :class="[
                    'w-full text-left px-4 py-2 rounded-lg text-sm font-medium transition-colors',
                    activeFormTab === tab.id
                      ? 'bg-green-600 text-white'
                      : 'text-gray-700 hover:bg-gray-200'
                  ]"
                >
                  {{ tab.label }}
                </button>
              </div>
            </div>

            <!-- Tab Content -->
            <div class="flex-1 overflow-y-auto p-6">
              <!-- Tab 1: Data Dasar -->
              <div v-show="activeFormTab === 'dasar'" class="space-y-4">
                <h3 class="text-lg font-bold text-gray-800 mb-4">Data Dasar Forum</h3>
                
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Tanggal Forum <span class="text-red-500">*</span></label>
                    <input v-model="formData.tanggal_forum" type="date" required class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Unit <span class="text-red-500">*</span></label>
                    <select v-model="formData.unit_id" required class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500">
                      <option value="">Pilih Unit</option>
                      <option v-for="unit in units" :key="unit.id" :value="unit.id">{{ unit.nama }}</option>
                    </select>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Waktu Mulai <span class="text-red-500">*</span></label>
                    <input v-model="formData.waktu_mulai" type="time" required class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Waktu Selesai</label>
                    <input v-model="formData.waktu_selesai" type="time" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Lokasi <span class="text-red-500">*</span></label>
                    <input v-model="formData.lokasi" type="text" required class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="Ruang Meeting A" />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Jenis Forum <span class="text-red-500">*</span></label>
                    <select v-model="formData.jenis_forum" required class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500">
                      <option value="">Pilih Jenis</option>
                      <option value="rutin">Rutin</option>
                      <option value="bulanan">Bulanan</option>
                      <option value="mingguan">Mingguan</option>
                      <option value="tahunan">Tahunan</option>
                      <option value="insidental">Insidental</option>
                      <option value="darurat">Darurat</option>
                    </select>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Kategori Forum</label>
                    <input v-model="formData.kategori_forum" type="text" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="P2K3, Toolbox Meeting, dll" />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Periode</label>
                    <input v-model="formData.periode" type="text" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="November 2024" />
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Tingkat Urgensi <span class="text-red-500">*</span></label>
                    <select v-model="formData.tingkat_urgensi" required class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500">
                      <option value="normal">Normal</option>
                      <option value="rendah">Rendah</option>
                      <option value="tinggi">Tinggi</option>
                      <option value="kritis">Kritis</option>
                    </select>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                    <select v-model="formData.status" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500">
                      <option value="draft">Draft</option>
                      <option value="scheduled">Terjadwal</option>
                      <option value="in_progress">Berlangsung</option>
                      <option value="completed">Selesai</option>
                      <option value="cancelled">Dibatalkan</option>
                      <option value="rescheduled">Dijadwalkan Ulang</option>
                    </select>
                  </div>
                </div>
              </div>

              <!-- Tab 2: Agenda -->
              <div v-show="activeFormTab === 'agenda'" class="space-y-4">
                <h3 class="text-lg font-bold text-gray-800 mb-4">Agenda Forum</h3>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Agenda Utama <span class="text-red-500">*</span></label>
                  <input v-model="formData.agenda_utama" type="text" required class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="Evaluasi K3 Bulan November" />
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Latar Belakang</label>
                  <textarea v-model="formData.latar_belakang" rows="4" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="Jelaskan latar belakang diadakannya forum ini"></textarea>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Tujuan Forum</label>
                  <textarea v-model="formData.tujuan_forum" rows="4" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="Jelaskan tujuan yang ingin dicapai"></textarea>
                </div>
              </div>

              <!-- Tab 3: Peserta -->
              <div v-show="activeFormTab === 'peserta'" class="space-y-4">
                <h3 class="text-lg font-bold text-gray-800 mb-4">Data Peserta</h3>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Ketua Forum</label>
                  <input v-model="formData.ketua_forum" type="text" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="Nama Ketua Forum" />
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Notulen Dibuat Oleh</label>
                  <input v-model="formData.notulen_by" type="text" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="Nama Notulis" />
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Jumlah Peserta Hadir</label>
                  <input v-model.number="formData.jumlah_peserta" type="number" min="0" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="0" />
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Peserta Wajib (pisahkan dengan koma)</label>
                  <textarea v-model="pesertaWajibText" rows="3" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="Nama 1, Nama 2, Nama 3"></textarea>
                  <p class="text-xs text-gray-500 mt-1">Contoh: John Doe, Jane Smith, Ahmad</p>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Peserta Hadir (pisahkan dengan koma)</label>
                  <textarea v-model="pesertaHadirText" rows="3" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="Nama 1, Nama 2, Nama 3"></textarea>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Peserta Tidak Hadir (pisahkan dengan koma)</label>
                  <textarea v-model="pesertaTidakHadirText" rows="3" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="Nama 1, Nama 2"></textarea>
                </div>
              </div>

              <!-- Tab 4: Topik Pembahasan -->
              <div v-show="activeFormTab === 'topik'" class="space-y-4">
                <h3 class="text-lg font-bold text-gray-800 mb-4">Topik Pembahasan</h3>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Topik Bahaya (pisahkan dengan enter)</label>
                  <textarea v-model="topikBahayaText" rows="4" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="Bahaya 1&#10;Bahaya 2"></textarea>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Topik Kecelakaan (pisahkan dengan enter)</label>
                  <textarea v-model="topikKecelakaanText" rows="4" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="Kecelakaan 1&#10;Kecelakaan 2"></textarea>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Topik Incident (pisahkan dengan enter)</label>
                  <textarea v-model="topikIncidentText" rows="4" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="Incident 1&#10;Incident 2"></textarea>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Topik Observasi (pisahkan dengan enter)</label>
                  <textarea v-model="topikObservasiText" rows="4" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="Observasi 1&#10;Observasi 2"></textarea>
                </div>
              </div>

              <!-- Tab 5: Hasil -->
              <div v-show="activeFormTab === 'hasil'" class="space-y-4">
                <h3 class="text-lg font-bold text-gray-800 mb-4">Hasil Pembahasan</h3>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Ringkasan Pembahasan</label>
                  <textarea v-model="formData.ringkasan_pembahasan" rows="6" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="Tuliskan ringkasan hasil pembahasan forum"></textarea>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Masalah Teridentifikasi (pisahkan dengan enter)</label>
                  <textarea v-model="masalahText" rows="5" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="Masalah 1&#10;Masalah 2"></textarea>
                </div>
              </div>

              <!-- Tab 6: Keputusan -->
              <div v-show="activeFormTab === 'keputusan'" class="space-y-4">
                <h3 class="text-lg font-bold text-gray-800 mb-4">Keputusan & Rekomendasi</h3>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Keputusan</label>
                  <textarea v-model="formData.keputusan" rows="4" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="Tuliskan keputusan yang diambil"></textarea>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Rekomendasi (pisahkan dengan enter)</label>
                  <textarea v-model="rekomendasiText" rows="5" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="Rekomendasi 1&#10;Rekomendasi 2"></textarea>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">SOP Baru (pisahkan dengan enter)</label>
                  <textarea v-model="sopBaruText" rows="3" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="SOP 1&#10;SOP 2"></textarea>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">APD yang Diperlukan (pisahkan dengan enter)</label>
                  <textarea v-model="apdText" rows="3" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="Helm&#10;Sarung tangan"></textarea>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Training yang Diperlukan (pisahkan dengan enter)</label>
                  <textarea v-model="trainingText" rows="3" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500" placeholder="Training 1&#10;Training 2"></textarea>
                </div>
              </div>

              <!-- Tab 7: Action Items -->
              <div v-show="activeFormTab === 'action'" class="space-y-4">
                <h3 class="text-lg font-bold text-gray-800 mb-4">Tindak Lanjut (Action Items)</h3>
                
                <button @click="addActionItem" type="button" class="mb-4 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700">
                  + Tambah Action Item
                </button>
                
                <div v-for="(item, idx) in actionItems" :key="idx" class="border rounded-lg p-4 bg-gray-50 relative">
                  <button @click="removeActionItem(idx)" type="button" class="absolute top-2 right-2 text-red-600 hover:text-red-800">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                  
                  <div class="grid grid-cols-2 gap-3">
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">No</label>
                      <input v-model.number="item.no" type="number" class="w-full px-3 py-2 border rounded-lg" />
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">PIC</label>
                      <input v-model="item.pic" type="text" class="w-full px-3 py-2 border rounded-lg" />
                    </div>
                    <div class="col-span-2">
                      <label class="block text-sm font-medium text-gray-700 mb-1">Tindakan</label>
                      <textarea v-model="item.tindakan" rows="2" class="w-full px-3 py-2 border rounded-lg"></textarea>
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">Target</label>
                      <input v-model="item.target" type="date" class="w-full px-3 py-2 border rounded-lg" />
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">Prioritas</label>
                      <select v-model="item.prioritas" class="w-full px-3 py-2 border rounded-lg">
                        <option value="rendah">Rendah</option>
                        <option value="sedang">Sedang</option>
                        <option value="tinggi">Tinggi</option>
                        <option value="kritis">Kritis</option>
                      </select>
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                      <select v-model="item.status" class="w-full px-3 py-2 border rounded-lg">
                        <option value="belum_mulai">Belum Mulai</option>
                        <option value="in_progress">Progress</option>
                        <option value="selesai">Selesai</option>
                        <option value="tertunda">Tertunda</option>
                      </select>
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-gray-700 mb-1">Catatan</label>
                      <input v-model="item.catatan" type="text" class="w-full px-3 py-2 border rounded-lg" />
                    </div>
                  </div>
                </div>
                
                <div v-if="actionItems.length === 0" class="text-center py-8 text-gray-500">
                  Belum ada action item. Klik tombol "Tambah Action Item" untuk menambahkan.
                </div>
              </div>

              <!-- Tab 8: Dokumentasi -->
              <div v-show="activeFormTab === 'dokumentasi'" class="space-y-4">
                <h3 class="text-lg font-bold text-gray-800 mb-4">Dokumentasi</h3>
                
                <!-- Upload Notulen -->
                <div class="border-2 border-dashed border-gray-300 rounded-lg p-4 bg-gray-50">
                  <label class="block text-sm font-medium text-gray-700 mb-2">File Notulen (PDF)</label>
                  <input 
                    @change="handleNotulenUpload" 
                    type="file" 
                    accept=".pdf"
                    ref="notulenFileInput"
                    class="hidden" 
                  />
                  <div v-if="!formData.notulen_file_url" class="text-center">
                    <button 
                      @click="notulenFileInput?.click()" 
                      type="button"
                      class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
                    >
                      <svg class="w-5 h-5 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
                      </svg>
                      Upload File Notulen
                    </button>
                    <p class="text-xs text-gray-500 mt-2">Format: PDF, Max 5MB</p>
                  </div>
                  <div v-else class="flex items-center justify-between bg-white p-3 rounded-lg">
                    <div class="flex items-center">
                      <svg class="w-8 h-8 text-red-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                      </svg>
                      <div>
                        <p class="text-sm font-medium text-gray-900">Notulen.pdf</p>
                        <p class="text-xs text-gray-500">File terupload</p>
                      </div>
                    </div>
                    <button 
                      @click="removeNotulenFile" 
                      type="button"
                      class="text-red-600 hover:text-red-800"
                    >
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                      </svg>
                    </button>
                  </div>
                </div>

                <!-- Upload Daftar Hadir -->
                <div class="border-2 border-dashed border-gray-300 rounded-lg p-4 bg-gray-50">
                  <label class="block text-sm font-medium text-gray-700 mb-2">File Daftar Hadir</label>
                  <input 
                    @change="handleDaftarHadirUpload" 
                    type="file" 
                    accept="image/*"
                    capture="environment"
                    ref="daftarHadirCameraInput"
                    class="hidden" 
                  />
                  <input 
                    @change="handleDaftarHadirUpload" 
                    type="file" 
                    accept=".pdf,image/*"
                    ref="daftarHadirFileInput"
                    class="hidden" 
                  />
                  <div v-if="!formData.daftar_hadir_url" class="text-center">
                    <div class="grid grid-cols-2 gap-3 mb-2">
                      <button 
                        @click="daftarHadirCameraInput?.click()" 
                        type="button"
                        class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 flex items-center justify-center gap-2"
                      >
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                        </svg>
                        Ambil Foto
                      </button>
                      <button 
                        @click="daftarHadirFileInput?.click()" 
                        type="button"
                        class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 flex items-center justify-center gap-2"
                      >
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                        </svg>
                        Pilih File/PDF
                      </button>
                    </div>
                    <p class="text-xs text-gray-500">Format: PDF atau Foto (otomatis dikompress jika >1MB)</p>
                  </div>
                  <div v-else class="flex items-center justify-between bg-white p-3 rounded-lg">
                    <div class="flex items-center">
                      <svg class="w-8 h-8 text-blue-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                      </svg>
                      <div>
                        <p class="text-sm font-medium text-gray-900">Daftar Hadir</p>
                        <p class="text-xs text-gray-500">File terupload</p>
                      </div>
                    </div>
                    <button 
                      @click="removeDaftarHadirFile" 
                      type="button"
                      class="text-red-600 hover:text-red-800"
                    >
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                      </svg>
                    </button>
                  </div>
                </div>

                <!-- Upload Foto Forum -->
                <div class="border-2 border-dashed border-gray-300 rounded-lg p-4 bg-gray-50">
                  <label class="block text-sm font-medium text-gray-700 mb-2">Foto Forum (Multiple)</label>
                  <input 
                    @change="handleFotoForumUpload" 
                    type="file" 
                    accept="image/*"
                    capture="environment"
                    ref="fotoForumCameraInput"
                    class="hidden" 
                  />
                  <input 
                    @change="handleFotoForumUpload" 
                    type="file" 
                    accept="image/*"
                    multiple
                    ref="fotoForumFileInput"
                    class="hidden" 
                  />
                  <div class="text-center mb-3">
                    <div class="grid grid-cols-2 gap-3 mb-2">
                      <button 
                        @click="fotoForumCameraInput?.click()" 
                        type="button"
                        class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 flex items-center justify-center gap-2"
                      >
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                        </svg>
                        Ambil Foto
                      </button>
                      <button 
                        @click="fotoForumFileInput?.click()" 
                        type="button"
                        class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 flex items-center justify-center gap-2"
                      >
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                        </svg>
                        Pilih dari Galeri
                      </button>
                    </div>
                    <p class="text-xs text-gray-500 mb-3">Foto otomatis dikompress jika >1MB</p>
                    <button 
                      @click="fotoForumFileInput?.click()" 
                      type="button"
                      class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
                    >
                      <svg class="w-5 h-5 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                      </svg>
                      Upload Foto
                    </button>
                    <p class="text-xs text-gray-500 mt-2">Format: JPG, PNG, Max 2MB per foto</p>
                  </div>
                  
                  <!-- Preview Foto -->
                  <div v-if="uploadedPhotos.length > 0" class="grid grid-cols-3 gap-3">
                    <div v-for="(photo, idx) in uploadedPhotos" :key="idx" class="relative group">
                      <img :src="photo.preview" class="w-full h-24 object-cover rounded-lg" />
                      <button 
                        @click="removePhoto(idx)" 
                        type="button"
                        class="absolute top-1 right-1 bg-red-600 text-white rounded-full p-1 opacity-0 group-hover:opacity-100 transition-opacity"
                      >
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                      </button>
                    </div>
                  </div>
                  <p v-if="uploadedPhotos.length === 0" class="text-sm text-gray-500 text-center py-4">
                    Belum ada foto terupload
                  </p>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Status Notulen</label>
                  <select v-model="formData.status_notulen" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-green-500">
                    <option value="belum_dibuat">Belum Dibuat</option>
                    <option value="draft">Draft</option>
                    <option value="review">Review</option>
                    <option value="approved">Approved</option>
                    <option value="rejected">Ditolak</option>
                  </select>
                </div>
              </div>
            </div>
          </div>

          <!-- Modal Footer -->
          <div class="bg-gray-50 px-6 py-4 flex justify-between items-center border-t">
            <div class="text-sm text-gray-600">
              Tab {{ formTabs.findIndex(t => t.id === activeFormTab) + 1 }} dari {{ formTabs.length }}
            </div>
            <div class="flex gap-3">
              <button
                @click="closeFormModal"
                type="button"
                class="px-4 py-2 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300"
              >
                Batal
              </button>
              <button
                @click="saveForm"
                type="button"
                :disabled="saving"
                class="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 disabled:bg-gray-400"
              >
                {{ saving ? 'Menyimpan...' : (formData.id ? 'Update' : 'Simpan') }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useImageCompression } from '@/composables/useImageCompression'
import { safetyForumService, type SafetyForumDTO } from '@/services/api/safety-forum.service'
import { unitsService } from '@/services/api/units.service'
import { supabase } from '@/services/api/supabase'

const { compressSingleImage, formatFileSize } = useImageCompression()

const forums = ref<any[]>([])
const units = ref<any[]>([])
const loading = ref(false)
const showDetailModal = ref(false)
const selectedForum = ref<any>(null)
const showFormModal = ref(false)
const saving = ref(false)
const activeFormTab = ref('dasar')

const formTabs = [
  { id: 'dasar', label: '1. Data Dasar' },
  { id: 'agenda', label: '2. Agenda' },
  { id: 'peserta', label: '3. Peserta' },
  { id: 'topik', label: '4. Topik' },
  { id: 'hasil', label: '5. Hasil' },
  { id: 'keputusan', label: '6. Keputusan' },
  { id: 'action', label: '7. Action Items' },
  { id: 'dokumentasi', label: '8. Dokumentasi' }
]

const formData = ref<any>({
  tanggal_forum: '',
  waktu_mulai: '',
  waktu_selesai: '',
  unit_id: '',
  lokasi: '',
  jenis_forum: '',
  kategori_forum: '',
  periode: '',
  tingkat_urgensi: 'normal',
  status: 'draft',
  agenda_utama: '',
  latar_belakang: '',
  tujuan_forum: '',
  ketua_forum: '',
  notulen_by: '',
  jumlah_peserta: 0,
  ringkasan_pembahasan: '',
  keputusan: '',
  notulen_file_url: '',
  daftar_hadir_url: '',
  status_notulen: 'belum_dibuat'
})

const actionItems = ref<any[]>([])
const pesertaWajibText = ref('')
const pesertaHadirText = ref('')
const pesertaTidakHadirText = ref('')
const topikBahayaText = ref('')
const topikKecelakaanText = ref('')
const topikIncidentText = ref('')
const topikObservasiText = ref('')
const masalahText = ref('')
const rekomendasiText = ref('')
const sopBaruText = ref('')
const apdText = ref('')
const trainingText = ref('')
const fotoForumText = ref('')

// File upload refs
const notulenFileInput = ref<HTMLInputElement>()
const daftarHadirFileInput = ref<HTMLInputElement>()
const daftarHadirCameraInput = ref<HTMLInputElement>()
const fotoForumFileInput = ref<HTMLInputElement>()
const fotoForumCameraInput = ref<HTMLInputElement>()
const uploadedPhotos = ref<Array<{ file: File; preview: string; url?: string }>>([])
const uploadingFiles = ref(false)

// Photo viewer state
const showPhotoViewer = ref(false)
const photoViewerPhotos = ref<string[]>([])
const currentPhotoIndex = ref(0)

const filters = ref({
  search: '',
  unit_id: '',
  jenis: '',
  status: '',
  month: ''
})

// Computed: filtered forums
const filteredForums = computed(() => {
  let result = forums.value

  if (filters.value.search) {
    const search = filters.value.search.toLowerCase()
    result = result.filter(f => 
      f.nomor_forum?.toLowerCase().includes(search) ||
      f.agenda_utama?.toLowerCase().includes(search) ||
      f.lokasi?.toLowerCase().includes(search)
    )
  }

  if (filters.value.unit_id) {
    result = result.filter(f => f.unit_id === filters.value.unit_id)
  }

  if (filters.value.jenis) {
    result = result.filter(f => f.jenis_forum === filters.value.jenis)
  }

  if (filters.value.status) {
    result = result.filter(f => f.status === filters.value.status)
  }

  if (filters.value.month) {
    const [year, month] = filters.value.month.split('-')
    if (year && month) {
      result = result.filter(f => {
        const forumDate = new Date(f.tanggal_forum)
        return forumDate.getFullYear() === parseInt(year) && 
               (forumDate.getMonth() + 1) === parseInt(month)
      })
    }
  }

  return result
})

// Load data
const loadForums = async () => {
  try {
    loading.value = true
    const data = await safetyForumService.getAll()
    forums.value = data || []
  } catch (error) {
    console.error('Error loading forums:', error)
    alert('Gagal memuat data forum')
  } finally {
    loading.value = false
  }
}

const loadUnits = async () => {
  try {
    console.log('Loading units...')
    const data = await unitsService.getAll()
    console.log('Units loaded:', data?.length || 0, 'units')
    console.log('First unit sample:', data?.[0])
    units.value = data || []
    console.log('Units assigned to ref:', units.value.length, 'units')
  } catch (error) {
    console.error('Error loading units:', error)
    // Fallback: try simple query
    try {
      console.log('Trying fallback units query...')
      const { data: fallbackData } = await supabase
        .from('units')
        .select('id, nama, kode')
        .eq('aktif', true)
        .order('nama')
      units.value = (fallbackData || []).map(u => ({
        id: u.id,
        nama: u.nama,
        kode: u.kode
      }))
      console.log('Fallback units loaded:', units.value.length, 'units')
    } catch (fallbackError) {
      console.error('Fallback also failed:', fallbackError)
    }
  }
}

// Format helpers
const formatDate = (dateStr: string) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return date.toLocaleDateString('id-ID', { 
    weekday: 'short',
    year: 'numeric', 
    month: 'short', 
    day: 'numeric' 
  })
}

const getStatusLabel = (status: string) => {
  const labels: Record<string, string> = {
    draft: 'Draft',
    scheduled: 'Terjadwal',
    in_progress: 'Berlangsung',
    completed: 'Selesai',
    cancelled: 'Dibatalkan',
    rescheduled: 'Dijadwalkan Ulang'
  }
  return labels[status] || status
}

const getNotulenLabel = (status: string) => {
  const labels: Record<string, string> = {
    belum_dibuat: 'Belum',
    draft: 'Draft',
    review: 'Review',
    approved: 'Approved',
    rejected: 'Ditolak'
  }
  return labels[status] || status
}

const getStatusBadgeClass = (status: string) => {
  const classes: Record<string, string> = {
    draft: 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800',
    scheduled: 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800',
    in_progress: 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800',
    completed: 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800',
    cancelled: 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800',
    rescheduled: 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-purple-100 text-purple-800'
  }
  return classes[status] || classes.draft
}

const getJenisForumBadgeClass = (jenis: string) => {
  const classes: Record<string, string> = {
    rutin: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-800',
    bulanan: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-green-100 text-green-800',
    mingguan: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-purple-100 text-purple-800',
    tahunan: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-indigo-100 text-indigo-800',
    insidental: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-yellow-100 text-yellow-800',
    darurat: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-red-100 text-red-800'
  }
  return classes[jenis] || classes.rutin
}

const getUrgensiClass = (urgensi: string) => {
  const classes: Record<string, string> = {
    rendah: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-gray-100 text-gray-700',
    normal: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-700',
    tinggi: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-orange-100 text-orange-700',
    kritis: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-red-100 text-red-700'
  }
  return classes[urgensi] || classes.normal
}

const getPrioritasClass = (prioritas: string) => {
  const classes: Record<string, string> = {
    rendah: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-gray-100 text-gray-700',
    sedang: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-700',
    tinggi: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-orange-100 text-orange-700',
    kritis: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-red-100 text-red-700'
  }
  return classes[prioritas] || classes.sedang
}

const getActionStatusClass = (status: string) => {
  const classes: Record<string, string> = {
    belum_mulai: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-gray-100 text-gray-700',
    in_progress: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-yellow-100 text-yellow-700',
    selesai: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-green-100 text-green-700',
    tertunda: 'inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-red-100 text-red-700'
  }
  return classes[status] || classes.belum_mulai
}

const getActionStatusLabel = (status: string) => {
  const labels: Record<string, string> = {
    belum_mulai: 'Belum Mulai',
    in_progress: 'Progress',
    selesai: 'Selesai',
    tertunda: 'Tertunda'
  }
  return labels[status] || status
}

// Modal handlers
const openFormModal = (forum?: any) => {
  if (forum) {
    // Edit mode - populate form with existing data
    formData.value = { ...forum }
    actionItems.value = forum.action_items ? [...forum.action_items] : []
    
    // Convert arrays to text for textarea fields
    pesertaWajibText.value = forum.peserta_wajib?.join(', ') || ''
    pesertaHadirText.value = forum.peserta_hadir?.join(', ') || ''
    pesertaTidakHadirText.value = forum.peserta_tidak_hadir?.join(', ') || ''
    topikBahayaText.value = forum.topik_bahaya?.join('\n') || ''
    topikKecelakaanText.value = forum.topik_kecelakaan?.join('\n') || ''
    topikIncidentText.value = forum.topik_incident?.join('\n') || ''
    topikObservasiText.value = forum.topik_observasi?.join('\n') || ''
    masalahText.value = forum.masalah_teridentifikasi?.join('\n') || ''
    rekomendasiText.value = forum.rekomendasi?.join('\n') || ''
    sopBaruText.value = forum.sop_baru?.join('\n') || ''
    apdText.value = forum.apd_yang_diperlukan?.join('\n') || ''
    trainingText.value = forum.training_yang_diperlukan?.join('\n') || ''
    
    // Load existing photos
    uploadedPhotos.value = []
    if (forum.foto_forum && Array.isArray(forum.foto_forum)) {
      forum.foto_forum.forEach((url: string) => {
        uploadedPhotos.value.push({
          file: null as any,
          preview: url,
          url: url
        })
      })
    }
  } else {
    // Create mode - reset form
    resetForm()
  }
  
  activeFormTab.value = 'dasar'
  showFormModal.value = true
}

const closeFormModal = () => {
  showFormModal.value = false
  resetForm()
}

// File upload handlers
const handleNotulenUpload = async (event: Event) => {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  if (!file) return

  if (file.size > 5 * 1024 * 1024) {
    alert('File terlalu besar. Maksimal 5MB')
    return
  }

  if (!file.type.includes('pdf')) {
    alert('Hanya file PDF yang diperbolehkan')
    return
  }

  try {
    uploadingFiles.value = true
    const url = await safetyForumService.uploadDocument(file, 'notulen')
    formData.value.notulen_file_url = url
    alert('File notulen berhasil diupload')
  } catch (error) {
    console.error('Error uploading notulen:', error)
    alert('Gagal upload file notulen')
  } finally {
    uploadingFiles.value = false
  }
}

const removeNotulenFile = () => {
  formData.value.notulen_file_url = ''
  if (notulenFileInput.value) {
    notulenFileInput.value.value = ''
  }
}

const handleDaftarHadirUpload = async (event: Event) => {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  if (!file) return

  try {
    uploadingFiles.value = true
    
    let fileToUpload = file
    
    // Compress if image
    if (file.type.startsWith('image/')) {
      const result = await compressSingleImage(file)
      fileToUpload = result.file
      console.log(`Daftar Hadir compression: ${formatFileSize(result.originalSize)} → ${formatFileSize(result.compressedSize)} (${result.compressionRatio})`)
    }
    
    const url = await safetyForumService.uploadDocument(fileToUpload, 'daftar_hadir')
    formData.value.daftar_hadir_url = url
    alert('File daftar hadir berhasil diupload')
  } catch (error) {
    console.error('Error uploading daftar hadir:', error)
    alert('Gagal upload file daftar hadir')
  } finally {
    uploadingFiles.value = false
  }
}

const removeDaftarHadirFile = () => {
  formData.value.daftar_hadir_url = ''
  if (daftarHadirFileInput.value) {
    daftarHadirFileInput.value.value = ''
  }
}

const handleFotoForumUpload = async (event: Event) => {
  const target = event.target as HTMLInputElement
  const files = target.files
  if (!files || files.length === 0) return

  for (const file of Array.from(files)) {
    if (!file.type.startsWith('image/')) {
      alert(`File ${file.name} bukan gambar`)
      continue
    }

    // Compress image
    const result = await compressSingleImage(file)
    console.log(`Foto forum compression: ${formatFileSize(result.originalSize)} → ${formatFileSize(result.compressedSize)} (${result.compressionRatio})`)
    
    // Create preview
    const preview = URL.createObjectURL(result.file)
    uploadedPhotos.value.push({ file: result.file, preview })
  }

  // Reset input
  if (fotoForumFileInput.value) {
    fotoForumFileInput.value.value = ''
  }
}

const removePhoto = (index: number) => {
  const photo = uploadedPhotos.value[index]
  if (photo?.preview) {
    URL.revokeObjectURL(photo.preview)
  }
  uploadedPhotos.value.splice(index, 1)
}

const resetForm = () => {
  formData.value = {
    tanggal_forum: '',
    waktu_mulai: '',
    waktu_selesai: '',
    unit_id: '',
    lokasi: '',
    jenis_forum: '',
    kategori_forum: '',
    periode: '',
    tingkat_urgensi: 'normal',
    status: 'draft',
    agenda_utama: '',
    latar_belakang: '',
    tujuan_forum: '',
    ketua_forum: '',
    notulen_by: '',
    jumlah_peserta: 0,
    ringkasan_pembahasan: '',
    keputusan: '',
    notulen_file_url: '',
    daftar_hadir_url: '',
    status_notulen: 'belum_dibuat'
  }
  actionItems.value = []
  pesertaWajibText.value = ''
  pesertaHadirText.value = ''
  pesertaTidakHadirText.value = ''
  topikBahayaText.value = ''
  topikKecelakaanText.value = ''
  topikIncidentText.value = ''
  topikObservasiText.value = ''
  masalahText.value = ''
  rekomendasiText.value = ''
  sopBaruText.value = ''
  apdText.value = ''
  trainingText.value = ''
  fotoForumText.value = ''
  
  // Clean up photo previews
  uploadedPhotos.value.forEach(photo => {
    if (photo.preview && !photo.url) {
      URL.revokeObjectURL(photo.preview)
    }
  })
  uploadedPhotos.value = []
}

const addActionItem = () => {
  actionItems.value.push({
    no: actionItems.value.length + 1,
    tindakan: '',
    pic: '',
    target: '',
    prioritas: 'sedang',
    status: 'belum_mulai',
    catatan: ''
  })
}

const removeActionItem = (index: number) => {
  actionItems.value.splice(index, 1)
  // Renumber items
  actionItems.value.forEach((item, idx) => {
    item.no = idx + 1
  })
}

const saveForm = async () => {
  // Validate required fields
  if (!formData.value.tanggal_forum || !formData.value.waktu_mulai || 
      !formData.value.unit_id || !formData.value.lokasi || 
      !formData.value.jenis_forum || !formData.value.agenda_utama) {
    alert('Mohon lengkapi field yang wajib diisi (bertanda *)')
    return
  }

  // Validate unit_id is a valid UUID format
  const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i
  if (!uuidRegex.test(formData.value.unit_id)) {
    console.error('Invalid unit_id:', formData.value.unit_id)
    alert('Unit tidak valid. Mohon pilih unit dari dropdown yang tersedia.')
    return
  }

  saving.value = true
  
  try {
    // Upload photos first if any
    const photoUrls: string[] = []
    if (uploadedPhotos.value.length > 0) {
      const tempForumId = formData.value.id || `temp_${Date.now()}`
      for (const photo of uploadedPhotos.value) {
        if (!photo.url) {
          // New photo, need to upload
          try {
            const url = await safetyForumService.uploadPhoto(photo.file, tempForumId)
            photoUrls.push(url)
          } catch (error) {
            console.error('Error uploading photo:', error)
          }
        } else {
          // Existing photo
          photoUrls.push(photo.url)
        }
      }
    }

    // Convert text fields to arrays
    const dataToSave: any = {
      ...formData.value,
      peserta_wajib: pesertaWajibText.value ? pesertaWajibText.value.split(',').map(s => s.trim()).filter(Boolean) : [],
      peserta_hadir: pesertaHadirText.value ? pesertaHadirText.value.split(',').map(s => s.trim()).filter(Boolean) : [],
      peserta_tidak_hadir: pesertaTidakHadirText.value ? pesertaTidakHadirText.value.split(',').map(s => s.trim()).filter(Boolean) : [],
      topik_bahaya: topikBahayaText.value ? topikBahayaText.value.split('\n').map(s => s.trim()).filter(Boolean) : [],
      topik_kecelakaan: topikKecelakaanText.value ? topikKecelakaanText.value.split('\n').map(s => s.trim()).filter(Boolean) : [],
      topik_incident: topikIncidentText.value ? topikIncidentText.value.split('\n').map(s => s.trim()).filter(Boolean) : [],
      topik_observasi: topikObservasiText.value ? topikObservasiText.value.split('\n').map(s => s.trim()).filter(Boolean) : [],
      masalah_teridentifikasi: masalahText.value ? masalahText.value.split('\n').map(s => s.trim()).filter(Boolean) : [],
      rekomendasi: rekomendasiText.value ? rekomendasiText.value.split('\n').map(s => s.trim()).filter(Boolean) : [],
      sop_baru: sopBaruText.value ? sopBaruText.value.split('\n').map(s => s.trim()).filter(Boolean) : [],
      apd_yang_diperlukan: apdText.value ? apdText.value.split('\n').map(s => s.trim()).filter(Boolean) : [],
      training_yang_diperlukan: trainingText.value ? trainingText.value.split('\n').map(s => s.trim()).filter(Boolean) : [],
      foto_forum: photoUrls,
      action_items: actionItems.value.length > 0 ? actionItems.value : []
    }

    // Remove nested object 'unit' that comes from join - only keep unit_id
    delete dataToSave.unit

    if (formData.value.id) {
      // Update existing
      await safetyForumService.update(formData.value.id, dataToSave)
      alert('Forum berhasil diupdate')
    } else {
      // Create new
      await safetyForumService.create(dataToSave)
      alert('Forum berhasil ditambahkan')
    }

    closeFormModal()
    await loadForums()
  } catch (error: any) {
    console.error('Error saving forum:', error)
    alert('Gagal menyimpan forum: ' + (error.message || 'Unknown error'))
  } finally {
    saving.value = false
  }
}

const openDetailModal = (forum: any) => {
  selectedForum.value = forum
  showDetailModal.value = true
}

const closeDetailModal = () => {
  showDetailModal.value = false
  selectedForum.value = null
}

// Photo viewer functions
const openPhotoViewer = (photos: string[], startIndex: number) => {
  photoViewerPhotos.value = photos
  currentPhotoIndex.value = startIndex
  showPhotoViewer.value = true
}

const closePhotoViewer = () => {
  showPhotoViewer.value = false
  photoViewerPhotos.value = []
  currentPhotoIndex.value = 0
}

// Helper functions for file display
const getFileName = (url: string) => {
  if (!url) return 'Unknown File'
  try {
    const urlObj = new URL(url)
    const pathname = urlObj.pathname
    const filename = pathname.substring(pathname.lastIndexOf('/') + 1)
    return decodeURIComponent(filename)
  } catch {
    return url.split('/').pop() || 'Unknown File'
  }
}

const getFileExtension = (url: string) => {
  if (!url) return ''
  const filename = getFileName(url)
  const ext = filename.split('.').pop()?.toUpperCase()
  return ext ? `${ext} File` : 'File'
}

const previousPhoto = () => {
  if (currentPhotoIndex.value > 0) {
    currentPhotoIndex.value--
  } else {
    currentPhotoIndex.value = photoViewerPhotos.value.length - 1
  }
}

const nextPhoto = () => {
  if (currentPhotoIndex.value < photoViewerPhotos.value.length - 1) {
    currentPhotoIndex.value++
  } else {
    currentPhotoIndex.value = 0
  }
}

const confirmDelete = async (forum: any) => {
  if (!confirm(`Yakin ingin menghapus forum ${forum.nomor_forum}?`)) return
  
  try {
    await safetyForumService.delete(forum.id)
    alert('Forum berhasil dihapus')
    await loadForums()
  } catch (error) {
    console.error('Error deleting forum:', error)
    alert('Gagal menghapus forum')
  }
}

// Lifecycle
onMounted(() => {
  loadForums()
  loadUnits()
})
</script>
