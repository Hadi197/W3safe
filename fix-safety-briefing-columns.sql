-- Fix safety_briefing table columns to match API expectations
-- Add missing columns or rename incorrect ones

-- First, add missing columns if they don't exist
ALTER TABLE safety_briefing ADD COLUMN IF NOT EXISTS catatan TEXT;

-- Check if we need to rename foto_briefing to foto_dokumentasi
-- If foto_dokumentasi doesn't exist but foto_briefing does, rename it
DO $$
BEGIN
    -- Check if foto_dokumentasi column exists
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'safety_briefing' AND column_name = 'foto_dokumentasi'
    ) AND EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'safety_briefing' AND column_name = 'foto_briefing'
    ) THEN
        -- Rename foto_briefing to foto_dokumentasi
        ALTER TABLE safety_briefing RENAME COLUMN foto_briefing TO foto_dokumentasi;
        RAISE NOTICE 'Renamed foto_briefing to foto_dokumentasi';
    END IF;

    -- Ensure catatan column exists
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'safety_briefing' AND column_name = 'catatan'
    ) THEN
        ALTER TABLE safety_briefing ADD COLUMN catatan TEXT;
        RAISE NOTICE 'Added catatan column';
    END IF;

    -- Ensure jumlah_peserta column exists
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'safety_briefing' AND column_name = 'jumlah_peserta'
    ) THEN
        ALTER TABLE safety_briefing ADD COLUMN jumlah_peserta INTEGER DEFAULT 0;
        RAISE NOTICE 'Added jumlah_peserta column';
    END IF;

END $$;

-- Update any existing NULL values safely
UPDATE safety_briefing SET
    catatan = COALESCE(catatan, ''),
    jumlah_peserta = COALESCE(jumlah_peserta, 0)
WHERE catatan IS NULL
   OR jumlah_peserta IS NULL;

-- Handle foto_dokumentasi based on its actual type
DO $$
DECLARE
    col_type TEXT;
BEGIN
    -- Check the actual type of foto_dokumentasi column
    SELECT data_type INTO col_type
    FROM information_schema.columns
    WHERE table_name = 'safety_briefing' AND column_name = 'foto_dokumentasi';

    RAISE NOTICE 'foto_dokumentasi column type: %', col_type;

    -- Handle based on type
    IF col_type = 'ARRAY' THEN
        -- It's already text array
        UPDATE safety_briefing SET
            foto_dokumentasi = COALESCE(foto_dokumentasi, ARRAY[]::TEXT[])
        WHERE foto_dokumentasi IS NULL;
        RAISE NOTICE 'Initialized foto_dokumentasi as text array';
    ELSIF col_type = 'jsonb' THEN
        -- It's jsonb, API expects text array, so convert jsonb array to text array
        -- First ensure it's an array, then convert
        UPDATE safety_briefing SET
            foto_dokumentasi = CASE
                WHEN foto_dokumentasi IS NULL THEN ARRAY[]::TEXT[]
                WHEN jsonb_typeof(foto_dokumentasi) = 'array' THEN
                    -- Convert jsonb array to text array
                    ARRAY(SELECT jsonb_array_elements_text(foto_dokumentasi))
                ELSE ARRAY[]::TEXT[]
            END;
        RAISE NOTICE 'Converted foto_dokumentasi from jsonb to text array';

        -- Now change column type to text array
        ALTER TABLE safety_briefing ALTER COLUMN foto_dokumentasi TYPE TEXT[];
        RAISE NOTICE 'Changed foto_dokumentasi column type to text[]';
    ELSE
        RAISE NOTICE 'foto_dokumentasi type % not handled, skipping initialization', col_type;
    END IF;
END $$;

-- Verify the fixes
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'safety_briefing'
    AND column_name IN ('foto_dokumentasi', 'catatan', 'jumlah_peserta', 'foto_briefing')
ORDER BY column_name;

-- Check sample data after fixes
SELECT
    id,
    topik,
    jumlah_peserta,
    CASE
        WHEN foto_dokumentasi IS NOT NULL AND array_length(foto_dokumentasi, 1) > 0
        THEN 'Has ' || array_length(foto_dokumentasi, 1) || ' photos'
        ELSE 'No photos'
    END as foto_status,
    CASE
        WHEN catatan IS NOT NULL AND catatan != ''
        THEN 'Has notes'
        ELSE 'No notes'
    END as catatan_status
FROM safety_briefing
LIMIT 3;
