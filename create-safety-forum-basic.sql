-- =====================================================
-- BASIC: Create Minimal Safety Forum Table
-- Run this FIRST in Supabase SQL Editor
-- =====================================================

-- Drop table if exists to start fresh
DROP TABLE IF EXISTS safety_forum CASCADE;

-- Create safety_forum table with minimal columns
CREATE TABLE safety_forum (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Basic required fields for INSERT
  nomor_forum VARCHAR(50) UNIQUE NOT NULL,
  tanggal_forum DATE NOT NULL,
  waktu_mulai TIME NOT NULL,
  waktu_selesai TIME,
  lokasi VARCHAR(200) NOT NULL,
  jenis_forum VARCHAR(50) NOT NULL DEFAULT 'rutin',
  periode VARCHAR(50),
  agenda_utama TEXT NOT NULL,
  latar_belakang TEXT,
  tujuan_forum TEXT,
  topik_bahaya TEXT[],
  topik_kecelakaan TEXT[],
  ringkasan_pembahasan TEXT,
  masalah_teridentifikasi TEXT[],
  rekomendasi TEXT[],
  action_items JSONB,
  jumlah_action_item INTEGER DEFAULT 0,
  action_belum_mulai INTEGER DEFAULT 0,
  jumlah_peserta INTEGER DEFAULT 0,
  status VARCHAR(50) NOT NULL DEFAULT 'draft',
  status_notulen VARCHAR(50) DEFAULT 'belum_dibuat',
  tingkat_urgensi VARCHAR(50) DEFAULT 'normal',
  kategori_forum VARCHAR(100),

  -- Audit fields
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create basic indexes
CREATE INDEX idx_safety_forum_tanggal ON safety_forum(tanggal_forum DESC);
CREATE INDEX idx_safety_forum_status ON safety_forum(status);
CREATE INDEX idx_safety_forum_created_at ON safety_forum(created_at DESC);

-- Enable Row Level Security
ALTER TABLE safety_forum ENABLE ROW LEVEL SECURITY;

-- Create basic policies
CREATE POLICY "Allow authenticated users to read safety forum"
  ON safety_forum FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated users to insert safety forum"
  ON safety_forum FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Insert sample data
INSERT INTO safety_forum (
  nomor_forum,
  tanggal_forum,
  waktu_mulai,
  waktu_selesai,
  lokasi,
  jenis_forum,
  periode,
  agenda_utama,
  latar_belakang,
  tujuan_forum,
  topik_bahaya,
  topik_kecelakaan,
  ringkasan_pembahasan,
  masalah_teridentifikasi,
  rekomendasi,
  action_items,
  jumlah_action_item,
  action_belum_mulai,
  jumlah_peserta,
  status,
  status_notulen,
  tingkat_urgensi,
  kategori_forum
) VALUES (
  'SF-2024-11-001',
  '2024-11-20',
  '09:00:00',
  '11:30:00',
  'Ruang Rapat Utama',
  'rutin',
  'November 2024',
  'Evaluasi Keselamatan Kerja Bulan Oktober & Program K3 November',
  'Evaluasi rutin bulanan untuk membahas kondisi keselamatan kerja, insiden yang terjadi, dan program K3 yang akan dijalankan bulan depan.',
  'Meningkatkan awareness K3, mengevaluasi insiden, dan merencanakan program K3',
  ARRAY['Bahaya jatuh dari ketinggian', 'Bahaya kebakaran', 'Bahaya tertimpa material'],
  ARRAY['Near miss - Hampir tertimpa pallet', 'Minor injury - Tergores besi'],
  'Forum membahas 2 insiden minor di bulan Oktober. Teridentifikasi area dermaga memerlukan peningkatan signage dan perbaikan housekeeping.',
  ARRAY['Housekeeping area dermaga kurang baik', 'Rambu K3 di area bongkar muat kurang'],
  ARRAY['Tambah rambu peringatan di 5 titik area bongkar muat', 'Perbaiki housekeeping area dermaga setiap hari'],
  '[
    {"no": 1, "tindakan": "Pemasangan 10 rambu K3 baru", "pic": "HSE Team", "target": "2024-11-30", "status": "belum_mulai", "prioritas": "tinggi"},
    {"no": 2, "tindakan": "Perbaikan housekeeping harian", "pic": "Supervisor Dermaga", "target": "2024-11-25", "status": "belum_mulai", "prioritas": "tinggi"}
  ]'::jsonb,
  2,
  2,
  15,
  'completed',
  'approved',
  'tinggi',
  'P2K3 Meeting'
);

-- Show result
SELECT id, nomor_forum, tanggal_forum, lokasi, agenda_utama, jumlah_peserta, status
FROM safety_forum
ORDER BY created_at DESC
LIMIT 5;
