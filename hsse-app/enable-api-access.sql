-- =====================================================
-- HSSE Database - Enable API Access & RLS Policies
-- =====================================================

-- Enable Row Level Security on all tables
ALTER TABLE wilayah ENABLE ROW LEVEL SECURITY;
ALTER TABLE units ENABLE ROW LEVEL SECURITY;
ALTER TABLE pegawai ENABLE ROW LEVEL SECURITY;
ALTER TABLE silent_inspection ENABLE ROW LEVEL SECURITY;

-- Create policies for public read access (for development)
-- Wilayah policies
CREATE POLICY "Enable read access for all users" ON wilayah FOR SELECT USING (true);
CREATE POLICY "Enable insert for authenticated users" ON wilayah FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for authenticated users" ON wilayah FOR UPDATE USING (true);

-- Units policies
CREATE POLICY "Enable read access for all users" ON units FOR SELECT USING (true);
CREATE POLICY "Enable insert for authenticated users" ON units FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for authenticated users" ON units FOR UPDATE USING (true);

-- Pegawai policies
CREATE POLICY "Enable read access for all users" ON pegawai FOR SELECT USING (true);
CREATE POLICY "Enable insert for authenticated users" ON pegawai FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for authenticated users" ON pegawai FOR UPDATE USING (true);

-- Silent inspection policies
CREATE POLICY "Enable read access for all users" ON silent_inspection FOR SELECT USING (true);
CREATE POLICY "Enable insert for authenticated users" ON silent_inspection FOR INSERT WITH CHECK (true);
CREATE POLICY "Enable update for authenticated users" ON silent_inspection FOR UPDATE USING (true);
CREATE POLICY "Enable delete for authenticated users" ON silent_inspection FOR DELETE USING (true);

-- Insert demo data if tables are empty
INSERT INTO wilayah (kode, nama, regional, aktif) VALUES
  ('WIL-3', 'Wilayah 3', 'Regional 3', true)
ON CONFLICT (kode) DO NOTHING;

INSERT INTO units (kode, nama, tipe, wilayah_id, aktif) VALUES
  ('AREA-JAWA1', 'Area Jawa 1', 'area', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), true),
  ('UNIT-TANJUNGPERAK', 'Tanjung Perak', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), true)
ON CONFLICT (kode) DO NOTHING;

INSERT INTO pegawai (nip, nama, email, jabatan, status) VALUES
  ('DEMO001', 'Safety Inspector Demo', 'demo@safety.local', 'Safety Inspector', 'aktif')
ON CONFLICT (nip) DO NOTHING;

-- Verify the setup
SELECT
  'wilayah' as table_name, COUNT(*) as count FROM wilayah
UNION ALL
SELECT 'units', COUNT(*) FROM units
UNION ALL
SELECT 'pegawai', COUNT(*) FROM pegawai
UNION ALL
SELECT 'silent_inspection', COUNT(*) FROM silent_inspection;