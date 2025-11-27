-- Check safety_forum columns for masalah_teridentifikasi
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'safety_forum'
  AND table_schema = 'public'
  AND (column_name ILIKE '%masalah%' OR column_name ILIKE '%tema%' OR column_name ILIKE '%action%')
ORDER BY column_name;

-- Check all columns in safety_forum
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'safety_forum'
  AND table_schema = 'public'
ORDER BY ordinal_position;
