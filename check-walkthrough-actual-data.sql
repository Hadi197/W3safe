-- CEK DATA SEBENARNYA DARI MANAGEMENT WALKTHROUGH
SELECT 
  id,
  tanggal_walkthrough,
  area_inspeksi,
  nama_agenda,
  lokasi_pelaksanaan,
  pimpinan_pelaksanaan,
  uraian_kegiatan,
  catatan_evaluasi,
  rekomendasi,
  temuan,
  dokumentasi_foto_1,
  dokumentasi_foto_2,
  dokumentasi_foto_3,
  pg_typeof(catatan_evaluasi) as type_catatan,
  pg_typeof(rekomendasi) as type_rekomendasi,
  pg_typeof(temuan) as type_temuan,
  pg_typeof(dokumentasi_foto_1) as type_foto1
FROM management_walkthrough
WHERE EXTRACT(YEAR FROM tanggal_walkthrough) = 2025 
  AND EXTRACT(MONTH FROM tanggal_walkthrough) = 11
LIMIT 3;

-- Cek semua kolom yang ada
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'management_walkthrough'
  AND column_name LIKE '%catatan%' 
   OR column_name LIKE '%rekomendasi%'
   OR column_name LIKE '%temuan%'
   OR column_name LIKE '%foto%'
   OR column_name LIKE '%dokumentasi%'
ORDER BY ordinal_position;
