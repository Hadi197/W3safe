<template>
  <div class="space-y-6">
    <!-- Page Header with Welcome Message -->
    <div class="bg-gradient-to-r from-primary-600 to-primary-800 rounded-2xl shadow-xl p-4 md:p-6 lg:p-8 text-white">
      <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between">
        <div class="mb-4 lg:mb-0">
          <h1 class="text-2xl md:text-3xl lg:text-4xl font-bold mb-2">Selamat Datang di W3Safe! 👋</h1>
          <p class="text-primary-100 text-sm md:text-base lg:text-lg">{{ currentGreeting }}, mari pantau implementasi keselamatan kerja hari ini</p>
        </div>
        <div class="block lg:hidden self-start">
          <div class="bg-white/10 backdrop-blur-sm rounded-xl p-3 text-center">
            <p class="text-xs text-primary-100">Tanggal</p>
            <p class="text-lg md:text-xl font-bold">{{ currentDate }}</p>
          </div>
        </div>
        <div class="hidden lg:block">
          <div class="bg-white/10 backdrop-blur-sm rounded-xl p-4 text-center">
            <p class="text-sm text-primary-100">Tanggal</p>
            <p class="text-2xl font-bold">{{ currentDate }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Statistics Cards with Gradients -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 md:gap-6">
      <!-- Safety Briefing Card -->
      <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-2xl shadow-lg p-4 md:p-6 text-white hover:shadow-xl transition-all duration-300">
        <div class="flex items-center justify-between">
          <div class="flex-1 min-w-0">
            <p class="text-blue-100 text-xs md:text-sm font-medium truncate">Safety Briefing</p>
            <p class="text-2xl md:text-3xl font-bold mt-1 md:mt-2">{{ stats.safetyBriefing }}</p>
            <p class="text-blue-100 text-xs mt-1">Total Bulan Ini</p>
          </div>
          <div class="bg-white/20 rounded-full p-2 md:p-3 ml-3 flex-shrink-0">
            <svg class="w-6 h-6 md:w-8 md:h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
          </div>
        </div>
      </div>

      <!-- Silent Inspection Card -->
      <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-2xl shadow-lg p-4 md:p-6 text-white hover:shadow-xl transition-all duration-300">
        <div class="flex items-center justify-between">
          <div class="flex-1 min-w-0">
            <p class="text-purple-100 text-xs md:text-sm font-medium truncate">Silent Inspection</p>
            <p class="text-2xl md:text-3xl font-bold mt-1 md:mt-2">{{ stats.silentInspection }}</p>
            <p class="text-purple-100 text-xs mt-1">Total Triwulan Ini</p>
          </div>
          <div class="bg-white/20 rounded-full p-2 md:p-3 ml-3 flex-shrink-0">
            <svg class="w-6 h-6 md:w-8 md:h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </div>
        </div>
      </div>

      <!-- Safety Patrol Card -->
      <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-2xl shadow-lg p-4 md:p-6 text-white hover:shadow-xl transition-all duration-300">
        <div class="flex items-center justify-between">
          <div class="flex-1 min-w-0">
            <p class="text-green-100 text-xs md:text-sm font-medium truncate">Safety Patrol</p>
            <p class="text-2xl md:text-3xl font-bold mt-1 md:mt-2">{{ stats.safetyPatrol }}</p>
            <p class="text-green-100 text-xs mt-1">Total Bulan Ini</p>
          </div>
          <div class="bg-white/20 rounded-full p-2 md:p-3 ml-3 flex-shrink-0">
            <svg class="w-6 h-6 md:w-8 md:h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
            </svg>
          </div>
        </div>
      </div>

      <!-- Safety Forum Card -->
      <div class="bg-gradient-to-br from-orange-500 to-orange-600 rounded-2xl shadow-lg p-4 md:p-6 text-white hover:shadow-xl transition-all duration-300">
        <div class="flex items-center justify-between">
          <div class="flex-1 min-w-0">
            <p class="text-orange-100 text-xs md:text-sm font-medium truncate">Safety Forum</p>
            <p class="text-2xl md:text-3xl font-bold mt-1 md:mt-2">{{ stats.safetyForum }}</p>
            <p class="text-orange-100 text-xs mt-1">Total Bulan Ini</p>
          </div>
          <div class="bg-white/20 rounded-full p-2 md:p-3 ml-3 flex-shrink-0">
            <svg class="w-6 h-6 md:w-8 md:h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8h2a2 2 0 012 2v6a2 2 0 01-2 2h-2v4l-4-4H9a1.994 1.994 0 01-1.414-.586m0 0L11 14h4a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2v4l.586-.586z" />
            </svg>
          </div>
        </div>
      </div>

      <!-- Management Walkthrough Card -->
      <div class="bg-gradient-to-br from-teal-500 to-teal-600 rounded-2xl shadow-lg p-4 md:p-6 text-white hover:shadow-xl transition-all duration-300">
        <div class="flex items-center justify-between">
          <div class="flex-1 min-w-0">
            <p class="text-teal-100 text-xs md:text-sm font-medium truncate">Management Walkthrough</p>
            <p class="text-2xl md:text-3xl font-bold mt-1 md:mt-2">{{ stats.managementWalkthrough }}</p>
            <p class="text-teal-100 text-xs mt-1">Total Bulan Ini</p>
          </div>
          <div class="bg-white/20 rounded-full p-2 md:p-3 ml-3 flex-shrink-0">
            <svg class="w-6 h-6 md:w-8 md:h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
            </svg>
          </div>
        </div>
      </div>

      <!-- Safety Induction Card -->
      <div class="bg-gradient-to-br from-indigo-500 to-indigo-600 rounded-2xl shadow-lg p-4 md:p-6 text-white hover:shadow-xl transition-all duration-300">
        <div class="flex items-center justify-between">
          <div class="flex-1 min-w-0">
            <p class="text-indigo-100 text-xs md:text-sm font-medium truncate">Safety Induction</p>
            <p class="text-2xl md:text-3xl font-bold mt-1 md:mt-2">{{ stats.safetyInduction }}</p>
            <p class="text-indigo-100 text-xs mt-1">Total Bulan Ini</p>
          </div>
          <div class="bg-white/20 rounded-full p-2 md:p-3 ml-3 flex-shrink-0">
            <svg class="w-6 h-6 md:w-8 md:h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
            </svg>
          </div>
        </div>
      </div>

      <!-- Safety Drill Card -->
      <div class="bg-gradient-to-br from-red-500 to-red-600 rounded-2xl shadow-lg p-4 md:p-6 text-white hover:shadow-xl transition-all duration-300">
        <div class="flex items-center justify-between">
          <div class="flex-1 min-w-0">
            <p class="text-red-100 text-xs md:text-sm font-medium truncate">Safety Drill</p>
            <p class="text-2xl md:text-3xl font-bold mt-1 md:mt-2">{{ stats.safetyDrill }}</p>
            <p class="text-red-100 text-xs mt-1">Total Bulan Ini</p>
          </div>
          <div class="bg-white/20 rounded-full p-2 md:p-3 ml-3 flex-shrink-0">
            <svg class="w-6 h-6 md:w-8 md:h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 18.657A8 8 0 016.343 7.343S7 9 9 10c0-2 .5-5 2.986-7C14 5 16.09 5.777 17.656 7.343A7.975 7.975 0 0120 13a7.975 7.975 0 01-2.343 5.657z" />
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.879 16.121A3 3 0 1012.015 11L11 14H9c0 .768.293 1.536.879 2.121z" />
            </svg>
          </div>
        </div>
      </div>

      <!-- Unsafe Action/Condition Card -->
      <div class="bg-gradient-to-br from-yellow-500 to-yellow-600 rounded-2xl shadow-lg p-4 md:p-6 text-white hover:shadow-xl transition-all duration-300">
        <div class="flex items-center justify-between">
          <div class="flex-1 min-w-0">
            <p class="text-yellow-100 text-xs md:text-sm font-medium truncate">Unsafe Action/Condition</p>
            <p class="text-2xl md:text-3xl font-bold mt-1 md:mt-2">{{ stats.unsafeActionCondition }}</p>
            <p class="text-yellow-100 text-xs mt-1">Total Bulan Ini</p>
          </div>
          <div class="bg-white/20 rounded-full p-2 md:p-3 ml-3 flex-shrink-0">
            <svg class="w-6 h-6 md:w-8 md:h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z" />
            </svg>
          </div>
        </div>
      </div>
    </div>

    <!-- Charts Section -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-4 md:gap-6">
      <!-- Trend Chart - Takes 2 columns -->
      <div class="lg:col-span-2 bg-white rounded-2xl shadow-lg p-4 md:p-6 hover:shadow-xl transition-shadow duration-300">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between mb-4 md:mb-6">
          <h3 class="text-lg md:text-xl font-bold text-gray-900 mb-2 sm:mb-0">📈 Trend Aktivitas Keselamatan</h3>
          <select class="px-3 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-primary-500 focus:border-transparent w-full sm:w-auto">
            <option>6 Bulan Terakhir</option>
            <option>3 Bulan Terakhir</option>
            <option>1 Tahun</option>
          </select>
        </div>
        <div class="h-64 md:h-80">
          <Line :data="trendChartData" :options="trendChartOptions" />
        </div>
      </div>

      <!-- Pie Chart - Takes 1 column -->
      <div class="bg-white rounded-2xl shadow-lg p-4 md:p-6 hover:shadow-xl transition-shadow duration-300">
        <h3 class="text-lg md:text-xl font-bold text-gray-900 mb-4 md:mb-6">🎯 Temuan by Kategori</h3>
        <div class="h-64 md:h-80 flex items-center justify-center">
          <Doughnut :data="categoryChartData" :options="categoryChartOptions" />
        </div>
      </div>
    </div>

    <!-- Recent Activities -->
    <div class="bg-white rounded-2xl shadow-lg p-4 md:p-6 hover:shadow-xl transition-shadow duration-300">
      <h3 class="text-lg md:text-xl font-bold text-gray-900 mb-4 md:mb-6">🕒 Aktivitas Terbaru</h3>
      <div class="space-y-3 md:space-y-4">
        <div
          v-for="activity in recentActivities"
          :key="activity.id"
          class="flex items-start space-x-3 md:space-x-4 p-3 md:p-4 rounded-xl hover:bg-gray-50 transition-colors duration-200 cursor-pointer border border-gray-100"
        >
          <div :class="`flex-shrink-0 w-10 h-10 md:w-12 md:h-12 rounded-full flex items-center justify-center ${activity.color}`">
            <span class="text-lg md:text-xl">{{ activity.icon }}</span>
          </div>
          <div class="flex-1 min-w-0">
            <p class="text-sm font-medium text-gray-900">{{ activity.title }}</p>
            <p class="text-xs md:text-sm text-gray-500 mt-1">{{ activity.description }}</p>
            <p class="text-xs text-gray-400 mt-1">{{ activity.time }}</p>
          </div>
          <span :class="`px-2 py-1 md:px-3 md:py-1 rounded-full text-xs font-medium ${activity.badgeColor}`">
            {{ activity.status }}
          </span>
        </div>
      </div>
    </div>

    <!-- Monthly Table Modal -->
    <div v-if="showMonthlyTableModal" @click.stop="showMonthlyTableModal = false" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-2 md:p-4">
      <div @click.stop class="bg-white rounded-lg shadow-2xl w-full max-w-[98vw] md:max-w-[95vw] h-[95vh] md:h-[90vh] flex flex-col">
        <!-- Modal Header -->
        <div class="px-4 md:px-6 py-3 md:py-4 border-b border-gray-200 bg-gradient-to-r from-blue-600 to-blue-700 text-white rounded-t-lg">
          <div class="flex items-center justify-between mb-2 md:mb-3">
            <div>
              <h2 class="text-lg md:text-2xl font-bold">{{ selectedModuleName }}</h2>
              <p class="text-blue-100 text-xs md:text-sm mt-1">Data Aktivitas Bulanan per Unit</p>
            </div>
            <button
              @click.stop="showMonthlyTableModal = false"
              class="text-white hover:bg-white/20 rounded-lg p-2 transition-colors"
            >
              <svg class="w-5 h-5 md:w-6 md:h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          <!-- Month Filter -->
          <div class="flex flex-col sm:flex-row sm:items-center gap-2 md:gap-3">
            <label class="text-white text-xs md:text-sm font-medium">Filter Bulan:</label>
            <input
              v-model="selectedMonth"
              @change="selectedModule === 'safety_briefing' ? loadSafetyBriefingData() : loadMonthlyData()"
              type="month"
              class="px-3 py-2 rounded-lg text-gray-900 text-sm focus:ring-2 focus:ring-white flex-1 sm:flex-none"
            />
            <span class="text-blue-100 text-xs md:text-sm">
              <span v-if="selectedModule === 'safety_briefing'">
                Total: {{ safetyBriefingData.length }} Safety Briefing
              </span>
              <span v-else>
                Total: {{ calculateTotalInputs() }} input data
              </span>
            </span>
          </div>
        </div>

        <!-- Modal Content -->
        <div class="flex-1 overflow-auto p-4 md:p-6">
          <!-- Safety Briefing Detailed Table -->
          <div v-if="selectedModule === 'safety_briefing'" class="overflow-x-auto">
            <div v-if="safetyBriefingData.length === 0" class="text-center py-12">
              <svg class="w-16 h-16 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
              <h3 class="text-lg font-medium text-gray-900 mb-2">Tidak ada data Safety Briefing</h3>
              <p class="text-gray-500">Belum ada Safety Briefing yang tercatat untuk bulan ini.</p>
            </div>
            <table v-else class="min-w-full border-collapse">
              <thead class="sticky top-0 z-10">
                <tr>
                  <th class="px-4 py-3 bg-gray-100 border border-gray-300 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                    Tanggal
                  </th>
                  <th class="px-4 py-3 bg-gray-100 border border-gray-300 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                    Topik
                  </th>
                  <th class="px-4 py-3 bg-gray-100 border border-gray-300 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                    Instruktur
                  </th>
                  <th class="px-4 py-3 bg-gray-100 border border-gray-300 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                    Unit
                  </th>
                  <th class="px-4 py-3 bg-gray-100 border border-gray-300 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider">
                    Peserta
                  </th>
                  <th class="px-4 py-3 bg-gray-100 border border-gray-300 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider">
                    Status
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="briefing in safetyBriefingData" :key="briefing.id" class="hover:bg-gray-50">
                  <td class="px-4 py-3 border border-gray-300 text-sm text-gray-900">
                    <div class="font-medium">{{ formatDate(briefing.tanggal) }}</div>
                    <div class="text-xs text-gray-500">{{ briefing.waktu_mulai }} - {{ briefing.waktu_selesai || '-' }}</div>
                  </td>
                  <td class="px-4 py-3 border border-gray-300 text-sm text-gray-900">
                    <div class="font-medium">{{ briefing.topik || '-' }}</div>
                    <div v-if="briefing.materi" class="text-xs text-gray-500 mt-1">{{ briefing.materi }}</div>
                  </td>
                  <td class="px-4 py-3 border border-gray-300 text-sm text-gray-900">
                    {{ briefing.petugas?.nama_lengkap || '-' }}
                  </td>
                  <td class="px-4 py-3 border border-gray-300 text-sm text-gray-900">
                    {{ briefing.unit?.nama || '-' }}
                  </td>
                  <td class="px-4 py-3 border border-gray-300 text-center text-sm text-gray-900">
                    {{ briefing.jumlah_peserta || 0 }}
                  </td>
                  <td class="px-4 py-3 border border-gray-300 text-center">
                    <span :class="getStatusBadgeClass(briefing.status)">
                      {{ getStatusLabel(briefing.status) }}
                    </span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          
          <!-- Other Modules Calendar Table -->
          <div v-else class="overflow-x-auto">
            <table class="min-w-full border-collapse">
              <thead class="sticky top-0 z-10">
                <tr>
                  <th class="px-4 py-3 bg-gray-100 border border-gray-300 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider sticky left-0 z-20">
                    Unit
                  </th>
                  <th 
                    v-for="day in daysInMonth" 
                    :key="day"
                    class="px-3 py-3 bg-gray-100 border border-gray-300 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider min-w-[50px]"
                  >
                    {{ day }}
                  </th>
                  <th class="px-4 py-3 bg-blue-100 border border-gray-300 text-center text-xs font-semibold text-blue-700 uppercase tracking-wider sticky right-0 z-20">
                    Total
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="unitData in monthlyData" :key="unitData.unit_id" class="hover:bg-gray-50">
                  <td class="px-4 py-3 border border-gray-300 text-sm font-medium text-gray-900 sticky left-0 bg-white z-10">
                    {{ unitData.unit_name }}
                  </td>
                  <td 
                    v-for="day in daysInMonth" 
                    :key="day"
                    class="px-3 py-3 border border-gray-300 text-center"
                    :class="hasData(unitData, day) ? 'bg-green-100' : 'bg-white'"
                  >
                    <svg v-if="hasData(unitData, day)" class="w-6 h-6 text-green-700 mx-auto drop-shadow-md" fill="currentColor" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7" />
                    </svg>
                    <svg v-else class="w-5 h-5 text-gray-300 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </td>
                  <td class="px-4 py-3 border border-gray-300 text-center text-sm font-bold text-blue-700 bg-blue-50 sticky right-0 z-10">
                    {{ countInputs(unitData) }}/31
                  </td>
                </tr>
                <!-- Total Row -->
                <tr class="bg-gray-50 font-semibold">
                  <td class="px-4 py-3 border border-gray-300 text-sm text-gray-900 sticky left-0 bg-gray-100 z-10">
                    Total Unit Input
                  </td>
                  <td 
                    v-for="day in daysInMonth" 
                    :key="day"
                    class="px-3 py-3 border border-gray-300 text-center text-sm text-gray-700 bg-gray-100"
                  >
                    {{ countUnitsWithDataOnDay(day) }}/{{ monthlyData.length }}
                  </td>
                  <td class="px-4 py-3 border border-gray-300 text-center text-sm font-bold text-blue-700 bg-blue-100 sticky right-0 z-10">
                    {{ calculateTotalInputs() }}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Modal Footer -->
        <div class="px-4 md:px-6 py-3 md:py-4 border-t border-gray-200 bg-gray-50 rounded-b-lg flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
          <div class="flex flex-col sm:flex-row sm:items-center gap-3 md:gap-6 text-xs md:text-sm">
            <!-- Safety Briefing Footer -->
            <div v-if="selectedModule === 'safety_briefing'" class="flex items-center gap-4">
              <div class="flex items-center gap-2">
                <svg class="w-4 h-4 md:w-5 md:h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
                <span class="text-gray-600">Total Safety Briefing: {{ safetyBriefingData.length }}</span>
              </div>
            </div>
            <!-- Other Modules Footer -->
            <div v-else class="flex flex-col sm:flex-row sm:items-center gap-3 md:gap-6">
              <div class="flex items-center gap-2">
                <svg class="w-4 h-4 md:w-5 md:h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                </svg>
                <span class="text-gray-600">Sudah Input Data</span>
              </div>
              <div class="flex items-center gap-2">
                <svg class="w-4 h-4 md:w-5 md:h-5 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
                <span class="text-gray-600">Belum Input Data</span>
              </div>
            </div>
          </div>
          <button
            @click="showMonthlyTableModal = false"
            class="px-4 md:px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors w-full sm:w-auto"
          >
            Tutup
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { Line, Doughnut } from 'vue-chartjs'
import { supabase } from '@/services/api/supabase'

// Define activity interface
interface Activity {
  id: string
  icon: string
  title: string
  description: string
  time: string
  status: string
  color: string
  badgeColor: string
  created_at?: Date
}
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  ArcElement,
  Title,
  Tooltip,
  Legend,
  Filler
} from 'chart.js'

// Register ChartJS components
ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  ArcElement,
  Title,
  Tooltip,
  Legend,
  Filler
)

// Stats data - Load from database
const stats = ref({
  safetyBriefing: 0,
  silentInspection: 0,
  safetyPatrol: 0,
  safetyForum: 0,
  managementWalkthrough: 0,
  safetyInduction: 0,
  safetyDrill: 0,
  unsafeActionCondition: 0,
  totalTemuan: 0
})

// Monthly table modal - Initialize with current month
const now = new Date()
const defaultMonth = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`
const selectedMonth = ref(defaultMonth)
// Monthly table modal
const showMonthlyTableModal = ref(false)
const selectedModule = ref('')
const selectedModuleName = ref('')
const units = ref<any[]>([])
const monthlyData = ref<any[]>([])
const safetyBriefingData = ref<any[]>([])

// Generate days 1-31
const daysInMonth = Array.from({ length: 31 }, (_, i) => i + 1)

const openMonthlyTable = async (module: string, moduleName: string) => {
  selectedModule.value = module
  selectedModuleName.value = moduleName
  showMonthlyTableModal.value = true
  
  // Special handling for Safety Briefing - show detailed table instead of calendar
  if (module === 'safety_briefing') {
    await loadSafetyBriefingData()
  } else {
    await loadMonthlyData()
  }
}

const loadMonthlyData = async () => {
  try {
    console.log('Dashboard: Loading units for monthly table...')
    // Load units
    const { data: unitsData } = await supabase
      .from('units')
      .select('*')
      .order('nama')

    console.log('Dashboard: Units loaded:', unitsData?.length || 0, 'units')
    console.log('Dashboard: First unit sample:', unitsData?.[0])

    units.value = unitsData || []
    console.log('Dashboard: Units assigned:', units.value.length, 'units')
    
    // Parse selected month
    const [yearStr, monthStr] = selectedMonth.value.split('-')
    const year = parseInt(yearStr!)
    const month = parseInt(monthStr!)
    
    // Calculate days in selected month
    const daysInSelectedMonth = new Date(year, month, 0).getDate()
    
    // Get first and last day of selected month
    const startDate = `${year}-${String(month).padStart(2, '0')}-01`
    const endDate = `${year}-${String(month).padStart(2, '0')}-${String(daysInSelectedMonth).padStart(2, '0')}`
    
    // Get table name and date field based on module
    let tableName = ''
    let dateField = 'created_at'
    
    switch(selectedModule.value) {
      case 'safety_briefing':
        tableName = 'safety_briefing'
        dateField = 'tanggal'
        break
      case 'safety_patrol':
        tableName = 'safety_patrol'
        dateField = 'tanggal_patrol'
        break
      case 'safety_drill':
        tableName = 'safety_drill'
        dateField = 'tanggal_drill'
        break
      case 'safety_forum':
        tableName = 'safety_forum'
        dateField = 'tanggal_forum'
        break
      case 'safety_induction':
        tableName = 'safety_induction'
        dateField = 'tanggal_induction'
        break
      case 'silent_inspection':
        tableName = 'silent_inspection'
        dateField = 'tanggal'
        break
      case 'management_walkthrough':
        tableName = 'management_walkthrough'
        dateField = 'tanggal_walkthrough'
        break
      default:
        tableName = selectedModule.value
    }
    
    // Query data for selected month
    const { data: moduleData, error: queryError } = await supabase
      .from(tableName)
      .select(`unit_id, ${dateField}`)
      .gte(dateField, startDate)
      .lte(dateField, endDate)
    
    if (queryError) {
      console.error('Query Error:', queryError)
    }
    
    // Debug for Management Walkthrough
    if (selectedModule.value === 'management_walkthrough') {
      console.log('=== MANAGEMENT WALKTHROUGH DEBUG ===')
      console.log('Date Range:', startDate, 'to', endDate)
      console.log('Data Count:', moduleData?.length || 0)
      console.log('=====================================')
    }
    
    if (queryError) {
      console.error('Query Error:', queryError)
    }
    
    // Build checklist data
    monthlyData.value = units.value.map(unit => {
      const data: any = { unit_id: unit.id, unit_name: unit.nama }
      
      // Initialize all days as false (use actual days in month)
      for (let day = 1; day <= daysInSelectedMonth; day++) {
        data[`day_${day}`] = false
      }
      
      // Mark days that have data
      if (moduleData) {
        const unitRecords = moduleData.filter((item: any) => item.unit_id === unit.id)
        
        unitRecords.forEach((item: any) => {
            const dateValue = item[dateField]
            
            if (dateValue) {
              const date = new Date(dateValue)
              const day = date.getDate()
              
              if (day >= 1 && day <= 31) {
                data[`day_${day}`] = true
              }
            }
          })
      }
      
      return data
    })
  } catch (error) {
    console.error('Error loading monthly data:', error)
  }
}

const loadSafetyBriefingData = async () => {
  try {
    console.log('Dashboard: Loading Safety Briefing data...')
    
    // Parse selected month
    const [yearStr, monthStr] = selectedMonth.value.split('-')
    const year = parseInt(yearStr!)
    const month = parseInt(monthStr!)
    
    // Get first and last day of selected month
    const startDate = `${year}-${String(month).padStart(2, '0')}-01`
    const endDate = `${year}-${String(month).padStart(2, '0')}-${String(new Date(year, month, 0).getDate()).padStart(2, '0')}`
    
    // Query Safety Briefing data with full details (without join)
    const { data: briefingData, error: queryError } = await supabase
      .from('safety_briefing')
      .select(`
        id,
        tanggal,
        waktu_mulai,
        waktu_selesai,
        topik,
        materi,
        petugas_id,
        unit_id,
        jumlah_peserta,
        status,
        catatan,
        created_at
      `)
      .gte('tanggal', startDate)
      .lte('tanggal', endDate)
      .order('tanggal', { ascending: false })
    
    if (queryError) {
      console.error('Query Error:', queryError)
    }
    
    // Get unit and petugas data for each briefing
    let processedBriefingData = briefingData || []
    if (processedBriefingData.length > 0) {
      const unitIds = [...new Set(processedBriefingData.map(b => b.unit_id).filter(id => id))]
      const petugasIds = [...new Set(processedBriefingData.map(b => b.petugas_id).filter(id => id))]
      
      // Fetch units data
      let unitsMap = new Map()
      if (unitIds.length > 0) {
        const { data: unitsData } = await supabase
          .from('units')
          .select('id, kode, nama')
          .in('id', unitIds)
        
        unitsMap = new Map(unitsData?.map(u => [u.id, u]) || [])
      }
      
      // Fetch petugas data
      let petugasMap = new Map()
      if (petugasIds.length > 0) {
        const { data: petugasData } = await supabase
          .from('pegawai')
          .select('id, nama_lengkap')
          .in('id', petugasIds)
        
        petugasMap = new Map(petugasData?.map(p => [p.id, p]) || [])
      }
      
      processedBriefingData = processedBriefingData.map(briefing => ({
        ...briefing,
        unit: briefing.unit_id ? unitsMap.get(briefing.unit_id) : null,
        petugas: briefing.petugas_id ? petugasMap.get(briefing.petugas_id) : null
      }))
    }
    
    console.log('Dashboard: Safety Briefing data loaded:', processedBriefingData?.length || 0, 'records')
    
    // Store the detailed data for display
    safetyBriefingData.value = processedBriefingData
    
  } catch (error) {
    console.error('Error loading Safety Briefing data:', error)
  }
}

// Helper functions for checklist table
const hasData = (unitData: any, day: number) => {
  return unitData[`day_${day}`] === true || unitData[`day_${day}`] > 0
}

const countInputs = (unitData: any) => {
  return daysInMonth.filter(day => hasData(unitData, day)).length
}

const countUnitsWithDataOnDay = (day: number) => {
  return monthlyData.value.filter(unit => hasData(unit, day)).length
}

const calculateTotalInputs = () => {
  return monthlyData.value.reduce((total, unit) => {
    return total + countInputs(unit)
  }, 0)
}

const getCellValue = (unitData: any, day: number) => {
  return unitData[`day_${day}`] || 0
}

const getCellClass = (value: number) => {
  if (value === 0) return 'bg-gray-50 text-gray-400'
  if (value <= 2) return 'bg-green-100 text-green-800 font-semibold'
  if (value <= 4) return 'bg-yellow-100 text-yellow-800 font-semibold'
  return 'bg-red-100 text-red-800 font-semibold'
}

// Current date and greeting
const currentDate = computed(() => {
  const options: Intl.DateTimeFormatOptions = { 
    weekday: 'long', 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  }
  return new Date().toLocaleDateString('id-ID', options)
})

const currentGreeting = computed(() => {
  const hour = new Date().getHours()
  if (hour < 12) return 'Selamat Pagi'
  if (hour < 15) return 'Selamat Siang'
  if (hour < 18) return 'Selamat Sore'
  return 'Selamat Malam'
})

// Recent activities - Dynamic data from all modules
const recentActivities = ref<Activity[]>([])

// Load recent activities from all modules
const loadRecentActivities = async () => {
  try {
    const activities: Activity[] = []

    // Fetch from Safety Briefing with unit join
    const { data: briefingData, error: briefingError } = await supabase
      .from('safety_briefing')
      .select('id, topik, tanggal, waktu_mulai, unit_id, units!unit_id(id, nama, kode)')
      .order('created_at', { ascending: false })
      .limit(3)

    if (!briefingError && briefingData) {
      briefingData.forEach((item: any) => {
        const unitName = item.units?.nama || item.units?.kode || '-'
        activities.push({
          id: `briefing-${item.id}`,
          icon: '📝',
          title: 'Safety Briefing Selesai',
          description: `${unitName} - ${item.topik}`,
          time: formatTimeAgo(new Date(item.tanggal + ' ' + item.waktu_mulai)),
          status: 'Selesai',
          color: 'bg-blue-100',
          badgeColor: 'bg-green-100 text-green-800',
          created_at: new Date(item.tanggal + ' ' + item.waktu_mulai)
        })
      })
    }

    // Fetch from Silent Inspection with unit join
    const { data: inspectionData, error: inspectionError } = await supabase
      .from('silent_inspection')
      .select('id, area_inspeksi, tanggal, unit_id, units!unit_id(id, nama, kode)')
      .order('created_at', { ascending: false })
      .limit(3)

    if (!inspectionError && inspectionData) {
      inspectionData.forEach((item: any) => {
        const unitName = item.units?.nama || item.units?.kode || '-'
        activities.push({
          id: `inspection-${item.id}`,
          icon: '🔍',
          title: 'Silent Inspection Selesai',
          description: `${unitName} - ${item.area_inspeksi}`,
          time: formatTimeAgo(new Date(item.tanggal)),
          status: 'Selesai',
          color: 'bg-purple-100',
          badgeColor: 'bg-blue-100 text-blue-800',
          created_at: new Date(item.tanggal)
        })
      })
    }

    // Fetch from Safety Patrol with unit join
    const { data: patrolData, error: patrolError } = await supabase
      .from('safety_patrol')
      .select('id, nomor_patrol, area_patrol, tanggal_patrol, unit_id, units!unit_id(id, nama, kode)')
      .order('created_at', { ascending: false })
      .limit(3)

    if (!patrolError && patrolData) {
      patrolData.forEach((item: any) => {
        const unitName = item.units?.nama || item.units?.kode || '-'
        activities.push({
          id: `patrol-${item.id}`,
          icon: '👮',
          title: 'Safety Patrol Selesai',
          description: `${unitName} - ${item.area_patrol}`,
          time: formatTimeAgo(new Date(item.tanggal_patrol)),
          status: 'Selesai',
          color: 'bg-green-100',
          badgeColor: 'bg-green-100 text-green-800',
          created_at: new Date(item.tanggal_patrol)
        })
      })
    }

    // Fetch from Safety Forum with unit join
    const { data: forumData, error: forumError } = await supabase
      .from('safety_forum')
      .select('id, agenda_utama, tanggal_forum, created_at, unit_id, units!unit_id(id, nama, kode)')
      .order('created_at', { ascending: false })
      .limit(3)

    if (!forumError && forumData) {
      forumData.forEach((item: any) => {
        const unitName = item.units?.nama || item.units?.kode || '-'
        activities.push({
          id: `forum-${item.id}`,
          icon: '💬',
          title: 'Safety Forum Selesai',
          description: `${unitName} - ${item.agenda_utama || 'Safety Forum'}`,
          time: formatTimeAgo(new Date(item.tanggal_forum || item.created_at)),
          status: 'Selesai',
          color: 'bg-orange-100',
          badgeColor: 'bg-orange-100 text-orange-800',
          created_at: new Date(item.tanggal_forum || item.created_at)
        })
      })
    }

    // Fetch from Management Walkthrough with unit join
    const { data: walkthroughData, error: walkthroughError } = await supabase
      .from('management_walkthrough')
      .select('id, created_at, unit_id, units!unit_id(id, nama, kode)')
      .order('created_at', { ascending: false })
      .limit(3)

    if (!walkthroughError && walkthroughData) {
      walkthroughData.forEach((item: any) => {
        const unitName = item.units?.nama || item.units?.kode || '-'
        activities.push({
          id: `walkthrough-${item.id}`,
          icon: '🚶',
          title: 'Management Walkthrough Selesai',
          description: `${unitName} - Management Walkthrough`,
          time: formatTimeAgo(new Date(item.created_at)),
          status: 'Selesai',
          color: 'bg-indigo-100',
          badgeColor: 'bg-indigo-100 text-indigo-800',
          created_at: new Date(item.created_at)
        })
      })
    }

    // Fetch from Safety Induction with unit join
    const { data: inductionData, error: inductionError } = await supabase
      .from('safety_induction')
      .select('id, created_at, unit_id, units!unit_id(id, nama, kode)')
      .order('created_at', { ascending: false })
      .limit(3)

    if (!inductionError && inductionData) {
      inductionData.forEach((item: any) => {
        const unitName = item.units?.nama || item.units?.kode || '-'
        activities.push({
          id: `induction-${item.id}`,
          icon: '🎓',
          title: 'Safety Induction Selesai',
          description: `${unitName} - Safety Induction`,
          time: formatTimeAgo(new Date(item.created_at)),
          status: 'Selesai',
          color: 'bg-teal-100',
          badgeColor: 'bg-teal-100 text-teal-800',
          created_at: new Date(item.created_at)
        })
      })
    }

    // Fetch from Safety Drill with unit join
    const { data: drillData, error: drillError } = await supabase
      .from('safety_drill')
      .select('id, created_at, unit_id, units!unit_id(id, nama, kode)')
      .order('created_at', { ascending: false })
      .limit(3)

    if (!drillError && drillData) {
      drillData.forEach((item: any) => {
        const unitName = item.units?.nama || item.units?.kode || '-'
        activities.push({
          id: `drill-${item.id}`,
          icon: '🚨',
          title: 'Safety Drill Selesai',
          description: `${unitName} - Safety Drill`,
          time: formatTimeAgo(new Date(item.created_at)),
          status: 'Selesai',
          color: 'bg-red-100',
          badgeColor: 'bg-red-100 text-red-800',
          created_at: new Date(item.created_at)
        })
      })
    }

    // Fetch from Unsafe Action/Condition
    const { data: unsafeData, error: unsafeError } = await supabase
      .from('unsafe_action_condition')
      .select('id, jenis_kejadian, lokasi_kejadian, tanggal_kejadian, unit_kerja')
      .order('created_at', { ascending: false })
      .limit(3)

    if (!unsafeError && unsafeData) {
      unsafeData.forEach(item => {
        activities.push({
          id: `unsafe-${item.id}`,
          icon: '⚠️',
          title: 'Laporan Unsafe Action/Condition',
          description: `${item.unit_kerja} - ${item.lokasi_kejadian}`,
          time: formatTimeAgo(new Date(item.tanggal_kejadian)),
          status: item.jenis_kejadian === 'unsafe_action' ? 'Unsafe Action' : 'Unsafe Condition',
          color: 'bg-yellow-100',
          badgeColor: 'bg-yellow-100 text-yellow-800',
          created_at: new Date(item.tanggal_kejadian)
        })
      })
    }

    // Sort by created_at descending and take top 10
    activities.sort((a, b) => (b.created_at?.getTime() || 0) - (a.created_at?.getTime() || 0))
    recentActivities.value = activities.slice(0, 10)

  } catch (error) {
    console.error('Error loading recent activities:', error)
    // Fallback to static data if error
    recentActivities.value = [
      {
        id: 'fallback-1',
        icon: '📝',
        title: 'Safety Briefing Selesai',
        description: 'Unit Produksi A - Topik: Pencegahan Kebakaran',
        time: '5 menit yang lalu',
        status: 'Selesai',
        color: 'bg-blue-100',
        badgeColor: 'bg-green-100 text-green-800'
      },
      {
        id: 'fallback-2',
        icon: '⚠️',
        title: 'Temuan Baru - Safety Patrol',
        description: 'Area Warehouse - Kabel listrik terkelupas',
        time: '15 menit yang lalu',
        status: 'Perlu Tindakan',
        color: 'bg-red-100',
        badgeColor: 'bg-red-100 text-red-800'
      }
    ]
  }
}

// Helper function to format time ago
const formatTimeAgo = (date: Date) => {
  const now = new Date()
  const diffInMinutes = Math.floor((now.getTime() - date.getTime()) / (1000 * 60))

  if (diffInMinutes < 1) return 'Baru saja'
  if (diffInMinutes < 60) return `${diffInMinutes} menit yang lalu`

  const diffInHours = Math.floor(diffInMinutes / 60)
  if (diffInHours < 24) return `${diffInHours} jam yang lalu`

  const diffInDays = Math.floor(diffInHours / 24)
  if (diffInDays < 7) return `${diffInDays} hari yang lalu`

  return date.toLocaleDateString('id-ID')
}

// Trend data from database
const trendData = ref({
  labels: ['Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov'],
  briefing: [0, 0, 0, 0, 0, 0],
  patrol: [0, 0, 0, 0, 0, 0],
  temuan: [0, 0, 0, 0, 0, 0]
})

// Load trend data from database
const loadTrendData = async () => {
  try {
    const currentDate = new Date()
    const months = []
    const briefingCounts = []
    const patrolCounts = []
    const temuanCounts = []

    // Generate last 6 months
    for (let i = 5; i >= 0; i--) {
      const date = new Date(currentDate.getFullYear(), currentDate.getMonth() - i, 1)
      const monthName = date.toLocaleDateString('id-ID', { month: 'short' })
      months.push(monthName)

      const startOfMonth = new Date(date.getFullYear(), date.getMonth(), 1)
      const endOfMonth = new Date(date.getFullYear(), date.getMonth() + 1, 0, 23, 59, 59)

      // Query Safety Briefing count for this month
      const { count: briefingCount } = await supabase
        .from('safety_briefing')
        .select('*', { count: 'exact', head: true })
        .gte('created_at', startOfMonth.toISOString())
        .lte('created_at', endOfMonth.toISOString())

      // Query Safety Patrol count for this month
      const { count: patrolCount } = await supabase
        .from('safety_patrol')
        .select('*', { count: 'exact', head: true })
        .gte('created_at', startOfMonth.toISOString())
        .lte('created_at', endOfMonth.toISOString())

      // Query Temuan count for this month
      const { count: temuanCount } = await supabase
        .from('unsafe_action_condition')
        .select('*', { count: 'exact', head: true })
        .gte('created_at', startOfMonth.toISOString())
        .lte('created_at', endOfMonth.toISOString())

      briefingCounts.push(briefingCount || 0)
      patrolCounts.push(patrolCount || 0)
      temuanCounts.push(temuanCount || 0)
    }

    trendData.value = {
      labels: months,
      briefing: briefingCounts,
      patrol: patrolCounts,
      temuan: temuanCounts
    }
  } catch (error) {
    console.error('Error loading trend data:', error)
  }
}

// Trend Chart Data - Real data from database
const trendChartData = computed(() => ({
  labels: trendData.value.labels,
  datasets: [
    {
      label: 'Safety Briefing',
      data: trendData.value.briefing,
      borderColor: '#3B82F6',
      backgroundColor: 'rgba(59, 130, 246, 0.1)',
      fill: true,
      tension: 0.4,
      borderWidth: 3
    },
    {
      label: 'Safety Patrol',
      data: trendData.value.patrol,
      borderColor: '#10B981',
      backgroundColor: 'rgba(16, 185, 129, 0.1)',
      fill: true,
      tension: 0.4,
      borderWidth: 3
    },
    {
      label: 'Temuan',
      data: trendData.value.temuan,
      borderColor: '#EF4444',
      backgroundColor: 'rgba(239, 68, 68, 0.1)',
      fill: true,
      tension: 0.4,
      borderWidth: 3
    }
  ]
}))

const trendChartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      display: true,
      position: 'bottom' as const,
      labels: {
        usePointStyle: true,
        padding: 15,
        font: {
          size: 13,
          weight: 500
        }
      }
    },
    tooltip: {
      mode: 'index' as const,
      intersect: false,
      backgroundColor: 'rgba(0, 0, 0, 0.8)',
      padding: 12,
      cornerRadius: 8
    }
  },
  scales: {
    y: {
      beginAtZero: true,
      grid: {
        color: 'rgba(0, 0, 0, 0.05)',
        drawBorder: false
      },
      ticks: {
        font: {
          size: 12
        }
      }
    },
    x: {
      grid: {
        display: false
      },
      ticks: {
        font: {
          size: 12
        }
      }
    }
  }
}

// Category data from database
const categoryData = ref({
  unsafe_action: 0,
  unsafe_condition: 0,
  near_miss: 0,
  incident: 0
})

// Load category data from database
const loadCategoryData = async () => {
  try {
    // Query counts for each category
    const { count: unsafeActionCount } = await supabase
      .from('unsafe_action_condition')
      .select('*', { count: 'exact', head: true })
      .eq('jenis_kejadian', 'unsafe_action')

    const { count: unsafeConditionCount } = await supabase
      .from('unsafe_action_condition')
      .select('*', { count: 'exact', head: true })
      .eq('jenis_kejadian', 'unsafe_condition')

    const { count: nearMissCount } = await supabase
      .from('unsafe_action_condition')
      .select('*', { count: 'exact', head: true })
      .eq('jenis_kejadian', 'near_miss')

    const { count: incidentCount } = await supabase
      .from('unsafe_action_condition')
      .select('*', { count: 'exact', head: true })
      .eq('jenis_kejadian', 'incident')

    categoryData.value = {
      unsafe_action: unsafeActionCount || 0,
      unsafe_condition: unsafeConditionCount || 0,
      near_miss: nearMissCount || 0,
      incident: incidentCount || 0
    }
  } catch (error) {
    console.error('Error loading category data:', error)
  }
}

// Category Chart Data - Real data from database
const categoryChartData = computed(() => ({
  labels: ['Unsafe Act', 'Unsafe Condition', 'Near Miss', 'Incident'],
  datasets: [
    {
      data: [
        categoryData.value.unsafe_action,
        categoryData.value.unsafe_condition,
        categoryData.value.near_miss,
        categoryData.value.incident
      ],
      backgroundColor: [
        '#EF4444',
        '#F59E0B',
        '#3B82F6',
        '#8B5CF6'
      ],
      borderWidth: 0,
      hoverOffset: 10
    }
  ]
}))

const categoryChartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      position: 'bottom' as const,
      labels: {
        padding: 15,
        usePointStyle: true,
        font: {
          size: 13,
          weight: 500
        }
      }
    },
    tooltip: {
      backgroundColor: 'rgba(0, 0, 0, 0.8)',
      padding: 12,
      cornerRadius: 8
    }
  }
}

// Load statistics from database
const loadStats = async () => {
  try {
    console.log('Dashboard: Loading statistics...')

    // Get current month for filtering
    const now = new Date()
    const currentYear = now.getFullYear()
    const currentMonth = now.getMonth() + 1
    const startDate = `${currentYear}-${String(currentMonth).padStart(2, '0')}-01`
    const endDate = currentMonth === 12
      ? `${currentYear + 1}-01-01`
      : `${currentYear}-${String(currentMonth + 1).padStart(2, '0')}-01`

    // Get current quarter for silent inspection
    const currentQuarter = Math.ceil(currentMonth / 3)
    const quarterStartMonth = (currentQuarter - 1) * 3 + 1
    const quarterStartDate = `${currentYear}-${String(quarterStartMonth).padStart(2, '0')}-01`
    const quarterEndDate = currentQuarter === 4
      ? `${currentYear + 1}-01-01`
      : `${currentYear}-${String(quarterStartMonth + 3).padStart(2, '0')}-01`

    // Load all stats concurrently
    const [
      safetyBriefingResult,
      silentInspectionResult,
      safetyPatrolResult,
      safetyForumResult,
      managementWalkthroughResult,
      safetyInductionResult,
      safetyDrillResult,
      unsafeActionConditionResult
    ] = await Promise.all([
      // Safety Briefing - current month
      supabase
        .from('safety_briefing')
        .select('id', { count: 'exact', head: true })
        .gte('tanggal', startDate)
        .lt('tanggal', endDate),

      // Silent Inspection - current quarter
      supabase
        .from('silent_inspection')
        .select('id', { count: 'exact', head: true })
        .eq('tahun', currentYear)
        .eq('triwulan', currentQuarter),

      // Safety Patrol - current month
      supabase
        .from('safety_patrol')
        .select('id', { count: 'exact', head: true })
        .gte('tanggal_patrol', startDate)
        .lt('tanggal_patrol', endDate),

      // Safety Forum - current month
      supabase
        .from('safety_forum')
        .select('id', { count: 'exact', head: true })
        .gte('tanggal_forum', startDate)
        .lt('tanggal_forum', endDate),

      // Management Walkthrough - current month
      supabase
        .from('management_walkthrough')
        .select('id', { count: 'exact', head: true })
        .gte('created_at', startDate)
        .lt('created_at', endDate),

      // Safety Induction - current month
      supabase
        .from('safety_induction')
        .select('id', { count: 'exact', head: true })
        .gte('tanggal_induction', startDate)
        .lt('tanggal_induction', endDate),

      // Safety Drill - current month
      supabase
        .from('safety_drill')
        .select('id', { count: 'exact', head: true })
        .gte('tanggal_drill', startDate)
        .lt('tanggal_drill', endDate),

      // Unsafe Action/Condition - current month
      supabase
        .from('unsafe_action_condition')
        .select('id', { count: 'exact', head: true })
        .gte('created_at', startDate)
        .lt('created_at', endDate)
    ])

    // Update stats
    stats.value.safetyBriefing = safetyBriefingResult.count || 0
    stats.value.silentInspection = silentInspectionResult.count || 0
    stats.value.safetyPatrol = safetyPatrolResult.count || 0
    stats.value.safetyForum = safetyForumResult.count || 0
    stats.value.managementWalkthrough = managementWalkthroughResult.count || 0
    stats.value.safetyInduction = safetyInductionResult.count || 0
    stats.value.safetyDrill = safetyDrillResult.count || 0
    stats.value.unsafeActionCondition = unsafeActionConditionResult.count || 0

    // Calculate total temuan (findings) from various sources
    // This could be from unsafe_action_condition or other inspection results
    const { count: totalTemuan } = await supabase
      .from('unsafe_action_condition')
      .select('id', { count: 'exact', head: true })

    stats.value.totalTemuan = totalTemuan || 0

    console.log('Dashboard: Statistics loaded:', stats.value)

  } catch (error) {
    console.error('Dashboard: Error loading statistics:', error)
    // Keep default values on error
  }
}

// Load data on component mount
onMounted(async () => {
  await loadStats()
  await loadRecentActivities()
  await loadTrendData()
  await loadCategoryData()
})

// Helper functions
const formatDate = (dateStr: string) => {
  if (!dateStr) return '-'
  const date = new Date(dateStr)
  return date.toLocaleDateString('id-ID', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  })
}

const getStatusBadgeClass = (status: string) => {
  switch (status) {
    case 'completed':
    case 'selesai':
      return 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800'
    case 'in_progress':
    case 'sedang_berlangsung':
      return 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800'
    case 'scheduled':
    case 'terjadwal':
      return 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800'
    case 'cancelled':
    case 'dibatalkan':
      return 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800'
    default:
      return 'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800'
  }
}

const getStatusLabel = (status: string) => {
  switch (status) {
    case 'completed':
      return 'Selesai'
    case 'selesai':
      return 'Selesai'
    case 'in_progress':
      return 'Sedang Berlangsung'
    case 'sedang_berlangsung':
      return 'Sedang Berlangsung'
    case 'scheduled':
      return 'Terjadwal'
    case 'terjadwal':
      return 'Terjadwal'
    case 'cancelled':
      return 'Dibatalkan'
    case 'dibatalkan':
      return 'Dibatalkan'
    case 'draft':
      return 'Draft'
    default:
      return status || 'Unknown'
  }
}
</script>
