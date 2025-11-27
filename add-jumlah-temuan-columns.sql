-- Add jumlah_temuan columns to all tables if not exists

-- 1. Safety Patrol
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name='safety_patrol' AND column_name='jumlah_temuan') THEN
        ALTER TABLE safety_patrol ADD COLUMN jumlah_temuan INTEGER DEFAULT 0;
    END IF;
END $$;

-- 2. Management Walkthrough
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name='management_walkthrough' AND column_name='jumlah_temuan') THEN
        ALTER TABLE management_walkthrough ADD COLUMN jumlah_temuan INTEGER DEFAULT 0;
    END IF;
END $$;

-- 3. Silent Inspection
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name='silent_inspection' AND column_name='jumlah_temuan') THEN
        ALTER TABLE silent_inspection ADD COLUMN jumlah_temuan INTEGER DEFAULT 0;
    END IF;
END $$;

-- 4. Safety Drill  
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name='safety_drill' AND column_name='jumlah_temuan') THEN
        ALTER TABLE safety_drill ADD COLUMN jumlah_temuan INTEGER DEFAULT 0;
    END IF;
END $$;

-- Update jumlah_temuan from existing data

-- Safety Patrol: sum of kritikal, mayor, minor
UPDATE safety_patrol 
SET jumlah_temuan = COALESCE(temuan_kritikal, 0) + COALESCE(temuan_mayor, 0) + COALESCE(temuan_minor, 0)
WHERE jumlah_temuan IS NULL OR jumlah_temuan = 0;

-- Management Walkthrough: sum of kritis, mayor, minor
UPDATE management_walkthrough 
SET jumlah_temuan = COALESCE(temuan_kritis, 0) + COALESCE(temuan_mayor, 0) + COALESCE(temuan_minor, 0)
WHERE jumlah_temuan IS NULL OR jumlah_temuan = 0;

-- Silent Inspection: sum of critical, major, minor
UPDATE silent_inspection 
SET jumlah_temuan = COALESCE(temuan_critical, 0) + COALESCE(temuan_major, 0) + COALESCE(temuan_minor, 0)
WHERE jumlah_temuan IS NULL OR jumlah_temuan = 0;

-- Safety Drill: sum of kritis, mayor, minor
UPDATE safety_drill 
SET jumlah_temuan = COALESCE(temuan_kritis, 0) + COALESCE(temuan_mayor, 0) + COALESCE(temuan_minor, 0)
WHERE jumlah_temuan IS NULL OR jumlah_temuan = 0;

-- Verify the updates
SELECT 'safety_patrol' as table_name, COUNT(*) as records, SUM(jumlah_temuan) as total_temuan FROM safety_patrol
UNION ALL
SELECT 'management_walkthrough', COUNT(*), SUM(jumlah_temuan) FROM management_walkthrough
UNION ALL
SELECT 'silent_inspection', COUNT(*), SUM(jumlah_temuan) FROM silent_inspection
UNION ALL
SELECT 'safety_drill', COUNT(*), SUM(jumlah_temuan) FROM safety_drill;
