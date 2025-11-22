# 🔌 API Specification - Aplikasi Implementasi HSSE

## Overview
API menggunakan Supabase REST API dengan JavaScript Client Library.
Base URL: `https://[your-project].supabase.co`

---

## 1. Authentication

### 1.1 Login
```javascript
// POST /auth/v1/token?grant_type=password
const { data, error } = await supabase.auth.signInWithPassword({
  email: 'user@company.com',
  password: 'password123'
})
```

**Response**:
```json
{
  "access_token": "eyJhbGc...",
  "token_type": "bearer",
  "expires_in": 3600,
  "refresh_token": "v1.MjA...",
  "user": {
    "id": "c3d4e5f6-a7b8-4c5d-9e0f-1a2b3c4d5e6f",
    "email": "user@company.com",
    "role": "authenticated"
  }
}
```

### 1.2 Logout
```javascript
const { error } = await supabase.auth.signOut()
```

### 1.3 Get Current User
```javascript
const { data: { user } } = await supabase.auth.getUser()
```

---

## 2. Master Data APIs

### 2.1 Units API

#### Get All Units
```javascript
// GET /rest/v1/units
const { data, error } = await supabase
  .from('units')
  .select('*')
  .eq('status', 'aktif')
  .order('nama_unit', { ascending: true })
```

**Query Parameters**:
- `status`: Filter by status (aktif/nonaktif)
- `order`: Sort field and direction

**Response**:
```json
[
  {
    "id": "a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d",
    "kode_unit": "UNIT-001",
    "nama_unit": "Unit Produksi A",
    "lokasi": "Gedung A Lantai 2",
    "manager_id": "m1n2o3p4-q5r6-7s8t-9u0v-w1x2y3z4a5b6",
    "status": "aktif",
    "created_at": "2024-01-15T08:00:00Z",
    "updated_at": "2024-01-15T08:00:00Z"
  }
]
```

#### Get Unit with Manager
```javascript
const { data, error } = await supabase
  .from('units')
  .select(`
    *,
    manager:pegawai!manager_id(id, nama_lengkap, email)
  `)
  .eq('id', unitId)
  .single()
```

#### Create Unit
```javascript
// POST /rest/v1/units
const { data, error } = await supabase
  .from('units')
  .insert({
    kode_unit: 'UNIT-002',
    nama_unit: 'Unit Produksi B',
    lokasi: 'Gedung B Lantai 1',
    manager_id: 'manager-uuid',
    status: 'aktif'
  })
  .select()
```

#### Update Unit
```javascript
// PATCH /rest/v1/units?id=eq.{id}
const { data, error } = await supabase
  .from('units')
  .update({
    nama_unit: 'Unit Produksi B - Updated',
    lokasi: 'Gedung B Lantai 2'
  })
  .eq('id', unitId)
  .select()
```

#### Delete Unit
```javascript
// DELETE /rest/v1/units?id=eq.{id}
const { error } = await supabase
  .from('units')
  .delete()
  .eq('id', unitId)
```

---

### 2.2 Wilayah API

#### Get All Wilayah
```javascript
const { data, error } = await supabase
  .from('wilayah')
  .select('*')
  .eq('status', 'aktif')
  .order('nama_wilayah', { ascending: true })
```

#### Get Wilayah with PIC
```javascript
const { data, error } = await supabase
  .from('wilayah')
  .select(`
    *,
    pic:pegawai!pic_id(id, nama_lengkap, email, phone)
  `)
  .eq('id', wilayahId)
  .single()
```

---

### 2.3 Pegawai API

#### Get All Pegawai
```javascript
const { data, error } = await supabase
  .from('pegawai')
  .select(`
    *,
    unit:units!unit_id(id, kode_unit, nama_unit),
    wilayah:wilayah!wilayah_id(id, kode_wilayah, nama_wilayah)
  `)
  .eq('status', 'aktif')
  .order('nama_lengkap', { ascending: true })
```

**Pagination**:
```javascript
const page = 1
const pageSize = 20
const from = (page - 1) * pageSize
const to = from + pageSize - 1

const { data, error, count } = await supabase
  .from('pegawai')
  .select('*', { count: 'exact' })
  .range(from, to)
```

#### Search Pegawai
```javascript
const { data, error } = await supabase
  .from('pegawai')
  .select('*')
  .or(`nama_lengkap.ilike.%${searchTerm}%,nip.ilike.%${searchTerm}%,email.ilike.%${searchTerm}%`)
```

#### Get Pegawai by Role
```javascript
const { data, error } = await supabase
  .from('pegawai')
  .select('*')
  .eq('role', 'manager')
  .eq('status', 'aktif')
```

---

### 2.4 Tamu Eksternal API

#### Create Tamu Eksternal
```javascript
const { data, error } = await supabase
  .from('tamu_eksternal')
  .insert({
    nama_lengkap: 'Ahmad Hidayat',
    perusahaan: 'PT Kontraktor ABC',
    email: 'ahmad@kontraktor-abc.com',
    phone: '082345678901',
    nik: '3174012345678901',
    foto_identitas_url: 'https://...'
  })
  .select()
```

#### Search Tamu
```javascript
const { data, error } = await supabase
  .from('tamu_eksternal')
  .select('*')
  .or(`nama_lengkap.ilike.%${searchTerm}%,perusahaan.ilike.%${searchTerm}%`)
```

---

## 3. HSSE Module APIs

### 3.1 Safety Briefing API

#### Get All Safety Briefing
```javascript
// GET /rest/v1/safety_briefing
const { data, error, count } = await supabase
  .from('safety_briefing')
  .select(`
    *,
    unit:units!unit_id(id, kode_unit, nama_unit),
    wilayah:wilayah!wilayah_id(id, kode_wilayah, nama_wilayah),
    petugas:pegawai!petugas_id(id, nama_lengkap, nip),
    approved_by_user:pegawai!approved_by(id, nama_lengkap),
    created_by_user:pegawai!created_by(id, nama_lengkap)
  `, { count: 'exact' })
  .order('tanggal', { ascending: false })
  .range(from, to)
```

**Query Parameters**:
- `tanggal_dari`: Start date filter
- `tanggal_sampai`: End date filter
- `unit_id`: Filter by unit
- `wilayah_id`: Filter by wilayah
- `status`: Filter by status (draft/submitted/approved)
- `page`: Page number
- `limit`: Items per page

#### Filter Safety Briefing
```javascript
let query = supabase
  .from('safety_briefing')
  .select('*', { count: 'exact' })

// Filter by date range
if (tanggalDari) {
  query = query.gte('tanggal', tanggalDari)
}
if (tanggalSampai) {
  query = query.lte('tanggal', tanggalSampai)
}

// Filter by unit or wilayah
if (unitId) {
  query = query.eq('unit_id', unitId)
}
if (wilayahId) {
  query = query.eq('wilayah_id', wilayahId)
}

// Filter by status
if (status) {
  query = query.eq('status', status)
}

const { data, error, count } = await query
  .order('tanggal', { ascending: false })
  .range(from, to)
```

#### Get Safety Briefing by ID
```javascript
const { data, error } = await supabase
  .from('safety_briefing')
  .select(`
    *,
    unit:units!unit_id(*),
    wilayah:wilayah!wilayah_id(*),
    petugas:pegawai!petugas_id(*),
    approved_by_user:pegawai!approved_by(*),
    created_by_user:pegawai!created_by(*)
  `)
  .eq('id', briefingId)
  .single()
```

#### Create Safety Briefing
```javascript
// POST /rest/v1/safety_briefing
const { data, error } = await supabase
  .from('safety_briefing')
  .insert({
    unit_id: 'unit-uuid',
    wilayah_id: null,
    tanggal: '2024-11-22',
    waktu_mulai: '07:30:00',
    waktu_selesai: '07:45:00',
    petugas_id: 'petugas-uuid',
    lokasi: 'Ruang Meeting A',
    topik: 'Keselamatan Operasi Mesin Press',
    materi: 'Materi briefing...',
    jumlah_peserta: 12,
    peserta_ids: ['uuid1', 'uuid2'],
    temuan: 'Beberapa operator belum menggunakan APD',
    tindak_lanjut: 'Supervisor akan monitoring',
    lampiran_url: 'https://...',
    status: 'draft',
    created_by: 'user-uuid'
  })
  .select()
```

#### Update Safety Briefing
```javascript
// PATCH /rest/v1/safety_briefing?id=eq.{id}
const { data, error } = await supabase
  .from('safety_briefing')
  .update({
    topik: 'Updated Topic',
    materi: 'Updated content...',
    status: 'submitted'
  })
  .eq('id', briefingId)
  .select()
```

#### Approve Safety Briefing
```javascript
const { data, error } = await supabase
  .from('safety_briefing')
  .update({
    status: 'approved',
    approved_by: currentUserId,
    approved_at: new Date().toISOString()
  })
  .eq('id', briefingId)
  .select()
```

#### Delete Safety Briefing
```javascript
// DELETE /rest/v1/safety_briefing?id=eq.{id}
const { error } = await supabase
  .from('safety_briefing')
  .delete()
  .eq('id', briefingId)
```

#### Get Statistics - Briefing Count
```javascript
// Count by month
const { count, error } = await supabase
  .from('safety_briefing')
  .select('*', { count: 'exact', head: true })
  .gte('tanggal', '2024-11-01')
  .lte('tanggal', '2024-11-30')
  .eq('unit_id', unitId)
```

#### Get Statistics - Briefing by Unit
```javascript
// Using RPC function (create in Supabase)
const { data, error } = await supabase
  .rpc('get_briefing_stats_by_unit', {
    tahun_param: 2024,
    bulan_param: 11
  })
```

---

### 3.2 Silent Inspection API

#### Get All Silent Inspection
```javascript
const { data, error, count } = await supabase
  .from('silent_inspection')
  .select(`
    *,
    unit:units!unit_id(id, kode_unit, nama_unit),
    wilayah:wilayah!wilayah_id(id, kode_wilayah, nama_wilayah),
    inspector:pegawai!inspector_id(id, nama_lengkap, nip),
    pic_perbaikan:pegawai!pic_perbaikan_id(id, nama_lengkap)
  `, { count: 'exact' })
  .order('tanggal', { ascending: false })
  .range(from, to)
```

#### Filter by Triwulan
```javascript
const { data, error } = await supabase
  .from('silent_inspection')
  .select('*')
  .eq('tahun', 2024)
  .eq('triwulan', 4)
  .order('tanggal', { ascending: false })
```

#### Create Silent Inspection
```javascript
const { data, error } = await supabase
  .from('silent_inspection')
  .insert({
    unit_id: 'unit-uuid',
    wilayah_id: null,
    tanggal: '2024-10-15',
    triwulan: 4,
    tahun: 2024,
    inspector_id: 'inspector-uuid',
    area_inspeksi: 'Workshop Maintenance',
    checklist: [
      { item: 'APD lengkap tersedia', status: 'ok', catatan: '' },
      { item: 'APAR dalam kondisi baik', status: 'not_ok', catatan: '1 unit expired' }
    ],
    skor_total: 85.50,
    kategori_temuan: 'minor',
    temuan: '1 unit APAR expired',
    rekomendasi: 'Segera replace APAR',
    pic_perbaikan_id: 'pic-uuid',
    target_selesai: '2024-10-20',
    lampiran_url: 'https://...',
    status: 'draft',
    created_by: 'user-uuid'
  })
  .select()
```

#### Update Status to Closed
```javascript
const { data, error } = await supabase
  .from('silent_inspection')
  .update({
    status: 'closed',
    tanggal_selesai: '2024-10-18'
  })
  .eq('id', inspectionId)
  .select()
```

#### Get Statistics by Kategori Temuan
```javascript
const { data, error } = await supabase
  .from('silent_inspection')
  .select('kategori_temuan')
  .eq('tahun', 2024)
  .eq('triwulan', 4)

// Process in frontend
const stats = data.reduce((acc, item) => {
  acc[item.kategori_temuan] = (acc[item.kategori_temuan] || 0) + 1
  return acc
}, {})
```

---

### 3.3 Safety Forum API

#### Get All Safety Forum
```javascript
const { data, error, count } = await supabase
  .from('safety_forum')
  .select(`
    *,
    unit:units!unit_id(id, kode_unit, nama_unit),
    wilayah:wilayah!wilayah_id(id, kode_wilayah, nama_wilayah),
    moderator:pegawai!moderator_id(id, nama_lengkap, nip)
  `, { count: 'exact' })
  .order('tanggal', { ascending: false })
  .range(from, to)
```

#### Filter by Triwulan
```javascript
const { data, error } = await supabase
  .from('safety_forum')
  .select('*')
  .eq('tahun', 2024)
  .eq('triwulan', 3)
  .order('tanggal', { ascending: false })
```

#### Create Safety Forum
```javascript
const { data, error } = await supabase
  .from('safety_forum')
  .insert({
    unit_id: null,
    wilayah_id: 'wilayah-uuid',
    tanggal: '2024-09-25',
    triwulan: 3,
    tahun: 2024,
    waktu_mulai: '13:00:00',
    waktu_selesai: '15:30:00',
    moderator_id: 'moderator-uuid',
    lokasi: 'Ruang Auditorium',
    tema: 'Zero Accident Program Q3 2024',
    agenda: '1. Review incident Q3\n2. Sharing best practices',
    jumlah_peserta: 45,
    peserta_ids: ['uuid1', 'uuid2'],
    pembicara: 'Ir. Siti Nurhaliza',
    ringkasan: 'Forum membahas...',
    keputusan: '1. Adopsi program...',
    notulen: 'Notulen lengkap...',
    lampiran_url: 'https://...',
    status: 'draft',
    created_by: 'user-uuid'
  })
  .select()
```

---

### 3.4 Management Walkthrough API

#### Get All Management Walkthrough
```javascript
const { data, error, count } = await supabase
  .from('management_walkthrough')
  .select(`
    *,
    unit:units!unit_id(id, kode_unit, nama_unit),
    wilayah:wilayah!wilayah_id(id, kode_wilayah, nama_wilayah),
    manager:pegawai!manager_id(id, nama_lengkap, jabatan),
    pic_tindak_lanjut:pegawai!pic_tindak_lanjut_id(id, nama_lengkap)
  `, { count: 'exact' })
  .order('tanggal', { ascending: false })
  .range(from, to)
```

#### Filter by Bulan
```javascript
const { data, error } = await supabase
  .from('management_walkthrough')
  .select('*')
  .eq('tahun', 2024)
  .eq('bulan', 11)
  .order('tanggal', { ascending: false })
```

#### Create Management Walkthrough
```javascript
const { data, error } = await supabase
  .from('management_walkthrough')
  .insert({
    unit_id: 'unit-uuid',
    wilayah_id: null,
    tanggal: '2024-11-15',
    bulan: 11,
    tahun: 2024,
    waktu_mulai: '09:00:00',
    waktu_selesai: '11:30:00',
    manager_id: 'manager-uuid',
    pendamping_ids: ['uuid1', 'uuid2'],
    area_kunjungan: 'Workshop, Gudang, Area Loading',
    fokus_observasi: 'Kepatuhan APD, Housekeeping',
    temuan_positif: 'Semua pekerja menggunakan APD lengkap',
    temuan_perbaikan: 'Safety signage kurang jelas',
    kategori_temuan: 'minor',
    rekomendasi: 'Tambah safety signage',
    pic_tindak_lanjut_id: 'pic-uuid',
    target_selesai: '2024-11-30',
    lampiran_url: 'https://...',
    status: 'draft',
    created_by: 'user-uuid'
  })
  .select()
```

---

### 3.5 Safety Patrol API

#### Get All Safety Patrol
```javascript
const { data, error, count } = await supabase
  .from('safety_patrol')
  .select(`
    *,
    unit:units!unit_id(id, kode_unit, nama_unit),
    wilayah:wilayah!wilayah_id(id, kode_wilayah, nama_wilayah),
    patrol_leader:pegawai!patrol_leader_id(id, nama_lengkap, nip),
    pic_tindak_lanjut:pegawai!pic_tindak_lanjut_id(id, nama_lengkap)
  `, { count: 'exact' })
  .order('tanggal', { ascending: false })
  .range(from, to)
```

#### Create Safety Patrol
```javascript
const { data, error } = await supabase
  .from('safety_patrol')
  .insert({
    unit_id: 'unit-uuid',
    wilayah_id: null,
    tanggal: '2024-11-22',
    waktu_mulai: '14:00:00',
    waktu_selesai: '15:30:00',
    patrol_leader_id: 'leader-uuid',
    anggota_patrol_ids: ['uuid1', 'uuid2'],
    area_patrol: 'Workshop, Gudang, Parkir',
    rute_patrol: 'Workshop → Gudang → Loading → Parkir',
    checklist: [
      { item: 'APD digunakan dengan benar', status: 'ok' },
      { item: 'Housekeeping area kerja', status: 'not_ok', detail: 'Material berserakan' }
    ],
    temuan_unsafe_act: '1 operator tanpa safety glasses',
    temuan_unsafe_condition: 'Material pallet melebihi batas',
    jumlah_temuan: 2,
    kategori_temuan: 'major',
    tindakan_langsung: 'Operator diminta pakai safety glasses',
    tindakan_lanjut: 'Briefing ulang prosedur stacking',
    pic_tindak_lanjut_id: 'pic-uuid',
    target_selesai: '2024-11-25',
    lampiran_url: 'https://...',
    status: 'draft',
    created_by: 'user-uuid'
  })
  .select()
```

#### Get Daily Patrol Status (untuk Unit)
```javascript
const today = new Date().toISOString().split('T')[0]
const { data, error } = await supabase
  .from('safety_patrol')
  .select('*')
  .eq('unit_id', unitId)
  .eq('tanggal', today)

// Check if patrol already done today
const isPatrolDone = data && data.length > 0
```

---

### 3.6 Safety Induction API

#### Get All Safety Induction
```javascript
const { data, error, count } = await supabase
  .from('safety_induction')
  .select(`
    *,
    pegawai:pegawai!pegawai_id(id, nip, nama_lengkap, email),
    tamu_eksternal:tamu_eksternal!tamu_eksternal_id(id, nama_lengkap, perusahaan),
    unit_tujuan:units!unit_tujuan_id(id, nama_unit),
    wilayah_tujuan:wilayah!wilayah_tujuan_id(id, nama_wilayah),
    instructor:pegawai!instructor_id(id, nama_lengkap, nip)
  `, { count: 'exact' })
  .order('tanggal', { ascending: false })
  .range(from, to)
```

#### Filter by Tipe Peserta
```javascript
const { data, error } = await supabase
  .from('safety_induction')
  .select('*')
  .eq('tipe_peserta', 'pegawai') // or 'tamu_eksternal'
  .order('tanggal', { ascending: false })
```

#### Create Safety Induction - Pegawai
```javascript
const { data, error } = await supabase
  .from('safety_induction')
  .insert({
    tanggal: '2024-01-10',
    waktu_mulai: '09:00:00',
    waktu_selesai: '12:00:00',
    tipe_peserta: 'pegawai',
    pegawai_id: 'pegawai-uuid',
    tamu_eksternal_id: null,
    unit_tujuan_id: 'unit-uuid',
    wilayah_tujuan_id: null,
    instructor_id: 'instructor-uuid',
    materi: 'Safety induction tahunan...',
    topik_utama: ['Kebijakan K3', 'Emergency Response', 'APD'],
    lokasi: 'Training Room A',
    durasi_menit: 180,
    metode: 'offline',
    test_hasil: 92.50,
    sertifikat_url: 'https://...',
    masa_berlaku: '2025-01-10',
    status_kelulusan: 'lulus',
    catatan: 'Peserta aktif',
    lampiran_url: 'https://...',
    status: 'draft',
    created_by: 'user-uuid'
  })
  .select()
```

#### Create Safety Induction - Tamu Eksternal
```javascript
// Step 1: Create tamu eksternal record
const { data: tamuData, error: tamuError } = await supabase
  .from('tamu_eksternal')
  .insert({
    nama_lengkap: 'Ahmad Hidayat',
    perusahaan: 'PT Kontraktor ABC',
    email: 'ahmad@kontraktor-abc.com',
    phone: '082345678901',
    nik: '3174012345678901'
  })
  .select()
  .single()

// Step 2: Create induction record
const { data, error } = await supabase
  .from('safety_induction')
  .insert({
    tanggal: '2024-11-20',
    waktu_mulai: '10:00:00',
    waktu_selesai: '10:30:00',
    tipe_peserta: 'tamu_eksternal',
    pegawai_id: null,
    tamu_eksternal_id: tamuData.id,
    unit_tujuan_id: 'unit-uuid',
    wilayah_tujuan_id: null,
    instructor_id: 'instructor-uuid',
    materi: 'Safety briefing untuk tamu',
    topik_utama: ['Aturan Area', 'Emergency Exit', 'APD Wajib'],
    lokasi: 'Security Post',
    durasi_menit: 30,
    metode: 'offline',
    status_kelulusan: 'lulus',
    catatan: 'Tamu untuk site visit',
    status: 'approved',
    approved_by: 'user-uuid',
    approved_at: new Date().toISOString(),
    created_by: 'user-uuid'
  })
  .select()
```

#### Check Induction Expiry
```javascript
// Get pegawai with induction expiring soon
const thirtyDaysFromNow = new Date()
thirtyDaysFromNow.setDate(thirtyDaysFromNow.getDate() + 30)

const { data, error } = await supabase
  .from('safety_induction')
  .select(`
    *,
    pegawai:pegawai!pegawai_id(id, nip, nama_lengkap, email)
  `)
  .eq('tipe_peserta', 'pegawai')
  .lte('masa_berlaku', thirtyDaysFromNow.toISOString().split('T')[0])
  .order('masa_berlaku', { ascending: true })
```

---

### 3.7 Safety Drill API

#### Get All Safety Drill
```javascript
const { data, error, count } = await supabase
  .from('safety_drill')
  .select(`
    *,
    unit:units!unit_id(id, kode_unit, nama_unit),
    wilayah:wilayah!wilayah_id(id, kode_wilayah, nama_wilayah),
    koordinator:pegawai!koordinator_id(id, nama_lengkap, jabatan),
    pic_tindak_lanjut:pegawai!pic_tindak_lanjut_id(id, nama_lengkap)
  `, { count: 'exact' })
  .order('tanggal', { ascending: false })
  .range(from, to)
```

#### Filter by Jenis Drill
```javascript
const { data, error } = await supabase
  .from('safety_drill')
  .select('*')
  .eq('jenis_drill', 'fire') // fire / earthquake / evacuation / emergency_response
  .order('tanggal', { ascending: false })
```

#### Create Safety Drill
```javascript
const { data, error } = await supabase
  .from('safety_drill')
  .insert({
    unit_id: null,
    wilayah_id: 'wilayah-uuid',
    tanggal: '2024-08-15',
    waktu_mulai: '10:00:00',
    waktu_selesai: '11:30:00',
    jenis_drill: 'fire',
    tipe_drill: 'unannounced',
    koordinator_id: 'koordinator-uuid',
    tim_drill_ids: ['uuid1', 'uuid2'],
    lokasi: 'Gedung Kantor Wilayah',
    skenario: 'Simulasi kebakaran di lantai 3',
    jumlah_peserta: 120,
    peserta_ids: ['uuid1', 'uuid2'],
    waktu_evakuasi: 285,
    target_waktu: 300,
    evaluasi: 'Drill berjalan lancar',
    temuan_positif: 'Waktu evakuasi di bawah target',
    temuan_perbaikan: 'Beberapa orang masih membawa barang',
    rekomendasi: 'Sosialisasi ulang prosedur',
    pic_tindak_lanjut_id: 'pic-uuid',
    target_selesai: '2024-09-30',
    skor_keseluruhan: 88.00,
    status_drill: 'sukses',
    lampiran_url: 'https://...',
    status: 'draft',
    created_by: 'user-uuid'
  })
  .select()
```

#### Get Drill Statistics
```javascript
// Count drills per jenis in current year
const { data, error } = await supabase
  .from('safety_drill')
  .select('jenis_drill')
  .eq('tahun', 2024)
  .eq('unit_id', unitId)

// Process in frontend
const stats = data.reduce((acc, item) => {
  acc[item.jenis_drill] = (acc[item.jenis_drill] || 0) + 1
  return acc
}, {})
```

---

## 4. File Upload API

### 4.1 Upload File to Storage
```javascript
// Upload to specific bucket
const uploadFile = async (bucket, file, path) => {
  const fileExt = file.name.split('.').pop()
  const fileName = `${Math.random()}.${fileExt}`
  const filePath = `${path}/${fileName}`

  const { data, error } = await supabase.storage
    .from(bucket)
    .upload(filePath, file)

  if (error) throw error

  // Get public URL
  const { data: { publicUrl } } = supabase.storage
    .from(bucket)
    .getPublicUrl(filePath)

  return publicUrl
}

// Example usage
const photoUrl = await uploadFile(
  'hsse-photos',
  photoFile,
  'safety_briefing/2024/11'
)
```

### 4.2 Delete File from Storage
```javascript
const deleteFile = async (bucket, filePath) => {
  const { error } = await supabase.storage
    .from(bucket)
    .remove([filePath])

  if (error) throw error
}
```

### 4.3 List Files in Bucket
```javascript
const { data, error } = await supabase.storage
  .from('hsse-photos')
  .list('safety_briefing/2024/11')
```

---

## 5. Dashboard & Statistics APIs

### 5.1 Dashboard Summary
```javascript
// Get counts for current month
const getDashboardSummary = async (unitId, wilayahId) => {
  const today = new Date()
  const firstDay = new Date(today.getFullYear(), today.getMonth(), 1)
  const lastDay = new Date(today.getFullYear(), today.getMonth() + 1, 0)

  const filter = unitId 
    ? { unit_id: unitId }
    : { wilayah_id: wilayahId }

  // Safety Briefing Count
  const { count: briefingCount } = await supabase
    .from('safety_briefing')
    .select('*', { count: 'exact', head: true })
    .match(filter)
    .gte('tanggal', firstDay.toISOString().split('T')[0])
    .lte('tanggal', lastDay.toISOString().split('T')[0])

  // Silent Inspection Count (current quarter)
  const quarter = Math.floor((today.getMonth() + 3) / 3)
  const { count: inspectionCount } = await supabase
    .from('silent_inspection')
    .select('*', { count: 'exact', head: true })
    .match(filter)
    .eq('tahun', today.getFullYear())
    .eq('triwulan', quarter)

  // Safety Patrol Count (today for unit, this month for wilayah)
  const patrolFilter = unitId
    ? { unit_id: unitId, tanggal: today.toISOString().split('T')[0] }
    : { wilayah_id: wilayahId }

  let patrolQuery = supabase
    .from('safety_patrol')
    .select('*', { count: 'exact', head: true })
    .match(patrolFilter)

  if (!unitId) {
    patrolQuery = patrolQuery
      .gte('tanggal', firstDay.toISOString().split('T')[0])
      .lte('tanggal', lastDay.toISOString().split('T')[0])
  }

  const { count: patrolCount } = await patrolQuery

  return {
    briefingCount,
    inspectionCount,
    patrolCount
  }
}
```

### 5.2 Trend Data for Chart
```javascript
// Get Safety Briefing trend for last 6 months
const getTrendData = async (moduleName, unitId, wilayahId) => {
  const sixMonthsAgo = new Date()
  sixMonthsAgo.setMonth(sixMonthsAgo.getMonth() - 6)

  const filter = unitId 
    ? { unit_id: unitId }
    : { wilayah_id: wilayahId }

  const { data, error } = await supabase
    .from(moduleName)
    .select('tanggal')
    .match(filter)
    .gte('tanggal', sixMonthsAgo.toISOString().split('T')[0])
    .order('tanggal', { ascending: true })

  // Process data to group by month
  const trendByMonth = data.reduce((acc, item) => {
    const month = item.tanggal.substring(0, 7) // YYYY-MM
    acc[month] = (acc[month] || 0) + 1
    return acc
  }, {})

  return trendByMonth
}
```

### 5.3 Temuan Statistics
```javascript
// Get temuan by kategori
const getTemuanStats = async (unitId, wilayahId) => {
  const filter = unitId 
    ? { unit_id: unitId }
    : { wilayah_id: wilayahId }

  // Get from Silent Inspection
  const { data: inspectionData } = await supabase
    .from('silent_inspection')
    .select('kategori_temuan')
    .match(filter)
    .not('kategori_temuan', 'is', null)

  // Get from Safety Patrol
  const { data: patrolData } = await supabase
    .from('safety_patrol')
    .select('kategori_temuan')
    .match(filter)
    .not('kategori_temuan', 'is', null)

  // Combine and count
  const allTemuan = [...inspectionData, ...patrolData]
  const stats = allTemuan.reduce((acc, item) => {
    acc[item.kategori_temuan] = (acc[item.kategori_temuan] || 0) + 1
    return acc
  }, {})

  return stats
}
```

---

## 6. Real-time Subscriptions

### 6.1 Subscribe to Changes
```javascript
// Subscribe to new safety_briefing records
const subscription = supabase
  .channel('safety_briefing_changes')
  .on(
    'postgres_changes',
    {
      event: 'INSERT',
      schema: 'public',
      table: 'safety_briefing',
      filter: `unit_id=eq.${unitId}`
    },
    (payload) => {
      console.log('New briefing:', payload.new)
      // Update UI
    }
  )
  .subscribe()

// Unsubscribe when component unmounts
subscription.unsubscribe()
```

### 6.2 Subscribe to Status Changes
```javascript
const subscription = supabase
  .channel('status_changes')
  .on(
    'postgres_changes',
    {
      event: 'UPDATE',
      schema: 'public',
      table: 'safety_briefing',
      filter: `id=eq.${briefingId}`
    },
    (payload) => {
      if (payload.new.status === 'approved') {
        console.log('Briefing approved!')
        // Show notification
      }
    }
  )
  .subscribe()
```

---

## 7. RPC Functions (Custom SQL Functions)

### 7.1 Get Briefing Statistics by Unit
```sql
-- Create function in Supabase SQL Editor
CREATE OR REPLACE FUNCTION get_briefing_stats_by_unit(
  tahun_param INTEGER,
  bulan_param INTEGER
)
RETURNS TABLE (
  unit_id UUID,
  unit_name TEXT,
  total_briefing BIGINT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    u.id as unit_id,
    u.nama_unit as unit_name,
    COUNT(sb.id) as total_briefing
  FROM units u
  LEFT JOIN safety_briefing sb ON u.id = sb.unit_id
    AND EXTRACT(YEAR FROM sb.tanggal) = tahun_param
    AND EXTRACT(MONTH FROM sb.tanggal) = bulan_param
  WHERE u.status = 'aktif'
  GROUP BY u.id, u.nama_unit
  ORDER BY total_briefing DESC;
END;
$$ LANGUAGE plpgsql;
```

**Call from JavaScript**:
```javascript
const { data, error } = await supabase
  .rpc('get_briefing_stats_by_unit', {
    tahun_param: 2024,
    bulan_param: 11
  })
```

### 7.2 Get Compliance Rate
```sql
-- Calculate compliance rate (patrol done vs expected)
CREATE OR REPLACE FUNCTION get_patrol_compliance(
  unit_id_param UUID,
  tahun_param INTEGER,
  bulan_param INTEGER
)
RETURNS JSON AS $$
DECLARE
  expected_count INTEGER;
  actual_count INTEGER;
  compliance_rate DECIMAL(5,2);
BEGIN
  -- Expected: working days in month (assume 22 days)
  expected_count := 22;
  
  -- Actual: count patrol done
  SELECT COUNT(*) INTO actual_count
  FROM safety_patrol
  WHERE unit_id = unit_id_param
    AND EXTRACT(YEAR FROM tanggal) = tahun_param
    AND EXTRACT(MONTH FROM tanggal) = bulan_param;
  
  compliance_rate := (actual_count::DECIMAL / expected_count::DECIMAL) * 100;
  
  RETURN json_build_object(
    'expected', expected_count,
    'actual', actual_count,
    'compliance_rate', compliance_rate
  );
END;
$$ LANGUAGE plpgsql;
```

---

## 8. Error Handling

### 8.1 Standard Error Response
```javascript
{
  "error": {
    "code": "23505", // Postgres error code
    "message": "duplicate key value violates unique constraint",
    "details": "Key (kode_unit)=(UNIT-001) already exists.",
    "hint": null
  }
}
```

### 8.2 Error Handling Pattern
```javascript
const handleSupabaseError = (error) => {
  if (!error) return null

  // Duplicate key
  if (error.code === '23505') {
    return 'Data sudah ada di sistem'
  }

  // Foreign key violation
  if (error.code === '23503') {
    return 'Data terkait tidak ditemukan'
  }

  // RLS policy violation
  if (error.code === '42501') {
    return 'Anda tidak memiliki akses untuk operasi ini'
  }

  // Default
  return error.message || 'Terjadi kesalahan'
}

// Usage
const { data, error } = await supabase.from('units').insert(newUnit)
if (error) {
  const message = handleSupabaseError(error)
  console.error(message)
}
```

---

## 9. Performance Best Practices

### 9.1 Selective Field Loading
```javascript
// ❌ Bad: Load all fields including heavy JSONB
const { data } = await supabase
  .from('safety_patrol')
  .select('*')

// ✅ Good: Load only needed fields
const { data } = await supabase
  .from('safety_patrol')
  .select('id, tanggal, area_patrol, jumlah_temuan, status')
```

### 9.2 Pagination
```javascript
// Always use pagination for lists
const pageSize = 20
const page = 1
const from = (page - 1) * pageSize
const to = from + pageSize - 1

const { data, count } = await supabase
  .from('safety_briefing')
  .select('*', { count: 'exact' })
  .range(from, to)

const totalPages = Math.ceil(count / pageSize)
```

### 9.3 Query Optimization
```javascript
// ❌ Bad: Multiple queries
const briefing = await supabase.from('safety_briefing').select('*').eq('id', id).single()
const unit = await supabase.from('units').select('*').eq('id', briefing.data.unit_id).single()
const petugas = await supabase.from('pegawai').select('*').eq('id', briefing.data.petugas_id).single()

// ✅ Good: Single query with joins
const { data } = await supabase
  .from('safety_briefing')
  .select(`
    *,
    unit:units!unit_id(*),
    petugas:pegawai!petugas_id(*)
  `)
  .eq('id', id)
  .single()
```

---

## Summary

**Total Endpoints**: ~70+ endpoints across 7 HSSE modules + master data

**Main Operations**:
- CRUD for all 7 HSSE modules
- Advanced filtering (date range, unit, wilayah, status)
- Pagination & search
- File upload/download
- Dashboard statistics
- Real-time subscriptions

**Next**: Vue.js Folder Structure (03_VUE_FOLDER_STRUCTURE.md)
