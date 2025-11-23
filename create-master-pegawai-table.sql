-- Create master_pegawai table for employee management
CREATE TABLE IF NOT EXISTS master_pegawai (
  -- Primary key
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Employee information
  nama VARCHAR NOT NULL,
  nipp VARCHAR UNIQUE NOT NULL,
  jabatan VARCHAR NOT NULL,
  unit_kerja VARCHAR NOT NULL,

  -- Additional optional fields
  email VARCHAR,
  no_telepon VARCHAR,
  tanggal_lahir DATE,
  alamat TEXT,
  status VARCHAR DEFAULT 'aktif' CHECK (status IN ('aktif', 'non_aktif', 'resign', 'pensiun')),

  -- Audit fields
  created_by UUID,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_master_pegawai_nipp ON master_pegawai(nipp);
CREATE INDEX IF NOT EXISTS idx_master_pegawai_unit_kerja ON master_pegawai(unit_kerja);
CREATE INDEX IF NOT EXISTS idx_master_pegawai_status ON master_pegawai(status);

-- Enable Row Level Security (RLS)
ALTER TABLE master_pegawai ENABLE ROW LEVEL SECURITY;

-- Create RLS policies (adjust based on your auth requirements)
CREATE POLICY "Allow all operations on master_pegawai" ON master_pegawai
  FOR ALL USING (true);

-- Create trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_master_pegawai_updated_at
  BEFORE UPDATE ON master_pegawai
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert sample data
INSERT INTO master_pegawai (nama, nipp, jabatan, unit_kerja, email, no_telepon) VALUES
  ('Ahmad Surya', 'PEG001', 'Manager HSE', 'Unit Banjarmasin', 'ahmad.surya@company.com', '+6281234567890'),
  ('Siti Nurhaliza', 'PEG002', 'Supervisor Produksi', 'Unit Batulicin', 'siti.nurhaliza@company.com', '+6281234567891'),
  ('Budi Santoso', 'PEG003', 'Safety Officer', 'Unit Benoa', 'budi.santoso@company.com', '+6281234567892'),
  ('Maya Sari', 'PEG004', 'Operator', 'Unit Celukan Bawang', 'maya.sari@company.com', '+6281234567893'),
  ('Rudi Hartono', 'PEG005', 'Teknisi', 'Unit Gresik', 'rudi.hartono@company.com', '+6281234567894')
ON CONFLICT (nipp) DO NOTHING;

-- Verify table creation
SELECT 'master_pegawai table created successfully with sample data!' as result;
SELECT COUNT(*) as total_employees FROM master_pegawai;
