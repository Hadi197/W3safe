-- CEK DETAIL DATA MANAGEMENT WALKTHROUGH UNTUK TABEL LAPORAN
-- November 2025

SELECT 
  id,
  tanggal_walkthrough,
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
  jumlah_temuan,
  status
FROM management_walkthrough
WHERE EXTRACT(YEAR FROM tanggal_walkthrough) = 2025 
  AND EXTRACT(MONTH FROM tanggal_walkthrough) = 11
ORDER BY tanggal_walkthrough DESC
LIMIT 10;

-- CEK STRUKTUR KOLOM
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'management_walkthrough'
ORDER BY ordinal_position;
