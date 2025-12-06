/**
 * WhatsApp Notification Service
 * Service untuk mengirim notifikasi WhatsApp untuk berbagai event HSSE
 */

import { getEvolutionApi } from './evolution-api.service'

export interface NotificationRecipient {
  name: string
  phone: string // Format: 628123456789
}

export class WhatsAppNotificationService {
  
  /**
   * Notifikasi Unsafe Action/Condition (Critical)
   */
  async notifyUnsafeCondition(data: {
    recipients: NotificationRecipient[]
    type: 'unsafe_action' | 'unsafe_condition'
    category: string
    location: string
    description: string
    priority: string
    reporter: string
    photoUrl?: string
  }): Promise<void> {
    const api = getEvolutionApi()
    
    const typeText = data.type === 'unsafe_action' ? '⚠️ UNSAFE ACTION' : '🚨 UNSAFE CONDITION'
    const priorityEmoji = data.priority === 'critical' ? '🔴' : data.priority === 'high' ? '🟠' : '🟡'
    
    const message = `
${priorityEmoji} *${typeText} TERDETEKSI*

📋 *Kategori:* ${data.category}
📍 *Lokasi:* ${data.location}
⚡ *Prioritas:* ${data.priority.toUpperCase()}

📝 *Deskripsi:*
${data.description}

👤 *Dilaporkan oleh:* ${data.reporter}
🕐 *Waktu:* ${new Date().toLocaleString('id-ID')}

⚠️ *Segera lakukan tindakan korektif!*
    `.trim()

    // Kirim ke semua recipients
    for (const recipient of data.recipients) {
      try {
        await api.sendTextMessage({
          number: recipient.phone,
          text: message
        })
        
        // Kirim foto jika ada
        if (data.photoUrl) {
          await api.sendMediaMessage({
            number: recipient.phone,
            mediaUrl: data.photoUrl,
            caption: `Foto ${typeText}`
          })
        }
        
        console.log(`✅ Notification sent to ${recipient.name} (${recipient.phone})`)
      } catch (error) {
        console.error(`❌ Failed to send notification to ${recipient.name}:`, error)
      }
    }
  }

  /**
   * Reminder Safety Briefing
   */
  async remindSafetyBriefing(data: {
    recipients: NotificationRecipient[]
    date: string
    time: string
    location: string
    topic: string
  }): Promise<void> {
    const api = getEvolutionApi()
    
    const message = `
👷 *REMINDER: SAFETY BRIEFING*

📅 *Tanggal:* ${data.date}
🕐 *Waktu:* ${data.time}
📍 *Lokasi:* ${data.location}

📋 *Topik:*
${data.topic}

⚠️ Kehadiran Anda sangat penting untuk keselamatan kerja!
    `.trim()

    for (const recipient of data.recipients) {
      try {
        await api.sendTextMessage({
          number: recipient.phone,
          text: message
        })
        console.log(`✅ Reminder sent to ${recipient.name}`)
      } catch (error) {
        console.error(`❌ Failed to send reminder to ${recipient.name}:`, error)
      }
    }
  }

  /**
   * Notifikasi Silent Inspection Selesai
   */
  async notifySilentInspectionCompleted(data: {
    recipients: NotificationRecipient[]
    area: string
    inspectionDate: string
    totalFindings: number
    criticalFindings: number
    majorFindings: number
    minorFindings: number
    riskLevel: string
  }): Promise<void> {
    const api = getEvolutionApi()
    
    const riskEmoji = data.riskLevel === 'tinggi' ? '🔴' : data.riskLevel === 'sedang' ? '🟡' : '🟢'
    
    const message = `
🔍 *SILENT INSPECTION SELESAI*

📍 *Area:* ${data.area}
📅 *Tanggal:* ${data.inspectionDate}

📊 *Hasil Temuan:*
• Total: ${data.totalFindings} temuan
• 🔴 Critical: ${data.criticalFindings}
• 🟠 Major: ${data.majorFindings}
• 🟡 Minor: ${data.minorFindings}

${riskEmoji} *Tingkat Risiko:* ${data.riskLevel.toUpperCase()}

${data.criticalFindings > 0 ? '⚠️ *PERHATIAN: Ada temuan CRITICAL yang memerlukan tindakan SEGERA!*' : '✅ Lanjutkan monitoring dan perbaikan area yang ditemukan.'}
    `.trim()

    for (const recipient of data.recipients) {
      try {
        await api.sendTextMessage({
          number: recipient.phone,
          text: message
        })
        console.log(`✅ Inspection report sent to ${recipient.name}`)
      } catch (error) {
        console.error(`❌ Failed to send report to ${recipient.name}:`, error)
      }
    }
  }

  /**
   * Notifikasi Safety Patrol Temuan
   */
  async notifySafetyPatrolFindings(data: {
    recipients: NotificationRecipient[]
    area: string
    patrolDate: string
    unsafeConditions: number
    unsafeActs: number
    recommendations: string
  }): Promise<void> {
    const api = getEvolutionApi()
    
    const message = `
🛡️ *SAFETY PATROL REPORT*

📍 *Area:* ${data.area}
📅 *Tanggal:* ${data.patrolDate}

📊 *Temuan:*
• Unsafe Conditions: ${data.unsafeConditions}
• Unsafe Acts: ${data.unsafeActs}

💡 *Rekomendasi:*
${data.recommendations}

⚠️ Mohon segera ditindaklanjuti untuk mencegah insiden.
    `.trim()

    for (const recipient of data.recipients) {
      try {
        await api.sendTextMessage({
          number: recipient.phone,
          text: message
        })
        console.log(`✅ Patrol report sent to ${recipient.name}`)
      } catch (error) {
        console.error(`❌ Failed to send report to ${recipient.name}:`, error)
      }
    }
  }

  /**
   * Notifikasi Management Walkthrough
   */
  async notifyManagementWalkthrough(data: {
    recipients: NotificationRecipient[]
    date: string
    time: string
    area: string
    leader: string
  }): Promise<void> {
    const api = getEvolutionApi()
    
    const message = `
👔 *MANAGEMENT WALKTHROUGH SCHEDULED*

📅 *Tanggal:* ${data.date}
🕐 *Waktu:* ${data.time}
📍 *Area:* ${data.area}
👤 *Dipimpin oleh:* ${data.leader}

✅ Pastikan area dalam kondisi aman dan siap untuk inspeksi.
    `.trim()

    for (const recipient of data.recipients) {
      try {
        await api.sendTextMessage({
          number: recipient.phone,
          text: message
        })
        console.log(`✅ Walkthrough notification sent to ${recipient.name}`)
      } catch (error) {
        console.error(`❌ Failed to send notification to ${recipient.name}:`, error)
      }
    }
  }

  /**
   * Laporan LTIFR Bulanan
   */
  async sendMonthlyLTIFRReport(data: {
    recipients: NotificationRecipient[]
    month: string
    year: string
    ltifr: number
    ltiCount: number
    totalWorkHours: number
    trend: 'up' | 'down' | 'stable'
  }): Promise<void> {
    const api = getEvolutionApi()
    
    const trendEmoji = data.trend === 'down' ? '✅📉' : data.trend === 'up' ? '⚠️📈' : '➡️'
    
    const message = `
📊 *LAPORAN LTIFR BULANAN*

📅 *Periode:* ${data.month} ${data.year}

📈 *Hasil:*
• LTIFR: ${data.ltifr.toFixed(2)}
• Jumlah LTI: ${data.ltiCount}
• Total Jam Kerja: ${data.totalWorkHours.toLocaleString()}

${trendEmoji} *Trend:* ${data.trend === 'down' ? 'MEMBAIK ✅' : data.trend === 'up' ? 'MENINGKAT ⚠️' : 'STABIL'}

${data.trend === 'up' ? '⚠️ Perlu peningkatan program keselamatan!' : data.trend === 'down' ? '✅ Pertahankan performa keselamatan!' : '➡️ Terus monitor dan tingkatkan awareness!'}
    `.trim()

    for (const recipient of data.recipients) {
      try {
        await api.sendTextMessage({
          number: recipient.phone,
          text: message
        })
        console.log(`✅ LTIFR report sent to ${recipient.name}`)
      } catch (error) {
        console.error(`❌ Failed to send report to ${recipient.name}:`, error)
      }
    }
  }

  /**
   * Kirim pesan custom
   */
  async sendCustomMessage(data: {
    recipients: NotificationRecipient[]
    message: string
    mediaUrl?: string
  }): Promise<void> {
    const api = getEvolutionApi()

    for (const recipient of data.recipients) {
      try {
        await api.sendTextMessage({
          number: recipient.phone,
          text: data.message
        })
        
        if (data.mediaUrl) {
          await api.sendMediaMessage({
            number: recipient.phone,
            mediaUrl: data.mediaUrl
          })
        }
        
        console.log(`✅ Custom message sent to ${recipient.name}`)
      } catch (error) {
        console.error(`❌ Failed to send message to ${recipient.name}:`, error)
      }
    }
  }
}

export const whatsappNotificationService = new WhatsAppNotificationService()
