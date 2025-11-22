-- Drop existing table if any
DROP TABLE IF EXISTS safety_patrol CASCADE;

-- Create Safety Patrol table
CREATE TABLE safety_patrol (
  -- ID & Identifikasi
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nomor_patrol VARCHAR(50) UNIQUE NOT NULL,
  
  -- Waktu & Lokasi
  tanggal_patrol DATE NOT NULL,
  waktu_mulai TIME NOT NULL,
  waktu_selesai TIME,
  shift VARCHAR(20) CHECK (shift IN ('pagi', 'siang', 'malam')),
  unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
  area_patrol VARCHAR(255) NOT NULL,
  lokasi_spesifik TEXT,
  
  -- Tim Patrol
  ketua_patrol VARCHAR(255) NOT NULL,
  anggota_patrol TEXT[],
  jumlah_anggota INTEGER DEFAULT 0,
  
  -- Jenis & Tujuan Patrol
  jenis_patrol VARCHAR(50) DEFAULT 'rutin' CHECK (jenis_patrol IN ('rutin', 'terjadwal', 'insidental', 'khusus', 'malam', 'emergency')),
  tujuan_patrol TEXT,
  fokus_patrol TEXT[], -- housekeeping, APD, mesin, perilaku, dll
  
  -- Observasi Kondisi
  cuaca VARCHAR(20) CHECK (cuaca IN ('cerah', 'mendung', 'hujan', 'panas')),
  suhu_area DECIMAL(5,2),
  kondisi_pencahayaan VARCHAR(20) CHECK (kondisi_pencahayaan IN ('baik', 'cukup', 'kurang', 'buruk')),
  kondisi_ventilasi VARCHAR(20) CHECK (kondisi_ventilasi IN ('baik', 'cukup', 'kurang', 'buruk')),
  tingkat_kebisingan VARCHAR(20) CHECK (tingkat_kebisingan IN ('normal', 'cukup_bising', 'bising', 'sangat_bising')),
  
  -- Unsafe Condition (Kondisi Tidak Aman)
  jumlah_unsafe_condition INTEGER DEFAULT 0,
  unsafe_condition JSONB, -- [{no, kategori, deskripsi, lokasi, tingkat_risiko, foto_urls, tindakan}]
  
  -- Unsafe Act (Tindakan Tidak Aman)
  jumlah_unsafe_act INTEGER DEFAULT 0,
  unsafe_act JSONB, -- [{no, deskripsi, pekerja, lokasi, tingkat_risiko, tindakan_langsung}]
  
  -- Kepatuhan APD
  pekerja_diamati INTEGER DEFAULT 0,
  pekerja_patuh_apd INTEGER DEFAULT 0,
  pekerja_tidak_patuh_apd INTEGER DEFAULT 0,
  persentase_kepatuhan_apd INTEGER CHECK (persentase_kepatuhan_apd BETWEEN 0 AND 100),
  detail_apd JSONB, -- [{jenis_apd, wajib, patuh, tidak_patuh}]
  
  -- Housekeeping
  skor_housekeeping INTEGER CHECK (skor_housekeeping BETWEEN 0 AND 100),
  kondisi_housekeeping VARCHAR(20) CHECK (kondisi_housekeeping IN ('sangat_baik', 'baik', 'cukup', 'kurang', 'buruk')),
  area_kotor TEXT[],
  area_rapi TEXT[],
  
  -- Peralatan & Mesin
  jumlah_mesin_diperiksa INTEGER DEFAULT 0,
  mesin_kondisi_baik INTEGER DEFAULT 0,
  mesin_perlu_perbaikan INTEGER DEFAULT 0,
  detail_mesin JSONB, -- [{nama_mesin, lokasi, kondisi, masalah, status}]
  
  -- Rambu & Label
  rambu_k3_lengkap BOOLEAN DEFAULT true,
  rambu_k3_hilang TEXT[],
  rambu_k3_rusak TEXT[],
  label_b3_lengkap BOOLEAN DEFAULT true,
  
  -- Jalur Evakuasi & Emergency
  jalur_evakuasi_bebas BOOLEAN DEFAULT true,
  pintu_darurat_berfungsi BOOLEAN DEFAULT true,
  apar_tersedia BOOLEAN DEFAULT true,
  apar_expire INTEGER DEFAULT 0,
  emergency_light_berfungsi BOOLEAN DEFAULT true,
  
  -- Temuan Positif
  good_practice TEXT[],
  area_excellent TEXT[],
  pekerja_teladan VARCHAR(255)[],
  
  -- Temuan & Rekomendasi
  total_temuan INTEGER DEFAULT 0,
  temuan_kritikal INTEGER DEFAULT 0,
  temuan_mayor INTEGER DEFAULT 0,
  temuan_minor INTEGER DEFAULT 0,
  rekomendasi TEXT[],
  catatan_patrol TEXT,
  
  -- Tindak Lanjut (Action Items)
  action_items JSONB, -- [{no, temuan, tindakan, pic, target_date, prioritas, status}]
  jumlah_action_item INTEGER DEFAULT 0,
  action_selesai INTEGER DEFAULT 0,
  action_progress INTEGER DEFAULT 0,
  action_belum_mulai INTEGER DEFAULT 0,
  
  -- Stop Work Authority
  stop_work_issued BOOLEAN DEFAULT false,
  stop_work_area TEXT[],
  stop_work_alasan TEXT,
  
  -- Dokumentasi
  foto_patrol TEXT[],
  dokumen_pendukung TEXT[],
  
  -- Scoring
  skor_keseluruhan INTEGER CHECK (skor_keseluruhan BETWEEN 0 AND 100),
  skor_apd INTEGER CHECK (skor_apd BETWEEN 0 AND 100),
  skor_kondisi_area INTEGER CHECK (skor_kondisi_area BETWEEN 0 AND 100),
  skor_peralatan INTEGER CHECK (skor_peralatan BETWEEN 0 AND 100),
  grade VARCHAR(2) CHECK (grade IN ('A', 'B', 'C', 'D', 'E')),
  
  -- Status & Follow-up
  status VARCHAR(50) DEFAULT 'draft' CHECK (status IN ('draft', 'submitted', 'reviewed', 'closed', 'cancelled')),
  tingkat_urgensi VARCHAR(20) DEFAULT 'normal' CHECK (tingkat_urgensi IN ('rendah', 'normal', 'tinggi', 'kritis')),
  perlu_follow_up BOOLEAN DEFAULT false,
  tanggal_follow_up DATE,
  status_follow_up VARCHAR(50) CHECK (status_follow_up IN ('belum', 'dijadwalkan', 'selesai')),
  
  -- Approval
  reviewed_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  reviewed_at TIMESTAMP WITH TIME ZONE,
  review_notes TEXT,
  
  -- Metadata
  created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_patrol_tanggal ON safety_patrol(tanggal_patrol DESC);
CREATE INDEX idx_patrol_unit ON safety_patrol(unit_id);
CREATE INDEX idx_patrol_status ON safety_patrol(status);
CREATE INDEX idx_patrol_jenis ON safety_patrol(jenis_patrol);
CREATE INDEX idx_patrol_ketua ON safety_patrol(ketua_patrol);
CREATE INDEX idx_patrol_created_at ON safety_patrol(created_at DESC);
CREATE INDEX idx_patrol_nomor ON safety_patrol(nomor_patrol);
CREATE INDEX idx_patrol_urgensi ON safety_patrol(tingkat_urgensi);
CREATE INDEX idx_patrol_shift ON safety_patrol(shift);

-- Trigger
CREATE TRIGGER update_patrol_updated_at
  BEFORE UPDATE ON safety_patrol
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Constraints
ALTER TABLE safety_patrol
  ADD CONSTRAINT check_waktu_valid 
  CHECK (waktu_selesai IS NULL OR waktu_selesai >= waktu_mulai);

ALTER TABLE safety_patrol
  ADD CONSTRAINT check_jumlah_anggota 
  CHECK (jumlah_anggota >= 0);

ALTER TABLE safety_patrol
  ADD CONSTRAINT check_unsafe_counts
  CHECK (
    jumlah_unsafe_condition >= 0 AND
    jumlah_unsafe_act >= 0 AND
    total_temuan >= 0
  );

ALTER TABLE safety_patrol
  ADD CONSTRAINT check_apd_counts
  CHECK (
    pekerja_diamati >= 0 AND
    pekerja_patuh_apd >= 0 AND
    pekerja_tidak_patuh_apd >= 0 AND
    (pekerja_patuh_apd + pekerja_tidak_patuh_apd) <= pekerja_diamati
  );

ALTER TABLE safety_patrol
  ADD CONSTRAINT check_action_counts
  CHECK (
    jumlah_action_item >= 0 AND
    action_selesai >= 0 AND
    action_progress >= 0 AND
    action_belum_mulai >= 0 AND
    (action_selesai + action_progress + action_belum_mulai) <= jumlah_action_item
  );

ALTER TABLE safety_patrol
  ADD CONSTRAINT check_temuan_klasifikasi
  CHECK (
    temuan_kritikal >= 0 AND
    temuan_mayor >= 0 AND
    temuan_minor >= 0 AND
    (temuan_kritikal + temuan_mayor + temuan_minor) <= total_temuan
  );

ALTER TABLE safety_patrol
  ADD CONSTRAINT check_mesin_counts
  CHECK (
    jumlah_mesin_diperiksa >= 0 AND
    mesin_kondisi_baik >= 0 AND
    mesin_perlu_perbaikan >= 0 AND
    (mesin_kondisi_baik + mesin_perlu_perbaikan) <= jumlah_mesin_diperiksa
  );

-- Sample data
INSERT INTO safety_patrol (
  nomor_patrol,
  tanggal_patrol,
  waktu_mulai,
  waktu_selesai,
  shift,
  unit_id,
  area_patrol,
  ketua_patrol,
  anggota_patrol,
  jumlah_anggota,
  jenis_patrol,
  fokus_patrol,
  cuaca,
  kondisi_pencahayaan,
  kondisi_ventilasi,
  jumlah_unsafe_condition,
  unsafe_condition,
  jumlah_unsafe_act,
  unsafe_act,
  pekerja_diamati,
  pekerja_patuh_apd,
  pekerja_tidak_patuh_apd,
  persentase_kepatuhan_apd,
  skor_housekeeping,
  kondisi_housekeeping,
  jalur_evakuasi_bebas,
  pintu_darurat_berfungsi,
  apar_tersedia,
  total_temuan,
  temuan_kritikal,
  temuan_mayor,
  temuan_minor,
  rekomendasi,
  action_items,
  jumlah_action_item,
  action_belum_mulai,
  skor_keseluruhan,
  skor_apd,
  skor_kondisi_area,
  skor_peralatan,
  grade,
  status,
  tingkat_urgensi,
  perlu_follow_up
) VALUES (
  'SP-2025-11-001',
  '2025-11-22'::date,
  '08:00'::time,
  '10:00'::time,
  'pagi',
  (SELECT id FROM units WHERE nama ILIKE '%gresik%' LIMIT 1),
  'Area Produksi & Warehouse',
  'Ahmad Safety Officer',
  ARRAY['Budi HSE', 'Siti Supervisor', 'Joko Teknisi'],
  4,
  'rutin',
  ARRAY['housekeeping', 'APD', 'unsafe_condition', 'emergency'],
  'cerah',
  'baik',
  'cukup',
  5,
  '[
    {
      "no": 1,
      "kategori": "housekeeping",
      "deskripsi": "Material berserakan di jalur lalu lintas forklift",
      "lokasi": "Warehouse Section A",
      "tingkat_risiko": "tinggi",
      "foto_urls": [],
      "tindakan": "Rapikan dan buat line marking yang jelas"
    },
    {
      "no": 2,
      "kategori": "mekanik",
      "deskripsi": "Guard mesin conveyor lepas",
      "lokasi": "Line Produksi 1",
      "tingkat_risiko": "kritikal",
      "foto_urls": [],
      "tindakan": "Stop work, pasang guard, inspeksi semua mesin"
    },
    {
      "no": 3,
      "kategori": "elektrik",
      "deskripsi": "Kabel listrik terbuka tanpa proteksi",
      "lokasi": "Area Maintenance",
      "tingkat_risiko": "tinggi",
      "foto_urls": [],
      "tindakan": "Isolasi kabel, pasang cable tray"
    },
    {
      "no": 4,
      "kategori": "ergonomi",
      "deskripsi": "Tidak ada alat bantu untuk manual lifting beban >25kg",
      "lokasi": "Loading Bay",
      "tingkat_risiko": "sedang",
      "foto_urls": [],
      "tindakan": "Sediakan trolley dan hand pallet"
    },
    {
      "no": 5,
      "kategori": "emergency",
      "deskripsi": "1 unit APAR sudah expired",
      "lokasi": "Kantor Lantai 2",
      "tingkat_risiko": "sedang",
      "foto_urls": [],
      "tindakan": "Ganti APAR dengan yang baru, update sticker"
    }
  ]'::jsonb,
  3,
  '[
    {
      "no": 1,
      "deskripsi": "Pekerja tidak menggunakan safety shoes",
      "pekerja": "2 orang operator produksi",
      "lokasi": "Line Produksi 2",
      "tingkat_risiko": "tinggi",
      "tindakan_langsung": "Teguran verbal, diminta pakai safety shoes"
    },
    {
      "no": 2,
      "deskripsi": "Operator forklift berkendara melebihi kecepatan yang diizinkan",
      "pekerja": "Driver forklift",
      "lokasi": "Warehouse",
      "tingkat_risiko": "tinggi",
      "tindakan_langsung": "Teguran, reminder speed limit 10km/h"
    },
    {
      "no": 3,
      "deskripsi": "Pekerja tidak menggunakan harness saat bekerja di ketinggian",
      "pekerja": "Teknisi maintenance",
      "lokasi": "Area atas conveyor",
      "tingkat_risiko": "kritikal",
      "tindakan_langsung": "Stop work immediately, wajibkan harness"
    }
  ]'::jsonb,
  25,
  20,
  5,
  80,
  75,
  'cukup',
  true,
  true,
  true,
  8,
  1,
  3,
  4,
  ARRAY[
    'Perkuat enforcement penggunaan APD wajib',
    'Training ulang work at height untuk semua teknisi',
    'Lakukan preventive maintenance guard mesin secara berkala',
    'Tambah rambu speed limit di area warehouse',
    'Implementasi program 5S di semua area'
  ],
  '[
    {
      "no": 1,
      "temuan": "Guard mesin conveyor lepas (CRITICAL)",
      "tindakan": "Pasang kembali guard, inspeksi semua guard mesin",
      "pic": "Supervisor Maintenance",
      "target_date": "2025-11-22",
      "prioritas": "kritikal",
      "status": "belum_mulai"
    },
    {
      "no": 2,
      "temuan": "Pekerja tidak pakai harness di ketinggian",
      "tindakan": "Training work at height dan enforcement harness",
      "pic": "HSE Coordinator",
      "target_date": "2025-11-25",
      "prioritas": "tinggi",
      "status": "belum_mulai"
    },
    {
      "no": 3,
      "temuan": "Material berserakan di jalur forklift",
      "tindakan": "5S activity dan marking ulang jalur",
      "pic": "Supervisor Warehouse",
      "target_date": "2025-11-23",
      "prioritas": "tinggi",
      "status": "belum_mulai"
    },
    {
      "no": 4,
      "temuan": "Kabel listrik terbuka",
      "tindakan": "Isolasi kabel dan pasang cable tray",
      "pic": "Teknisi Elektrik",
      "target_date": "2025-11-24",
      "prioritas": "tinggi",
      "status": "belum_mulai"
    },
    {
      "no": 5,
      "temuan": "APAR expired",
      "tindakan": "Ganti APAR baru dan update log pemeriksaan",
      "pic": "HSE Admin",
      "target_date": "2025-11-23",
      "prioritas": "sedang",
      "status": "belum_mulai"
    },
    {
      "no": 6,
      "temuan": "Pekerja tidak pakai safety shoes",
      "tindakan": "Sosialisasi ulang peraturan APD dan sanksi",
      "pic": "Supervisor Produksi",
      "target_date": "2025-11-25",
      "prioritas": "sedang",
      "status": "belum_mulai"
    },
    {
      "no": 7,
      "temuan": "Forklift melebihi speed limit",
      "tindakan": "Pasang rambu speed limit tambahan",
      "pic": "Supervisor Warehouse",
      "target_date": "2025-11-26",
      "prioritas": "sedang",
      "status": "belum_mulai"
    },
    {
      "no": 8,
      "temuan": "Tidak ada alat bantu manual handling",
      "tindakan": "Procurement trolley dan hand pallet",
      "pic": "Dept. Logistik",
      "target_date": "2025-12-01",
      "prioritas": "sedang",
      "status": "belum_mulai"
    }
  ]'::jsonb,
  8,
  8,
  72,
  80,
  70,
  75,
  'C',
  'submitted',
  'tinggi',
  true
);
