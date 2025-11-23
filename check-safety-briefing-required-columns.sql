-- Check which columns in safety_briefing are NOT NULL
SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'safety_briefing'
AND is_nullable = 'NO'
ORDER BY ordinal_position;

-- Check the current safety_briefing table structure
SELECT
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'safety_briefing'
ORDER BY ordinal_position;
