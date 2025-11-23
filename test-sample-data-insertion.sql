-- Test the sample data insertion
-- Run this in Supabase SQL Editor after running the main sample data script

-- Check if demo pegawai was created
SELECT id, nama_lengkap, nip, jabatan, role, status
FROM pegawai
WHERE nip = 'DEMO001';

-- Check if safety briefings were inserted
SELECT
    sb.id,
    sb.tanggal,
    sb.topik_briefing,
    sb.status,
    p.nama_lengkap as petugas_nama,
    u.nama_unit as unit_nama
FROM safety_briefing sb
LEFT JOIN pegawai p ON sb.petugas_id = p.id
LEFT JOIN units u ON sb.unit_id = u.id
ORDER BY sb.tanggal DESC;

-- Summary counts
SELECT
    'Total Safety Briefings' as metric,
    COUNT(*) as count
FROM safety_briefing
UNION ALL
SELECT
    'Approved Briefings' as metric,
    COUNT(*) as count
FROM safety_briefing
WHERE status = 'approved'
UNION ALL
SELECT
    'Draft Briefings' as metric,
    COUNT(*) as count
FROM safety_briefing
WHERE status = 'draft';
