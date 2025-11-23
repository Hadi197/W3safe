-- Create unsafe_action_condition table for real-time safety reporting
CREATE TABLE IF NOT EXISTS unsafe_action_condition (
  -- Primary key
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Incident details
  tanggal_kejadian DATE NOT NULL,
  waktu_kejadian TIME NOT NULL,
  lokasi_kejadian VARCHAR NOT NULL,
  unit_kerja VARCHAR NOT NULL,

  -- Classification
  jenis_kejadian VARCHAR CHECK (jenis_kejadian IN ('unsafe_action', 'unsafe_condition')) NOT NULL,
  kategori VARCHAR NOT NULL, -- Specific category within type
  sub_kategori VARCHAR,

  -- Description and details
  deskripsi_kejadian TEXT NOT NULL,
  penyebab_diduga TEXT,
  potensi_risiko TEXT,

  -- Reporter information
  pelapor_nama VARCHAR NOT NULL,
  pelapor_jabatan VARCHAR,
  pelapor_kontak VARCHAR,

  -- Immediate actions taken
  tindakan_segera TEXT,
  area_diamankan BOOLEAN DEFAULT false,
  korban_ada BOOLEAN DEFAULT false,
  korban_jumlah INTEGER DEFAULT 0,

  -- Evidence
  foto_kejadian TEXT[], -- Array of photo URLs
  video_kejadian TEXT[], -- Array of video URLs
  audio_catatan TEXT, -- Audio recording URL if any

  -- Classification
  prioritas VARCHAR DEFAULT 'medium' CHECK (prioritas IN ('low', 'medium', 'high', 'critical')),
  severity_level INTEGER CHECK (severity_level >= 1 AND severity_level <= 5),

  -- Status and assignment
  status VARCHAR DEFAULT 'draft' CHECK (status IN ('draft', 'reported', 'investigating', 'resolved', 'closed')),
  assigned_to UUID,
  assigned_by UUID,
  assigned_at TIMESTAMP WITH TIME ZONE,

  -- Investigation and follow-up
  investigasi_dilakukan BOOLEAN DEFAULT false,
  temuan_investigasi TEXT,
  rekomendasi_koreksi TEXT[],
  target_penyelesaian DATE,
  aktual_penyelesaian DATE,

  -- GPS location (optional for mobile reporting)
  latitude DECIMAL,
  longitude DECIMAL,
  gps_accuracy DECIMAL,

  -- Audit fields
  created_by UUID,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_unsafe_action_condition_tanggal_kejadian ON unsafe_action_condition(tanggal_kejadian);
CREATE INDEX IF NOT EXISTS idx_unsafe_action_condition_unit_kerja ON unsafe_action_condition(unit_kerja);
CREATE INDEX IF NOT EXISTS idx_unsafe_action_condition_jenis_kejadian ON unsafe_action_condition(jenis_kejadian);
CREATE INDEX IF NOT EXISTS idx_unsafe_action_condition_status ON unsafe_action_condition(status);
CREATE INDEX IF NOT EXISTS idx_unsafe_action_condition_prioritas ON unsafe_action_condition(prioritas);

-- Enable Row Level Security (RLS)
ALTER TABLE unsafe_action_condition ENABLE ROW LEVEL SECURITY;

-- Create RLS policies (adjust based on your auth requirements)
CREATE POLICY "Allow all operations on unsafe_action_condition" ON unsafe_action_condition
  FOR ALL USING (true);

-- Create trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_unsafe_action_condition_updated_at
  BEFORE UPDATE ON unsafe_action_condition
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert sample data
INSERT INTO unsafe_action_condition (
  tanggal_kejadian, waktu_kejadian, lokasi_kejadian, unit_kerja,
  jenis_kejadian, kategori, deskripsi_kejadian,
  pelapor_nama, pelapor_jabatan, prioritas, status
) VALUES
  ('2025-01-15', '08:30:00', 'Dermaga Utama', 'Unit Banjarmasin',
   'unsafe_condition', 'Pencahayaan Kurang', 'Area bongkar muat memiliki pencahayaan yang kurang di malam hari',
   'Ahmad Surya', 'Safety Officer', 'high', 'reported'),
  ('2025-01-16', '14:20:00', 'Gudang B3', 'Unit Batulicin',
   'unsafe_action', 'Tidak Menggunakan APD', 'Pekerja melakukan pekerjaan tanpa menggunakan safety helmet',
   'Siti Nurhaliza', 'Supervisor', 'medium', 'investigating'),
  ('2025-01-17', '10:45:00', 'Area Produksi', 'Unit Benoa',
   'unsafe_condition', 'Lantai Licin', 'Tumpahan oli di area produksi menyebabkan lantai licin',
   'Budi Santoso', 'Operator', 'high', 'reported')
ON CONFLICT DO NOTHING;

-- Verify table creation
SELECT 'unsafe_action_condition table created successfully!' as result;
SELECT COUNT(*) as total_incidents FROM unsafe_action_condition;
