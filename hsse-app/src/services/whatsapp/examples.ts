/**
 * Example: Integrasi WhatsApp di Unsafe Action/Condition Service
 */

import { whatsappNotificationService } from '../whatsapp/notification.service'

// Config helper untuk environment variables
const getEnvVar = (key: string, defaultValue: string = ''): string => {
  // For Vite
  if (typeof import.meta !== 'undefined' && import.meta.env) {
    return import.meta.env[key] || defaultValue
  }
  // For Node.js (using globalThis to avoid type error)
  if (typeof globalThis !== 'undefined' && (globalThis as any).process?.env) {
    return (globalThis as any).process.env[key] || defaultValue
  }
  return defaultValue
}

// Contoh: Kirim notifikasi saat create unsafe condition
export async function sendUnsafeConditionNotification(unsafeCondition: any) {
  try {
    // Ambil recipients dari database atau config
    const recipients = [
      { 
        name: 'HSE Supervisor',
        phone: getEnvVar('VITE_SUPERVISOR_WHATSAPP', '628123456789')
      },
      { 
        name: 'HSE Manager',
        phone: getEnvVar('VITE_HSE_MANAGER_WHATSAPP', '628987654321')
      }
    ]

    // Kirim notifikasi hanya untuk priority critical atau high
    if (unsafeCondition.prioritas === 'critical' || unsafeCondition.prioritas === 'high') {
      await whatsappNotificationService.notifyUnsafeCondition({
        recipients,
        type: unsafeCondition.jenis_kejadian,
        category: unsafeCondition.kategori,
        location: unsafeCondition.lokasi_kejadian,
        description: unsafeCondition.deskripsi_kejadian,
        priority: unsafeCondition.prioritas,
        reporter: unsafeCondition.pelapor_nama,
        photoUrl: unsafeCondition.foto_kejadian?.[0] // Kirim foto pertama
      })
      
      console.log('✅ WhatsApp notification sent for unsafe condition')
    }
  } catch (error) {
    console.error('❌ Failed to send WhatsApp notification:', error)
    // Don't throw error, just log it (notification failure shouldn't break the main flow)
  }
}

// Contoh: Reminder safety briefing otomatis (bisa dijadwalkan dengan cron job)
export async function sendSafetyBriefingReminder(briefing: any) {
  try {
    // Ambil peserta dari daftar_peserta
    const recipients = briefing.daftar_peserta?.map((nama: string) => ({
      name: nama,
      phone: '628xxxxxxxxx' // TODO: Ambil nomor dari database pegawai
    })) || []

    await whatsappNotificationService.remindSafetyBriefing({
      recipients,
      date: new Date(briefing.tanggal).toLocaleDateString('id-ID'),
      time: briefing.waktu_mulai,
      location: briefing.lokasi || 'Ruang Meeting',
      topic: briefing.topik
    })
    
    console.log('✅ Safety briefing reminder sent')
  } catch (error) {
    console.error('❌ Failed to send briefing reminder:', error)
  }
}

// Contoh: Notifikasi setelah silent inspection
export async function sendSilentInspectionReport(inspection: any) {
  try {
    const recipients = [
      { name: 'HSE Manager', phone: getEnvVar('VITE_HSE_MANAGER_WHATSAPP', '628987654321') }
    ]

    await whatsappNotificationService.notifySilentInspectionCompleted({
      recipients,
      area: inspection.area_inspeksi,
      inspectionDate: new Date(inspection.tanggal).toLocaleDateString('id-ID'),
      totalFindings: inspection.jumlah_temuan || 0,
      criticalFindings: inspection.temuan_critical || 0,
      majorFindings: inspection.temuan_major || 0,
      minorFindings: inspection.temuan_minor || 0,
      riskLevel: inspection.tingkat_risiko || 'rendah'
    })
    
    console.log('✅ Silent inspection report sent')
  } catch (error) {
    console.error('❌ Failed to send inspection report:', error)
  }
}

// Contoh: Laporan LTIFR bulanan (scheduled job)
export async function sendMonthlyLTIFRReport(ltifr: any) {
  try {
    const recipients = [
      { name: 'HSE Manager', phone: getEnvVar('VITE_HSE_MANAGER_WHATSAPP', '628987654321') },
      { name: 'Plant Manager', phone: '628111111111' }
    ]

    // Determine trend
    let trend: 'up' | 'down' | 'stable' = 'stable'
    // TODO: Compare with previous month to determine trend

    await whatsappNotificationService.sendMonthlyLTIFRReport({
      recipients,
      month: ltifr.periode_bulan.split('-')[1],
      year: ltifr.periode_bulan.split('-')[0],
      ltifr: ltifr.ltifr,
      ltiCount: ltifr.jumlah_lti,
      totalWorkHours: ltifr.total_jam_kerja,
      trend
    })
    
    console.log('✅ Monthly LTIFR report sent')
  } catch (error) {
    console.error('❌ Failed to send LTIFR report:', error)
  }
}
