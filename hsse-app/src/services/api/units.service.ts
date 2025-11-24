import { supabase, isSupabaseConfigured } from './supabase'

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
    try {
      // First, try with joins (if related tables exist)
      const { data, error } = await supabase
        .from(this.tableName)
        .select(`
          *,
          wilayah:wilayah_id (
            id,
            nama,
            kode
          )
        `)
        .order('nama', { ascending: true })

      if (error) {
        // If join fails, fallback to simple query without relations
        console.warn('Units join query failed, falling back to simple query:', error.message)
        const { data: simpleData, error: simpleError } = await supabase
          .from(this.tableName)
          .select('*')
          .order('nama', { ascending: true })

        if (simpleError) throw simpleError

        // Map without relations
        return (simpleData || []).map(unit => ({
          ...unit,
          wilayah: undefined,
          
        }))
      }

      // Return data as-is since column names match
      return (data || []).map(unit => ({
        ...unit,
        wilayah: unit.wilayah || undefined
      }))
    } catch (error) {
      console.error('Error in getAll():', error)
      throw error
    }
  }

  async getActive(): Promise<Unit[]> {
    const { data, error} = await supabase
      .from(this.tableName)
      .select(`
        id,
        kode,
        nama,
        tipe,
        wilayah_id,
        area_id,
        aktif,
        created_at,
        updated_at
      `)
      .eq('aktif', true)
      .eq('tipe', 'unit')
      .order('nama', { ascending: true })

    if (error) throw error

    // Data is already in correct format, no mapping needed
    const mappedData = data || []

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
    try {
      // First, try with joins
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
        .order('nama', { ascending: true })

      if (error) {
        // Fallback to simple query
        console.warn('Units getByWilayah join query failed, falling back to simple query:', error.message)
        const { data: simpleData, error: simpleError } = await supabase
          .from(this.tableName)
          .select('*')
          .eq('wilayah_id', wilayahId)
          .eq('aktif', true)
          .order('nama', { ascending: true })

        if (simpleError) throw simpleError

        // Map without relations
        return (simpleData || []).map(unit => ({
          ...unit,
          wilayah: undefined,
          
        }))
      }

      // Map the database column names to the expected interface names
      return (data || []).map(unit => ({
        ...unit,
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
    } catch (error) {
      console.error('Error in getByWilayah():', error)
      throw error
    }
  }

  async getById(id: string): Promise<Unit | null> {
    try {
      // First, try with joins
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

      if (error) {
        // Fallback to simple query
        console.warn('Units getById join query failed, falling back to simple query:', error.message)
        const { data: simpleData, error: simpleError } = await supabase
          .from(this.tableName)
          .select('*')
          .eq('id', id)
          .single()

        if (simpleError) throw simpleError

        // Map without relations
        if (simpleData) {
          return {
            ...simpleData,
            wilayah: undefined,
            
          }
        }
        return null
      }

      // Map the database column names to the expected interface names
      if (data) {
        return {
          ...data,
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
    } catch (error) {
      console.error('Error in getById():', error)
      throw error
    }
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
    // First, perform the update
    const { error: updateError } = await supabase
      .from(this.tableName)
      .update(unit)
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
