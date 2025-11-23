-- Add missing columns to safety_induction table
-- Based on interface and Vue component usage

-- Add missing columns
ALTER TABLE safety_induction
ADD COLUMN IF NOT EXISTS sertifikat_diterbitkan BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS nomor_sertifikat VARCHAR,
ADD COLUMN IF NOT EXISTS tanggal_terbit_sertifikat DATE,
ADD COLUMN IF NOT EXISTS masa_berlaku_bulan INTEGER,
ADD COLUMN IF NOT EXISTS tanggal_expired DATE,
ADD COLUMN IF NOT EXISTS file_sertifikat VARCHAR,

-- Re-Induction
ADD COLUMN IF NOT EXISTS perlu_reinduction BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS tanggal_reinduction_scheduled DATE,
ADD COLUMN IF NOT EXISTS alasan_reinduction TEXT,

-- Additional Documentation
ADD COLUMN IF NOT EXISTS foto_kegiatan TEXT[], -- Array of photo URLs
ADD COLUMN IF NOT EXISTS video_induction VARCHAR,
ADD COLUMN IF NOT EXISTS materi_presentasi TEXT[], -- Array of presentation URLs

-- Signatures
ADD COLUMN IF NOT EXISTS waktu_hadir TIME,
ADD COLUMN IF NOT EXISTS tanda_tangan_peserta VARCHAR, -- URL to signature image
ADD COLUMN IF NOT EXISTS tanda_tangan_instruktur VARCHAR, -- URL to signature image
ADD COLUMN IF NOT EXISTS tanda_tangan_pic_hse VARCHAR, -- URL to signature image

-- Ratings
ADD COLUMN IF NOT EXISTS rating_materi INTEGER CHECK (rating_materi >= 1 AND rating_materi <= 5),
ADD COLUMN IF NOT EXISTS rating_instruktur INTEGER CHECK (rating_instruktur >= 1 AND rating_instruktur <= 5),
ADD COLUMN IF NOT EXISTS rating_overall INTEGER CHECK (rating_overall >= 1 AND rating_overall <= 5),

-- Additional fields
ADD COLUMN IF NOT EXISTS catatan_khusus TEXT,
ADD COLUMN IF NOT EXISTS feedback_tambahan TEXT;

-- Update existing records to have empty arrays where needed
UPDATE safety_induction SET
    foto_kegiatan = COALESCE(foto_kegiatan, ARRAY[]::TEXT[]),
    materi_presentasi = COALESCE(materi_presentasi, ARRAY[]::TEXT[])
WHERE foto_kegiatan IS NULL OR materi_presentasi IS NULL;

-- Verify columns were added
SELECT
    'safety_induction columns after update:' as info,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'safety_induction'
  AND column_name IN ('tanggal_expired', 'rating_materi', 'rating_instruktur', 'sertifikat_diterbitkan', 'nomor_sertifikat')
ORDER BY column_name;
