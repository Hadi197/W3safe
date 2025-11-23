-- Verify the wilayah table now has the new columns
SELECT kode_wilayah, nama_wilayah, nama, aktif, status FROM wilayah ORDER BY nama_wilayah;

-- Check the units table structure (should now have wilayah_id and area_id)
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'units' 
AND column_name IN ('wilayah_id', 'area_id', 'nama', 'aktif')
ORDER BY column_name;

-- Check the wilayah table structure (should now have nama and aktif)
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'wilayah' 
AND column_name IN ('nama', 'aktif', 'nama_wilayah', 'status')
ORDER BY column_name;
