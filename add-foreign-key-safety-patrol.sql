-- Add foreign key constraint for safety_patrol table
-- This fixes the "Could not find a relationship" error when joining with units table

-- Check if constraint already exists
DO $$
BEGIN
    -- Check if the foreign key constraint already exists
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'fk_safety_patrol_unit'
          AND table_name = 'safety_patrol'
    ) THEN
        -- Add the foreign key constraint
        ALTER TABLE safety_patrol
        ADD CONSTRAINT fk_safety_patrol_unit
        FOREIGN KEY (unit_id) REFERENCES units(id);

        RAISE NOTICE 'Added foreign key constraint fk_safety_patrol_unit';
    ELSE
        RAISE NOTICE 'Foreign key constraint fk_safety_patrol_unit already exists';
    END IF;
END $$;

-- Verify the constraint was added
SELECT
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
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
  AND tc.table_name = 'safety_patrol';

-- Initialize array fields to empty arrays for existing records
UPDATE safety_patrol SET
    anggota_patrol = COALESCE(anggota_patrol, ARRAY[]::TEXT[]),
    fokus_patrol = COALESCE(fokus_patrol, ARRAY[]::TEXT[]),
    unsafe_condition = COALESCE(unsafe_condition, '[]'::jsonb),
    unsafe_act = COALESCE(unsafe_act, '[]'::jsonb),
    detail_apd = COALESCE(detail_apd, '[]'::jsonb),
    area_kotor = COALESCE(area_kotor, ARRAY[]::TEXT[]),
    area_rapi = COALESCE(area_rapi, ARRAY[]::TEXT[]),
    detail_mesin = COALESCE(detail_mesin, '[]'::jsonb),
    rambu_k3_hilang = COALESCE(rambu_k3_hilang, ARRAY[]::TEXT[]),
    rambu_k3_rusak = COALESCE(rambu_k3_rusak, ARRAY[]::TEXT[]),
    good_practice = COALESCE(good_practice, ARRAY[]::TEXT[]),
    area_excellent = COALESCE(area_excellent, ARRAY[]::TEXT[]),
    pekerja_teladan = COALESCE(pekerja_teladan, ARRAY[]::TEXT[]),
    rekomendasi = COALESCE(rekomendasi, ARRAY[]::TEXT[]),
    action_items = COALESCE(action_items, '[]'::jsonb),
    stop_work_area = COALESCE(stop_work_area, ARRAY[]::TEXT[]),
    foto_patrol = COALESCE(foto_patrol, ARRAY[]::TEXT[]),
    dokumen_pendukung = COALESCE(dokumen_pendukung, ARRAY[]::TEXT[])
WHERE
    anggota_patrol IS NULL OR
    fokus_patrol IS NULL OR
    unsafe_condition IS NULL OR
    unsafe_act IS NULL OR
    detail_apd IS NULL OR
    area_kotor IS NULL OR
    area_rapi IS NULL OR
    detail_mesin IS NULL OR
    rambu_k3_hilang IS NULL OR
    rambu_k3_rusak IS NULL OR
    good_practice IS NULL OR
    area_excellent IS NULL OR
    pekerja_teladan IS NULL OR
    rekomendasi IS NULL OR
    action_items IS NULL OR
    stop_work_area IS NULL OR
    foto_patrol IS NULL OR
    dokumen_pendukung IS NULL;

-- Test a simple join query to verify it works
SELECT 'Testing join query...' as test;
SELECT
    sp.id,
    sp.nomor_patrol,
    sp.unit_id,
    u.nama_unit as unit_name
FROM safety_patrol sp
LEFT JOIN units u ON sp.unit_id = u.id
LIMIT 3;
