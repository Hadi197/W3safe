-- Check if safety_patrol table exists
SELECT
    CASE WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'safety_patrol') THEN 'safety_patrol table EXISTS' ELSE 'safety_patrol table MISSING' END as table_status;

-- If table exists, show its structure
SELECT 'safety_patrol table structure:' as info;
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'safety_patrol'
ORDER BY ordinal_position;

-- Check all tables in database to see what's available
SELECT 'All tables in database:' as info;
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- Check if there are similar tables (maybe different name)
SELECT 'Tables with patrol in name:' as info;
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
  AND table_name ILIKE '%patrol%'
ORDER BY table_name;
