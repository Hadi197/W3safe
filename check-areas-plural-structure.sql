-- Check the actual columns in the areas table (plural)
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'areas' 
ORDER BY ordinal_position;
