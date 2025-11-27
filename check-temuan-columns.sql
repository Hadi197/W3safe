-- Check if jumlah_temuan columns exist in all tables

-- Safety Patrol
SELECT 
    column_name, 
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'safety_patrol'
AND column_name IN ('jumlah_temuan', 'temuan_kritikal', 'temuan_mayor', 'temuan_minor', 'action_items')
ORDER BY column_name;

-- Management Walkthrough
SELECT 
    column_name, 
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'management_walkthrough'
AND column_name IN ('jumlah_temuan', 'temuan_kritis', 'temuan_mayor', 'temuan_minor', 'action_items')
ORDER BY column_name;

-- Silent Inspection
SELECT 
    column_name, 
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'silent_inspection'
AND column_name IN ('jumlah_temuan', 'temuan_critical', 'temuan_major', 'temuan_minor', 'tindak_lanjut')
ORDER BY column_name;

-- Safety Drill
SELECT 
    column_name, 
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'safety_drill'
AND column_name IN ('jumlah_temuan', 'temuan_kritis', 'temuan_mayor', 'temuan_minor', 'action_items')
ORDER BY column_name;

-- Safety Forum
SELECT 
    column_name, 
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'safety_forum'
AND column_name IN ('action_items')
ORDER BY column_name;
