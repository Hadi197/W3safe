-- Add missing skor_total column to silent_inspection table
ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS skor_total DECIMAL(5,2);