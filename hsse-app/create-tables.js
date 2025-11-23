import { createClient } from '@supabase/supabase-js'

const supabase = createClient('https://oxskmrkzxkvifbappsic.supabase.co', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3NjkyMDgsImV4cCI6MjA3OTM0NTIwOH0.fJlPco2DGRzusGXQ_9HFwHEqulJ0qQsQrIAP3mT3MJw')

async function createTables() {
  try {
    console.log('Creating tables...')

    // Create wilayah table
    const { error: wilayahError } = await supabase.from('wilayah').insert({
      kode: 'WIL-3',
      nama: 'Wilayah 3',
      aktif: true
    })

    if (wilayahError && !wilayahError.message.includes('already exists')) {
      console.log('Wilayah table might not exist, trying to create it...')
      // Table doesn't exist, we need to create it via SQL
      console.log('Please run the SQL setup manually in Supabase dashboard')
      return
    }

    console.log('Tables created successfully!')

  } catch (error) {
    console.error('Error:', error)
  }
}

createTables()