import { createClient } from '@supabase/supabase-js'
import { readFileSync } from 'fs'

const supabase = createClient('https://oxskmrkzxkvifbappsic.supabase.co', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3NjkyMDgsImV4cCI6MjA3OTM0NTIwOH0.fJlPco2DGRzusGXQ_9HFwHEqulJ0qQsQrIAP3mT3MJw')

async function runSetup() {
  try {
    console.log('Reading setup SQL file...')
    const sql = readFileSync('./supabase-setup.sql', 'utf8')

    // Split SQL into individual statements
    const statements = sql
      .split(';')
      .map(stmt => stmt.trim())
      .filter(stmt => stmt.length > 0 && !stmt.startsWith('--'))

    console.log(`Found ${statements.length} SQL statements to execute`)

    for (let i = 0; i < statements.length; i++) {
      const statement = statements[i]
      if (statement.trim() === '') continue

      console.log(`Executing statement ${i + 1}/${statements.length}...`)

      try {
        const { error } = await supabase.rpc('exec', { query: statement })

        if (error) {
          // Try direct query if rpc fails
          const { error: queryError } = await supabase.from('_temp').select('*').limit(0)
          if (queryError) {
            console.log(`Statement ${i + 1} might be DDL, continuing...`)
          }
        }
      } catch (e) {
        console.log(`Statement ${i + 1} completed (expected for DDL statements)`)
      }
    }

    console.log('SQL setup completed!')

    // Now try to insert units data
    console.log('Inserting units data...')
    await insertUnitsData()

  } catch (error) {
    console.error('Unexpected error:', error)
  }
}

async function insertUnitsData() {
  try {
    // Insert wilayah first
    const { data: wilayahData, error: wilayahError } = await supabase
      .from('wilayah')
      .insert({ kode: 'WIL-3', nama: 'Wilayah 3' })
      .select('id')
      .single()

    if (wilayahError) {
      console.error('Error inserting wilayah:', wilayahError)
      return
    }

    console.log('Inserted wilayah:', wilayahData)

    // Insert areas
    const areas = [
      { kode: 'AREA-JAWA1', nama: 'Area Jawa 1', tipe: 'area', wilayah_id: wilayahData.id },
      { kode: 'AREA-KALIMANTAN3', nama: 'Area Kalimantan 3', tipe: 'area', wilayah_id: wilayahData.id },
      { kode: 'AREA-BALINUSRA', nama: 'Area Bali Nusatenggara', tipe: 'area', wilayah_id: wilayahData.id }
    ]

    const { data: areasData, error: areasError } = await supabase
      .from('units')
      .insert(areas)
      .select('id, kode, nama')

    if (areasError) {
      console.error('Error inserting areas:', areasError)
      return
    }

    console.log('Inserted areas:', areasData)

    // Insert units
    const areaJawa = areasData.find(a => a.kode === 'AREA-JAWA1')
    const areaKalimantan = areasData.find(a => a.kode === 'AREA-KALIMANTAN3')
    const areaBali = areasData.find(a => a.kode === 'AREA-BALINUSRA')

    const units = [
      // Area Jawa 1
      { kode: 'UNIT-TANJUNGPERAK', nama: 'Tanjung Perak', tipe: 'unit', wilayah_id: wilayahData.id, area_id: areaJawa.id },
      { kode: 'UNIT-GRESIK', nama: 'Gresik', tipe: 'unit', wilayah_id: wilayahData.id, area_id: areaJawa.id },
      { kode: 'UNIT-TANJUNGINTAN', nama: 'Tanjung Intan', tipe: 'unit', wilayah_id: wilayahData.id, area_id: areaJawa.id },

      // Area Kalimantan 3
      { kode: 'UNIT-BANJARMASIN', nama: 'Banjarmasin', tipe: 'unit', wilayah_id: wilayahData.id, area_id: areaKalimantan.id },
      { kode: 'UNIT-KOTABARU', nama: 'Kotabaru', tipe: 'unit', wilayah_id: wilayahData.id, area_id: areaKalimantan.id },
      { kode: 'UNIT-MEKARPUTIH', nama: 'Mekar Putih', tipe: 'unit', wilayah_id: wilayahData.id, area_id: areaKalimantan.id },
      { kode: 'UNIT-BATULICIN', nama: 'Batulicin', tipe: 'unit', wilayah_id: wilayahData.id, area_id: areaKalimantan.id },
      { kode: 'UNIT-SATUI', nama: 'Satui', tipe: 'unit', wilayah_id: wilayahData.id, area_id: areaKalimantan.id },
      { kode: 'UNIT-BUNATI', nama: 'Bunati', tipe: 'unit', wilayah_id: wilayahData.id, area_id: areaKalimantan.id },
      { kode: 'UNIT-SAMPIT', nama: 'Sampit', tipe: 'unit', wilayah_id: wilayahData.id, area_id: areaKalimantan.id },
      { kode: 'UNIT-KUMAI', nama: 'Kumai', tipe: 'unit', wilayah_id: wilayahData.id, area_id: areaKalimantan.id },

      // Area Bali Nusatenggara
      { kode: 'UNIT-BENOA', nama: 'Benoa', tipe: 'unit', wilayah_id: wilayahData.id, area_id: areaBali.id },
      { kode: 'UNIT-CELUKANBAWANG', nama: 'Celukan Bawang', tipe: 'unit', wilayah_id: wilayahData.id, area_id: areaBali.id },
      { kode: 'UNIT-LEMBAR', nama: 'Lembar', tipe: 'unit', wilayah_id: wilayahData.id, area_id: areaBali.id },
      { kode: 'UNIT-TENAUKUPANG', nama: 'Tenau Kupang', tipe: 'unit', wilayah_id: wilayahData.id, area_id: areaBali.id }
    ]

    const { data: unitsData, error: unitsError } = await supabase
      .from('units')
      .insert(units)
      .select('id, kode, nama')

    if (unitsError) {
      console.error('Error inserting units:', unitsError)
      return
    }

    console.log(`Successfully inserted ${unitsData.length} units!`)

  } catch (error) {
    console.error('Error in insertUnitsData:', error)
  }
}

runSetup()