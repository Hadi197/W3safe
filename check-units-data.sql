-- Check units data and mapping
SELECT
    id,
    nama_unit,
    kode_unit,
    aktif,
    CASE WHEN nama_unit IS NOT NULL AND nama_unit != '' THEN 'Has nama_unit' ELSE 'Missing nama_unit' END as nama_status,
    CASE WHEN kode_unit IS NOT NULL AND kode_unit != '' THEN 'Has kode_unit' ELSE 'Missing kode_unit' END as kode_status
FROM units
ORDER BY nama_unit;

-- Check if units are loaded in the app (sample of what should be returned by API)
SELECT
    id,
    nama_unit as nama_unit_raw,
    kode_unit as kode_unit_raw,
    -- This is what the API should return (mapped):
    nama_unit as nama,  -- This should be nama_unit
    kode_unit as kode   -- This should be kode_unit
FROM units
WHERE aktif = true
ORDER BY nama_unit
LIMIT 5;

-- Check if there are any units with NULL nama_unit
SELECT
    COUNT(*) as total_units,
    COUNT(CASE WHEN nama_unit IS NULL OR nama_unit = '' THEN 1 END) as units_with_empty_nama,
    COUNT(CASE WHEN kode_unit IS NULL OR kode_unit = '' THEN 1 END) as units_with_empty_kode
FROM units;
