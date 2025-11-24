-- =====================================================
-- HSSE Database - Targeted Diagnosis & Fix
-- Based on existing tables found in database
-- =====================================================

-- Step 1: Check silent_inspection table structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'silent_inspection'
ORDER BY ordinal_position;

-- Step 2: Check units table structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'units'
ORDER BY ordinal_position;

-- Step 3: Check wilayah table structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'wilayah'
ORDER BY ordinal_position;

-- Step 4: Check pegawai table structure (note: there's also master_pegawai)
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'pegawai'
ORDER BY ordinal_position;

-- Step 5: Check for missing columns in silent_inspection
-- Common missing columns based on our app requirements
DO $$
DECLARE
    missing_columns TEXT[] := ARRAY[
        'jumlah_temuan',
        'temuan_critical',
        'temuan_major',
        'temuan_minor',
        'area_inspeksi',
        'kategori_bahaya',
        'checklist',
        'deskripsi_temuan',
        'foto_kondisi_unsafe',
        'foto_perilaku_unsafe',
        'skor_kepatuhan',
        'tingkat_risiko',
        'kondisi_housekeeping',
        'penggunaan_apd',
        'rekomendasi',
        'tindakan_korektif',
        'pic_tindak_lanjut',
        'target_penyelesaian',
        'status_tindak_lanjut',
        'catatan',
        'approved_by',
        'approved_at',
        'closed_at',
        'created_by'
    ];
    col_name TEXT;
BEGIN
    FOREACH col_name IN ARRAY missing_columns
    LOOP
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_name = 'silent_inspection' AND column_name = col_name
        ) THEN
            RAISE NOTICE 'Missing column: %', col_name;
        END IF;
    END LOOP;
END $$;

-- Step 6: Add missing columns if needed (uncomment and modify as needed)
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS jumlah_temuan INTEGER DEFAULT 0;
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS temuan_critical INTEGER DEFAULT 0;
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS temuan_major INTEGER DEFAULT 0;
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS temuan_minor INTEGER DEFAULT 0;
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS area_inspeksi VARCHAR(255);
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS kategori_bahaya VARCHAR(100);
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS checklist JSONB;
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS deskripsi_temuan TEXT;
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS foto_kondisi_unsafe TEXT[];
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS foto_perilaku_unsafe TEXT[];
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS skor_kepatuhan DECIMAL(5,2);
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS tingkat_risiko VARCHAR(50);
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS kondisi_housekeeping VARCHAR(100);
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS penggunaan_apd VARCHAR(100);
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS rekomendasi TEXT;
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS tindakan_korektif TEXT;
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS pic_tindak_lanjut VARCHAR(255);
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS target_penyelesaian DATE;
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS status_tindak_lanjut VARCHAR(50) DEFAULT 'open';
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS catatan TEXT;
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS approved_by UUID REFERENCES pegawai(id);
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS approved_at TIMESTAMP WITH TIME ZONE;
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS closed_at TIMESTAMP WITH TIME ZONE;
-- ALTER TABLE silent_inspection ADD COLUMN IF NOT EXISTS created_by UUID REFERENCES pegawai(id);

-- Step 7: Check data in tables
SELECT 'wilayah count' as table_name, COUNT(*) as record_count FROM wilayah
UNION ALL
SELECT 'units count', COUNT(*) FROM units
UNION ALL
SELECT 'pegawai count', COUNT(*) FROM pegawai
UNION ALL
SELECT 'silent_inspection count', COUNT(*) FROM silent_inspection;