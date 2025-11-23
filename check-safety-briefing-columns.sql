-- Check exact column names in safety_briefing table
SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'safety_briefing'
ORDER BY ordinal_position;
