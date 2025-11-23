-- Add missing columns to units table
-- Run this in Supabase SQL Editor

-- First, check current structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'units'
ORDER BY ordinal_position;

-- Add tipe column to units table
ALTER TABLE units ADD COLUMN IF NOT EXISTS tipe VARCHAR(50) CHECK (tipe IN ('unit', 'area', 'departemen', 'divisi'));

-- Add kode_unit column (if not exists) for backward compatibility
ALTER TABLE units ADD COLUMN IF NOT EXISTS kode_unit VARCHAR(50);

-- Add nama_unit column (if not exists) for backward compatibility
ALTER TABLE units ADD COLUMN IF NOT EXISTS nama_unit VARCHAR(255);

-- Check if 'kode' column exists before trying to update
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'kode') THEN
        UPDATE units SET kode_unit = kode WHERE kode_unit IS NULL;
    END IF;
END $$;

-- Check if 'nama' column exists before trying to update
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'nama') THEN
        UPDATE units SET nama_unit = nama WHERE nama_unit IS NULL;
    END IF;
END $$;

-- Update tipe column based on existing data or set default to 'unit'
UPDATE units SET tipe = 'unit' WHERE tipe IS NULL;

-- Verify the changes
SELECT
    id,
    COALESCE(kode_unit, kode) as kode_display,
    COALESCE(nama_unit, nama) as nama_display,
    tipe,
    aktif
FROM units
LIMIT 10;
