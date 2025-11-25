-- Create LTIFR Records Table
-- Lost Time Injury Frequency Rate (LTIFR) = (Jumlah LTI × 1.000.000) / Total Jam Kerja

CREATE TABLE IF NOT EXISTS ltifr_records (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    
    -- Periode dan Unit
    periode_bulan VARCHAR(7) NOT NULL, -- Format: YYYY-MM
    unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
    
    -- Data Kecelakaan
    jumlah_lti INTEGER NOT NULL DEFAULT 0, -- Lost Time Injury
    jumlah_fatality INTEGER NOT NULL DEFAULT 0, -- Kecelakaan Fatal
    jumlah_near_miss INTEGER NOT NULL DEFAULT 0, -- Nyaris Celaka
    
    -- Data Jam Kerja
    jumlah_pekerja INTEGER NOT NULL DEFAULT 0,
    hari_kerja INTEGER NOT NULL DEFAULT 0,
    jam_kerja_per_hari NUMERIC(5,2) NOT NULL DEFAULT 8.00,
    total_jam_kerja INTEGER NOT NULL DEFAULT 0, -- jumlah_pekerja × hari_kerja × jam_kerja_per_hari
    
    -- Hasil Perhitungan
    ltifr NUMERIC(10,2) NOT NULL DEFAULT 0.00, -- (jumlah_lti × 1.000.000) / total_jam_kerja
    
    -- Detail
    deskripsi_kecelakaan TEXT,
    tindakan_perbaikan TEXT,
    pic_penanggung_jawab VARCHAR(150), -- Nama PIC yang menangani
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT check_positive_lti CHECK (jumlah_lti >= 0),
    CONSTRAINT check_positive_fatality CHECK (jumlah_fatality >= 0),
    CONSTRAINT check_positive_near_miss CHECK (jumlah_near_miss >= 0),
    CONSTRAINT check_positive_pekerja CHECK (jumlah_pekerja >= 0),
    CONSTRAINT check_positive_hari CHECK (hari_kerja >= 0),
    CONSTRAINT check_positive_jam CHECK (jam_kerja_per_hari >= 0),
    CONSTRAINT check_positive_total_jam CHECK (total_jam_kerja >= 0)
);

-- Indexes
CREATE INDEX idx_ltifr_periode ON ltifr_records(periode_bulan);
CREATE INDEX idx_ltifr_unit ON ltifr_records(unit_id);
CREATE INDEX idx_ltifr_created_at ON ltifr_records(created_at);
CREATE INDEX idx_ltifr_periode_unit ON ltifr_records(periode_bulan, unit_id);

-- Trigger untuk update timestamp
CREATE OR REPLACE FUNCTION update_ltifr_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_ltifr_timestamp
    BEFORE UPDATE ON ltifr_records
    FOR EACH ROW
    EXECUTE FUNCTION update_ltifr_updated_at();

-- Enable RLS
ALTER TABLE ltifr_records ENABLE ROW LEVEL SECURITY;

-- RLS Policies - Semua user yang terautentikasi bisa akses
CREATE POLICY "Authenticated users can view LTIFR records"
    ON ltifr_records FOR SELECT
    USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can insert LTIFR records"
    ON ltifr_records FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can update LTIFR records"
    ON ltifr_records FOR UPDATE
    USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can delete LTIFR records"
    ON ltifr_records FOR DELETE
    USING (auth.role() = 'authenticated');

-- Sample Data (Optional)
INSERT INTO ltifr_records (
    periode_bulan,
    unit_id,
    jumlah_lti,
    jumlah_fatality,
    jumlah_near_miss,
    jumlah_pekerja,
    hari_kerja,
    jam_kerja_per_hari,
    total_jam_kerja,
    ltifr,
    deskripsi_kecelakaan,
    tindakan_perbaikan
) VALUES
(
    '2025-01',
    (SELECT id FROM units WHERE nama = 'Terminal Petikemas' LIMIT 1),
    2,
    0,
    5,
    150,
    22,
    8,
    26400, -- 150 × 22 × 8
    75.76, -- (2 × 1000000) / 26400
    'Kecelakaan kerja ringan: 1 pekerja terluka akibat tersandung material, 1 pekerja tangan terjepit',
    'Penataan ulang area kerja, briefing keselamatan ditingkatkan, APD diperiksa rutin'
),
(
    '2025-02',
    (SELECT id FROM units WHERE nama = 'Terminal Petikemas' LIMIT 1),
    1,
    0,
    3,
    150,
    20,
    8,
    24000,
    41.67, -- (1 × 1000000) / 24000
    'Kecelakaan kerja: 1 pekerja terluka saat operasi crane',
    'Training ulang operator crane, inspeksi crane dijadwalkan rutin, safety briefing sebelum shift'
),
(
    '2025-01',
    (SELECT id FROM units WHERE nama = 'Terminal Curah Kering' LIMIT 1),
    0,
    0,
    2,
    80,
    22,
    8,
    14080,
    0.00,
    'Tidak ada kecelakaan, 2 near miss terkait material handling',
    'Evaluasi prosedur material handling, safety awareness campaign'
);

COMMENT ON TABLE ltifr_records IS 'Tabel untuk menyimpan data Lost Time Injury Frequency Rate (LTIFR)';
COMMENT ON COLUMN ltifr_records.periode_bulan IS 'Periode bulan dalam format YYYY-MM';
COMMENT ON COLUMN ltifr_records.jumlah_lti IS 'Jumlah Lost Time Injury (kecelakaan yang menyebabkan waktu kerja hilang)';
COMMENT ON COLUMN ltifr_records.jumlah_fatality IS 'Jumlah kecelakaan fatal (meninggal dunia)';
COMMENT ON COLUMN ltifr_records.jumlah_near_miss IS 'Jumlah kejadian nyaris celaka';
COMMENT ON COLUMN ltifr_records.total_jam_kerja IS 'Total jam kerja = jumlah_pekerja × hari_kerja × jam_kerja_per_hari';
COMMENT ON COLUMN ltifr_records.ltifr IS 'Lost Time Injury Frequency Rate = (jumlah_lti × 1.000.000) / total_jam_kerja';
