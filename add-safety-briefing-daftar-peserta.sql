-- Fix Safety Briefing missing columns
-- Run this in Supabase SQL Editor

-- Add missing daftar_peserta column
ALTER TABLE safety_briefing 
ADD COLUMN IF NOT EXISTS daftar_peserta TEXT[];

-- Verify all columns exist
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'safety_briefing'
ORDER BY ordinal_position;
