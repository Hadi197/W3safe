import { supabase } from './supabase'

export interface Wilayah {
  id: string
  nama: string
  kode: string
  regional?: string
  aktif: boolean
  created_at: string
  updated_at: string
}

export interface CreateWilayahDto {
  nama: string
  kode: string
  regional?: string
  aktif?: boolean
}

export interface UpdateWilayahDto {
  nama?: string
  kode?: string
  regional?: string
  aktif?: boolean
}

class WilayahService {
  private tableName = 'wilayah'

  async getAll(): Promise<Wilayah[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('*')
      .order('nama_wilayah', { ascending: true })

    if (error) throw error
    
    // Map kode_wilayah to kode and nama_wilayah to nama for frontend compatibility
    return (data || []).map(wilayah => ({
      ...wilayah,
      kode: wilayah.kode_wilayah,
      nama: wilayah.nama_wilayah
    }))
  }

  async getActive(): Promise<Wilayah[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('*')
      .eq('aktif', true)
      .order('nama_wilayah', { ascending: true })

    if (error) throw error
    
    // Map kode_wilayah to kode and nama_wilayah to nama for frontend compatibility
    return (data || []).map(wilayah => ({
      ...wilayah,
      kode: wilayah.kode_wilayah,
      nama: wilayah.nama_wilayah
    }))
  }

  async getById(id: string): Promise<Wilayah | null> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select('*')
      .eq('id', id)
      .single()

    if (error) throw error
    return data
  }

  async create(wilayah: CreateWilayahDto): Promise<Wilayah> {
    const { data, error } = await supabase
      .from(this.tableName)
      .insert(wilayah)
      .select()
      .single()

    if (error) throw error
    return data
  }

  async update(id: string, wilayah: UpdateWilayahDto): Promise<Wilayah> {
    const { data, error } = await supabase
      .from(this.tableName)
      .update(wilayah)
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
}

export const wilayahService = new WilayahService()
