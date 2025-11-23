/**
 * Quick Fix: Create Safety Files Bucket
 *
 * This script creates the missing safety-files bucket for unsafe action/condition uploads.
 * Run this to fix the 400 Bad Request error for photo/video/audio uploads.
 */

import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://oxskmrkzxkvifbappsic.supabase.co'
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3NjkyMDgsImV4cCI6MjA3OTM0NTIwOH0.fJlPco2DGRzusGXQ_9HFwHEqulJ0qQsQrIAP3mT3MJw'

const supabase = createClient(supabaseUrl, supabaseAnonKey)

const BUCKET_NAME = 'safety-files'

async function createBucket() {
  console.log('🔨 Creating safety-files bucket...')

  try {
    const { data, error } = await supabase.storage.createBucket(BUCKET_NAME, {
      public: true,
      allowedMimeTypes: [
        'image/jpeg',
        'image/png',
        'image/jpg',
        'image/webp',
        'video/mp4',
        'video/webm',
        'video/avi',
        'audio/mpeg',
        'audio/wav',
        'audio/webm',
        'audio/mp3'
      ],
      fileSizeLimit: 10485760 // 10MB for videos
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
      console.error('❌ Bucket access test failed:', listError.message)
    } else {
      console.log('✅ Bucket access test passed!')
    }

  } catch (err) {
    console.error('❌ Unexpected error:', err.message)
  }
}

createBucket()