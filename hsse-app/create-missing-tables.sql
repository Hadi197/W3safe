-- =====================================================
-- Missing Tables for HSSE App
-- Create safety_briefing and silent_inspection tables
-- =====================================================

-- Create safety_briefing table
CREATE TABLE IF NOT EXISTS safety_briefing (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nomor_briefing VARCHAR(100) UNIQUE NOT NULL,
    tanggal DATE NOT NULL,
    waktu_mulai TIME,
    waktu_selesai TIME,
    unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
    area_briefing TEXT,
    petugas_id UUID, -- Will reference users table later
    topik_briefing TEXT NOT NULL,
    peserta JSONB,
    jumlah_peserta INTEGER DEFAULT 0,
    materi_briefing TEXT,
    poin_poin_pembahasan JSONB,
    kesimpulan TEXT,
    rekomendasi JSONB,
    tindak_lanjut JSONB,
    foto_briefing JSONB,
    dokumen_pendukung JSONB,
    status VARCHAR(50) DEFAULT 'draft' CHECK (status IN ('draft', 'in_progress', 'completed', 'cancelled')),
    jenis_briefing VARCHAR(50) CHECK (jenis_briefing IN ('rutin', 'khusus', 'follow_up')),
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    approved_by UUID,
    approved_at TIMESTAMP WITH TIME ZONE
);

-- Create silent_inspection table
CREATE TABLE IF NOT EXISTS silent_inspection (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nomor_inspeksi VARCHAR(100) UNIQUE NOT NULL,
    tanggal DATE NOT NULL,
    waktu_mulai TIME,
    waktu_selesai TIME,
    unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
    area_inspeksi TEXT,
    inspector_id UUID, -- Will reference users table later
    verified_by UUID, -- Will reference users table later
    jenis_inspeksi VARCHAR(50) CHECK (jenis_inspeksi IN ('silent', 'announced', 'follow_up')),
    fokus_inspeksi JSONB,
    temuan JSONB,
    jumlah_temuan INTEGER DEFAULT 0,
    kategori_temuan JSONB,
    rekomendasi JSONB,
    tindak_lanjut JSONB,
    status_verifikasi VARCHAR(20) DEFAULT 'pending' CHECK (status_verifikasi IN ('pending', 'verified', 'rejected')),
    foto_inspeksi JSONB,
    dokumen_pendukung JSONB,
    catatan_inspector TEXT,
    catatan_verifier TEXT,
    status VARCHAR(50) DEFAULT 'draft' CHECK (status IN ('draft', 'in_progress', 'completed', 'cancelled')),
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    approved_by UUID,
    approved_at TIMESTAMP WITH TIME ZONE
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_safety_briefing_tanggal ON safety_briefing(tanggal);
CREATE INDEX IF NOT EXISTS idx_safety_briefing_unit ON safety_briefing(unit_id);
CREATE INDEX IF NOT EXISTS idx_safety_briefing_status ON safety_briefing(status);
CREATE INDEX IF NOT EXISTS idx_safety_briefing_jenis ON safety_briefing(jenis_briefing);
CREATE INDEX IF NOT EXISTS idx_safety_briefing_petugas ON safety_briefing(petugas_id);
CREATE INDEX IF NOT EXISTS idx_safety_briefing_created_at ON safety_briefing(created_at);
CREATE INDEX IF NOT EXISTS idx_safety_briefing_nomor ON safety_briefing(nomor_briefing);

CREATE INDEX IF NOT EXISTS idx_silent_inspection_tanggal ON silent_inspection(tanggal);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_unit ON silent_inspection(unit_id);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_status ON silent_inspection(status);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_jenis ON silent_inspection(jenis_inspeksi);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_inspector ON silent_inspection(inspector_id);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_verifier ON silent_inspection(verified_by);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_created_at ON silent_inspection(created_at);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_nomor ON silent_inspection(nomor_inspeksi);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_verifikasi ON silent_inspection(status_verifikasi);

-- Enable RLS
ALTER TABLE safety_briefing ENABLE ROW LEVEL SECURITY;
ALTER TABLE silent_inspection ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Enable all for authenticated users" ON safety_briefing FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Enable all for authenticated users" ON silent_inspection FOR ALL USING (auth.role() = 'authenticated');

-- Insert sample data for testing
INSERT INTO safety_briefing (
    nomor_briefing, tanggal, waktu_mulai, waktu_selesai, unit_id, area_briefing,
    topik_briefing, peserta, jumlah_peserta, materi_briefing, status, jenis_briefing
) VALUES (
    'SB-2025-001', '2025-11-23', '08:00', '09:00',
    (SELECT id FROM units WHERE kode = 'UNIT-TANJUNGPERAK' LIMIT 1),
    'Dermaga Utama',
    'Safety Briefing Awal Shift - Prosedur Emergency Response',
    '["Petugas Dermaga", "Operator Crane", "Safety Officer"]',
    15,
    'Pembahasan prosedur tanggap darurat, penggunaan APD, dan identifikasi bahaya',
    'completed',
    'rutin'
);

INSERT INTO silent_inspection (
    nomor_inspeksi, tanggal, waktu_mulai, waktu_selesai, unit_id, area_inspeksi,
    jenis_inspeksi, temuan, jumlah_temuan, rekomendasi, status, status_verifikasi
) VALUES (
    'SI-2025-001', '2025-11-23', '10:00', '11:30',
    (SELECT id FROM units WHERE kode = 'UNIT-GRESIK' LIMIT 1),
    'Workshop Maintenance',
    'silent',
    '["APD tidak digunakan dengan benar", "Area kerja tidak tertib"]',
    2,
    '["Pelatihan penggunaan APD", "Pembersihan area kerja rutin"]',
    'completed',
    'verified'
);

-- Verify setup
SELECT 'Missing tables created successfully!' as status;