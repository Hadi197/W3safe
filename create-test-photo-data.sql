-- Create a test silent inspection record with photos to test the display
-- First, ensure we have the required foreign key data

-- Check existing data
SELECT 'Existing Units:' as info;
SELECT id, nama_unit, kode_unit FROM units LIMIT 3;

SELECT 'Existing Wilayah:' as info;
SELECT id, nama_wilayah FROM wilayah LIMIT 3;

SELECT 'Existing Pegawai:' as info;
SELECT id, nama_lengkap, nip FROM pegawai LIMIT 3;

-- Create test silent inspection with photos
INSERT INTO silent_inspection (
    tanggal, triwulan, tahun, unit_id, wilayah_id, inspector_id,
    area_inspeksi, checklist, skor_total, temuan, rekomendasi, status,
    created_by, foto_kondisi_unsafe, foto_perilaku_unsafe,
    jumlah_temuan, kategori_bahaya, skor_kepatuhan
) VALUES (
    CURRENT_DATE,
    EXTRACT(QUARTER FROM CURRENT_DATE),
    EXTRACT(YEAR FROM CURRENT_DATE),
    (SELECT id FROM units WHERE tipe = 'unit' LIMIT 1),
    (SELECT id FROM wilayah LIMIT 1),
    (SELECT id FROM pegawai WHERE nip = 'ADMIN002' LIMIT 1),
    'Area Produksi Test',
    '["Pengecekan APD", "Kondisi mesin", "Kebersihan area"]'::jsonb,
    75.00,
    '[{"item": "APD tidak lengkap", "severity": "minor"}, {"item": "Area kerja kotor", "severity": "major"}]'::jsonb,
    'Perbaiki penggunaan APD dan tingkatkan kebersihan area kerja',
    'draft',
    (SELECT id FROM pegawai WHERE nip = 'ADMIN002' LIMIT 1),
    '["https://example.com/test-photo-kondisi-1.jpg", "https://example.com/test-photo-kondisi-2.jpg"]'::jsonb,
    '["https://example.com/test-photo-perilaku-1.jpg"]'::jsonb,
    2,
    'sedang',
    75.00
) ON CONFLICT DO NOTHING;

-- Verify the test record was created
SELECT 'Test record created:' as info;
SELECT id, area_inspeksi, created_at,
       CASE WHEN foto_kondisi_unsafe IS NOT NULL THEN jsonb_array_length(foto_kondisi_unsafe) ELSE 0 END as kondisi_photos,
       CASE WHEN foto_perilaku_unsafe IS NOT NULL THEN jsonb_array_length(foto_perilaku_unsafe) ELSE 0 END as perilaku_photos,
       foto_kondisi_unsafe,
       foto_perilaku_unsafe
FROM silent_inspection
WHERE area_inspeksi = 'Area Produksi Test'
ORDER BY created_at DESC
LIMIT 1;
