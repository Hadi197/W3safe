-- Migration: Create silent_inspection table
-- Description: Table for silent inspection records in HSSE system

-- Drop table if exists (clean slate)
DROP TABLE IF EXISTS silent_inspection CASCADE;

-- Create function for updating updated_at timestamp (if not exists)
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create silent_inspection table
CREATE TABLE silent_inspection (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Data Dasar
    tanggal DATE NOT NULL,
    waktu_mulai TIME NOT NULL,
    waktu_selesai TIME,
    unit_id UUID REFERENCES units(id) ON DELETE RESTRICT,
    area_inspeksi VARCHAR(200),
    
    -- Tim Inspeksi
    inspector_id UUID REFERENCES pegawai(id) ON DELETE RESTRICT,
    anggota_tim TEXT[], -- Array nama anggota tim
    
    -- Kategori Pemeriksaan
    kategori_bahaya VARCHAR(50),
    checklist_items JSONB, -- Checklist dalam format JSON
    
    -- Temuan
    jumlah_temuan INTEGER DEFAULT 0,
    temuan_critical INTEGER DEFAULT 0,
    temuan_major INTEGER DEFAULT 0,
    temuan_minor INTEGER DEFAULT 0,
    deskripsi_temuan TEXT,
    
    -- Dokumentasi
    foto_kondisi_unsafe TEXT[], -- Array URL foto kondisi tidak aman
    foto_perilaku_unsafe TEXT[], -- Array URL foto perilaku tidak aman
    
    -- Penilaian
    skor_kepatuhan NUMERIC(5,2),
    tingkat_risiko VARCHAR(20),
    kondisi_housekeeping VARCHAR(20),
    penggunaan_apd VARCHAR(20),
    
    -- Tindak Lanjut
    rekomendasi TEXT,
    tindakan_korektif TEXT,
    pic_tindak_lanjut VARCHAR(200),
    target_penyelesaian DATE,
    status_tindak_lanjut VARCHAR(20) DEFAULT 'open',
    
    -- Meta Data
    status VARCHAR(20) DEFAULT 'draft',
    catatan TEXT,
    verified_by UUID REFERENCES pegawai(id) ON DELETE SET NULL,
    verified_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Add CHECK constraints
ALTER TABLE silent_inspection ADD CONSTRAINT chk_skor_kepatuhan CHECK (skor_kepatuhan >= 0 AND skor_kepatuhan <= 100);
ALTER TABLE silent_inspection ADD CONSTRAINT chk_kategori_bahaya CHECK (kategori_bahaya IN ('fisik_mekanik', 'kimia', 'biologis', 'ergonomi', 'psikososial', 'kombinasi'));
ALTER TABLE silent_inspection ADD CONSTRAINT chk_tingkat_risiko CHECK (tingkat_risiko IN ('rendah', 'sedang', 'tinggi', 'sangat_tinggi'));
ALTER TABLE silent_inspection ADD CONSTRAINT chk_kondisi_housekeeping CHECK (kondisi_housekeeping IN ('baik', 'cukup', 'buruk'));
ALTER TABLE silent_inspection ADD CONSTRAINT chk_penggunaan_apd CHECK (penggunaan_apd IN ('baik', 'cukup', 'buruk'));
ALTER TABLE silent_inspection ADD CONSTRAINT chk_status_tindak_lanjut CHECK (status_tindak_lanjut IN ('open', 'in_progress', 'closed'));
ALTER TABLE silent_inspection ADD CONSTRAINT chk_status CHECK (status IN ('draft', 'submitted', 'verified', 'closed'));

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_silent_inspection_tanggal ON silent_inspection(tanggal DESC);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_unit ON silent_inspection(unit_id);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_inspector ON silent_inspection(inspector_id);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_status ON silent_inspection(status);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_tingkat_risiko ON silent_inspection(tingkat_risiko);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_status_tindak_lanjut ON silent_inspection(status_tindak_lanjut);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_created_at ON silent_inspection(created_at DESC);

-- Create trigger for updated_at
DROP TRIGGER IF EXISTS update_silent_inspection_updated_at ON silent_inspection;
CREATE TRIGGER update_silent_inspection_updated_at
    BEFORE UPDATE ON silent_inspection
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security
ALTER TABLE silent_inspection ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON silent_inspection;
DROP POLICY IF EXISTS "Enable insert access for authenticated users" ON silent_inspection;
DROP POLICY IF EXISTS "Enable update access for authenticated users" ON silent_inspection;
DROP POLICY IF EXISTS "Enable delete access for authenticated users" ON silent_inspection;

-- Create RLS Policies
CREATE POLICY "Enable read access for authenticated users"
    ON silent_inspection FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Enable insert access for authenticated users"
    ON silent_inspection FOR INSERT
    TO authenticated
    WITH CHECK (true);

CREATE POLICY "Enable update access for authenticated users"
    ON silent_inspection FOR UPDATE
    TO authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Enable delete access for authenticated users"
    ON silent_inspection FOR DELETE
    TO authenticated
    USING (true);

-- Insert sample data
INSERT INTO silent_inspection (
    tanggal,
    waktu_mulai,
    waktu_selesai,
    unit_id,
    area_inspeksi,
    kategori_bahaya,
    jumlah_temuan,
    temuan_critical,
    temuan_major,
    temuan_minor,
    deskripsi_temuan,
    skor_kepatuhan,
    tingkat_risiko,
    kondisi_housekeeping,
    penggunaan_apd,
    rekomendasi,
    tindakan_korektif,
    pic_tindak_lanjut,
    target_penyelesaian,
    status_tindak_lanjut,
    status,
    catatan
) VALUES (
    CURRENT_DATE,
    '09:00:00',
    '11:30:00',
    (SELECT id FROM units LIMIT 1),
    'Area Dermaga 1',
    'fisik_mekanik',
    8,
    2,
    3,
    3,
    'Ditemukan beberapa kondisi tidak aman: 1) Tangga tanpa handrail, 2) Kabel listrik tidak tertata, 3) APD tidak digunakan lengkap',
    72.5,
    'tinggi',
    'cukup',
    'buruk',
    '1. Pasang handrail pada tangga, 2. Rapikan instalasi kabel, 3. Enforcement penggunaan APD',
    'Koordinasi dengan maintenance untuk perbaikan infrastruktur dan sosialisasi ulang SOP penggunaan APD',
    'Supervisor HSE',
    CURRENT_DATE + INTERVAL '7 days',
    'open',
    'submitted',
    'Perlu tindakan segera untuk temuan critical'
) ON CONFLICT DO NOTHING;

-- Verify data
SELECT 
    id,
    tanggal,
    area_inspeksi,
    jumlah_temuan,
    tingkat_risiko,
    status,
    created_at
FROM silent_inspection
ORDER BY created_at DESC
LIMIT 5;
