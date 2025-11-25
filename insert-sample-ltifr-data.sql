-- Insert Sample LTIFR Data
-- Pastikan semua field sesuai dengan struktur tabel ltifr_records

-- Sample data untuk berbagai unit dan periode
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
) VALUES
-- Januari 2025 - Tanjung Perak
(
    '2025-01',
    (SELECT id FROM units WHERE nama = 'Tanjung Perak' LIMIT 1),
    2,
    0,
    5,
    150,
    22,
    8,
    26400, -- 150 × 22 × 8
    75.76, -- (2 × 1000000) / 26400
    'Kecelakaan kerja ringan: 1 pekerja terluka akibat tersandung material di area loading, 1 pekerja tangan terjepit saat operasi forklift',
    'Penataan ulang area kerja, briefing keselamatan ditingkatkan, APD diperiksa rutin sebelum shift, training ulang operator forklift',
    'Budi Santoso - Manager Operations'
),

-- Februari 2025 - Tanjung Perak
(
    '2025-02',
    (SELECT id FROM units WHERE nama = 'Tanjung Perak' LIMIT 1),
    1,
    0,
    3,
    150,
    20,
    8,
    24000, -- 150 × 20 × 8
    41.67, -- (1 × 1000000) / 24000
    'Kecelakaan kerja: 1 pekerja mengalami luka ringan saat operasi crane, kabel sling putus dan mengenai kaki pekerja',
    'Training ulang operator crane, inspeksi crane dijadwalkan rutin 2x seminggu, safety briefing sebelum setiap shift, penggantian kabel sling yang sudah aus',
    'Ahmad Hidayat - Supervisor K3'
),

-- Januari 2025 - Gresik (Zero Accident)
(
    '2025-01',
    (SELECT id FROM units WHERE nama = 'Gresik' LIMIT 1),
    0,
    0,
    2,
    80,
    22,
    8,
    14080, -- 80 × 22 × 8
    0.00, -- (0 × 1000000) / 14080
    'Tidak ada kecelakaan kerja. 2 near miss terkait material handling: material hampir jatuh dari conveyor belt, pekerja hampir tersandung di area gelap',
    'Evaluasi prosedur material handling, perbaikan sistem pencahayaan di area gelap, safety awareness campaign, pemasangan rambu peringatan tambahan',
    'Siti Nurhaliza - HSE Coordinator'
),

-- Maret 2025 - Tanjung Perak (Zero Accident)
(
    '2025-03',
    (SELECT id FROM units WHERE nama = 'Tanjung Perak' LIMIT 1),
    0,
    0,
    4,
    155,
    21,
    8,
    26040, -- 155 × 21 × 8
    0.00,
    'Zero accident. 4 near miss: 2 terkait forklift nyaris menabrak pekerja, 1 material hampir terjatuh, 1 kabel listrik terkelupas',
    'Program 5S ditingkatkan, morning briefing fokus pada keselamatan, perbaikan kabel listrik, jalur forklift dipisahkan dari jalur pejalan kaki',
    'Budi Santoso - Manager Operations'
),

-- Februari 2025 - Gresik
(
    '2025-02',
    (SELECT id FROM units WHERE nama = 'Gresik' LIMIT 1),
    1,
    0,
    1,
    82,
    20,
    8,
    13120, -- 82 × 20 × 8
    76.22, -- (1 × 1000000) / 13120
    'Kecelakaan kerja: 1 pekerja tergelincir di lantai licin area unloading, mengalami cedera ringan di lutut',
    'Pemasangan rambu anti slip, pembersihan lantai rutin 3x sehari, wajib menggunakan sepatu safety anti slip, penambahan titik lampu di area gelap',
    'Andi Wijaya - Supervisor Operasional'
),

-- Januari 2025 - Tanjung Emas
(
    '2025-01',
    (SELECT id FROM units WHERE nama = 'Tanjung Emas' LIMIT 1),
    0,
    0,
    3,
    60,
    22,
    8,
    10560, -- 60 × 22 × 8
    0.00,
    'Zero accident. 3 near miss: 1 valve bocor hampir terkena pekerja, 1 tumpahan chemical minor, 1 pekerja nyaris terpeleset',
    'Inspeksi valve dijadwalkan mingguan, training chemical handling, perbaikan drainage area, SOP emergency response di-review',
    'Dewi Kusuma - HSE Officer'
),

-- Maret 2025 - Gresik
(
    '2025-03',
    (SELECT id FROM units WHERE nama = 'Gresik' LIMIT 1),
    0,
    0,
    1,
    85,
    23,
    8,
    15640, -- 85 × 23 × 8
    0.00,
    'Zero accident. 1 near miss: pekerja nyaris tertimpa material dari tumpukan yang tidak tertata rapi',
    'Program 5S implementasi konsisten, inspeksi area penyimpanan setiap shift, training stacking procedure, audit housekeeping mingguan',
    'Rudi Hermawan - Manager Operasi'
),

-- Februari 2025 - Tanjung Emas
(
    '2025-02',
    (SELECT id FROM units WHERE nama = 'Tanjung Emas' LIMIT 1),
    1,
    0,
    2,
    62,
    19,
    8,
    9424, -- 62 × 19 × 8
    106.12, -- (1 × 1000000) / 9424
    'Kecelakaan kerja: 1 pekerja terkena percikan chemical saat transfer produk, mengalami iritasi kulit ringan',
    'Review SOP transfer product, wajib double check APD sebelum kerja dengan chemical, penyediaan eyewash station tambahan, training chemical safety refresh',
    'Hendra Gunawan - Supervisor K3'
),

-- Maret 2025 - Tanjung Emas (Zero Accident - Improvement)
(
    '2025-03',
    (SELECT id FROM units WHERE nama = 'Tanjung Emas' LIMIT 1),
    0,
    0,
    0,
    65,
    22,
    8,
    11440, -- 65 × 22 × 8
    0.00,
    'Zero accident dan zero near miss! Hasil implementasi safety improvement bulan sebelumnya menunjukkan hasil positif',
    'Pertahankan program safety yang sudah berjalan, reward & recognition untuk tim yang maintain zero accident, safety culture campaign berkelanjutan',
    'Dewi Kusuma - HSE Officer'
),

-- Januari 2025 - Benoa
(
    '2025-01',
    (SELECT id FROM units WHERE nama = 'Benoa' LIMIT 1),
    0,
    0,
    5,
    45,
    22,
    8,
    7920, -- 45 × 22 × 8
    0.00,
    'Zero accident. 5 near miss: semua terkait passenger handling - penumpang nyaris terpeleset, kursi roda nyaris terguling, dll',
    'Review SOP passenger handling, training crew, perbaikan jalur evakuasi, penambahan handrail, floor marking lebih jelas',
    'Sari Indah - Customer Service Manager'
),

-- Januari 2025 - Banjarmasin
(
    '2025-01',
    (SELECT id FROM units WHERE nama = 'Banjarmasin' LIMIT 1),
    1,
    0,
    2,
    55,
    22,
    8,
    9680, -- 55 × 22 × 8
    103.31, -- (1 × 1000000) / 9680
    'Kecelakaan kerja: 1 pekerja jatuh dari tangga saat melakukan maintenance, cedera ringan pada tangan',
    'Training bekerja di ketinggian, wajib menggunakan safety harness, inspeksi tangga sebelum digunakan, pemasangan safety net',
    'Bambang Suryono - Safety Officer'
),

-- Februari 2025 - Benoa
(
    '2025-02',
    (SELECT id FROM units WHERE nama = 'Benoa' LIMIT 1),
    0,
    0,
    3,
    47,
    20,
    8,
    7520, -- 47 × 20 × 8
    0.00,
    'Zero accident. 3 near miss: 2 terkait gangway penumpang, 1 equipment nyaris jatuh',
    'Inspeksi gangway sebelum setiap keberangkatan, training crew handling passenger dengan disability, audit safety equipment',
    'Made Sutama - Operations Manager'
),

-- Maret 2025 - Banjarmasin
(
    '2025-03',
    (SELECT id FROM units WHERE nama = 'Banjarmasin' LIMIT 1),
    0,
    0,
    1,
    58,
    21,
    8,
    9744, -- 58 × 21 × 8
    0.00,
    'Zero accident. 1 near miss: pekerja nyaris terkena swing boom crane',
    'Training crane operation awareness, pemasangan barrier area kerja crane, safety signage ditambah, komunikasi radio mandatory',
    'Agus Setiawan - Supervisor K3'
);

-- Verification query
SELECT 
    periode_bulan,
    u.nama as unit,
    jumlah_lti,
    jumlah_fatality,
    jumlah_near_miss,
    jumlah_pekerja,
    hari_kerja,
    jam_kerja_per_hari,
    total_jam_kerja,
    ltifr,
    pic_penanggung_jawab
FROM ltifr_records
LEFT JOIN units u ON u.id = ltifr_records.unit_id
ORDER BY periode_bulan DESC, ltifr DESC;
