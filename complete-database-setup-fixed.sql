-- =====================================================
-- COMPLETE HSSE DATABASE SETUP - FIXED VERSION
-- Run this in Supabase SQL Editor - ONE TIME SETUP
-- =====================================================

-- Clean up existing tables if they exist (for fresh setup)
DROP TABLE IF EXISTS silent_inspection CASCADE;
DROP TABLE IF EXISTS safety_briefing CASCADE;
DROP TABLE IF EXISTS tamu_eksternal CASCADE;
DROP TABLE IF EXISTS pegawai CASCADE;
DROP TABLE IF EXISTS wilayah CASCADE;
DROP TABLE IF EXISTS units CASCADE;

-- Migration 1: Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Migration 2: Create Master Tables (without circular references first)
-- Table: wilayah (created first, no dependencies)
CREATE TABLE IF NOT EXISTS wilayah (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  kode_wilayah VARCHAR(20) UNIQUE NOT NULL,
  nama_wilayah VARCHAR(100) NOT NULL,
  provinsi VARCHAR(50),
  kota VARCHAR(50),
  status VARCHAR(20) NOT NULL DEFAULT 'aktif' CHECK (status IN ('aktif', 'nonaktif')),
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Table: units (created second, no dependencies)
CREATE TABLE IF NOT EXISTS units (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  kode_unit VARCHAR(20) UNIQUE NOT NULL,
  nama_unit VARCHAR(100) NOT NULL,
  lokasi VARCHAR(200),
  status VARCHAR(20) NOT NULL DEFAULT 'aktif' CHECK (status IN ('aktif', 'nonaktif')),
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Table: pegawai (created third, can reference units and wilayah)
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

-- Now add the foreign key constraints that reference pegawai
DO $$
BEGIN
  -- Add manager_id column to units table if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'units' AND column_name = 'manager_id'
  ) THEN
    ALTER TABLE units ADD COLUMN manager_id UUID;
    RAISE NOTICE 'Added manager_id column to units table';
  END IF;

  -- Add pic_id column to wilayah table if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'wilayah' AND column_name = 'pic_id'
  ) THEN
    ALTER TABLE wilayah ADD COLUMN pic_id UUID;
    RAISE NOTICE 'Added pic_id column to wilayah table';
  END IF;

  -- Add foreign key for units.manager_id if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_type = 'FOREIGN KEY'
      AND table_name = 'units'
      AND constraint_name LIKE '%manager%'
  ) THEN
    ALTER TABLE units ADD CONSTRAINT fk_units_manager
      FOREIGN KEY (manager_id) REFERENCES pegawai(id) ON DELETE SET NULL;
    RAISE NOTICE 'Added foreign key constraint for units.manager_id';
  END IF;

  -- Add foreign key for wilayah.pic_id if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_type = 'FOREIGN KEY'
      AND table_name = 'wilayah'
      AND constraint_name LIKE '%pic%'
  ) THEN
    ALTER TABLE wilayah ADD CONSTRAINT fk_wilayah_pic
      FOREIGN KEY (pic_id) REFERENCES pegawai(id) ON DELETE SET NULL;
    RAISE NOTICE 'Added foreign key constraint for wilayah.pic_id';
  END IF;
END $$;

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
  CONSTRAINT chk_unit_or_wilayah CHECK (unit_id IS NOT NULL OR wilayah_id IS NOT NULL)
);

-- Migration 4: Create Indexes
-- Indexes for units
CREATE INDEX IF NOT EXISTS idx_units_kode ON units(kode);
CREATE INDEX IF NOT EXISTS idx_units_aktif ON units(aktif);
CREATE INDEX IF NOT EXISTS idx_units_tipe ON units(tipe);

-- Indexes for wilayah
CREATE INDEX IF NOT EXISTS idx_wilayah_kode ON wilayah(kode);
CREATE INDEX IF NOT EXISTS idx_wilayah_aktif ON wilayah(aktif);

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

-- Simplified policies for all tables (allow all authenticated users for now)
CREATE POLICY "Enable all for authenticated users" ON units FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Enable all for authenticated users" ON wilayah FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Enable all for authenticated users" ON pegawai FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Enable all for authenticated users" ON tamu_eksternal FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Enable all for authenticated users" ON safety_briefing FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Enable all for authenticated users" ON silent_inspection FOR ALL USING (auth.role() = 'authenticated');

-- Now add any missing columns to existing tables before inserting sample data
DO $$
BEGIN
  -- Ensure units table has all required columns
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'kode_unit') THEN
    ALTER TABLE units ADD COLUMN kode_unit VARCHAR(20) UNIQUE NOT NULL DEFAULT 'TEMP-' || uuid_generate_v4()::text;
    RAISE NOTICE 'Added kode_unit column to units table';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'nama_unit') THEN
    ALTER TABLE units ADD COLUMN nama_unit VARCHAR(100) NOT NULL DEFAULT 'Temporary Unit';
    RAISE NOTICE 'Added nama_unit column to units table';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'lokasi') THEN
    ALTER TABLE units ADD COLUMN lokasi VARCHAR(200);
    RAISE NOTICE 'Added lokasi column to units table';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'status') THEN
    ALTER TABLE units ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'aktif' CHECK (status IN ('aktif', 'nonaktif'));
    RAISE NOTICE 'Added status column to units table';
  END IF;

  -- Ensure wilayah table has all required columns
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'wilayah' AND column_name = 'kode_wilayah') THEN
    ALTER TABLE wilayah ADD COLUMN kode_wilayah VARCHAR(20) UNIQUE NOT NULL DEFAULT 'TEMP-' || uuid_generate_v4()::text;
    RAISE NOTICE 'Added kode_wilayah column to wilayah table';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'wilayah' AND column_name = 'nama_wilayah') THEN
    ALTER TABLE wilayah ADD COLUMN nama_wilayah VARCHAR(100) NOT NULL DEFAULT 'Temporary Wilayah';
    RAISE NOTICE 'Added nama_wilayah column to wilayah table';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'wilayah' AND column_name = 'provinsi') THEN
    ALTER TABLE wilayah ADD COLUMN provinsi VARCHAR(50);
    RAISE NOTICE 'Added provinsi column to wilayah table';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'wilayah' AND column_name = 'kota') THEN
    ALTER TABLE wilayah ADD COLUMN kota VARCHAR(50);
    RAISE NOTICE 'Added kota column to wilayah table';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'wilayah' AND column_name = 'status') THEN
    ALTER TABLE wilayah ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'aktif' CHECK (status IN ('aktif', 'nonaktif'));
    RAISE NOTICE 'Added status column to wilayah table';
  END IF;

  -- Ensure pegawai table has all required columns
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'pegawai' AND column_name = 'nip') THEN
    ALTER TABLE pegawai ADD COLUMN nip VARCHAR(30) UNIQUE NOT NULL DEFAULT 'TEMP-' || uuid_generate_v4()::text;
    RAISE NOTICE 'Added nip column to pegawai table';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'pegawai' AND column_name = 'nama_lengkap') THEN
    ALTER TABLE pegawai ADD COLUMN nama_lengkap VARCHAR(150) NOT NULL DEFAULT 'Temporary Employee';
    RAISE NOTICE 'Added nama_lengkap column to pegawai table';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'pegawai' AND column_name = 'email') THEN
    ALTER TABLE pegawai ADD COLUMN email VARCHAR(100) UNIQUE NOT NULL DEFAULT 'temp-' || uuid_generate_v4()::text || '@temp.com';
    RAISE NOTICE 'Added email column to pegawai table';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'pegawai' AND column_name = 'phone') THEN
    ALTER TABLE pegawai ADD COLUMN phone VARCHAR(20);
    RAISE NOTICE 'Added phone column to pegawai table';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'pegawai' AND column_name = 'jabatan') THEN
    ALTER TABLE pegawai ADD COLUMN jabatan VARCHAR(100);
    RAISE NOTICE 'Added jabatan column to pegawai table';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'pegawai' AND column_name = 'role') THEN
    ALTER TABLE pegawai ADD COLUMN role VARCHAR(20) NOT NULL DEFAULT 'user' CHECK (role IN ('admin', 'manager', 'user'));
    RAISE NOTICE 'Added role column to pegawai table';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'pegawai' AND column_name = 'status') THEN
    ALTER TABLE pegawai ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'aktif' CHECK (status IN ('aktif', 'nonaktif', 'cuti'));
    RAISE NOTICE 'Added status column to pegawai table';
  END IF;

  -- Ensure silent_inspection table has verified_by column
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'silent_inspection' AND column_name = 'verified_by') THEN
    ALTER TABLE silent_inspection ADD COLUMN verified_by UUID;
    ALTER TABLE silent_inspection ADD COLUMN verified_at TIMESTAMP;
    RAISE NOTICE 'Added verified_by and verified_at columns to silent_inspection table';
  END IF;
END $$;

-- Add remaining foreign key constraints after all tables and columns are created
DO $$
BEGIN
  -- Add foreign key for silent_inspection.verified_by if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_type = 'FOREIGN KEY'
      AND table_name = 'silent_inspection'
      AND constraint_name LIKE '%verified_by%'
  ) THEN
    ALTER TABLE silent_inspection ADD CONSTRAINT fk_silent_inspection_verified_by
      FOREIGN KEY (verified_by) REFERENCES pegawai(id) ON DELETE SET NULL;
    RAISE NOTICE 'Added foreign key constraint for silent_inspection.verified_by';
  END IF;
END $$;

-- Migration 8: Insert Sample Data
-- Sample Units
INSERT INTO units (kode, nama, lokasi, aktif, tipe) VALUES
('UNIT-001', 'Unit Produksi A', 'Gedung A Lantai 2', true, 'unit'),
('UNIT-002', 'Unit Produksi B', 'Gedung B Lantai 1', true, 'unit'),
('UNIT-003', 'Unit Maintenance', 'Workshop', true, 'unit')
ON CONFLICT (kode) DO NOTHING;

-- Sample Wilayah
INSERT INTO wilayah (kode, nama, provinsi, kota, aktif) VALUES
('WIL-JKT-01', 'Wilayah Jakarta Pusat', 'DKI Jakarta', 'Jakarta Pusat', true),
('WIL-JKT-02', 'Wilayah Jakarta Selatan', 'DKI Jakarta', 'Jakarta Selatan', true)
ON CONFLICT (kode) DO NOTHING;

-- Sample Pegawai (including the admin user)
INSERT INTO pegawai (nip, nama_lengkap, email, phone, jabatan, unit_id, role, status) VALUES
('EMP-2024-001', 'Budi Santoso', 'budi.santoso@company.com', '081234567890', 'Safety Officer',
  (SELECT id FROM units WHERE kode = 'UNIT-001'), 'user', 'aktif'),
('EMP-2024-002', 'Siti Nurhaliza', 'siti.nurhaliza@company.com', '081234567891', 'HSE Manager',
  (SELECT id FROM units WHERE kode = 'UNIT-001'), 'manager', 'aktif'),
('EMP-2024-003', 'Ahmad Hidayat', 'ahmad.hidayat@company.com', '081234567892', 'Admin',
  NULL, 'admin', 'aktif')
ON CONFLICT (nip) DO NOTHING;

-- =====================================================
-- SCHEMA MIGRATION - Update column names to match frontend expectations
-- Run this AFTER the initial setup to fix column name mismatches
-- =====================================================

-- Rename columns in units table to match frontend expectations
DO $$
BEGIN
  -- Rename kode_unit to kode
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'kode_unit') 
     AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'kode') THEN
    ALTER TABLE units RENAME COLUMN kode_unit TO kode;
    RAISE NOTICE 'Renamed kode_unit to kode in units table';
  END IF;

  -- Rename nama_unit to nama
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'nama_unit') 
     AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'nama') THEN
    ALTER TABLE units RENAME COLUMN nama_unit TO nama;
    RAISE NOTICE 'Renamed nama_unit to nama in units table';
  END IF;

  -- Add tipe column if it doesn't exist
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'tipe') THEN
    ALTER TABLE units ADD COLUMN tipe VARCHAR(20) DEFAULT 'unit';
    RAISE NOTICE 'Added tipe column to units table';
  END IF;

  -- Add area_id column if it doesn't exist
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'area_id') THEN
    ALTER TABLE units ADD COLUMN area_id UUID REFERENCES units(id) ON DELETE SET NULL;
    RAISE NOTICE 'Added area_id column to units table';
  END IF;

  -- Convert status to aktif (boolean)
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'status') 
     AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'units' AND column_name = 'aktif') THEN
    ALTER TABLE units ADD COLUMN aktif BOOLEAN DEFAULT true;
    UPDATE units SET aktif = CASE WHEN status = 'aktif' THEN true ELSE false END;
    ALTER TABLE units DROP COLUMN status;
    RAISE NOTICE 'Converted status to aktif boolean column in units table';
  END IF;

  -- Rename columns in wilayah table
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'wilayah' AND column_name = 'nama_wilayah') 
     AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'wilayah' AND column_name = 'nama') THEN
    ALTER TABLE wilayah RENAME COLUMN nama_wilayah TO nama;
    RAISE NOTICE 'Renamed nama_wilayah to nama in wilayah table';
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'wilayah' AND column_name = 'kode_wilayah') 
     AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'wilayah' AND column_name = 'kode') THEN
    ALTER TABLE wilayah RENAME COLUMN kode_wilayah TO kode;
    RAISE NOTICE 'Renamed kode_wilayah to kode in wilayah table';
  END IF;

  -- Convert status to aktif in wilayah table
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'wilayah' AND column_name = 'status') 
     AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'wilayah' AND column_name = 'aktif') THEN
    ALTER TABLE wilayah ADD COLUMN aktif BOOLEAN DEFAULT true;
    UPDATE wilayah SET aktif = CASE WHEN status = 'aktif' THEN true ELSE false END;
    ALTER TABLE wilayah DROP COLUMN status;
    RAISE NOTICE 'Converted status to aktif boolean column in wilayah table';
  END IF;

END $$;

-- Update sample data to use new column names
UPDATE units SET tipe = 'unit' WHERE tipe IS NULL;
UPDATE units SET aktif = true WHERE aktif IS NULL;

-- Verify the migration
SELECT 'Schema migration completed successfully!' as status;