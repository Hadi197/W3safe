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
          kode_wilayah
        ),
        area:area_id (
          id,
          nama_area,
          kode_area
        )
      `)
      .order('nama_unit', { ascending: true })

    if (error) throw error
    
    // Map the database column names to the expected interface names
    return (data || []).map(unit => ({
      ...unit,
      kode: unit.kode_unit,
      nama: unit.nama_unit,
      wilayah: unit.wilayah ? {
        ...unit.wilayah,
        kode: unit.wilayah.kode_wilayah
      } : undefined,
      area: unit.area ? {
        ...unit.area,
        nama: unit.area.nama_area,
        kode: unit.area.kode_area
      } : undefined
    }))
  }

  async getActive(): Promise<Unit[]> {
    const { data, error} = await supabase
      .from(this.tableName)
      .select(`
        id,
        kode_unit,
        nama_unit,
        tipe,
        wilayah_id,
        area_id,
        aktif,
        created_at,
        updated_at
      `)
      .eq('aktif', true)
      .eq('tipe', 'unit')
      .order('nama_unit', { ascending: true })

    if (error) throw error

    // Map database column names to interface names
    const mappedData = (data || []).map(unit => ({
      ...unit,
      kode: unit.kode_unit,
      nama: unit.nama_unit
    }))

    // Get wilayah and area data separately to avoid complex joins
    const processedData = await Promise.all(mappedData.map(async (unit) => {
      const unitWithRelations = { ...unit } as Unit

      // Get wilayah data
      if (unit.wilayah_id) {
        const { data: wilayah } = await supabase
          .from('wilayah')
          .select('id, nama, kode_wilayah')
          .eq('id', unit.wilayah_id)
          .single()

        if (wilayah) {
          unitWithRelations.wilayah = {
            ...wilayah,
            kode: wilayah.kode_wilayah
          }
        }
      }

      // Get area data
      if (unit.area_id) {
        const { data: area } = await supabase
          .from('areas')
          .select('id, nama_area, kode_area')
          .eq('id', unit.area_id)
          .single()

        if (area) {
          unitWithRelations.area = {
            ...area,
            nama: area.nama_area,
            kode: area.kode_area
          }
        }
      }

      return unitWithRelations
    }))

    return processedData
  }

  async getByWilayah(wilayahId: string): Promise<Unit[]> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select(`
        *,
        wilayah:wilayah_id (
          id,
          nama,
          kode_wilayah
        ),
        area:area_id (
          id,
          nama_area,
          kode_area
        )
      `)
      .eq('wilayah_id', wilayahId)
      .eq('aktif', true)
      .order('nama_unit', { ascending: true })

    if (error) throw error
    
    // Map the database column names to the expected interface names
    return (data || []).map(unit => ({
      ...unit,
      kode: unit.kode_unit,
      nama: unit.nama_unit,
      wilayah: unit.wilayah ? {
        ...unit.wilayah,
        kode: unit.wilayah.kode_wilayah
      } : undefined,
      area: unit.area ? {
        ...unit.area,
        nama: unit.area.nama_area,
        kode: unit.area.kode_area
      } : undefined
    }))
  }

  async getById(id: string): Promise<Unit | null> {
    const { data, error } = await supabase
      .from(this.tableName)
      .select(`
        *,
        wilayah:wilayah_id (
          id,
          nama,
          kode_wilayah
        ),
        area:area_id (
          id,
          nama_area,
          kode_area
        )
      `)
      .eq('id', id)
      .single()

    if (error) throw error
    
    // Map the database column names to the expected interface names
    if (data) {
      return {
        ...data,
        kode: data.kode_unit,
        nama: data.nama_unit,
        wilayah: data.wilayah ? {
          ...data.wilayah,
          kode: data.wilayah.kode_wilayah
        } : undefined,
        area: data.area ? {
          ...data.area,
          nama: data.area.nama_area,
          kode: data.area.kode_area
        } : undefined
      }
    }
    return null
  }

  async create(unit: CreateUnitDto): Promise<Unit> {
    // Map frontend field names to database column names
    const dbUnit = {
      ...unit,
      kode_unit: unit.kode,
      nama_unit: unit.nama,
      // Remove the frontend field names to avoid conflicts
      kode: undefined,
      nama: undefined
    }

    const { data, error } = await supabase
      .from(this.tableName)
      .insert(dbUnit)
      .select(`
        *,
        wilayah:wilayah_id (
          id,
          nama,
          kode_wilayah
        ),
        area:area_id (
          id,
          nama_area,
          kode_area
        )
      `)
      .single()

    if (error) throw error
    
    // Map the database column names to the expected interface names
    return {
      ...data,
      kode: data.kode_unit,
      nama: data.nama_unit,
      wilayah: data.wilayah ? {
        ...data.wilayah,
        kode: data.wilayah.kode_wilayah
      } : undefined,
      area: data.area ? {
        ...data.area,
        nama: data.area.nama_area,
        kode: data.area.kode_area
      } : undefined
    }
  }

  async update(id: string, unit: UpdateUnitDto): Promise<Unit> {
    // Map frontend field names to database column names
    const dbUnit = {
      ...unit,
      ...(unit.kode !== undefined && { kode_unit: unit.kode }),
      ...(unit.nama !== undefined && { nama_unit: unit.nama }),
      // Remove the frontend field names to avoid conflicts
      kode: undefined,
      nama: undefined
    }

    // First, perform the update
    const { error: updateError } = await supabase
      .from(this.tableName)
      .update(dbUnit)
      .eq('id', id)

    if (updateError) throw updateError

    // Then, fetch the updated record
    return await this.getById(id) as Unit
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
