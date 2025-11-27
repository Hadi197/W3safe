-- Sample Data for Safety Alert Tables
-- Data untuk periode November 2024 agar muncul di dashboard

-- ========================================
-- 1. UNSAFE ACTION/CONDITION DATA
-- ========================================

-- Unsafe Action 1: Tidak menggunakan APD
INSERT INTO unsafe_action_condition (
    tanggal_kejadian,
    waktu_kejadian,
    lokasi_kejadian,
    unit_kerja,
    jenis_kejadian,
    kategori,
    deskripsi_kejadian,
    penyebab_diduga,
    potensi_risiko,
    pelapor_nama,
    pelapor_jabatan,
    tindakan_segera,
    korban_ada,
    korban_jumlah,
    prioritas,
    status,
    investigasi_dilakukan,
    temuan_investigasi,
    rekomendasi_koreksi,
    created_by
) VALUES (
    '2024-11-05',
    '09:30:00',
    'Area Lapangan Terminal Tanjung Perak',
    'Tanjung Perak',
    'unsafe_action',
    'PPE Violation',
    'Pekerja tidak menggunakan safety helmet dan safety shoes saat bekerja di area lapangan. Supervisor menemukan 2 pekerja (Operator A dan Operator B) sedang melakukan pekerjaan angkat-angkut tanpa APD lengkap.',
    'Kurangnya kesadaran keselamatan, APD tidak nyaman digunakan, pekerja mengaku APD tertinggal di locker',
    'Risiko cedera kepala dan kaki akibat benda jatuh atau tertimpa material',
    'Supervisor Operasional',
    'Supervisor',
    'Pekerjaan dihentikan segera, pekerja diwajibkan menggunakan APD lengkap sebelum melanjutkan pekerjaan',
    true,
    2,
    'high',
    'closed',
    true,
    'Ditemukan bahwa pekerja sering meninggalkan APD di locker karena merasa tidak nyaman. Perlu safety talk dan penegakan aturan lebih ketat.',
    ARRAY['Safety talk rutin mengenai pentingnya APD', 'Pemeriksaan APD sebelum shift dimulai', 'Penerapan sistem reward & punishment', 'Evaluasi kenyamanan APD yang digunakan']::TEXT[],
    (SELECT id FROM pegawai WHERE email = 'admin@hsse.com' LIMIT 1)
);

-- Unsafe Condition 1: Tumpahan oli di lantai
INSERT INTO unsafe_action_condition (
    tanggal_kejadian,
    waktu_kejadian,
    lokasi_kejadian,
    unit_kerja,
    jenis_kejadian,
    kategori,
    deskripsi_kejadian,
    penyebab_diduga,
    potensi_risiko,
    pelapor_nama,
    pelapor_jabatan,
    tindakan_segera,
    korban_ada,
    area_diamankan,
    prioritas,
    status,
    investigasi_dilakukan,
    temuan_investigasi,
    rekomendasi_koreksi,
    created_by
) VALUES (
    '2024-11-08',
    '13:15:00',
    'Workshop Maintenance Tanjung Emas',
    'Tanjung Emas',
    'unsafe_condition',
    'Housekeeping Issue',
    'Tumpahan oli hydraulic di lantai workshop tidak dibersihkan, berpotensi menyebabkan slip. Ditemukan genangan oli seluas 2m² di area lalu lalang pekerja.',
    'Kebocoran selang hydraulic forklift, pembersihan area tidak rutin, sistem pemeriksaan preventif kurang optimal',
    'Risiko slip and fall yang dapat menyebabkan cedera serius, potensi kecelakaan kerja',
    'Safety Officer',
    'HSE Officer',
    'Area diberi barrier dan safety cone, oli dibersihkan menggunakan oil absorbent, selang hydraulic diperbaiki',
    false,
    true,
    'critical',
    'closed',
    true,
    'Selang hydraulic sudah melewati umur pakai. Housekeeping tidak dilakukan secara rutin. Perlu implementasi program 5R.',
    ARRAY['Implementasi program 5R secara konsisten', 'Penyediaan spill kit di setiap area workshop', 'Pengecekan rutin kondisi equipment', 'Preventive maintenance untuk hydraulic system']::TEXT[],
    (SELECT id FROM pegawai WHERE email = 'admin@hsse.com' LIMIT 1)
);

-- Unsafe Action 2: Bekerja di ketinggian tanpa safety harness
INSERT INTO unsafe_action_condition (
    tanggal_kejadian,
    waktu_kejadian,
    lokasi_kejadian,
    unit_kerja,
    jenis_kejadian,
    kategori,
    deskripsi_kejadian,
    penyebab_diduga,
    potensi_risiko,
    pelapor_nama,
    pelapor_jabatan,
    tindakan_segera,
    korban_ada,
    prioritas,
    severity_level,
    status,
    investigasi_dilakukan,
    temuan_investigasi,
    rekomendasi_koreksi,
    created_by
) VALUES (
    '2024-11-12',
    '10:45:00',
    'Area Container Yard Benoa',
    'Benoa',
    'unsafe_action',
    'Work at Height Violation',
    'Pekerja melakukan pekerjaan di ketinggian 4 meter tanpa menggunakan full body harness. Safety officer menemukan pekerja sedang melakukan inspeksi lampu di tiang menggunakan tangga tanpa safety harness.',
    'Terburu-buru menyelesaikan pekerjaan, safety harness sulit diakses dari lokasi kerja, kurangnya pengawasan',
    'Risiko jatuh dari ketinggian yang dapat menyebabkan cedera berat atau fatal',
    'Safety Officer',
    'Senior Safety Officer',
    'Pekerjaan dihentikan segera, pekerja diinstruksikan menggunakan harness dan lifeline, dilakukan re-briefing JSA sebelum melanjutkan',
    false,
    'critical',
    5,
    'closed',
    true,
    'Pekerja tidak memiliki sertifikat working at height. Permit to work tidak dibuat. Fall protection equipment tidak tersedia di lokasi.',
    ARRAY['Penyediaan fall protection equipment di setiap area ketinggian', 'Training dan sertifikasi working at height untuk semua pekerja terkait', 'Implementasi permit to work yang ketat', 'Penunjukan safety watcher untuk pekerjaan di ketinggian']::TEXT[],
    (SELECT id FROM pegawai WHERE email = 'admin@hsse.com' LIMIT 1)
);

-- Unsafe Condition 2: Kabel listrik terkelupas
INSERT INTO unsafe_action_condition (
    tanggal_kejadian,
    waktu_kejadian,
    lokasi_kejadian,
    unit_kerja,
    jenis_kejadian,
    kategori,
    deskripsi_kejadian,
    penyebab_diduga,
    potensi_risiko,
    pelapor_nama,
    pelapor_jabatan,
    tindakan_segera,
    korban_ada,
    area_diamankan,
    prioritas,
    severity_level,
    status,
    investigasi_dilakukan,
    temuan_investigasi,
    rekomendasi_koreksi,
    target_penyelesaian,
    aktual_penyelesaian,
    created_by
) VALUES (
    '2024-11-15',
    '14:20:00',
    'Kantor Operasional Banjarmasin',
    'Banjarmasin',
    'unsafe_condition',
    'Electrical Hazard',
    'Kabel listrik panel distribusi terkelupas dan terbuka, berpotensi electrical shock. Tim K3 menemukan kabel power panel dengan isolasi terkelupas sepanjang 15cm, kabel masih bertegangan.',
    'Kabel sudah tua dan melewati umur pakai, tidak terawat, terkena gesekan berulang, tidak ada program preventive maintenance',
    'Risiko electrical shock yang dapat menyebabkan fatality, potensi kebakaran akibat korsleting listrik',
    'HSE Coordinator',
    'Koordinator K3',
    'Area diberi barrier dan warning sign, power dimatikan sementara, kabel diganti dengan yang baru oleh teknisi bersertifikat, area di-commissioning sampai aman',
    false,
    true,
    'critical',
    5,
    'closed',
    true,
    'Kabel instalasi sudah berusia 15 tahun tanpa penggantian. Tidak ada program preventive maintenance electrical. Perlu electrical safety audit menyeluruh.',
    ARRAY['Program preventive maintenance electrical system', 'Penggantian kabel berkala sesuai umur pakai', 'Electrical safety inspection rutin oleh teknisi bersertifikat', 'Thermal imaging inspection untuk deteksi dini hotspot', 'Pemasangan MCB dan ELCB yang sesuai']::TEXT[],
    '2024-11-17',
    '2024-11-16',
    (SELECT id FROM pegawai WHERE email = 'admin@hsse.com' LIMIT 1)
);

-- ========================================
-- 2. LTIFR RECORDS DATA
-- ========================================

-- LTIFR November 2024 - 1 LTI case
INSERT INTO ltifr_records (
    periode_bulan,
    unit_id,
    jumlah_lti,
    jumlah_fatality,
    jumlah_near_miss,
    jumlah_pekerja,
    hari_kerja,
    jam_kerja_per_hari,
    total_jam_kerja,
    ltifr,
    deskripsi_kecelakaan,
    tindakan_perbaikan,
    pic_penanggung_jawab
) VALUES (
    '2024-11',
    (SELECT id FROM units WHERE nama = 'Tanjung Perak' LIMIT 1),
    1,
    0,
    0,
    50,
    22,
    8.00,
    8800,
    113.64,
    'Operator forklift terluka saat menurunkan container. Kaki terjepit antara container dan forklift, mengakibatkan fraktur metatarsal. Korban mendapat perawatan medis dan istirahat 14 hari.',
    'Investigasi kecelakaan dilakukan, retraining forklift operator, implementasi prosedur komunikasi yang lebih baik, penyediaan spotter untuk operasi berisiko tinggi',
    'HSE Manager'
);

-- LTIFR Oktober 2024 - Zero accident
INSERT INTO ltifr_records (
    periode_bulan,
    unit_id,
    jumlah_lti,
    jumlah_fatality,
    jumlah_near_miss,
    jumlah_pekerja,
    hari_kerja,
    jam_kerja_per_hari,
    total_jam_kerja,
    ltifr,
    deskripsi_kecelakaan,
    pic_penanggung_jawab
) VALUES (
    '2024-10',
    (SELECT id FROM units WHERE nama = 'Tanjung Perak' LIMIT 1),
    0,
    0,
    0,
    50,
    23,
    8.00,
    9200,
    0.00,
    'Tidak ada kecelakaan kerja pada bulan ini. Zero accident achievement.',
    'HSE Manager'
);

-- ========================================
-- 3. MANAGEMENT WALKTHROUGH DATA
-- ========================================

-- Walkthrough 1: Inspection Terminal Area
INSERT INTO management_walkthrough (
    nomor_walkthrough,
    tanggal_walkthrough,
    waktu_mulai,
    waktu_selesai,
    unit_id,
    area_inspeksi,
    pimpinan_walkthrough,
    anggota_tim,
    jumlah_tim,
    jenis_walkthrough,
    kondisi_housekeeping,
    kondisi_pencahayaan,
    pekerja_diamati,
    jumlah_temuan,
    temuan_kritis,
    temuan_mayor,
    temuan_minor,
    ringkasan_observasi,
    rekomendasi,
    praktek_baik,
    catatan_khusus,
    status,
    skor_keseluruhan,
    skor_housekeeping,
    created_by
) VALUES (
    'MW-2024-11-001',
    '2024-11-10',
    '08:00',
    '11:30',
    (SELECT id FROM units WHERE nama = 'Tanjung Emas' LIMIT 1),
    'Terminal Peti Kemas dan Area Gudang',
    'Manager Operasional',
    '["HSE Coordinator", "Supervisor Lapangan", "Safety Officer"]'::jsonb,
    3,
    'rutin',
    'cukup',
    'kurang',
    25,
    4,
    0,
    2,
    2,
    'Inspeksi menyeluruh kondisi terminal, ditemukan beberapa area yang perlu perbaikan terkait housekeeping dan marking. Secara umum kondisi baik namun ada improvement area.',
    '["Pengecatan ulang marking dan marka jalan", "Implementasi sistem penyimpanan pallet yang teratur", "Penambahan lampu LED di area gelap", "Pemasangan signage forklift operation area"]'::jsonb,
    '["Area loading sudah menerapkan sistem zone marking dengan baik", "Tim housekeeping bekerja dengan koordinasi baik", "Emergency assembly point sudah jelas dan well-maintained"]'::jsonb,
    'Housekeeping dan marking yang baik mencegah kecelakaan. Area kerja yang rapi meningkatkan produktivitas dan keselamatan. Perlu konsistensi dalam maintenance area.',
    'completed',
    75,
    70,
    (SELECT id FROM pegawai WHERE email = 'admin@hsse.com' LIMIT 1)
);

-- Walkthrough 2: Workshop Inspection
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
    jenis_walkthrough,
    kondisi_housekeeping,
    kepatuhan_apd,
    pekerja_diamati,
    perilaku_aman,
    perilaku_tidak_aman,
    jumlah_temuan,
    temuan_kritis,
    temuan_mayor,
    ringkasan_observasi,
    rekomendasi,
    praktek_baik,
    catatan_khusus,
    status,
    skor_keseluruhan,
    skor_housekeeping,
    skor_apd,
    created_by
) VALUES (
    'MW-2024-11-002',
    '2024-11-20',
    '09:00',
    '12:00',
    (SELECT id FROM units WHERE nama = 'Benoa' LIMIT 1),
    'Workshop Maintenance dan Tool Room',
    'Maintenance',
    'General Manager',
    '["EHS Manager", "Workshop Supervisor", "HSE Officer"]'::jsonb,
    3,
    'rutin',
    'kurang',
    65,
    18,
    15,
    3,
    4,
    2,
    2,
    'Review kondisi workshop dan tool management, ditemukan potensi bahaya pada beberapa peralatan. Kepatuhan APD masih perlu ditingkatkan. Chemical storage perlu reorganisasi.',
    '["Pasang safety guard pada semua gerinda", "Penyediaan cable reel dan kabel management system", "Instalasi eye wash station dan safety shower", "Reorganisasi chemical storage sesuai kompatibilitas", "Training proper tool usage untuk semua teknisi"]'::jsonb,
    '["Sistem tool management dengan barcode scanning sudah berjalan baik", "Preventive maintenance schedule sudah tertib", "Tool calibration record lengkap dan up-to-date"]'::jsonb,
    'Safety device pada power tools harus selalu terpasang. Chemical storage yang tidak proper dapat menyebabkan reaksi berbahaya. Perlu enforcement aturan APD yang lebih ketat.',
    'completed',
    68,
    60,
    65,
    (SELECT id FROM pegawai WHERE email = 'admin@hsse.com' LIMIT 1)
);

-- ========================================
-- 4. SAFETY PATROL DATA
-- ========================================

-- Patrol 1: Morning Shift
INSERT INTO safety_patrol (
    nomor_patrol,
    tanggal_patrol,
    waktu_mulai,
    waktu_selesai,
    shift,
    area_patrol,
    ketua_patrol,
    catatan_patrol,
    rekomendasi,
    status,
    unit_id,
    created_by
) VALUES (
    'SP-2024-11-001',
    '2024-11-07',
    '07:00',
    '09:00',
    'pagi',
    'Area Lapangan dan Terminal',
    'Safety Officer',
    'Temuan: Pekerja merokok di area non-smoking, sampah berserakan di dekat container, fire extinguisher tidak terpasang di bracket. Analisis: Merokok di area non-smoking dapat memicu kebakaran, housekeeping buruk menunjukkan lemahnya disiplin K3',
    ARRAY['Pekerja diberi teguran dan edukasi, dipindahkan ke smoking area', 'Pembersihan dilakukan segera, penambahan tempat sampah', 'APAR dipasang kembali, pengecekan seluruh APAR di area']::TEXT[],
    'closed',
    (SELECT id FROM units WHERE nama = 'Tanjung Perak' LIMIT 1),
    (SELECT id FROM pegawai WHERE email = 'admin@hsse.com' LIMIT 1)
);

-- Patrol 2: Afternoon Shift
INSERT INTO safety_patrol (
    nomor_patrol,
    tanggal_patrol,
    waktu_mulai,
    waktu_selesai,
    shift,
    area_patrol,
    ketua_patrol,
    catatan_patrol,
    rekomendasi,
    status,
    unit_id,
    created_by
) VALUES (
    'SP-2024-11-002',
    '2024-11-14',
    '13:00',
    '15:30',
    'siang',
    'Warehouse dan Loading Area',
    'HSE Supervisor',
    'Temuan: Forklift berjalan dengan kecepatan tinggi, pekerja tidak menggunakan sepatu safety, material blocking jalur evakuasi. Analisis: Kecepatan forklift berlebihan meningkatkan risiko collision, emergency route harus selalu clear',
    ARRAY['Operator forklift diberi peringatan tertulis, speed limit dipasang', 'Pekerja diwajibkan ke locker untuk mengambil safety shoes', 'Material dipindahkan, marking emergency exit diperjelas']::TEXT[],
    'closed',
    (SELECT id FROM units WHERE nama = 'Tanjung Emas' LIMIT 1),
    (SELECT id FROM pegawai WHERE email = 'admin@hsse.com' LIMIT 1)
);

-- Patrol 3: Night Shift
INSERT INTO safety_patrol (
    nomor_patrol,
    tanggal_patrol,
    waktu_mulai,
    waktu_selesai,
    shift,
    area_patrol,
    ketua_patrol,
    catatan_patrol,
    rekomendasi,
    status,
    unit_id,
    created_by
) VALUES (
    'SP-2024-11-003',
    '2024-11-18',
    '20:00',
    '22:30',
    'malam',
    'Container Yard Night Operation',
    'Night Shift Supervisor',
    'Temuan: Penerangan kurang di corner area, tidak ada high-vis vest pada pekerja malam, radio komunikasi tidak berfungsi dengan baik. Analisis: Visibility di malam hari sangat penting untuk keselamatan, komunikasi yang baik mencegah miscommunication yang berbahaya',
    ARRAY['Penambahan portable light tower di area gelap', 'Distribusi high-vis vest reflective ke semua pekerja shift malam', 'Penggantian battery radio, pengadaan radio cadangan']::TEXT[],
    'closed',
    (SELECT id FROM units WHERE nama = 'Benoa' LIMIT 1),
    (SELECT id FROM pegawai WHERE email = 'admin@hsse.com' LIMIT 1)
);

-- ========================================
-- 5. SAFETY DRILL DATA (Already exists in your file)
-- ========================================
-- Data safety drill sudah ada di file insert-sample-safety-drill-data-fixed.sql

-- Verification Queries
SELECT 'Unsafe Action/Condition' as table_name, COUNT(*) as total FROM unsafe_action_condition WHERE tanggal_kejadian >= '2024-11-01' AND tanggal_kejadian < '2024-12-01'
UNION ALL
SELECT 'LTIFR Records', COUNT(*) FROM ltifr_records WHERE periode_bulan >= '2024-11' AND periode_bulan < '2024-12'
UNION ALL
SELECT 'Management Walkthrough', COUNT(*) FROM management_walkthrough WHERE tanggal_walkthrough >= '2024-11-01' AND tanggal_walkthrough < '2024-12-01'
UNION ALL
SELECT 'Safety Patrol', COUNT(*) FROM safety_patrol WHERE tanggal_patrol >= '2024-11-01' AND tanggal_patrol < '2024-12-01'
UNION ALL
SELECT 'Safety Drill', COUNT(*) FROM safety_drill WHERE tanggal_drill >= '2024-11-01' AND tanggal_drill < '2024-12-01';
