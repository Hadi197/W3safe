-- Check silent_inspection table structure
SELECT 'silent_inspection table structure:' as info;
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'silent_inspection'
ORDER BY ordinal_position;

-- Check if temuan column exists
SELECT 
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'silent_inspection' AND column_name = 'temuan'
    ) THEN 'temuan column EXISTS' ELSE 'temuan column MISSING' END as temuan_status;

-- Check all columns in silent_inspection table
SELECT 'All columns in silent_inspection:' as info;
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'silent_inspection'
ORDER BY column_name;
