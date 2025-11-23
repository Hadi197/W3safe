-- Check safety_briefing table structure
-- Verify if foto_dokumentasi column exists

-- Check if table exists
SELECT
    schemaname,
    tablename,
    tableowner
FROM pg_tables
WHERE tablename = 'safety_briefing';

-- Check table columns
SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'safety_briefing'
ORDER BY ordinal_position;

-- Check if foto_dokumentasi column exists specifically
SELECT
    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'safety_briefing' AND column_name = 'foto_dokumentasi'
    ) THEN 'foto_dokumentasi column EXISTS' ELSE 'foto_dokumentasi column DOES NOT EXIST' END as foto_dokumentasi_check,

    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'safety_briefing' AND column_name = 'catatan'
    ) THEN 'catatan column EXISTS' ELSE 'catatan column DOES NOT EXIST' END as catatan_check,

    CASE WHEN EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'safety_briefing' AND column_name = 'jumlah_peserta'
    ) THEN 'jumlah_peserta column EXISTS' ELSE 'jumlah_peserta column DOES NOT EXIST' END as jumlah_peserta_check;

-- Check sample data
SELECT * FROM safety_briefing LIMIT 3;

-- Compare with expected schema
SELECT
    'Expected in create-safety-briefing-table.sql' as source,
    'foto_dokumentasi, catatan, jumlah_peserta' as expected_columns,
    CASE
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'safety_briefing' AND column_name = 'foto_dokumentasi') THEN 'EXISTS'
        ELSE 'MISSING'
    END as foto_dokumentasi_status,
    CASE
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'safety_briefing' AND column_name = 'catatan') THEN 'EXISTS'
        ELSE 'MISSING'
    END as catatan_status,
    CASE
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'safety_briefing' AND column_name = 'jumlah_peserta') THEN 'EXISTS'
        ELSE 'MISSING'
    END as jumlah_peserta_status;

-- Check what columns actually exist vs what API expects
SELECT
    column_name,
    CASE
        WHEN column_name IN ('id', 'tanggal', 'waktu_mulai', 'waktu_selesai', 'unit_id', 'petugas_id', 'topik', 'materi', 'status', 'created_at', 'updated_at') THEN 'USED by API'
        WHEN column_name IN ('jumlah_peserta', 'foto_dokumentasi', 'catatan') THEN 'EXPECTED by API - MISSING'
        WHEN column_name IN ('foto_briefing') THEN 'EXISTS but API expects foto_dokumentasi'
        ELSE 'EXTRA column'
    END as api_compatibility
FROM information_schema.columns
WHERE table_name = 'safety_briefing'
ORDER BY
    CASE
        WHEN column_name IN ('jumlah_peserta', 'foto_dokumentasi', 'catatan') THEN 1
        WHEN column_name IN ('foto_briefing') THEN 2
        ELSE 3
    END,
    column_name;
