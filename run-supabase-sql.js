import { createClient } from '@supabase/supabase-js'

// Supabase configuration
const supabaseUrl = 'https://oxskmrkzxkvifbappsic.supabase.co'
const supabaseServiceKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2Mzc2OTIwOCwiZXhwIjoyMDc5MzQ1MjA4fQ.01Ix7RoHljydCOWWZAhho6P4fgktOkM_XQ8kk51xSp4'

// Create Supabase client with service role key
const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
})

/**
 * Execute SQL query using Supabase REST API
 * @param {string} sql - SQL query to execute
 * @returns {Promise<Object>} - Query result
 */
async function executeSQL(sql) {
  try {
    console.log('🔄 Executing SQL query...')
    console.log('SQL:', sql.substring(0, 100) + (sql.length > 100 ? '...' : ''))

    const { data, error } = await supabase.rpc('exec_sql', {
      sql_query: sql
    })

    if (error) {
      console.error('❌ SQL Error:', error)
      return { success: false, error: error.message }
    }

    console.log('✅ SQL executed successfully')
    return { success: true, data }

  } catch (error) {
    console.error('❌ Execution Error:', error.message)
    return { success: false, error: error.message }
  }
}

/**
 * Test database connection
 */
async function testConnection() {
  try {
    console.log('🔍 Testing Supabase connection...')

    const { data, error } = await supabase
      .from('units')
      .select('count', { count: 'exact', head: true })

    if (error) {
      console.error('❌ Connection failed:', error.message)
      return false
    }

    console.log('✅ Supabase connection successful')
    return true

  } catch (error) {
    console.error('❌ Connection test failed:', error.message)
    return false
  }
}

// Export functions for use in other scripts
export { executeSQL, testConnection, supabase }
