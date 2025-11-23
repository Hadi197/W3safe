-- Check kondisi_akses_jalan field nullability
SELECT
    column_name,
    data_type,
    is_nullable,
    CASE
        WHEN is_nullable = 'NO' THEN 'REQUIRED - cannot be null'
        WHEN is_nullable = 'YES' THEN 'OPTIONAL - can be null'
        ELSE 'UNKNOWN'
    END as nullability_status
FROM information_schema.columns
WHERE table_name = 'management_walkthrough'
  AND column_name IN ('kondisi_akses_jalan', 'kondisi_housekeeping', 'kondisi_pencahayaan', 'kondisi_ventilasi');
