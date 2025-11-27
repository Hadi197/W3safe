-- CEK SEMUA MODUL UNTUK TABEL REKAP IMPLEMENTASI K3L
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


-- ===================================
-- DETAIL DATA SAMPLE (AMBIL 3 DATA PER MODUL)
-- ===================================

-- SAFETY BRIEFING
SELECT 
  'SAFETY BRIEFING' as modul,
  topik as kegiatan,
  CASE WHEN foto_dokumentasi IS NOT NULL AND array_length(foto_dokumentasi, 1) > 0 
       THEN 'Ada (' || array_length(foto_dokumentasi, 1) || ' foto)'
       ELSE 'Tidak Ada' END as dokumentasi,
  to_char(tanggal, 'Day, DD Mon YYYY') as hari_tanggal,
  to_char(waktu_mulai, 'HH24:MI') as jam,
  p.nama as pimpinan,
  COALESCE(jumlah_peserta, 0) as peserta,
  COALESCE(lokasi, '-') as tempat,
  COALESCE(catatan, '-') as keterangan
FROM safety_briefing sb
LEFT JOIN pegawai p ON sb.petugas_id = p.id
WHERE EXTRACT(YEAR FROM tanggal) = 2024
ORDER BY tanggal DESC
LIMIT 3;

-- SKIP SAFETY INDUCTION - Query detail tidak dijalankan

-- SKIP SAFETY FORUM - Query detail tidak dijalankan

-- SKIP MANAGEMENT WALKTHROUGH - Query detail tidak dijalankan

-- SKIP SAFETY PATROL - Query detail tidak dijalankan

-- SAFETY DRILL
SELECT 
  'SAFETY DRILL' as modul,
  tujuan_drill as kegiatan,
  'Tidak Ada' as dokumentasi,
  to_char(tanggal_drill, 'Day, DD Mon YYYY') as hari_tanggal,
  to_char(waktu_mulai, 'HH24:MI') as jam,
  drill_commander as pimpinan,
  COALESCE(jumlah_peserta, 0) as peserta,
  area_lokasi as tempat,
  '-' as keterangan
FROM safety_drill
WHERE EXTRACT(YEAR FROM tanggal_drill) = 2024
ORDER BY tanggal_drill DESC
LIMIT 3;

-- SILENT INSPECTION
SELECT 
  'SILENT INSPECTION' as modul,
  COALESCE('Silent Inspection - ' || area_inspeksi, 'Silent Inspection') as kegiatan,
  'Tidak Ada' as dokumentasi,
  to_char(tanggal, 'Day, DD Mon YYYY') as hari_tanggal,
  '-' as jam,
  p.nama as pimpinan,
  0 as peserta,
  area_inspeksi as tempat,
  CASE WHEN si.status = 'draft' THEN 'Draft'
       WHEN si.status = 'approved' THEN 'Approved'
       WHEN si.status = 'closed' THEN 'Closed'
       ELSE '-' END as keterangan
FROM silent_inspection si
LEFT JOIN pegawai p ON si.inspector_id = p.id
WHERE EXTRACT(YEAR FROM tanggal) = 2024
ORDER BY tanggal DESC
LIMIT 3;
