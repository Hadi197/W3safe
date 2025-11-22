-- Setup Storage Policies for safety-briefing-photos bucket
-- Run this in Supabase SQL Editor AFTER creating the bucket

-- 1. Allow authenticated users to INSERT (upload)
CREATE POLICY "Allow authenticated users to upload safety briefing photos"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'safety-briefing-photos'
);

-- 2. Allow public to SELECT (read/view)
CREATE POLICY "Allow public to read safety briefing photos"
ON storage.objects FOR SELECT
TO public
USING (
  bucket_id = 'safety-briefing-photos'
);

-- 3. Allow authenticated users to UPDATE
CREATE POLICY "Allow authenticated users to update safety briefing photos"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'safety-briefing-photos'
)
WITH CHECK (
  bucket_id = 'safety-briefing-photos'
);

-- 4. Allow authenticated users to DELETE
CREATE POLICY "Allow authenticated users to delete safety briefing photos"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'safety-briefing-photos'
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
  AND policyname LIKE '%safety-briefing-photos%';
