-- Check if management_walkthrough table exists
SELECT
    CASE WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'management_walkthrough') THEN 'management_walkthrough table EXISTS' ELSE 'management_walkthrough table MISSING' END as table_status;

-- If table exists, show its structure
SELECT 'management_walkthrough table structure:' as info;
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'management_walkthrough'
ORDER BY ordinal_position;

-- Check all tables in database to see what's available
SELECT 'All tables in database:' as info;
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- Check if there are similar tables (maybe different name)
SELECT 'Tables with walkthrough in name:' as info;
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
  AND table_name ILIKE '%walkthrough%'
ORDER BY table_name;

-- Check if there are tables with management in name
SELECT 'Tables with management in name:' as info;
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
  AND table_name ILIKE '%management%'
ORDER BY table_name;
