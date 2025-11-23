-- Add sample data to silent_inspection table
-- Run this in Supabase SQL Editor

-- Create demo pegawai if not exists (this is crucial for silent inspection creation)
INSERT INTO pegawai (nama_lengkap, nip, email, jabatan, role, status)
VALUES ('Safety Inspector Demo', 'DEMO001', 'demo@safety.local', 'Safety Inspector', 'user', 'aktif')
ON CONFLICT (nip) DO NOTHING;

-- Verify demo user exists
SELECT id, nama_lengkap, nip, email, jabatan, role, status
FROM pegawai
WHERE nip = 'DEMO001';

-- Insert sample silent inspections
INSERT INTO silent_inspection (
    tanggal,
    triwulan,
    tahun,
    unit_id,
    wilayah_id,
    inspector_id,
    area_inspeksi,
    checklist,
    skor_total,
    temuan,
    rekomendasi,
    status,
    created_by
) VALUES
(
    CURRENT_DATE - INTERVAL '1 day',
    4,
    EXTRACT(YEAR FROM CURRENT_DATE),
    (SELECT id FROM units WHERE tipe = 'unit' LIMIT 1),
    (SELECT id FROM wilayah LIMIT 1),
    (SELECT id FROM pegawai WHERE nip = 'DEMO001'),
    'Area Produksi Line 1',
    '["Pengecekan APD", "Kondisi mesin", "Kebersihan area", "Ventilasi"]'::jsonb,
    85,
    '[{"item": "APD tidak lengkap", "severity": "minor"}, {"item": "Area kurang bersih", "severity": "minor"}]'::jsonb,
    'Perbaiki penggunaan APD dan tingkatkan kebersihan area kerja',
    'draft',
    (SELECT id FROM pegawai WHERE nip = 'DEMO001')
),
(
    CURRENT_DATE - INTERVAL '3 days',
    4,
    EXTRACT(YEAR FROM CURRENT_DATE),
    (SELECT id FROM units WHERE tipe = 'unit' LIMIT 1 OFFSET 1),
    (SELECT id FROM wilayah LIMIT 1),
    (SELECT id FROM pegawai WHERE nip = 'DEMO001'),
    'Gudang Bahan Baku',
    '["Safety signage", "Emergency exit", "Fire extinguisher", "First aid kit"]'::jsonb,
    92,
    '[{"item": "Signage kurang jelas", "severity": "minor"}]'::jsonb,
    'Perbaiki dan tambahkan signage yang lebih jelas di area gudang',
    'approved',
    (SELECT id FROM pegawai WHERE nip = 'DEMO001')
),
(
    CURRENT_DATE - INTERVAL '5 days',
    4,
    EXTRACT(YEAR FROM CURRENT_DATE),
    (SELECT id FROM units WHERE tipe = 'unit' LIMIT 1 OFFSET 2),
    (SELECT id FROM wilayah LIMIT 1),
    (SELECT id FROM pegawai WHERE nip = 'DEMO001'),
    'Loading Dock Area',
    '["Loading procedures", "Vehicle safety", "Ground conditions", "Lighting"]'::jsonb,
    78,
    '[{"item": "Pencahayaan kurang", "severity": "major"}, {"item": "Ground kondisi buruk", "severity": "major"}]'::jsonb,
    'Perbaiki sistem pencahayaan dan perbaiki kondisi lantai loading dock',
    'approved'
)
ON CONFLICT DO NOTHING;

-- Verify data was inserted
SELECT
    'Silent Inspections' as type,
    COUNT(*) as total_count,
    SUM(CASE WHEN status = 'approved' THEN 1 ELSE 0 END) as approved_count,
    SUM(CASE WHEN status = 'draft' THEN 1 ELSE 0 END) as draft_count,
    ROUND(AVG(skor_total), 1) as avg_score
FROM silent_inspection;

-- Show detailed data
SELECT
    si.id,
    si.tanggal,
    si.area_inspeksi,
    si.skor_total,
    si.status,
    p.nama_lengkap as inspector_nama,
    u.nama_unit as unit_nama,
    CASE WHEN si.temuan IS NOT NULL THEN jsonb_array_length(si.temuan) ELSE 0 END as temuan_count
FROM silent_inspection si
LEFT JOIN pegawai p ON si.inspector_id = p.id
LEFT JOIN units u ON si.unit_id = u.id
ORDER BY si.tanggal DESC;
