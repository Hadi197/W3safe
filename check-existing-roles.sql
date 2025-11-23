-- Check what role values exist in the pegawai table
SELECT DISTINCT role, COUNT(*) as count
FROM pegawai
GROUP BY role
ORDER BY count DESC;

-- Also check the constraint definition
SELECT
    conname as constraint_name,
    pg_get_constraintdef(oid) as constraint_definition
FROM pg_constraint
WHERE conname LIKE '%role%'
AND conrelid = 'pegawai'::regclass;
