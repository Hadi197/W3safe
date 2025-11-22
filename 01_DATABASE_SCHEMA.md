# 📊 Database Schema - Aplikasi Implementasi HSSE

## Overview
Database menggunakan PostgreSQL (Supabase) dengan struktur relasional yang normalized.

---

## 1. Tabel Master

### 1.1 Tabel `units`
**Deskripsi**: Master data Unit organisasi

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT uuid_generate_v4() | ID unik unit |
| kode_unit | VARCHAR(20) | UNIQUE, NOT NULL | Kode unit (misal: "UNIT-001") |
| nama_unit | VARCHAR(100) | NOT NULL | Nama unit (misal: "Unit Produksi A") |
| lokasi | VARCHAR(200) | NULL | Lokasi fisik unit |
| manager_id | UUID | FOREIGN KEY (pegawai.id), NULL | Manager unit |
| status | VARCHAR(20) | NOT NULL, DEFAULT 'aktif' | aktif / nonaktif |
| created_at | TIMESTAMP | DEFAULT now() | Waktu dibuat |
| updated_at | TIMESTAMP | DEFAULT now() | Waktu update terakhir |

**Index**:
- `idx_units_kode` ON kode_unit
- `idx_units_status` ON status

**Contoh Data**:
```json
{
  "id": "a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d",
  "kode_unit": "UNIT-001",
  "nama_unit": "Unit Produksi A",
  "lokasi": "Gedung A Lantai 2",
  "manager_id": "m1n2o3p4-q5r6-7s8t-9u0v-w1x2y3z4a5b6",
  "status": "aktif",
  "created_at": "2024-01-15 08:00:00",
  "updated_at": "2024-01-15 08:00:00"
}
```

---

### 1.2 Tabel `wilayah`
**Deskripsi**: Master data Wilayah

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT uuid_generate_v4() | ID unik wilayah |
| kode_wilayah | VARCHAR(20) | UNIQUE, NOT NULL | Kode wilayah |
| nama_wilayah | VARCHAR(100) | NOT NULL | Nama wilayah |
| provinsi | VARCHAR(50) | NULL | Provinsi |
| kota | VARCHAR(50) | NULL | Kota/Kabupaten |
| pic_id | UUID | FOREIGN KEY (pegawai.id), NULL | PIC wilayah |
| status | VARCHAR(20) | NOT NULL, DEFAULT 'aktif' | aktif / nonaktif |
| created_at | TIMESTAMP | DEFAULT now() | Waktu dibuat |
| updated_at | TIMESTAMP | DEFAULT now() | Waktu update terakhir |

**Index**:
- `idx_wilayah_kode` ON kode_wilayah
- `idx_wilayah_status` ON status

**Contoh Data**:
```json
{
  "id": "b2c3d4e5-f6a7-4b5c-8d9e-0f1a2b3c4d5e",
  "kode_wilayah": "WIL-JKT-01",
  "nama_wilayah": "Wilayah Jakarta Pusat",
  "provinsi": "DKI Jakarta",
  "kota": "Jakarta Pusat",
  "pic_id": "p1q2r3s4-t5u6-7v8w-9x0y-z1a2b3c4d5e6",
  "status": "aktif",
  "created_at": "2024-01-15 08:00:00",
  "updated_at": "2024-01-15 08:00:00"
}
```

---

### 1.3 Tabel `pegawai`
**Deskripsi**: Master data Pegawai/User

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT uuid_generate_v4() | ID unik pegawai |
| nip | VARCHAR(30) | UNIQUE, NOT NULL | Nomor Induk Pegawai |
| nama_lengkap | VARCHAR(150) | NOT NULL | Nama lengkap pegawai |
| email | VARCHAR(100) | UNIQUE, NOT NULL | Email pegawai |
| phone | VARCHAR(20) | NULL | Nomor telepon |
| jabatan | VARCHAR(100) | NULL | Jabatan |
| unit_id | UUID | FOREIGN KEY (units.id), NULL | Unit pegawai |
| wilayah_id | UUID | FOREIGN KEY (wilayah.id), NULL | Wilayah pegawai |
| role | VARCHAR(20) | NOT NULL, DEFAULT 'user' | admin / manager / user |
| photo_url | TEXT | NULL | URL foto profil |
| status | VARCHAR(20) | NOT NULL, DEFAULT 'aktif' | aktif / nonaktif / cuti |
| tanggal_bergabung | DATE | NULL | Tanggal bergabung |
| created_at | TIMESTAMP | DEFAULT now() | Waktu dibuat |
| updated_at | TIMESTAMP | DEFAULT now() | Waktu update terakhir |

**Index**:
- `idx_pegawai_nip` ON nip
- `idx_pegawai_email` ON email
- `idx_pegawai_unit` ON unit_id
- `idx_pegawai_wilayah` ON wilayah_id
- `idx_pegawai_role` ON role

**Contoh Data**:
```json
{
  "id": "c3d4e5f6-a7b8-4c5d-9e0f-1a2b3c4d5e6f",
  "nip": "EMP-2024-001",
  "nama_lengkap": "Budi Santoso",
  "email": "budi.santoso@company.com",
  "phone": "081234567890",
  "jabatan": "Safety Officer",
  "unit_id": "a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d",
  "wilayah_id": "b2c3d4e5-f6a7-4b5c-8d9e-0f1a2b3c4d5e",
  "role": "user",
  "photo_url": "https://storage.supabase.co/photos/budi.jpg",
  "status": "aktif",
  "tanggal_bergabung": "2023-06-15",
  "created_at": "2024-01-15 08:00:00",
  "updated_at": "2024-01-15 08:00:00"
}
```

---

### 1.4 Tabel `tamu_eksternal`
**Deskripsi**: Data tamu eksternal untuk Safety Induction

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT uuid_generate_v4() | ID unik tamu |
| nama_lengkap | VARCHAR(150) | NOT NULL | Nama lengkap tamu |
| perusahaan | VARCHAR(100) | NULL | Nama perusahaan |
| email | VARCHAR(100) | NULL | Email tamu |
| phone | VARCHAR(20) | NULL | Nomor telepon |
| nik | VARCHAR(30) | NULL | NIK tamu |
| foto_identitas_url | TEXT | NULL | URL foto KTP/Passport |
| created_at | TIMESTAMP | DEFAULT now() | Waktu dibuat |
| updated_at | TIMESTAMP | DEFAULT now() | Waktu update terakhir |

**Index**:
- `idx_tamu_email` ON email

**Contoh Data**:
```json
{
  "id": "d4e5f6a7-b8c9-4d5e-0f1a-2b3c4d5e6f7a",
  "nama_lengkap": "Ahmad Hidayat",
  "perusahaan": "PT Kontraktor ABC",
  "email": "ahmad@kontraktor-abc.com",
  "phone": "082345678901",
  "nik": "3174012345678901",
  "foto_identitas_url": "https://storage.supabase.co/identitas/ahmad_ktp.jpg",
  "created_at": "2024-11-20 09:00:00",
  "updated_at": "2024-11-20 09:00:00"
}
```

---

## 2. Tabel Transaksi HSSE

### 2.1 Tabel `safety_briefing`
**Deskripsi**: Safety Briefing dilakukan setiap hari oleh Unit dan Wilayah

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT uuid_generate_v4() | ID unik |
| unit_id | UUID | FOREIGN KEY (units.id), NULL | Unit yang melaksanakan |
| wilayah_id | UUID | FOREIGN KEY (wilayah.id), NULL | Wilayah yang melaksanakan |
| tanggal | DATE | NOT NULL | Tanggal briefing |
| waktu_mulai | TIME | NOT NULL | Waktu mulai briefing |
| waktu_selesai | TIME | NULL | Waktu selesai briefing |
| petugas_id | UUID | FOREIGN KEY (pegawai.id), NOT NULL | Petugas yang memimpin |
| lokasi | VARCHAR(200) | NULL | Lokasi briefing |
| topik | VARCHAR(200) | NOT NULL | Topik briefing |
| materi | TEXT | NULL | Materi briefing |
| jumlah_peserta | INTEGER | DEFAULT 0 | Jumlah peserta hadir |
| peserta_ids | JSONB | NULL | Array UUID peserta |
| temuan | TEXT | NULL | Temuan/issue yang dibahas |
| tindak_lanjut | TEXT | NULL | Tindak lanjut yang diperlukan |
| lampiran_url | TEXT | NULL | URL foto/dokumen |
| status | VARCHAR(20) | NOT NULL, DEFAULT 'draft' | draft / submitted / approved |
| approved_by | UUID | FOREIGN KEY (pegawai.id), NULL | Yang menyetujui |
| approved_at | TIMESTAMP | NULL | Waktu approval |
| created_by | UUID | FOREIGN KEY (pegawai.id), NOT NULL | Pembuat record |
| created_at | TIMESTAMP | DEFAULT now() | Waktu dibuat |
| updated_at | TIMESTAMP | DEFAULT now() | Waktu update terakhir |

**Index**:
- `idx_safety_briefing_tanggal` ON tanggal
- `idx_safety_briefing_unit` ON unit_id
- `idx_safety_briefing_wilayah` ON wilayah_id
- `idx_safety_briefing_status` ON status
- `idx_safety_briefing_composite` ON (tanggal, unit_id, wilayah_id)

**Contoh Data**:
```json
{
  "id": "e5f6a7b8-c9d0-4e5f-1a2b-3c4d5e6f7a8b",
  "unit_id": "a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d",
  "wilayah_id": null,
  "tanggal": "2024-11-22",
  "waktu_mulai": "07:30:00",
  "waktu_selesai": "07:45:00",
  "petugas_id": "c3d4e5f6-a7b8-4c5d-9e0f-1a2b3c4d5e6f",
  "lokasi": "Ruang Meeting A",
  "topik": "Keselamatan Operasi Mesin Press",
  "materi": "1. Penggunaan APD wajib\n2. Prosedur emergency stop\n3. Area berbahaya sekitar mesin",
  "jumlah_peserta": 12,
  "peserta_ids": ["c3d4e5f6-a7b8-4c5d-9e0f-1a2b3c4d5e6f", "d4e5f6a7-b8c9-4d5e-0f1a-2b3c4d5e6f7a"],
  "temuan": "Beberapa operator belum menggunakan sarung tangan safety",
  "tindak_lanjut": "Supervisor akan melakukan monitoring penggunaan APD",
  "lampiran_url": "https://storage.supabase.co/briefing/2024-11-22-photo.jpg",
  "status": "approved",
  "approved_by": "m1n2o3p4-q5r6-7s8t-9u0v-w1x2y3z4a5b6",
  "approved_at": "2024-11-22 08:00:00",
  "created_by": "c3d4e5f6-a7b8-4c5d-9e0f-1a2b3c4d5e6f",
  "created_at": "2024-11-22 07:50:00",
  "updated_at": "2024-11-22 08:00:00"
}
```

---

### 2.2 Tabel `silent_inspection`
**Deskripsi**: Silent Inspection per triwulan (Unit dan Wilayah)

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT uuid_generate_v4() | ID unik |
| unit_id | UUID | FOREIGN KEY (units.id), NULL | Unit yang diinspeksi |
| wilayah_id | UUID | FOREIGN KEY (wilayah.id), NULL | Wilayah yang diinspeksi |
| tanggal | DATE | NOT NULL | Tanggal inspeksi |
| triwulan | INTEGER | NOT NULL CHECK (triwulan BETWEEN 1 AND 4) | Triwulan (1-4) |
| tahun | INTEGER | NOT NULL | Tahun |
| inspector_id | UUID | FOREIGN KEY (pegawai.id), NOT NULL | Inspector |
| area_inspeksi | VARCHAR(200) | NOT NULL | Area yang diinspeksi |
| checklist | JSONB | NULL | Checklist items (array objects) |
| skor_total | DECIMAL(5,2) | NULL | Skor total inspeksi (0-100) |
| kategori_temuan | VARCHAR(50) | NULL | critical / major / minor |
| temuan | TEXT | NULL | Deskripsi temuan |
| rekomendasi | TEXT | NULL | Rekomendasi perbaikan |
| pic_perbaikan_id | UUID | FOREIGN KEY (pegawai.id), NULL | PIC untuk perbaikan |
| target_selesai | DATE | NULL | Target tanggal selesai |
| tanggal_selesai | DATE | NULL | Tanggal aktual selesai |
| lampiran_url | TEXT | NULL | URL foto/dokumen |
| status | VARCHAR(20) | NOT NULL, DEFAULT 'draft' | draft / submitted / approved / closed |
| approved_by | UUID | FOREIGN KEY (pegawai.id), NULL | Yang menyetujui |
| approved_at | TIMESTAMP | NULL | Waktu approval |
| created_by | UUID | FOREIGN KEY (pegawai.id), NOT NULL | Pembuat record |
| created_at | TIMESTAMP | DEFAULT now() | Waktu dibuat |
| updated_at | TIMESTAMP | DEFAULT now() | Waktu update terakhir |

**Index**:
- `idx_silent_inspection_tanggal` ON tanggal
- `idx_silent_inspection_triwulan` ON (tahun, triwulan)
- `idx_silent_inspection_unit` ON unit_id
- `idx_silent_inspection_wilayah` ON wilayah_id
- `idx_silent_inspection_status` ON status

**Contoh Data**:
```json
{
  "id": "f6a7b8c9-d0e1-4f5a-2b3c-4d5e6f7a8b9c",
  "unit_id": "a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d",
  "wilayah_id": null,
  "tanggal": "2024-10-15",
  "triwulan": 4,
  "tahun": 2024,
  "inspector_id": "c3d4e5f6-a7b8-4c5d-9e0f-1a2b3c4d5e6f",
  "area_inspeksi": "Workshop Maintenance",
  "checklist": [
    {"item": "APD lengkap tersedia", "status": "ok", "catatan": ""},
    {"item": "APAR dalam kondisi baik", "status": "not_ok", "catatan": "1 unit expired"},
    {"item": "Housekeeping area kerja", "status": "ok", "catatan": ""}
  ],
  "skor_total": 85.50,
  "kategori_temuan": "minor",
  "temuan": "1 unit APAR expired tanggal Oktober 2024",
  "rekomendasi": "Segera replace APAR yang expired dan update sticker maintenance",
  "pic_perbaikan_id": "d4e5f6a7-b8c9-4d5e-0f1a-2b3c4d5e6f7a",
  "target_selesai": "2024-10-20",
  "tanggal_selesai": "2024-10-18",
  "lampiran_url": "https://storage.supabase.co/inspection/2024-q4-workshop.jpg",
  "status": "closed",
  "approved_by": "m1n2o3p4-q5r6-7s8t-9u0v-w1x2y3z4a5b6",
  "approved_at": "2024-10-16 10:00:00",
  "created_by": "c3d4e5f6-a7b8-4c5d-9e0f-1a2b3c4d5e6f",
  "created_at": "2024-10-15 14:30:00",
  "updated_at": "2024-10-18 16:00:00"
}
```

---

### 2.3 Tabel `safety_forum`
**Deskripsi**: Safety Forum per triwulan (Unit dan Wilayah)

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT uuid_generate_v4() | ID unik |
| unit_id | UUID | FOREIGN KEY (units.id), NULL | Unit penyelenggara |
| wilayah_id | UUID | FOREIGN KEY (wilayah.id), NULL | Wilayah penyelenggara |
| tanggal | DATE | NOT NULL | Tanggal forum |
| triwulan | INTEGER | NOT NULL CHECK (triwulan BETWEEN 1 AND 4) | Triwulan (1-4) |
| tahun | INTEGER | NOT NULL | Tahun |
| waktu_mulai | TIME | NOT NULL | Waktu mulai |
| waktu_selesai | TIME | NULL | Waktu selesai |
| moderator_id | UUID | FOREIGN KEY (pegawai.id), NOT NULL | Moderator forum |
| lokasi | VARCHAR(200) | NOT NULL | Lokasi forum |
| tema | VARCHAR(200) | NOT NULL | Tema forum |
| agenda | TEXT | NULL | Agenda pembahasan |
| jumlah_peserta | INTEGER | DEFAULT 0 | Jumlah peserta |
| peserta_ids | JSONB | NULL | Array UUID peserta |
| pembicara | VARCHAR(200) | NULL | Nama pembicara/narasumber |
| ringkasan | TEXT | NULL | Ringkasan hasil forum |
| keputusan | TEXT | NULL | Keputusan/action items |
| notulen | TEXT | NULL | Notulen lengkap |
| lampiran_url | TEXT | NULL | URL foto/dokumen/presentasi |
| status | VARCHAR(20) | NOT NULL, DEFAULT 'draft' | draft / submitted / approved |
| approved_by | UUID | FOREIGN KEY (pegawai.id), NULL | Yang menyetujui |
| approved_at | TIMESTAMP | NULL | Waktu approval |
| created_by | UUID | FOREIGN KEY (pegawai.id), NOT NULL | Pembuat record |
| created_at | TIMESTAMP | DEFAULT now() | Waktu dibuat |
| updated_at | TIMESTAMP | DEFAULT now() | Waktu update terakhir |

**Index**:
- `idx_safety_forum_tanggal` ON tanggal
- `idx_safety_forum_triwulan` ON (tahun, triwulan)
- `idx_safety_forum_unit` ON unit_id
- `idx_safety_forum_wilayah` ON wilayah_id
- `idx_safety_forum_status` ON status

**Contoh Data**:
```json
{
  "id": "a7b8c9d0-e1f2-4a5b-3c4d-5e6f7a8b9c0d",
  "unit_id": null,
  "wilayah_id": "b2c3d4e5-f6a7-4b5c-8d9e-0f1a2b3c4d5e",
  "tanggal": "2024-09-25",
  "triwulan": 3,
  "tahun": 2024,
  "waktu_mulai": "13:00:00",
  "waktu_selesai": "15:30:00",
  "moderator_id": "p1q2r3s4-t5u6-7v8w-9x0y-z1a2b3c4d5e6",
  "lokasi": "Ruang Auditorium Wilayah Jakarta",
  "tema": "Zero Accident Program & Best Practices Q3 2024",
  "agenda": "1. Review incident Q3\n2. Sharing best practices\n3. Target Q4\n4. Q&A",
  "jumlah_peserta": 45,
  "peserta_ids": ["c3d4e5f6-a7b8-4c5d-9e0f-1a2b3c4d5e6f", "d4e5f6a7-b8c9-4d5e-0f1a-2b3c4d5e6f7a"],
  "pembicara": "Ir. Siti Nurhaliza, HSE Manager",
  "ringkasan": "Forum membahas pencapaian zero accident selama 90 hari di Unit A dan sharing program safety patrol yang efektif",
  "keputusan": "1. Adopsi program safety patrol model Unit A ke unit lain\n2. Intensifkan training APD bulan Oktober\n3. Budget tambahan untuk upgrade APAR",
  "notulen": "Forum dibuka pukul 13:00... [notulen lengkap]",
  "lampiran_url": "https://storage.supabase.co/forum/2024-q3-presentation.pdf",
  "status": "approved",
  "approved_by": "m1n2o3p4-q5r6-7s8t-9u0v-w1x2y3z4a5b6",
  "approved_at": "2024-09-26 09:00:00",
  "created_by": "p1q2r3s4-t5u6-7v8w-9x0y-z1a2b3c4d5e6",
  "created_at": "2024-09-25 16:00:00",
  "updated_at": "2024-09-26 09:00:00"
}
```

---

### 2.4 Tabel `management_walkthrough`
**Deskripsi**: Management Walkthrough (setiap bulan untuk Unit dan per triwulan untuk Wilayah)

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT uuid_generate_v4() | ID unik |
| unit_id | UUID | FOREIGN KEY (units.id), NULL | Unit yang dikunjungi |
| wilayah_id | UUID | FOREIGN KEY (wilayah.id), NULL | Wilayah yang dikunjungi |
| tanggal | DATE | NOT NULL | Tanggal walkthrough |
| bulan | INTEGER | NOT NULL CHECK (bulan BETWEEN 1 AND 12) | Bulan (1-12) |
| tahun | INTEGER | NOT NULL | Tahun |
| waktu_mulai | TIME | NOT NULL | Waktu mulai |
| waktu_selesai | TIME | NULL | Waktu selesai |
| manager_id | UUID | FOREIGN KEY (pegawai.id), NOT NULL | Manager yang melakukan |
| pendamping_ids | JSONB | NULL | Array UUID pendamping |
| area_kunjungan | TEXT | NOT NULL | Area yang dikunjungi |
| fokus_observasi | VARCHAR(200) | NULL | Fokus observasi |
| temuan_positif | TEXT | NULL | Temuan positif |
| temuan_perbaikan | TEXT | NULL | Temuan yang perlu perbaikan |
| kategori_temuan | VARCHAR(50) | NULL | critical / major / minor / none |
| rekomendasi | TEXT | NULL | Rekomendasi |
| pic_tindak_lanjut_id | UUID | FOREIGN KEY (pegawai.id), NULL | PIC tindak lanjut |
| target_selesai | DATE | NULL | Target selesai |
| lampiran_url | TEXT | NULL | URL foto/dokumen |
| status | VARCHAR(20) | NOT NULL, DEFAULT 'draft' | draft / submitted / approved / closed |
| approved_by | UUID | FOREIGN KEY (pegawai.id), NULL | Yang menyetujui |
| approved_at | TIMESTAMP | NULL | Waktu approval |
| created_by | UUID | FOREIGN KEY (pegawai.id), NOT NULL | Pembuat record |
| created_at | TIMESTAMP | DEFAULT now() | Waktu dibuat |
| updated_at | TIMESTAMP | DEFAULT now() | Waktu update terakhir |

**Index**:
- `idx_walkthrough_tanggal` ON tanggal
- `idx_walkthrough_bulan` ON (tahun, bulan)
- `idx_walkthrough_unit` ON unit_id
- `idx_walkthrough_wilayah` ON wilayah_id
- `idx_walkthrough_status` ON status

**Contoh Data**:
```json
{
  "id": "b8c9d0e1-f2a3-4b5c-4d5e-6f7a8b9c0d1e",
  "unit_id": "a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d",
  "wilayah_id": null,
  "tanggal": "2024-11-15",
  "bulan": 11,
  "tahun": 2024,
  "waktu_mulai": "09:00:00",
  "waktu_selesai": "11:30:00",
  "manager_id": "m1n2o3p4-q5r6-7s8t-9u0v-w1x2y3z4a5b6",
  "pendamping_ids": ["c3d4e5f6-a7b8-4c5d-9e0f-1a2b3c4d5e6f", "d4e5f6a7-b8c9-4d5e-0f1a-2b3c4d5e6f7a"],
  "area_kunjungan": "Workshop Produksi, Gudang Material, Area Loading",
  "fokus_observasi": "Kepatuhan APD, Housekeeping, Safety signage",
  "temuan_positif": "Semua pekerja menggunakan APD lengkap, area workshop rapi dan bersih",
  "temuan_perbaikan": "Safety signage di area loading kurang jelas, perlu penambahan rambu",
  "kategori_temuan": "minor",
  "rekomendasi": "1. Tambah safety signage di area loading\n2. Pertahankan praktik housekeeping yang baik",
  "pic_tindak_lanjut_id": "c3d4e5f6-a7b8-4c5d-9e0f-1a2b3c4d5e6f",
  "target_selesai": "2024-11-30",
  "lampiran_url": "https://storage.supabase.co/walkthrough/2024-11-unit-a.jpg",
  "status": "approved",
  "approved_by": "m1n2o3p4-q5r6-7s8t-9u0v-w1x2y3z4a5b6",
  "approved_at": "2024-11-15 12:00:00",
  "created_by": "m1n2o3p4-q5r6-7s8t-9u0v-w1x2y3z4a5b6",
  "created_at": "2024-11-15 11:45:00",
  "updated_at": "2024-11-15 12:00:00"
}
```

---

### 2.5 Tabel `safety_patrol`
**Deskripsi**: Safety Patrol (setiap hari untuk Unit dan setiap bulan untuk Wilayah)

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT uuid_generate_v4() | ID unik |
| unit_id | UUID | FOREIGN KEY (units.id), NULL | Unit yang dipatroli |
| wilayah_id | UUID | FOREIGN KEY (wilayah.id), NULL | Wilayah yang dipatroli |
| tanggal | DATE | NOT NULL | Tanggal patrol |
| waktu_mulai | TIME | NOT NULL | Waktu mulai patrol |
| waktu_selesai | TIME | NULL | Waktu selesai patrol |
| patrol_leader_id | UUID | FOREIGN KEY (pegawai.id), NOT NULL | Leader patrol |
| anggota_patrol_ids | JSONB | NULL | Array UUID anggota tim |
| area_patrol | TEXT | NOT NULL | Area yang dipatroli |
| rute_patrol | TEXT | NULL | Rute patrol |
| checklist | JSONB | NULL | Checklist patrol items |
| temuan_unsafe_act | TEXT | NULL | Temuan unsafe act |
| temuan_unsafe_condition | TEXT | NULL | Temuan unsafe condition |
| jumlah_temuan | INTEGER | DEFAULT 0 | Total jumlah temuan |
| kategori_temuan | VARCHAR(50) | NULL | critical / major / minor / none |
| tindakan_langsung | TEXT | NULL | Tindakan langsung di tempat |
| tindakan_lanjut | TEXT | NULL | Tindakan lanjut diperlukan |
| pic_tindak_lanjut_id | UUID | FOREIGN KEY (pegawai.id), NULL | PIC tindak lanjut |
| target_selesai | DATE | NULL | Target selesai |
| lampiran_url | TEXT | NULL | URL foto temuan |
| status | VARCHAR(20) | NOT NULL, DEFAULT 'draft' | draft / submitted / approved / closed |
| approved_by | UUID | FOREIGN KEY (pegawai.id), NULL | Yang menyetujui |
| approved_at | TIMESTAMP | NULL | Waktu approval |
| created_by | UUID | FOREIGN KEY (pegawai.id), NOT NULL | Pembuat record |
| created_at | TIMESTAMP | DEFAULT now() | Waktu dibuat |
| updated_at | TIMESTAMP | DEFAULT now() | Waktu update terakhir |

**Index**:
- `idx_safety_patrol_tanggal` ON tanggal
- `idx_safety_patrol_unit` ON unit_id
- `idx_safety_patrol_wilayah` ON wilayah_id
- `idx_safety_patrol_status` ON status

**Contoh Data**:
```json
{
  "id": "c9d0e1f2-a3b4-4c5d-5e6f-7a8b9c0d1e2f",
  "unit_id": "a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d",
  "wilayah_id": null,
  "tanggal": "2024-11-22",
  "waktu_mulai": "14:00:00",
  "waktu_selesai": "15:30:00",
  "patrol_leader_id": "c3d4e5f6-a7b8-4c5d-9e0f-1a2b3c4d5e6f",
  "anggota_patrol_ids": ["d4e5f6a7-b8c9-4d5e-0f1a-2b3c4d5e6f7a", "e5f6a7b8-c9d0-4e5f-1a2b-3c4d5e6f7a8b"],
  "area_patrol": "Workshop Produksi, Gudang, Area Parkir",
  "rute_patrol": "Workshop → Gudang → Area Loading → Parkir → Kantor",
  "checklist": [
    {"item": "APD digunakan dengan benar", "status": "ok"},
    {"item": "Housekeeping area kerja", "status": "not_ok", "detail": "Material berserakan di area loading"},
    {"item": "Emergency exit tidak terhalang", "status": "ok"}
  ],
  "temuan_unsafe_act": "1 operator bekerja tanpa safety glasses",
  "temuan_unsafe_condition": "Material pallet ditumpuk melebihi batas aman di gudang",
  "jumlah_temuan": 2,
  "kategori_temuan": "major",
  "tindakan_langsung": "Operator diminta menggunakan safety glasses. Material pallet langsung diturunkan",
  "tindakan_lanjut": "Briefing ulang prosedur stacking material. Review kapasitas gudang",
  "pic_tindak_lanjut_id": "d4e5f6a7-b8c9-4d5e-0f1a-2b3c4d5e6f7a",
  "target_selesai": "2024-11-25",
  "lampiran_url": "https://storage.supabase.co/patrol/2024-11-22-temuan.jpg",
  "status": "approved",
  "approved_by": "m1n2o3p4-q5r6-7s8t-9u0v-w1x2y3z4a5b6",
  "approved_at": "2024-11-22 16:00:00",
  "created_by": "c3d4e5f6-a7b8-4c5d-9e0f-1a2b3c4d5e6f",
  "created_at": "2024-11-22 15:45:00",
  "updated_at": "2024-11-22 16:00:00"
}
```

---

### 2.6 Tabel `safety_induction`
**Deskripsi**: Safety Induction (setiap tahun untuk pegawai dan setiap kunjungan tamu eksternal)

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT uuid_generate_v4() | ID unik |
| tanggal | DATE | NOT NULL | Tanggal induction |
| waktu_mulai | TIME | NOT NULL | Waktu mulai |
| waktu_selesai | TIME | NULL | Waktu selesai |
| tipe_peserta | VARCHAR(20) | NOT NULL | pegawai / tamu_eksternal |
| pegawai_id | UUID | FOREIGN KEY (pegawai.id), NULL | ID pegawai (jika pegawai) |
| tamu_eksternal_id | UUID | FOREIGN KEY (tamu_eksternal.id), NULL | ID tamu (jika tamu) |
| unit_tujuan_id | UUID | FOREIGN KEY (units.id), NULL | Unit yang dikunjungi |
| wilayah_tujuan_id | UUID | FOREIGN KEY (wilayah.id), NULL | Wilayah yang dikunjungi |
| instructor_id | UUID | FOREIGN KEY (pegawai.id), NOT NULL | Instructor induction |
| materi | TEXT | NULL | Materi induction |
| topik_utama | JSONB | NULL | Array topik utama |
| lokasi | VARCHAR(200) | NULL | Lokasi induction |
| durasi_menit | INTEGER | NULL | Durasi dalam menit |
| metode | VARCHAR(50) | NULL | online / offline / hybrid |
| test_hasil | DECIMAL(5,2) | NULL | Nilai test (0-100) |
| sertifikat_url | TEXT | NULL | URL sertifikat induction |
| masa_berlaku | DATE | NULL | Masa berlaku induction |
| status_kelulusan | VARCHAR(20) | NULL | lulus / tidak_lulus |
| catatan | TEXT | NULL | Catatan tambahan |
| lampiran_url | TEXT | NULL | URL foto/dokumen |
| status | VARCHAR(20) | NOT NULL, DEFAULT 'draft' | draft / submitted / approved |
| approved_by | UUID | FOREIGN KEY (pegawai.id), NULL | Yang menyetujui |
| approved_at | TIMESTAMP | NULL | Waktu approval |
| created_by | UUID | FOREIGN KEY (pegawai.id), NOT NULL | Pembuat record |
| created_at | TIMESTAMP | DEFAULT now() | Waktu dibuat |
| updated_at | TIMESTAMP | DEFAULT now() | Waktu update terakhir |

**Index**:
- `idx_safety_induction_tanggal` ON tanggal
- `idx_safety_induction_pegawai` ON pegawai_id
- `idx_safety_induction_tamu` ON tamu_eksternal_id
- `idx_safety_induction_tipe` ON tipe_peserta
- `idx_safety_induction_status` ON status

**Contoh Data Pegawai**:
```json
{
  "id": "d0e1f2a3-b4c5-4d5e-6f7a-8b9c0d1e2f3a",
  "tanggal": "2024-01-10",
  "waktu_mulai": "09:00:00",
  "waktu_selesai": "12:00:00",
  "tipe_peserta": "pegawai",
  "pegawai_id": "c3d4e5f6-a7b8-4c5d-9e0f-1a2b3c4d5e6f",
  "tamu_eksternal_id": null,
  "unit_tujuan_id": "a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d",
  "wilayah_tujuan_id": null,
  "instructor_id": "m1n2o3p4-q5r6-7s8t-9u0v-w1x2y3z4a5b6",
  "materi": "Safety induction tahunan mencakup kebijakan K3, prosedur emergency, penggunaan APD, dan hazard identification",
  "topik_utama": ["Kebijakan K3", "Emergency Response", "APD", "Hazard Identification", "Work Permit"],
  "lokasi": "Training Room A",
  "durasi_menit": 180,
  "metode": "offline",
  "test_hasil": 92.50,
  "sertifikat_url": "https://storage.supabase.co/sertifikat/2024-emp001.pdf",
  "masa_berlaku": "2025-01-10",
  "status_kelulusan": "lulus",
  "catatan": "Peserta aktif dan memahami materi dengan baik",
  "lampiran_url": "https://storage.supabase.co/induction/2024-01-10-photo.jpg",
  "status": "approved",
  "approved_by": "m1n2o3p4-q5r6-7s8t-9u0v-w1x2y3z4a5b6",
  "approved_at": "2024-01-10 13:00:00",
  "created_by": "m1n2o3p4-q5r6-7s8t-9u0v-w1x2y3z4a5b6",
  "created_at": "2024-01-10 12:30:00",
  "updated_at": "2024-01-10 13:00:00"
}
```

**Contoh Data Tamu Eksternal**:
```json
{
  "id": "e1f2a3b4-c5d6-4e5f-7a8b-9c0d1e2f3a4b",
  "tanggal": "2024-11-20",
  "waktu_mulai": "10:00:00",
  "waktu_selesai": "10:30:00",
  "tipe_peserta": "tamu_eksternal",
  "pegawai_id": null,
  "tamu_eksternal_id": "d4e5f6a7-b8c9-4d5e-0f1a-2b3c4d5e6f7a",
  "unit_tujuan_id": "a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d",
  "wilayah_tujuan_id": null,
  "instructor_id": "c3d4e5f6-a7b8-4c5d-9e0f-1a2b3c4d5e6f",
  "materi": "Safety briefing untuk tamu: aturan area, emergency exit, APD wajib",
  "topik_utama": ["Aturan Area", "Emergency Exit", "APD Wajib", "Prohibited Areas"],
  "lokasi": "Security Post",
  "durasi_menit": 30,
  "metode": "offline",
  "test_hasil": null,
  "sertifikat_url": null,
  "masa_berlaku": "2024-11-20",
  "status_kelulusan": "lulus",
  "catatan": "Tamu dari PT Kontraktor ABC untuk site visit",
  "lampiran_url": null,
  "status": "approved",
  "approved_by": "c3d4e5f6-a7b8-4c5d-9e0f-1a2b3c4d5e6f",
  "approved_at": "2024-11-20 10:35:00",
  "created_by": "c3d4e5f6-a7b8-4c5d-9e0f-1a2b3c4d5e6f",
  "created_at": "2024-11-20 10:32:00",
  "updated_at": "2024-11-20 10:35:00"
}
```

---

### 2.7 Tabel `safety_drill`
**Deskripsi**: Safety Drill (simulasi keadaan darurat)

| Field Name | Type | Constraints | Description |
|------------|------|-------------|-------------|
| id | UUID | PRIMARY KEY, DEFAULT uuid_generate_v4() | ID unik |
| unit_id | UUID | FOREIGN KEY (units.id), NULL | Unit pelaksana drill |
| wilayah_id | UUID | FOREIGN KEY (wilayah.id), NULL | Wilayah pelaksana drill |
| tanggal | DATE | NOT NULL | Tanggal drill |
| waktu_mulai | TIME | NOT NULL | Waktu mulai drill |
| waktu_selesai | TIME | NULL | Waktu selesai drill |
| jenis_drill | VARCHAR(50) | NOT NULL | fire / earthquake / evacuation / emergency_response / other |
| tipe_drill | VARCHAR(20) | NOT NULL | announced / unannounced |
| koordinator_id | UUID | FOREIGN KEY (pegawai.id), NOT NULL | Koordinator drill |
| tim_drill_ids | JSONB | NULL | Array UUID tim drill |
| lokasi | VARCHAR(200) | NOT NULL | Lokasi drill |
| skenario | TEXT | NULL | Skenario drill |
| jumlah_peserta | INTEGER | DEFAULT 0 | Jumlah peserta |
| peserta_ids | JSONB | NULL | Array UUID peserta |
| waktu_evakuasi | INTEGER | NULL | Waktu evakuasi (detik) |
| target_waktu | INTEGER | NULL | Target waktu evakuasi (detik) |
| evaluasi | TEXT | NULL | Evaluasi pelaksanaan |
| temuan_positif | TEXT | NULL | Temuan positif |
| temuan_perbaikan | TEXT | NULL | Hal yang perlu diperbaiki |
| rekomendasi | TEXT | NULL | Rekomendasi |
| pic_tindak_lanjut_id | UUID | FOREIGN KEY (pegawai.id), NULL | PIC tindak lanjut |
| target_selesai | DATE | NULL | Target selesai perbaikan |
| skor_keseluruhan | DECIMAL(5,2) | NULL | Skor evaluasi (0-100) |
| status_drill | VARCHAR(20) | NULL | sukses / perlu_perbaikan / gagal |
| lampiran_url | TEXT | NULL | URL foto/video/dokumen |
| status | VARCHAR(20) | NOT NULL, DEFAULT 'draft' | draft / submitted / approved |
| approved_by | UUID | FOREIGN KEY (pegawai.id), NULL | Yang menyetujui |
| approved_at | TIMESTAMP | NULL | Waktu approval |
| created_by | UUID | FOREIGN KEY (pegawai.id), NOT NULL | Pembuat record |
| created_at | TIMESTAMP | DEFAULT now() | Waktu dibuat |
| updated_at | TIMESTAMP | DEFAULT now() | Waktu update terakhir |

**Index**:
- `idx_safety_drill_tanggal` ON tanggal
- `idx_safety_drill_jenis` ON jenis_drill
- `idx_safety_drill_unit` ON unit_id
- `idx_safety_drill_wilayah` ON wilayah_id
- `idx_safety_drill_status` ON status

**Contoh Data**:
```json
{
  "id": "f2a3b4c5-d6e7-4f5a-8b9c-0d1e2f3a4b5c",
  "unit_id": null,
  "wilayah_id": "b2c3d4e5-f6a7-4b5c-8d9e-0f1a2b3c4d5e",
  "tanggal": "2024-08-15",
  "waktu_mulai": "10:00:00",
  "waktu_selesai": "11:30:00",
  "jenis_drill": "fire",
  "tipe_drill": "unannounced",
  "koordinator_id": "m1n2o3p4-q5r6-7s8t-9u0v-w1x2y3z4a5b6",
  "tim_drill_ids": ["c3d4e5f6-a7b8-4c5d-9e0f-1a2b3c4d5e6f", "d4e5f6a7-b8c9-4d5e-0f1a-2b3c4d5e6f7a"],
  "lokasi": "Gedung Kantor Wilayah Jakarta",
  "skenario": "Simulasi kebakaran di lantai 3, evacuasi seluruh personel ke titik kumpul",
  "jumlah_peserta": 120,
  "peserta_ids": ["c3d4e5f6-a7b8-4c5d-9e0f-1a2b3c4d5e6f", "d4e5f6a7-b8c9-4d5e-0f1a-2b3c4d5e6f7a"],
  "waktu_evakuasi": 285,
  "target_waktu": 300,
  "evaluasi": "Drill berjalan lancar, semua peserta berhasil evacuasi dalam waktu target. Fire warden menjalankan tugas dengan baik",
  "temuan_positif": "1. Waktu evakuasi di bawah target\n2. Tidak ada kepanikan\n3. Roll call berjalan tertib",
  "temuan_perbaikan": "1. Beberapa orang masih membawa barang bawaan\n2. Emergency exit di lantai 2 agak macet\n3. Perlu tambahan fire warden",
  "rekomendasi": "1. Sosialisasi ulang prosedur evakuasi tanpa bawa barang\n2. Pelebaran pintu emergency exit lantai 2\n3. Training fire warden tambahan",
  "pic_tindak_lanjut_id": "p1q2r3s4-t5u6-7v8w-9x0y-z1a2b3c4d5e6",
  "target_selesai": "2024-09-30",
  "skor_keseluruhan": 88.00,
  "status_drill": "sukses",
  "lampiran_url": "https://storage.supabase.co/drill/2024-08-fire-drill.mp4",
  "status": "approved",
  "approved_by": "m1n2o3p4-q5r6-7s8t-9u0v-w1x2y3z4a5b6",
  "approved_at": "2024-08-15 14:00:00",
  "created_by": "m1n2o3p4-q5r6-7s8t-9u0v-w1x2y3z4a5b6",
  "created_at": "2024-08-15 12:00:00",
  "updated_at": "2024-08-15 14:00:00"
}
```

---

## 3. Relasi Antar Tabel

### Entity Relationship Diagram (ERD) - Text Format

```
units
  ├── has many → safety_briefing
  ├── has many → silent_inspection
  ├── has many → safety_forum
  ├── has many → management_walkthrough
  ├── has many → safety_patrol
  ├── has many → safety_induction
  ├── has many → safety_drill
  └── has many → pegawai

wilayah
  ├── has many → safety_briefing
  ├── has many → silent_inspection
  ├── has many → safety_forum
  ├── has many → management_walkthrough
  ├── has many → safety_patrol
  ├── has many → safety_induction
  ├── has many → safety_drill
  └── has many → pegawai

pegawai
  ├── belongs to → units (unit_id)
  ├── belongs to → wilayah (wilayah_id)
  ├── has many → safety_briefing (as petugas)
  ├── has many → safety_briefing (as created_by)
  ├── has many → safety_briefing (as approved_by)
  ├── has many → silent_inspection (as inspector)
  ├── has many → safety_forum (as moderator)
  ├── has many → management_walkthrough (as manager)
  ├── has many → safety_patrol (as patrol_leader)
  ├── has many → safety_induction (as instructor)
  ├── has many → safety_induction (as pegawai)
  └── has many → safety_drill (as koordinator)

tamu_eksternal
  └── has many → safety_induction
```

---

## 4. Constraint & Business Rules

### 4.1 Constraint Database
1. **Unit atau Wilayah**: Setiap record HSSE harus memiliki `unit_id` ATAU `wilayah_id` (minimal salah satu)
2. **Status Flow**: draft → submitted → approved (atau closed untuk beberapa modul)
3. **Unique Constraint**:
   - `units.kode_unit`
   - `wilayah.kode_wilayah`
   - `pegawai.nip`
   - `pegawai.email`

### 4.2 Business Rules
1. **Safety Briefing**: Harus dilakukan setiap hari kerja
2. **Silent Inspection**: 1x per triwulan (Q1, Q2, Q3, Q4)
3. **Safety Forum**: 1x per triwulan
4. **Management Walkthrough**: 
   - Unit: minimal 1x per bulan
   - Wilayah: minimal 1x per triwulan
5. **Safety Patrol**: 
   - Unit: minimal 1x per hari
   - Wilayah: minimal 1x per bulan
6. **Safety Induction**: 
   - Pegawai: 1x per tahun (renewal)
   - Tamu: setiap kunjungan
7. **Safety Drill**: Minimal 2x per tahun per unit/wilayah

---

## 5. Storage untuk File Upload

### 5.1 Supabase Storage Buckets

| Bucket Name | Description | Max Size | Public |
|-------------|-------------|----------|--------|
| hsse-photos | Foto dokumentasi | 10 MB | No |
| hsse-documents | Dokumen PDF, Excel, Word | 25 MB | No |
| hsse-videos | Video drill atau walkthrough | 100 MB | No |
| hsse-certificates | Sertifikat induction | 5 MB | No |
| profile-photos | Foto profil pegawai | 2 MB | Yes |

### 5.2 Naming Convention File
```
{module}/{year}/{month}/{unique_id}_{filename}

Contoh:
- safety_briefing/2024/11/e5f6a7b8-c9d0-4e5f-1a2b_photo1.jpg
- silent_inspection/2024/10/f6a7b8c9-d0e1-4f5a_report.pdf
- safety_drill/2024/08/f2a3b4c5-d6e7-4f5a_video.mp4
```

---

## 6. Security & Row Level Security (RLS)

### 6.1 RLS Policies

**Untuk semua tabel HSSE**:

```sql
-- User dapat melihat data unit/wilayah mereka sendiri
CREATE POLICY "Users can view own unit/wilayah data"
ON {table_name} FOR SELECT
USING (
  unit_id IN (SELECT unit_id FROM pegawai WHERE id = auth.uid())
  OR wilayah_id IN (SELECT wilayah_id FROM pegawai WHERE id = auth.uid())
);

-- User dapat membuat data untuk unit/wilayah mereka
CREATE POLICY "Users can create own unit/wilayah data"
ON {table_name} FOR INSERT
WITH CHECK (
  unit_id IN (SELECT unit_id FROM pegawai WHERE id = auth.uid())
  OR wilayah_id IN (SELECT wilayah_id FROM pegawai WHERE id = auth.uid())
);

-- User dapat update data draft/submitted yang mereka buat
CREATE POLICY "Users can update own draft/submitted data"
ON {table_name} FOR UPDATE
USING (
  created_by = auth.uid() 
  AND status IN ('draft', 'submitted')
);

-- Manager/Admin dapat approve data
CREATE POLICY "Managers can approve data"
ON {table_name} FOR UPDATE
USING (
  EXISTS (
    SELECT 1 FROM pegawai 
    WHERE id = auth.uid() 
    AND role IN ('manager', 'admin')
  )
);
```

---

## 7. Indexes untuk Performance

### 7.1 Composite Indexes

```sql
-- Untuk query filter kombinasi tanggal + unit/wilayah
CREATE INDEX idx_safety_briefing_date_unit ON safety_briefing(tanggal DESC, unit_id);
CREATE INDEX idx_safety_briefing_date_wilayah ON safety_briefing(tanggal DESC, wilayah_id);

CREATE INDEX idx_silent_inspection_quarter_unit ON silent_inspection(tahun DESC, triwulan, unit_id);
CREATE INDEX idx_safety_forum_quarter_wilayah ON safety_forum(tahun DESC, triwulan, wilayah_id);

CREATE INDEX idx_walkthrough_month_unit ON management_walkthrough(tahun DESC, bulan, unit_id);
CREATE INDEX idx_safety_patrol_date_unit ON safety_patrol(tanggal DESC, unit_id);

-- Full-text search indexes (untuk search fitur)
CREATE INDEX idx_safety_briefing_topik_search ON safety_briefing USING GIN (to_tsvector('indonesian', topik));
CREATE INDEX idx_silent_inspection_temuan_search ON silent_inspection USING GIN (to_tsvector('indonesian', temuan));
```

---

## 8. Audit Trail (Optional Enhancement)

### Tabel `audit_logs`
Track semua perubahan penting pada data HSSE

| Field Name | Type | Description |
|------------|------|-------------|
| id | UUID | PRIMARY KEY |
| table_name | VARCHAR(50) | Nama tabel yang diubah |
| record_id | UUID | ID record yang diubah |
| action | VARCHAR(20) | INSERT / UPDATE / DELETE |
| old_data | JSONB | Data sebelum perubahan |
| new_data | JSONB | Data setelah perubahan |
| changed_by | UUID | User yang melakukan perubahan |
| changed_at | TIMESTAMP | Waktu perubahan |

---

## Summary Database Schema

**Total Tabel**: 11 tabel
- **Master**: 4 tabel (units, wilayah, pegawai, tamu_eksternal)
- **Transaksi HSSE**: 7 tabel (safety_briefing, silent_inspection, safety_forum, management_walkthrough, safety_patrol, safety_induction, safety_drill)

**Total Indexes**: ~50+ indexes (single + composite)

**Storage Buckets**: 5 buckets

**RLS Policies**: ~4 policies per tabel (total ~44 policies)

---

**Next**: API Specification (02_API_SPECIFICATION.md)
