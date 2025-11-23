-- Minimal fix for units table - just add the missing tipe column
-- Run this in Supabase SQL Editor

-- This is the absolute minimum fix needed to resolve the 400 error
-- Add tipe column to units table (this is what causes the error)
ALTER TABLE units ADD COLUMN IF NOT EXISTS tipe VARCHAR(50) CHECK (tipe IN ('unit', 'area', 'departemen', 'divisi'));

-- Set default value for existing records
UPDATE units SET tipe = 'unit' WHERE tipe IS NULL;

-- Verify only the tipe column was added
SELECT
    id,
    tipe,
    aktif
FROM units
ORDER BY id
LIMIT 5;
