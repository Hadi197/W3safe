-- Check units table structure and data
SELECT
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'units'
ORDER BY ordinal_position;

-- Check what columns actually exist
SELECT column_name FROM information_schema.columns WHERE table_name = 'units';

-- Check sample data from units
SELECT * FROM units LIMIT 3;

-- Check if nama_unit exists and what the actual column names are
SELECT
    CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'nama') THEN 'nama EXISTS' ELSE 'nama MISSING' END as nama_status,
    CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'nama_unit') THEN 'nama_unit EXISTS' ELSE 'nama_unit MISSING' END as nama_unit_status,
    CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'kode') THEN 'kode EXISTS' ELSE 'kode MISSING' END as kode_status,
    CASE WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'kode_unit') THEN 'kode_unit EXISTS' ELSE 'kode_unit MISSING' END as kode_unit_status;
