import { supabase } from './supabase'

export interface SafetyForumDTO {
  id?: string
  nomor_forum: string
  tanggal_forum: string
  waktu_mulai: string
  waktu_selesai?: string
  unit_id?: string
  lokasi: string
  jenis_forum: 'rutin' | 'insidental' | 'darurat' | 'tahunan' | 'bulanan' | 'mingguan'
  periode?: string
  
  // Pimpinan & Peserta
  ketua_forum?: string
  notulen_by?: string
  peserta_wajib?: string[]
  peserta_hadir?: string[]
  peserta_tidak_hadir?: string[]
  jumlah_peserta?: number
  
  // Agenda & Pembahasan
  agenda_utama: string
  agenda_detail?: AgendaItem[]
  latar_belakang?: string
  tujuan_forum?: string
  
  // Materi Pembahasan
  topik_bahaya?: string[]
  topik_kecelakaan?: string[]
  topik_incident?: string[]
  topik_observasi?: string[]
  topik_peraturan?: string[]
  topik_training?: string[]
  topik_lainnya?: string
  
  // Hasil Pembahasan
  ringkasan_pembahasan?: string
  masalah_teridentifikasi?: string[]
  risiko_teridentifikasi?: RisikoItem[]
  
  // Keputusan & Rekomendasi
  keputusan?: string
  rekomendasi?: string[]
  sop_baru?: string[]
  apd_yang_diperlukan?: string[]
  training_yang_diperlukan?: string[]
  
  // Action Items
  action_items?: ActionItem[]
  jumlah_action_item?: number
  action_selesai?: number
  action_progress?: number
  action_belum_mulai?: number
  
  // Dokumentasi
  foto_forum?: string[]
  dokumen_pendukung?: string[]
  notulen_file_url?: string
  daftar_hadir_url?: string
  presentasi_url?: string[]
  
  // Evaluasi & Tindak Lanjut
  forum_sebelumnya_id?: string
  evaluasi_tindak_lanjut?: string
  progress_action_sebelumnya?: number
  
  // Forum Berikutnya
  jadwal_forum_berikutnya?: string
  agenda_forum_berikutnya?: string
  
  // Status & Approval
  status: 'draft' | 'scheduled' | 'in_progress' | 'completed' | 'cancelled' | 'rescheduled'
  status_notulen?: 'belum_dibuat' | 'draft' | 'review' | 'approved' | 'rejected'
  approved_by?: string
  approved_at?: string
  
  // Catatan & Metadata
  catatan?: string
  tingkat_urgensi?: 'rendah' | 'normal' | 'tinggi' | 'kritis'
  kategori_forum?: string
  
  created_by?: string
  updated_by?: string
}

export interface AgendaItem {
  no: number
  topik: string
  pembicara?: string
  durasi?: string
  status?: 'pending' | 'discussing' | 'completed'
}

export interface RisikoItem {
  masalah: string
  tingkat_risiko: 'rendah' | 'sedang' | 'tinggi' | 'sangat_tinggi'
  dampak: string
  tindakan_mitigasi?: string
}

export interface ActionItem {
  no: number
  tindakan: string
  pic: string
  target: string
  status: 'belum_mulai' | 'progress' | 'selesai' | 'terlambat'
  prioritas: 'rendah' | 'sedang' | 'tinggi' | 'kritis'
  keterangan?: string
  progress_percentage?: number
}

export interface SafetyForumStats {
  total_forum: number
  forum_bulan_ini: number
  action_item_total: number
  action_item_selesai: number
  action_item_progress: number
  tingkat_penyelesaian: number
  forum_by_jenis: { jenis: string; count: number }[]
  forum_by_status: { status: string; count: number }[]
}

class SafetyForumService {
  // Upload foto forum
  async uploadPhoto(file: File, forumId: string): Promise<string> {
    try {
      const fileExt = file.name.split('.').pop()
      const fileName = `${forumId}_${Date.now()}_${Math.random().toString(36).substring(7)}.${fileExt}`
      const filePath = `${fileName}`

      const { data, error } = await supabase.storage
        .from('safety-forum-photos')
        .upload(filePath, file, {
          cacheControl: '3600',
          upsert: false
        })

      if (error) throw error

      const { data: { publicUrl } } = supabase.storage
        .from('safety-forum-photos')
        .getPublicUrl(filePath)

      return publicUrl
    } catch (error) {
      console.error('Error uploading photo:', error)
      throw error
    }
  }

  // Upload multiple photos
  async uploadPhotos(files: File[], forumId: string): Promise<string[]> {
    const uploadPromises = files.map(file => this.uploadPhoto(file, forumId))
    return Promise.all(uploadPromises)
  }

  // Upload dokumen pendukung
  async uploadDocument(file: File, forumId: string): Promise<string> {
    try {
      const fileExt = file.name.split('.').pop()
      const fileName = `${forumId}_doc_${Date.now()}.${fileExt}`
      const filePath = `documents/${fileName}`

      const { data, error } = await supabase.storage
        .from('safety-forum-photos')
        .upload(filePath, file, {
          cacheControl: '3600',
          upsert: false
        })

      if (error) throw error

      const { data: { publicUrl } } = supabase.storage
        .from('safety-forum-photos')
        .getPublicUrl(filePath)

      return publicUrl
    } catch (error) {
      console.error('Error uploading document:', error)
      throw error
    }
  }

  // Delete foto
  async deletePhoto(photoUrl: string): Promise<void> {
    try {
      const fileName = photoUrl.split('/').pop()
      if (!fileName) return

      const { error } = await supabase.storage
        .from('safety-forum-photos')
        .remove([fileName])

      if (error) throw error
    } catch (error) {
      console.error('Error deleting photo:', error)
      throw error
    }
  }

  // Get all forums
  async getAll(filters?: {
    unit_id?: string
    jenis_forum?: string
    status?: string
    tahun?: number
    bulan?: number
  }) {
    try {
      let query = supabase
        .from('safety_forum')
        .select(`
          *,
          unit:units(id, nama_unit, kode_unit)
        `)
        .order('tanggal_forum', { ascending: false })

      if (filters?.unit_id) {
        query = query.eq('unit_id', filters.unit_id)
      }

      if (filters?.jenis_forum) {
        query = query.eq('jenis_forum', filters.jenis_forum)
      }

      if (filters?.status) {
        query = query.eq('status', filters.status)
      }

      if (filters?.tahun) {
        query = query.gte('tanggal_forum', `${filters.tahun}-01-01`)
        query = query.lte('tanggal_forum', `${filters.tahun}-12-31`)
      }

      if (filters?.bulan && filters?.tahun) {
        const startDate = new Date(filters.tahun, filters.bulan - 1, 1)
        const endDate = new Date(filters.tahun, filters.bulan, 0)
        query = query.gte('tanggal_forum', startDate.toISOString().split('T')[0])
        query = query.lte('tanggal_forum', endDate.toISOString().split('T')[0])
      }

      const { data, error } = await query

      if (error) throw error
      return data
    } catch (error) {
      console.error('Error fetching safety forums:', error)
      throw error
    }
  }

  // Get by ID
  async getById(id: string) {
    try {
      const { data, error } = await supabase
        .from('safety_forum')
        .select(`
          *,
          unit:units(id, nama_unit, kode_unit)
        `)
        .eq('id', id)
        .single()

      if (error) throw error
      return data
    } catch (error) {
      console.error('Error fetching safety forum:', error)
      throw error
    }
  }

  // Get by nomor forum
  async getByNomor(nomor: string) {
    try {
      const { data, error } = await supabase
        .from('safety_forum')
        .select('*')
        .eq('nomor_forum', nomor)
        .single()

      if (error) throw error
      return data
    } catch (error) {
      console.error('Error fetching safety forum by nomor:', error)
      throw error
    }
  }

  // Get by unit
  async getByUnit(unitId: string) {
    try {
      const { data, error } = await supabase
        .from('safety_forum')
        .select(`
          *,
          unit:units(id, nama_unit, kode_unit)
        `)
        .eq('unit_id', unitId)
        .order('tanggal_forum', { ascending: false })

      if (error) throw error
      return data
    } catch (error) {
      console.error('Error fetching forums by unit:', error)
      throw error
    }
  }

  // Get by date range
  async getByDateRange(startDate: string, endDate: string) {
    try {
      const { data, error } = await supabase
        .from('safety_forum')
        .select(`
          *,
          unit:units(id, nama_unit, kode_unit)
        `)
        .gte('tanggal_forum', startDate)
        .lte('tanggal_forum', endDate)
        .order('tanggal_forum', { ascending: false })

      if (error) throw error
      return data
    } catch (error) {
      console.error('Error fetching forums by date range:', error)
      throw error
    }
  }

  // Get by status
  async getByStatus(status: string) {
    try {
      const { data, error } = await supabase
        .from('safety_forum')
        .select(`
          *,
          unit:units(id, nama_unit, kode_unit)
        `)
        .eq('status', status)
        .order('tanggal_forum', { ascending: false })

      if (error) throw error
      return data
    } catch (error) {
      console.error('Error fetching forums by status:', error)
      throw error
    }
  }

  // Create forum
  async create(dto: SafetyForumDTO) {
    try {
      const { data, error } = await supabase
        .from('safety_forum')
        .insert([dto])
        .select()
        .single()

      if (error) throw error
      return data
    } catch (error) {
      console.error('Error creating safety forum:', error)
      throw error
    }
  }

  // Update forum
  async update(id: string, dto: Partial<SafetyForumDTO>) {
    try {
      const { error } = await supabase
        .from('safety_forum')
        .update(dto)
        .eq('id', id)

      if (error) throw error
      
      // Return the updated data without re-fetching
      // This bypasses the schema cache issue
      return { id, ...dto }
    } catch (error) {
      console.error('Error updating safety forum:', error)
      throw error
    }
  }

  // Delete forum (soft delete by updating status)
  async delete(id: string) {
    try {
      // Get forum data first to delete associated files
      const forum = await this.getById(id)
      
      // Delete photos
      if (forum.foto_forum && forum.foto_forum.length > 0) {
        await Promise.all(
          forum.foto_forum.map((url: string) => this.deletePhoto(url))
        )
      }

      // Delete from database
      const { error } = await supabase
        .from('safety_forum')
        .delete()
        .eq('id', id)

      if (error) throw error
    } catch (error) {
      console.error('Error deleting safety forum:', error)
      throw error
    }
  }

  // Approve notulen
  async approveNotulen(id: string, approvedBy: string) {
    try {
      const { data, error } = await supabase
        .from('safety_forum')
        .update({
          status_notulen: 'approved',
          approved_by: approvedBy,
          approved_at: new Date().toISOString()
        })
        .eq('id', id)
        .select()
        .single()

      if (error) throw error
      return data
    } catch (error) {
      console.error('Error approving notulen:', error)
      throw error
    }
  }

  // Update action item status
  async updateActionItem(forumId: string, actionNo: number, updates: Partial<ActionItem>) {
    try {
      const forum = await this.getById(forumId)
      const actionItems = forum.action_items || []
      
      const updatedItems = actionItems.map((item: ActionItem) => 
        item.no === actionNo ? { ...item, ...updates } : item
      )

      // Recalculate action counts
      const counts = {
        action_selesai: updatedItems.filter((i: ActionItem) => i.status === 'selesai').length,
        action_progress: updatedItems.filter((i: ActionItem) => i.status === 'progress').length,
        action_belum_mulai: updatedItems.filter((i: ActionItem) => i.status === 'belum_mulai').length
      }

      const { data, error } = await supabase
        .from('safety_forum')
        .update({
          action_items: updatedItems,
          ...counts
        })
        .eq('id', forumId)
        .select()
        .single()

      if (error) throw error
      return data
    } catch (error) {
      console.error('Error updating action item:', error)
      throw error
    }
  }

  // Get statistics
  async getStats(): Promise<SafetyForumStats> {
    try {
      const { data: allForums, error: errorAll } = await supabase
        .from('safety_forum')
        .select('*')

      if (errorAll) throw errorAll

      const now = new Date()
      const firstDayOfMonth = new Date(now.getFullYear(), now.getMonth(), 1)
      const lastDayOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0)

      const { data: monthForums, error: errorMonth } = await supabase
        .from('safety_forum')
        .select('*')
        .gte('tanggal_forum', firstDayOfMonth.toISOString().split('T')[0])
        .lte('tanggal_forum', lastDayOfMonth.toISOString().split('T')[0])

      if (errorMonth) throw errorMonth

      // Calculate totals
      const totalActionItems = allForums?.reduce((sum, f) => sum + (f.jumlah_action_item || 0), 0) || 0
      const totalActionSelesai = allForums?.reduce((sum, f) => sum + (f.action_selesai || 0), 0) || 0
      const totalActionProgress = allForums?.reduce((sum, f) => sum + (f.action_progress || 0), 0) || 0

      // Group by jenis
      const forumByJenis = allForums?.reduce((acc: any, forum) => {
        const jenis = forum.jenis_forum
        const existing = acc.find((item: any) => item.jenis === jenis)
        if (existing) {
          existing.count++
        } else {
          acc.push({ jenis, count: 1 })
        }
        return acc
      }, []) || []

      // Group by status
      const forumByStatus = allForums?.reduce((acc: any, forum) => {
        const status = forum.status
        const existing = acc.find((item: any) => item.status === status)
        if (existing) {
          existing.count++
        } else {
          acc.push({ status, count: 1 })
        }
        return acc
      }, []) || []

      return {
        total_forum: allForums?.length || 0,
        forum_bulan_ini: monthForums?.length || 0,
        action_item_total: totalActionItems,
        action_item_selesai: totalActionSelesai,
        action_item_progress: totalActionProgress,
        tingkat_penyelesaian: totalActionItems > 0 
          ? Math.round((totalActionSelesai / totalActionItems) * 100) 
          : 0,
        forum_by_jenis: forumByJenis,
        forum_by_status: forumByStatus
      }
    } catch (error) {
      console.error('Error fetching stats:', error)
      throw error
    }
  }

  // Generate nomor forum otomatis
  async generateNomorForum(jenis: string = 'SF'): Promise<string> {
    try {
      const year = new Date().getFullYear()
      const month = String(new Date().getMonth() + 1).padStart(2, '0')
      
      const { data, error } = await supabase
        .from('safety_forum')
        .select('nomor_forum')
        .like('nomor_forum', `${jenis}-${year}-${month}-%`)
        .order('nomor_forum', { ascending: false })
        .limit(1)

      if (error) throw error

      let nextNum = 1
      if (data && data.length > 0 && data[0]) {
        const parts = data[0].nomor_forum.split('-')
        const lastPart = parts[parts.length - 1]
        const lastNum = parseInt(lastPart || '0')
        nextNum = lastNum + 1
      }

      return `${jenis}-${year}-${month}-${String(nextNum).padStart(3, '0')}`
    } catch (error) {
      console.error('Error generating nomor forum:', error)
      throw error
    }
  }
}

export const safetyForumService = new SafetyForumService()
