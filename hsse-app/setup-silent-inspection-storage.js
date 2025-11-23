/**
 * Setup Silent Inspection Storage Bucket
 *
 * This script creates the required storage bucket and policies for silent inspection photos.
 * Run this after setting up your Supabase environment variables.
 */

import { createClient } from '@supabase/supabase-js'
import dotenv from 'dotenv'

// Load environment variables
dotenv.config()

const supabaseUrl = process.env.VITE_SUPABASE_URL
const supabaseServiceKey = process.env.VITE_SUPABASE_SERVICE_KEY || process.env.SUPABASE_SERVICE_ROLE_KEY

if (!supabaseUrl || !supabaseServiceKey) {
  console.error('❌ Missing environment variables:')
  console.error('   VITE_SUPABASE_URL:', supabaseUrl ? '✅ Set' : '❌ Missing')
  console.error('   SUPABASE_SERVICE_ROLE_KEY:', supabaseServiceKey ? '✅ Set' : '❌ Missing')
  console.log('')
  console.log('📝 Please set these environment variables:')
  console.log('   export VITE_SUPABASE_URL="your_supabase_url"')
  console.log('   export SUPABASE_SERVICE_ROLE_KEY="your_service_role_key"')
  console.log('   (Get service role key from Supabase Dashboard > Settings > API)')
  process.exit(1)
}

// Create Supabase client with service role key for admin operations
const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
})

const BUCKET_NAME = 'silent-inspection-photos'

async function setupSilentInspectionStorage() {
  console.log('🚀 Setting up Silent Inspection Storage...')
  console.log('')

  try {
    // Step 1: Create the bucket
    console.log('📦 Step 1: Creating storage bucket...')
    const { data: bucketData, error: bucketError } = await supabase.storage.createBucket(BUCKET_NAME, {
      public: true,
      allowedMimeTypes: ['image/jpeg', 'image/png', 'image/jpg', 'image/webp'],
      fileSizeLimit: 1048576 // 1MB
    })

    if (bucketError) {
      if (bucketError.message.includes('already exists')) {
        console.log('✅ Bucket already exists, continuing...')
      } else {
        throw bucketError
      }
    } else {
      console.log('✅ Bucket created successfully')
    }

    // Step 2: Apply storage policies via SQL
    console.log('🔒 Step 2: Setting up storage policies...')

    const policiesSQL = `
      -- Drop existing policies if any
      DROP POLICY IF EXISTS "silent-inspection-insert" ON storage.objects;
      DROP POLICY IF EXISTS "silent-inspection-select" ON storage.objects;
      DROP POLICY IF EXISTS "silent-inspection-update" ON storage.objects;
      DROP POLICY IF EXISTS "silent-inspection-delete" ON storage.objects;

      -- Policy 1: Allow authenticated users to INSERT (upload)
      CREATE POLICY "silent-inspection-insert"
      ON storage.objects FOR INSERT
      TO authenticated
      WITH CHECK (bucket_id = '${BUCKET_NAME}');

      -- Policy 2: Allow public to SELECT (view/download)
      CREATE POLICY "silent-inspection-select"
      ON storage.objects FOR SELECT
      TO public
      USING (bucket_id = '${BUCKET_NAME}');

      -- Policy 3: Allow authenticated users to UPDATE
      CREATE POLICY "silent-inspection-update"
      ON storage.objects FOR UPDATE
      TO authenticated
      USING (bucket_id = '${BUCKET_NAME}')
      WITH CHECK (bucket_id = '${BUCKET_NAME}');

      -- Policy 4: Allow authenticated users to DELETE
      CREATE POLICY "silent-inspection-delete"
      ON storage.objects FOR DELETE
      TO authenticated
      USING (bucket_id = '${BUCKET_NAME}');
    `

    const { error: sqlError } = await supabase.rpc('exec_sql', { sql: policiesSQL })

    if (sqlError) {
      console.log('⚠️  Could not apply policies via RPC, you may need to run the SQL manually')
      console.log('📄 Copy and run this SQL in Supabase SQL Editor:')
      console.log('')
      console.log(policiesSQL)
    } else {
      console.log('✅ Storage policies applied successfully')
    }

    // Step 3: Test the setup
    console.log('🧪 Step 3: Testing storage setup...')

    // Try to list objects in the bucket
    const { data: listData, error: listError } = await supabase.storage
      .from(BUCKET_NAME)
      .list()

    if (listError) {
      console.log('⚠️  Could not list bucket contents (this might be normal)')
      console.log('   Error:', listError.message)
    } else {
      console.log('✅ Bucket is accessible')
      console.log(`   📊 Objects in bucket: ${listData.length}`)
    }

    console.log('')
    console.log('🎉 Silent Inspection Storage setup completed!')
    console.log('')
    console.log('📋 Next steps:')
    console.log('1. Make sure your app has these environment variables:')
    console.log(`   VITE_SUPABASE_URL=${supabaseUrl}`)
    console.log('   VITE_SUPABASE_ANON_KEY=your_anon_key')
    console.log('')
    console.log('2. Try uploading a photo in the Silent Inspection module')
    console.log('')
    console.log('3. If upload still fails, check browser console for detailed errors')

  } catch (error) {
    console.error('❌ Setup failed:', error.message)
    console.log('')
    console.log('🔧 Troubleshooting:')
    console.log('1. Check your Supabase service role key is correct')
    console.log('2. Make sure you have admin access to the Supabase project')
    console.log('3. Try creating the bucket manually in Supabase Dashboard')
    process.exit(1)
  }
}

// Alternative method if RPC doesn't work - provide manual instructions
async function provideManualInstructions() {
  console.log('📖 Manual Setup Instructions:')
  console.log('')
  console.log('1. Go to Supabase Dashboard > Storage')
  console.log('2. Click "Create a new bucket"')
  console.log(`3. Bucket name: ${BUCKET_NAME}`)
  console.log('4. Check "Public bucket"')
  console.log('5. Click "Create bucket"')
  console.log('')
  console.log('6. Go to SQL Editor and run this SQL:')
  console.log('')
  console.log(`
-- Storage policies for ${BUCKET_NAME}
DROP POLICY IF EXISTS "silent-inspection-insert" ON storage.objects;
DROP POLICY IF EXISTS "silent-inspection-select" ON storage.objects;
DROP POLICY IF EXISTS "silent-inspection-update" ON storage.objects;
DROP POLICY IF EXISTS "silent-inspection-delete" ON storage.objects;

CREATE POLICY "silent-inspection-insert"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = '${BUCKET_NAME}');

CREATE POLICY "silent-inspection-select"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = '${BUCKET_NAME}');

CREATE POLICY "silent-inspection-update"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = '${BUCKET_NAME}')
WITH CHECK (bucket_id = '${BUCKET_NAME}');

CREATE POLICY "silent-inspection-delete"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = '${BUCKET_NAME}');
  `)
}

// Run the setup
setupSilentInspectionStorage().catch(error => {
  console.error('❌ Unexpected error:', error)
  console.log('')
  provideManualInstructions()
})

