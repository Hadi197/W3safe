# 📋 Dokumentasi Detail 7 Modul HSSE

## Overview
Dokumentasi lengkap proses bisnis, user roles, required fields, validation logic, dan UI/UX design untuk setiap modul HSSE.

---

## 1. Safety Briefing

### 1.1 Proses Bisnis
**Tujuan**: Briefing keselamatan harian sebelum aktivitas kerja dimulai

**Frekuensi**: Setiap hari kerja (Unit dan Wilayah)

**Flow Process**:
1. Petugas membuka sesi briefing di pagi hari
2. Mencatat peserta hadir
3. Menyampaikan topik keselamatan hari ini
4. Diskusi temuan/issue (jika ada)
5. Menetapkan tindak lanjut
6. Dokumentasi dan submit
7. Approval oleh supervisor/manager

### 1.2 User Roles
| Role | Permissions |
|------|-------------|
| User (Petugas) | Create draft, edit own draft, submit |
| Supervisor | View all, approve submitted |
| Manager | View all, approve, delete |
| Admin | Full access |

### 1.3 Required Fields
- ✅ **Tanggal** (date, required): Tanggal briefing
- ✅ **Waktu Mulai** (time, required): Jam mulai briefing
- ✅ **Petugas** (FK pegawai, required): Yang memimpin briefing
- ✅ **Topik** (string, required): Topik pembahasan
- ✅ **Unit atau Wilayah** (FK, required): Salah satu harus diisi
- ⭕ Waktu Selesai (time, optional)
- ⭕ Lokasi (string, optional)
- ⭕ Materi (text, optional)
- ⭕ Jumlah Peserta (integer, optional)
- ⭕ Temuan (text, optional)
- ⭕ Tindak Lanjut (text, optional)
- ⭕ Lampiran (file, optional)

### 1.4 Validation Logic
```javascript
{
  tanggal: required() && pastDate(),
  waktu_mulai: required(),
  petugas_id: required(),
  topik: required() && minLength(5),
  unit_id_or_wilayah_id: oneRequired('unit_id', 'wilayah_id'),
  jumlah_peserta: optional() && minValue(0),
  status: required() && in(['draft', 'submitted', 'approved'])
}
```

### 1.5 UI/UX Design
**List View**:
- Table dengan kolom: Tanggal, Unit/Wilayah, Topik, Petugas, Status
- Filter: Date range, Unit, Wilayah, Status
- Search: By topik
- Action buttons: Create, View, Edit, Delete

**Form View**:
- Tab 1: Info Dasar (tanggal, waktu, petugas, lokasi)
- Tab 2: Konten (topik, materi, peserta)
- Tab 3: Temuan & Tindak Lanjut
- Tab 4: Lampiran
- Save as draft / Submit for approval

**Detail View**:
- Header: Tanggal, status badge
- Content: All fields display
- Timeline: Created → Submitted → Approved
- Actions: Edit (if allowed), Approve (if manager), Print

---

## 2. Silent Inspection

### 2.1 Proses Bisnis
**Tujuan**: Inspeksi keselamatan mendalam tanpa pemberitahuan sebelumnya

**Frekuensi**: Per triwulan (Unit dan Wilayah)

**Flow Process**:
1. Inspector melakukan inspeksi area kerja
2. Menggunakan checklist standar
3. Memberikan skor per item
4. Menghitung total skor
5. Mengkategorikan temuan (critical/major/minor)
6. Membuat rekomendasi perbaikan
7. Menentukan PIC dan target selesai
8. Submit untuk approval
9. Follow up hingga selesai (closed)

### 2.2 User Roles
| Role | Permissions |
|------|-------------|
| Inspector | Create, edit own, submit |
| PIC Perbaikan | Update progress |
| Manager | Approve, assign PIC |
| Admin | Full access |

### 2.3 Required Fields
- ✅ **Tanggal** (date, required)
- ✅ **Triwulan** (1-4, required)
- ✅ **Tahun** (integer, required)
- ✅ **Inspector** (FK pegawai, required)
- ✅ **Area Inspeksi** (string, required)
- ⭕ Checklist (JSONB array, optional)
- ⭕ Skor Total (decimal, optional)
- ⭕ Kategori Temuan (enum, optional)
- ⭕ Temuan (text, optional)
- ⭕ Rekomendasi (text, optional)
- ⭕ PIC Perbaikan (FK pegawai, optional)
- ⭕ Target Selesai (date, optional)

### 2.4 Validation Logic
```javascript
{
  tanggal: required(),
  triwulan: required() && between(1, 4),
  tahun: required() && between(2020, 2050),
  inspector_id: required(),
  area_inspeksi: required(),
  skor_total: optional() && between(0, 100),
  kategori_temuan: optional() && in(['critical', 'major', 'minor', 'none']),
  status: required() && in(['draft', 'submitted', 'approved', 'closed'])
}
```

### 2.5 UI/UX Design
**List View**:
- Cards/Table: Tanggal, Triwulan, Area, Skor, Kategori, Status
- Filter: Triwulan, Tahun, Kategori Temuan, Status
- Color coding by kategori temuan

**Form View**:
- Dynamic checklist builder
- Auto-calculate skor total
- Conditional fields based on kategori temuan
- File upload for evidence photos

---

## 3. Safety Forum

### 3.1 Proses Bisnis
**Tujuan**: Forum diskusi keselamatan untuk sharing knowledge dan review program

**Frekuensi**: Per triwulan (Unit dan Wilayah)

**Flow Process**:
1. Moderator menjadwalkan forum
2. Menentukan tema dan agenda
3. Mengundang peserta
4. Melaksanakan forum
5. Mencatat notulen dan keputusan
6. Submit untuk approval
7. Follow up action items

### 3.2 User Roles
| Role | Permissions |
|------|-------------|
| Moderator | Create, edit, submit |
| Peserta | View assigned forums |
| Manager | Approve, assign follow-up |
| Admin | Full access |

### 3.3 Required Fields
- ✅ **Tanggal** (date, required)
- ✅ **Triwulan** (1-4, required)
- ✅ **Tahun** (integer, required)
- ✅ **Moderator** (FK pegawai, required)
- ✅ **Lokasi** (string, required)
- ✅ **Tema** (string, required)
- ⭕ Waktu Mulai/Selesai
- ⭕ Agenda (text)
- ⭕ Jumlah Peserta
- ⭕ Pembicara
- ⭕ Ringkasan
- ⭕ Keputusan
- ⭕ Notulen

---

## 4. Management Walkthrough

### 4.1 Proses Bisnis
**Tujuan**: Kunjungan langsung management ke area kerja untuk observasi keselamatan

**Frekuensi**:
- Unit: Setiap bulan
- Wilayah: Per triwulan

**Flow Process**:
1. Manager menjadwalkan walkthrough
2. Menentukan area kunjungan dan fokus observasi
3. Melakukan walkthrough dengan pendamping
4. Mencatat temuan positif dan area perbaikan
5. Memberikan rekomendasi
6. Menentukan PIC tindak lanjut
7. Auto-approved (karena dilakukan manager)

### 4.2 User Roles
| Role | Permissions |
|------|-------------|
| Manager | Create, auto-approve |
| PIC Tindak Lanjut | Update progress |
| Admin | Full access |

### 4.3 Required Fields
- ✅ **Tanggal** (date, required)
- ✅ **Bulan** (1-12, required)
- ✅ **Tahun** (integer, required)
- ✅ **Manager** (FK pegawai, required)
- ✅ **Area Kunjungan** (text, required)
- ⭕ Waktu Mulai/Selesai
- ⭕ Pendamping (JSONB array)
- ⭕ Fokus Observasi
- ⭕ Temuan Positif
- ⭕ Temuan Perbaikan
- ⭕ Kategori Temuan
- ⭕ Rekomendasi
- ⭕ PIC & Target Selesai

---

## 5. Safety Patrol

### 5.1 Proses Bisnis
**Tujuan**: Patroli rutin untuk mengidentifikasi unsafe act dan unsafe condition

**Frekuensi**:
- Unit: Setiap hari
- Wilayah: Setiap bulan

**Flow Process**:
1. Patrol leader membentuk tim patrol
2. Menentukan rute patrol
3. Melakukan patrol dengan checklist
4. Mencatat unsafe act dan unsafe condition
5. Melakukan tindakan langsung jika memungkinkan
6. Dokumentasi temuan dengan foto
7. Menentukan tindakan lanjut jika diperlukan
8. Submit untuk approval

### 5.2 User Roles
| Role | Permissions |
|------|-------------|
| Patrol Leader | Create, edit, submit |
| Anggota Tim | Participate |
| PIC Tindak Lanjut | Update corrective actions |
| Supervisor | Approve |
| Admin | Full access |

### 5.3 Required Fields
- ✅ **Tanggal** (date, required)
- ✅ **Waktu Mulai** (time, required)
- ✅ **Patrol Leader** (FK pegawai, required)
- ✅ **Area Patrol** (text, required)
- ⭕ Waktu Selesai
- ⭕ Anggota Tim (JSONB array)
- ⭕ Rute Patrol
- ⭕ Checklist (JSONB)
- ⭕ Unsafe Act
- ⭕ Unsafe Condition
- ⭕ Jumlah Temuan
- ⭕ Kategori Temuan
- ⭕ Tindakan Langsung
- ⭕ Tindakan Lanjut
- ⭕ PIC & Target

### 5.4 Validation Logic
```javascript
{
  tanggal: required() && notFutureDate(),
  waktu_mulai: required(),
  patrol_leader_id: required(),
  area_patrol: required(),
  jumlah_temuan: optional() && minValue(0),
  kategori_temuan: optionalIf(jumlah_temuan > 0)
}
```

### 5.5 UI/UX Design
**Quick Entry Mode**:
- Simplified form untuk patrol harian
- Pre-filled tanggal hari ini
- Quick checklist dengan toggle OK/Not OK
- Camera button untuk foto temuan
- Quick submit

---

## 6. Safety Induction

### 6.1 Proses Bisnis
**Tujuan**: Induksi keselamatan untuk pegawai baru/renewal dan tamu eksternal

**Frekuensi**:
- Pegawai: Setiap tahun (renewal)
- Tamu Eksternal: Setiap kunjungan

**Flow Process**:

**A. Untuk Pegawai**:
1. HR/Safety Officer jadwalkan induction
2. Peserta attend training (offline/online)
3. Materi: Kebijakan K3, Emergency Response, APD, Hazard ID
4. Test evaluasi
5. Generate sertifikat jika lulus
6. Set masa berlaku 1 tahun
7. Reminder 30 hari sebelum expiry

**B. Untuk Tamu Eksternal**:
1. Tamu datang ke security post
2. Security call safety officer
3. Safety briefing singkat (15-30 menit)
4. Tamu sign form dan terima kartu visitor
5. Escort ke area tujuan
6. Log kunjungan

### 6.2 User Roles
| Role | Permissions |
|------|-------------|
| Instructor | Create, conduct, approve |
| Pegawai | View own induction history |
| Security | Create quick induction for tamu |
| HR | Schedule, monitor expiry |
| Admin | Full access |

### 6.3 Required Fields

**Untuk Pegawai**:
- ✅ **Tanggal** (date, required)
- ✅ **Pegawai** (FK pegawai, required)
- ✅ **Instructor** (FK pegawai, required)
- ✅ **Materi** (text, required)
- ✅ **Metode** (online/offline/hybrid, required)
- ⭕ Test Hasil (decimal 0-100)
- ⭕ Status Kelulusan (lulus/tidak_lulus)
- ✅ **Masa Berlaku** (date, required): +1 year dari tanggal

**Untuk Tamu**:
- ✅ **Tanggal** (date, required)
- ✅ **Tamu Eksternal** (FK tamu, required)
- ✅ **Instructor** (FK pegawai, required)
- ✅ **Unit/Wilayah Tujuan** (FK, required)
- ⭕ Materi Singkat
- ⭕ Durasi (menit)

### 6.4 Validation Logic
```javascript
{
  tanggal: required(),
  tipe_peserta: required() && in(['pegawai', 'tamu_eksternal']),
  pegawai_id: requiredIf(tipe_peserta === 'pegawai'),
  tamu_eksternal_id: requiredIf(tipe_peserta === 'tamu_eksternal'),
  instructor_id: required(),
  materi: required(),
  masa_berlaku: requiredIf(tipe_peserta === 'pegawai'),
  test_hasil: optionalIf(tipe_peserta === 'pegawai') && between(0, 100)
}
```

### 6.5 UI/UX Design

**List View**:
- Tabs: "Pegawai" | "Tamu Eksternal"
- For Pegawai: Show expiry status (expired, expiring soon, valid)
- Filter: Status kelulusan, Metode, Date range
- Expiry Alert: Badge merah untuk yang expired

**Form View - Pegawai**:
- Step 1: Select pegawai, instructor, lokasi
- Step 2: Tanggal, waktu, metode
- Step 3: Materi dan topik utama
- Step 4: Test dan hasil
- Step 5: Generate sertifikat PDF

**Form View - Tamu**:
- Quick form (1 page)
- Search tamu by nama/perusahaan/NIK
- Auto-create tamu baru jika belum ada
- Quick safety briefing checklist
- Print visitor pass

---

## 7. Safety Drill

### 7.1 Proses Bisnis
**Tujuan**: Simulasi emergency untuk menguji kesiapan tim dan prosedur

**Frekuensi**: Minimal 2x per tahun per unit/wilayah

**Jenis Drill**:
- Fire Drill (kebakaran)
- Earthquake Drill (gempa)
- Evacuation Drill (evakuasi)
- Emergency Response Drill

**Flow Process**:
1. Koordinator menyusun skenario drill
2. Menentukan announced/unannounced
3. Briefing tim drill (jika announced)
4. Melaksanakan drill sesuai skenario
5. Monitor dan catat waktu evakuasi
6. Roll call di assembly point
7. Evaluasi pelaksanaan
8. Identifikasi temuan positif dan perbaikan
9. Buat rekomendasi
10. Submit dan approve
11. Follow up tindak lanjut

### 7.2 User Roles
| Role | Permissions |
|------|-------------|
| Koordinator | Create, conduct, evaluate |
| Tim Drill | Participate, assist |
| Observer | Monitor dan evaluate |
| Manager | Approve, review recommendations |
| Admin | Full access |

### 7.3 Required Fields
- ✅ **Tanggal** (date, required)
- ✅ **Waktu Mulai** (time, required)
- ✅ **Jenis Drill** (enum, required): fire/earthquake/evacuation/emergency_response
- ✅ **Tipe Drill** (enum, required): announced/unannounced
- ✅ **Koordinator** (FK pegawai, required)
- ✅ **Lokasi** (string, required)
- ✅ **Skenario** (text, required)
- ⭕ Waktu Selesai
- ⭕ Tim Drill (JSONB array)
- ⭕ Jumlah Peserta
- ⭕ Peserta IDs (JSONB array)
- ⭕ Waktu Evakuasi (detik)
- ⭕ Target Waktu (detik)
- ⭕ Evaluasi
- ⭕ Temuan Positif
- ⭕ Temuan Perbaikan
- ⭕ Rekomendasi
- ⭕ PIC & Target Selesai
- ⭕ Skor Keseluruhan (0-100)
- ⭕ Status Drill (sukses/perlu_perbaikan/gagal)

### 7.4 Validation Logic
```javascript
{
  tanggal: required(),
  waktu_mulai: required(),
  jenis_drill: required() && in(['fire', 'earthquake', 'evacuation', 'emergency_response', 'other']),
  tipe_drill: required() && in(['announced', 'unannounced']),
  koordinator_id: required(),
  lokasi: required(),
  skenario: required() && minLength(20),
  waktu_evakuasi: optional() && minValue(0),
  target_waktu: optional() && minValue(0),
  skor_keseluruhan: optional() && between(0, 100),
  status_drill: optional() && in(['sukses', 'perlu_perbaikan', 'gagal'])
}
```

### 7.5 UI/UX Design

**List View**:
- Card layout dengan icon jenis drill
- Color coding: Fire=Red, Earthquake=Orange, Evacuation=Blue
- Show: Jenis, Tanggal, Lokasi, Skor, Status Drill
- Filter: Jenis Drill, Status, Date range

**Form View**:
- Step 1: Basic Info (jenis, tipe, tanggal, lokasi, skenario)
- Step 2: Tim & Peserta
- Step 3: Execution (waktu mulai/selesai, waktu evakuasi)
- Step 4: Evaluation (skor, temuan, rekomendasi)
- Step 5: Media (foto/video upload)

**Detail View**:
- Header dengan icon jenis drill
- Comparison: Waktu Evakuasi vs Target (dengan gauge)
- Timeline pelaksanaan
- Gallery foto/video
- Evaluation summary dengan skor visual
- Action items tracking

---

## Summary Comparison

| Module | Frekuensi | Status Flow | Approval Required |
|--------|-----------|-------------|-------------------|
| Safety Briefing | Harian (Unit/Wilayah) | Draft → Submitted → Approved | Yes |
| Silent Inspection | Per Triwulan | Draft → Submitted → Approved → Closed | Yes |
| Safety Forum | Per Triwulan | Draft → Submitted → Approved | Yes |
| Mgmt Walkthrough | Bulanan (Unit), Triwulan (Wilayah) | Draft → Auto-Approved | Auto |
| Safety Patrol | Harian (Unit), Bulanan (Wilayah) | Draft → Submitted → Approved → Closed | Yes |
| Safety Induction | Tahunan (Pegawai), Per Kunjungan (Tamu) | Draft → Approved | Yes |
| Safety Drill | Min 2x/tahun | Draft → Submitted → Approved → Closed | Yes |

---

**Next**: Migration SQL (07_MIGRATION_SQL.md)
