-- Safety Drill Table
-- Comprehensive emergency drill tracking and documentation

DROP TABLE IF EXISTS safety_drill CASCADE;

CREATE TABLE safety_drill (
    -- Primary Key
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Nomor Drill (Auto-generated: DRL-YYYY-MM-XXX)
    nomor_drill VARCHAR(50) UNIQUE NOT NULL,
    
    -- Jenis & Kategori Drill
    jenis_drill VARCHAR(50) NOT NULL CHECK (jenis_drill IN (
        'fire_drill',           -- Kebakaran
        'earthquake_drill',     -- Gempa Bumi
        'evacuation_drill',     -- Evakuasi Umum
        'chemical_spill',       -- Tumpahan Kimia
        'medical_emergency',    -- Kedaruratan Medis
        'bomb_threat',          -- Ancaman Bom
        'gas_leak',             -- Kebocoran Gas
        'confined_space',       -- Ruang Terbatas
        'height_rescue',        -- Penyelamatan Ketinggian
        'water_rescue',         -- Penyelamatan Air
        'severe_weather',       -- Cuaca Ekstrem
        'security_breach',      -- Pelanggaran Keamanan
        'power_outage',         -- Pemadaman Listrik
        'active_shooter',       -- Penembak Aktif
        'full_scale'            -- Drill Skala Penuh
    )),
    
    kategori_drill VARCHAR(30) NOT NULL CHECK (kategori_drill IN (
        'planned',              -- Terencana
        'unannounced',          -- Tanpa Pemberitahuan
        'tabletop',             -- Simulasi Meja
        'functional',           -- Fungsional
        'full_scale'            -- Skala Penuh
    )),
    
    tingkat_drill VARCHAR(30) NOT NULL CHECK (tingkat_drill IN (
        'plant_wide',           -- Seluruh Pabrik
        'area_specific',        -- Area Tertentu
        'department',           -- Departemen
        'shift_based',          -- Per Shift
        'team_based'            -- Per Tim
    )),
    
    -- Informasi Dasar
    judul_drill VARCHAR(255) NOT NULL,
    deskripsi TEXT,
    
    -- Unit & Lokasi
    unit_kerja VARCHAR(100) NOT NULL,
    area_lokasi VARCHAR(100) NOT NULL,
    ruang_khusus VARCHAR(100),
    titik_kumpul VARCHAR(100) NOT NULL,
    area_terdampak TEXT[],                          -- Multiple areas affected
    
    -- Jadwal Drill
    tanggal_drill DATE NOT NULL,
    waktu_mulai TIME NOT NULL,
    waktu_selesai TIME,
    durasi_menit INTEGER,
    shift VARCHAR(30),
    
    -- Perencanaan
    tanggal_perencanaan DATE,
    pic_perencanaan VARCHAR(100),
    tujuan_drill TEXT NOT NULL,
    sasaran_drill TEXT[],                           -- Multiple objectives
    skenario TEXT NOT NULL,
    kriteria_keberhasilan TEXT[],                   -- Success criteria
    
    -- Tim Drill
    drill_commander VARCHAR(100) NOT NULL,          -- Komandan Drill
    jabatan_commander VARCHAR(100),
    safety_officer VARCHAR(100) NOT NULL,           -- Petugas K3
    jabatan_safety VARCHAR(100),
    observer TEXT[],                                -- Multiple observers
    controller TEXT[],                              -- Controllers
    evaluator TEXT[],                               -- Evaluators
    
    -- Tim Emergency Response
    ert_leader VARCHAR(100),                        -- Leader ERT
    ert_members TEXT[],                             -- Anggota ERT
    first_aider TEXT[],                             -- Petugas P3K
    fire_team TEXT[],                               -- Tim Pemadam Kebakaran
    evacuation_team TEXT[],                         -- Tim Evakuasi
    communication_team TEXT[],                      -- Tim Komunikasi
    
    -- Partisipan
    jumlah_peserta INTEGER NOT NULL DEFAULT 0,
    jumlah_karyawan INTEGER DEFAULT 0,
    jumlah_kontraktor INTEGER DEFAULT 0,
    jumlah_observer INTEGER DEFAULT 0,
    daftar_peserta JSONB,                           -- [{nama, nik, dept, role, unit}]
    
    -- Pre-Drill Briefing
    briefing_dilakukan BOOLEAN DEFAULT false,
    tanggal_briefing DATE,
    waktu_briefing TIME,
    peserta_briefing TEXT[],
    materi_briefing TEXT,
    
    -- Peralatan & Fasilitas
    peralatan_digunakan JSONB,                      -- [{nama, jumlah, kondisi, lokasi}]
    apar_digunakan INTEGER DEFAULT 0,
    hydrant_digunakan INTEGER DEFAULT 0,
    stretcher_digunakan INTEGER DEFAULT 0,
    ppe_digunakan TEXT[],
    alat_komunikasi TEXT[],
    
    -- Alarm & Komunikasi
    alarm_activated BOOLEAN DEFAULT false,
    waktu_alarm TIME,
    jenis_alarm VARCHAR(50),
    pa_system_used BOOLEAN DEFAULT false,
    radio_communication BOOLEAN DEFAULT false,
    emergency_contact_called TEXT[],
    
    -- Pelaksanaan Drill
    drill_dimulai BOOLEAN DEFAULT false,
    waktu_aktual_mulai TIME,
    waktu_deteksi TIME,                             -- Waktu deteksi insiden
    waktu_alarm_berbunyi TIME,                      -- Waktu alarm
    waktu_mulai_evakuasi TIME,                      -- Waktu mulai evakuasi
    waktu_selesai_evakuasi TIME,                    -- Waktu selesai evakuasi
    waktu_all_clear TIME,                           -- Waktu all clear
    total_waktu_evakuasi INTEGER,                   -- Dalam detik
    
    -- Response Time Breakdown
    detection_time INTEGER,                         -- Deteksi ke alarm (detik)
    alarm_to_evacuation INTEGER,                    -- Alarm ke evakuasi (detik)
    evacuation_duration INTEGER,                    -- Durasi evakuasi (detik)
    response_team_arrival INTEGER,                  -- Kedatangan tim (detik)
    
    -- Observasi Selama Drill
    observasi_positif TEXT[],                       -- Positive observations
    observasi_negatif TEXT[],                       -- Issues observed
    perilaku_peserta TEXT,                          -- Participant behavior
    kepatuhan_prosedur TEXT,                        -- Procedure compliance
    
    -- Evaluasi Kinerja
    evakuasi_teratur BOOLEAN,
    rute_evakuasi_jelas BOOLEAN,
    pintu_darurat_berfungsi BOOLEAN,
    lampu_darurat_berfungsi BOOLEAN,
    alat_pemadam_siap BOOLEAN,
    p3k_tersedia BOOLEAN,
    komunikasi_efektif BOOLEAN,
    koordinasi_tim_baik BOOLEAN,
    
    -- Penilaian Detail
    penilaian_kesiapan INTEGER CHECK (penilaian_kesiapan BETWEEN 1 AND 5),
    penilaian_response INTEGER CHECK (penilaian_response BETWEEN 1 AND 5),
    penilaian_koordinasi INTEGER CHECK (penilaian_koordinasi BETWEEN 1 AND 5),
    penilaian_komunikasi INTEGER CHECK (penilaian_komunikasi BETWEEN 1 AND 5),
    penilaian_evakuasi INTEGER CHECK (penilaian_evakuasi BETWEEN 1 AND 5),
    penilaian_peralatan INTEGER CHECK (penilaian_peralatan BETWEEN 1 AND 5),
    
    -- Scoring
    skor_total INTEGER,
    skor_maksimal INTEGER DEFAULT 100,
    persentase_keberhasilan DECIMAL(5,2),
    grade VARCHAR(2) CHECK (grade IN ('A', 'B', 'C', 'D', 'E')),
    
    -- Target vs Aktual
    target_waktu_evakuasi INTEGER,                  -- Target dalam detik
    selisih_waktu INTEGER,                          -- Aktual - Target (detik)
    target_tercapai BOOLEAN,
    
    -- Temuan & Issues
    jumlah_temuan INTEGER DEFAULT 0,
    temuan_kritis INTEGER DEFAULT 0,
    temuan_mayor INTEGER DEFAULT 0,
    temuan_minor INTEGER DEFAULT 0,
    detail_temuan JSONB,                            -- [{kategori, deskripsi, lokasi, severity}]
    
    -- Korban & Insiden (Simulasi)
    ada_korban_simulasi BOOLEAN DEFAULT false,
    jumlah_korban_simulasi INTEGER DEFAULT 0,
    detail_korban JSONB,                            -- [{nama, kondisi, tindakan, waktu_rescue}]
    
    -- Near Miss & Actual Incident
    near_miss_terjadi BOOLEAN DEFAULT false,
    detail_near_miss TEXT,
    actual_incident BOOLEAN DEFAULT false,
    detail_incident TEXT,
    
    -- Improvement Areas
    area_perbaikan TEXT[],                          -- Areas needing improvement
    rekomendasi TEXT[],                             -- Recommendations
    best_practice TEXT[],                           -- Best practices observed
    lesson_learned TEXT[],                          -- Lessons learned
    
    -- Action Items & Follow Up
    action_items JSONB,                             -- [{item, pic, target_date, status, priority}]
    corrective_actions JSONB,                       -- [{action, pic, deadline, status}]
    
    -- Post-Drill Debriefing
    debriefing_dilakukan BOOLEAN DEFAULT false,
    tanggal_debriefing DATE,
    waktu_debriefing TIME,
    peserta_debriefing TEXT[],
    hasil_debriefing TEXT,
    
    -- Dokumentasi
    foto_dokumentasi TEXT[],                        -- Photo URLs
    video_dokumentasi TEXT[],                       -- Video URLs
    dokumen_pendukung TEXT[],                       -- Document URLs
    form_evaluasi_url TEXT,
    laporan_url TEXT,
    
    -- External Involvement
    pihak_eksternal_terlibat BOOLEAN DEFAULT false,
    nama_pihak_eksternal TEXT[],                    -- Damkar, Polisi, RS, etc
    waktu_kedatangan_eksternal TIME,
    peran_pihak_eksternal TEXT,
    
    -- Weather & Environment
    kondisi_cuaca VARCHAR(50),
    suhu_celsius DECIMAL(4,1),
    kondisi_lingkungan TEXT,
    faktor_pengganggu TEXT,                         -- Disturbing factors
    
    -- Peraturan & Compliance
    regulasi_acuan TEXT[],                          -- Regulations referenced
    compliance_status VARCHAR(30) CHECK (compliance_status IN (
        'compliant',
        'partially_compliant',
        'non_compliant',
        'not_applicable'
    )),
    gap_analysis TEXT,
    
    -- Status & Approval
    status VARCHAR(30) NOT NULL DEFAULT 'planned' CHECK (status IN (
        'planned',              -- Direncanakan
        'ongoing',              -- Sedang Berlangsung
        'completed',            -- Selesai
        'cancelled',            -- Dibatalkan
        'postponed'             -- Ditunda
    )),
    
    alasan_cancel TEXT,
    alasan_postpone TEXT,
    tanggal_reschedule DATE,
    
    -- Approval Workflow
    submitted_by VARCHAR(100),
    submitted_at TIMESTAMP,
    reviewed_by VARCHAR(100),
    reviewed_at TIMESTAMP,
    approved_by VARCHAR(100),
    approved_at TIMESTAMP,
    approval_status VARCHAR(30) CHECK (approval_status IN (
        'draft',
        'submitted',
        'reviewed',
        'approved',
        'rejected'
    )),
    approval_notes TEXT,
    
    -- Sertifikat Drill
    sertifikat_diberikan BOOLEAN DEFAULT false,
    nomor_sertifikat VARCHAR(100),
    tanggal_sertifikat DATE,
    masa_berlaku_bulan INTEGER,
    tanggal_kadaluarsa DATE,
    
    -- Next Drill Planning
    next_drill_scheduled BOOLEAN DEFAULT false,
    tanggal_next_drill DATE,
    catatan_next_drill TEXT,
    
    -- Metadata
    created_by VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(100),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT valid_times CHECK (
        (waktu_selesai IS NULL) OR (waktu_mulai < waktu_selesai)
    ),
    CONSTRAINT valid_evacuation_time CHECK (
        (waktu_selesai_evakuasi IS NULL) OR 
        (waktu_mulai_evakuasi IS NULL) OR 
        (waktu_mulai_evakuasi < waktu_selesai_evakuasi)
    ),
    CONSTRAINT valid_participant_count CHECK (
        jumlah_peserta = (jumlah_karyawan + jumlah_kontraktor + jumlah_observer)
    )
);

-- Indexes for better query performance
CREATE INDEX idx_safety_drill_nomor ON safety_drill(nomor_drill);
CREATE INDEX idx_safety_drill_tanggal ON safety_drill(tanggal_drill DESC);
CREATE INDEX idx_safety_drill_jenis ON safety_drill(jenis_drill);
CREATE INDEX idx_safety_drill_kategori ON safety_drill(kategori_drill);
CREATE INDEX idx_safety_drill_status ON safety_drill(status);
CREATE INDEX idx_safety_drill_unit ON safety_drill(unit_kerja);
CREATE INDEX idx_safety_drill_commander ON safety_drill(drill_commander);
CREATE INDEX idx_safety_drill_grade ON safety_drill(grade);
CREATE INDEX idx_safety_drill_created ON safety_drill(created_at DESC);
CREATE INDEX idx_safety_drill_next ON safety_drill(tanggal_next_drill) WHERE next_drill_scheduled = true;

-- Comments
COMMENT ON TABLE safety_drill IS 'Comprehensive safety drill and emergency response exercise tracking';
COMMENT ON COLUMN safety_drill.nomor_drill IS 'Auto-generated drill number: DRL-YYYY-MM-XXX';
COMMENT ON COLUMN safety_drill.jenis_drill IS 'Type of emergency drill (fire, earthquake, evacuation, etc)';
COMMENT ON COLUMN safety_drill.kategori_drill IS 'Drill category (planned, unannounced, tabletop, etc)';
COMMENT ON COLUMN safety_drill.total_waktu_evakuasi IS 'Total evacuation time in seconds';
COMMENT ON COLUMN safety_drill.detection_time IS 'Time from incident detection to alarm activation (seconds)';
COMMENT ON COLUMN safety_drill.persentase_keberhasilan IS 'Success percentage based on criteria achievement';

-- Insert sample data
INSERT INTO safety_drill (
    nomor_drill,
    jenis_drill,
    kategori_drill,
    tingkat_drill,
    judul_drill,
    deskripsi,
    unit_kerja,
    area_lokasi,
    titik_kumpul,
    area_terdampak,
    tanggal_drill,
    waktu_mulai,
    waktu_selesai,
    durasi_menit,
    shift,
    tanggal_perencanaan,
    pic_perencanaan,
    tujuan_drill,
    sasaran_drill,
    skenario,
    kriteria_keberhasilan,
    drill_commander,
    jabatan_commander,
    safety_officer,
    jabatan_safety,
    observer,
    controller,
    evaluator,
    ert_leader,
    ert_members,
    first_aider,
    fire_team,
    evacuation_team,
    communication_team,
    jumlah_peserta,
    jumlah_karyawan,
    jumlah_kontraktor,
    jumlah_observer,
    daftar_peserta,
    briefing_dilakukan,
    tanggal_briefing,
    waktu_briefing,
    peserta_briefing,
    materi_briefing,
    peralatan_digunakan,
    apar_digunakan,
    hydrant_digunakan,
    stretcher_digunakan,
    ppe_digunakan,
    alat_komunikasi,
    alarm_activated,
    waktu_alarm,
    jenis_alarm,
    pa_system_used,
    radio_communication,
    emergency_contact_called,
    drill_dimulai,
    waktu_aktual_mulai,
    waktu_deteksi,
    waktu_alarm_berbunyi,
    waktu_mulai_evakuasi,
    waktu_selesai_evakuasi,
    waktu_all_clear,
    total_waktu_evakuasi,
    detection_time,
    alarm_to_evacuation,
    evacuation_duration,
    response_team_arrival,
    observasi_positif,
    observasi_negatif,
    perilaku_peserta,
    kepatuhan_prosedur,
    evakuasi_teratur,
    rute_evakuasi_jelas,
    pintu_darurat_berfungsi,
    lampu_darurat_berfungsi,
    alat_pemadam_siap,
    p3k_tersedia,
    komunikasi_efektif,
    koordinasi_tim_baik,
    penilaian_kesiapan,
    penilaian_response,
    penilaian_koordinasi,
    penilaian_komunikasi,
    penilaian_evakuasi,
    penilaian_peralatan,
    skor_total,
    skor_maksimal,
    persentase_keberhasilan,
    grade,
    target_waktu_evakuasi,
    selisih_waktu,
    target_tercapai,
    jumlah_temuan,
    temuan_kritis,
    temuan_mayor,
    temuan_minor,
    detail_temuan,
    ada_korban_simulasi,
    jumlah_korban_simulasi,
    detail_korban,
    near_miss_terjadi,
    actual_incident,
    area_perbaikan,
    rekomendasi,
    best_practice,
    lesson_learned,
    action_items,
    corrective_actions,
    debriefing_dilakukan,
    tanggal_debriefing,
    waktu_debriefing,
    peserta_debriefing,
    hasil_debriefing,
    foto_dokumentasi,
    pihak_eksternal_terlibat,
    nama_pihak_eksternal,
    waktu_kedatangan_eksternal,
    peran_pihak_eksternal,
    kondisi_cuaca,
    suhu_celsius,
    kondisi_lingkungan,
    regulasi_acuan,
    compliance_status,
    status,
    submitted_by,
    submitted_at,
    reviewed_by,
    reviewed_at,
    approved_by,
    approved_at,
    approval_status,
    sertifikat_diberikan,
    nomor_sertifikat,
    tanggal_sertifikat,
    masa_berlaku_bulan,
    tanggal_kadaluarsa,
    next_drill_scheduled,
    tanggal_next_drill,
    catatan_next_drill,
    created_by,
    created_at,
    updated_by,
    updated_at
) VALUES (
    'DRL-2025-11-001',
    'fire_drill',
    'planned',
    'plant_wide',
    'Fire Drill Gedung Utama - Q4 2025',
    'Simulasi kebakaran di area produksi lantai 2 dengan skenario korsleting listrik',
    'Production',
    'Main Building - Floor 2',
    'Lapangan Parkir Utara',
    ARRAY['Production Floor 2', 'Warehouse', 'Office Area'],
    '2025-11-15',
    '10:00:00',
    '11:30:00',
    90,
    'Day Shift',
    '2025-11-01',
    'Ahmad Rizki - HSE Manager',
    'Menguji kesiapan karyawan dalam menghadapi situasi kebakaran dan prosedur evakuasi',
    ARRAY['Evakuasi dalam waktu < 5 menit', 'Penggunaan APAR yang tepat', 'Koordinasi tim ERT efektif', 'Komunikasi emergency berjalan lancar'],
    'Skenario: Terdeteksi asap tebal dari panel listrik di ruang produksi. Alarm kebakaran berbunyi. Tim ERT bergegas ke lokasi dengan APAR dan selang pemadam. Seluruh karyawan melakukan evakuasi ke titik kumpul.',
    ARRAY['Semua karyawan menuju titik kumpul', 'Waktu evakuasi < 5 menit', 'Tim ERT tiba < 3 menit', 'Api berhasil dipadamkan', 'No injuries'],
    'Budi Hartono',
    'Plant Manager',
    'Siti Nurhaliza',
    'HSE Supervisor',
    ARRAY['Ahmad Rizki - HSE Manager', 'Dr. Ratna - Medical Officer', 'Dedi Kusuma - Security Chief'],
    ARRAY['Eko Prasetyo - Production', 'Indah Permata - Warehouse', 'Bambang Sutejo - Office'],
    ARRAY['Ahmad Rizki - HSE Manager', 'Siti Nurhaliza - HSE Supervisor'],
    'Agus Setiawan',
    ARRAY['Rudi Hermawan', 'Tri Wibowo', 'Joko Susilo', 'Andi Pratama', 'Deni Saputra'],
    ARRAY['Rina Amelia - Nurse', 'Tono Subagyo - First Aider'],
    ARRAY['Agus Setiawan - Leader', 'Rudi Hermawan', 'Tri Wibowo'],
    ARRAY['Joko Susilo - Coordinator', 'Andi Pratama', 'Deni Saputra'],
    ARRAY['Indah Permata - Comm Leader', 'Bambang Sutejo'],
    158,
    120,
    35,
    3,
    '[{"nama": "Budi Santoso", "nik": "EMP001", "dept": "Production", "role": "Operator", "unit": "Main Building"}, {"nama": "Ani Wijaya", "nik": "EMP002", "dept": "QC", "role": "Inspector", "unit": "Main Building"}, {"nama": "Dedi Kurniawan", "nik": "CTR001", "dept": "Maintenance", "role": "Technician", "unit": "Contractor"}]',
    true,
    '2025-11-14',
    '14:00:00',
    ARRAY['All Department Heads', 'ERT Members', 'Floor Wardens', 'Security Team'],
    'Penjelasan skenario drill, peran masing-masing tim, prosedur evakuasi, titik kumpul, dan safety briefing',
    '[{"nama": "APAR CO2 5kg", "jumlah": 8, "kondisi": "Baik", "lokasi": "Various floors"}, {"nama": "Fire Hose", "jumlah": 2, "kondisi": "Baik", "lokasi": "Stairwell"}, {"nama": "Stretcher", "jumlah": 2, "kondisi": "Baik", "lokasi": "Medical Room"}, {"nama": "Megaphone", "jumlah": 4, "kondisi": "Baik", "lokasi": "Floor Wardens"}]',
    8,
    2,
    2,
    ARRAY['Helmet', 'Fire-resistant jacket', 'Gloves', 'Safety boots', 'SCBA'],
    ARRAY['HT Radio (10 units)', 'Megaphone (4 units)', 'PA System', 'Mobile phones'],
    true,
    '10:02:30',
    'Fire Alarm Bell + PA Announcement',
    true,
    true,
    ARRAY['Fire Department (standby)', 'Security Team', 'Medical Team'],
    true,
    '10:00:00',
    '10:02:00',
    '10:02:30',
    '10:03:00',
    '10:06:45',
    '10:08:00',
    225,
    30,
    30,
    225,
    165,
    ARRAY['Respons tim ERT sangat cepat dan terorganisir', 'Prosedur evakuasi diikuti dengan baik', 'Komunikasi antar tim efektif menggunakan radio', 'Penggunaan APAR sesuai prosedur', 'Titik kumpul tertib dan roll call berjalan lancar'],
    ARRAY['Beberapa karyawan masih membawa barang pribadi saat evakuasi', 'Pintu darurat lantai 3 sedikit macet', '2 karyawan tidak langsung ke titik kumpul'],
    'Sebagian besar karyawan tenang dan mengikuti instruksi. Beberapa karyawan baru terlihat sedikit panik namun dibantu oleh floor warden.',
    'Kepatuhan terhadap prosedur evakuasi mencapai 95%. Tim ERT mengikuti SOP pemadaman kebakaran dengan sangat baik.',
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    5,
    5,
    5,
    5,
    4,
    5,
    92,
    100,
    92.00,
    'A',
    300,
    -75,
    true,
    5,
    0,
    2,
    3,
    '[{"kategori": "Mayor", "deskripsi": "Pintu darurat lantai 3 sedikit macet, perlu pelumasan", "lokasi": "Floor 3 - Emergency Exit", "severity": "Medium", "pic": "Maintenance Team", "target_date": "2025-11-20"}, {"kategori": "Mayor", "deskripsi": "Lampu emergency exit di koridor B tidak menyala", "lokasi": "Corridor B", "severity": "Medium", "pic": "Electrical Team", "target_date": "2025-11-18"}, {"kategori": "Minor", "deskripsi": "Beberapa karyawan membawa tas saat evakuasi", "lokasi": "Production Area", "severity": "Low", "pic": "HSE Team", "target_date": "2025-11-25"}, {"kategori": "Minor", "deskripsi": "Tanda arah evakuasi di area baru kurang jelas", "lokasi": "New Extension Area", "severity": "Low", "pic": "HSE Team", "target_date": "2025-11-22"}, {"kategori": "Minor", "deskripsi": "Megaphone unit 3 baterai lemah", "lokasi": "Floor 3", "severity": "Low", "pic": "Security", "target_date": "2025-11-17"}]',
    true,
    2,
    '[{"nama": "Simulasi Korban - Pak Joko", "kondisi": "Terpapar asap, sesak napas", "tindakan": "Dibawa ke medical room, diberikan oksigen, vital signs checked", "waktu_rescue": "10:05:00", "pic": "Rina Amelia - Nurse"}, {"nama": "Simulasi Korban - Ibu Sari", "kondisi": "Pingsan karena panik", "tindakan": "First aid, pemulihan kesadaran, observasi", "waktu_rescue": "10:06:30", "pic": "Tono Subagyo - First Aider"}]',
    false,
    false,
    ARRAY['Perbaikan pintu darurat lantai 3', 'Penggantian lampu emergency exit', 'Sosialisasi ulang prosedur evakuasi untuk karyawan baru', 'Penambahan signage di area baru'],
    ARRAY['Lakukan pemeliharaan rutin semua pintu darurat setiap bulan', 'Refresh training evakuasi untuk karyawan baru setiap 3 bulan', 'Tambah signage evacuation di area perluasan baru', 'Stock APAR dicek dan diisi ulang jika < 80%', 'Conduct unannounced drill in Q1 2026'],
    ARRAY['Koordinasi tim ERT sangat solid dan profesional', 'Penggunaan radio komunikasi sangat membantu koordinasi', 'Roll call system dengan checklist efektif', 'Medical team response sangat cepat'],
    ARRAY['Perlu sosialisasi berulang untuk tidak membawa barang pribadi saat evakuasi', 'Maintenance pintu darurat harus dijadwalkan rutin', 'Karyawan baru perlu buddy system saat drill', 'PA system sangat membantu komunikasi massa'],
    '[{"item": "Perbaikan pintu darurat lantai 3 - pelumasan dan pemeriksaan engsel", "pic": "Dedi Kurniawan - Maintenance", "target_date": "2025-11-20", "status": "Open", "priority": "High"}, {"item": "Penggantian lampu emergency exit koridor B", "pic": "Electrical Team", "target_date": "2025-11-18", "status": "Open", "priority": "High"}, {"item": "Sosialisasi prosedur evakuasi ke seluruh karyawan baru batch Nov 2025", "pic": "Siti Nurhaliza - HSE", "target_date": "2025-11-25", "status": "Open", "priority": "Medium"}, {"item": "Penambahan signage evakuasi di area perluasan gedung", "pic": "Ahmad Rizki - HSE", "target_date": "2025-11-22", "status": "Open", "priority": "Medium"}, {"item": "Penggantian baterai megaphone unit 3", "pic": "Security Team", "target_date": "2025-11-17", "status": "Open", "priority": "Low"}]',
    '[{"action": "Perbaikan dan pelumasan pintu darurat lantai 3", "pic": "Maintenance Manager", "deadline": "2025-11-20", "status": "In Progress"}, {"action": "Replace faulty emergency exit light", "pic": "Electrical Supervisor", "deadline": "2025-11-18", "status": "In Progress"}]',
    true,
    '2025-11-15',
    '13:00:00',
    ARRAY['Budi Hartono - Plant Manager', 'Ahmad Rizki - HSE Manager', 'All Department Heads', 'ERT Team', 'Observers'],
    'Drill berjalan sangat baik dengan pencapaian 92%. Tim ERT menunjukkan profesionalisme tinggi. Area improvement sudah diidentifikasi dan action plan sudah dibuat. Management sangat puas dengan hasil drill dan komitmen untuk perbaikan berkelanjutan.',
    ARRAY['https://storage.supabase.co/drill/briefing-team.jpg', 'https://storage.supabase.co/drill/ert-action.jpg', 'https://storage.supabase.co/drill/evacuation-process.jpg', 'https://storage.supabase.co/drill/assembly-point.jpg', 'https://storage.supabase.co/drill/debriefing.jpg'],
    true,
    ARRAY['Fire Department Bekasi (standby only)', 'Plant Security Team'],
    '10:15:00',
    'Fire Department standby di luar area sebagai backup. Security team membantu mengatur lalu lintas kendaraan di area assembly point.',
    'Cerah',
    28.5,
    'Kondisi normal, tidak ada gangguan eksternal',
    ARRAY['UU No. 1 Tahun 1970 tentang Keselamatan Kerja', 'Permenaker No. 4 Tahun 1980 tentang SKTJK', 'NFPA 101 - Life Safety Code', 'ISO 45001:2018 - OH&S Management'],
    'compliant',
    'completed',
    'Siti Nurhaliza',
    '2025-11-15 11:45:00',
    'Ahmad Rizki',
    '2025-11-15 13:30:00',
    'Budi Hartono',
    '2025-11-15 14:00:00',
    'approved',
    true,
    'CERT-DRL-2025-11-001',
    '2025-11-15',
    12,
    '2026-11-15',
    true,
    '2026-02-15',
    'Q1 2026 - Unannounced fire drill. Focus on night shift readiness.',
    'Siti Nurhaliza',
    '2025-11-15 11:45:00',
    'Ahmad Rizki',
    '2025-11-15 14:00:00'
);

-- Sample 2: Earthquake Drill
INSERT INTO safety_drill (
    nomor_drill,
    jenis_drill,
    kategori_drill,
    tingkat_drill,
    judul_drill,
    deskripsi,
    unit_kerja,
    area_lokasi,
    titik_kumpul,
    area_terdampak,
    tanggal_drill,
    waktu_mulai,
    waktu_selesai,
    durasi_menit,
    shift,
    tanggal_perencanaan,
    pic_perencanaan,
    tujuan_drill,
    sasaran_drill,
    skenario,
    kriteria_keberhasilan,
    drill_commander,
    jabatan_commander,
    safety_officer,
    jabatan_safety,
    observer,
    ert_leader,
    ert_members,
    jumlah_peserta,
    jumlah_karyawan,
    jumlah_kontraktor,
    jumlah_observer,
    briefing_dilakukan,
    tanggal_briefing,
    alarm_activated,
    waktu_alarm,
    jenis_alarm,
    pa_system_used,
    drill_dimulai,
    waktu_aktual_mulai,
    waktu_deteksi,
    waktu_alarm_berbunyi,
    waktu_mulai_evakuasi,
    waktu_selesai_evakuasi,
    total_waktu_evakuasi,
    evakuasi_teratur,
    rute_evakuasi_jelas,
    pintu_darurat_berfungsi,
    penilaian_kesiapan,
    penilaian_response,
    penilaian_evakuasi,
    skor_total,
    persentase_keberhasilan,
    grade,
    target_waktu_evakuasi,
    target_tercapai,
    jumlah_temuan,
    temuan_minor,
    status,
    created_by,
    created_at
) VALUES (
    'DRL-2025-11-002',
    'earthquake_drill',
    'unannounced',
    'plant_wide',
    'Gempa Bumi Drill - Unannounced',
    'Simulasi gempa bumi tanpa pemberitahuan untuk menguji kesiagaan spontan',
    'All Units',
    'Entire Facility',
    'Lapangan Terbuka Selatan',
    ARRAY['All Buildings', 'Production Area', 'Office', 'Warehouse'],
    '2025-11-20',
    '14:30:00',
    '15:15:00',
    45,
    'Day Shift',
    '2025-11-10',
    'Ahmad Rizki - HSE Manager',
    'Menguji respons spontan karyawan terhadap gempa bumi tanpa pemberitahuan sebelumnya',
    ARRAY['Drop-Cover-Hold dalam 10 detik', 'Evakuasi teratur setelah guncangan berhenti', 'Assembly di area terbuka', 'Roll call selesai < 10 menit'],
    'Alarm gempa berbunyi tiba-tiba. Karyawan harus segera drop-cover-hold. Setelah alarm berhenti, lakukan evakuasi ke area terbuka.',
    ARRAY['Response time < 10 detik', 'Tidak ada panic running', 'Hindari lift dan kaca', 'Semua di area terbuka dalam 5 menit'],
    'Ahmad Rizki',
    'HSE Manager',
    'Siti Nurhaliza',
    'HSE Supervisor',
    ARRAY['Budi Hartono - Plant Manager', 'External Consultant - Dr. Andi Setiawan'],
    'Agus Setiawan',
    ARRAY['Rudi Hermawan', 'Joko Susilo', 'Andi Pratama'],
    95,
    85,
    8,
    2,
    true,
    '2025-11-19',
    true,
    '14:30:15',
    'Earthquake Siren',
    true,
    true,
    '14:30:15',
    '14:30:15',
    '14:30:15',
    '14:30:30',
    '14:34:45',
    255,
    true,
    true,
    true,
    4,
    5,
    4,
    85,
    85.00,
    'B',
    300,
    true,
    3,
    3,
    'completed',
    'Ahmad Rizki',
    '2025-11-20 15:30:00'
);

-- Sample 3: Chemical Spill Drill (Planned)
INSERT INTO safety_drill (
    nomor_drill,
    jenis_drill,
    kategori_drill,
    tingkat_drill,
    judul_drill,
    deskripsi,
    unit_kerja,
    area_lokasi,
    titik_kumpul,
    area_terdampak,
    tanggal_drill,
    waktu_mulai,
    shift,
    tanggal_perencanaan,
    pic_perencanaan,
    tujuan_drill,
    skenario,
    drill_commander,
    jabatan_commander,
    safety_officer,
    jabatan_safety,
    jumlah_peserta,
    jumlah_karyawan,
    jumlah_kontraktor,
    jumlah_observer,
    status,
    created_by,
    created_at
) VALUES (
    'DRL-2025-12-003',
    'chemical_spill',
    'planned',
    'area_specific',
    'Chemical Spill Response Drill - December',
    'Simulasi tumpahan bahan kimia berbahaya di area warehouse',
    'Warehouse',
    'Chemical Storage Area',
    'Upwind Assembly Point',
    ARRAY['Chemical Storage', 'Warehouse Area'],
    '2025-12-05',
    '09:00:00',
    'Day Shift',
    '2025-11-22',
    'Siti Nurhaliza - HSE Supervisor',
    'Menguji prosedur penanganan tumpahan kimia dan penggunaan spill kit',
    'Skenario: Drum asam sulfat 200L bocor. Tim harus melakukan isolasi area, gunakan PPE lengkap, containment dengan spill kit, dan disposal sesuai prosedur.',
    'Ahmad Rizki',
    'HSE Manager',
    'Siti Nurhaliza',
    'HSE Supervisor',
    25,
    20,
    3,
    2,
    'planned',
    'Siti Nurhaliza',
    '2025-11-22 10:00:00'
);
