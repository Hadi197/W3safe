-- Verify safety_briefing table structure and check for data
-- Run this in Supabase SQL Editor

-- Check table structure
SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'safety_briefing'
ORDER BY ordinal_position;

-- Check for existing data
SELECT COUNT(*) as total_records FROM safety_briefing;

-- Show sample data if exists
SELECT
    id,
    tanggal,
    area_briefing,
    topik_briefing,
    materi_briefing,
    jenis_briefing,
    status,
    created_at
FROM safety_briefing
ORDER BY created_at DESC
LIMIT 5;
