-- Insert Sample Safety Drill Data - Fixed Version
-- Simplified to match exact column order

-- Drill 1: Fire Drill - Completed dengan Grade A
INSERT INTO safety_drill (
    nomor_drill, jenis_drill, kategori_drill, tingkat_drill, judul_drill, deskripsi,
    unit_id, unit_kerja, area_lokasi, titik_kumpul, tanggal_drill, waktu_mulai, shift,
    tujuan_drill, sasaran_drill, skenario, kriteria_keberhasilan,
    drill_commander, jabatan_commander, safety_officer, jabatan_safety, ert_leader,
    jumlah_peserta, jumlah_karyawan, jumlah_kontraktor,
    observer, ert_members,
    waktu_deteksi, waktu_mulai_evakuasi, waktu_alarm_berbunyi, waktu_selesai_evakuasi,
    jenis_alarm, total_waktu_evakuasi, target_waktu_evakuasi,
    alarm_activated, target_tercapai, apar_digunakan, hydrant_digunakan,
    kondisi_cuaca, perilaku_peserta, ada_korban_simulasi,
    evakuasi_teratur, pintu_darurat_berfungsi, alat_pemadam_siap, rute_evakuasi_jelas,
    lampu_darurat_berfungsi, komunikasi_efektif,
    penilaian_kesiapan, penilaian_response, penilaian_koordinasi, penilaian_komunikasi,
    penilaian_evakuasi, penilaian_peralatan, skor_total, persentase_keberhasilan,
    skor_overall, grade, hasil_debriefing, tanggal_debriefing, debriefing_dilakukan,
    catatan_next_drill, tanggal_next_drill, next_drill_scheduled,
    pihak_eksternal_terlibat, compliance_status, status, created_by
) VALUES (
    'SD-2024-11-001', 'fire_drill', 'planned', 'plant_wide',
    'Simulasi Kebakaran Gudang Material',
    'Drill evakuasi kebakaran pada gudang material dengan skenario kebakaran akibat korsleting listrik',
    (SELECT id FROM units WHERE nama = 'Tanjung Perak' LIMIT 1),
    'Operasional', 'Gudang Material Blok A', 'Lapangan Parkir Utama',
    '2024-11-15', '09:00', 'Pagi',
    'Menguji kesiapan tim dalam menangani kebakaran, mengukur waktu evakuasi, dan mengevaluasi koordinasi tim ERT',
    ARRAY['Evakuasi < 5 menit', 'Zero injury', 'Semua titik kumpul tercapai'],
    'Kebakaran terjadi akibat korsleting listrik di panel gudang, asap tebal menyebar, aktivasi alarm otomatis',
    ARRAY['Waktu evakuasi maksimal 5 menit', 'Semua peserta berhasil dievakuasi', 'ERT berhasil melakukan pemadaman'],
    'Budi Santoso', 'Manager Operasional', 'Ahmad Wijaya', 'HSE Coordinator', 'Eko Prasetyo',
    38, 35, 3,
    ARRAY['Kepala Departemen K3', 'Supervisor Produksi'],
    ARRAY['Agus Setiawan', 'Rudi Hermawan', 'Siti Nurhaliza'],
    '09:00:30', '09:01:00', '09:00:45', '09:04:30',
    'Alarm Kebakaran Otomatis', 210, 300,
    true, true, 2, 1,
    'Cerah', 'Sangat baik, tertib dan mengikuti prosedur', true,
    true, true, true, true, true, true,
    18, 19, 19, 18, 20, 19, 113, 94.17,
    95, 'A',
    'Debriefing dilakukan dengan melibatkan semua peserta. Waktu response cepat, koordinasi baik.',
    '2024-11-15', true,
    'Drill berikutnya fokus pada skenario kebakaran dengan korban terjebak di lantai 2',
    '2025-02-15', true,
    true, 'compliant', 'completed',
    (SELECT id FROM pegawai WHERE email = 'admin@hsse.com' LIMIT 1)
);

-- Drill 2: Chemical Spill - Completed Grade B
INSERT INTO safety_drill (
    nomor_drill, jenis_drill, kategori_drill, tingkat_drill, judul_drill, deskripsi,
    unit_id, unit_kerja, area_lokasi, titik_kumpul, tanggal_drill, waktu_mulai, shift,
    tujuan_drill, skenario, kriteria_keberhasilan,
    drill_commander, jabatan_commander, safety_officer, jabatan_safety, ert_leader,
    jumlah_peserta, jumlah_karyawan, jumlah_kontraktor,
    observer, ert_members,
    waktu_deteksi, waktu_mulai_evakuasi, waktu_alarm_berbunyi, waktu_selesai_evakuasi,
    jenis_alarm, total_waktu_evakuasi, target_waktu_evakuasi,
    alarm_activated, target_tercapai,
    kondisi_cuaca, perilaku_peserta,
    evakuasi_teratur, pintu_darurat_berfungsi, alat_pemadam_siap, rute_evakuasi_jelas,
    lampu_darurat_berfungsi, komunikasi_efektif,
    penilaian_kesiapan, penilaian_response, penilaian_koordinasi, penilaian_komunikasi,
    penilaian_evakuasi, penilaian_peralatan, skor_total, persentase_keberhasilan,
    skor_overall, grade, hasil_debriefing, tanggal_debriefing, debriefing_dilakukan,
    catatan_next_drill, tanggal_next_drill, next_drill_scheduled,
    compliance_status, status, created_by
) VALUES (
    'SD-2024-11-002', 'chemical_spill', 'functional', 'area_specific',
    'Simulasi Tumpahan Chemical HCl di Area Produksi',
    'Drill penanganan tumpahan bahan kimia berbahaya dengan fokus pada area produksi',
    (SELECT id FROM units WHERE nama = 'Tanjung Emas' LIMIT 1),
    'Produksi', 'Area Produksi Line 2', 'Assembly Point C',
    '2024-11-18', '14:00', 'Siang',
    'Melatih prosedur penanganan chemical spill, penggunaan spill kit, dan koordinasi tim',
    'Drum berisi HCl 35% terjatuh dan bocor, tumpahan 2m², tim response harus melakukan containment',
    ARRAY['Containment dalam 5 menit', 'PPE lengkap digunakan', 'Zero exposure'],
    'Siti Nurhaliza', 'HSE Coordinator', 'Rudi Hermawan', 'EHS Manager', 'Dewi Kusuma',
    25, 20, 5,
    ARRAY['Supervisor Produksi', 'Manager EHS'],
    ARRAY['Chemical Response Team 1', 'Chemical Response Team 2', 'Chemical Response Team 3'],
    '14:01:00', '14:02:00', '14:01:15', '14:15:00',
    'Chemical Alarm', 780, 600,
    true, false,
    'Cerah', 'Baik, beberapa ragu dalam penggunaan spill kit',
    true, true, true, true, true, false,
    16, 17, 15, 14, 18, 16, 96, 80.00,
    80, 'B',
    'Drill berjalan baik namun waktu response melebihi target. Beberapa anggota masih ragu dalam prosedur',
    '2024-11-18', true,
    'Drill berikutnya akan fokus pada multiple chemical spill scenario',
    '2025-02-18', true,
    'compliant', 'completed',
    (SELECT id FROM pegawai WHERE email = 'admin@hsse.com' LIMIT 1)
);

-- Drill 3: Medical Emergency - Completed Grade A
INSERT INTO safety_drill (
    nomor_drill, jenis_drill, kategori_drill, tingkat_drill, judul_drill, deskripsi,
    unit_id, unit_kerja, area_lokasi, titik_kumpul, tanggal_drill, waktu_mulai, shift,
    tujuan_drill, skenario, kriteria_keberhasilan,
    drill_commander, jabatan_commander, safety_officer, jabatan_safety, ert_leader,
    jumlah_peserta, jumlah_karyawan,
    observer, ert_members, first_aider,
    waktu_deteksi,
    kondisi_cuaca, perilaku_peserta, ada_korban_simulasi,
    detail_korban,
    evakuasi_teratur, pintu_darurat_berfungsi, alat_pemadam_siap, rute_evakuasi_jelas,
    lampu_darurat_berfungsi, komunikasi_efektif,
    penilaian_kesiapan, penilaian_response, penilaian_koordinasi, penilaian_komunikasi,
    penilaian_evakuasi, penilaian_peralatan, skor_total, persentase_keberhasilan,
    skor_overall, grade, hasil_debriefing, tanggal_debriefing, debriefing_dilakukan,
    catatan_next_drill, tanggal_next_drill, next_drill_scheduled,
    pihak_eksternal_terlibat, compliance_status, status, created_by
) VALUES (
    'SD-2024-11-004', 'medical_emergency', 'tabletop', 'team_based',
    'Simulasi Kecelakaan Kerja dengan Korban Berat',
    'Table-top exercise untuk menguji prosedur penanganan medical emergency',
    (SELECT id FROM units WHERE nama = 'Banjarmasin' LIMIT 1),
    'Produksi', 'Ruang Meeting B', 'N/A (Table Top)',
    '2024-11-22', '13:00', 'Siang',
    'Menguji knowledge tim medis dalam handling trauma case, prosedur evakuasi medis, dan koordinasi dengan RS',
    'Pekerja jatuh dari ketinggian 3 meter, multiple trauma, perdarahan, fraktur, tim harus stabilisasi dan evakuasi',
    ARRAY['Correct trauma assessment', 'Proper stabilization', 'Correct evacuation procedure'],
    'Andi Wijaya', 'Supervisor K3', 'Bambang Suryono', 'Paramedic Leader', 'Dr. Sari Indah',
    15, 15,
    ARRAY['RS Rujukan Representative', 'BPJS Ketenagakerjaan'],
    ARRAY['Paramedic 1', 'Paramedic 2'],
    ARRAY['First Aider 1', 'First Aider 2'],
    '13:05:00',
    'N/A (Indoor)', 'Sangat baik, decision making cepat dan tepat', true,
    '{"jenis": "korban_simulasi", "kondisi": "fraktur femur, perdarahan eksternal, penurunan kesadaran"}'::jsonb,
    true, true, true, true, true, true,
    19, 20, 19, 20, 19, 18, 115, 95.83,
    96, 'A',
    'Table-top exercise sangat efektif. Tim medis menunjukkan competency yang sangat baik dalam trauma management',
    '2024-11-22', true,
    'Drill selanjutnya akan field exercise dengan victim simulasi real',
    '2025-02-22', true,
    true, 'compliant', 'completed',
    (SELECT id FROM pegawai WHERE email = 'admin@hsse.com' LIMIT 1)
);

-- Drill 4: Evacuation Drill - Ongoing
INSERT INTO safety_drill (
    nomor_drill, jenis_drill, kategori_drill, tingkat_drill, judul_drill, deskripsi,
    unit_id, unit_kerja, area_lokasi, titik_kumpul, tanggal_drill, waktu_mulai, shift,
    tujuan_drill, skenario, kriteria_keberhasilan,
    drill_commander, jabatan_commander, safety_officer, jabatan_safety,
    jumlah_peserta, jumlah_karyawan, jumlah_kontraktor,
    observer, ert_members,
    status, created_by
) VALUES (
    'SD-2024-11-003', 'evacuation_drill', 'planned', 'department',
    'Evakuasi Darurat Departemen Administrasi',
    'Drill evakuasi khusus untuk departemen administrasi dengan skenario kebocoran gas',
    (SELECT id FROM units WHERE nama = 'Benoa' LIMIT 1),
    'Administrasi', 'Gedung Administrasi Lantai 1-3', 'Lapangan Parkir Depan',
    '2024-11-26', '11:00', 'Pagi',
    'Menguji prosedur evakuasi multi-lantai, penggunaan tangga darurat, dan sistem komunikasi',
    'Kebocoran gas terdeteksi di lantai 1, aktivasi alarm, evakuasi bertingkat dari lantai 3 ke bawah',
    ARRAY['Evakuasi teratur per lantai', 'Tangga darurat dapat diakses', 'Semua peserta terakuntansi'],
    'Made Sutama', 'Manager Administrasi', 'Agus Setiawan', 'Safety Officer',
    32, 25, 7,
    ARRAY['HR Manager', 'IT Manager'],
    ARRAY['Floor Warden Lt 1', 'Floor Warden Lt 2', 'Floor Warden Lt 3'],
    'in_progress',
    (SELECT id FROM pegawai WHERE email = 'admin@hsse.com' LIMIT 1)
);

-- Drill 5: Earthquake Drill - Planned
INSERT INTO safety_drill (
    nomor_drill, jenis_drill, kategori_drill, tingkat_drill, judul_drill, deskripsi,
    unit_id, unit_kerja, area_lokasi, titik_kumpul, tanggal_drill, waktu_mulai, shift,
    tujuan_drill, skenario, kriteria_keberhasilan,
    drill_commander, jabatan_commander, safety_officer, jabatan_safety,
    jumlah_peserta,
    observer, ert_members,
    pihak_eksternal_terlibat, compliance_status, status, created_by
) VALUES (
    'SD-2024-12-001', 'earthquake_drill', 'unannounced', 'plant_wide',
    'Simulasi Gempa Bumi Skala 6.5 SR',
    'Drill evakuasi gempa bumi tanpa pemberitahuan untuk menguji kesiapan spontan karyawan',
    (SELECT id FROM units WHERE nama = 'Gresik' LIMIT 1),
    'Seluruh Area', 'Semua Gedung', 'Lapangan Terbuka Area B',
    '2024-12-20', '10:30', 'Siang',
    'Menguji response time karyawan terhadap gempa tanpa warning, evaluasi prosedur duck-cover-hold',
    'Gempa berkekuatan 6.5 SR terjadi tiba-tiba, karyawan harus melakukan duck-cover-hold kemudian evakuasi',
    ARRAY['Response time < 10 detik', 'Duck-cover-hold dijalankan', 'Evakuasi terkoordinir'],
    'Hendra Gunawan', 'Manager K3', 'Bambang Suryono', 'Safety Officer Senior',
    65,
    ARRAY['Direktur Operasional', 'BPBD Gresik'],
    ARRAY['Tim ERT Gresik A', 'Tim ERT Gresik B'],
    true, 'not_applicable', 'planned',
    (SELECT id FROM pegawai WHERE email = 'admin@hsse.com' LIMIT 1)
);

-- Verification Query
SELECT 
    nomor_drill,
    jenis_drill,
    judul_drill,
    tanggal_drill,
    status,
    grade,
    persentase_keberhasilan,
    u.nama as unit
FROM safety_drill sd
LEFT JOIN units u ON u.id = sd.unit_id
WHERE nomor_drill LIKE 'SD-2024-%'
ORDER BY tanggal_drill DESC;
