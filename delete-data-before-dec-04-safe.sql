-- =====================================================
-- SQL AMAN: Hapus Data Sebelum 04 Desember 2025
-- dengan TRANSAKSI dan ROLLBACK
-- =====================================================
-- Script ini menggunakan transaksi sehingga bisa di-rollback
-- jika ada kesalahan
-- =====================================================

BEGIN;

-- Cek dulu jumlah data yang akan dihapus
DO $$
DECLARE
  count_briefing INTEGER;
  count_patrol INTEGER;
  count_silent INTEGER;
  count_forum INTEGER;
  count_walkthrough INTEGER;
  count_drill INTEGER;
  count_induction INTEGER;
  count_unsafe INTEGER;
  count_ltifr INTEGER;
BEGIN
  -- Hitung data yang akan dihapus
  SELECT COUNT(*) INTO count_briefing FROM safety_briefing WHERE tanggal < '2025-12-04';
  SELECT COUNT(*) INTO count_patrol FROM safety_patrol WHERE tanggal_patrol < '2025-12-04';
  SELECT COUNT(*) INTO count_silent FROM silent_inspection WHERE tanggal < '2025-12-04';
  SELECT COUNT(*) INTO count_forum FROM safety_forum WHERE tanggal_forum < '2025-12-04';
  SELECT COUNT(*) INTO count_walkthrough FROM management_walkthrough WHERE tanggal_walkthrough < '2025-12-04';
  SELECT COUNT(*) INTO count_drill FROM safety_drill WHERE tanggal_pelaksanaan < '2025-12-04';
  SELECT COUNT(*) INTO count_induction FROM safety_induction WHERE tanggal < '2025-12-04';
  SELECT COUNT(*) INTO count_unsafe FROM unsafe_action_condition WHERE tanggal_kejadian < '2025-12-04';
  SELECT COUNT(*) INTO count_ltifr FROM ltifr_records WHERE periode_bulan < '2025-12';
  
  -- Tampilkan ringkasan
  RAISE NOTICE '============================================';
  RAISE NOTICE 'DATA YANG AKAN DIHAPUS:';
  RAISE NOTICE '============================================';
  RAISE NOTICE 'Safety Briefing        : % records', count_briefing;
  RAISE NOTICE 'Safety Patrol          : % records', count_patrol;
  RAISE NOTICE 'Silent Inspection      : % records', count_silent;
  RAISE NOTICE 'Safety Forum           : % records', count_forum;
  RAISE NOTICE 'Management Walkthrough : % records', count_walkthrough;
  RAISE NOTICE 'Safety Drill           : % records', count_drill;
  RAISE NOTICE 'Safety Induction       : % records', count_induction;
  RAISE NOTICE 'Unsafe Action/Condition: % records', count_unsafe;
  RAISE NOTICE 'LTIFR Records          : % records', count_ltifr;
  RAISE NOTICE '============================================';
  RAISE NOTICE 'TOTAL                  : % records', 
    count_briefing + count_patrol + count_silent + count_forum + 
    count_walkthrough + count_drill + count_induction + count_unsafe + count_ltifr;
  RAISE NOTICE '============================================';
END $$;

-- HAPUS DATA (dalam transaksi)
DELETE FROM safety_briefing WHERE tanggal < '2025-12-04';
DELETE FROM safety_patrol WHERE tanggal_patrol < '2025-12-04';
DELETE FROM silent_inspection WHERE tanggal < '2025-12-04';
DELETE FROM safety_forum WHERE tanggal_forum < '2025-12-04';
DELETE FROM management_walkthrough WHERE tanggal_walkthrough < '2025-12-04';
DELETE FROM safety_drill WHERE tanggal_pelaksanaan < '2025-12-04';
DELETE FROM safety_induction WHERE tanggal < '2025-12-04';
DELETE FROM unsafe_action_condition WHERE tanggal_kejadian < '2025-12-04';
DELETE FROM ltifr_records WHERE periode_bulan < '2025-12';

-- Tampilkan hasil setelah penghapusan
DO $$
DECLARE
  count_briefing INTEGER;
  count_patrol INTEGER;
  count_silent INTEGER;
  count_forum INTEGER;
  count_walkthrough INTEGER;
  count_drill INTEGER;
  count_induction INTEGER;
  count_unsafe INTEGER;
  count_ltifr INTEGER;
BEGIN
  -- Hitung data yang tersisa
  SELECT COUNT(*) INTO count_briefing FROM safety_briefing;
  SELECT COUNT(*) INTO count_patrol FROM safety_patrol;
  SELECT COUNT(*) INTO count_silent FROM silent_inspection;
  SELECT COUNT(*) INTO count_forum FROM safety_forum;
  SELECT COUNT(*) INTO count_walkthrough FROM management_walkthrough;
  SELECT COUNT(*) INTO count_drill FROM safety_drill;
  SELECT COUNT(*) INTO count_induction FROM safety_induction;
  SELECT COUNT(*) INTO count_unsafe FROM unsafe_action_condition;
  SELECT COUNT(*) INTO count_ltifr FROM ltifr_records;
  
  -- Tampilkan ringkasan
  RAISE NOTICE '============================================';
  RAISE NOTICE 'DATA YANG TERSISA:';
  RAISE NOTICE '============================================';
  RAISE NOTICE 'Safety Briefing        : % records', count_briefing;
  RAISE NOTICE 'Safety Patrol          : % records', count_patrol;
  RAISE NOTICE 'Silent Inspection      : % records', count_silent;
  RAISE NOTICE 'Safety Forum           : % records', count_forum;
  RAISE NOTICE 'Management Walkthrough : % records', count_walkthrough;
  RAISE NOTICE 'Safety Drill           : % records', count_drill;
  RAISE NOTICE 'Safety Induction       : % records', count_induction;
  RAISE NOTICE 'Unsafe Action/Condition: % records', count_unsafe;
  RAISE NOTICE 'LTIFR Records          : % records', count_ltifr;
  RAISE NOTICE '============================================';
  RAISE NOTICE 'TOTAL                  : % records', 
    count_briefing + count_patrol + count_silent + count_forum + 
    count_walkthrough + count_drill + count_induction + count_unsafe + count_ltifr;
  RAISE NOTICE '============================================';
END $$;

-- =====================================================
-- PILIH SALAH SATU:
-- =====================================================

-- OPSI 1: COMMIT - Simpan perubahan (hapus data permanen)
-- COMMIT;

-- OPSI 2: ROLLBACK - Batalkan perubahan (data tidak jadi dihapus)
ROLLBACK;

-- =====================================================
-- INSTRUKSI:
-- 1. Jalankan script ini sampai ROLLBACK
-- 2. Lihat NOTICE untuk jumlah data yang akan dihapus
-- 3. Jika yakin, ganti ROLLBACK dengan COMMIT
-- 4. Jalankan ulang script
-- =====================================================
