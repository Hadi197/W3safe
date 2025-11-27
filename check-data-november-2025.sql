-- CEK DATA UNTUK PERIODE NOVEMBER 2025
-- Untuk memastikan apakah ada data di database

-- 1. Safety Briefing (November 2025)
SELECT 'Safety Briefing' as tabel, COUNT(*) as jumlah_data
FROM safety_briefing
WHERE EXTRACT(YEAR FROM tanggal) = 2025 
  AND EXTRACT(MONTH FROM tanggal) = 11
  AND status IN ('approved', 'completed');

-- Detail data Safety Briefing
SELECT 
  id,
  tanggal,
  topik,
  status,
  jumlah_peserta
FROM safety_briefing
WHERE EXTRACT(YEAR FROM tanggal) = 2025 
  AND EXTRACT(MONTH FROM tanggal) = 11
ORDER BY tanggal DESC
LIMIT 5;

-- 2. Safety Patrol (November 2025)
SELECT 'Safety Patrol' as tabel, COUNT(*) as jumlah_data
FROM safety_patrol
WHERE EXTRACT(YEAR FROM tanggal_patrol) = 2025 
  AND EXTRACT(MONTH FROM tanggal_patrol) = 11;

-- Detail data Safety Patrol dengan temuan
SELECT 
  id,
  tanggal_patrol,
  area_patrol,
  temuan_kritikal,
  temuan_mayor,
  status
FROM safety_patrol
WHERE EXTRACT(YEAR FROM tanggal_patrol) = 2025 
  AND EXTRACT(MONTH FROM tanggal_patrol) = 11
ORDER BY tanggal_patrol DESC
LIMIT 5;

-- 3. Safety Drill (November 2025)
SELECT 'Safety Drill' as tabel, COUNT(*) as jumlah_data
FROM safety_drill
WHERE EXTRACT(YEAR FROM tanggal_drill) = 2025 
  AND EXTRACT(MONTH FROM tanggal_drill) = 11
  AND status IN ('completed', 'reviewed');

-- Detail data Safety Drill
SELECT 
  id,
  tanggal_drill,
  jenis_drill,
  evaluasi_overall,
  jumlah_temuan,
  status
FROM safety_drill
WHERE EXTRACT(YEAR FROM tanggal_drill) = 2025 
  AND EXTRACT(MONTH FROM tanggal_drill) = 11
ORDER BY tanggal_drill DESC
LIMIT 5;

-- 4. Safety Forum (November 2025)
SELECT 'Safety Forum' as tabel, COUNT(*) as jumlah_data
FROM safety_forum
WHERE EXTRACT(YEAR FROM tanggal_forum) = 2025 
  AND EXTRACT(MONTH FROM tanggal_forum) = 11
  AND status IN ('approved', 'completed');

-- Detail data Safety Forum
SELECT 
  id,
  tanggal_forum,
  agenda_utama,
  masalah_teridentifikasi,
  action_items,
  status
FROM safety_forum
WHERE EXTRACT(YEAR FROM tanggal_forum) = 2025 
  AND EXTRACT(MONTH FROM tanggal_forum) = 11
ORDER BY tanggal_forum DESC
LIMIT 5;

-- 5. Safety Induction (November 2025)
SELECT 'Safety Induction' as tabel, COUNT(*) as jumlah_data
FROM safety_induction
WHERE EXTRACT(YEAR FROM tanggal_induction) = 2025 
  AND EXTRACT(MONTH FROM tanggal_induction) = 11
  AND status IN ('approved', 'completed');

-- Detail data Safety Induction
SELECT 
  id,
  tanggal_induction,
  nama_peserta,
  jenis_peserta,
  status_ujian,
  perlu_reinduction,
  status
FROM safety_induction
WHERE EXTRACT(YEAR FROM tanggal_induction) = 2025 
  AND EXTRACT(MONTH FROM tanggal_induction) = 11
ORDER BY tanggal_induction DESC
LIMIT 5;

-- 6. Silent Inspection (November 2025)
SELECT 'Silent Inspection' as tabel, COUNT(*) as jumlah_data
FROM silent_inspection
WHERE EXTRACT(YEAR FROM tanggal) = 2025 
  AND EXTRACT(MONTH FROM tanggal) = 11;

-- Detail data Silent Inspection dengan risiko tinggi
SELECT 
  id,
  tanggal,
  area_inspeksi,
  tingkat_risiko,
  jumlah_temuan,
  status
FROM silent_inspection
WHERE EXTRACT(YEAR FROM tanggal) = 2025 
  AND EXTRACT(MONTH FROM tanggal) = 11
ORDER BY tanggal DESC
LIMIT 5;

-- 7. Management Walkthrough (November 2025)
SELECT 'Management Walkthrough' as tabel, COUNT(*) as jumlah_data
FROM management_walkthrough
WHERE EXTRACT(YEAR FROM tanggal_walkthrough) = 2025 
  AND EXTRACT(MONTH FROM tanggal_walkthrough) = 11
  AND status IN ('completed', 'approved');

-- Detail data Management Walkthrough
SELECT 
  id,
  tanggal_walkthrough,
  area_inspeksi,
  jumlah_temuan,
  status
FROM management_walkthrough
WHERE EXTRACT(YEAR FROM tanggal_walkthrough) = 2025 
  AND EXTRACT(MONTH FROM tanggal_walkthrough) = 11
ORDER BY tanggal_walkthrough DESC
LIMIT 5;

-- SUMMARY: Total data per modul untuk November 2025
SELECT 
  'SUMMARY - November 2025' as info,
  (SELECT COUNT(*) FROM safety_briefing WHERE EXTRACT(YEAR FROM tanggal) = 2025 AND EXTRACT(MONTH FROM tanggal) = 11 AND status IN ('approved', 'completed')) as safety_briefing,
  (SELECT COUNT(*) FROM safety_patrol WHERE EXTRACT(YEAR FROM tanggal_patrol) = 2025 AND EXTRACT(MONTH FROM tanggal_patrol) = 11) as safety_patrol,
  (SELECT COUNT(*) FROM safety_drill WHERE EXTRACT(YEAR FROM tanggal_drill) = 2025 AND EXTRACT(MONTH FROM tanggal_drill) = 11 AND status IN ('completed', 'reviewed')) as safety_drill,
  (SELECT COUNT(*) FROM safety_forum WHERE EXTRACT(YEAR FROM tanggal_forum) = 2025 AND EXTRACT(MONTH FROM tanggal_forum) = 11 AND status IN ('approved', 'completed')) as safety_forum,
  (SELECT COUNT(*) FROM safety_induction WHERE EXTRACT(YEAR FROM tanggal_induction) = 2025 AND EXTRACT(MONTH FROM tanggal_induction) = 11 AND status IN ('approved', 'completed')) as safety_induction,
  (SELECT COUNT(*) FROM silent_inspection WHERE EXTRACT(YEAR FROM tanggal) = 2025 AND EXTRACT(MONTH FROM tanggal) = 11) as silent_inspection,
  (SELECT COUNT(*) FROM management_walkthrough WHERE EXTRACT(YEAR FROM tanggal_walkthrough) = 2025 AND EXTRACT(MONTH FROM tanggal_walkthrough) = 11 AND status IN ('completed', 'approved')) as management_walkthrough;

-- CEK DATA UNTUK SEMUA BULAN DI TAHUN 2025 (untuk memastikan ada data atau tidak)
SELECT 
  EXTRACT(MONTH FROM tanggal) as bulan,
  COUNT(*) as jumlah_data
FROM safety_briefing
WHERE EXTRACT(YEAR FROM tanggal) = 2025
GROUP BY EXTRACT(MONTH FROM tanggal)
ORDER BY bulan;

-- Alternatif: Cek data terbaru (untuk tahu bulan apa yang ada data)
SELECT 
  'safety_briefing' as tabel,
  MIN(tanggal) as tanggal_paling_awal,
  MAX(tanggal) as tanggal_paling_baru,
  COUNT(*) as total_records
FROM safety_briefing
UNION ALL
SELECT 
  'safety_patrol' as tabel,
  MIN(tanggal_patrol) as tanggal_paling_awal,
  MAX(tanggal_patrol) as tanggal_paling_baru,
  COUNT(*) as total_records
FROM safety_patrol
UNION ALL
SELECT 
  'safety_drill' as tabel,
  MIN(tanggal_drill) as tanggal_paling_awal,
  MAX(tanggal_drill) as tanggal_paling_baru,
  COUNT(*) as total_records
FROM safety_drill
UNION ALL
SELECT 
  'safety_forum' as tabel,
  MIN(tanggal_forum) as tanggal_paling_awal,
  MAX(tanggal_forum) as tanggal_paling_baru,
  COUNT(*) as total_records
FROM safety_forum
UNION ALL
SELECT 
  'safety_induction' as tabel,
  MIN(tanggal_induction) as tanggal_paling_awal,
  MAX(tanggal_induction) as tanggal_paling_baru,
  COUNT(*) as total_records
FROM safety_induction
UNION ALL
SELECT 
  'silent_inspection' as tabel,
  MIN(tanggal) as tanggal_paling_awal,
  MAX(tanggal) as tanggal_paling_baru,
  COUNT(*) as total_records
FROM silent_inspection
UNION ALL
SELECT 
  'management_walkthrough' as tabel,
  MIN(tanggal_walkthrough) as tanggal_paling_awal,
  MAX(tanggal_walkthrough) as tanggal_paling_baru,
  COUNT(*) as total_records
FROM management_walkthrough;
