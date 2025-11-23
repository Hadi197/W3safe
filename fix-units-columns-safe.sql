-- Safe fix for units table columns
-- Run this in Supabase SQL Editor

-- Add tipe column to units table (this is the main issue)
ALTER TABLE units ADD COLUMN IF NOT EXISTS tipe VARCHAR(50) CHECK (tipe IN ('unit', 'area', 'departemen', 'divisi'));

-- Add backward compatibility columns if they don't exist
ALTER TABLE units ADD COLUMN IF NOT EXISTS kode_unit VARCHAR(50);
ALTER TABLE units ADD COLUMN IF NOT EXISTS nama_unit VARCHAR(255);

-- Set default tipe for existing records
UPDATE units SET tipe = 'unit' WHERE tipe IS NULL;

-- Copy data to compatibility columns if they exist and are empty
-- This uses a safe approach that won't fail if source columns don't exist
DO $$
DECLARE
    kode_exists BOOLEAN := FALSE;
    nama_exists BOOLEAN := FALSE;
BEGIN
    -- Check if kode column exists
    SELECT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'units' AND column_name = 'kode'
    ) INTO kode_exists;

    -- Check if nama column exists
    SELECT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'units' AND column_name = 'nama'
    ) INTO nama_exists;

    -- Only update if both columns exist
    IF kode_exists AND nama_exists THEN
        UPDATE units SET
            kode_unit = CASE WHEN kode_unit IS NULL THEN kode ELSE kode_unit END,
            nama_unit = CASE WHEN nama_unit IS NULL THEN nama ELSE nama_unit END;
    END IF;
END $$;

-- Verify the changes (safe query that doesn't reference potentially missing columns)
SELECT
    id,
    kode_unit,
    nama_unit,
    tipe,
    aktif,
    CASE
        WHEN tipe IS NOT NULL THEN 'HAS_TYPE'
        ELSE 'NO_TYPE'
    END as type_status
FROM units
ORDER BY id
LIMIT 10;
