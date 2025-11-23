-- Check all safety_patrol constraints
SELECT
    tc.constraint_name,
    tc.constraint_type,
    CASE WHEN tc.constraint_type = 'FOREIGN KEY' THEN 'FK to other table'
         ELSE tc.constraint_type END as type_desc
FROM information_schema.table_constraints tc
WHERE tc.table_name = 'safety_patrol';
