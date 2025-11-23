import { supabase } from './api/supabase'

export interface MasterPegawai {
  id?: string
  nama: string
  nipp: string
  jabatan: string
  unit_kerja: string
  email?: string
  no_telepon?: string
  tanggal_lahir?: string
  alamat?: string
  status?: 'aktif' | 'non_aktif' | 'resign' | 'pensiun'
  created_at?: string
  updated_at?: string
}

export interface PegawaiFilters {
  search?: string
  unit_kerja?: string
  jabatan?: string
  status?: string
}

class MasterPegawaiService {
  private tableName = 'master_pegawai'

  async getAll(filters?: PegawaiFilters) {
    let query = supabase
      .from(this.tableName)
      .select('*', { count: 'exact' })
      .order('nama', { ascending: true })

    // Apply filters
    if (filters?.search) {
      query = query.or(`nama.ilike.%${filters.search}%,nipp.ilike.%${filters.search}%,jabatan.ilike.%${filters.search}%`)
    }

    if (filters?.unit_kerja) {
      query = query.ilike('unit_kerja', `%${filters.unit_kerja}%`)
    }

    if (filters?.jabatan) {
      query = query.ilike('jabatan', `%${filters.jabatan}%`)
    }

    if (filters?.status) {
      query = query.eq('status', filters.status)
    }

    const { data, error, count } = await query

    if (error) throw error

    return {
      data: data || [],
      count: count || 0
    }
  }

  async getById(id: string): Promise<MasterPegawai | null> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('*')
      .eq('id', id)
      .single()

    if (error) throw error
    return data
  }

  async create(pegawai: Omit<MasterPegawai, 'id' | 'created_at' | 'updated_at'>): Promise<MasterPegawai> {
    const { data, error } = await supabase
      .from(this.tableName)
      .insert(pegawai)
      .select()
      .single()

    if (error) throw error
    return data
  }

  async update(id: string, pegawai: Partial<MasterPegawai>): Promise<MasterPegawai> {
    const { data, error } = await supabase
      .from(this.tableName)
      .update(pegawai)
      .eq('id', id)
      .select()
      .single()

    if (error) throw error
    return data
  }

  async delete(id: string): Promise<void> {
    const { error } = await supabase
      .from(this.tableName)
      .delete()
      .eq('id', id)

    if (error) throw error
  }

  async getUnits(): Promise<string[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('unit_kerja')
      .not('unit_kerja', 'is', null)

    if (error) throw error

    // Get unique unit names
    const units = [...new Set((data || []).map(item => item.unit_kerja))].sort()
    return units
  }

  async getJabatans(): Promise<string[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('jabatan')
      .not('jabatan', 'is', null)

    if (error) throw error

    // Get unique jabatan names
    const jabatans = [...new Set((data || []).map(item => item.jabatan))].sort()
    return jabatans
  }
}

export const masterPegawaiService = new MasterPegawaiService()
