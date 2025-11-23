-- Check if pegawai table exists and create it if needed
-- Run this in Supabase SQL Editor

-- Check if pegawai table exists
SELECT EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_name = 'pegawai'
) as pegawai_table_exists;

-- If pegawai table doesn't exist, create it
CREATE TABLE IF NOT EXISTS pegawai (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nip VARCHAR(50) UNIQUE NOT NULL,
    nama VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    jabatan VARCHAR(255),
    unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
    wilayah_id UUID REFERENCES wilayah(id) ON DELETE SET NULL,
    status VARCHAR(50) DEFAULT 'aktif' CHECK (status IN ('aktif', 'nonaktif', 'resign')),
    foto_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Check the actual structure
SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'pegawai'
ORDER BY ordinal_position;
