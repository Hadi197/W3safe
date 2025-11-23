import { createClient } from '@supabase/supabase-js'

// Supabase configuration
const supabaseUrl = 'https://oxskmrkzxkvifbappsic.supabase.co'
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3NjkyMDgsImV4cCI6MjA3OTM0NTIwOH0.fJlPco2DGRzusGXQ_9HFwHEqulJ0qQsQrIAP3mT3MJw'

const supabase = createClient(supabaseUrl, supabaseKey)

async function updateWalkthroughUnits() {
  try {
    // Get all walkthroughs with null unit_id
    const { data: walkthroughs, error: fetchError } = await supabase
      .from('management_walkthrough')
      .select('id, nomor_walkthrough, area_inspeksi')
      .is('unit_id', null)

    if (fetchError) {
      console.error('Error fetching walkthroughs:', fetchError)
      return
    }

    console.log(`Found ${walkthroughs?.length || 0} walkthroughs with null unit_id`)

    if (!walkthroughs || walkthroughs.length === 0) {
      console.log('No walkthroughs need updating')
      return
    }

    // Get all units
    const { data: units, error: unitsError } = await supabase
      .from('units')
      .select('id, kode, nama, aktif')

    console.log('Available units:', units)

    if (unitsError) {
      console.error('Error fetching units:', unitsError)
      return
    }

    let defaultUnitId

    if (!units || units.length === 0) {
      console.log('No units found in database, creating a default unit...')

      // Create a default unit
      const { data: newUnit, error: createError } = await supabase
        .from('units')
        .insert({
          kode: 'UNIT-DEFAULT',
          nama: 'Default Unit',
          tipe: 'unit',
          aktif: true
        })
        .select()
        .single()

      if (createError) {
        console.error('Error creating default unit:', createError)
        return
      }

      console.log('Created default unit:', newUnit)
      defaultUnitId = newUnit.id
      console.log(`Using newly created unit: ${newUnit.nama} (${newUnit.kode})`)
    } else {
      defaultUnitId = units[0].id
      console.log(`Using existing unit: ${units[0].nama} (${units[0].kode}) - Active: ${units[0].aktif}`)
    }

    // Update all walkthroughs with null unit_id
    const { error: updateError } = await supabase
      .from('management_walkthrough')
      .update({ unit_id: defaultUnitId })
      .is('unit_id', null)

    if (updateError) {
      console.error('Error updating walkthroughs:', updateError)
      return
    }

    console.log(`Successfully updated ${walkthroughs.length} walkthroughs with unit_id: ${defaultUnitId}`)

  } catch (error) {
    console.error('Unexpected error:', error)
  }
}

updateWalkthroughUnits()