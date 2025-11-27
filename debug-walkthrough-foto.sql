-- =====================================================
-- DEBUG: CEK FOTO DI MANAGEMENT WALKTHROUGH
-- Untuk laporan di Monitoring Realisasi K3
-- =====================================================

-- 1. CEK SEMUA KOLOM DI TABEL management_walkthrough
SELECT 
    column_name,
    data_type,
    udt_name,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'management_walkthrough'
ORDER BY ordinal_position;

-- 2. CEK KOLOM YANG BERISI FOTO/DOKUMENTASI
SELECT 
    column_name,
    data_type,
    udt_name
FROM information_schema.columns
WHERE table_name = 'management_walkthrough'
  AND (column_name LIKE '%foto%' 
    OR column_name LIKE '%dokumentasi%' 
    OR column_name LIKE '%temuan%')
ORDER BY ordinal_position;

-- 3. CEK DATA NOVEMBER 2025 - LIHAT KOLOM PENTING
SELECT 
    id,
    nomor_walkthrough,
    tanggal_walkthrough,
    area_inspeksi,
    
    -- Kolom temuan (bisa berisi foto di dalam JSON)
    temuan_bahaya,
    
    -- Kolom foto array (jika ada)
    foto_walkthrough,
    
    -- Metadata
    created_at
FROM management_walkthrough
WHERE EXTRACT(YEAR FROM tanggal_walkthrough) = 2025
  AND EXTRACT(MONTH FROM tanggal_walkthrough) = 11
ORDER BY tanggal_walkthrough DESC;

-- 4. CEK STRUKTUR JSON TEMUAN_BAHAYA (jika ada)
SELECT 
    id,
    nomor_walkthrough,
    tanggal_walkthrough,
    
    -- Extract temuan_bahaya sebagai JSON
    temuan_bahaya::text as temuan_json,
    
    -- Coba extract foto_urls dari dalam temuan_bahaya
    jsonb_array_length(COALESCE(temuan_bahaya, '[]'::jsonb)) as jumlah_temuan
FROM management_walkthrough
WHERE EXTRACT(YEAR FROM tanggal_walkthrough) = 2025
  AND EXTRACT(MONTH FROM tanggal_walkthrough) = 11
  AND temuan_bahaya IS NOT NULL
ORDER BY tanggal_walkthrough DESC;

-- 5. CEK DETAIL ISI TEMUAN_BAHAYA (struktur nested)
SELECT 
    id,
    nomor_walkthrough,
    tanggal_walkthrough,
    
    -- Extract each temuan item
    jsonb_array_elements(COALESCE(temuan_bahaya, '[]'::jsonb)) as temuan_item
FROM management_walkthrough
WHERE EXTRACT(YEAR FROM tanggal_walkthrough) = 2025
  AND EXTRACT(MONTH FROM tanggal_walkthrough) = 11
  AND temuan_bahaya IS NOT NULL
LIMIT 5;

-- 6. CEK FOTO URLS DI DALAM TEMUAN_BAHAYA
SELECT 
    id,
    nomor_walkthrough,
    tanggal_walkthrough,
    
    -- Extract foto_urls dari setiap temuan
    temuan_item->>'deskripsi' as deskripsi_temuan,
    temuan_item->'foto_urls' as foto_urls_array,
    jsonb_array_length(COALESCE(temuan_item->'foto_urls', '[]'::jsonb)) as jumlah_foto
FROM management_walkthrough,
     jsonb_array_elements(COALESCE(temuan_bahaya, '[]'::jsonb)) as temuan_item
WHERE EXTRACT(YEAR FROM tanggal_walkthrough) = 2025
  AND EXTRACT(MONTH FROM tanggal_walkthrough) = 11
  AND temuan_bahaya IS NOT NULL;

-- 7. CEK SAMPLE DATA LENGKAP (1 RECORD TERBARU)
SELECT *
FROM management_walkthrough
WHERE EXTRACT(YEAR FROM tanggal_walkthrough) = 2025
  AND EXTRACT(MONTH FROM tanggal_walkthrough) = 11
ORDER BY tanggal_walkthrough DESC
LIMIT 1;

-- 8. RINGKASAN: BERAPA WALKTHROUGH YANG PUNYA FOTO
SELECT 
    COUNT(*) as total_walkthrough,
    COUNT(foto_walkthrough) as punya_foto_walkthrough,
    COUNT(temuan_bahaya) as punya_temuan_bahaya,
    
    -- Hitung yang punya foto di temuan
    COUNT(CASE 
        WHEN temuan_bahaya IS NOT NULL 
        AND jsonb_array_length(temuan_bahaya) > 0 
        THEN 1 
    END) as punya_temuan_dengan_data
FROM management_walkthrough
WHERE EXTRACT(YEAR FROM tanggal_walkthrough) = 2025
  AND EXTRACT(MONTH FROM tanggal_walkthrough) = 11;

-- 9. LIST SEMUA FOTO URLs YANG ADA (untuk testing)
SELECT 
    id,
    nomor_walkthrough,
    tanggal_walkthrough,
    
    -- Jika foto_walkthrough adalah array
    CASE 
        WHEN foto_walkthrough IS NOT NULL THEN foto_walkthrough
        ELSE NULL
    END as foto_walkthrough_array,
    
    -- Extract foto dari temuan_bahaya
    (
        SELECT jsonb_agg(foto_url)
        FROM management_walkthrough mw,
             jsonb_array_elements(COALESCE(mw.temuan_bahaya, '[]'::jsonb)) as temuan,
             jsonb_array_elements_text(COALESCE(temuan->'foto_urls', '[]'::jsonb)) as foto_url
        WHERE mw.id = management_walkthrough.id
    ) as foto_dari_temuan
FROM management_walkthrough
WHERE EXTRACT(YEAR FROM tanggal_walkthrough) = 2025
  AND EXTRACT(MONTH FROM tanggal_walkthrough) = 11
ORDER BY tanggal_walkthrough DESC;

-- =====================================================
-- QUERY UNTUK PERBAIKAN DI CODE
-- =====================================================

-- 10. QUERY YANG HARUS DIGUNAKAN DI ProgramK3DashboardView.vue
-- Untuk mengambil data dengan foto yang benar
SELECT 
    mw.*,
    units.nama as unit_name,
    
    -- Extract foto dari temuan_bahaya (array of arrays)
    (
        SELECT jsonb_agg(DISTINCT foto_url)
        FROM jsonb_array_elements(COALESCE(mw.temuan_bahaya, '[]'::jsonb)) as temuan,
             jsonb_array_elements_text(COALESCE(temuan->'foto_urls', '[]'::jsonb)) as foto_url
    ) as all_foto_urls,
    
    -- Get first 3 photos for display
    (
        SELECT jsonb_array_elements_text(temuan->'foto_urls')
        FROM jsonb_array_elements(COALESCE(mw.temuan_bahaya, '[]'::jsonb)) as temuan
        WHERE jsonb_array_length(COALESCE(temuan->'foto_urls', '[]'::jsonb)) > 0
        LIMIT 1
        OFFSET 0
    ) as foto_1,
    
    (
        SELECT jsonb_array_elements_text(temuan->'foto_urls')
        FROM jsonb_array_elements(COALESCE(mw.temuan_bahaya, '[]'::jsonb)) as temuan
        WHERE jsonb_array_length(COALESCE(temuan->'foto_urls', '[]'::jsonb)) > 0
        LIMIT 1
        OFFSET 1
    ) as foto_2,
    
    (
        SELECT jsonb_array_elements_text(temuan->'foto_urls')
        FROM jsonb_array_elements(COALESCE(mw.temuan_bahaya, '[]'::jsonb)) as temuan
        WHERE jsonb_array_length(COALESCE(temuan->'foto_urls', '[]'::jsonb)) > 0
        LIMIT 1
        OFFSET 2
    ) as foto_3
    
FROM management_walkthrough mw
LEFT JOIN units ON mw.unit_id = units.id
WHERE EXTRACT(YEAR FROM mw.tanggal_walkthrough) = 2025
  AND EXTRACT(MONTH FROM mw.tanggal_walkthrough) = 11
ORDER BY mw.tanggal_walkthrough DESC;
