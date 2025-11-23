-- Add aktif column to units table
ALTER TABLE units ADD COLUMN IF NOT EXISTS aktif BOOLEAN DEFAULT true;

-- Update existing records to set aktif based on status
UPDATE units SET aktif = CASE WHEN status = 'aktif' THEN true ELSE false END WHERE aktif IS NULL;