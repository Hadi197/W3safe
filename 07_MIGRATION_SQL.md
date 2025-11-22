# 🗄️ SQL Migration Scripts - Aplikasi Implementasi HSSE

## Setup Instructions

Execute these SQL scripts in order in your Supabase SQL Editor.

---

## Migration 1: Enable UUID Extension

```sql
-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

---

## Migration 2: Create Master Tables

```sql
-- Table: units
CREATE TABLE units (
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
CREATE TABLE wilayah (
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
CREATE TABLE pegawai (
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
CREATE TABLE tamu_eksternal (
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
```

---

## Migration 3: Create HSSE Transaction Tables

```sql
-- Table: safety_briefing
CREATE TABLE safety_briefing (
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
CREATE TABLE silent_inspection (
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

-- Table: safety_forum
CREATE TABLE safety_forum (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
  wilayah_id UUID REFERENCES wilayah(id) ON DELETE SET NULL,
  tanggal DATE NOT NULL,
  triwulan INTEGER NOT NULL CHECK (triwulan BETWEEN 1 AND 4),
  tahun INTEGER NOT NULL,
  waktu_mulai TIME NOT NULL,
  waktu_selesai TIME,
  moderator_id UUID NOT NULL REFERENCES pegawai(id) ON DELETE RESTRICT,
  lokasi VARCHAR(200) NOT NULL,
  tema VARCHAR(200) NOT NULL,
  agenda TEXT,
  jumlah_peserta INTEGER DEFAULT 0,
  peserta_ids JSONB,
  pembicara VARCHAR(200),
  ringkasan TEXT,
  keputusan TEXT,
  notulen TEXT,
  lampiran_url TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'submitted', 'approved')),
  approved_by UUID REFERENCES pegawai(id) ON DELETE SET NULL,
  approved_at TIMESTAMP,
  created_by UUID NOT NULL REFERENCES pegawai(id) ON DELETE RESTRICT,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now(),
  CONSTRAINT chk_unit_or_wilayah CHECK (unit_id IS NOT NULL OR wilayah_id IS NOT NULL)
);

-- Table: management_walkthrough
CREATE TABLE management_walkthrough (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
  wilayah_id UUID REFERENCES wilayah(id) ON DELETE SET NULL,
  tanggal DATE NOT NULL,
  bulan INTEGER NOT NULL CHECK (bulan BETWEEN 1 AND 12),
  tahun INTEGER NOT NULL,
  waktu_mulai TIME NOT NULL,
  waktu_selesai TIME,
  manager_id UUID NOT NULL REFERENCES pegawai(id) ON DELETE RESTRICT,
  pendamping_ids JSONB,
  area_kunjungan TEXT NOT NULL,
  fokus_observasi VARCHAR(200),
  temuan_positif TEXT,
  temuan_perbaikan TEXT,
  kategori_temuan VARCHAR(50) CHECK (kategori_temuan IN ('critical', 'major', 'minor', 'none')),
  rekomendasi TEXT,
  pic_tindak_lanjut_id UUID REFERENCES pegawai(id) ON DELETE SET NULL,
  target_selesai DATE,
  lampiran_url TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'submitted', 'approved', 'closed')),
  approved_by UUID REFERENCES pegawai(id) ON DELETE SET NULL,
  approved_at TIMESTAMP,
  created_by UUID NOT NULL REFERENCES pegawai(id) ON DELETE RESTRICT,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now(),
  CONSTRAINT chk_unit_or_wilayah CHECK (unit_id IS NOT NULL OR wilayah_id IS NOT NULL)
);

-- Table: safety_patrol
CREATE TABLE safety_patrol (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
  wilayah_id UUID REFERENCES wilayah(id) ON DELETE SET NULL,
  tanggal DATE NOT NULL,
  waktu_mulai TIME NOT NULL,
  waktu_selesai TIME,
  patrol_leader_id UUID NOT NULL REFERENCES pegawai(id) ON DELETE RESTRICT,
  anggota_patrol_ids JSONB,
  area_patrol TEXT NOT NULL,
  rute_patrol TEXT,
  checklist JSONB,
  temuan_unsafe_act TEXT,
  temuan_unsafe_condition TEXT,
  jumlah_temuan INTEGER DEFAULT 0,
  kategori_temuan VARCHAR(50) CHECK (kategori_temuan IN ('critical', 'major', 'minor', 'none')),
  tindakan_langsung TEXT,
  tindakan_lanjut TEXT,
  pic_tindak_lanjut_id UUID REFERENCES pegawai(id) ON DELETE SET NULL,
  target_selesai DATE,
  lampiran_url TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'submitted', 'approved', 'closed')),
  approved_by UUID REFERENCES pegawai(id) ON DELETE SET NULL,
  approved_at TIMESTAMP,
  created_by UUID NOT NULL REFERENCES pegawai(id) ON DELETE RESTRICT,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now(),
  CONSTRAINT chk_unit_or_wilayah CHECK (unit_id IS NOT NULL OR wilayah_id IS NOT NULL)
);

-- Table: safety_induction
CREATE TABLE safety_induction (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tanggal DATE NOT NULL,
  waktu_mulai TIME NOT NULL,
  waktu_selesai TIME,
  tipe_peserta VARCHAR(20) NOT NULL CHECK (tipe_peserta IN ('pegawai', 'tamu_eksternal')),
  pegawai_id UUID REFERENCES pegawai(id) ON DELETE SET NULL,
  tamu_eksternal_id UUID REFERENCES tamu_eksternal(id) ON DELETE SET NULL,
  unit_tujuan_id UUID REFERENCES units(id) ON DELETE SET NULL,
  wilayah_tujuan_id UUID REFERENCES wilayah(id) ON DELETE SET NULL,
  instructor_id UUID NOT NULL REFERENCES pegawai(id) ON DELETE RESTRICT,
  materi TEXT,
  topik_utama JSONB,
  lokasi VARCHAR(200),
  durasi_menit INTEGER,
  metode VARCHAR(50) CHECK (metode IN ('online', 'offline', 'hybrid')),
  test_hasil DECIMAL(5,2) CHECK (test_hasil BETWEEN 0 AND 100),
  sertifikat_url TEXT,
  masa_berlaku DATE,
  status_kelulusan VARCHAR(20) CHECK (status_kelulusan IN ('lulus', 'tidak_lulus')),
  catatan TEXT,
  lampiran_url TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'submitted', 'approved')),
  approved_by UUID REFERENCES pegawai(id) ON DELETE SET NULL,
  approved_at TIMESTAMP,
  created_by UUID NOT NULL REFERENCES pegawai(id) ON DELETE RESTRICT,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now(),
  CONSTRAINT chk_peserta CHECK (
    (tipe_peserta = 'pegawai' AND pegawai_id IS NOT NULL) OR
    (tipe_peserta = 'tamu_eksternal' AND tamu_eksternal_id IS NOT NULL)
  )
);

-- Table: safety_drill
CREATE TABLE safety_drill (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
  wilayah_id UUID REFERENCES wilayah(id) ON DELETE SET NULL,
  tanggal DATE NOT NULL,
  waktu_mulai TIME NOT NULL,
  waktu_selesai TIME,
  jenis_drill VARCHAR(50) NOT NULL CHECK (jenis_drill IN ('fire', 'earthquake', 'evacuation', 'emergency_response', 'other')),
  tipe_drill VARCHAR(20) NOT NULL CHECK (tipe_drill IN ('announced', 'unannounced')),
  koordinator_id UUID NOT NULL REFERENCES pegawai(id) ON DELETE RESTRICT,
  tim_drill_ids JSONB,
  lokasi VARCHAR(200) NOT NULL,
  skenario TEXT,
  jumlah_peserta INTEGER DEFAULT 0,
  peserta_ids JSONB,
  waktu_evakuasi INTEGER,
  target_waktu INTEGER,
  evaluasi TEXT,
  temuan_positif TEXT,
  temuan_perbaikan TEXT,
  rekomendasi TEXT,
  pic_tindak_lanjut_id UUID REFERENCES pegawai(id) ON DELETE SET NULL,
  target_selesai DATE,
  skor_keseluruhan DECIMAL(5,2) CHECK (skor_keseluruhan BETWEEN 0 AND 100),
  status_drill VARCHAR(20) CHECK (status_drill IN ('sukses', 'perlu_perbaikan', 'gagal')),
  lampiran_url TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'submitted', 'approved', 'closed')),
  approved_by UUID REFERENCES pegawai(id) ON DELETE SET NULL,
  approved_at TIMESTAMP,
  created_by UUID NOT NULL REFERENCES pegawai(id) ON DELETE RESTRICT,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now(),
  CONSTRAINT chk_unit_or_wilayah CHECK (unit_id IS NOT NULL OR wilayah_id IS NOT NULL)
);
```

---

## Migration 4: Create Indexes

```sql
-- Indexes for units
CREATE INDEX idx_units_kode ON units(kode_unit);
CREATE INDEX idx_units_status ON units(status);

-- Indexes for wilayah
CREATE INDEX idx_wilayah_kode ON wilayah(kode_wilayah);
CREATE INDEX idx_wilayah_status ON wilayah(status);

-- Indexes for pegawai
CREATE INDEX idx_pegawai_nip ON pegawai(nip);
CREATE INDEX idx_pegawai_email ON pegawai(email);
CREATE INDEX idx_pegawai_unit ON pegawai(unit_id);
CREATE INDEX idx_pegawai_wilayah ON pegawai(wilayah_id);
CREATE INDEX idx_pegawai_role ON pegawai(role);

-- Indexes for tamu_eksternal
CREATE INDEX idx_tamu_email ON tamu_eksternal(email);

-- Indexes for safety_briefing
CREATE INDEX idx_safety_briefing_tanggal ON safety_briefing(tanggal DESC);
CREATE INDEX idx_safety_briefing_unit ON safety_briefing(unit_id);
CREATE INDEX idx_safety_briefing_wilayah ON safety_briefing(wilayah_id);
CREATE INDEX idx_safety_briefing_status ON safety_briefing(status);
CREATE INDEX idx_safety_briefing_composite ON safety_briefing(tanggal DESC, unit_id, wilayah_id);

-- Indexes for silent_inspection
CREATE INDEX idx_silent_inspection_tanggal ON silent_inspection(tanggal DESC);
CREATE INDEX idx_silent_inspection_triwulan ON silent_inspection(tahun DESC, triwulan);
CREATE INDEX idx_silent_inspection_unit ON silent_inspection(unit_id);
CREATE INDEX idx_silent_inspection_wilayah ON silent_inspection(wilayah_id);
CREATE INDEX idx_silent_inspection_status ON silent_inspection(status);

-- Indexes for safety_forum
CREATE INDEX idx_safety_forum_tanggal ON safety_forum(tanggal DESC);
CREATE INDEX idx_safety_forum_triwulan ON safety_forum(tahun DESC, triwulan);
CREATE INDEX idx_safety_forum_unit ON safety_forum(unit_id);
CREATE INDEX idx_safety_forum_wilayah ON safety_forum(wilayah_id);
CREATE INDEX idx_safety_forum_status ON safety_forum(status);

-- Indexes for management_walkthrough
CREATE INDEX idx_walkthrough_tanggal ON management_walkthrough(tanggal DESC);
CREATE INDEX idx_walkthrough_bulan ON management_walkthrough(tahun DESC, bulan);
CREATE INDEX idx_walkthrough_unit ON management_walkthrough(unit_id);
CREATE INDEX idx_walkthrough_wilayah ON management_walkthrough(wilayah_id);
CREATE INDEX idx_walkthrough_status ON management_walkthrough(status);

-- Indexes for safety_patrol
CREATE INDEX idx_safety_patrol_tanggal ON safety_patrol(tanggal DESC);
CREATE INDEX idx_safety_patrol_unit ON safety_patrol(unit_id);
CREATE INDEX idx_safety_patrol_wilayah ON safety_patrol(wilayah_id);
CREATE INDEX idx_safety_patrol_status ON safety_patrol(status);

-- Indexes for safety_induction
CREATE INDEX idx_safety_induction_tanggal ON safety_induction(tanggal DESC);
CREATE INDEX idx_safety_induction_pegawai ON safety_induction(pegawai_id);
CREATE INDEX idx_safety_induction_tamu ON safety_induction(tamu_eksternal_id);
CREATE INDEX idx_safety_induction_tipe ON safety_induction(tipe_peserta);
CREATE INDEX idx_safety_induction_status ON safety_induction(status);
CREATE INDEX idx_safety_induction_masa_berlaku ON safety_induction(masa_berlaku);

-- Indexes for safety_drill
CREATE INDEX idx_safety_drill_tanggal ON safety_drill(tanggal DESC);
CREATE INDEX idx_safety_drill_jenis ON safety_drill(jenis_drill);
CREATE INDEX idx_safety_drill_unit ON safety_drill(unit_id);
CREATE INDEX idx_safety_drill_wilayah ON safety_drill(wilayah_id);
CREATE INDEX idx_safety_drill_status ON safety_drill(status);

-- Full-text search indexes (optional)
CREATE INDEX idx_safety_briefing_topik_search ON safety_briefing USING GIN (to_tsvector('indonesian', topik));
CREATE INDEX idx_silent_inspection_temuan_search ON silent_inspection USING GIN (to_tsvector('indonesian', temuan));
```

---

## Migration 5: Enable Row Level Security (RLS)

```sql
-- Enable RLS on all tables
ALTER TABLE units ENABLE ROW LEVEL SECURITY;
ALTER TABLE wilayah ENABLE ROW LEVEL SECURITY;
ALTER TABLE pegawai ENABLE ROW LEVEL SECURITY;
ALTER TABLE tamu_eksternal ENABLE ROW LEVEL SECURITY;
ALTER TABLE safety_briefing ENABLE ROW LEVEL SECURITY;
ALTER TABLE silent_inspection ENABLE ROW LEVEL SECURITY;
ALTER TABLE safety_forum ENABLE ROW LEVEL SECURITY;
ALTER TABLE management_walkthrough ENABLE ROW LEVEL SECURITY;
ALTER TABLE safety_patrol ENABLE ROW LEVEL SECURITY;
ALTER TABLE safety_induction ENABLE ROW LEVEL SECURITY;
ALTER TABLE safety_drill ENABLE ROW LEVEL SECURITY;

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

-- Note: Repeat similar policies for other HSSE tables
```

---

## Migration 6: Create Helper Functions

```sql
-- Function to get briefing statistics by unit
CREATE OR REPLACE FUNCTION get_briefing_stats_by_unit(
  tahun_param INTEGER,
  bulan_param INTEGER
)
RETURNS TABLE (
  unit_id UUID,
  unit_name TEXT,
  total_briefing BIGINT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    u.id as unit_id,
    u.nama_unit as unit_name,
    COUNT(sb.id) as total_briefing
  FROM units u
  LEFT JOIN safety_briefing sb ON u.id = sb.unit_id
    AND EXTRACT(YEAR FROM sb.tanggal) = tahun_param
    AND EXTRACT(MONTH FROM sb.tanggal) = bulan_param
  WHERE u.status = 'aktif'
  GROUP BY u.id, u.nama_unit
  ORDER BY total_briefing DESC;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate patrol compliance rate
CREATE OR REPLACE FUNCTION get_patrol_compliance(
  unit_id_param UUID,
  tahun_param INTEGER,
  bulan_param INTEGER
)
RETURNS JSON AS $$
DECLARE
  expected_count INTEGER;
  actual_count INTEGER;
  compliance_rate DECIMAL(5,2);
BEGIN
  expected_count := 22; -- working days in month
  
  SELECT COUNT(*) INTO actual_count
  FROM safety_patrol
  WHERE unit_id = unit_id_param
    AND EXTRACT(YEAR FROM tanggal) = tahun_param
    AND EXTRACT(MONTH FROM tanggal) = bulan_param;
  
  compliance_rate := (actual_count::DECIMAL / expected_count::DECIMAL) * 100;
  
  RETURN json_build_object(
    'expected', expected_count,
    'actual', actual_count,
    'compliance_rate', compliance_rate
  );
END;
$$ LANGUAGE plpgsql;
```

---

## Migration 7: Trigger for Updated_at

```sql
-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for all tables
CREATE TRIGGER update_units_updated_at BEFORE UPDATE ON units
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_wilayah_updated_at BEFORE UPDATE ON wilayah
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_pegawai_updated_at BEFORE UPDATE ON pegawai
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_safety_briefing_updated_at BEFORE UPDATE ON safety_briefing
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_silent_inspection_updated_at BEFORE UPDATE ON silent_inspection
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_safety_forum_updated_at BEFORE UPDATE ON safety_forum
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_management_walkthrough_updated_at BEFORE UPDATE ON management_walkthrough
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_safety_patrol_updated_at BEFORE UPDATE ON safety_patrol
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_safety_induction_updated_at BEFORE UPDATE ON safety_induction
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_safety_drill_updated_at BEFORE UPDATE ON safety_drill
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

---

## Migration 8: Insert Sample Data

```sql
-- Sample Units
INSERT INTO units (kode_unit, nama_unit, lokasi, status) VALUES
('UNIT-001', 'Unit Produksi A', 'Gedung A Lantai 2', 'aktif'),
('UNIT-002', 'Unit Produksi B', 'Gedung B Lantai 1', 'aktif'),
('UNIT-003', 'Unit Maintenance', 'Workshop', 'aktif');

-- Sample Wilayah
INSERT INTO wilayah (kode_wilayah, nama_wilayah, provinsi, kota, status) VALUES
('WIL-JKT-01', 'Wilayah Jakarta Pusat', 'DKI Jakarta', 'Jakarta Pusat', 'aktif'),
('WIL-JKT-02', 'Wilayah Jakarta Selatan', 'DKI Jakarta', 'Jakarta Selatan', 'aktif');

-- Sample Pegawai
INSERT INTO pegawai (nip, nama_lengkap, email, phone, jabatan, unit_id, role, status) VALUES
('EMP-2024-001', 'Budi Santoso', 'budi.santoso@company.com', '081234567890', 'Safety Officer', 
  (SELECT id FROM units WHERE kode_unit = 'UNIT-001'), 'user', 'aktif'),
('EMP-2024-002', 'Siti Nurhaliza', 'siti.nurhaliza@company.com', '081234567891', 'HSE Manager', 
  (SELECT id FROM units WHERE kode_unit = 'UNIT-001'), 'manager', 'aktif'),
('EMP-2024-003', 'Ahmad Hidayat', 'ahmad.hidayat@company.com', '081234567892', 'Admin', 
  NULL, 'admin', 'aktif');
```

---

## Setup Storage Buckets (via Supabase Dashboard)

```javascript
// Execute in Supabase Dashboard → Storage
// Create these buckets:

1. hsse-photos (Max: 10MB, Private)
2. hsse-documents (Max: 25MB, Private)
3. hsse-videos (Max: 100MB, Private)
4. hsse-certificates (Max: 5MB, Private)
5. profile-photos (Max: 2MB, Public)
```

---

## Verification Queries

```sql
-- Check table creation
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- Check indexes
SELECT tablename, indexname 
FROM pg_indexes 
WHERE schemaname = 'public' 
ORDER BY tablename, indexname;

-- Check foreign keys
SELECT
  tc.table_name, 
  kcu.column_name, 
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name 
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
ORDER BY tc.table_name;

-- Check row counts
SELECT 
  'units' as table_name, COUNT(*) as row_count FROM units
UNION ALL
SELECT 'wilayah', COUNT(*) FROM wilayah
UNION ALL
SELECT 'pegawai', COUNT(*) FROM pegawai;
```

---

## Rollback (if needed)

```sql
-- Drop all tables in reverse order
DROP TABLE IF EXISTS safety_drill CASCADE;
DROP TABLE IF EXISTS safety_induction CASCADE;
DROP TABLE IF EXISTS safety_patrol CASCADE;
DROP TABLE IF EXISTS management_walkthrough CASCADE;
DROP TABLE IF EXISTS safety_forum CASCADE;
DROP TABLE IF EXISTS silent_inspection CASCADE;
DROP TABLE IF EXISTS safety_briefing CASCADE;
DROP TABLE IF EXISTS tamu_eksternal CASCADE;
DROP TABLE IF EXISTS pegawai CASCADE;
DROP TABLE IF EXISTS wilayah CASCADE;
DROP TABLE IF EXISTS units CASCADE;

-- Drop functions
DROP FUNCTION IF EXISTS get_briefing_stats_by_unit;
DROP FUNCTION IF EXISTS get_patrol_compliance;
DROP FUNCTION IF EXISTS update_updated_at_column;
```

---

**Next**: Development Roadmap (08_ROADMAP.md)
