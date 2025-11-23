import { createClient } from '@supabase/supabase-js'

const supabase = createClient('https://oxskmrkzxkvifbappsic.supabase.co', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3NjkyMDgsImV4cCI6MjA3OTM0NTIwOH0.fJlPco2DGRzusGXQ_9HFwHEqulJ0qQsQrIAP3mT3MJw')

async function setupUnits() {
  try {
    console.log('Checking wilayah...')

    // Check if wilayah WIL-3 exists
    const { data: wilayahData, error: wilayahError } = await supabase
      .from('wilayah')
      .select('id, kode')
      .eq('kode', 'WIL-3')

    if (wilayahError) {
      console.error('Error checking wilayah:', wilayahError)
      return
    }

    let wilayahId
    if (!wilayahData || wilayahData.length === 0) {
      console.log('Creating wilayah WIL-3...')
      const { data: newWilayah, error: createError } = await supabase
        .from('wilayah')
        .insert({ kode: 'WIL-3', nama: 'Wilayah 3' })
        .select('id')
        .single()

      if (createError) {
        console.error('Error creating wilayah:', createError)
        return
      }
      wilayahId = newWilayah.id
      console.log('Created wilayah with ID:', wilayahId)
    } else {
      wilayahId = wilayahData[0].id
      console.log('Found existing wilayah with ID:', wilayahId)
    }

    // Create areas
    console.log('Creating areas...')
    const areas = [
      { kode: 'AREA-JAWA1', nama: 'Area Jawa 1', tipe: 'area', wilayah_id: wilayahId, area_id: null },
      { kode: 'AREA-KALIMANTAN3', nama: 'Area Kalimantan 3', tipe: 'area', wilayah_id: wilayahId, area_id: null },
      { kode: 'AREA-BALINUSRA', nama: 'Area Bali Nusatenggara', tipe: 'area', wilayah_id: wilayahId, area_id: null }
    ]

    const { data: createdAreas, error: areasError } = await supabase
      .from('units')
      .insert(areas)
      .select('id, kode, nama')

    if (areasError) {
      console.error('Error creating areas:', areasError)
      return
    }

    console.log('Created areas:', createdAreas)

    // Get area IDs
    const areaJawa = createdAreas.find(a => a.kode === 'AREA-JAWA1')
    const areaKalimantan = createdAreas.find(a => a.kode === 'AREA-KALIMANTAN3')
    const areaBali = createdAreas.find(a => a.kode === 'AREA-BALINUSRA')

    // Create units for each area
    console.log('Creating units...')

    const units = [
      // Area Jawa 1
      { kode: 'UNIT-TANJUNGPERAK', nama: 'Tanjung Perak', tipe: 'unit', wilayah_id: wilayahId, area_id: areaJawa.id },
      { kode: 'UNIT-GRESIK', nama: 'Gresik', tipe: 'unit', wilayah_id: wilayahId, area_id: areaJawa.id },
      { kode: 'UNIT-TANJUNGINTAN', nama: 'Tanjung Intan', tipe: 'unit', wilayah_id: wilayahId, area_id: areaJawa.id },

      // Area Kalimantan 3
      { kode: 'UNIT-BANJARMASIN', nama: 'Banjarmasin', tipe: 'unit', wilayah_id: wilayahId, area_id: areaKalimantan.id },
      { kode: 'UNIT-KOTABARU', nama: 'Kotabaru', tipe: 'unit', wilayah_id: wilayahId, area_id: areaKalimantan.id },
      { kode: 'UNIT-MEKARPUTIH', nama: 'Mekar Putih', tipe: 'unit', wilayah_id: wilayahId, area_id: areaKalimantan.id },
      { kode: 'UNIT-BATULICIN', nama: 'Batulicin', tipe: 'unit', wilayah_id: wilayahId, area_id: areaKalimantan.id },
      { kode: 'UNIT-SATUI', nama: 'Satui', tipe: 'unit', wilayah_id: wilayahId, area_id: areaKalimantan.id },
      { kode: 'UNIT-BUNATI', nama: 'Bunati', tipe: 'unit', wilayah_id: wilayahId, area_id: areaKalimantan.id },
      { kode: 'UNIT-SAMPIT', nama: 'Sampit', tipe: 'unit', wilayah_id: wilayahId, area_id: areaKalimantan.id },
      { kode: 'UNIT-KUMAI', nama: 'Kumai', tipe: 'unit', wilayah_id: wilayahId, area_id: areaKalimantan.id },

      // Area Bali Nusatenggara
      { kode: 'UNIT-BENOA', nama: 'Benoa', tipe: 'unit', wilayah_id: wilayahId, area_id: areaBali.id },
      { kode: 'UNIT-CELUKANBAWANG', nama: 'Celukan Bawang', tipe: 'unit', wilayah_id: wilayahId, area_id: areaBali.id },
      { kode: 'UNIT-LEMBAR', nama: 'Lembar', tipe: 'unit', wilayah_id: wilayahId, area_id: areaBali.id },
      { kode: 'UNIT-TENAUKUPANG', nama: 'Tenau Kupang', tipe: 'unit', wilayah_id: wilayahId, area_id: areaBali.id }
    ]

    const { data: createdUnits, error: unitsError } = await supabase
      .from('units')
      .insert(units)
      .select('id, kode, nama')

    if (unitsError) {
      console.error('Error creating units:', unitsError)
      return
    }

    console.log(`Created ${createdUnits.length} units successfully!`)

    // Now update walkthroughs with null unit_id
    console.log('Updating walkthroughs with null unit_id...')
    const firstUnit = createdUnits[0]
    const { error: updateError } = await supabase
      .from('management_walkthrough')
      .update({ unit_id: firstUnit.id })
      .is('unit_id', null)

    if (updateError) {
      console.error('Error updating walkthroughs:', updateError)
    } else {
      console.log('Successfully updated walkthroughs with unit_id')
    }

  } catch (error) {
    console.error('Unexpected error:', error)
  }
}

setupUnits()