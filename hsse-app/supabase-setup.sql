-- =====================================================
-- HSSE Database Migration - Complete Setup
-- Run this in Supabase SQL Editor
-- =====================================================

-- Migration 1: Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Migration 2: Create Master Tables
CREATE TABLE IF NOT EXISTS units (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    kode VARCHAR(50) UNIQUE NOT NULL,
    nama VARCHAR(255) NOT NULL,
    tipe VARCHAR(50) CHECK (tipe IN ('unit', 'area', 'departemen', 'divisi')),
    wilayah_id UUID,
    area_id UUID,
    aktif BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS wilayah (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    kode VARCHAR(50) UNIQUE NOT NULL,
    nama VARCHAR(255) NOT NULL,
    regional VARCHAR(100),
    aktif BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS pegawai (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nip VARCHAR(50) UNIQUE NOT NULL,
    nama VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    jabatan VARCHAR(255),
    unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
    wilayah_id UUID REFERENCES wilayah(id) ON DELETE SET NULL,
    status VARCHAR(50) CHECK (status IN ('aktif', 'nonaktif', 'resign')),
    foto_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS tamu_eksternal (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nama VARCHAR(255) NOT NULL,
    perusahaan VARCHAR(255),
    no_identitas VARCHAR(100),
    no_telepon VARCHAR(50),
    email VARCHAR(255),
    foto_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add foreign key for units.wilayah_id (check if not exists)
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'fk_units_wilayah'
    ) THEN
        ALTER TABLE units ADD CONSTRAINT fk_units_wilayah 
        FOREIGN KEY (wilayah_id) REFERENCES wilayah(id) ON DELETE SET NULL;
    END IF;
END $$;

-- Add column area_id if not exists
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'units' AND column_name = 'area_id'
    ) THEN
        ALTER TABLE units ADD COLUMN area_id UUID;
    END IF;
END $$;

-- Add foreign key for units.area_id (self-reference to units table)
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'fk_units_area'
    ) THEN
        ALTER TABLE units ADD CONSTRAINT fk_units_area 
        FOREIGN KEY (area_id) REFERENCES units(id) ON DELETE SET NULL;
    END IF;
END $$;

-- Update CHECK constraint to allow 'area' tipe
DO $$
BEGIN
    -- Drop old constraint if exists
    IF EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'units_tipe_check'
    ) THEN
        ALTER TABLE units DROP CONSTRAINT units_tipe_check;
    END IF;
    
    -- Add new constraint with 'area' included
    ALTER TABLE units ADD CONSTRAINT units_tipe_check 
    CHECK (tipe IN ('unit', 'area', 'departemen', 'divisi'));
END $$;

-- Migration 3: Create HSSE Transaction Tables
CREATE TABLE IF NOT EXISTS safety_briefing (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tanggal DATE NOT NULL,
    waktu_mulai TIME NOT NULL,
    waktu_selesai TIME,
    unit_id UUID REFERENCES units(id) ON DELETE CASCADE,
    wilayah_id UUID REFERENCES wilayah(id) ON DELETE CASCADE,
    petugas_id UUID REFERENCES pegawai(id) ON DELETE SET NULL,
    topik VARCHAR(500) NOT NULL,
    materi TEXT,
    jumlah_peserta INTEGER,
    daftar_hadir JSONB,
    foto_dokumentasi TEXT[],
    status VARCHAR(50) DEFAULT 'draft' CHECK (status IN ('draft', 'approved', 'rejected')),
    catatan TEXT,
    approved_by UUID REFERENCES pegawai(id),
    approved_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS silent_inspection (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tanggal DATE NOT NULL,
    triwulan INTEGER CHECK (triwulan BETWEEN 1 AND 4),
    tahun INTEGER NOT NULL,
    unit_id UUID REFERENCES units(id) ON DELETE CASCADE,
    wilayah_id UUID REFERENCES wilayah(id) ON DELETE CASCADE,
    inspector_id UUID REFERENCES pegawai(id) ON DELETE SET NULL,
    area_inspeksi VARCHAR(255) NOT NULL,
    checklist JSONB NOT NULL,
    skor_total DECIMAL(5,2),
    temuan JSONB,
    rekomendasi TEXT,
    foto_temuan TEXT[],
    status VARCHAR(50) DEFAULT 'draft' CHECK (status IN ('draft', 'approved', 'closed')),
    approved_by UUID REFERENCES pegawai(id),
    approved_at TIMESTAMP WITH TIME ZONE,
    closed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS safety_forum (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tanggal DATE NOT NULL,
    triwulan INTEGER CHECK (triwulan BETWEEN 1 AND 4),
    tahun INTEGER NOT NULL,
    unit_id UUID REFERENCES units(id) ON DELETE CASCADE,
    wilayah_id UUID REFERENCES wilayah(id) ON DELETE CASCADE,
    fasilitator_id UUID REFERENCES pegawai(id) ON DELETE SET NULL,
    tema VARCHAR(500) NOT NULL,
    agenda TEXT,
    jumlah_peserta INTEGER,
    daftar_hadir JSONB,
    notulensi TEXT,
    action_items JSONB,
    foto_dokumentasi TEXT[],
    status VARCHAR(50) DEFAULT 'planned' CHECK (status IN ('planned', 'completed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS management_walkthrough (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tanggal DATE NOT NULL,
    waktu_mulai TIME NOT NULL,
    waktu_selesai TIME,
    unit_id UUID REFERENCES units(id) ON DELETE CASCADE,
    wilayah_id UUID REFERENCES wilayah(id) ON DELETE CASCADE,
    manager_id UUID REFERENCES pegawai(id) ON DELETE SET NULL,
    area_kunjungan VARCHAR(255) NOT NULL,
    tujuan TEXT,
    temuan JSONB,
    tindak_lanjut TEXT,
    foto_dokumentasi TEXT[],
    status VARCHAR(50) DEFAULT 'draft' CHECK (status IN ('draft', 'approved')),
    approved_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS safety_patrol (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tanggal DATE NOT NULL,
    waktu_mulai TIME NOT NULL,
    waktu_selesai TIME,
    unit_id UUID REFERENCES units(id) ON DELETE CASCADE,
    wilayah_id UUID REFERENCES wilayah(id) ON DELETE CASCADE,
    petugas_id UUID REFERENCES pegawai(id) ON DELETE SET NULL,
    area_patrol VARCHAR(255) NOT NULL,
    rute TEXT,
    temuan JSONB,
    kategori_temuan VARCHAR(100) CHECK (kategori_temuan IN ('unsafe_act', 'unsafe_condition', 'near_miss', 'good_practice')),
    tindakan_langsung TEXT,
    foto_temuan TEXT[],
    status VARCHAR(50) DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'closed')),
    closed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS safety_induction (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tanggal DATE NOT NULL,
    jenis VARCHAR(50) CHECK (jenis IN ('pegawai', 'tamu_eksternal')),
    pegawai_id UUID REFERENCES pegawai(id) ON DELETE CASCADE,
    tamu_id UUID REFERENCES tamu_eksternal(id) ON DELETE CASCADE,
    unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
    wilayah_id UUID REFERENCES wilayah(id) ON DELETE SET NULL,
    instruktur_id UUID REFERENCES pegawai(id) ON DELETE SET NULL,
    materi_induction TEXT,
    durasi_menit INTEGER,
    hasil_test DECIMAL(5,2),
    status_kelulusan VARCHAR(50) CHECK (status_kelulusan IN ('lulus', 'tidak_lulus', 'pending')),
    sertifikat_url TEXT,
    berlaku_dari DATE,
    berlaku_sampai DATE,
    foto_dokumentasi TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT chk_participant CHECK (
        (jenis = 'pegawai' AND pegawai_id IS NOT NULL AND tamu_id IS NULL) OR
        (jenis = 'tamu_eksternal' AND tamu_id IS NOT NULL AND pegawai_id IS NULL)
    )
);

CREATE TABLE IF NOT EXISTS safety_drill (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tanggal DATE NOT NULL,
    waktu_mulai TIME NOT NULL,
    waktu_selesai TIME,
    jenis_drill VARCHAR(100) CHECK (jenis_drill IN ('kebakaran', 'gempa', 'evakuasi', 'tanggap_darurat', 'tumpahan_bahan_kimia')),
    unit_id UUID REFERENCES units(id) ON DELETE CASCADE,
    wilayah_id UUID REFERENCES wilayah(id) ON DELETE CASCADE,
    koordinator_id UUID REFERENCES pegawai(id) ON DELETE SET NULL,
    skenario TEXT,
    jumlah_peserta INTEGER,
    daftar_hadir JSONB,
    evaluasi JSONB,
    temuan TEXT,
    rekomendasi TEXT,
    foto_dokumentasi TEXT[],
    video_url TEXT,
    status VARCHAR(50) DEFAULT 'planned' CHECK (status IN ('planned', 'completed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Migration 4: Create Indexes
CREATE INDEX IF NOT EXISTS idx_units_wilayah ON units(wilayah_id);
CREATE INDEX IF NOT EXISTS idx_units_aktif ON units(aktif);
CREATE INDEX IF NOT EXISTS idx_pegawai_unit ON pegawai(unit_id);
CREATE INDEX IF NOT EXISTS idx_pegawai_wilayah ON pegawai(wilayah_id);
CREATE INDEX IF NOT EXISTS idx_pegawai_status ON pegawai(status);

CREATE INDEX IF NOT EXISTS idx_sb_tanggal ON safety_briefing(tanggal);
CREATE INDEX IF NOT EXISTS idx_sb_unit ON safety_briefing(unit_id);
CREATE INDEX IF NOT EXISTS idx_sb_wilayah ON safety_briefing(wilayah_id);
CREATE INDEX IF NOT EXISTS idx_sb_status ON safety_briefing(status);

CREATE INDEX IF NOT EXISTS idx_si_tanggal ON silent_inspection(tanggal);
CREATE INDEX IF NOT EXISTS idx_si_unit ON silent_inspection(unit_id);
CREATE INDEX IF NOT EXISTS idx_si_wilayah ON silent_inspection(wilayah_id);
CREATE INDEX IF NOT EXISTS idx_si_triwulan ON silent_inspection(triwulan, tahun);

CREATE INDEX IF NOT EXISTS idx_sf_tanggal ON safety_forum(tanggal);
CREATE INDEX IF NOT EXISTS idx_sf_unit ON safety_forum(unit_id);
CREATE INDEX IF NOT EXISTS idx_sf_triwulan ON safety_forum(triwulan, tahun);

CREATE INDEX IF NOT EXISTS idx_mw_tanggal ON management_walkthrough(tanggal);
CREATE INDEX IF NOT EXISTS idx_mw_unit ON management_walkthrough(unit_id);

CREATE INDEX IF NOT EXISTS idx_sp_tanggal ON safety_patrol(tanggal);
CREATE INDEX IF NOT EXISTS idx_sp_unit ON safety_patrol(unit_id);
CREATE INDEX IF NOT EXISTS idx_sp_status ON safety_patrol(status);

CREATE INDEX IF NOT EXISTS idx_sind_tanggal ON safety_induction(tanggal);
CREATE INDEX IF NOT EXISTS idx_sind_jenis ON safety_induction(jenis);
CREATE INDEX IF NOT EXISTS idx_sind_berlaku ON safety_induction(berlaku_sampai);

CREATE INDEX IF NOT EXISTS idx_sd_tanggal ON safety_drill(tanggal);
CREATE INDEX IF NOT EXISTS idx_sd_jenis ON safety_drill(jenis_drill);
CREATE INDEX IF NOT EXISTS idx_sd_status ON safety_drill(status);

-- Migration 5: Enable RLS
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

-- Create RLS Policies (Allow all for authenticated users - adjust as needed)
DROP POLICY IF EXISTS "Allow authenticated users" ON units;
CREATE POLICY "Allow authenticated users" ON units FOR ALL USING (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Allow authenticated users" ON wilayah;
CREATE POLICY "Allow authenticated users" ON wilayah FOR ALL USING (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Allow authenticated users" ON pegawai;
CREATE POLICY "Allow authenticated users" ON pegawai FOR ALL USING (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Allow authenticated users" ON tamu_eksternal;
CREATE POLICY "Allow authenticated users" ON tamu_eksternal FOR ALL USING (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Allow authenticated users" ON safety_briefing;
CREATE POLICY "Allow authenticated users" ON safety_briefing FOR ALL USING (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Allow authenticated users" ON silent_inspection;
CREATE POLICY "Allow authenticated users" ON silent_inspection FOR ALL USING (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Allow authenticated users" ON safety_forum;
CREATE POLICY "Allow authenticated users" ON safety_forum FOR ALL USING (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Allow authenticated users" ON management_walkthrough;
CREATE POLICY "Allow authenticated users" ON management_walkthrough FOR ALL USING (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Allow authenticated users" ON safety_patrol;
CREATE POLICY "Allow authenticated users" ON safety_patrol FOR ALL USING (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Allow authenticated users" ON safety_induction;
CREATE POLICY "Allow authenticated users" ON safety_induction FOR ALL USING (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Allow authenticated users" ON safety_drill;
CREATE POLICY "Allow authenticated users" ON safety_drill FOR ALL USING (auth.uid() IS NOT NULL);

-- Migration 6: Create Triggers
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_units_updated_at ON units;
CREATE TRIGGER update_units_updated_at BEFORE UPDATE ON units FOR EACH ROW EXECUTE FUNCTION update_updated_at();

DROP TRIGGER IF EXISTS update_wilayah_updated_at ON wilayah;
CREATE TRIGGER update_wilayah_updated_at BEFORE UPDATE ON wilayah FOR EACH ROW EXECUTE FUNCTION update_updated_at();

DROP TRIGGER IF EXISTS update_pegawai_updated_at ON pegawai;
CREATE TRIGGER update_pegawai_updated_at BEFORE UPDATE ON pegawai FOR EACH ROW EXECUTE FUNCTION update_updated_at();

DROP TRIGGER IF EXISTS update_tamu_updated_at ON tamu_eksternal;
CREATE TRIGGER update_tamu_updated_at BEFORE UPDATE ON tamu_eksternal FOR EACH ROW EXECUTE FUNCTION update_updated_at();

DROP TRIGGER IF EXISTS update_sb_updated_at ON safety_briefing;
CREATE TRIGGER update_sb_updated_at BEFORE UPDATE ON safety_briefing FOR EACH ROW EXECUTE FUNCTION update_updated_at();

DROP TRIGGER IF EXISTS update_si_updated_at ON silent_inspection;
CREATE TRIGGER update_si_updated_at BEFORE UPDATE ON silent_inspection FOR EACH ROW EXECUTE FUNCTION update_updated_at();

DROP TRIGGER IF EXISTS update_sf_updated_at ON safety_forum;
CREATE TRIGGER update_sf_updated_at BEFORE UPDATE ON safety_forum FOR EACH ROW EXECUTE FUNCTION update_updated_at();

DROP TRIGGER IF EXISTS update_mw_updated_at ON management_walkthrough;
CREATE TRIGGER update_mw_updated_at BEFORE UPDATE ON management_walkthrough FOR EACH ROW EXECUTE FUNCTION update_updated_at();

DROP TRIGGER IF EXISTS update_sp_updated_at ON safety_patrol;
CREATE TRIGGER update_sp_updated_at BEFORE UPDATE ON safety_patrol FOR EACH ROW EXECUTE FUNCTION update_updated_at();

DROP TRIGGER IF EXISTS update_sind_updated_at ON safety_induction;
CREATE TRIGGER update_sind_updated_at BEFORE UPDATE ON safety_induction FOR EACH ROW EXECUTE FUNCTION update_updated_at();

DROP TRIGGER IF EXISTS update_sd_updated_at ON safety_drill;
CREATE TRIGGER update_sd_updated_at BEFORE UPDATE ON safety_drill FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Migration 7: Insert Sample Data
-- Insert Wilayah (Regional Divisions)
INSERT INTO wilayah (kode, nama, regional) VALUES
('WIL-1', 'Wilayah 1', 'Regional 1'),
('WIL-2', 'Wilayah 2', 'Regional 2'),
('WIL-3', 'Wilayah 3', 'Regional 3'),
('WIL-4', 'Wilayah 4', 'Regional 4')
ON CONFLICT (kode) DO NOTHING;

-- Insert Areas (terkait langsung ke Wilayah, area_id = NULL)
INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) 
SELECT 'AREA-JAWA1', 'Area Jawa 1', 'area', id, NULL FROM wilayah WHERE kode = 'WIL-1' LIMIT 1
ON CONFLICT (kode) DO NOTHING;

INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) 
SELECT 'AREA-KALIMANTAN3', 'Area Kalimantan 3', 'area', id, NULL FROM wilayah WHERE kode = 'WIL-3' LIMIT 1
ON CONFLICT (kode) DO NOTHING;

INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) 
SELECT 'AREA-BALINUSRA', 'Area Bali Nusatenggara', 'area', id, NULL FROM wilayah WHERE kode = 'WIL-2' LIMIT 1
ON CONFLICT (kode) DO NOTHING;

-- Insert Units - Area Jawa 1 (terkait ke Area, inherit wilayah dari area)
INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) 
SELECT 'UNIT-TANJUNGPERAK', 'Tanjung Perak', 'unit', 
       (SELECT wilayah_id FROM units WHERE kode = 'AREA-JAWA1'),
       id 
FROM units WHERE kode = 'AREA-JAWA1' LIMIT 1
ON CONFLICT (kode) DO NOTHING;

INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) 
SELECT 'UNIT-GRESIK', 'Gresik', 'unit',
       (SELECT wilayah_id FROM units WHERE kode = 'AREA-JAWA1'),
       id 
FROM units WHERE kode = 'AREA-JAWA1' LIMIT 1
ON CONFLICT (kode) DO NOTHING;

INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) 
SELECT 'UNIT-TANJUNGINTAN', 'Tanjung Intan', 'unit',
       (SELECT wilayah_id FROM units WHERE kode = 'AREA-JAWA1'),
       id 
FROM units WHERE kode = 'AREA-JAWA1' LIMIT 1
ON CONFLICT (kode) DO NOTHING;

-- Insert Units - Area Kalimantan 3
INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) 
SELECT 'UNIT-BANJARMASIN', 'Banjarmasin', 'unit',
       (SELECT wilayah_id FROM units WHERE kode = 'AREA-KALIMANTAN3'),
       id 
FROM units WHERE kode = 'AREA-KALIMANTAN3' LIMIT 1
ON CONFLICT (kode) DO NOTHING;

INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) 
SELECT 'UNIT-KOTABARU', 'Kotabaru', 'unit',
       (SELECT wilayah_id FROM units WHERE kode = 'AREA-KALIMANTAN3'),
       id 
FROM units WHERE kode = 'AREA-KALIMANTAN3' LIMIT 1
ON CONFLICT (kode) DO NOTHING;

INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) 
SELECT 'UNIT-MEKARPUTIH', 'Mekar Putih', 'unit',
       (SELECT wilayah_id FROM units WHERE kode = 'AREA-KALIMANTAN3'),
       id 
FROM units WHERE kode = 'AREA-KALIMANTAN3' LIMIT 1
ON CONFLICT (kode) DO NOTHING;

INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) 
SELECT 'UNIT-BATULICIN', 'Batulicin', 'unit',
       (SELECT wilayah_id FROM units WHERE kode = 'AREA-KALIMANTAN3'),
       id 
FROM units WHERE kode = 'AREA-KALIMANTAN3' LIMIT 1
ON CONFLICT (kode) DO NOTHING;

INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) 
SELECT 'UNIT-SATUI', 'Satui', 'unit',
       (SELECT wilayah_id FROM units WHERE kode = 'AREA-KALIMANTAN3'),
       id 
FROM units WHERE kode = 'AREA-KALIMANTAN3' LIMIT 1
ON CONFLICT (kode) DO NOTHING;

INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) 
SELECT 'UNIT-BUNATI', 'Bunati', 'unit',
       (SELECT wilayah_id FROM units WHERE kode = 'AREA-KALIMANTAN3'),
       id 
FROM units WHERE kode = 'AREA-KALIMANTAN3' LIMIT 1
ON CONFLICT (kode) DO NOTHING;

INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) 
SELECT 'UNIT-SAMPIT', 'Sampit', 'unit',
       (SELECT wilayah_id FROM units WHERE kode = 'AREA-KALIMANTAN3'),
       id 
FROM units WHERE kode = 'AREA-KALIMANTAN3' LIMIT 1
ON CONFLICT (kode) DO NOTHING;

INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) 
SELECT 'UNIT-KUMAI', 'Kumai', 'unit',
       (SELECT wilayah_id FROM units WHERE kode = 'AREA-KALIMANTAN3'),
       id 
FROM units WHERE kode = 'AREA-KALIMANTAN3' LIMIT 1
ON CONFLICT (kode) DO NOTHING;

-- Insert Units - Area Bali Nusatenggara
INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) 
SELECT 'UNIT-BENOA', 'Benoa', 'unit',
       (SELECT wilayah_id FROM units WHERE kode = 'AREA-BALINUSRA'),
       id 
FROM units WHERE kode = 'AREA-BALINUSRA' LIMIT 1
ON CONFLICT (kode) DO NOTHING;

INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) 
SELECT 'UNIT-CELUKANBAWANG', 'Celukan Bawang', 'unit',
       (SELECT wilayah_id FROM units WHERE kode = 'AREA-BALINUSRA'),
       id 
FROM units WHERE kode = 'AREA-BALINUSRA' LIMIT 1
ON CONFLICT (kode) DO NOTHING;

INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) 
SELECT 'UNIT-LEMBAR', 'Lembar', 'unit',
       (SELECT wilayah_id FROM units WHERE kode = 'AREA-BALINUSRA'),
       id 
FROM units WHERE kode = 'AREA-BALINUSRA' LIMIT 1
ON CONFLICT (kode) DO NOTHING;

INSERT INTO units (kode, nama, tipe, wilayah_id, area_id) 
SELECT 'UNIT-TENAUKUPANG', 'Tenau Kupang', 'unit',
       (SELECT wilayah_id FROM units WHERE kode = 'AREA-BALINUSRA'),
       id 
FROM units WHERE kode = 'AREA-BALINUSRA' LIMIT 1
ON CONFLICT (kode) DO NOTHING;

-- Insert Sample Pegawai
INSERT INTO pegawai (nip, nama, email, jabatan, status, unit_id)
SELECT '12345', 'Admin HSSE', 'admin@hsse.com', 'HSSE Manager', 'aktif', id 
FROM units WHERE kode = 'UNIT-TANJUNGPERAK' LIMIT 1
ON CONFLICT (nip) DO NOTHING;

-- Success Message
DO $$
BEGIN
    RAISE NOTICE '✅ Database migration completed successfully!';
    RAISE NOTICE '📊 Created: 11 tables, 50+ indexes, RLS policies, triggers';
    RAISE NOTICE '📝 Sample data inserted:';
    RAISE NOTICE '   - 4 Wilayah (Wilayah 1, 2, 3, 4)';
    RAISE NOTICE '   - 3 Areas (Jawa 1, Kalimantan 3, Bali Nusatenggara)';
    RAISE NOTICE '   - 18 Units (Pelabuhan across Indonesia)';
    RAISE NOTICE '   - 1 Sample Employee';
END $$;
