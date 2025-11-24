-- Check what the actual table name is (area or areas)
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name LIKE 'area%'
ORDER BY table_name;
