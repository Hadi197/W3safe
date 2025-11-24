-- Check safety_induction table structure for NOT NULL columns
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'safety_induction'
  AND table_schema = 'public'
  AND is_nullable = 'NO'
ORDER BY ordinal_position;
