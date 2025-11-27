-- Check actual column names for problem tables

-- Management Walkthrough - check for 'lokasi' vs 'area_inspeksi'
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'management_walkthrough' 
  AND column_name IN ('lokasi', 'area_inspeksi', 'area_walkthrough')
ORDER BY column_name;

-- Silent Inspection - check for 'tindak_lanjut'
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'silent_inspection' 
  AND column_name LIKE '%tindak%'
ORDER BY column_name;

-- Safety Drill - check for 'temuan_kritis' vs 'temuan_kritikal'
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'safety_drill' 
  AND column_name LIKE '%temuan%'
ORDER BY column_name;

-- Get all columns for each table
SELECT 'management_walkthrough' as table_name, column_name 
FROM information_schema.columns 
WHERE table_name = 'management_walkthrough'
ORDER BY ordinal_position
LIMIT 30;

SELECT 'silent_inspection' as table_name, column_name 
FROM information_schema.columns 
WHERE table_name = 'silent_inspection'
ORDER BY ordinal_position
LIMIT 30;

SELECT 'safety_drill' as table_name, column_name 
FROM information_schema.columns 
WHERE table_name = 'safety_drill'
ORDER BY ordinal_position
LIMIT 30;
