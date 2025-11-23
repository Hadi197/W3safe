-- Add missing columns to safety_forum table
-- Run this after creating the basic table to add all missing columns

-- Add missing columns to existing safety_forum table
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS unit_id UUID;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS periode VARCHAR(50);
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS ketua_forum UUID;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS notulen_by UUID;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS peserta_wajib TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS peserta_hadir TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS peserta_tidak_hadir TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS agenda_detail JSONB;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS latar_belakang TEXT;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS tujuan_forum TEXT;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS topik_bahaya TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS topik_kecelakaan TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS topik_incident TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS topik_observasi TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS topik_peraturan TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS topik_training TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS topik_lainnya TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS ringkasan_pembahasan TEXT;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS masalah_teridentifikasi TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS risiko_teridentifikasi JSONB;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS keputusan TEXT;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS rekomendasi TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS sop_baru TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS apd_yang_diperlukan TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS training_yang_diperlukan TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS action_items JSONB;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS jumlah_action_item INTEGER DEFAULT 0;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS action_selesai INTEGER DEFAULT 0;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS action_progress INTEGER DEFAULT 0;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS action_belum_mulai INTEGER DEFAULT 0;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS foto_forum TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS dokumen_pendukung TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS notulen_file_url TEXT;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS daftar_hadir_url TEXT;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS presentasi_url TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS forum_sebelumnya_id UUID;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS evaluasi_tindak_lanjut TEXT;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS progress_action_sebelumnya NUMERIC(5,2);
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS jadwal_forum_berikutnya DATE;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS agenda_forum_berikutnya TEXT;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS status_notulen VARCHAR(50) DEFAULT 'belum_dibuat';
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS approved_by UUID;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS approved_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS catatan TEXT;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS tingkat_urgensi VARCHAR(50) DEFAULT 'normal';
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS kategori_forum VARCHAR(100);
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS created_by UUID;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS updated_by UUID;

-- Add missing indexes
CREATE INDEX IF NOT EXISTS idx_safety_forum_unit ON safety_forum(unit_id);
CREATE INDEX IF NOT EXISTS idx_safety_forum_jenis ON safety_forum(jenis_forum);
CREATE INDEX IF NOT EXISTS idx_safety_forum_nomor ON safety_forum(nomor_forum);
CREATE INDEX IF NOT EXISTS idx_safety_forum_status_notulen ON safety_forum(status_notulen);

-- Update existing sample data with new fields
UPDATE safety_forum SET
  periode = 'November 2024',
  latar_belakang = 'Evaluasi rutin bulanan untuk membahas kondisi keselamatan kerja, insiden yang terjadi, dan program K3 yang akan dijalankan bulan depan.',
  tujuan_forum = 'Meningkatkan awareness K3, mengevaluasi insiden, dan merencanakan program K3',
  topik_bahaya = ARRAY['Bahaya jatuh dari ketinggian', 'Bahaya kebakaran', 'Bahaya tertimpa material'],
  topik_kecelakaan = ARRAY['Near miss - Hampir tertimpa pallet', 'Minor injury - Tergores besi'],
  ringkasan_pembahasan = 'Forum membahas 2 insiden minor di bulan Oktober. Teridentifikasi area dermaga memerlukan peningkatan signage dan perbaikan housekeeping. Diputuskan untuk melaksanakan safety patrol intensif dan safety briefing rutin setiap shift.',
  masalah_teridentifikasi = ARRAY['Housekeeping area dermaga kurang baik', 'Rambu K3 di area bongkar muat kurang', 'APD helm tidak digunakan konsisten', 'Akses jalan becek dan licin'],
  rekomendasi = ARRAY['Tambah rambu peringatan di 5 titik area bongkar muat', 'Perbaiki housekeeping area dermaga setiap hari', 'Lakukan safety talk sebelum setiap shift', 'Perbaiki akses jalan dengan cor beton'],
  apd_yang_diperlukan = ARRAY['Helm safety tambahan', 'Safety shoes', 'Safety glasses'],
  training_yang_diperlukan = ARRAY['Safety briefing rutin', 'Housekeeping training', 'APD usage training'],
  action_items = '[
    {"no": 1, "tindakan": "Pemasangan 10 rambu K3 baru di area bongkar muat", "pic": "HSE Team", "target": "2024-11-30", "status": "belum_mulai", "prioritas": "tinggi"},
    {"no": 2, "tindakan": "Perbaikan housekeeping harian area dermaga", "pic": "Supervisor Dermaga", "target": "2024-11-25", "status": "belum_mulai", "prioritas": "tinggi"},
    {"no": 3, "tindakan": "Safety briefing rutin setiap shift", "pic": "HSE Officer", "target": "2024-11-22", "status": "belum_mulai", "prioritas": "sedang"},
    {"no": 4, "tindakan": "Pengecoran akses jalan dermaga", "pic": "Maintenance Team", "target": "2024-12-15", "status": "belum_mulai", "prioritas": "sedang"}
  ]'::jsonb,
  jumlah_action_item = 4,
  action_belum_mulai = 4,
  status_notulen = 'approved',
  tingkat_urgensi = 'tinggi',
  kategori_forum = 'P2K3 Meeting',
  updated_at = NOW()
WHERE id = '0253a239-7f3e-4636-a600-bc491eb00005';

-- Verify the update
SELECT
  id,
  nomor_forum,
  tanggal_forum,
  lokasi,
  agenda_utama,
  apd_yang_diperlukan,
  training_yang_diperlukan,
  jumlah_action_item,
  action_belum_mulai,
  status,
  status_notulen
FROM safety_forum
WHERE id = '0253a239-7f3e-4636-a600-bc491eb00005';
