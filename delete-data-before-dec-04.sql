-- =====================================================
-- SQL untuk Menghapus Data Sebelum 04 Desember 2025
-- =====================================================
-- PERINGATAN: Script ini akan menghapus data PERMANEN!
-- Backup database sebelum menjalankan script ini!
-- =====================================================

-- 1. Hapus Safety Briefing sebelum 04 Des 2025
DELETE FROM safety_briefing
WHERE tanggal < '2025-12-04';

-- 2. Hapus Safety Patrol sebelum 04 Des 2025
DELETE FROM safety_patrol
WHERE tanggal_patrol < '2025-12-04';

-- 3. Hapus Silent Inspection sebelum 04 Des 2025
DELETE FROM silent_inspection
WHERE tanggal < '2025-12-04';

-- 4. Hapus Safety Forum sebelum 04 Des 2025
DELETE FROM safety_forum
WHERE tanggal_forum < '2025-12-04';

-- 5. Hapus Management Walkthrough sebelum 04 Des 2025
DELETE FROM management_walkthrough
WHERE tanggal_walkthrough < '2025-12-04';

-- 6. Hapus Safety Drill sebelum 04 Des 2025
-- Column: tanggal_drill (BUKAN tanggal_pelaksanaan!)
DELETE FROM safety_drill
WHERE tanggal_drill < '2025-12-04';

-- 7. Hapus Safety Induction sebelum 04 Des 2025
-- Column: tanggal_induction (BUKAN tanggal!)
DELETE FROM safety_induction
WHERE tanggal_induction < '2025-12-04';

-- 8. Hapus Unsafe Action/Condition sebelum 04 Des 2025
DELETE FROM unsafe_action_condition
WHERE tanggal_kejadian < '2025-12-04';

-- 9. Hapus LTIFR Records sebelum 04 Des 2025
-- Menggunakan periode_bulan (format: YYYY-MM)
DELETE FROM ltifr_records
WHERE periode_bulan < '2025-12';

-- =====================================================
-- Verifikasi: Cek jumlah data yang tersisa
-- =====================================================

SELECT 'safety_briefing' as tabel, COUNT(*) as total_data FROM safety_briefing
UNION ALL
SELECT 'safety_patrol', COUNT(*) FROM safety_patrol
UNION ALL
SELECT 'silent_inspection', COUNT(*) FROM silent_inspection
UNION ALL
SELECT 'safety_forum', COUNT(*) FROM safety_forum
UNION ALL
SELECT 'management_walkthrough', COUNT(*) FROM management_walkthrough
UNION ALL
SELECT 'safety_drill', COUNT(*) FROM safety_drill
UNION ALL
SELECT 'safety_induction', COUNT(*) FROM safety_induction
UNION ALL
SELECT 'unsafe_action_condition', COUNT(*) FROM unsafe_action_condition
UNION ALL
SELECT 'ltifr_records', COUNT(*) FROM ltifr_records
ORDER BY tabel;

-- =====================================================
-- Detail data yang tersisa (per tanggal)
-- =====================================================

-- Safety Briefing
SELECT 'safety_briefing' as tabel, 
       tanggal, 
       COUNT(*) as jumlah 
FROM safety_briefing 
WHERE tanggal >= '2025-12-04'
GROUP BY tanggal 
ORDER BY tanggal;

-- Safety Patrol
SELECT 'safety_patrol' as tabel, 
       tanggal_patrol, 
       COUNT(*) as jumlah 
FROM safety_patrol 
WHERE tanggal_patrol >= '2025-12-04'
GROUP BY tanggal_patrol 
ORDER BY tanggal_patrol;

-- Silent Inspection
SELECT 'silent_inspection' as tabel, 
       tanggal, 
       COUNT(*) as jumlah 
FROM silent_inspection 
WHERE tanggal >= '2025-12-04'
GROUP BY tanggal 
ORDER BY tanggal;

-- Unsafe Action/Condition
SELECT 'unsafe_action_condition' as tabel, 
       tanggal_kejadian, 
       COUNT(*) as jumlah 
FROM unsafe_action_condition 
WHERE tanggal_kejadian >= '2025-12-04'
GROUP BY tanggal_kejadian 
ORDER BY tanggal_kejadian;
