-- Check silent_inspection table structure
SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'silent_inspection'
ORDER BY ordinal_position;
