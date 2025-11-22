import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { unitsService, type Unit, type CreateUnitDto, type UpdateUnitDto } from '@/services/api/units.service'
import { wilayahService, type Wilayah } from '@/services/api/wilayah.service'

export const useUnitsStore = defineStore('units', () => {
  const units = ref<Unit[]>([])
  const wilayahList = ref<Wilayah[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  const activeUnits = computed(() => units.value.filter(u => u.aktif))
  
  const unitsByWilayah = computed(() => {
    const grouped: Record<string, Unit[]> = {}
    units.value.forEach(unit => {
      const wilayahKey = unit.wilayah?.kode || 'no-region'
      if (!grouped[wilayahKey]) {
        grouped[wilayahKey] = []
      }
      grouped[wilayahKey]!.push(unit)
    })
    return grouped
  })

  async function fetchUnits() {
    loading.value = true
    error.value = null
    try {
      units.value = await unitsService.getAll()
    } catch (e: any) {
      error.value = e.message || 'Failed to fetch units'
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchWilayahList() {
    try {
      wilayahList.value = await wilayahService.getActive()
    } catch (e: any) {
      error.value = e.message || 'Failed to fetch wilayah'
      throw e
    }
  }

  async function createUnit(unitData: CreateUnitDto) {
    loading.value = true
    error.value = null
    try {
      const newUnit = await unitsService.create(unitData)
      units.value.push(newUnit)
      return newUnit
    } catch (e: any) {
      error.value = e.message || 'Failed to create unit'
      throw e
    } finally {
      loading.value = false
    }
  }

  async function updateUnit(id: string, unitData: UpdateUnitDto) {
    loading.value = true
    error.value = null
    try {
      const updatedUnit = await unitsService.update(id, unitData)
      const index = units.value.findIndex(u => u.id === id)
      if (index !== -1) {
        units.value[index] = updatedUnit
      }
      return updatedUnit
    } catch (e: any) {
      error.value = e.message || 'Failed to update unit'
      throw e
    } finally {
      loading.value = false
    }
  }

  async function deleteUnit(id: string) {
    loading.value = true
    error.value = null
    try {
      await unitsService.delete(id)
      units.value = units.value.filter(u => u.id !== id)
    } catch (e: any) {
      error.value = e.message || 'Failed to delete unit'
      throw e
    } finally {
      loading.value = false
    }
  }

  function getUnitById(id: string): Unit | undefined {
    return units.value.find(u => u.id === id)
  }

  return {
    units,
    wilayahList,
    loading,
    error,
    activeUnits,
    unitsByWilayah,
    fetchUnits,
    fetchWilayahList,
    createUnit,
    updateUnit,
    deleteUnit,
    getUnitById
  }
})
