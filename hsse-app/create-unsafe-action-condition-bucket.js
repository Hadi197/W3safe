/**
 * Create Unsafe Action Condition Files Bucket
 *
 * This script creates the unsafe-action-condition-files bucket and sets up policies.
 * Run this to set up the storage for unsafe action/condition photo/video/audio uploads.
 */

import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://oxskmrkzxkvifbappsic.supabase.co'
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3NjkyMDgsImV4cCI6MjA3OTM0NTIwOH0.fJlPco2DGRzusGXQ_9HFwHEqulJ0qQsQrIAP3mT3MJw'

const supabase = createClient(supabaseUrl, supabaseAnonKey)

const BUCKET_NAME = 'unsafe-action-condition-files'

async function createBucketAndPolicies() {
  console.log('🔨 Creating unsafe-action-condition-files bucket...')

  try {
    // Create the bucket
    const { data: bucketData, error: bucketError } = await supabase.storage.createBucket(BUCKET_NAME, {
      public: true,
      allowedMimeTypes: [
        'image/jpeg',
        'image/png',
        'image/jpg',
        'image/webp',
        'video/mp4',
        'video/webm',
        'video/avi',
        'video/quicktime',
        'audio/mpeg',
        'audio/wav',
        'audio/webm',
        'audio/mp3',
        'audio/m4a'
      ],
      fileSizeLimit: 10485760 // 10MB
    })

    if (bucketError) {
      if (bucketError.message.includes('already exists')) {
        console.log('✅ Bucket already exists!')
      } else {
        console.error('❌ Failed to create bucket:', bucketError.message)
        return
      }
    } else {
      console.log('✅ Bucket created successfully!')
    }

    // Test bucket access
    console.log('🧪 Testing bucket access...')
    const { data: listData, error: listError } = await supabase.storage
      .from(BUCKET_NAME)
      .list()

    if (listError) {
      console.error('❌ Bucket access test failed:', listError.message)
    } else {
      console.log(`✅ Bucket accessible (${listData.length} files)`)
    }

    console.log('\n📋 Next Steps:')
    console.log('1. The bucket has been created with basic settings')
    console.log('2. You need to run the SQL policies manually in Supabase SQL Editor')
    console.log('3. Copy and run the contents of: supabase/create-unsafe-action-condition-storage.sql')
    console.log('4. After running the policies, photo/video/audio uploads should work!')

  } catch (error) {
    console.error('❌ Unexpected error:', error.message)
  }
}

createBucketAndPolicies()