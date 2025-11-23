/**
 * Check Silent Inspection Storage Setup
 *
 * This script checks if the silent-inspection-photos bucket exists and is properly configured.
 * Run this to diagnose storage issues.
 */

import { createClient } from '@supabase/supabase-js'
import dotenv from 'dotenv'

// Load environment variables
dotenv.config()

// Use environment variables if available, otherwise use hardcoded values for testing
const supabaseUrl = process.env.VITE_SUPABASE_URL || 'https://oxskmrkzxkvifbappsic.supabase.co'
const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3NjkyMDgsImV4cCI6MjA3OTM0NTIwOH0.fJlPco2DGRzusGXQ_9HFwHEqulJ0qQsQrIAP3mT3MJw'

console.log('🔗 Using Supabase URL:', supabaseUrl)
console.log('🔑 Using anon key:', supabaseAnonKey.substring(0, 20) + '...')
console.log('')

// Create Supabase client
const supabase = createClient(supabaseUrl, supabaseAnonKey)

const BUCKET_NAME = 'silent-inspection-photos'

async function checkStorageSetup() {
  console.log('🔍 Checking Silent Inspection Storage Setup...')
  console.log('')

  try {
    // Check 1: List all buckets
    console.log('📦 Checking available buckets...')
    const { data: buckets, error: bucketsError } = await supabase.storage.listBuckets()

    if (bucketsError) {
      console.error('❌ Cannot access storage:', bucketsError.message)
      console.log('')
      console.log('🔧 Possible solutions:')
      console.log('1. Check your VITE_SUPABASE_ANON_KEY is correct')
      console.log('2. Make sure your Supabase project allows anonymous access')
      return
    }

    const bucketNames = buckets.map(b => b.name)
    console.log('✅ Available buckets:', bucketNames.join(', '))

    const bucketExists = bucketNames.includes(BUCKET_NAME)
    console.log(`📦 ${BUCKET_NAME} exists:`, bucketExists ? '✅ Yes' : '❌ No')

    if (!bucketExists) {
      console.log('')
      console.log('❌ PROBLEM: The required bucket does not exist!')
      console.log('')
      console.log('🛠️  SOLUTION: Create the bucket manually')
      console.log('')
      console.log('Steps:')
      console.log('1. Go to Supabase Dashboard')
      console.log('2. Navigate to Storage')
      console.log('3. Click "Create a new bucket"')
      console.log(`4. Bucket name: ${BUCKET_NAME}`)
      console.log('5. Check "Public bucket"')
      console.log('6. Click "Create bucket"')
      console.log('')
      console.log('Or run: node setup-silent-inspection-storage.js')
      return
    }

    // Check 2: Try to list objects in the bucket
    console.log('')
    console.log('📋 Checking bucket access...')
    const { data: objects, error: listError } = await supabase.storage
      .from(BUCKET_NAME)
      .list()

    if (listError) {
      console.error('❌ Cannot access bucket:', listError.message)
      console.log('')
      console.log('🔧 Possible solutions:')
      console.log('1. Check bucket policies in Supabase Dashboard > Storage')
      console.log('2. Make sure the bucket is public or has proper SELECT policies')
      console.log('3. Run the storage policies SQL from create-silent-inspection-storage-policies.sql')
      return
    }

    console.log(`✅ Bucket accessible, contains ${objects.length} objects`)

    // Check 3: Try a test upload (with a small test file)
    console.log('')
    console.log('🧪 Testing upload capability...')

    // Create a small test blob
    const testBlob = new Blob(['test'], { type: 'text/plain' })
    const testFile = new File([testBlob], 'test.txt', { type: 'text/plain' })

    const testFileName = `test_${Date.now()}.txt`

    const { data: uploadData, error: uploadError } = await supabase.storage
      .from(BUCKET_NAME)
      .upload(testFileName, testFile, { upsert: false })

    if (uploadError) {
      console.error('❌ Cannot upload to bucket:', uploadError.message)
      console.log('')
      console.log('🔧 Possible solutions:')
      console.log('1. Check INSERT policies for authenticated users')
      console.log('2. Make sure you are logged in when uploading')
      console.log('3. Run the storage policies SQL')
      return
    }

    console.log('✅ Upload test successful')

    // Clean up test file
    await supabase.storage
      .from(BUCKET_NAME)
      .remove([testFileName])

    console.log('🧹 Test file cleaned up')

    // Success
    console.log('')
    console.log('🎉 Silent Inspection Storage is properly configured!')
    console.log('')
    console.log('✅ Bucket exists and is accessible')
    console.log('✅ Upload permissions are working')
    console.log('✅ You should be able to upload photos now')

  } catch (error) {
    console.error('❌ Unexpected error:', error.message)
  }
}

// Run the check
checkStorageSetup()
