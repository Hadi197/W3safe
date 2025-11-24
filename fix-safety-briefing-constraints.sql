-- Drop the old check constraint that requires unit_id or wilayah_id
ALTER TABLE safety_briefing
DROP CONSTRAINT IF EXISTS chk_unit_or_wilayah;

-- Now clean up invalid unit_id references
UPDATE safety_briefing
SET unit_id = NULL
WHERE unit_id NOT IN (SELECT id FROM units);

-- Add proper foreign key constraints
ALTER TABLE safety_briefing
DROP CONSTRAINT IF EXISTS fk_safety_briefing_unit;

ALTER TABLE safety_briefing
ADD CONSTRAINT fk_safety_briefing_unit
FOREIGN KEY (unit_id) 
REFERENCES units(id)
ON DELETE SET NULL;

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
    tc.constraint_type,
    tc.table_name,
    kcu.column_name
FROM information_schema.table_constraints AS tc
LEFT JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
WHERE tc.table_name = 'safety_briefing'
ORDER BY tc.constraint_type, tc.constraint_name;
