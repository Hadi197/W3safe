-- Check if foto_dokumentasi column exists in safety_drill table
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'safety_drill'
  AND table_schema = 'public'
ORDER BY ordinal_position;
