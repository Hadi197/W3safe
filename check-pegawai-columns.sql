-- Check actual column names in pegawai table
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'pegawai' 
  AND table_schema = 'public'
ORDER BY ordinal_position;
