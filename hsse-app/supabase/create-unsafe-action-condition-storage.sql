-- Storage setup for unsafe-action-condition files
-- Run this in Supabase SQL Editor AFTER creating the bucket via Dashboard

-- Bucket name to create: unsafe-action-condition-files

-- 1. Allow authenticated users to INSERT (upload photos, videos, audio)
CREATE POLICY "Allow authenticated users to upload unsafe action condition files"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'unsafe-action-condition-files'
  AND (storage.foldername(name))[1] IN ('unsafe-action-condition-photos', 'unsafe-action-condition-videos', 'unsafe-action-condition-audio')
);

-- 2. Allow public to SELECT (read/view files)
CREATE POLICY "Allow public to read unsafe action condition files"
ON storage.objects FOR SELECT
TO public
USING (
  bucket_id = 'unsafe-action-condition-files'
);

-- 3. Allow authenticated users to UPDATE their files
CREATE POLICY "Allow authenticated users to update unsafe action condition files"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'unsafe-action-condition-files'
)
WITH CHECK (
  bucket_id = 'unsafe-action-condition-files'
);

-- 4. Allow authenticated users to DELETE their files
CREATE POLICY "Allow authenticated users to delete unsafe action condition files"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'unsafe-action-condition-files'
);

-- 5. Verification - Check policies
SELECT
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd
FROM pg_policies
WHERE tablename = 'objects'
  AND policyname LIKE '%unsafe-action-condition%';

-- 6. Update bucket to allow larger files and more MIME types
UPDATE storage.buckets
SET
  file_size_limit = 10485760, -- 10MB
  allowed_mime_types = ARRAY[
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
  ]
WHERE id = 'unsafe-action-condition-files';