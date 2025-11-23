-- Fix safety_briefing table columns to match API expectations
-- Add missing columns or rename incorrect ones

-- First, add missing columns if they don't exist
ALTER TABLE safety_briefing ADD COLUMN IF NOT EXISTS catatan TEXT;

-- Check if we need to rename foto_briefing to foto_dokumentasi
-- If foto_dokumentasi doesn't exist but foto_briefing does, rename it
DO $$
BEGIN
    -- Step 1: Handle foto_briefing -> foto_dokumentasi conversion
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'safety_briefing' AND column_name = 'foto_briefing'
    ) THEN
        -- Convert jsonb array to text array first, then rename
        -- Create a temporary text array column
        ALTER TABLE safety_briefing ADD COLUMN temp_foto_dokumentasi TEXT[];

        -- Convert jsonb data to text array
        UPDATE safety_briefing SET temp_foto_dokumentasi = CASE
            WHEN foto_briefing IS NULL THEN ARRAY[]::TEXT[]
            WHEN jsonb_typeof(foto_briefing) = 'array' THEN
                ARRAY(SELECT jsonb_array_elements_text(foto_briefing))
            ELSE ARRAY[]::TEXT[]
        END;

        -- Drop old column and rename new one
        ALTER TABLE safety_briefing DROP COLUMN foto_briefing;
        ALTER TABLE safety_briefing RENAME COLUMN temp_foto_dokumentasi TO foto_dokumentasi;
        RAISE NOTICE 'Converted foto_briefing (jsonb) to foto_dokumentasi (text[])';
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

-- Initialize foto_dokumentasi with empty arrays where needed
UPDATE safety_briefing SET
    foto_dokumentasi = COALESCE(foto_dokumentasi, ARRAY[]::TEXT[])
WHERE foto_dokumentasi IS NULL;
RAISE NOTICE 'Initialized NULL foto_dokumentasi values with empty arrays';

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
