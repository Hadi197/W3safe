-- Check if there are any silent inspection records with photos
SELECT 'Silent Inspection with Photos:' as info;
SELECT id, area_inspeksi, created_at,
       CASE WHEN foto_kondisi_unsafe IS NOT NULL THEN jsonb_array_length(foto_kondisi_unsafe) ELSE 0 END as kondisi_unsafe_count,
       CASE WHEN foto_perilaku_unsafe IS NOT NULL THEN jsonb_array_length(foto_perilaku_unsafe) ELSE 0 END as perilaku_unsafe_count,
       foto_kondisi_unsafe,
       foto_perilaku_unsafe
FROM silent_inspection
WHERE foto_kondisi_unsafe IS NOT NULL OR foto_perilaku_unsafe IS NOT NULL
ORDER BY created_at DESC;

-- Check recent silent inspections (even without photos)
SELECT 'Recent Silent Inspections:' as info;
SELECT id, area_inspeksi, temuan, created_at,
       CASE WHEN foto_kondisi_unsafe IS NOT NULL THEN jsonb_array_length(foto_kondisi_unsafe) ELSE 0 END as kondisi_photos,
       CASE WHEN foto_perilaku_unsafe IS NOT NULL THEN jsonb_array_length(foto_perilaku_unsafe) ELSE 0 END as perilaku_photos
FROM silent_inspection
ORDER BY created_at DESC
LIMIT 5;

-- Check storage bucket for uploaded photos
SELECT 'Storage Objects:' as info;
SELECT name, created_at, metadata
FROM storage.objects
WHERE bucket_id = 'silent-inspection-photos'
ORDER BY created_at DESC
LIMIT 10;
