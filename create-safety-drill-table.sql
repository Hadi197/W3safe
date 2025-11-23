-- Create safety_drill table
-- Based on SafetyDrill interface from safety-drill.service.ts

CREATE TABLE IF NOT EXISTS safety_drill (
  -- Primary key
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Basic information
  nomor_drill VARCHAR NOT NULL,
  judul_drill VARCHAR NOT NULL,
  deskripsi TEXT,

  -- Jenis & Kategori
  jenis_drill VARCHAR CHECK (jenis_drill IN ('fire_drill', 'earthquake_drill', 'evacuation_drill', 'chemical_spill',
                                             'medical_emergency', 'bomb_threat', 'gas_leak', 'confined_space',
                                             'height_rescue', 'water_rescue', 'severe_weather', 'security_breach',
                                             'power_outage', 'active_shooter', 'full_scale')),
  kategori_drill VARCHAR CHECK (kategori_drill IN ('planned', 'unannounced', 'tabletop', 'functional', 'full_scale')),
  tingkat_drill VARCHAR CHECK (tingkat_drill IN ('plant_wide', 'area_specific', 'department', 'shift_based', 'team_based')),

  -- Unit & Lokasi
  unit_kerja VARCHAR NOT NULL,
  area_lokasi VARCHAR NOT NULL,
  ruang_khusus VARCHAR,
  titik_kumpul VARCHAR NOT NULL,
  area_terdampak TEXT[], -- Array of areas

  -- Jadwal
  tanggal_drill DATE NOT NULL,
  waktu_mulai TIME NOT NULL,
  waktu_selesai TIME,
  durasi_menit INTEGER,
  shift VARCHAR,

  -- Perencanaan
  tanggal_perencanaan DATE,
  pic_perencanaan VARCHAR,
  tujuan_drill TEXT NOT NULL,
  sasaran_drill TEXT[], -- Array of objectives
  skenario TEXT NOT NULL,
  kriteria_keberhasilan TEXT[], -- Array of criteria

  -- Tim Drill
  drill_commander VARCHAR NOT NULL,
  jabatan_commander VARCHAR,
  safety_officer VARCHAR NOT NULL,
  jabatan_safety VARCHAR,
  observer TEXT[], -- Array of names
  controller TEXT[], -- Array of names
  evaluator TEXT[], -- Array of names

  -- Tim Emergency Response
  ert_leader VARCHAR,
  ert_members TEXT[], -- Array of names
  first_aider TEXT[], -- Array of names
  fire_team TEXT[], -- Array of names
  evacuation_team TEXT[], -- Array of names
  communication_team TEXT[], -- Array of names

  -- Partisipan
  jumlah_peserta INTEGER NOT NULL DEFAULT 0,
  jumlah_karyawan INTEGER DEFAULT 0,
  jumlah_kontraktor INTEGER DEFAULT 0,
  jumlah_observer INTEGER DEFAULT 0,
  daftar_peserta JSONB, -- Complex participant data

  -- Pre-Drill Briefing
  briefing_dilakukan BOOLEAN DEFAULT false,
  tanggal_briefing DATE,
  waktu_briefing TIME,
  peserta_briefing TEXT[], -- Array of names
  materi_briefing TEXT,

  -- Peralatan
  peralatan_digunakan JSONB, -- Equipment usage data
  apar_digunakan INTEGER DEFAULT 0,
  hydrant_digunakan INTEGER DEFAULT 0,
  stretcher_digunakan INTEGER DEFAULT 0,
  ppe_digunakan TEXT[], -- Array of PPE types
  alat_komunikasi TEXT[], -- Array of communication tools

  -- Alarm & Komunikasi
  alarm_activated BOOLEAN DEFAULT false,
  waktu_alarm TIME,
  jenis_alarm VARCHAR,
  pa_system_used BOOLEAN DEFAULT false,
  radio_communication BOOLEAN DEFAULT false,
  emergency_contact_called TEXT[], -- Array of contacts

  -- Pelaksanaan
  drill_dimulai BOOLEAN DEFAULT false,
  waktu_aktual_mulai TIME,
  waktu_deteksi TIME,
  waktu_alarm_berbunyi TIME,
  waktu_mulai_evakuasi TIME,
  waktu_selesai_evakuasi TIME,
  waktu_all_clear TIME,
  total_waktu_evakuasi INTEGER,

  -- Response Time
  detection_time INTEGER,
  alarm_to_evacuation INTEGER,
  evacuation_completion_time INTEGER,
  total_response_time INTEGER,

  -- Evakuasi
  evakuasi_dilakukan BOOLEAN DEFAULT false,
  jumlah_dievaluasi INTEGER DEFAULT 0,
  jumlah_berhasil_evakuasi INTEGER DEFAULT 0,
  jumlah_tidak_evakuasi INTEGER DEFAULT 0,
  alasan_tidak_evakuasi TEXT,
  safe_area_reached BOOLEAN DEFAULT false,
  waktu_ke_safe_area TIME,

  -- Korban & Cedera
  ada_korban BOOLEAN DEFAULT false,
  jumlah_korban_luka INTEGER DEFAULT 0,
  jumlah_korban_meninggal INTEGER DEFAULT 0,
  jenis_cedera TEXT[],
  tingkat_keparahan TEXT[],
  penanganan_korban TEXT,

  -- Temuan & Pelanggaran
  temuan_selama_drill TEXT[],
  pelanggaran_teridentifikasi TEXT[],
  unsafe_condition TEXT[],
  unsafe_act TEXT[],
  jumlah_temuan INTEGER DEFAULT 0,

  -- Evaluasi
  evaluasi_overall TEXT,
  skor_overall DECIMAL CHECK (skor_overall >= 0 AND skor_overall <= 100),
  strength_areas TEXT[],
  improvement_areas TEXT[],
  rekomendasi TEXT[],

  -- Tindak Lanjut
  action_required BOOLEAN DEFAULT false,
  action_items JSONB, -- Action items data
  jumlah_action_item INTEGER DEFAULT 0,
  action_selesai INTEGER DEFAULT 0,
  action_progress INTEGER DEFAULT 0,
  action_belum_mulai INTEGER DEFAULT 0,

  -- Dokumentasi
  foto_drill TEXT[], -- Array of photo URLs
  video_drill TEXT[], -- Array of video URLs
  dokumen_pendukung TEXT[], -- Array of document URLs
  laporan_drill TEXT,

  -- Status & Approval
  status VARCHAR DEFAULT 'draft' CHECK (status IN ('draft', 'planned', 'in_progress', 'completed', 'cancelled', 'reviewed')),
  approved_by UUID,
  approved_at TIMESTAMP WITH TIME ZONE,
  review_notes TEXT,

  -- Follow up
  perlu_follow_up BOOLEAN DEFAULT false,
  tanggal_follow_up DATE,
  status_follow_up VARCHAR CHECK (status_follow_up IN ('belum', 'dijadwalkan', 'selesai')),

  -- Audit fields
  created_by UUID,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_safety_drill_tanggal_drill ON safety_drill(tanggal_drill);
CREATE INDEX IF NOT EXISTS idx_safety_drill_status ON safety_drill(status);
CREATE INDEX IF NOT EXISTS idx_safety_drill_jenis_drill ON safety_drill(jenis_drill);
CREATE INDEX IF NOT EXISTS idx_safety_drill_unit_kerja ON safety_drill(unit_kerja);

-- Enable Row Level Security (RLS)
ALTER TABLE safety_drill ENABLE ROW LEVEL SECURITY;

-- Create RLS policies (adjust based on your auth requirements)
CREATE POLICY "Allow all operations on safety_drill" ON safety_drill
  FOR ALL USING (true);

-- Create trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_safety_drill_updated_at
  BEFORE UPDATE ON safety_drill
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Verify table creation
SELECT 'safety_drill table created successfully!' as result;
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'safety_drill'
ORDER BY ordinal_position
LIMIT 10;
