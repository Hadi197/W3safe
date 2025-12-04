# Auto Unit ID Feature - Dokumentasi

## Overview
Fitur auto-fill unit_id berdasarkan user yang login. Setiap user yang dibuat dari units akan otomatis memiliki unit_id dan unit_kode di metadata mereka, sehingga ketika membuat form baru, field unit akan otomatis terisi.

## Implementasi

### 1. Auth Store Enhancement
**File**: `hsse-app/src/stores/auth.ts`

Menambahkan computed properties baru:
```typescript
const unitId = computed(() => user.value?.user_metadata?.unit_id || null)
const unitKode = computed(() => user.value?.user_metadata?.unit_kode || null)
const userName = computed(() => user.value?.user_metadata?.username || user.value?.email || '')
```

Properties yang di-export:
- `unitId` - ID unit dari user yang login
- `unitKode` - Kode unit (misal: UNIT-001)
- `userName` - Username atau email user

### 2. Form Views Updated

Semua form view HSSE sudah diupdate untuk auto-set `unit_id` saat membuat record baru:

#### a. SafetyBriefingView
- **File**: `hsse-app/src/views/hsse/SafetyBriefingView.vue`
- **Location**: `resetForm()` function
- **Set**: `unit_id: authStore.unitId || ''`

#### b. SafetyPatrolView
- **File**: `hsse-app/src/views/hsse/SafetyPatrolView.vue`
- **Location**: `openFormModal()` function (create mode)
- **Set**: `unit_id: authStore.unitId || ''`

#### c. SilentInspectionView
- **File**: `hsse-app/src/views/hsse/SilentInspectionView.vue`
- **Location**: `resetForm()` function
- **Set**: `unit_id: authStore.unitId || ''`

#### d. SafetyForumView
- **File**: `hsse-app/src/views/hsse/SafetyForumView.vue`
- **Location**: Form reset in `openFormModal()`
- **Set**: `unit_id: authStore.unitId || ''`

#### e. ManagementWalkthroughView
- **File**: `hsse-app/src/views/ManagementWalkthroughView.vue`
- **Location**: `resetFormData()` function
- **Set**: `unit_id: authStore.unitId || ''`

#### f. SafetyDrillView
- **File**: `hsse-app/src/views/hsse/SafetyDrillView.vue`
- **Location**: `resetForm()` function
- **Set**: `unit_kerja: authStore.unitId || ''`
- **Note**: Menggunakan field `unit_kerja` bukan `unit_id`

#### g. SafetyInductionView
- **File**: `hsse-app/src/views/hsse/SafetyInductionView.vue`
- **Location**: `openFormModal()` function (create mode)
- **Set**: `unit_id: authStore.unitId || ''`

## User Flow

### Before (Manual Selection)
1. User login dengan email unit (misal: `unit-001@w3safe.local`)
2. User membuka form Safety Briefing
3. User harus **manual pilih** unit dari dropdown
4. Kemungkinan user salah pilih unit atau lupa mengisi

### After (Auto Selection)
1. User login dengan email unit (misal: `unit-001@w3safe.local`)
2. User membuka form Safety Briefing
3. Field "Unit" **otomatis terisi** sesuai unit user yang login
4. User bisa langsung isi field lainnya tanpa khawatir salah unit
5. User tetap bisa ganti unit jika diperlukan (untuk role tertentu)

## Benefits

✅ **Efisiensi**: User tidak perlu cari dan pilih unit setiap kali buat form
✅ **Akurasi**: Mengurangi kesalahan input unit yang salah
✅ **Konsistensi**: Semua record otomatis terkait dengan unit yang benar
✅ **User Experience**: Form lebih cepat diisi, fokus ke data yang penting

## Technical Details

### Import Pattern
Setiap view yang diupdate menggunakan pattern yang sama:

```typescript
import { useAuthStore } from '@/stores/auth'

// Di dalam setup
const authStore = useAuthStore()

// Saat reset/create form baru
form.value = {
  // ... fields lain
  unit_id: authStore.unitId || '',
  // ... fields lain
}
```

### User Metadata Structure
User metadata yang disimpan di Supabase auth.users:
```json
{
  "role": "user",
  "username": "UNIT-001",
  "unit_id": "abc123-def456-ghi789",
  "unit_kode": "UNIT-001"
}
```

Metadata ini diset saat user dibuat melalui:
- SQL script: `auto-create-users-from-units.sql`
- Manual creation dengan metadata

## Related Files

### Core Files
- `hsse-app/src/stores/auth.ts` - Auth store dengan unit info
- `auto-create-users-from-units.sql` - Script membuat user dengan metadata
- `DOKUMENTASI_USER_PASSWORD.md` - Dokumentasi user management

### Form View Files (Updated)
- `hsse-app/src/views/hsse/SafetyBriefingView.vue`
- `hsse-app/src/views/hsse/SafetyPatrolView.vue`
- `hsse-app/src/views/hsse/SilentInspectionView.vue`
- `hsse-app/src/views/hsse/SafetyForumView.vue`
- `hsse-app/src/views/ManagementWalkthroughView.vue`
- `hsse-app/src/views/hsse/SafetyDrillView.vue`
- `hsse-app/src/views/hsse/SafetyInductionView.vue`

## Testing

### Test Scenario
1. Login dengan user unit (misal: `unit-001@w3safe.local`, password: `password123`)
2. Buka setiap modul form:
   - Safety Briefing
   - Safety Patrol
   - Silent Inspection
   - Safety Forum
   - Management Walkthrough
   - Safety Drill
   - Safety Induction
3. Klik tombol "Tambah" atau "Buat Baru"
4. Verifikasi field unit sudah terisi otomatis dengan unit yang sesuai
5. Coba isi dan submit form untuk memastikan data tersimpan dengan benar

### Expected Results
- ✅ Field unit otomatis terisi saat buka form baru
- ✅ Unit yang terisi sesuai dengan unit user yang login
- ✅ Data tersimpan dengan unit_id yang benar
- ✅ Edit mode tetap menggunakan unit dari data existing

## Future Enhancements

Potensi pengembangan fitur ini:

1. **Role-based Unit Access**
   - Admin/Wilayah bisa pilih unit lain
   - Unit user hanya bisa lihat/edit data unit sendiri

2. **Unit Hierarchy Display**
   - Tampilkan info Wilayah > Area > Unit
   - Breadcrumb navigation berdasarkan unit

3. **Unit-based Dashboard**
   - Filter otomatis dashboard berdasarkan unit user
   - Statistik spesifik untuk unit

4. **Mobile Integration**
   - Sync unit info ke Flutter app
   - Auto-set unit di mobile forms juga

## Troubleshooting

### Q: Field unit masih kosong setelah login?
**A**: Pastikan user memiliki `unit_id` di metadata:
```sql
SELECT 
  id, 
  email, 
  raw_user_meta_data->>'unit_id' as unit_id,
  raw_user_meta_data->>'unit_kode' as unit_kode
FROM auth.users 
WHERE email = 'your-email@w3safe.local';
```

### Q: User bisa ganti unit saat buat form?
**A**: Ya, field unit tetap editable. Auto-fill hanya untuk convenience.

### Q: Bagaimana untuk role Admin yang manage semua unit?
**A**: Admin bisa override unit_id sesuai kebutuhan. Auto-fill hanya default value.

## Version History

- **v1.0** (Dec 4, 2024) - Initial implementation
  - Added unit info to auth store
  - Updated 7 form views with auto unit_id
  - Created documentation

---

**Last Updated**: December 4, 2024  
**Author**: W3safe Development Team
