-- Update safety-forum-photos bucket to allow PDF files
UPDATE storage.buckets
SET allowed_mime_types = ARRAY[
  'image/jpeg',
  'image/jpg', 
  'image/png',
  'image/webp',
  'image/gif',
  'application/pdf'
]
WHERE id = 'safety-forum-photos';
