-- Check management_walkthrough table structure and units relationship
SELECT
    CASE WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'management_walkthrough') THEN 'management_walkthrough table EXISTS' ELSE 'management_walkthrough table MISSING' END as walkthrough_table_status;

-- Check management_walkthrough table columns
SELECT 'management_walkthrough columns:' as info;
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'management_walkthrough' ORDER BY ordinal_position;

-- Check if unit_id column exists in management_walkthrough
SELECT
    CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'management_walkthrough' AND column_name = 'unit_id') THEN 'unit_id column EXISTS' ELSE 'unit_id column MISSING' END as unit_id_status;

-- Check foreign key constraints for management_walkthrough
SELECT
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
  AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
  AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_name = 'management_walkthrough';

-- Check sample data
SELECT 'Sample management_walkthrough data:' as info;
SELECT id, nomor_walkthrough, unit_id, tanggal_walkthrough FROM management_walkthrough LIMIT 3;

-- Check if unit_id values exist in units table
SELECT
    COUNT(*) as total_walkthroughs,
    COUNT(CASE WHEN mw.unit_id IS NOT NULL THEN 1 END) as walkthroughs_with_unit_id,
    COUNT(CASE WHEN mw.unit_id IS NOT NULL AND u.id IS NOT NULL THEN 1 END) as valid_unit_references
FROM management_walkthrough mw
LEFT JOIN units u ON mw.unit_id = u.id;
