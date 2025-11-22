-- Drop existing table if any
DROP TABLE IF EXISTS safety_induction CASCADE;

-- Create Safety Induction table
CREATE TABLE safety_induction (
  -- ID & Identifikasi
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nomor_induction VARCHAR(50) UNIQUE NOT NULL,
  
  -- Data Peserta
  nama_peserta VARCHAR(255) NOT NULL,
  nik VARCHAR(50),
  no_identitas VARCHAR(50), -- KTP/Passport
  perusahaan VARCHAR(255) NOT NULL,
  jabatan VARCHAR(255),
  departemen VARCHAR(255),
  no_telepon VARCHAR(20),
  email VARCHAR(255),
  foto_peserta TEXT,
  
  -- Jenis Peserta
  jenis_peserta VARCHAR(50) DEFAULT 'karyawan_baru' CHECK (jenis_peserta IN (
    'karyawan_baru', 'karyawan_pindah', 'kontraktor', 'vendor', 
    'tamu', 'mahasiswa_pkl', 'tamu_vip'
  )),
  kategori_pekerjaan VARCHAR(50) CHECK (kategori_pekerjaan IN (
    'office', 'produksi', 'maintenance', 'operator', 'supervisor', 
    'manager', 'teknisi', 'driver', 'security', 'cleaning'
  )),
  
  -- Waktu & Lokasi
  tanggal_induction DATE NOT NULL,
  waktu_mulai TIME NOT NULL,
  waktu_selesai TIME,
  durasi_menit INTEGER,
  unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
  lokasi_induction VARCHAR(255) NOT NULL,
  ruangan VARCHAR(255),
  
  -- Instruktur & Penyelenggara
  instruktur_utama VARCHAR(255) NOT NULL,
  instruktur_pendamping VARCHAR(255)[],
  pic_hse UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  
  -- Materi Induction (Checklist)
  materi_kebijakan_k3 BOOLEAN DEFAULT false,
  materi_prosedur_emergency BOOLEAN DEFAULT false,
  materi_apd_wajib BOOLEAN DEFAULT false,
  materi_rambu_k3 BOOLEAN DEFAULT false,
  materi_identifikasi_bahaya BOOLEAN DEFAULT false,
  materi_pelaporan_insiden BOOLEAN DEFAULT false,
  materi_permit_to_work BOOLEAN DEFAULT false,
  materi_housekeeping BOOLEAN DEFAULT false,
  materi_chemical_safety BOOLEAN DEFAULT false,
  materi_working_at_height BOOLEAN DEFAULT false,
  materi_confined_space BOOLEAN DEFAULT false,
  materi_loto BOOLEAN DEFAULT false,
  materi_fire_safety BOOLEAN DEFAULT false,
  materi_first_aid BOOLEAN DEFAULT false,
  materi_ergonomi BOOLEAN DEFAULT false,
  
  -- Materi Kustom
  materi_tambahan JSONB, -- [{judul, durasi_menit, disampaikan}]
  
  -- Site Tour
  site_tour_dilakukan BOOLEAN DEFAULT false,
  area_dikunjungi TEXT[],
  durasi_tour_menit INTEGER,
  pemandu_tour VARCHAR(255),
  
  -- APD yang Diberikan
  apd_diberikan JSONB, -- [{jenis_apd, ukuran, jumlah, nomor_aset, tanggal_serah}]
  kartu_id_diberikan BOOLEAN DEFAULT false,
  nomor_kartu_id VARCHAR(50),
  akses_area TEXT[], -- daftar area yang boleh diakses
  
  -- Assessment/Ujian
  ujian_dilakukan BOOLEAN DEFAULT false,
  jenis_ujian VARCHAR(50) CHECK (jenis_ujian IN ('tertulis', 'lisan', 'praktek', 'online', 'campuran')),
  jumlah_soal INTEGER,
  skor_ujian INTEGER CHECK (skor_ujian BETWEEN 0 AND 100),
  passing_grade INTEGER DEFAULT 80,
  status_ujian VARCHAR(20) CHECK (status_ujian IN ('lulus', 'tidak_lulus', 'belum_ujian', 'remedial')),
  tanggal_ujian DATE,
  
  -- Sertifikat
  sertifikat_diterbitkan BOOLEAN DEFAULT false,
  nomor_sertifikat VARCHAR(50),
  tanggal_terbit_sertifikat DATE,
  masa_berlaku_bulan INTEGER DEFAULT 12,
  tanggal_expired DATE,
  file_sertifikat TEXT,
  
  -- Re-Induction
  perlu_reinduction BOOLEAN DEFAULT false,
  tanggal_reinduction_scheduled DATE,
  alasan_reinduction TEXT,
  
  -- Dokumentasi
  foto_kegiatan TEXT[],
  video_induction TEXT,
  materi_presentasi TEXT[],
  dokumen_pendukung TEXT[],
  
  -- Attendance & Signature
  waktu_hadir TIMESTAMP WITH TIME ZONE,
  tanda_tangan_peserta TEXT, -- signature image URL
  tanda_tangan_instruktur TEXT,
  tanda_tangan_pic_hse TEXT,
  
  -- Feedback & Evaluasi
  feedback_peserta TEXT,
  rating_materi INTEGER CHECK (rating_materi BETWEEN 1 AND 5),
  rating_instruktur INTEGER CHECK (rating_instruktur BETWEEN 1 AND 5),
  saran_peserta TEXT,
  
  -- Evaluasi Instruktur
  evaluasi_pemahaman VARCHAR(20) CHECK (evaluasi_pemahaman IN ('sangat_baik', 'baik', 'cukup', 'kurang')),
  evaluasi_keaktifan VARCHAR(20) CHECK (evaluasi_keaktifan IN ('sangat_aktif', 'aktif', 'cukup', 'pasif')),
  catatan_instruktur TEXT,
  rekomendasi_khusus TEXT,
  
  -- Follow-up
  follow_up_diperlukan BOOLEAN DEFAULT false,
  jenis_follow_up TEXT[], -- ['training_tambahan', 'mentoring', 'assessment_ulang', 'restricted_access']
  pic_follow_up VARCHAR(255),
  tanggal_follow_up DATE,
  status_follow_up VARCHAR(50) CHECK (status_follow_up IN ('pending', 'scheduled', 'completed', 'cancelled')),
  
  -- Status & Approval
  status VARCHAR(50) DEFAULT 'scheduled' CHECK (status IN (
    'scheduled', 'ongoing', 'completed', 'passed', 'failed', 
    'no_show', 'cancelled', 'rescheduled'
  )),
  approved_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  approved_at TIMESTAMP WITH TIME ZONE,
  approval_notes TEXT,
  
  -- Metadata
  created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_induction_tanggal ON safety_induction(tanggal_induction DESC);
CREATE INDEX idx_induction_unit ON safety_induction(unit_id);
CREATE INDEX idx_induction_status ON safety_induction(status);
CREATE INDEX idx_induction_jenis_peserta ON safety_induction(jenis_peserta);
CREATE INDEX idx_induction_nama_peserta ON safety_induction(nama_peserta);
CREATE INDEX idx_induction_perusahaan ON safety_induction(perusahaan);
CREATE INDEX idx_induction_nomor ON safety_induction(nomor_induction);
CREATE INDEX idx_induction_instruktur ON safety_induction(instruktur_utama);
CREATE INDEX idx_induction_expired ON safety_induction(tanggal_expired);
CREATE INDEX idx_induction_created_at ON safety_induction(created_at DESC);

-- Trigger
CREATE TRIGGER update_induction_updated_at
  BEFORE UPDATE ON safety_induction
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Constraints
ALTER TABLE safety_induction
  ADD CONSTRAINT check_waktu_valid 
  CHECK (waktu_selesai IS NULL OR waktu_selesai >= waktu_mulai);

ALTER TABLE safety_induction
  ADD CONSTRAINT check_durasi_valid 
  CHECK (durasi_menit IS NULL OR durasi_menit > 0);

ALTER TABLE safety_induction
  ADD CONSTRAINT check_skor_valid 
  CHECK (
    (ujian_dilakukan = false AND skor_ujian IS NULL) OR
    (ujian_dilakukan = true AND skor_ujian IS NOT NULL)
  );

ALTER TABLE safety_induction
  ADD CONSTRAINT check_expired_after_terbit
  CHECK (tanggal_expired IS NULL OR tanggal_terbit_sertifikat IS NULL OR tanggal_expired > tanggal_terbit_sertifikat);

-- Sample data
INSERT INTO safety_induction (
  nomor_induction,
  nama_peserta,
  nik,
  no_identitas,
  perusahaan,
  jabatan,
  departemen,
  no_telepon,
  email,
  jenis_peserta,
  kategori_pekerjaan,
  tanggal_induction,
  waktu_mulai,
  waktu_selesai,
  durasi_menit,
  unit_id,
  lokasi_induction,
  ruangan,
  instruktur_utama,
  instruktur_pendamping,
  materi_kebijakan_k3,
  materi_prosedur_emergency,
  materi_apd_wajib,
  materi_rambu_k3,
  materi_identifikasi_bahaya,
  materi_pelaporan_insiden,
  materi_permit_to_work,
  materi_housekeeping,
  materi_fire_safety,
  materi_first_aid,
  materi_tambahan,
  site_tour_dilakukan,
  area_dikunjungi,
  durasi_tour_menit,
  pemandu_tour,
  apd_diberikan,
  kartu_id_diberikan,
  nomor_kartu_id,
  akses_area,
  ujian_dilakukan,
  jenis_ujian,
  jumlah_soal,
  skor_ujian,
  passing_grade,
  status_ujian,
  tanggal_ujian,
  sertifikat_diterbitkan,
  nomor_sertifikat,
  tanggal_terbit_sertifikat,
  masa_berlaku_bulan,
  tanggal_expired,
  feedback_peserta,
  rating_materi,
  rating_instruktur,
  evaluasi_pemahaman,
  evaluasi_keaktifan,
  catatan_instruktur,
  status,
  waktu_hadir
) VALUES (
  'IND-2025-11-001',
  'Budi Santoso',
  'EMP-2025-001',
  '3578121234567890',
  'PT Petrokimia Gresik',
  'Operator Produksi',
  'Production',
  '081234567890',
  'budi.santoso@example.com',
  'karyawan_baru',
  'operator',
  '2025-11-22'::date,
  '08:00'::time,
  '12:00'::time,
  240,
  (SELECT id FROM units WHERE nama ILIKE '%gresik%' LIMIT 1),
  'Training Center Lantai 2',
  'Ruang Meeting A',
  'Ir. Ahmad HSE Manager',
  ARRAY['Siti HSE Officer', 'Joko Fire Safety'],
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  '[
    {
      "judul": "Bahaya Spesifik Area Produksi Pupuk",
      "durasi_menit": 30,
      "disampaikan": true
    },
    {
      "judul": "Prosedur Handling Ammonia",
      "durasi_menit": 45,
      "disampaikan": true
    }
  ]'::jsonb,
  true,
  ARRAY['Area Produksi NPK', 'Warehouse Pupuk', 'Control Room', 'Area Emergency Assembly'],
  60,
  'Joko Site Coordinator',
  '[
    {
      "jenis_apd": "Safety Helmet",
      "ukuran": "L",
      "jumlah": 1,
      "nomor_aset": "HLM-2025-001",
      "tanggal_serah": "2025-11-22"
    },
    {
      "jenis_apd": "Safety Shoes",
      "ukuran": "42",
      "jumlah": 1,
      "nomor_aset": "SHO-2025-001",
      "tanggal_serah": "2025-11-22"
    },
    {
      "jenis_apd": "Safety Glasses",
      "ukuran": "Standard",
      "jumlah": 1,
      "nomor_aset": "GLS-2025-001",
      "tanggal_serah": "2025-11-22"
    },
    {
      "jenis_apd": "Coverall",
      "ukuran": "L",
      "jumlah": 2,
      "nomor_aset": "COV-2025-001",
      "tanggal_serah": "2025-11-22"
    }
  ]'::jsonb,
  true,
  'ID-001-2025',
  ARRAY['Area Produksi NPK', 'Warehouse', 'Control Room', 'Canteen', 'Locker Room'],
  true,
  'tertulis',
  25,
  88,
  80,
  'lulus',
  '2025-11-22'::date,
  true,
  'CERT-IND-2025-001',
  '2025-11-22'::date,
  12,
  '2026-11-22'::date,
  'Materi sangat lengkap dan mudah dipahami. Instruktur menjelaskan dengan baik terutama tentang bahaya ammonia. Site tour sangat membantu untuk memahami layout pabrik.',
  5,
  5,
  'sangat_baik',
  'sangat_aktif',
  'Peserta sangat antusias dan aktif bertanya. Pemahaman tentang safety procedure sangat baik. Sudah siap bekerja di area produksi dengan pengawasan.',
  'passed',
  '2025-11-22 07:55:00+07'::timestamp with time zone
),
(
  'IND-2025-11-002',
  'PT Cahaya Konstruksi',
  'KONTRAKTOR-2025-002',
  '3578987654321098',
  'PT Cahaya Konstruksi',
  'Site Manager',
  'Construction',
  '082345678901',
  'site.manager@cahayakonstruksi.com',
  'kontraktor',
  'supervisor',
  '2025-11-22'::date,
  '13:00'::time,
  '16:00'::time,
  180,
  (SELECT id FROM units WHERE nama ILIKE '%gresik%' LIMIT 1),
  'Training Center Lantai 2',
  'Ruang Meeting B',
  'Ir. Ahmad HSE Manager',
  ARRAY['Siti HSE Officer'],
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  false,
  true,
  '[
    {
      "judul": "Prosedur Permit to Work untuk Kontraktor",
      "durasi_menit": 45,
      "disampaikan": true
    },
    {
      "judul": "Site Rules & Regulations",
      "durasi_menit": 30,
      "disampaikan": true
    }
  ]'::jsonb,
  true,
  ARRAY['Area Konstruksi Warehouse Baru', 'Site Office', 'Material Yard'],
  45,
  'Budi Site Coordinator',
  '[
    {
      "jenis_apd": "Safety Helmet",
      "ukuran": "M",
      "jumlah": 1,
      "nomor_aset": "HLM-CTR-001",
      "tanggal_serah": "2025-11-22"
    },
    {
      "jenis_apd": "Safety Vest (Orange)",
      "ukuran": "L",
      "jumlah": 1,
      "nomor_aset": "VST-CTR-001",
      "tanggal_serah": "2025-11-22"
    }
  ]'::jsonb,
  true,
  'CTR-001-2025',
  ARRAY['Area Konstruksi', 'Material Yard', 'Site Office', 'Toilet Area'],
  true,
  'tertulis',
  20,
  85,
  80,
  'lulus',
  '2025-11-22'::date,
  true,
  'CERT-CTR-2025-002',
  '2025-11-22'::date,
  6,
  '2026-05-22'::date,
  'Informasi permit to work sangat detail. Penting untuk koordinasi dengan HSE setiap hari.',
  4,
  5,
  'baik',
  'aktif',
  'Kontraktor berpengalaman, memahami safety procedure dengan baik. Diberikan akses terbatas ke area konstruksi saja.',
  'passed',
  '2025-11-22 12:50:00+07'::timestamp with time zone
),
(
  'IND-2025-11-003',
  'Rina Kusuma',
  'EMP-2025-002',
  '3578223344556677',
  'PT Petrokimia Gresik',
  'Admin HSE',
  'HSSE Department',
  '081345678902',
  'rina.kusuma@example.com',
  'karyawan_pindah',
  'office',
  '2025-11-23'::date,
  '09:00'::time,
  NULL,
  NULL,
  (SELECT id FROM units WHERE nama ILIKE '%gresik%' LIMIT 1),
  'Training Center Lantai 2',
  'Ruang Meeting A',
  'Siti HSE Officer',
  ARRAY[]::VARCHAR(255)[],
  true,
  true,
  true,
  true,
  true,
  true,
  false,
  true,
  true,
  true,
  NULL,
  false,
  NULL,
  NULL,
  NULL,
  NULL,
  false,
  NULL,
  NULL,
  true,
  'online',
  20,
  92,
  80,
  'lulus',
  '2025-11-23'::date,
  false,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'sangat_baik',
  'aktif',
  'Karyawan pindahan dari unit lain, sudah familiar dengan prosedur K3 dasar. Focus diberikan pada prosedur spesifik unit Gresik.',
  'completed',
  '2025-11-23 08:55:00+07'::timestamp with time zone
);
