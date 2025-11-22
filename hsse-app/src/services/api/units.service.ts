import { supabase } from './supabase'

export interface Unit {
  id: string
  kode: string
  nama: string
  tipe?: string
  wilayah_id?: string
  area_id?: string
  aktif: boolean
  created_at: string
  updated_at: string
  // Relations
  wilayah?: {
    id: string
    nama: string
    kode: string
  }
  area?: {
    id: string
    nama: string
    kode: string
  }
}

export interface CreateUnitDto {
  kode: string
  nama: string
  tipe?: string
  wilayah_id?: string
  area_id?: string
  aktif?: boolean
}

export interface UpdateUnitDto {
  kode?: string
  nama?: string
  tipe?: string
  wilayah_id?: string
  area_id?: string
  aktif?: boolean
}

class UnitsService {
  private tableName = 'units'

  async getAll(): Promise<Unit[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select(`
        *,
        wilayah:wilayah_id (
          id,
          nama,
          kode
        ),
        area:area_id (
          id,
          nama,
          kode
        )
      `)
      .order('nama', { ascending: true })

    if (error) throw error
    return data || []
  }

  async getActive(): Promise<Unit[]> {
    const { data, error} = await supabase
      .from(this.tableName)
      .select(`
        *,
        wilayah:wilayah_id (
          id,
          nama,
          kode
        ),
        area:area_id (
          id,
          nama,
          kode
        )
      `)
      .eq('aktif', true)
      .order('nama', { ascending: true })

    if (error) throw error
    return data || []
  }

  async getByWilayah(wilayahId: string): Promise<Unit[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select(`
        *,
        wilayah:wilayah_id (
          id,
          nama,
          kode
        ),
        area:area_id (
          id,
          nama,
          kode
        )
      `)
      .eq('wilayah_id', wilayahId)
      .eq('aktif', true)
      .order('nama', { ascending: true })

    if (error) throw error
    return data || []
  }

  async getById(id: string): Promise<Unit | null> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select(`
        *,
        wilayah:wilayah_id (
          id,
          nama,
          kode
        ),
        area:area_id (
          id,
          nama,
          kode
        )
      `)
      .eq('id', id)
      .single()

    if (error) throw error
    return data
  }

  async create(unit: CreateUnitDto): Promise<Unit> {
    const { data, error } = await supabase
      .from(this.tableName)
      .insert(unit)
      .select(`
        *,
        wilayah:wilayah_id (
          id,
          nama,
          kode
        ),
        area:area_id (
          id,
          nama,
          kode
        )
      `)
      .single()

    if (error) throw error
    return data
  }

  async update(id: string, unit: UpdateUnitDto): Promise<Unit> {
    const { data, error } = await supabase
      .from(this.tableName)
      .update(unit)
      .eq('id', id)
      .select(`
        *,
        wilayah:wilayah_id (
          id,
          nama,
          kode
        ),
        area:area_id (
          id,
          nama,
          kode
        )
      `)
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

export const unitsService = new UnitsService()
