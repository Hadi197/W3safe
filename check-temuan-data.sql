-- Check Temuan Data across all modules

-- 1. Safety Patrol
SELECT 
    'safety_patrol' as module,
    COUNT(*) as total_records,
    COUNT(jumlah_temuan) as has_jumlah_temuan,
    SUM(jumlah_temuan) as total_temuan,
    SUM(temuan_kritikal) as total_kritikal,
    SUM(temuan_mayor) as total_mayor,
    SUM(temuan_minor) as total_minor
FROM safety_patrol;

-- 2. Management Walkthrough
SELECT 
    'management_walkthrough' as module,
    COUNT(*) as total_records,
    COUNT(jumlah_temuan) as has_jumlah_temuan,
    SUM(jumlah_temuan) as total_temuan,
    SUM(temuan_kritis) as total_kritikal,
    SUM(temuan_mayor) as total_mayor,
    SUM(temuan_minor) as total_minor
FROM management_walkthrough;

-- 3. Silent Inspection
SELECT 
    'silent_inspection' as module,
    COUNT(*) as total_records,
    COUNT(jumlah_temuan) as has_jumlah_temuan,
    SUM(jumlah_temuan) as total_temuan,
    SUM(temuan_critical) as total_kritikal,
    SUM(temuan_major) as total_mayor,
    SUM(temuan_minor) as total_minor
FROM silent_inspection;

-- 4. Safety Drill
SELECT 
    'safety_drill' as module,
    COUNT(*) as total_records,
    COUNT(jumlah_temuan) as has_jumlah_temuan,
    SUM(jumlah_temuan) as total_temuan,
    SUM(temuan_kritis) as total_kritikal,
    SUM(temuan_mayor) as total_mayor,
    SUM(temuan_minor) as total_minor
FROM safety_drill;

-- 5. Safety Forum
SELECT 
    'safety_forum' as module,
    COUNT(*) as total_records,
    COUNT(action_items) as has_action_items,
    0 as total_temuan,
    0 as total_kritikal,
    0 as total_mayor,
    0 as total_minor
FROM safety_forum;

-- Detail sample data from each module
SELECT 'SAFETY PATROL SAMPLES:' as info;
SELECT 
    nomor_patrol,
    tanggal_patrol,
    jumlah_temuan,
    temuan_kritikal,
    temuan_mayor,
    temuan_minor,
    unit_id,
    status
FROM safety_patrol
LIMIT 5;

SELECT 'MANAGEMENT WALKTHROUGH SAMPLES:' as info;
SELECT 
    nomor_walkthrough,
    tanggal_walkthrough,
    jumlah_temuan,
    temuan_kritis,
    temuan_mayor,
    temuan_minor,
    unit_id,
    status
FROM management_walkthrough
LIMIT 5;

SELECT 'SILENT INSPECTION SAMPLES:' as info;
SELECT 
    nomor_inspeksi,
    tanggal_inspeksi,
    jumlah_temuan,
    temuan_critical,
    temuan_major,
    temuan_minor,
    unit_id,
    status
FROM silent_inspection
LIMIT 5;

SELECT 'SAFETY DRILL SAMPLES:' as info;
SELECT 
    nomor_drill,
    tanggal_drill,
    jumlah_temuan,
    temuan_kritis,
    temuan_mayor,
    temuan_minor,
    unit_id,
    status
FROM safety_drill
LIMIT 5;

SELECT 'SAFETY FORUM SAMPLES:' as info;
SELECT 
    nomor_forum,
    tanggal_pelaksanaan,
    jsonb_array_length(COALESCE(action_items, '[]'::jsonb)) as action_items_count,
    unit_id,
    status
FROM safety_forum
LIMIT 5;
