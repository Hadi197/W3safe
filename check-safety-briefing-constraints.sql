-- Check safety_briefing table constraints
SELECT 
    con.conname as constraint_name,
    con.contype as constraint_type,
    CASE con.contype
        WHEN 'c' THEN 'CHECK'
        WHEN 'f' THEN 'FOREIGN KEY'
        WHEN 'p' THEN 'PRIMARY KEY'
        WHEN 'u' THEN 'UNIQUE'
        WHEN 't' THEN 'TRIGGER'
        ELSE con.contype::text
    END as constraint_type_desc,
    pg_get_constraintdef(con.oid) as constraint_definition
FROM pg_constraint con
JOIN pg_class rel ON rel.oid = con.conrelid
JOIN pg_namespace nsp ON nsp.oid = rel.relnamespace
WHERE rel.relname = 'safety_briefing'
  AND nsp.nspname = 'public'
ORDER BY con.contype, con.conname;

-- Check column details for status
SELECT 
    column_name,
    data_type,
    character_maximum_length,
    column_default,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'public' 
  AND table_name = 'safety_briefing'
  AND column_name = 'status';

-- Try to see what values are currently in status column
SELECT DISTINCT status 
FROM safety_briefing 
ORDER BY status;
