-- Check area table columns
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'area' 
ORDER BY ordinal_position;

-- Check units table columns
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'units' 
ORDER BY ordinal_position;
