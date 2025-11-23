-- =====================================================
-- COMPLETE HSSE DATABASE SETUP
-- Run this in Supabase SQL Editor - ONE TIME SETUP
-- =====================================================

-- Migration 1: Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Migration 2: Create Master Tables
-- Table: units
CREATE TABLE IF NOT EXISTS units (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  kode_unit VARCHAR(20) UNIQUE NOT NULL,
  nama_unit VARCHAR(100) NOT NULL,
  lokasi VARCHAR(200),
  manager_id UUID,
  status VARCHAR(20) NOT NULL DEFAULT 'aktif' CHECK (status IN ('aktif', 'nonaktif')),
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Table: wilayah
CREATE TABLE IF NOT EXISTS wilayah (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  kode_wilayah VARCHAR(20) UNIQUE NOT NULL,
  nama_wilayah VARCHAR(100) NOT NULL,
  provinsi VARCHAR(50),
  kota VARCHAR(50),
  pic_id UUID,
  status VARCHAR(20) NOT NULL DEFAULT 'aktif' CHECK (status IN ('aktif', 'nonaktif')),
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Table: pegawai
CREATE TABLE IF NOT EXISTS pegawai (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nip VARCHAR(30) UNIQUE NOT NULL,
  nama_lengkap VARCHAR(150) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  jabatan VARCHAR(100),
  unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
  wilayah_id UUID REFERENCES wilayah(id) ON DELETE SET NULL,
  role VARCHAR(20) NOT NULL DEFAULT 'user' CHECK (role IN ('admin', 'manager', 'user')),
  photo_url TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'aktif' CHECK (status IN ('aktif', 'nonaktif', 'cuti')),
  tanggal_bergabung DATE,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Table: tamu_eksternal
CREATE TABLE IF NOT EXISTS tamu_eksternal (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nama_lengkap VARCHAR(150) NOT NULL,
  perusahaan VARCHAR(100),
  email VARCHAR(100),
  phone VARCHAR(20),
  nik VARCHAR(30),
  foto_identitas_url TEXT,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Add foreign keys for manager_id and pic_id
ALTER TABLE units ADD CONSTRAINT fk_units_manager
  FOREIGN KEY (manager_id) REFERENCES pegawai(id) ON DELETE SET NULL;

ALTER TABLE wilayah ADD CONSTRAINT fk_wilayah_pic
  FOREIGN KEY (pic_id) REFERENCES pegawai(id) ON DELETE SET NULL;

-- Migration 3: Create HSSE Transaction Tables
-- Table: safety_briefing
CREATE TABLE IF NOT EXISTS safety_briefing (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
  wilayah_id UUID REFERENCES wilayah(id) ON DELETE SET NULL,
  tanggal DATE NOT NULL,
  waktu_mulai TIME NOT NULL,
  waktu_selesai TIME,
  petugas_id UUID NOT NULL REFERENCES pegawai(id) ON DELETE RESTRICT,
  lokasi VARCHAR(200),
  topik VARCHAR(200) NOT NULL,
  materi TEXT,
  jumlah_peserta INTEGER DEFAULT 0,
  peserta_ids JSONB,
  temuan TEXT,
  tindak_lanjut TEXT,
  lampiran_url TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'submitted', 'approved')),
  approved_by UUID REFERENCES pegawai(id) ON DELETE SET NULL,
  approved_at TIMESTAMP,
  created_by UUID NOT NULL REFERENCES pegawai(id) ON DELETE RESTRICT,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now(),
  CONSTRAINT chk_unit_or_wilayah CHECK (unit_id IS NOT NULL OR wilayah_id IS NOT NULL)
);

-- Table: silent_inspection
CREATE TABLE IF NOT EXISTS silent_inspection (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
  wilayah_id UUID REFERENCES wilayah(id) ON DELETE SET NULL,
  tanggal DATE NOT NULL,
  triwulan INTEGER NOT NULL CHECK (triwulan BETWEEN 1 AND 4),
  tahun INTEGER NOT NULL,
  inspector_id UUID NOT NULL REFERENCES pegawai(id) ON DELETE RESTRICT,
  area_inspeksi VARCHAR(200) NOT NULL,
  checklist JSONB,
  skor_total DECIMAL(5,2),
  kategori_temuan VARCHAR(50) CHECK (kategori_temuan IN ('critical', 'major', 'minor', 'none')),
  temuan TEXT,
  rekomendasi TEXT,
  pic_perbaikan_id UUID REFERENCES pegawai(id) ON DELETE SET NULL,
  target_selesai DATE,
  tanggal_selesai DATE,
  lampiran_url TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'submitted', 'approved', 'closed')),
  approved_by UUID REFERENCES pegawai(id) ON DELETE SET NULL,
  approved_at TIMESTAMP,
  created_by UUID NOT NULL REFERENCES pegawai(id) ON DELETE RESTRICT,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now(),
  -- Add the missing verified_by column
  verified_by UUID REFERENCES pegawai(id) ON DELETE SET NULL,
  verified_at TIMESTAMP,
  CONSTRAINT chk_unit_or_wilayah CHECK (unit_id IS NOT NULL OR wilayah_id IS NOT NULL)
);

-- Migration 4: Create Indexes
-- Indexes for units
CREATE INDEX IF NOT EXISTS idx_units_kode ON units(kode_unit);
CREATE INDEX IF NOT EXISTS idx_units_status ON units(status);

-- Indexes for wilayah
CREATE INDEX IF NOT EXISTS idx_wilayah_kode ON wilayah(kode_wilayah);
CREATE INDEX IF NOT EXISTS idx_wilayah_status ON wilayah(status);

-- Indexes for pegawai
CREATE INDEX IF NOT EXISTS idx_pegawai_nip ON pegawai(nip);
CREATE INDEX IF NOT EXISTS idx_pegawai_email ON pegawai(email);
CREATE INDEX IF NOT EXISTS idx_pegawai_unit ON pegawai(unit_id);
CREATE INDEX IF NOT EXISTS idx_pegawai_wilayah ON pegawai(wilayah_id);
CREATE INDEX IF NOT EXISTS idx_pegawai_role ON pegawai(role);

-- Indexes for tamu_eksternal
CREATE INDEX IF NOT EXISTS idx_tamu_email ON tamu_eksternal(email);

-- Indexes for safety_briefing
CREATE INDEX IF NOT EXISTS idx_safety_briefing_tanggal ON safety_briefing(tanggal DESC);
CREATE INDEX IF NOT EXISTS idx_safety_briefing_unit ON safety_briefing(unit_id);
CREATE INDEX IF NOT EXISTS idx_safety_briefing_wilayah ON safety_briefing(wilayah_id);
CREATE INDEX IF NOT EXISTS idx_safety_briefing_status ON safety_briefing(status);
CREATE INDEX IF NOT EXISTS idx_safety_briefing_composite ON safety_briefing(tanggal DESC, unit_id, wilayah_id);

-- Indexes for silent_inspection
CREATE INDEX IF NOT EXISTS idx_silent_inspection_tanggal ON silent_inspection(tanggal DESC);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_triwulan ON silent_inspection(tahun DESC, triwulan);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_unit ON silent_inspection(unit_id);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_wilayah ON silent_inspection(wilayah_id);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_status ON silent_inspection(status);

-- Migration 5: Enable Row Level Security (RLS)
-- Enable RLS on all tables
ALTER TABLE units ENABLE ROW LEVEL SECURITY;
ALTER TABLE wilayah ENABLE ROW LEVEL SECURITY;
ALTER TABLE pegawai ENABLE ROW LEVEL SECURITY;
ALTER TABLE tamu_eksternal ENABLE ROW LEVEL SECURITY;
ALTER TABLE safety_briefing ENABLE ROW LEVEL SECURITY;
ALTER TABLE silent_inspection ENABLE ROW LEVEL SECURITY;

-- RLS Policies for safety_briefing (example - repeat pattern for other tables)
CREATE POLICY "Users can view own unit/wilayah briefings"
  ON safety_briefing FOR SELECT
  USING (
    unit_id IN (SELECT unit_id FROM pegawai WHERE id = auth.uid())
    OR wilayah_id IN (SELECT wilayah_id FROM pegawai WHERE id = auth.uid())
  );

CREATE POLICY "Users can create briefings for own unit/wilayah"
  ON safety_briefing FOR INSERT
  WITH CHECK (
    unit_id IN (SELECT unit_id FROM pegawai WHERE id = auth.uid())
    OR wilayah_id IN (SELECT wilayah_id FROM pegawai WHERE id = auth.uid())
  );

CREATE POLICY "Users can update own draft/submitted briefings"
  ON safety_briefing FOR UPDATE
  USING (
    created_by = auth.uid()
    AND status IN ('draft', 'submitted')
  );

CREATE POLICY "Managers can approve briefings"
  ON safety_briefing FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM pegawai
      WHERE id = auth.uid()
      AND role IN ('manager', 'admin')
    )
  );

-- Simplified policies for silent_inspection (allow all authenticated users for now)
CREATE POLICY "Enable all for authenticated users" ON silent_inspection FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Enable all for authenticated users" ON units FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Enable all for authenticated users" ON wilayah FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Enable all for authenticated users" ON pegawai FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Enable all for authenticated users" ON tamu_eksternal FOR ALL USING (auth.role() = 'authenticated');

-- Migration 8: Insert Sample Data
-- Sample Units
INSERT INTO units (kode_unit, nama_unit, lokasi, status) VALUES
('UNIT-001', 'Unit Produksi A', 'Gedung A Lantai 2', 'aktif'),
('UNIT-002', 'Unit Produksi B', 'Gedung B Lantai 1', 'aktif'),
('UNIT-003', 'Unit Maintenance', 'Workshop', 'aktif')
ON CONFLICT (kode_unit) DO NOTHING;

-- Sample Wilayah
INSERT INTO wilayah (kode_wilayah, nama_wilayah, provinsi, kota, status) VALUES
('WIL-JKT-01', 'Wilayah Jakarta Pusat', 'DKI Jakarta', 'Jakarta Pusat', 'aktif'),
('WIL-JKT-02', 'Wilayah Jakarta Selatan', 'DKI Jakarta', 'Jakarta Selatan', 'aktif')
ON CONFLICT (kode_wilayah) DO NOTHING;

-- Sample Pegawai (including the admin user)
INSERT INTO pegawai (nip, nama_lengkap, email, phone, jabatan, unit_id, role, status) VALUES
('EMP-2024-001', 'Budi Santoso', 'budi.santoso@company.com', '081234567890', 'Safety Officer',
  (SELECT id FROM units WHERE kode_unit = 'UNIT-001'), 'user', 'aktif'),
('EMP-2024-002', 'Siti Nurhaliza', 'siti.nurhaliza@company.com', '081234567891', 'HSE Manager',
  (SELECT id FROM units WHERE kode_unit = 'UNIT-001'), 'manager', 'aktif'),
('EMP-2024-003', 'Ahmad Hidayat', 'ahmad.hidayat@company.com', '081234567892', 'Admin',
  NULL, 'admin', 'aktif')
ON CONFLICT (nip) DO NOTHING;

-- Verify setup
SELECT 'Database setup completed successfully!' as status;
SELECT
  'units' as table_name, COUNT(*) as row_count FROM units
UNION ALL
SELECT 'wilayah', COUNT(*) FROM wilayah
UNION ALL
SELECT 'pegawai', COUNT(*) FROM pegawai
UNION ALL
SELECT 'silent_inspection', COUNT(*) FROM silent_inspection;