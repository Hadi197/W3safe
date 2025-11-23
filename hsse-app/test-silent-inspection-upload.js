/**
 * Test Silent Inspection Photo Upload
 *
 * Script untuk test upload foto ke silent-inspection-photos bucket
 * untuk mendiagnosis masalah 400 Bad Request error
 */

import { createClient } from '@supabase/supabase-js'
import fs from 'fs'
import path from 'path'

const supabaseUrl = 'https://oxskmrkzxkvifbappsic.supabase.co'
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94c2ttcmt6eGt2aWZiYXBwc2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3NjkyMDgsImV4cCI6MjA3OTM0NTIwOH0.fJlPco2DGRzusGXQ_9HFwHEqulJ0qQsQrIAP3mT3MJw'

const supabase = createClient(supabaseUrl, supabaseAnonKey)
const BUCKET_NAME = 'silent-inspection-photos'

async function testUpload() {
  console.log('🧪 Testing Silent Inspection Photo Upload...\n')

  try {
    // Step 1: Check if bucket exists
    console.log('📦 Step 1: Checking bucket existence...')
    const { data: buckets, error: bucketsError } = await supabase.storage.listBuckets()

    if (bucketsError) {
      console.error('❌ Cannot list buckets:', bucketsError.message)
      return
    }

    const bucketExists = buckets.some(b => b.name === BUCKET_NAME)
    console.log(`📦 Bucket "${BUCKET_NAME}" exists:`, bucketExists ? '✅' : '❌')

    if (!bucketExists) {
      console.log('❌ Bucket does not exist! Please create it first.')
      return
    }

    const bucket = buckets.find(b => b.name === BUCKET_NAME)
    console.log(`📦 Bucket public:`, bucket.public ? '✅' : '❌ (should be public)')
    console.log(`📦 File size limit:`, bucket.file_size_limit || 'none')

    // Step 2: Check bucket contents
    console.log('\n📋 Step 2: Checking bucket contents...')
    const { data: files, error: listError } = await supabase.storage
      .from(BUCKET_NAME)
      .list()

    if (listError) {
      console.error('❌ Cannot list bucket contents:', listError.message)
      console.log('🔧 This might indicate policy issues')
    } else {
      console.log(`✅ Can list bucket contents (${files.length} files)`)
    }

    // Step 3: Test upload with small test file
    console.log('\n📤 Step 3: Testing file upload...')

    // Create a small test image (1x1 pixel PNG)
    const testImageData = Buffer.from('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==', 'base64')
    const testFile = new File([testImageData], 'test-pixel.png', { type: 'image/png' })

    const testFileName = `test_${Date.now()}.png`

    console.log(`📄 Uploading test file: ${testFileName}`)
    console.log(`📏 File size: ${testFile.size} bytes`)
    console.log(`📏 File type: ${testFile.type}`)

    const { data: uploadData, error: uploadError } = await supabase.storage
      .from(BUCKET_NAME)
      .upload(testFileName, testFile, {
        cacheControl: '3600',
        upsert: false
      })

    if (uploadError) {
      console.error('❌ Upload failed:', uploadError.message)
      console.log('\n🔧 Possible causes:')
      console.log('1. Missing INSERT policy for authenticated users')
      console.log('2. File type not allowed (allowed: image/jpeg, image/png, image/jpg, image/webp)')
      console.log('3. File too large (max 1MB)')
      console.log('4. Not authenticated (need to be logged in)')
      console.log('\n📋 Check these in Supabase Dashboard:')
      console.log('- Storage > silent-inspection-photos > Policies')
      console.log('- Make sure INSERT policy exists for authenticated users')
    } else {
      console.log('✅ Upload successful!')
      console.log('📄 Uploaded file:', uploadData.path)

      // Test getting public URL
      const { data: urlData } = supabase.storage
        .from(BUCKET_NAME)
        .getPublicUrl(testFileName)

      console.log('🔗 Public URL:', urlData.publicUrl)

      // Clean up test file
      console.log('\n🧹 Cleaning up test file...')
      const { error: deleteError } = await supabase.storage
        .from(BUCKET_NAME)
        .remove([testFileName])

      if (deleteError) {
        console.log('⚠️ Could not delete test file:', deleteError.message)
      } else {
        console.log('✅ Test file cleaned up')
      }
    }

    // Step 4: Check storage policies
    console.log('\n📋 Step 4: Policy Recommendations')

    console.log('🔒 Required policies for silent-inspection-photos:')
    console.log('')
    console.log('INSERT (upload):')
    console.log('  CREATE POLICY "silent-inspection-insert"')
    console.log('  ON storage.objects FOR INSERT')
    console.log('  TO authenticated')
    console.log('  WITH CHECK (bucket_id = \'silent-inspection-photos\');')
    console.log('')
    console.log('SELECT (view):')
    console.log('  CREATE POLICY "silent-inspection-select"')
    console.log('  ON storage.objects FOR SELECT')
    console.log('  TO public')
    console.log('  USING (bucket_id = \'silent-inspection-photos\');')
    console.log('')
    console.log('UPDATE (modify):')
    console.log('  CREATE POLICY "silent-inspection-update"')
    console.log('  ON storage.objects FOR UPDATE')
    console.log('  TO authenticated')
    console.log('  USING (bucket_id = \'silent-inspection-photos\')')
    console.log('  WITH CHECK (bucket_id = \'silent-inspection-photos\');')
    console.log('')
    console.log('DELETE (remove):')
    console.log('  CREATE POLICY "silent-inspection-delete"')
    console.log('  ON storage.objects FOR DELETE')
    console.log('  TO authenticated')
    console.log('  USING (bucket_id = \'silent-inspection-photos\');')

  } catch (error) {
    console.error('❌ Unexpected error:', error.message)
  }
}

// Run the test
testUpload()

