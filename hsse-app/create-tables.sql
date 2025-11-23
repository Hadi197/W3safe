-- =====================================================
-- HSSE Database Setup - Complete Tables
-- Run this in Supabase SQL Editor AFTER quick-setup.sql
-- =====================================================

-- Create management_walkthrough table
CREATE TABLE IF NOT EXISTS management_walkthrough (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nomor_walkthrough VARCHAR(100) UNIQUE NOT NULL,
    tanggal_walkthrough DATE NOT NULL,
    waktu_mulai TIME,
    waktu_selesai TIME,
    unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
    area_inspeksi TEXT,
    departemen VARCHAR(255),
    pimpinan_walkthrough TEXT NOT NULL,
    anggota_tim JSONB,
    jumlah_tim INTEGER,
    tujuan_walkthrough TEXT,
    fokus_area JSONB,
    jenis_walkthrough VARCHAR(50) CHECK (jenis_walkthrough IN ('rutin', 'terjadwal', 'insidental', 'follow_up', 'khusus')),

    -- Kondisi Housekeeping
    kondisi_housekeeping VARCHAR(20) CHECK (kondisi_housekeeping IN ('baik', 'cukup', 'kurang', 'buruk')),
    kondisi_pencahayaan VARCHAR(20) CHECK (kondisi_pencahayaan IN ('baik', 'cukup', 'kurang', 'buruk')),
    kondisi_ventilasi VARCHAR(20) CHECK (kondisi_ventilasi IN ('baik', 'cukup', 'kurang', 'buruk')),
    kondisi_akses_jalan VARCHAR(20) CHECK (kondisi_akses_jalan IN ('baik', 'cukup', 'kurang', 'buruk')),

    -- APD
    kepatuhan_apd INTEGER CHECK (kepatuhan_apd >= 0 AND kepatuhan_apd <= 100),
    apd_tersedia BOOLEAN DEFAULT false,
    apd_kondisi_baik BOOLEAN DEFAULT false,
    apd_digunakan_benar BOOLEAN DEFAULT false,
    apd_tidak_sesuai JSONB,

    -- Perilaku Kerja
    pekerja_diamati INTEGER DEFAULT 0,
    perilaku_aman INTEGER DEFAULT 0,
    perilaku_tidak_aman INTEGER DEFAULT 0,
    perilaku_tidak_aman_detail JSONB,

    -- Interaksi Pekerja
    jumlah_pekerja_diwawancara INTEGER DEFAULT 0,
    feedback_pekerja JSONB,
    saran_pekerja JSONB,
    pekerja_aware_prosedur BOOLEAN DEFAULT false,

    -- Temuan
    jumlah_temuan INTEGER DEFAULT 0,
    temuan_bahaya JSONB,
    temuan_kritis INTEGER DEFAULT 0,
    temuan_mayor INTEGER DEFAULT 0,
    temuan_minor INTEGER DEFAULT 0,
    temuan_observasi INTEGER DEFAULT 0,

    -- Pelanggaran
    pelanggaran_prosedur JSONB,
    pelanggaran_peraturan JSONB,
    area_non_compliance JSONB,

    -- Positive Findings
    praktek_baik JSONB,
    area_excellent JSONB,
    pekerja_teladan JSONB,

    -- Action Items
    action_items JSONB,
    jumlah_action_item INTEGER DEFAULT 0,
    action_selesai INTEGER DEFAULT 0,
    action_progress INTEGER DEFAULT 0,
    action_belum_mulai INTEGER DEFAULT 0,

    -- Immediate Actions
    tindakan_segera JSONB,
    area_ditutup JSONB,
    pekerjaan_dihentikan JSONB,

    -- Dokumentasi
    foto_walkthrough JSONB,
    dokumen_pendukung JSONB,
    sketsa_lokasi_url TEXT,
    video_url TEXT,

    -- Ringkasan
    ringkasan_observasi TEXT,
    rekomendasi JSONB,
    catatan_khusus TEXT,

    -- Status
    status VARCHAR(50) DEFAULT 'draft' CHECK (status IN ('draft', 'in_progress', 'completed', 'cancelled')),
    tingkat_urgensi VARCHAR(20) DEFAULT 'normal' CHECK (tingkat_urgensi IN ('rendah', 'normal', 'tinggi', 'kritis')),

    -- Follow-up
    perlu_follow_up BOOLEAN DEFAULT false,
    tanggal_follow_up DATE,
    status_follow_up VARCHAR(20) CHECK (status_follow_up IN ('belum', 'terjadwal', 'selesai', 'tidak_perlu')),

    -- Scoring
    skor_keseluruhan DECIMAL(5,2),
    skor_housekeeping DECIMAL(5,2),
    skor_apd DECIMAL(5,2),
    skor_perilaku DECIMAL(5,2),

    -- Metadata
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    approved_by UUID,
    approved_at TIMESTAMP WITH TIME ZONE
);

-- Create safety_forum table
CREATE TABLE IF NOT EXISTS safety_forum (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nomor_forum VARCHAR(100) UNIQUE NOT NULL,
    tanggal_forum DATE NOT NULL,
    waktu_mulai TIME,
    waktu_selesai TIME,
    unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
    area_forum TEXT,
    ketua_forum TEXT NOT NULL,
    sekretaris_forum TEXT,
    peserta JSONB,
    jumlah_peserta INTEGER,
    agenda TEXT,
    topik_pembahasan JSONB,
    kesimpulan TEXT,
    rekomendasi JSONB,
    tindak_lanjut JSONB,
    status_notulen VARCHAR(20) DEFAULT 'draft' CHECK (status_notulen IN ('draft', 'final', 'approved')),
    foto_forum JSONB,
    dokumen_pendukung JSONB,
    status VARCHAR(50) DEFAULT 'draft' CHECK (status IN ('draft', 'in_progress', 'completed', 'cancelled')),
    jenis_forum VARCHAR(50) CHECK (jenis_forum IN ('rutin', 'khusus', 'follow_up')),
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    approved_by UUID,
    approved_at TIMESTAMP WITH TIME ZONE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_walkthrough_tanggal ON management_walkthrough(tanggal_walkthrough);
CREATE INDEX IF NOT EXISTS idx_walkthrough_unit ON management_walkthrough(unit_id);
CREATE INDEX IF NOT EXISTS idx_walkthrough_status ON management_walkthrough(status);
CREATE INDEX IF NOT EXISTS idx_walkthrough_jenis ON management_walkthrough(jenis_walkthrough);
CREATE INDEX IF NOT EXISTS idx_walkthrough_pimpinan ON management_walkthrough(pimpinan_walkthrough);
CREATE INDEX IF NOT EXISTS idx_walkthrough_created_at ON management_walkthrough(created_at);
CREATE INDEX IF NOT EXISTS idx_walkthrough_nomor ON management_walkthrough(nomor_walkthrough);
CREATE INDEX IF NOT EXISTS idx_walkthrough_urgensi ON management_walkthrough(tingkat_urgensi);

CREATE INDEX IF NOT EXISTS idx_safety_forum_tanggal ON safety_forum(tanggal_forum);
CREATE INDEX IF NOT EXISTS idx_safety_forum_unit ON safety_forum(unit_id);
CREATE INDEX IF NOT EXISTS idx_safety_forum_status ON safety_forum(status);
CREATE INDEX IF NOT EXISTS idx_safety_forum_jenis ON safety_forum(jenis_forum);
CREATE INDEX IF NOT EXISTS idx_safety_forum_ketua ON safety_forum(ketua_forum);
CREATE INDEX IF NOT EXISTS idx_safety_forum_created_at ON safety_forum(created_at);
CREATE INDEX IF NOT EXISTS idx_safety_forum_nomor ON safety_forum(nomor_forum);
CREATE INDEX IF NOT EXISTS idx_safety_forum_status_notulen ON safety_forum(status_notulen);

-- Enable RLS
ALTER TABLE units ENABLE ROW LEVEL SECURITY;
ALTER TABLE wilayah ENABLE ROW LEVEL SECURITY;
ALTER TABLE management_walkthrough ENABLE ROW LEVEL SECURITY;
ALTER TABLE safety_forum ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Enable all for authenticated users" ON units FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Enable all for authenticated users" ON wilayah FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Enable all for authenticated users" ON management_walkthrough FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Enable all for authenticated users" ON safety_forum FOR ALL USING (auth.role() = 'authenticated');

-- Verify setup
SELECT 'Tables created successfully!' as status;