-- Get correct area IDs from areas table
SELECT id, kode_area, nama_area, wilayah_id 
FROM areas 
WHERE nama_area IN ('Area Jawa 1', 'Area Kalimantan 3', 'Area Bali Nusatenggara')
ORDER BY nama_area;
