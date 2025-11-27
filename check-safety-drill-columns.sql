-- Check if foto_dokumentasi column exists in safety_drill table
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'safety_drill'
  AND table_schema = 'public'
ORDER BY ordinal_position;

-- Check for evaluation-related columns
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'safety_drill'
  AND table_schema = 'public'
  AND (column_name ILIKE '%eval%' OR column_name ILIKE '%review%' OR column_name ILIKE '%temuan%' OR column_name ILIKE '%rekomendasi%')
ORDER BY column_name;
