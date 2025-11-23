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
