-- Check the actual columns in the wilayah table
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'wilayah' 
ORDER BY ordinal_position;
