-- =====================================================
-- HSSE Database Setup - Quick Setup (Fixed)
-- Run this in Supabase SQL Editor
-- =====================================================

-- Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Drop existing tables if they exist with wrong structure
DROP TABLE IF EXISTS silent_inspection CASCADE;
DROP TABLE IF EXISTS pegawai CASCADE;
DROP TABLE IF EXISTS units CASCADE;
DROP TABLE IF EXISTS wilayah CASCADE;

-- Create wilayah table
CREATE TABLE wilayah (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    kode VARCHAR(50) UNIQUE NOT NULL,
    nama VARCHAR(255) NOT NULL,
    regional VARCHAR(100),
    aktif BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create units table
CREATE TABLE units (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    kode VARCHAR(50) UNIQUE NOT NULL,
    nama VARCHAR(255) NOT NULL,
    tipe VARCHAR(50) CHECK (tipe IN ('unit', 'area', 'departemen', 'divisi')),
    wilayah_id UUID REFERENCES wilayah(id) ON DELETE SET NULL,
    area_id UUID,
    aktif BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create pegawai table
CREATE TABLE pegawai (
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

-- Create silent_inspection table with all required columns
CREATE TABLE silent_inspection (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tanggal DATE NOT NULL,
    waktu_mulai TIME,
    waktu_selesai TIME,
    triwulan INTEGER CHECK (triwulan BETWEEN 1 AND 4),
    tahun INTEGER,
    unit_id UUID REFERENCES units(id) ON DELETE CASCADE,
    wilayah_id UUID REFERENCES wilayah(id) ON DELETE CASCADE,
    inspector_id UUID REFERENCES pegawai(id) ON DELETE SET NULL,
    area_inspeksi VARCHAR(255) NOT NULL,
    kategori_bahaya VARCHAR(100),
    checklist JSONB,
    jumlah_temuan INTEGER DEFAULT 0,
    temuan_critical INTEGER DEFAULT 0,
    temuan_major INTEGER DEFAULT 0,
    temuan_minor INTEGER DEFAULT 0,
    deskripsi_temuan TEXT,
    foto_kondisi_unsafe TEXT[],
    foto_perilaku_unsafe TEXT[],
    skor_kepatuhan DECIMAL(5,2),
    tingkat_risiko VARCHAR(50),
    kondisi_housekeeping VARCHAR(100),
    penggunaan_apd VARCHAR(100),
    rekomendasi TEXT,
    tindakan_korektif TEXT,
    pic_tindak_lanjut VARCHAR(255),
    target_penyelesaian DATE,
    status_tindak_lanjut VARCHAR(50) DEFAULT 'open',
    status VARCHAR(50) DEFAULT 'draft' CHECK (status IN ('draft', 'approved', 'closed')),
    catatan TEXT,
    approved_by UUID REFERENCES pegawai(id),
    approved_at TIMESTAMP WITH TIME ZONE,
    closed_at TIMESTAMP WITH TIME ZONE,
    created_by UUID REFERENCES pegawai(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert wilayah data
INSERT INTO wilayah (kode, nama, regional, aktif) VALUES
  ('WIL-3', 'Wilayah 3', 'Regional 3', true)
ON CONFLICT (kode) DO NOTHING;

-- Insert area data
INSERT INTO units (kode, nama, tipe, wilayah_id, area_id, aktif) VALUES
  ('AREA-JAWA1', 'Area Jawa 1', 'area', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), NULL, true),
  ('AREA-KALIMANTAN3', 'Area Kalimantan 3', 'area', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), NULL, true),
  ('AREA-BALINUSRA', 'Area Bali Nusatenggara', 'area', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), NULL, true)
ON CONFLICT (kode) DO NOTHING;

-- Insert unit data
INSERT INTO units (kode, nama, tipe, wilayah_id, area_id, aktif) VALUES
  -- Area Jawa 1
  ('UNIT-TANJUNGPERAK', 'Tanjung Perak', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-JAWA1'), true),
  ('UNIT-GRESIK', 'Gresik', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-JAWA1'), true),
  ('UNIT-TANJUNGINTAN', 'Tanjung Intan', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-JAWA1'), true),

  -- Area Kalimantan 3
  ('UNIT-BANJARMASIN', 'Banjarmasin', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-KALIMANTAN3'), true),
  ('UNIT-KOTABARU', 'Kotabaru', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-KALIMANTAN3'), true),
  ('UNIT-MEKARPUTIH', 'Mekar Putih', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-KALIMANTAN3'), true),
  ('UNIT-BATULICIN', 'Batulicin', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-KALIMANTAN3'), true),
  ('UNIT-SATUI', 'Satui', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-KALIMANTAN3'), true),
  ('UNIT-BUNATI', 'Bunati', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-KALIMANTAN3'), true),
  ('UNIT-SAMPIT', 'Sampit', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-KALIMANTAN3'), true),
  ('UNIT-KUMAI', 'Kumai', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-KALIMANTAN3'), true),

  -- Area Bali Nusatenggara
  ('UNIT-BENOA', 'Benoa', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-BALINUSRA'), true),
  ('UNIT-CELUKANBAWANG', 'Celukan Bawang', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-BALINUSRA'), true),
  ('UNIT-LEMBAR', 'Lembar', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-BALINUSRA'), true),
  ('UNIT-TENAUKUPANG', 'Tenau Kupang', 'unit', (SELECT id FROM wilayah WHERE kode = 'WIL-3'), (SELECT id FROM units WHERE kode = 'AREA-BALINUSRA'), true)
ON CONFLICT (kode) DO NOTHING;

-- Insert demo inspector
INSERT INTO pegawai (nip, nama, email, jabatan, status) VALUES
  ('DEMO001', 'Safety Inspector Demo', 'demo@safety.local', 'Safety Inspector', 'aktif')
ON CONFLICT (nip) DO NOTHING;

-- Verify data insertion
SELECT 'Wilayah count:' as info, COUNT(*) as count FROM wilayah
UNION ALL
SELECT 'Units count:', COUNT(*) FROM units
UNION ALL
SELECT 'Pegawai count:', COUNT(*) FROM pegawai
UNION ALL
SELECT 'Silent Inspection count:', COUNT(*) FROM silent_inspection;