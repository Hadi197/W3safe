-- QUERY UNTUK TABEL REKAP IMPLEMENTASI K3L (SEMUA MODUL)
-- Menampilkan data dari semua modul HSSE dalam format tabel Rekap K3L
-- Struktur: NO, MODUL, KEGIATAN, DOKUMENTASI, URAIAN (Hari/Tgl, Jam, Pimpinan, Peserta, Tempat, Keterangan)

-- 1. Safety Briefing
SELECT 
  ROW_NUMBER() OVER (ORDER BY tanggal DESC) as no,
  'Safety Briefing' as modul,
  topik as kegiatan,
  'Tidak Ada' as dokumentasi,
  to_char(tanggal, 'Day, DD Mon YYYY') as hari_tanggal,
  to_char(waktu_mulai, 'HH24:MI') as jam,
  COALESCE('-', '-') as pimpinan,
  COALESCE(jumlah_peserta, 0) as peserta,
  COALESCE(lokasi, '-') as tempat,
  '-' as keterangan
FROM safety_briefing
WHERE EXTRACT(YEAR FROM tanggal) = 2024 AND EXTRACT(MONTH FROM tanggal) = 11

UNION ALL

-- 2. Safety Patrol
SELECT 
  ROW_NUMBER() OVER (ORDER BY tanggal_patrol DESC) as no,
  'Safety Patrol' as modul,
  'Safety Patrol - ' || area_patrol as kegiatan,
  'Tidak Ada' as dokumentasi,
  to_char(tanggal_patrol, 'Day, DD Mon YYYY') as hari_tanggal,
  COALESCE(to_char(waktu_mulai, 'HH24:MI'), '-') as jam,
  COALESCE(patrol_leader, '-') as pimpinan,
  COALESCE(jumlah_anggota, 0) as peserta,
  COALESCE(area_patrol, '-') as tempat,
  '-' as keterangan
FROM safety_patrol
WHERE EXTRACT(YEAR FROM tanggal_patrol) = 2024 AND EXTRACT(MONTH FROM tanggal_patrol) = 11

UNION ALL

-- 3. Safety Drill
SELECT 
  ROW_NUMBER() OVER (ORDER BY tanggal_drill DESC) as no,
  'Safety Drill' as modul,
  tujuan_drill as kegiatan,
  'Tidak Ada' as dokumentasi,
  to_char(tanggal_drill, 'Day, DD Mon YYYY') as hari_tanggal,
  COALESCE(to_char(waktu_mulai, 'HH24:MI'), '-') as jam,
  COALESCE(drill_commander, '-') as pimpinan,
  COALESCE(jumlah_peserta, 0) as peserta,
  COALESCE(area_lokasi, '-') as tempat,
  '-' as keterangan
FROM safety_drill
WHERE EXTRACT(YEAR FROM tanggal_drill) = 2024 AND EXTRACT(MONTH FROM tanggal_drill) = 11

UNION ALL

-- 4. Safety Forum
SELECT 
  ROW_NUMBER() OVER (ORDER BY tanggal_forum DESC) as no,
  'Safety Forum' as modul,
  tema as kegiatan,
  'Tidak Ada' as dokumentasi,
  to_char(tanggal_forum, 'Day, DD Mon YYYY') as hari_tanggal,
  COALESCE(to_char(waktu_mulai, 'HH24:MI'), '-') as jam,
  COALESCE(moderator, '-') as pimpinan,
  COALESCE(jumlah_peserta, 0) as peserta,
  COALESCE(lokasi, '-') as tempat,
  '-' as keterangan
FROM safety_forum
WHERE EXTRACT(YEAR FROM tanggal_forum) = 2024 AND EXTRACT(MONTH FROM tanggal_forum) = 11

UNION ALL

-- 5. Safety Induction
SELECT 
  ROW_NUMBER() OVER (ORDER BY tanggal_induction DESC) as no,
  'Safety Induction' as modul,
  topik_induction as kegiatan,
  'Tidak Ada' as dokumentasi,
  to_char(tanggal_induction, 'Day, DD Mon YYYY') as hari_tanggal,
  COALESCE(to_char(waktu_mulai, 'HH24:MI'), '-') as jam,
  '-' as pimpinan,
  COALESCE(jumlah_peserta, 0) as peserta,
  COALESCE(lokasi, '-') as tempat,
  '-' as keterangan
FROM safety_induction
WHERE EXTRACT(YEAR FROM tanggal_induction) = 2024 AND EXTRACT(MONTH FROM tanggal_induction) = 11

UNION ALL

-- 6. Silent Inspection
SELECT 
  ROW_NUMBER() OVER (ORDER BY tanggal DESC) as no,
  'Silent Inspection' as modul,
  'Silent Inspection - ' || area_inspeksi as kegiatan,
  'Tidak Ada' as dokumentasi,
  to_char(tanggal, 'Day, DD Mon YYYY') as hari_tanggal,
  '-' as jam,
  '-' as pimpinan,
  0 as peserta,
  COALESCE(area_inspeksi, '-') as tempat,
  COALESCE(status, '-') as keterangan
FROM silent_inspection
WHERE EXTRACT(YEAR FROM tanggal) = 2024 AND EXTRACT(MONTH FROM tanggal) = 11

UNION ALL

-- 7. Management Walkthrough
SELECT 
  ROW_NUMBER() OVER (ORDER BY tanggal_walkthrough DESC) as no,
  'Management Walkthrough' as modul,
  'Management Walkthrough - ' || area as kegiatan,
  'Tidak Ada' as dokumentasi,
  to_char(tanggal_walkthrough, 'Day, DD Mon YYYY') as hari_tanggal,
  COALESCE(to_char(waktu_mulai, 'HH24:MI'), '-') as jam,
  COALESCE(pic, '-') as pimpinan,
  COALESCE(jumlah_peserta, 0) as peserta,
  COALESCE(area, '-') as tempat,
  '-' as keterangan
FROM management_walkthrough
WHERE EXTRACT(YEAR FROM tanggal_walkthrough) = 2024 AND EXTRACT(MONTH FROM tanggal_walkthrough) = 11

ORDER BY hari_tanggal DESC;
