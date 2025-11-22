-- Migrasi database untuk Safety Forum
-- Safety Forum adalah forum/rapat berkala membahas isu keselamatan kerja

-- Hapus tabel jika sudah ada
DROP TABLE IF EXISTS safety_forum CASCADE;

-- Buat tabel safety_forum
CREATE TABLE safety_forum (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Data Dasar Forum
  nomor_forum VARCHAR(50) UNIQUE NOT NULL, -- Contoh: SF-2024-001
  tanggal_forum DATE NOT NULL,
  waktu_mulai TIME NOT NULL,
  waktu_selesai TIME,
  unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
  lokasi VARCHAR(200) NOT NULL, -- Lokasi pelaksanaan forum
  jenis_forum VARCHAR(50) NOT NULL DEFAULT 'rutin', -- rutin, insidental, darurat
  periode VARCHAR(50), -- Contoh: Januari 2024, Q1 2024, Minggu ke-1
  
  -- Pimpinan & Peserta
  ketua_forum UUID REFERENCES pegawai(id), -- Ketua/moderator forum
  notulen_by UUID REFERENCES pegawai(id), -- Pembuat notulen/risalah
  peserta_wajib TEXT[], -- Array UUID pegawai yang wajib hadir
  peserta_hadir TEXT[], -- Array UUID pegawai yang hadir
  peserta_tidak_hadir TEXT[], -- Array UUID pegawai yang tidak hadir
  jumlah_peserta INTEGER DEFAULT 0, -- Total peserta hadir
  
  -- Agenda & Pembahasan
  agenda_utama TEXT NOT NULL, -- Topik utama yang dibahas
  agenda_detail JSONB, -- Detail agenda dalam format [{no: 1, topik: "", pembicara: "", durasi: ""}]
  latar_belakang TEXT, -- Latar belakang dilaksanakannya forum
  tujuan_forum TEXT, -- Tujuan pelaksanaan forum
  
  -- Materi Pembahasan
  topik_bahaya TEXT[], -- Array topik bahaya yang dibahas
  topik_kecelakaan TEXT[], -- Array topik kecelakaan yang dibahas
  topik_incident TEXT[], -- Array topik incident/near miss
  topik_observasi TEXT[], -- Array topik hasil observasi lapangan
  topik_peraturan TEXT[], -- Array topik peraturan K3 baru
  topik_training TEXT[], -- Array topik training K3
  topik_lainnya TEXT[], -- Topik pembahasan lainnya
  
  -- Hasil Pembahasan
  ringkasan_pembahasan TEXT, -- Ringkasan hasil pembahasan
  masalah_teridentifikasi TEXT[], -- Array masalah K3 yang teridentifikasi
  risiko_teridentifikasi JSONB, -- [{masalah: "", tingkat_risiko: "", dampak: ""}]
  
  -- Keputusan & Rekomendasi
  keputusan TEXT, -- Keputusan hasil forum
  rekomendasi TEXT[], -- Array rekomendasi K3
  sop_baru TEXT[], -- Array SOP baru yang diusulkan
  apd_yang_diperlukan TEXT[], -- Array APD yang perlu disediakan
  training_yang_diperlukan TEXT[], -- Array training yang perlu dilaksanakan
  
  -- Action Items / Tindak Lanjut
  action_items JSONB, -- [{no: 1, tindakan: "", pic: "", target: "", status: "", prioritas: ""}]
  jumlah_action_item INTEGER DEFAULT 0,
  action_selesai INTEGER DEFAULT 0,
  action_progress INTEGER DEFAULT 0,
  action_belum_mulai INTEGER DEFAULT 0,
  
  -- Dokumentasi
  foto_forum TEXT[], -- Array URL foto kegiatan forum
  dokumen_pendukung TEXT[], -- Array URL dokumen (PDF, Excel, dll)
  notulen_file_url TEXT, -- URL file notulen/risalah rapat
  daftar_hadir_url TEXT, -- URL scan daftar hadir
  presentasi_url TEXT[], -- Array URL file presentasi
  
  -- Evaluasi & Tindak Lanjut Forum Sebelumnya
  forum_sebelumnya_id UUID REFERENCES safety_forum(id),
  evaluasi_tindak_lanjut TEXT, -- Evaluasi tindak lanjut forum sebelumnya
  progress_action_sebelumnya NUMERIC(5,2), -- Persentase progress action items forum sebelumnya
  
  -- Forum Selanjutnya
  jadwal_forum_berikutnya DATE, -- Tanggal forum berikutnya
  agenda_forum_berikutnya TEXT, -- Rencana agenda forum berikutnya
  
  -- Status & Approval
  status VARCHAR(50) NOT NULL DEFAULT 'draft', -- draft, scheduled, completed, cancelled
  status_notulen VARCHAR(50) DEFAULT 'belum_dibuat', -- belum_dibuat, draft, review, approved
  approved_by UUID REFERENCES pegawai(id), -- Yang menyetujui notulen
  approved_at TIMESTAMP WITH TIME ZONE,
  
  -- Catatan & Metadata
  catatan TEXT,
  tingkat_urgensi VARCHAR(50) DEFAULT 'normal', -- rendah, normal, tinggi, kritis
  kategori_forum VARCHAR(100), -- Contoh: P2K3, HSE Committee, Safety Meeting
  
  -- Audit Trail
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES pegawai(id),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_by UUID REFERENCES pegawai(id)
);

-- Tambah constraint untuk validasi
ALTER TABLE safety_forum ADD CONSTRAINT check_jenis_forum 
  CHECK (jenis_forum IN ('rutin', 'insidental', 'darurat', 'tahunan', 'bulanan', 'mingguan'));

ALTER TABLE safety_forum ADD CONSTRAINT check_status 
  CHECK (status IN ('draft', 'scheduled', 'in_progress', 'completed', 'cancelled', 'rescheduled'));

ALTER TABLE safety_forum ADD CONSTRAINT check_status_notulen 
  CHECK (status_notulen IN ('belum_dibuat', 'draft', 'review', 'approved', 'rejected'));

ALTER TABLE safety_forum ADD CONSTRAINT check_tingkat_urgensi 
  CHECK (tingkat_urgensi IN ('rendah', 'normal', 'tinggi', 'kritis'));

ALTER TABLE safety_forum ADD CONSTRAINT check_waktu_valid 
  CHECK (waktu_selesai IS NULL OR waktu_selesai > waktu_mulai);

ALTER TABLE safety_forum ADD CONSTRAINT check_jumlah_peserta_valid 
  CHECK (jumlah_peserta >= 0);

ALTER TABLE safety_forum ADD CONSTRAINT check_action_counts_valid 
  CHECK (
    jumlah_action_item >= 0 AND
    action_selesai >= 0 AND
    action_progress >= 0 AND
    action_belum_mulai >= 0 AND
    (action_selesai + action_progress + action_belum_mulai) <= jumlah_action_item
  );

-- Buat indexes untuk performa query
CREATE INDEX idx_safety_forum_tanggal ON safety_forum(tanggal_forum DESC);
CREATE INDEX idx_safety_forum_unit ON safety_forum(unit_id);
CREATE INDEX idx_safety_forum_status ON safety_forum(status);
CREATE INDEX idx_safety_forum_jenis ON safety_forum(jenis_forum);
CREATE INDEX idx_safety_forum_ketua ON safety_forum(ketua_forum);
CREATE INDEX idx_safety_forum_created_at ON safety_forum(created_at DESC);
CREATE INDEX idx_safety_forum_nomor ON safety_forum(nomor_forum);
CREATE INDEX idx_safety_forum_status_notulen ON safety_forum(status_notulen);

-- Buat trigger untuk update timestamp
CREATE OR REPLACE FUNCTION update_safety_forum_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_safety_forum_timestamp
  BEFORE UPDATE ON safety_forum
  FOR EACH ROW
  EXECUTE FUNCTION update_safety_forum_timestamp();

-- Enable Row Level Security
ALTER TABLE safety_forum ENABLE ROW LEVEL SECURITY;

-- Policy: Semua user authenticated bisa melihat
CREATE POLICY "Allow authenticated users to read safety forum"
  ON safety_forum FOR SELECT
  TO authenticated
  USING (true);

-- Policy: Semua user authenticated bisa insert
CREATE POLICY "Allow authenticated users to insert safety forum"
  ON safety_forum FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Policy: User bisa update data sendiri atau yang dibuat unitnya
CREATE POLICY "Allow authenticated users to update safety forum"
  ON safety_forum FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Policy: User bisa delete data sendiri
CREATE POLICY "Allow authenticated users to delete safety forum"
  ON safety_forum FOR DELETE
  TO authenticated
  USING (true);

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
  'Forum membahas 2 insiden minor di bulan Oktober. Teridentifikasi area dermaga memerlukan peningkatan signage dan perbaikan housekeeping. Diputuskan untuk melaksanakan safety patrol intensif dan safety briefing rutin setiap shift.',
  ARRAY['Housekeeping area dermaga kurang baik', 'Rambu K3 di area bongkar muat kurang', 'APD helm tidak digunakan konsisten', 'Akses jalan becek dan licin'],
  ARRAY['Tambah rambu peringatan di 5 titik area bongkar muat', 'Perbaiki housekeeping area dermaga setiap hari', 'Lakukan safety talk sebelum setiap shift', 'Perbaiki akses jalan dengan cor beton'],
  '[
    {"no": 1, "tindakan": "Pemasangan 10 rambu K3 baru di area bongkar muat", "pic": "HSE Team", "target": "2024-11-30", "status": "belum_mulai", "prioritas": "tinggi"},
    {"no": 2, "tindakan": "Perbaikan housekeeping harian area dermaga", "pic": "Supervisor Dermaga", "target": "2024-11-25", "status": "belum_mulai", "prioritas": "tinggi"},
    {"no": 3, "tindakan": "Safety briefing rutin setiap shift", "pic": "HSE Officer", "target": "2024-11-22", "status": "belum_mulai", "prioritas": "sedang"},
    {"no": 4, "tindakan": "Pengecoran akses jalan dermaga", "pic": "Maintenance Team", "target": "2024-12-15", "status": "belum_mulai", "prioritas": "sedang"}
  ]'::jsonb,
  4,
  4,
  15,
  'completed',
  'approved',
  'tinggi',
  'P2K3 Meeting'
);

-- Tampilkan hasil
SELECT id, nomor_forum, tanggal_forum, agenda_utama, jumlah_peserta, jumlah_action_item, status
FROM safety_forum
ORDER BY created_at DESC
LIMIT 5;
