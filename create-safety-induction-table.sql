-- Create safety_induction table
-- Based on SafetyInduction interface from safety-induction.service.ts

CREATE TABLE IF NOT EXISTS safety_induction (
  -- Primary key
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Basic information
  nomor_induction VARCHAR NOT NULL,

  -- Data Peserta
  nama_peserta VARCHAR NOT NULL,
  nik VARCHAR,
  no_identitas VARCHAR,
  perusahaan VARCHAR NOT NULL,
  jabatan VARCHAR,
  departemen VARCHAR,
  no_telepon VARCHAR,
  email VARCHAR,
  foto_peserta VARCHAR, -- URL to photo

  -- Jenis Peserta
  jenis_peserta VARCHAR CHECK (jenis_peserta IN ('karyawan_baru', 'karyawan_pindah', 'kontraktor', 'vendor', 'tamu', 'mahasiswa_pkl', 'tamu_vip')),
  kategori_pekerjaan VARCHAR CHECK (kategori_pekerjaan IN ('office', 'produksi', 'maintenance', 'operator', 'supervisor', 'manager', 'teknisi', 'driver', 'security', 'cleaning')),

  -- Waktu & Lokasi
  tanggal_induction DATE NOT NULL,
  waktu_mulai TIME NOT NULL,
  waktu_selesai TIME,
  durasi_menit INTEGER,
  unit_id UUID REFERENCES units(id),
  lokasi_induction VARCHAR NOT NULL,
  ruangan VARCHAR,

  -- Instruktur
  instruktur_utama VARCHAR NOT NULL,
  instruktur_pendamping TEXT[], -- Array of strings
  pic_hse VARCHAR NOT NULL,

  -- Materi Checklist (boolean fields)
  materi_kebijakan_k3 BOOLEAN DEFAULT false,
  materi_prosedur_emergency BOOLEAN DEFAULT false,
  materi_apd_wajib BOOLEAN DEFAULT false,
  materi_rambu_k3 BOOLEAN DEFAULT false,
  materi_identifikasi_bahaya BOOLEAN DEFAULT false,
  materi_pelaporan_insiden BOOLEAN DEFAULT false,
  materi_permit_to_work BOOLEAN DEFAULT false,
  materi_housekeeping BOOLEAN DEFAULT false,
  materi_chemical_safety BOOLEAN DEFAULT false,
  materi_working_at_height BOOLEAN DEFAULT false,
  materi_confined_space BOOLEAN DEFAULT false,
  materi_loto BOOLEAN DEFAULT false,
  materi_fire_safety BOOLEAN DEFAULT false,
  materi_first_aid BOOLEAN DEFAULT false,
  materi_ergonomi BOOLEAN DEFAULT false,

  -- Materi Tambahan (JSON array)
  materi_tambahan JSONB DEFAULT '[]'::jsonb,

  -- Site Tour
  site_tour_dilakukan BOOLEAN DEFAULT false,
  area_dikunjungi TEXT[], -- Array of strings
  durasi_tour_menit INTEGER,
  pemandu_tour VARCHAR,

  -- APD
  apd_diberikan JSONB DEFAULT '[]'::jsonb, -- Array of objects
  kartu_id_diberikan BOOLEAN DEFAULT false,
  nomor_kartu_id VARCHAR,
  akses_area TEXT[], -- Array of strings

  -- Assessment
  ujian_dilakukan BOOLEAN DEFAULT false,
  jenis_ujian VARCHAR CHECK (jenis_ujian IN ('tertulis', 'lisan', 'praktek', 'online', 'campuran')),
  jumlah_soal INTEGER,
  skor_ujian DECIMAL,
  passing_grade INTEGER,
  status_ujian VARCHAR CHECK (status_ujian IN ('lulus', 'tidak_lulus', 'belum_ujian', 'remedial')),
  tanggal_ujian DATE,

  -- Sertifikat
  sertifikat_dikeluarkan BOOLEAN DEFAULT false,
  nomor_sertifikat VARCHAR,
  tanggal_sertifikat DATE,
  masa_berlaku_sertifikat DATE,
  file_sertifikat VARCHAR, -- URL to certificate file

  -- Approval & Status
  status VARCHAR DEFAULT 'draft' CHECK (status IN ('draft', 'scheduled', 'in_progress', 'completed', 'cancelled')),
  approved_by UUID,
  approved_at TIMESTAMP WITH TIME ZONE,
  review_notes TEXT,

  -- Follow up
  perlu_follow_up BOOLEAN DEFAULT false,
  tanggal_follow_up DATE,
  status_follow_up VARCHAR CHECK (status_follow_up IN ('belum', 'dijadwalkan', 'selesai')),

  -- Emergency Contact
  emergency_kontak_nama VARCHAR,
  emergency_kontak_telepon VARCHAR,
  emergency_kontak_hubungan VARCHAR,

  -- Medical Information
  riwayat_penyakit TEXT,
  alergi TEXT,
  obat_khusus TEXT,
  golongan_darah VARCHAR,

  -- Feedback & Notes
  feedback_peserta TEXT,
  catatan_khusus TEXT,
  rekomendasi_peningkatan TEXT,

  -- Documentation
  foto_induction TEXT[], -- Array of photo URLs
  dokumen_pendukung TEXT[], -- Array of document URLs

  -- Audit fields
  created_by UUID,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_safety_induction_unit_id ON safety_induction(unit_id);
CREATE INDEX IF NOT EXISTS idx_safety_induction_tanggal_induction ON safety_induction(tanggal_induction);
CREATE INDEX IF NOT EXISTS idx_safety_induction_status ON safety_induction(status);
CREATE INDEX IF NOT EXISTS idx_safety_induction_jenis_peserta ON safety_induction(jenis_peserta);

-- Enable Row Level Security (RLS)
ALTER TABLE safety_induction ENABLE ROW LEVEL SECURITY;

-- Create RLS policies (adjust based on your auth requirements)
CREATE POLICY "Allow all operations on safety_induction" ON safety_induction
  FOR ALL USING (true);

-- Create trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_safety_induction_updated_at
  BEFORE UPDATE ON safety_induction
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Verify table creation
SELECT 'safety_induction table created successfully!' as result;
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'safety_induction'
ORDER BY ordinal_position
LIMIT 10;
