-- =====================================================
-- SCHEMA MIGRATION - Update column names to match frontend expectations
-- Run this AFTER the initial database setup to fix column name mismatches
-- =====================================================

-- Rename columns in units table to match frontend expectations
DO $$
BEGIN
  -- Rename kode_unit to kode
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'kode_unit')
     AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'kode') THEN
    ALTER TABLE units RENAME COLUMN kode_unit TO kode;
    RAISE NOTICE 'Renamed kode_unit to kode in units table';
  END IF;

  -- Rename nama_unit to nama
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'nama_unit')
     AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'nama') THEN
    ALTER TABLE units RENAME COLUMN nama_unit TO nama;
    RAISE NOTICE 'Renamed nama_unit to nama in units table';
  END IF;

  -- Add tipe column if it doesn't exist
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'tipe') THEN
    ALTER TABLE units ADD COLUMN tipe VARCHAR(20) DEFAULT 'unit';
    RAISE NOTICE 'Added tipe column to units table';
  END IF;

  -- Add area_id column if it doesn't exist
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'area_id') THEN
    ALTER TABLE units ADD COLUMN area_id UUID REFERENCES units(id) ON DELETE SET NULL;
    RAISE NOTICE 'Added area_id column to units table';
  END IF;

  -- Convert status to aktif (boolean)
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'status')
     AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'aktif') THEN
    ALTER TABLE units ADD COLUMN aktif BOOLEAN DEFAULT true;
    UPDATE units SET aktif = CASE WHEN status = 'aktif' THEN true ELSE false END;
    ALTER TABLE units DROP COLUMN status;
    RAISE NOTICE 'Converted status to aktif boolean column in units table';
  END IF;

  -- Rename columns in wilayah table
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'wilayah' AND column_name = 'nama_wilayah')
     AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'wilayah' AND column_name = 'nama') THEN
    ALTER TABLE wilayah RENAME COLUMN nama_wilayah TO nama;
    RAISE NOTICE 'Renamed nama_wilayah to nama in wilayah table';
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'wilayah' AND column_name = 'kode_wilayah')
     AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'wilayah' AND column_name = 'kode') THEN
    ALTER TABLE wilayah RENAME COLUMN kode_wilayah TO kode;
    RAISE NOTICE 'Renamed kode_wilayah to kode in wilayah table';
  END IF;

  -- Convert status to aktif in wilayah table
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'wilayah' AND column_name = 'status')
     AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'wilayah' AND column_name = 'aktif') THEN
    ALTER TABLE wilayah ADD COLUMN aktif BOOLEAN DEFAULT true;
    UPDATE wilayah SET aktif = CASE WHEN status = 'aktif' THEN true ELSE false END;
    ALTER TABLE wilayah DROP COLUMN status;
    RAISE NOTICE 'Converted status to aktif boolean column in wilayah table';
  END IF;

END $$;

-- Update existing data to use new column names
UPDATE units SET tipe = 'unit' WHERE tipe IS NULL;
UPDATE units SET aktif = true WHERE aktif IS NULL;
UPDATE wilayah SET aktif = true WHERE aktif IS NULL;

-- Recreate indexes with new column names
DROP INDEX IF EXISTS idx_units_kode;
DROP INDEX IF EXISTS idx_units_status;
DROP INDEX IF EXISTS idx_wilayah_kode;
DROP INDEX IF EXISTS idx_wilayah_status;

CREATE INDEX IF NOT EXISTS idx_units_kode ON units(kode);
CREATE INDEX IF NOT EXISTS idx_units_aktif ON units(aktif);
CREATE INDEX IF NOT EXISTS idx_units_tipe ON units(tipe);
CREATE INDEX IF NOT EXISTS idx_wilayah_kode ON wilayah(kode);
CREATE INDEX IF NOT EXISTS idx_wilayah_aktif ON wilayah(aktif);

-- Verify the migration
SELECT 'Schema migration completed successfully!' as status;
SELECT
  'units' as table_name, COUNT(*) as row_count FROM units
UNION ALL
SELECT 'wilayah', COUNT(*) FROM wilayah;