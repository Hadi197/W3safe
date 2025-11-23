-- Add missing columns to safety_briefing table
-- Run this in Supabase SQL Editor

-- Add area_briefing column
ALTER TABLE safety_briefing ADD COLUMN IF NOT EXISTS area_briefing TEXT;

-- Add topik_briefing column (rename from topik if exists, or create new)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'safety_briefing' AND column_name = 'topik_briefing') THEN
        ALTER TABLE safety_briefing ADD COLUMN topik_briefing TEXT;
        -- Copy data from topik to topik_briefing if topik exists
        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'safety_briefing' AND column_name = 'topik') THEN
            UPDATE safety_briefing SET topik_briefing = topik WHERE topik_briefing IS NULL;
        END IF;
    END IF;
END $$;

-- Add materi_briefing column
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'safety_briefing' AND column_name = 'materi_briefing') THEN
        ALTER TABLE safety_briefing ADD COLUMN materi_briefing TEXT;
        -- Copy data from materi to materi_briefing if materi exists
        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'safety_briefing' AND column_name = 'materi') THEN
            UPDATE safety_briefing SET materi_briefing = materi WHERE materi_briefing IS NULL;
        END IF;
    END IF;
END $$;

-- Add poin_poin_pembahasan column
ALTER TABLE safety_briefing ADD COLUMN IF NOT EXISTS poin_poin_pembahasan JSONB;

-- Add kesimpulan column
ALTER TABLE safety_briefing ADD COLUMN IF NOT EXISTS kesimpulan TEXT;

-- Add foto_briefing column (rename from foto_dokumentasi if exists, or create new)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'safety_briefing' AND column_name = 'foto_briefing') THEN
        ALTER TABLE safety_briefing ADD COLUMN foto_briefing JSONB;
        -- Copy data from foto_dokumentasi to foto_briefing if foto_dokumentasi exists
        IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'safety_briefing' AND column_name = 'foto_dokumentasi') THEN
            UPDATE safety_briefing SET foto_briefing = foto_dokumentasi WHERE foto_briefing IS NULL;
        END IF;
    END IF;
END $$;

-- Add jenis_briefing column
ALTER TABLE safety_briefing ADD COLUMN IF NOT EXISTS jenis_briefing VARCHAR(50);

-- Add inspector_id column (if different from petugas_id)
ALTER TABLE safety_briefing ADD COLUMN IF NOT EXISTS inspector_id UUID REFERENCES pegawai(id) ON DELETE SET NULL;

-- Verify the changes
SELECT
    id,
    tanggal,
    area_briefing,
    topik_briefing,
    materi_briefing,
    poin_poin_pembahasan,
    kesimpulan,
    foto_briefing,
    jenis_briefing,
    status
FROM safety_briefing
ORDER BY created_at DESC
LIMIT 3;
