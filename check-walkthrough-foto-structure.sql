-- CEK STRUKTUR DAN DATA FOTO DI MANAGEMENT WALKTHROUGH
-- Untuk debugging kenapa foto tidak muncul di UI

-- 1. CEK SEMUA KOLOM DI TABEL (PENTING!)
SELECT 
    column_name,
    data_type,
    character_maximum_length,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'management_walkthrough'
ORDER BY ordinal_position;

-- 2. Cek kolom yang mengandung kata 'foto' atau 'dokumentasi'
SELECT 
    column_name,
    data_type,
    character_maximum_length,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'management_walkthrough'
  AND (column_name LIKE '%foto%' OR column_name LIKE '%dokumentasi%')
ORDER BY ordinal_position;

-- 3. Cek sample data (tanpa asumsi nama kolom foto)
SELECT *
FROM management_walkthrough
WHERE EXTRACT(YEAR FROM tanggal_walkthrough) = 2025
  AND EXTRACT(MONTH FROM tanggal_walkthrough) = 11
ORDER BY tanggal_walkthrough DESC
LIMIT 1;

-- 3. Cek sample data (tanpa asumsi nama kolom foto)
SELECT *
FROM management_walkthrough
WHERE EXTRACT(YEAR FROM tanggal_walkthrough) = 2025
  AND EXTRACT(MONTH FROM tanggal_walkthrough) = 11
ORDER BY tanggal_walkthrough DESC
LIMIT 1;

-- 4. Cek tipe data kolom catatan/evaluasi/rekomendasi/temuan
SELECT 
    column_name,
    data_type,
    udt_name
FROM information_schema.columns
WHERE table_name = 'management_walkthrough'
  AND (column_name LIKE '%catatan%' 
    OR column_name LIKE '%evaluasi%' 
    OR column_name LIKE '%rekomendasi%' 
    OR column_name LIKE '%temuan%')
ORDER BY ordinal_position;
