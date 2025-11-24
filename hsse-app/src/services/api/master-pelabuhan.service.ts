import { supabase } from './supabase'

export interface MasterPelabuhan {
  id: string
  wilayah_id: string
  area_id: string
  unit_id: string
  aktif: boolean
  created_at: string
  updated_at: string
  // Relations
  wilayah: {
    id: string
    nama: string
    kode: string
  }
  area: {
    id: string
    nama: string
    kode: string
  }
  unit: {
    id: string
    kode: string
    nama: string
    aktif: boolean
  }
}

class MasterPelabuhanService {
  private tableName = 'master_pelabuhan'

  async getAll(): Promise<MasterPelabuhan[]> {
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
          nama_area,
          kode_area
        ),
        unit:unit_id (
          id,
          kode,
          nama,
          aktif
        )
      `)

    if (error) throw error

    // Map areas column names to match interface
    const mappedData = (data || []).map(item => ({
      ...item,
      area: item.area ? {
        ...item.area,
        nama: item.area.nama_area,
        kode: item.area.kode_area
      } : null
    }))

    // Sort by wilayah name, then area name, then unit name
    return mappedData.sort((a, b) => {
      const wilayahCompare = (a.wilayah?.nama || '').localeCompare(b.wilayah?.nama || '')
      if (wilayahCompare !== 0) return wilayahCompare

      const areaCompare = (a.area?.nama || '').localeCompare(b.area?.nama || '')
      if (areaCompare !== 0) return areaCompare

      return (a.unit?.nama || '').localeCompare(b.unit?.nama || '')
    })
  }

  async getActive(): Promise<MasterPelabuhan[]> {
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
          nama_area,
          kode_area
        ),
        unit:unit_id (
          id,
          kode,
          nama,
          aktif
        )
      `)
      .eq('aktif', true)

    if (error) throw error

    // Map areas column names to match interface
    const mappedData = (data || []).map(item => ({
      ...item,
      area: item.area ? {
        ...item.area,
        nama: item.area.nama_area,
        kode: item.area.kode_area
      } : null
    }))

    // Sort by wilayah name, then area name, then unit name
    return mappedData.sort((a, b) => {
      const wilayahCompare = (a.wilayah?.nama || '').localeCompare(b.wilayah?.nama || '')
      if (wilayahCompare !== 0) return wilayahCompare

      const areaCompare = (a.area?.nama || '').localeCompare(b.area?.nama || '')
      if (areaCompare !== 0) return areaCompare

      return (a.unit?.nama || '').localeCompare(b.unit?.nama || '')
    })
  }
}

export const masterPelabuhanService = new MasterPelabuhanService()