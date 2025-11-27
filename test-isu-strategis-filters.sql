-- TEST QUERY ISU STRATEGIS DENGAN FILTER YANG SUDAH DIUPDATE
-- Untuk memastikan data bisa diambil setelah filter status dihapus

-- Parameter periode
WITH periode AS (
  SELECT 2025 as tahun, 11 as bulan
)

-- 1. Safety Briefing (TANPA filter status)
SELECT 
  'Safety Briefing' as modul,
  COUNT(*) as jumlah_data
FROM safety_briefing, periode
WHERE EXTRACT(YEAR FROM tanggal) = periode.tahun 
  AND EXTRACT(MONTH FROM tanggal) = periode.bulan;

-- Detail Safety Briefing
SELECT 
  'Safety Briefing' as modul,
  id,
  tanggal,
  topik,
  status
FROM safety_briefing, (SELECT 2025 as tahun, 11 as bulan) periode
WHERE EXTRACT(YEAR FROM tanggal) = periode.tahun 
  AND EXTRACT(MONTH FROM tanggal) = periode.bulan
LIMIT 3;

-- 2. Safety Patrol (TANPA filter temuan)
SELECT 
  'Safety Patrol' as modul,
  COUNT(*) as jumlah_data
FROM safety_patrol, (SELECT 2025 as tahun, 11 as bulan) periode
WHERE EXTRACT(YEAR FROM tanggal_patrol) = periode.tahun 
  AND EXTRACT(MONTH FROM tanggal_patrol) = periode.bulan;

-- Detail Safety Patrol
SELECT 
  'Safety Patrol' as modul,
  id,
  tanggal_patrol,
  area_patrol,
  temuan_kritikal,
  temuan_mayor
FROM safety_patrol, (SELECT 2025 as tahun, 11 as bulan) periode
WHERE EXTRACT(YEAR FROM tanggal_patrol) = periode.tahun 
  AND EXTRACT(MONTH FROM tanggal_patrol) = periode.bulan
ORDER BY tanggal_patrol DESC
LIMIT 3;

-- 3. Safety Drill (TANPA filter status)
SELECT 
  'Safety Drill' as modul,
  COUNT(*) as jumlah_data
FROM safety_drill, (SELECT 2025 as tahun, 11 as bulan) periode
WHERE EXTRACT(YEAR FROM tanggal_drill) = periode.tahun 
  AND EXTRACT(MONTH FROM tanggal_drill) = periode.bulan;

-- Detail Safety Drill
SELECT 
  'Safety Drill' as modul,
  id,
  tanggal_drill,
  jenis_drill,
  evaluasi_overall,
  jumlah_temuan,
  status
FROM safety_drill, (SELECT 2025 as tahun, 11 as bulan) periode
WHERE EXTRACT(YEAR FROM tanggal_drill) = periode.tahun 
  AND EXTRACT(MONTH FROM tanggal_drill) = periode.bulan
LIMIT 2;

-- 4. Safety Forum (TANPA filter status)
SELECT 
  'Safety Forum' as modul,
  COUNT(*) as jumlah_data
FROM safety_forum, (SELECT 2025 as tahun, 11 as bulan) periode
WHERE EXTRACT(YEAR FROM tanggal_forum) = periode.tahun 
  AND EXTRACT(MONTH FROM tanggal_forum) = periode.bulan;

-- Detail Safety Forum
SELECT 
  'Safety Forum' as modul,
  id,
  tanggal_forum,
  agenda_utama,
  masalah_teridentifikasi,
  status
FROM safety_forum, (SELECT 2025 as tahun, 11 as bulan) periode
WHERE EXTRACT(YEAR FROM tanggal_forum) = periode.tahun 
  AND EXTRACT(MONTH FROM tanggal_forum) = periode.bulan
LIMIT 2;

-- 5. Safety Induction (TANPA filter status)
SELECT 
  'Safety Induction' as modul,
  COUNT(*) as jumlah_data
FROM safety_induction, (SELECT 2025 as tahun, 11 as bulan) periode
WHERE EXTRACT(YEAR FROM tanggal_induction) = periode.tahun 
  AND EXTRACT(MONTH FROM tanggal_induction) = periode.bulan;

-- Detail Safety Induction
SELECT 
  'Safety Induction' as modul,
  id,
  tanggal_induction,
  jenis_peserta,
  nama_peserta,
  status
FROM safety_induction, (SELECT 2025 as tahun, 11 as bulan) periode
WHERE EXTRACT(YEAR FROM tanggal_induction) = periode.tahun 
  AND EXTRACT(MONTH FROM tanggal_induction) = periode.bulan
LIMIT 2;

-- 6. Silent Inspection (TANPA filter risiko)
SELECT 
  'Silent Inspection' as modul,
  COUNT(*) as jumlah_data
FROM silent_inspection, (SELECT 2025 as tahun, 11 as bulan) periode
WHERE EXTRACT(YEAR FROM tanggal) = periode.tahun 
  AND EXTRACT(MONTH FROM tanggal) = periode.bulan;

-- Detail Silent Inspection
SELECT 
  'Silent Inspection' as modul,
  id,
  tanggal,
  area_inspeksi,
  tingkat_risiko,
  jumlah_temuan
FROM silent_inspection, (SELECT 2025 as tahun, 11 as bulan) periode
WHERE EXTRACT(YEAR FROM tanggal) = periode.tahun 
  AND EXTRACT(MONTH FROM tanggal) = periode.bulan
ORDER BY tingkat_risiko
LIMIT 3;

-- 7. Management Walkthrough (TANPA filter status)
SELECT 
  'Management Walkthrough' as modul,
  COUNT(*) as jumlah_data
FROM management_walkthrough, (SELECT 2025 as tahun, 11 as bulan) periode
WHERE EXTRACT(YEAR FROM tanggal_walkthrough) = periode.tahun 
  AND EXTRACT(MONTH FROM tanggal_walkthrough) = periode.bulan;

-- Detail Management Walkthrough
SELECT 
  'Management Walkthrough' as modul,
  id,
  tanggal_walkthrough,
  area_inspeksi,
  jumlah_temuan,
  status
FROM management_walkthrough, (SELECT 2025 as tahun, 11 as bulan) periode
WHERE EXTRACT(YEAR FROM tanggal_walkthrough) = periode.tahun 
  AND EXTRACT(MONTH FROM tanggal_walkthrough) = periode.bulan
ORDER BY jumlah_temuan DESC
LIMIT 2;

-- SUMMARY: Total yang bisa diambil untuk Isu Strategis
SELECT 
  'TOTAL ISU STRATEGIS (no filters)' as info,
  (SELECT COUNT(*) FROM safety_briefing WHERE EXTRACT(YEAR FROM tanggal) = 2025 AND EXTRACT(MONTH FROM tanggal) = 11) as briefing,
  (SELECT COUNT(*) FROM safety_patrol WHERE EXTRACT(YEAR FROM tanggal_patrol) = 2025 AND EXTRACT(MONTH FROM tanggal_patrol) = 11) as patrol,
  (SELECT COUNT(*) FROM safety_drill WHERE EXTRACT(YEAR FROM tanggal_drill) = 2025 AND EXTRACT(MONTH FROM tanggal_drill) = 11) as drill,
  (SELECT COUNT(*) FROM safety_forum WHERE EXTRACT(YEAR FROM tanggal_forum) = 2025 AND EXTRACT(MONTH FROM tanggal_forum) = 11) as forum,
  (SELECT COUNT(*) FROM safety_induction WHERE EXTRACT(YEAR FROM tanggal_induction) = 2025 AND EXTRACT(MONTH FROM tanggal_induction) = 11) as induction,
  (SELECT COUNT(*) FROM silent_inspection WHERE EXTRACT(YEAR FROM tanggal) = 2025 AND EXTRACT(MONTH FROM tanggal) = 11) as inspection,
  (SELECT COUNT(*) FROM management_walkthrough WHERE EXTRACT(YEAR FROM tanggal_walkthrough) = 2025 AND EXTRACT(MONTH FROM tanggal_walkthrough) = 11) as walkthrough;
