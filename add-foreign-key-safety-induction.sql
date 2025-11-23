-- Add foreign key constraint for safety_induction table
-- This fixes the "Could not find a relationship" error when joining with units table

-- Check if constraint already exists
DO $$
BEGIN
    -- Check if the foreign key constraint already exists
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'fk_safety_induction_unit'
          AND table_name = 'safety_induction'
    ) THEN
        -- Add the foreign key constraint
        ALTER TABLE safety_induction
        ADD CONSTRAINT fk_safety_induction_unit
        FOREIGN KEY (unit_id) REFERENCES units(id);

        RAISE NOTICE 'Added foreign key constraint fk_safety_induction_unit';
    ELSE
        RAISE NOTICE 'Foreign key constraint fk_safety_induction_unit already exists';
    END IF;
END $$;

-- Initialize array fields to empty arrays for existing records
UPDATE safety_induction SET
    instruktur_pendamping = COALESCE(instruktur_pendamping, ARRAY[]::TEXT[]),
    materi_tambahan = COALESCE(materi_tambahan, '[]'::jsonb),
    area_dikunjungi = COALESCE(area_dikunjungi, ARRAY[]::TEXT[]),
    apd_diberikan = COALESCE(apd_diberikan, '[]'::jsonb),
    akses_area = COALESCE(akses_area, ARRAY[]::TEXT[]),
    foto_induction = COALESCE(foto_induction, ARRAY[]::TEXT[]),
    dokumen_pendukung = COALESCE(dokumen_pendukung, ARRAY[]::TEXT[])
WHERE
    instruktur_pendamping IS NULL OR
    materi_tambahan IS NULL OR
    area_dikunjungi IS NULL OR
    apd_diberikan IS NULL OR
    akses_area IS NULL OR
    foto_induction IS NULL OR
    dokumen_pendukung IS NULL;

-- Verify the constraint was added
SELECT
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name,
    ccu.table_name AS referenced_table,
    ccu.column_name AS referenced_column
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
  AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
  AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_name = 'safety_induction';

-- Test a simple join query to verify it works
SELECT 'Testing join query:' as test;
SELECT
    si.id,
    si.nomor_induction,
    si.unit_id,
    u.nama_unit as unit_name
FROM safety_induction si
LEFT JOIN units u ON si.unit_id = u.id
LIMIT 3;
