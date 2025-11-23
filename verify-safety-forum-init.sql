-- Verify safety_forum initialization is working correctly

-- Check array initialization (should not be NULL)
SELECT
  id,
  nomor_forum,
  CASE
    WHEN foto_forum IS NULL THEN 'NULL'
    WHEN array_length(foto_forum, 1) IS NULL THEN 'Empty Array'
    ELSE array_length(foto_forum, 1)::text
  END as foto_status,
  CASE
    WHEN dokumen_pendukung IS NULL THEN 'NULL'
    WHEN array_length(dokumen_pendukung, 1) IS NULL THEN 'Empty Array'
    ELSE array_length(dokumen_pendukung, 1)::text
  END as dokumen_status,
  CASE
    WHEN risiko_teridentifikasi IS NULL THEN 'NULL'
    WHEN jsonb_array_length(risiko_teridentifikasi) = 0 THEN 'Empty JSONB Array'
    ELSE jsonb_array_length(risiko_teridentifikasi)::text
  END as risiko_status,
  status
FROM safety_forum
ORDER BY created_at DESC
LIMIT 3;

-- Check actual array contents
SELECT
  id,
  nomor_forum,
  foto_forum,
  dokumen_pendukung,
  risiko_teridentifikasi,
  status
FROM safety_forum
WHERE id = '0253a239-7f3e-4636-a600-bc491eb00005';
