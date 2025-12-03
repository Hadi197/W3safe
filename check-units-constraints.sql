-- Check the constraint on units table
SELECT 
    conname AS constraint_name,
    pg_get_constraintdef(oid) AS constraint_definition
FROM pg_constraint
WHERE conrelid = 'units'::regclass
  AND contype = 'c';

-- Check existing tipe values in units table
SELECT DISTINCT tipe 
FROM units 
WHERE tipe IS NOT NULL
ORDER BY tipe;
