-- Add sample data to safety_briefing table
-- Run this in Supabase SQL Editor

-- Step 1: Create demo pegawai
INSERT INTO pegawai (nama_lengkap, nip, email, jabatan, role, status)
VALUES ('Safety Inspector Demo', 'DEMO001', 'demo@safety.local', 'Safety Inspector', 'user', 'aktif')
ON CONFLICT (nip) DO NOTHING;

-- Step 2: Insert first safety briefing (include created_by)
INSERT INTO safety_briefing (
    tanggal, waktu_mulai, waktu_selesai, unit_id, petugas_id,
    topik, materi, status, created_by
) VALUES (
    CURRENT_DATE,
    '08:00:00',
    '08:30:00',
    (SELECT id FROM units WHERE tipe = 'unit' LIMIT 1),
    (SELECT id FROM pegawai WHERE nip = 'DEMO001'),
    'Bahaya Listrik di Area Kerja',
    'Penjelasan mengenai bahaya listrik',
    'approved',
    (SELECT id FROM pegawai WHERE nip = 'DEMO001') -- created_by same as petugas
);

-- Step 3: Insert second safety briefing
INSERT INTO safety_briefing (
    tanggal, waktu_mulai, waktu_selesai, unit_id, petugas_id,
    topik, materi, status, created_by
) VALUES (
    CURRENT_DATE - INTERVAL '1 day',
    '07:30:00',
    '08:00:00',
    (SELECT id FROM units WHERE tipe = 'unit' LIMIT 1 OFFSET 1),
    (SELECT id FROM pegawai WHERE nip = 'DEMO001'),
    'Penggunaan APD yang Benar',
    'Panduan lengkap penggunaan APD',
    'approved',
    (SELECT id FROM pegawai WHERE nip = 'DEMO001')
);

-- Step 4: Insert third safety briefing
INSERT INTO safety_briefing (
    tanggal, waktu_mulai, unit_id, petugas_id,
    topik, materi, status, created_by
) VALUES (
    CURRENT_DATE - INTERVAL '2 days',
    '08:00:00',
    (SELECT id FROM units WHERE tipe = 'unit' LIMIT 1 OFFSET 2),
    (SELECT id FROM pegawai WHERE nip = 'DEMO001'),
    'Prosedur Evakuasi Darurat',
    'Simulasi evakuasi darurat',
    'draft',
    (SELECT id FROM pegawai WHERE nip = 'DEMO001')
);

-- Verify data was inserted
SELECT
    COUNT(*) as total_briefings,
    COUNT(CASE WHEN status = 'approved' THEN 1 END) as approved_count,
    COUNT(CASE WHEN status = 'draft' THEN 1 END) as draft_count
FROM safety_briefing;

-- Show the inserted data
SELECT
    sb.id,
    sb.tanggal,
    sb.waktu_mulai,
    sb.area_briefing,
    sb.topik_briefing,
    sb.jenis_briefing,
    sb.jumlah_peserta,
    sb.status,
    u.nama_unit as unit_name
FROM safety_briefing sb
LEFT JOIN units u ON sb.unit_id = u.id
ORDER BY sb.tanggal DESC, sb.waktu_mulai DESC;
