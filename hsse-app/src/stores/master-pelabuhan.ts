import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { masterPelabuhanService, type MasterPelabuhan } from '@/services/api/master-pelabuhan.service'

export const useMasterPelabuhanStore = defineStore('masterPelabuhan', () => {
  const masterPelabuhan = ref<MasterPelabuhan[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  const activeMasterPelabuhan = computed(() => masterPelabuhan.value.filter(mp => mp.aktif))

  const masterPelabuhanByWilayah = computed(() => {
    const grouped: Record<string, MasterPelabuhan[]> = {}
    masterPelabuhan.value.forEach(mp => {
      const wilayahKey = mp.wilayah?.nama || 'no-region'
      if (!grouped[wilayahKey]) {
        grouped[wilayahKey] = []
      }
      grouped[wilayahKey]!.push(mp)
    })
    return grouped
  })

  async function fetchMasterPelabuhan() {
    loading.value = true
    error.value = null
    try {
      masterPelabuhan.value = await masterPelabuhanService.getAll()
    } catch (e: any) {
      error.value = e.message || 'Failed to fetch master pelabuhan'
      throw e
    } finally {
      loading.value = false
    }
  }

  async function fetchActiveMasterPelabuhan() {
    loading.value = true
    error.value = null
    try {
      masterPelabuhan.value = await masterPelabuhanService.getActive()
    } catch (e: any) {
      error.value = e.message || 'Failed to fetch active master pelabuhan'
      throw e
    } finally {
      loading.value = false
    }
  }

  return {
    masterPelabuhan,
    loading,
    error,
    activeMasterPelabuhan,
    masterPelabuhanByWilayah,
    fetchMasterPelabuhan,
    fetchActiveMasterPelabuhan
  }
})