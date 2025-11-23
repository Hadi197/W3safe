import { createClient } from '@supabase/supabase-js'
import { readFileSync } from 'fs'

const supabase = createClient('https://oxskmrkzxkvifbappsic.supabase.co', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3NjkyMDgsImV4cCI6MjA3OTM0NTIwOH0.fJlPco2DGRzusGXQ_9HFwHEqulJ0qQsQrIAP3mT3MJw')

async function runSetup() {
  try {
    console.log('Reading setup SQL file...')
    const sql = readFileSync('./supabase-setup.sql', 'utf8')

    console.log('Executing SQL setup...')
    const { error } = await supabase.rpc('exec_sql', { sql })

    if (error) {
      console.error('Error executing SQL:', error)
      return
    }

    console.log('Database setup completed successfully!')

  } catch (error) {
    console.error('Unexpected error:', error)
  }
}

runSetup()