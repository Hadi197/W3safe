/**
 * Evolution API WhatsApp Service
 * Service untuk integrasi WhatsApp menggunakan Evolution API
 */

import axios from 'axios'
import type { AxiosInstance } from 'axios'

export interface WhatsAppConfig {
  baseUrl: string
  apiKey: string
  instanceName: string
}

export interface SendMessageDto {
  number: string // Format: 628123456789 (tanpa +)
  text: string
  delay?: number // delay dalam ms (optional)
}

export interface SendMediaDto {
  number: string
  mediaUrl: string
  caption?: string
  fileName?: string
}

export interface SendLocationDto {
  number: string
  latitude: number
  longitude: number
  name?: string
  address?: string
}

export interface WhatsAppStatus {
  instance: string
  state: 'open' | 'connecting' | 'close'
  qrcode?: string
}

class EvolutionApiService {
  private client: AxiosInstance
  private config: WhatsAppConfig

  constructor(config: WhatsAppConfig) {
    this.config = config
    this.client = axios.create({
      baseURL: config.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'apikey': config.apiKey
      }
    })
  }

  /**
   * Cek status koneksi WhatsApp
   */
  async getStatus(): Promise<WhatsAppStatus> {
    try {
      const response = await this.client.get(`/instance/connectionState/${this.config.instanceName}`)
      return response.data
    } catch (error) {
      console.error('Error getting WhatsApp status:', error)
      throw error
    }
  }

  /**
   * Generate QR Code untuk autentikasi
   */
  async getQRCode(): Promise<string> {
    try {
      const response = await this.client.get(`/instance/qrcode/${this.config.instanceName}`)
      return response.data.qrcode
    } catch (error) {
      console.error('Error getting QR code:', error)
      throw error
    }
  }

  /**
   * Kirim pesan teks
   */
  async sendTextMessage(data: SendMessageDto): Promise<any> {
    try {
      const response = await this.client.post(`/message/sendText/${this.config.instanceName}`, {
        number: data.number,
        text: data.text,
        delay: data.delay || 1000
      })
      return response.data
    } catch (error) {
      console.error('Error sending text message:', error)
      throw error
    }
  }

  /**
   * Kirim pesan dengan media (foto/dokumen)
   */
  async sendMediaMessage(data: SendMediaDto): Promise<any> {
    try {
      const response = await this.client.post(`/message/sendMedia/${this.config.instanceName}`, {
        number: data.number,
        mediatype: 'image',
        media: data.mediaUrl,
        caption: data.caption || '',
        fileName: data.fileName || 'image.jpg'
      })
      return response.data
    } catch (error) {
      console.error('Error sending media message:', error)
      throw error
    }
  }

  /**
   * Kirim lokasi
   */
  async sendLocation(data: SendLocationDto): Promise<any> {
    try {
      const response = await this.client.post(`/message/sendLocation/${this.config.instanceName}`, {
        number: data.number,
        latitude: data.latitude,
        longitude: data.longitude,
        name: data.name || 'Lokasi',
        address: data.address || ''
      })
      return response.data
    } catch (error) {
      console.error('Error sending location:', error)
      throw error
    }
  }

  /**
   * Kirim pesan ke grup
   */
  async sendGroupMessage(groupId: string, text: string): Promise<any> {
    try {
      const response = await this.client.post(`/message/sendText/${this.config.instanceName}`, {
        number: groupId,
        text: text
      })
      return response.data
    } catch (error) {
      console.error('Error sending group message:', error)
      throw error
    }
  }
}

// Singleton instance
let evolutionApiService: EvolutionApiService | null = null

export const initializeEvolutionApi = (config: WhatsAppConfig) => {
  evolutionApiService = new EvolutionApiService(config)
  return evolutionApiService
}

export const getEvolutionApi = (): EvolutionApiService => {
  if (!evolutionApiService) {
    throw new Error('Evolution API not initialized. Call initializeEvolutionApi first.')
  }
  return evolutionApiService
}

export default EvolutionApiService
