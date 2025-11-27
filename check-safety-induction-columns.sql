-- Check safety_induction columns
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'safety_induction'
  AND table_schema = 'public'
  AND (column_name ILIKE '%topik%' OR column_name ILIKE '%judul%' OR column_name ILIKE '%tema%' OR column_name ILIKE '%peserta%')
ORDER BY column_name;
