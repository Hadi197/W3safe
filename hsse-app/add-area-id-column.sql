-- Add area_id column to units table
-- Run this FIRST before reset-units-data.sql

-- 1. Add column area_id if not exists
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'units' AND column_name = 'area_id'
    ) THEN
        ALTER TABLE units ADD COLUMN area_id UUID;
        RAISE NOTICE 'Column area_id added successfully';
    ELSE
        RAISE NOTICE 'Column area_id already exists';
    END IF;
END $$;

-- 2. Add foreign key for units.area_id (self-reference to units table)
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'fk_units_area'
    ) THEN
        ALTER TABLE units ADD CONSTRAINT fk_units_area 
        FOREIGN KEY (area_id) REFERENCES units(id) ON DELETE SET NULL;
        RAISE NOTICE 'Foreign key fk_units_area added successfully';
    ELSE
        RAISE NOTICE 'Foreign key fk_units_area already exists';
    END IF;
END $$;

-- 3. Add index for performance
CREATE INDEX IF NOT EXISTS idx_units_area ON units(area_id);

-- 4. Verify
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'units'
ORDER BY ordinal_position;
