// Test Supabase connection
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://oxskmrkzxkvifbappsic.supabase.co'
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3NjkyMDgsImV4cCI6MjA3OTM0NTIwOH0.fJlPco2DGRzusGXQ_9HFwHEqulJ0qQsQrIAP3mT3MJw'

const supabase = createClient(supabaseUrl, supabaseAnonKey)

async function testConnection() {
  try {
    console.log('🔍 Testing Supabase connection...')

    // Test basic connection by getting user (should fail since not authenticated, but won't give 401 for wrong key)
    const { data: user, error: userError } = await supabase.auth.getUser()

    // Test database connection by querying units table
    const { data: units, error: unitsError } = await supabase
      .from('units')
      .select('id, kode_unit, nama_unit, tipe, aktif')
      .limit(1)

    if (unitsError) {
      console.error('❌ Database connection failed:', unitsError.message)
      return false
    }

    console.log('✅ Supabase connection successful!')
    console.log('📊 Sample units data:', units)
    return true

  } catch (error) {
    console.error('❌ Connection test failed:', error.message)
    return false
  }
}

testConnection()
