-- Verify that sample data was successfully inserted
-- Run this in Supabase SQL Editor

-- Check demo pegawai
SELECT 'Demo Pegawai' as type, nama_lengkap, nip, jabatan, role, status
FROM pegawai
WHERE nip = 'DEMO001';

-- Check safety briefings
SELECT
    'Safety Briefings' as type,
    COUNT(*) as total_count,
    SUM(CASE WHEN status = 'approved' THEN 1 ELSE 0 END) as approved_count,
    SUM(CASE WHEN status = 'draft' THEN 1 ELSE 0 END) as draft_count
FROM safety_briefing;

-- Show detailed safety briefing data
SELECT
    sb.id,
    sb.tanggal,
    sb.waktu_mulai,
    sb.topik,
    sb.status,
    p.nama_lengkap as petugas_nama,
    u.nama_unit as unit_nama
FROM safety_briefing sb
LEFT JOIN pegawai p ON sb.petugas_id = p.id
LEFT JOIN units u ON sb.unit_id = u.id
ORDER BY sb.tanggal DESC;

-- Check total counts
SELECT
    'Summary' as info,
    (SELECT COUNT(*) FROM pegawai WHERE nip = 'DEMO001') as demo_pegawai_count,
    (SELECT COUNT(*) FROM safety_briefing) as safety_briefing_count,
    (SELECT COUNT(*) FROM units WHERE tipe = 'unit') as unit_count;
