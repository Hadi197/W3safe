-- Add foreign key constraint for safety_briefing -> units
ALTER TABLE safety_briefing
DROP CONSTRAINT IF EXISTS fk_safety_briefing_unit;

ALTER TABLE safety_briefing
ADD CONSTRAINT fk_safety_briefing_unit
FOREIGN KEY (unit_id) 
REFERENCES units(id)
ON DELETE SET NULL;

-- Add foreign key constraint for safety_briefing -> pegawai
ALTER TABLE safety_briefing
DROP CONSTRAINT IF EXISTS fk_safety_briefing_petugas;

ALTER TABLE safety_briefing
ADD CONSTRAINT fk_safety_briefing_petugas
FOREIGN KEY (petugas_id) 
REFERENCES pegawai(id)
ON DELETE SET NULL;

-- Verify the constraints
SELECT
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_name = 'safety_briefing';
