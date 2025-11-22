-- Create Safety Briefing Table
-- Run this in Supabase SQL Editor

-- 0. Create update function (if not exists)
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 1. Create table
CREATE TABLE IF NOT EXISTS safety_briefing (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tanggal DATE NOT NULL,
    waktu_mulai TIME NOT NULL,
    waktu_selesai TIME,
    unit_id UUID,
    petugas_id UUID,
    topik VARCHAR(500) NOT NULL,
    materi TEXT,
    jumlah_peserta INTEGER DEFAULT 0,
    daftar_peserta TEXT[], -- Array of participant names
    foto_dokumentasi TEXT[], -- Array of photo URLs
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'approved', 'rejected')),
    catatan TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT fk_safety_briefing_unit FOREIGN KEY (unit_id) REFERENCES units(id) ON DELETE SET NULL,
    CONSTRAINT fk_safety_briefing_petugas FOREIGN KEY (petugas_id) REFERENCES pegawai(id) ON DELETE SET NULL
);

-- 2. Create indexes
CREATE INDEX IF NOT EXISTS idx_safety_briefing_tanggal ON safety_briefing(tanggal);
CREATE INDEX IF NOT EXISTS idx_safety_briefing_unit ON safety_briefing(unit_id);
CREATE INDEX IF NOT EXISTS idx_safety_briefing_petugas ON safety_briefing(petugas_id);
CREATE INDEX IF NOT EXISTS idx_safety_briefing_status ON safety_briefing(status);
CREATE INDEX IF NOT EXISTS idx_safety_briefing_created_at ON safety_briefing(created_at);

-- 3. Create trigger for updated_at
DROP TRIGGER IF EXISTS set_updated_at_safety_briefing ON safety_briefing;

CREATE TRIGGER set_updated_at_safety_briefing
    BEFORE UPDATE ON safety_briefing
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 4. Enable RLS
ALTER TABLE safety_briefing ENABLE ROW LEVEL SECURITY;

-- 5. Create RLS policies
DROP POLICY IF EXISTS "Allow authenticated users to read safety_briefing" ON safety_briefing;
CREATE POLICY "Allow authenticated users to read safety_briefing"
    ON safety_briefing FOR SELECT
    TO authenticated
    USING (true);

DROP POLICY IF EXISTS "Allow authenticated users to insert safety_briefing" ON safety_briefing;
CREATE POLICY "Allow authenticated users to insert safety_briefing"
    ON safety_briefing FOR INSERT
    TO authenticated
    WITH CHECK (true);

DROP POLICY IF EXISTS "Allow authenticated users to update safety_briefing" ON safety_briefing;
CREATE POLICY "Allow authenticated users to update safety_briefing"
    ON safety_briefing FOR UPDATE
    TO authenticated
    USING (true)
    WITH CHECK (true);

DROP POLICY IF EXISTS "Allow authenticated users to delete safety_briefing" ON safety_briefing;
CREATE POLICY "Allow authenticated users to delete safety_briefing"
    ON safety_briefing FOR DELETE
    TO authenticated
    USING (true);

-- 6. Create storage bucket for photos (Run this separately in SQL or via Dashboard)
-- Note: This needs to be done through Supabase Dashboard > Storage
-- Bucket name: safety-briefing-photos
-- Public: Yes (or handle authentication in policies)

-- 7. Insert sample data (optional)
INSERT INTO safety_briefing (
    tanggal,
    waktu_mulai,
    waktu_selesai,
    unit_id,
    topik,
    materi,
    jumlah_peserta,
    status
) VALUES (
    CURRENT_DATE,
    '08:00:00',
    '08:30:00',
    (SELECT id FROM units WHERE kode = 'UNIT-TANJUNGPERAK' LIMIT 1),
    'Bahaya Listrik di Area Kerja',
    'Penjelasan mengenai bahaya listrik, cara pencegahan, dan prosedur keselamatan saat bekerja di area yang memiliki instalasi listrik.',
    25,
    'approved'
),
(
    CURRENT_DATE - INTERVAL '1 day',
    '07:30:00',
    '08:00:00',
    (SELECT id FROM units WHERE kode = 'UNIT-GRESIK' LIMIT 1),
    'Penggunaan APD yang Benar',
    'Panduan lengkap penggunaan Alat Pelindung Diri (APD) sesuai standar K3.',
    18,
    'approved'
),
(
    CURRENT_DATE - INTERVAL '2 days',
    '08:00:00',
    NULL,
    (SELECT id FROM units WHERE kode = 'UNIT-BANJARMASIN' LIMIT 1),
    'Prosedur Evakuasi Darurat',
    'Simulasi dan penjelasan prosedur evakuasi saat terjadi keadaan darurat.',
    32,
    'draft'
);

-- 8. Verification query
SELECT 
    sb.id,
    sb.tanggal,
    sb.waktu_mulai,
    sb.topik,
    u.nama as unit_nama,
    p.nama as petugas_nama,
    sb.jumlah_peserta,
    sb.status,
    COALESCE(array_length(sb.foto_dokumentasi, 1), 0) as jumlah_foto
FROM safety_briefing sb
LEFT JOIN units u ON sb.unit_id = u.id
LEFT JOIN pegawai p ON sb.petugas_id = p.id
ORDER BY sb.tanggal DESC, sb.waktu_mulai DESC
LIMIT 10;
