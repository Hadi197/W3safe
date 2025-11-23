-- Check the role check constraint definition
SELECT
    conname as constraint_name,
    pg_get_constraintdef(oid) as constraint_definition
FROM pg_constraint
WHERE conname = 'pegawai_role_check'
AND conrelid = 'pegawai'::regclass;

-- Check what roles actually exist
SELECT role, COUNT(*) as count
FROM pegawai
WHERE role IS NOT NULL
GROUP BY role
ORDER BY count DESC;

-- Check the default role value
SELECT column_name, column_default
FROM information_schema.columns
WHERE table_name = 'pegawai'
AND column_name = 'role';
