-- Step 1: Check which unit_ids are invalid
SELECT 
    sb.unit_id,
    COUNT(*) as record_count,
    MIN(sb.tanggal) as first_date,
    MAX(sb.tanggal) as last_date
FROM safety_briefing sb
LEFT JOIN units u ON sb.unit_id = u.id
WHERE sb.unit_id IS NOT NULL 
  AND u.id IS NULL
GROUP BY sb.unit_id;

-- Step 2: Set invalid unit_id to NULL (soft fix - preserves the records)
UPDATE safety_briefing
SET unit_id = NULL
WHERE unit_id IN (
    SELECT sb.unit_id
    FROM safety_briefing sb
    LEFT JOIN units u ON sb.unit_id = u.id
    WHERE sb.unit_id IS NOT NULL 
      AND u.id IS NULL
);

-- Step 3: Verify no more invalid references
SELECT COUNT(*) as remaining_invalid
FROM safety_briefing sb
LEFT JOIN units u ON sb.unit_id = u.id
WHERE sb.unit_id IS NOT NULL 
  AND u.id IS NULL;

-- Step 4: Now we can safely add the foreign key
ALTER TABLE safety_briefing
DROP CONSTRAINT IF EXISTS fk_safety_briefing_unit;

ALTER TABLE safety_briefing
ADD CONSTRAINT fk_safety_briefing_unit
FOREIGN KEY (unit_id) 
REFERENCES units(id)
ON DELETE SET NULL;

-- Step 5: Add petugas foreign key
ALTER TABLE safety_briefing
DROP CONSTRAINT IF EXISTS fk_safety_briefing_petugas;

ALTER TABLE safety_briefing
ADD CONSTRAINT fk_safety_briefing_petugas
FOREIGN KEY (petugas_id) 
REFERENCES pegawai(id)
ON DELETE SET NULL;

-- Step 6: Verify constraints were created
SELECT
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_name = 'safety_briefing';
