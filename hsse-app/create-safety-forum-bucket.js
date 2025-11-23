/**
 * Quick Fix: Create Safety Forum Bucket
 *
 * This script creates the missing safety-forum-photos bucket.
 * Run this to fix the 400 Bad Request error for document uploads.
 */

import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://oxskmrkzxkvifbappsic.supabase.co'
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3NjkyMDgsImV4cCI6MjA3OTM0NTIwOH0.fJlPco2DGRzusGXQ_9HFwHEqulJ0qQsQrIAP3mT3MJw'

const supabase = createClient(supabaseUrl, supabaseAnonKey)

const BUCKET_NAME = 'safety-forum-photos'

async function createBucket() {
  console.log('🔨 Creating safety-forum-photos bucket...')

  try {
    const { data, error } = await supabase.storage.createBucket(BUCKET_NAME, {
      public: true,
      allowedMimeTypes: [
        'image/jpeg',
        'image/png',
        'image/jpg',
        'image/webp',
        'application/pdf',
        'application/msword',
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'application/vnd.ms-excel',
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'text/plain'
      ],
      fileSizeLimit: 5242880 // 5MB
    })

    if (error) {
      if (error.message.includes('already exists')) {
        console.log('✅ Bucket already exists!')
      } else {
        console.error('❌ Failed to create bucket:', error.message)
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
      console.error('❌ Cannot access bucket:', listError.message)
    } else {
      console.log(`✅ Bucket accessible (${listData.length} files)`)
    }

  } catch (error) {
    console.error('❌ Unexpected error:', error.message)
  }
}

createBucket()
