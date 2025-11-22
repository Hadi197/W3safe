-- Storage policies for safety-forum-photos bucket
-- Jalankan SQL ini untuk setup policies

-- Drop existing policies if exists (ignore errors)
DROP POLICY IF EXISTS "safety_forum_upload" ON storage.objects;
DROP POLICY IF EXISTS "safety_forum_read" ON storage.objects;
DROP POLICY IF EXISTS "safety_forum_delete" ON storage.objects;
DROP POLICY IF EXISTS "safety_forum_update" ON storage.objects;

-- Policy 1: Allow ALL users (authenticated + anon) to upload files
CREATE POLICY "safety_forum_upload"
ON storage.objects
FOR INSERT
WITH CHECK (bucket_id = 'safety-forum-photos');

-- Policy 2: Allow public read access
CREATE POLICY "safety_forum_read"
ON storage.objects
FOR SELECT
USING (bucket_id = 'safety-forum-photos');

-- Policy 3: Allow ALL users to delete
CREATE POLICY "safety_forum_delete"
ON storage.objects
FOR DELETE
USING (bucket_id = 'safety-forum-photos');

-- Policy 4: Allow ALL users to update
CREATE POLICY "safety_forum_update"
ON storage.objects
FOR UPDATE
USING (bucket_id = 'safety-forum-photos')
WITH CHECK (bucket_id = 'safety-forum-photos');
