-- Create safety_patrol table
-- Based on SafetyPatrol interface from safety-patrol.service.ts

CREATE TABLE IF NOT EXISTS safety_patrol (
  -- Primary key
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Basic information
  nomor_patrol VARCHAR NOT NULL,
  tanggal_patrol DATE NOT NULL,
  waktu_mulai TIME NOT NULL,
  waktu_selesai TIME,

  -- Shift and unit
  shift VARCHAR CHECK (shift IN ('pagi', 'siang', 'malam')),
  unit_id UUID REFERENCES units(id),
  area_patrol VARCHAR NOT NULL,
  lokasi_spesifik VARCHAR,

  -- Team information
  ketua_patrol VARCHAR NOT NULL,
  anggota_patrol TEXT[], -- Array of strings
  jumlah_anggota INTEGER DEFAULT 0,

  -- Patrol details
  jenis_patrol VARCHAR CHECK (jenis_patrol IN ('rutin', 'terjadwal', 'insidental', 'khusus', 'malam', 'emergency')),
  tujuan_patrol TEXT,
  fokus_patrol TEXT[], -- Array of strings

  -- Environmental conditions
  cuaca VARCHAR CHECK (cuaca IN ('cerah', 'mendung', 'hujan', 'panas')),
  suhu_area DECIMAL,
  kondisi_pencahayaan VARCHAR CHECK (kondisi_pencahayaan IN ('baik', 'cukup', 'kurang', 'buruk')),
  kondisi_ventilasi VARCHAR CHECK (kondisi_ventilasi IN ('baik', 'cukup', 'kurang', 'buruk')),
  tingkat_kebisingan VARCHAR CHECK (tingkat_kebisingan IN ('normal', 'cukup_bising', 'bising', 'sangat_bising')),

  -- Unsafe conditions and acts
  jumlah_unsafe_condition INTEGER DEFAULT 0,
  unsafe_condition JSONB DEFAULT '[]'::jsonb, -- Array of objects
  jumlah_unsafe_act INTEGER DEFAULT 0,
  unsafe_act JSONB DEFAULT '[]'::jsonb, -- Array of objects

  -- Worker observations
  pekerja_diamati INTEGER DEFAULT 0,
  pekerja_patuh_apd INTEGER DEFAULT 0,
  pekerja_tidak_patuh_apd INTEGER DEFAULT 0,
  persentase_kepatuhan_apd DECIMAL,
  detail_apd JSONB DEFAULT '[]'::jsonb, -- Array of objects

  -- Housekeeping
  skor_housekeeping INTEGER,
  kondisi_housekeeping VARCHAR CHECK (kondisi_housekeeping IN ('sangat_baik', 'baik', 'cukup', 'kurang', 'buruk')),
  area_kotor TEXT[], -- Array of strings
  area_rapi TEXT[], -- Array of strings

  -- Equipment checks
  jumlah_mesin_diperiksa INTEGER DEFAULT 0,
  mesin_kondisi_baik INTEGER DEFAULT 0,
  mesin_perlu_perbaikan INTEGER DEFAULT 0,
  detail_mesin JSONB DEFAULT '[]'::jsonb, -- Array of objects

  -- Safety equipment checks
  rambu_k3_lengkap BOOLEAN DEFAULT false,
  rambu_k3_hilang TEXT[], -- Array of strings
  rambu_k3_rusak TEXT[], -- Array of strings
  label_b3_lengkap BOOLEAN DEFAULT false,
  jalur_evakuasi_bebas BOOLEAN DEFAULT false,
  pintu_darurat_berfungsi BOOLEAN DEFAULT false,
  apar_tersedia BOOLEAN DEFAULT false,
  apar_expire INTEGER DEFAULT 0,
  emergency_light_berfungsi BOOLEAN DEFAULT false,

  -- Positive observations
  good_practice TEXT[], -- Array of strings
  area_excellent TEXT[], -- Array of strings
  pekerja_teladan TEXT[], -- Array of strings

  -- Findings and recommendations
  total_temuan INTEGER DEFAULT 0,
  temuan_kritikal INTEGER DEFAULT 0,
  temuan_mayor INTEGER DEFAULT 0,
  temuan_minor INTEGER DEFAULT 0,
  rekomendasi TEXT[], -- Array of strings
  catatan_patrol TEXT,

  -- Action items
  action_items JSONB DEFAULT '[]'::jsonb, -- Array of objects
  jumlah_action_item INTEGER DEFAULT 0,
  action_selesai INTEGER DEFAULT 0,
  action_progress INTEGER DEFAULT 0,
  action_belum_mulai INTEGER DEFAULT 0,

  -- Stop work orders
  stop_work_issued BOOLEAN DEFAULT false,
  stop_work_area TEXT[], -- Array of strings
  stop_work_alasan TEXT,

  -- Documentation
  foto_patrol TEXT[], -- Array of strings (URLs)
  dokumen_pendukung TEXT[], -- Array of strings (URLs)

  -- Scoring
  skor_keseluruhan DECIMAL,
  skor_apd DECIMAL,
  skor_kondisi_area DECIMAL,
  skor_peralatan DECIMAL,
  grade VARCHAR CHECK (grade IN ('A', 'B', 'C', 'D', 'E')),

  -- Status and approval
  status VARCHAR DEFAULT 'draft' CHECK (status IN ('draft', 'submitted', 'reviewed', 'closed', 'cancelled')),
  tingkat_urgensi VARCHAR DEFAULT 'normal' CHECK (tingkat_urgensi IN ('rendah', 'normal', 'tinggi', 'kritis')),

  -- Follow up
  perlu_follow_up BOOLEAN DEFAULT false,
  tanggal_follow_up DATE,
  status_follow_up VARCHAR CHECK (status_follow_up IN ('belum', 'dijadwalkan', 'selesai')),

  -- Review information
  reviewed_by UUID,
  reviewed_at TIMESTAMP WITH TIME ZONE,
  review_notes TEXT,

  -- Audit fields
  created_by UUID,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_safety_patrol_unit_id ON safety_patrol(unit_id);
CREATE INDEX IF NOT EXISTS idx_safety_patrol_tanggal_patrol ON safety_patrol(tanggal_patrol);
CREATE INDEX IF NOT EXISTS idx_safety_patrol_status ON safety_patrol(status);
CREATE INDEX IF NOT EXISTS idx_safety_patrol_jenis ON safety_patrol(jenis_patrol);

-- Enable Row Level Security (RLS)
ALTER TABLE safety_patrol ENABLE ROW LEVEL SECURITY;

-- Create RLS policies (adjust based on your auth requirements)
-- For now, allow all operations (you can restrict later)
CREATE POLICY "Allow all operations on safety_patrol" ON safety_patrol
  FOR ALL USING (true);

-- Create trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_safety_patrol_updated_at
  BEFORE UPDATE ON safety_patrol
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Verify table creation
SELECT 'safety_patrol table created successfully!' as result;
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'safety_patrol'
ORDER BY ordinal_position
LIMIT 10;
