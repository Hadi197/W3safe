-- Add nama and aktif columns to wilayah table for frontend compatibility
ALTER TABLE wilayah
ADD COLUMN IF NOT EXISTS nama VARCHAR(100),
ADD COLUMN IF NOT EXISTS aktif BOOLEAN DEFAULT true;

-- Update wilayah nama column to match nama_wilayah
UPDATE wilayah SET nama = nama_wilayah WHERE nama IS NULL;
UPDATE wilayah SET aktif = CASE WHEN status = 'aktif' THEN true ELSE false END;
