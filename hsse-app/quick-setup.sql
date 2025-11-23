-- =====================================================
-- HSSE Database Setup - Quick Setup
-- Run this in Supabase SQL Editor
-- =====================================================

-- Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create wilayah table
CREATE TABLE IF NOT EXISTS wilayah (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    kode VARCHAR(50) UNIQUE NOT NULL,
    nama VARCHAR(255) NOT NULL,
    regional VARCHAR(100),
    aktif BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create units table
CREATE TABLE IF NOT EXISTS units (
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

-- Verify data
SELECT
    u.kode,
    u.nama,
    u.tipe,
    w.nama as wilayah,
    a.nama as area
FROM units u
LEFT JOIN wilayah w ON u.wilayah_id = w.id
LEFT JOIN units a ON u.area_id = a.id
ORDER BY u.tipe DESC, w.nama, a.nama, u.nama;