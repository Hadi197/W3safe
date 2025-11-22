-- Verifikasi data yang sudah diinsert

-- 1. Cek Wilayah
SELECT 'WILAYAH' as tabel, kode, nama, regional, aktif 
FROM wilayah 
ORDER BY kode;

-- 2. Cek Units (Area dan Unit)
SELECT 'UNITS' as tabel, kode, nama, tipe, 
       (SELECT nama FROM wilayah w WHERE w.id = units.wilayah_id) as wilayah,
       aktif
FROM units 
ORDER BY tipe DESC, kode;

-- 3. Cek Pegawai
SELECT 'PEGAWAI' as tabel, nip, nama, email, jabatan, status,
       (SELECT nama FROM units u WHERE u.id = pegawai.unit_id) as unit
FROM pegawai;

-- 4. Count Summary
SELECT 
    (SELECT COUNT(*) FROM wilayah) as total_wilayah,
    (SELECT COUNT(*) FROM units WHERE tipe = 'area') as total_area,
    (SELECT COUNT(*) FROM units WHERE tipe = 'unit') as total_unit,
    (SELECT COUNT(*) FROM pegawai) as total_pegawai;
