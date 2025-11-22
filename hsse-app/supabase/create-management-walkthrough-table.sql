-- Create Management Walkthrough table
-- Management Walkthrough adalah inspeksi keselamatan yang dilakukan oleh manajemen
-- dengan observasi langsung di lapangan untuk identifikasi bahaya dan interaksi dengan pekerja

CREATE TABLE IF NOT EXISTS management_walkthrough (
  -- ID & Identifikasi
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nomor_walkthrough VARCHAR(50) UNIQUE NOT NULL, -- Format: MW-2024-11-001
  
  -- Waktu & Lokasi
  tanggal_walkthrough DATE NOT NULL,
  waktu_mulai TIME NOT NULL,
  waktu_selesai TIME,
  unit_id UUID REFERENCES units(id) ON DELETE SET NULL,
  area_inspeksi VARCHAR(255) NOT NULL, -- Area/lokasi yang diinspeksi
  departemen VARCHAR(255), -- Departemen yang diinspeksi
  
  -- Tim Inspeksi
  pimpinan_walkthrough VARCHAR(255) NOT NULL, -- Manager/Supervisor yang memimpin
  anggota_tim TEXT[], -- Array nama anggota tim
  jumlah_tim INTEGER DEFAULT 0,
  
  -- Tujuan & Fokus
  tujuan_walkthrough TEXT, -- Tujuan dari walkthrough ini
  fokus_area TEXT[], -- Area fokus: housekeeping, PPE, ergonomi, dll
  jenis_walkthrough VARCHAR(50) DEFAULT 'rutin' CHECK (jenis_walkthrough IN ('rutin', 'terjadwal', 'insidental', 'follow_up', 'khusus')),
  
  -- Observasi Kondisi Fisik
  kondisi_housekeeping VARCHAR(20) CHECK (kondisi_housekeeping IN ('baik', 'cukup', 'kurang', 'buruk')),
  kondisi_pencahayaan VARCHAR(20) CHECK (kondisi_pencahayaan IN ('baik', 'cukup', 'kurang', 'buruk')),
  kondisi_ventilasi VARCHAR(20) CHECK (kondisi_ventilasi IN ('baik', 'cukup', 'kurang', 'buruk')),
  kondisi_akses_jalan VARCHAR(20) CHECK (kondisi_akses_jalan IN ('baik', 'cukup', 'kurang', 'buruk')),
  
  -- Observasi APD
  kepatuhan_apd INTEGER CHECK (kepatuhan_apd BETWEEN 0 AND 100), -- Persentase kepatuhan APD
  apd_tersedia BOOLEAN DEFAULT true,
  apd_kondisi_baik BOOLEAN DEFAULT true,
  apd_digunakan_benar BOOLEAN DEFAULT true,
  apd_tidak_sesuai TEXT[], -- Daftar APD yang tidak sesuai/tidak digunakan
  
  -- Observasi Perilaku Kerja
  pekerja_diamati INTEGER DEFAULT 0, -- Jumlah pekerja yang diamati
  perilaku_aman INTEGER DEFAULT 0, -- Jumlah perilaku aman yang diamati
  perilaku_tidak_aman INTEGER DEFAULT 0, -- Jumlah perilaku tidak aman
  perilaku_tidak_aman_detail JSONB, -- Detail perilaku tidak aman: [{pekerja, perilaku, lokasi, tindakan}]
  
  -- Interaksi dengan Pekerja
  jumlah_pekerja_diwawancara INTEGER DEFAULT 0,
  feedback_pekerja TEXT[], -- Feedback/keluhan dari pekerja
  saran_pekerja TEXT[], -- Saran dari pekerja
  pekerja_aware_prosedur BOOLEAN DEFAULT true, -- Pekerja paham prosedur K3
  
  -- Temuan Bahaya (Hazard Identification)
  jumlah_temuan INTEGER DEFAULT 0,
  temuan_bahaya JSONB, -- Array of: [{no, kategori, deskripsi, lokasi, tingkat_risiko, foto_url, status}]
  -- Kategori: fisik, mekanik, elektrik, kimia, ergonomi, biological, psikososial
  
  -- Klasifikasi Temuan
  temuan_kritis INTEGER DEFAULT 0, -- Risiko tinggi, perlu tindakan segera
  temuan_mayor INTEGER DEFAULT 0, -- Risiko sedang-tinggi
  temuan_minor INTEGER DEFAULT 0, -- Risiko rendah
  temuan_observasi INTEGER DEFAULT 0, -- Opportunity for improvement
  
  -- Pelanggaran & Non-Compliance
  pelanggaran_prosedur TEXT[], -- Daftar prosedur yang dilanggar
  pelanggaran_peraturan TEXT[], -- Daftar peraturan yang dilanggar
  area_non_compliance TEXT[], -- Area yang tidak compliant
  
  -- Positive Findings
  praktek_baik TEXT[], -- Good practices yang ditemukan
  area_excellent TEXT[], -- Area dengan kondisi sangat baik
  pekerja_teladan VARCHAR(255)[], -- Pekerja dengan perilaku K3 teladan
  
  -- Corrective Actions
  action_items JSONB, -- Array of: [{no, temuan, tindakan, pic, target, prioritas, status, catatan}]
  jumlah_action_item INTEGER DEFAULT 0,
  action_selesai INTEGER DEFAULT 0,
  action_progress INTEGER DEFAULT 0,
  action_belum_mulai INTEGER DEFAULT 0,
  
  -- Immediate Actions
  tindakan_segera TEXT[], -- Tindakan yang dilakukan saat itu juga
  area_ditutup TEXT[], -- Area yang ditutup/di-barrier sementara
  pekerjaan_dihentikan TEXT[], -- Pekerjaan yang dihentikan
  
  -- Dokumentasi
  foto_walkthrough TEXT[], -- Array URL foto temuan
  dokumen_pendukung TEXT[], -- Array URL dokumen pendukung
  sketsa_lokasi_url VARCHAR(500), -- URL sketsa/map area inspeksi
  video_url VARCHAR(500), -- URL video walkthrough
  
  -- Ringkasan & Rekomendasi
  ringkasan_observasi TEXT, -- Summary hasil walkthrough
  rekomendasi TEXT[], -- Rekomendasi untuk improvement
  catatan_khusus TEXT, -- Catatan penting
  
  -- Status & Follow-up
  status VARCHAR(50) DEFAULT 'draft' CHECK (status IN ('draft', 'in_progress', 'completed', 'cancelled')),
  tingkat_urgensi VARCHAR(20) DEFAULT 'normal' CHECK (tingkat_urgensi IN ('rendah', 'normal', 'tinggi', 'kritis')),
  perlu_follow_up BOOLEAN DEFAULT false,
  tanggal_follow_up DATE,
  status_follow_up VARCHAR(50) CHECK (status_follow_up IN ('belum', 'terjadwal', 'selesai', 'tidak_perlu')),
  
  -- Rating & Score
  skor_keseluruhan INTEGER CHECK (skor_keseluruhan BETWEEN 0 AND 100), -- Overall safety score
  skor_housekeeping INTEGER CHECK (skor_housekeeping BETWEEN 0 AND 100),
  skor_apd INTEGER CHECK (skor_apd BETWEEN 0 AND 100),
  skor_perilaku INTEGER CHECK (skor_perilaku BETWEEN 0 AND 100),
  
  -- Metadata
  created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  approved_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  approved_at TIMESTAMP WITH TIME ZONE
);

-- Indexes for better query performance
CREATE INDEX idx_walkthrough_tanggal ON management_walkthrough(tanggal_walkthrough DESC);
CREATE INDEX idx_walkthrough_unit ON management_walkthrough(unit_id);
CREATE INDEX idx_walkthrough_status ON management_walkthrough(status);
CREATE INDEX idx_walkthrough_jenis ON management_walkthrough(jenis_walkthrough);
CREATE INDEX idx_walkthrough_pimpinan ON management_walkthrough(pimpinan_walkthrough);
CREATE INDEX idx_walkthrough_created_at ON management_walkthrough(created_at DESC);
CREATE INDEX idx_walkthrough_nomor ON management_walkthrough(nomor_walkthrough);
CREATE INDEX idx_walkthrough_urgensi ON management_walkthrough(tingkat_urgensi);

-- Triggers for updated_at
CREATE TRIGGER update_walkthrough_updated_at
  BEFORE UPDATE ON management_walkthrough
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Check constraints
ALTER TABLE management_walkthrough
  ADD CONSTRAINT check_waktu_valid 
  CHECK (waktu_selesai IS NULL OR waktu_selesai >= waktu_mulai);

ALTER TABLE management_walkthrough
  ADD CONSTRAINT check_jumlah_tim 
  CHECK (jumlah_tim >= 0);

ALTER TABLE management_walkthrough
  ADD CONSTRAINT check_pekerja_diamati 
  CHECK (pekerja_diamati >= 0);

ALTER TABLE management_walkthrough
  ADD CONSTRAINT check_jumlah_temuan 
  CHECK (jumlah_temuan >= 0);

ALTER TABLE management_walkthrough
  ADD CONSTRAINT check_action_counts
  CHECK (
    jumlah_action_item >= 0 AND
    action_selesai >= 0 AND
    action_progress >= 0 AND
    action_belum_mulai >= 0 AND
    (action_selesai + action_progress + action_belum_mulai) <= jumlah_action_item
  );

ALTER TABLE management_walkthrough
  ADD CONSTRAINT check_temuan_klasifikasi
  CHECK (
    temuan_kritis >= 0 AND
    temuan_mayor >= 0 AND
    temuan_minor >= 0 AND
    temuan_observasi >= 0 AND
    (temuan_kritis + temuan_mayor + temuan_minor + temuan_observasi) <= jumlah_temuan
  );

-- Comments
COMMENT ON TABLE management_walkthrough IS 'Management Walkthrough - Inspeksi keselamatan lapangan oleh manajemen';
COMMENT ON COLUMN management_walkthrough.nomor_walkthrough IS 'Nomor unik walkthrough format MW-YYYY-MM-XXX';
COMMENT ON COLUMN management_walkthrough.jenis_walkthrough IS 'Tipe walkthrough: rutin, terjadwal, insidental, follow_up, khusus';
COMMENT ON COLUMN management_walkthrough.perilaku_tidak_aman_detail IS 'Detail observasi perilaku tidak aman dalam format JSONB';
COMMENT ON COLUMN management_walkthrough.temuan_bahaya IS 'Detail temuan bahaya dengan kategori, risiko, dan foto';
COMMENT ON COLUMN management_walkthrough.action_items IS 'Tindak lanjut hasil walkthrough dengan tracking status';

-- Sample data
INSERT INTO management_walkthrough (
  nomor_walkthrough,
  tanggal_walkthrough,
  waktu_mulai,
  waktu_selesai,
  unit_id,
  area_inspeksi,
  departemen,
  pimpinan_walkthrough,
  anggota_tim,
  jumlah_tim,
  tujuan_walkthrough,
  fokus_area,
  jenis_walkthrough,
  kondisi_housekeeping,
  kondisi_pencahayaan,
  kondisi_ventilasi,
  kondisi_akses_jalan,
  kepatuhan_apd,
  apd_tersedia,
  apd_digunakan_benar,
  pekerja_diamati,
  perilaku_aman,
  perilaku_tidak_aman,
  jumlah_pekerja_diwawancara,
  pekerja_aware_prosedur,
  jumlah_temuan,
  temuan_bahaya,
  temuan_kritis,
  temuan_mayor,
  temuan_minor,
  pelanggaran_prosedur,
  praktek_baik,
  action_items,
  jumlah_action_item,
  action_belum_mulai,
  ringkasan_observasi,
  rekomendasi,
  status,
  tingkat_urgensi,
  perlu_follow_up,
  skor_keseluruhan,
  skor_housekeeping,
  skor_apd,
  skor_perilaku
) VALUES (
  'MW-2024-11-001',
  '2024-11-22'::date,
  '08:00',
  '10:30',
  (SELECT id FROM units WHERE kode = 'WIL1' LIMIT 1),
  'Area Produksi Unit 1',
  'Produksi',
  'Budi Santoso',
  ARRAY['Ahmad HSE', 'Siti Supervisor', 'Joko Safety Officer'],
  4,
  'Inspeksi rutin bulanan untuk memastikan kondisi K3 di area produksi',
  ARRAY['housekeeping', 'APD', 'ergonomi', 'perilaku_kerja'],
  'rutin',
  'cukup',
  'baik',
  'cukup',
  'baik',
  85,
  true,
  false,
  25,
  20,
  5,
  8,
  true,
  7,
  '[
    {
      "no": 1,
      "kategori": "fisik",
      "deskripsi": "Lantai licin karena tumpahan oli di area mesin",
      "lokasi": "Line Produksi A",
      "tingkat_risiko": "tinggi",
      "status": "open"
    },
    {
      "no": 2,
      "kategori": "mekanik",
      "deskripsi": "Guard mesin conveyor belt lepas",
      "lokasi": "Line Produksi B",
      "tingkat_risiko": "kritis",
      "status": "open"
    },
    {
      "no": 3,
      "kategori": "ergonomi",
      "deskripsi": "Tinggi meja kerja tidak sesuai standar ergonomi",
      "lokasi": "Area Packing",
      "tingkat_risiko": "sedang",
      "status": "open"
    }
  ]'::jsonb,
  1,
  2,
  3,
  ARRAY['Beberapa pekerja tidak menggunakan safety shoes', 'SOP lifting manual tidak diikuti'],
  ARRAY['Tim produksi rutin melakukan 5R setiap shift', 'Komunikasi tim sangat baik'],
  '[
    {
      "no": 1,
      "temuan": "Lantai licin area mesin",
      "tindakan": "Bersihkan tumpahan oli dan pasang rambu lantai licin",
      "pic": "Supervisor Produksi",
      "target": "2024-11-22",
      "prioritas": "tinggi",
      "status": "belum_mulai"
    },
    {
      "no": 2,
      "temuan": "Guard mesin lepas",
      "tindakan": "Pasang kembali guard dan lakukan pengecekan semua guard",
      "pic": "Teknisi Mekanik",
      "target": "2024-11-22",
      "prioritas": "kritis",
      "status": "belum_mulai"
    },
    {
      "no": 3,
      "temuan": "Meja kerja tidak ergonomis",
      "tindakan": "Adjustable workbench untuk area packing",
      "pic": "Dept. Engineering",
      "target": "2024-12-15",
      "prioritas": "sedang",
      "status": "belum_mulai"
    }
  ]'::jsonb,
  3,
  3,
  'Walkthrough dilakukan di area produksi Unit 1. Secara umum kondisi cukup baik dengan housekeeping score 75%. Ditemukan beberapa temuan kritis dan mayor yang perlu segera ditindaklanjuti. Kepatuhan APD 85% dengan beberapa pekerja masih tidak menggunakan safety shoes. Perilaku kerja umumnya aman dengan 5 observasi perilaku tidak aman terkait manual handling.',
  ARRAY['Tingkatkan enforcement penggunaan APD khususnya safety shoes', 'Training ulang SOP manual handling', 'Perbaikan immediate untuk guard mesin', 'Program 5R perlu diperkuat'],
  'completed',
  'tinggi',
  true,
  78,
  75,
  85,
  80
);
