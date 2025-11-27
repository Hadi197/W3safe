-- CEK STATISTIK SEMUA MODUL UNTUK TABEL REKAP IMPLEMENTASI K3L
-- Struktur tabel: NO, KEGIATAN, DOKUMENTASI, URAIAN (Hari/Tgl, Jam, Pimpinan, Peserta, Tempat, Keterangan)

-- ===================================
-- 1. SAFETY BRIEFING
-- ===================================
SELECT 
  '1. SAFETY BRIEFING' as modul,
  COUNT(*) as total_data,
  COUNT(CASE WHEN tanggal IS NOT NULL THEN 1 END) as ada_tanggal,
  COUNT(CASE WHEN waktu_mulai IS NOT NULL THEN 1 END) as ada_jam,
  COUNT(CASE WHEN petugas_id IS NOT NULL THEN 1 END) as ada_pimpinan,
  COUNT(CASE WHEN jumlah_peserta > 0 THEN 1 END) as ada_peserta,
  COUNT(CASE WHEN lokasi IS NOT NULL THEN 1 END) as ada_tempat,
  COUNT(CASE WHEN foto_dokumentasi IS NOT NULL AND array_length(foto_dokumentasi, 1) > 0 THEN 1 END) as ada_foto,
  COUNT(CASE WHEN topik IS NOT NULL THEN 1 END) as ada_kegiatan_topik,
  COUNT(CASE WHEN catatan IS NOT NULL THEN 1 END) as ada_keterangan
FROM safety_briefing
WHERE EXTRACT(YEAR FROM tanggal) = 2024

-- SKIP SAFETY INDUCTION - Tabel belum tersedia atau struktur berbeda

-- SKIP SAFETY FORUM - Tabel belum tersedia atau struktur berbeda  

-- SKIP MANAGEMENT WALKTHROUGH - Tabel belum tersedia atau struktur berbeda

-- SKIP SAFETY PATROL - Tabel belum tersedia atau struktur berbeda

UNION ALL

-- ===================================
-- 6. SAFETY DRILL
-- ===================================
SELECT 
  '6. SAFETY DRILL' as modul,
  COUNT(*) as total_data,
  COUNT(CASE WHEN tanggal_drill IS NOT NULL THEN 1 END) as ada_tanggal,
  COUNT(CASE WHEN waktu_mulai IS NOT NULL THEN 1 END) as ada_jam,
  COUNT(CASE WHEN drill_commander IS NOT NULL THEN 1 END) as ada_pimpinan,
  COUNT(CASE WHEN jumlah_peserta > 0 THEN 1 END) as ada_peserta,
  COUNT(CASE WHEN area_lokasi IS NOT NULL THEN 1 END) as ada_tempat,
  0 as ada_foto,
  COUNT(CASE WHEN tujuan_drill IS NOT NULL THEN 1 END) as ada_kegiatan_topik,
  0 as ada_keterangan
FROM safety_drill
WHERE EXTRACT(YEAR FROM tanggal_drill) = 2024

UNION ALL

-- ===================================
-- 7. SILENT INSPECTION
-- ===================================
SELECT 
  '7. SILENT INSPECTION' as modul,
  COUNT(*) as total_data,
  COUNT(CASE WHEN tanggal IS NOT NULL THEN 1 END) as ada_tanggal,
  0 as ada_jam,
  COUNT(CASE WHEN inspector_id IS NOT NULL THEN 1 END) as ada_pimpinan,
  0 as ada_peserta,
  COUNT(CASE WHEN area_inspeksi IS NOT NULL THEN 1 END) as ada_tempat,
  0 as ada_foto,
  COUNT(CASE WHEN rekomendasi IS NOT NULL THEN 1 END) as ada_kegiatan_topik,
  0 as ada_keterangan
FROM silent_inspection
WHERE EXTRACT(YEAR FROM tanggal) = 2024

ORDER BY modul;
