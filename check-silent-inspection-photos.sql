-- =====================================================
-- Check Silent Inspection Photos - December 05, 2025
-- =====================================================

-- 1. Cek semua data silent_inspection hari ini
SELECT 
    id,
    tanggal,
    area_inspeksi,
    foto_kondisi_unsafe,
    foto_perilaku_unsafe,
    array_length(foto_kondisi_unsafe, 1) as jumlah_foto_kondisi,
    array_length(foto_perilaku_unsafe, 1) as jumlah_foto_perilaku,
    created_at
FROM silent_inspection
WHERE tanggal = '2025-12-05'
ORDER BY created_at DESC;

-- 2. Cek struktur kolom tabel silent_inspection
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'silent_inspection'
    AND column_name LIKE '%foto%'
ORDER BY ordinal_position;

-- 3. Cek semua data dengan foto (tidak kosong)
SELECT 
    id,
    tanggal,
    area_inspeksi,
    foto_kondisi_unsafe,
    foto_perilaku_unsafe,
    array_length(foto_kondisi_unsafe, 1) as jumlah_foto_kondisi,
    array_length(foto_perilaku_unsafe, 1) as jumlah_foto_perilaku
FROM silent_inspection
WHERE foto_kondisi_unsafe IS NOT NULL 
   OR foto_perilaku_unsafe IS NOT NULL
ORDER BY tanggal DESC
LIMIT 10;

-- 4. Statistik foto per tanggal (7 hari terakhir)
SELECT 
    tanggal,
    COUNT(*) as total_records,
    COUNT(foto_kondisi_unsafe) as records_with_kondisi_photo,
    COUNT(foto_perilaku_unsafe) as records_with_perilaku_photo,
    SUM(array_length(foto_kondisi_unsafe, 1)) as total_kondisi_photos,
    SUM(array_length(foto_perilaku_unsafe, 1)) as total_perilaku_photos
FROM silent_inspection
WHERE tanggal >= '2025-11-28'
GROUP BY tanggal
ORDER BY tanggal DESC;

-- 5. Sample: Lihat isi array foto (jika ada)
SELECT 
    id,
    tanggal,
    foto_kondisi_unsafe[1] as first_kondisi_photo,
    foto_perilaku_unsafe[1] as first_perilaku_photo
FROM silent_inspection
WHERE tanggal = '2025-12-05'
LIMIT 5;
