-- Check actual columns in safety_drill table
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'safety_drill' 
ORDER BY ordinal_position;

-- Check actual columns in silent_inspection table  
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'silent_inspection' 
ORDER BY ordinal_position;
