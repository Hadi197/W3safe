/**
 * Setup Silent Inspection Storage Policies Only
 *
 * Script khusus untuk setup storage policies jika bucket sudah ada
 * tapi policies belum di-setup dengan benar
 */

import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://oxskmrkzxkvifbappsic.supabase.co'
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3NjkyMDgsImV4cCI6MjA3OTM0NTIwOH0.fJlPco2DGRzusGXQ_9HFwHEqulJ0qQsQrIAP3mT3MJw'

const supabase = createClient(supabaseUrl, supabaseAnonKey)

async function setupPolicies() {
  console.log('🔒 Setting up Silent Inspection Storage Policies...\n')

  const policies = [
    {
      name: 'silent-inspection-insert',
      sql: `
        CREATE POLICY "silent-inspection-insert"
        ON storage.objects FOR INSERT
        TO authenticated
        WITH CHECK (bucket_id = 'silent-inspection-photos');
      `
    },
    {
      name: 'silent-inspection-select',
      sql: `
        CREATE POLICY "silent-inspection-select"
        ON storage.objects FOR SELECT
        TO public
        USING (bucket_id = 'silent-inspection-photos');
      `
    },
    {
      name: 'silent-inspection-update',
      sql: `
        CREATE POLICY "silent-inspection-update"
        ON storage.objects FOR UPDATE
        TO authenticated
        USING (bucket_id = 'silent-inspection-photos')
        WITH CHECK (bucket_id = 'silent-inspection-photos');
      `
    },
    {
      name: 'silent-inspection-delete',
      sql: `
        CREATE POLICY "silent-inspection-delete"
        ON storage.objects FOR DELETE
        TO authenticated
        USING (bucket_id = 'silent-inspection-photos');
      `
    }
  ]

  for (const policy of policies) {
    console.log(`📝 Setting up policy: ${policy.name}`)

    try {
      // First drop if exists
      const dropSql = `DROP POLICY IF EXISTS "${policy.name}" ON storage.objects;`

      const { error: dropError } = await supabase.rpc('exec_sql', { sql: dropSql })

      if (dropError) {
        console.log(`⚠️  Could not drop existing policy (might not exist): ${dropError.message}`)
      }

      // Then create new policy
      const { error: createError } = await supabase.rpc('exec_sql', { sql: policy.sql.trim() })

      if (createError) {
        console.log(`❌ Failed to create policy ${policy.name}: ${createError.message}`)
        console.log('💡 You may need to run this SQL manually in Supabase SQL Editor')
      } else {
        console.log(`✅ Policy ${policy.name} created successfully`)
      }

    } catch (error) {
      console.log(`❌ Error setting up policy ${policy.name}: ${error.message}`)
    }

    console.log('')
  }

  console.log('🎉 Policy setup completed!')
  console.log('')
  console.log('🧪 Test upload dengan:')
  console.log('node test-silent-inspection-upload.js')
  console.log('')
  console.log('📋 Jika masih error, check:')
  console.log('1. Supabase Dashboard > Storage > silent-inspection-photos > Policies')
  console.log('2. Pastikan bucket adalah Public bucket')
  console.log('3. Pastikan user sudah login di aplikasi')
}

// Run the setup
setupPolicies()

