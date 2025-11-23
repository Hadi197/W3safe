-- Create visible test data with photos that will definitely show the icon
-- This will create a silent inspection record with actual photo URLs

-- Insert test silent inspection with photos
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
    (SELECT id FROM pegawai WHERE email = 'admin2@w3safe.com' LIMIT 1),
    'TEST AREA - DENGAN FOTO',
    '["Test checklist item 1", "Test checklist item 2"]'::jsonb,
    85.00,
    '[{"item": "Test finding 1", "severity": "minor"}, {"item": "Test finding 2", "severity": "major"}]'::jsonb,
    'Test recommendation - improve safety measures',
    'draft',
    (SELECT id FROM pegawai WHERE email = 'admin2@w3safe.com' LIMIT 1),
    '["https://via.placeholder.com/300x200/FF6B6B/FFFFFF?text=Kondisi+Unsafe+1", "https://via.placeholder.com/300x200/4ECDC4/FFFFFF?text=Kondisi+Unsafe+2"]'::jsonb,
    '["https://via.placeholder.com/300x200/45B7D1/FFFFFF?text=Perilaku+Unsafe+1"]'::jsonb,
    2,
    'sedang',
    85.00
);

-- Verify the record was created and has photos
SELECT 'Test record with photos:' as info;
SELECT
    id,
    area_inspeksi,
    created_at,
    CASE WHEN foto_kondisi_unsafe IS NOT NULL THEN jsonb_array_length(foto_kondisi_unsafe) ELSE 0 END as kondisi_photos,
    CASE WHEN foto_perilaku_unsafe IS NOT NULL THEN jsonb_array_length(foto_perilaku_unsafe) ELSE 0 END as perilaku_photos,
    foto_kondisi_unsafe,
    foto_perilaku_unsafe
FROM silent_inspection
WHERE area_inspeksi = 'TEST AREA - DENGAN FOTO'
ORDER BY created_at DESC
LIMIT 1;

-- Show all silent inspection records with photo counts
SELECT 'All records with photo counts:' as info;
SELECT
    id,
    area_inspeksi,
    created_at,
    CASE WHEN foto_kondisi_unsafe IS NOT NULL THEN jsonb_array_length(foto_kondisi_unsafe) ELSE 0 END as kondisi_photos,
    CASE WHEN foto_perilaku_unsafe IS NOT NULL THEN jsonb_array_length(foto_perilaku_unsafe) ELSE 0 END as perilaku_photos,
    CASE WHEN foto_kondisi_unsafe IS NOT NULL OR foto_perilaku_unsafe IS NOT NULL THEN 'HAS PHOTOS' ELSE 'NO PHOTOS' END as photo_status
FROM silent_inspection
ORDER BY created_at DESC;
