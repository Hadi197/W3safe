-- Migration: Create storage policies for silent-inspection-photos
-- Description: Storage bucket and policies for silent inspection photos

-- Note: Bucket creation must be done via Supabase Dashboard
-- Bucket name: silent-inspection-photos
-- Public: true
-- File size limit: 1MB
-- Allowed MIME types: image/jpeg, image/png, image/jpg, image/webp

-- Drop ALL existing policies for this bucket (clean slate)
DROP POLICY IF EXISTS "Allow authenticated users to upload silent inspection photos" ON storage.objects;
DROP POLICY IF EXISTS "Allow public to view silent inspection photos" ON storage.objects;
DROP POLICY IF EXISTS "Allow authenticated users to update silent inspection photos" ON storage.objects;
DROP POLICY IF EXISTS "Allow authenticated users to delete silent inspection photos" ON storage.objects;

-- Also try dropping with other possible names
DROP POLICY IF EXISTS "silent-inspection-insert" ON storage.objects;
DROP POLICY IF EXISTS "silent-inspection-select" ON storage.objects;
DROP POLICY IF EXISTS "silent-inspection-update" ON storage.objects;
DROP POLICY IF EXISTS "silent-inspection-delete" ON storage.objects;

-- Policy 1: Allow authenticated users to INSERT (upload)
CREATE POLICY "silent-inspection-insert"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'silent-inspection-photos');

-- Policy 2: Allow public to SELECT (view/download)
CREATE POLICY "silent-inspection-select"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'silent-inspection-photos');

-- Policy 3: Allow authenticated users to UPDATE
CREATE POLICY "silent-inspection-update"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'silent-inspection-photos')
WITH CHECK (bucket_id = 'silent-inspection-photos');

-- Policy 4: Allow authenticated users to DELETE
CREATE POLICY "silent-inspection-delete"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'silent-inspection-photos');
