-- Check actual column names in all tables

-- Safety Patrol columns
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'safety_patrol'
AND column_name LIKE '%patrol%' OR column_name LIKE '%temuan%'
ORDER BY ordinal_position;

-- Management Walkthrough columns  
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'management_walkthrough'
AND (column_name LIKE '%walkthrough%' OR column_name LIKE '%temuan%' OR column_name LIKE '%area%')
ORDER BY ordinal_position;

-- Silent Inspection columns
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'silent_inspection'
AND (column_name LIKE '%inspect%' OR column_name LIKE '%temuan%' OR column_name LIKE '%nomor%')
ORDER BY ordinal_position;

-- Safety Drill columns
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'safety_drill'
AND (column_name LIKE '%drill%' OR column_name LIKE '%temuan%')
ORDER BY ordinal_position;

-- Safety Forum columns
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'safety_forum'
AND (column_name LIKE '%forum%' OR column_name LIKE '%tanggal%' OR column_name LIKE '%action%')
ORDER BY ordinal_position;
