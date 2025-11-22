# 🚀 Quick Reference: Create Unit Users

## TL;DR

**Tujuan**: Buat user untuk setiap unit dengan password yang sama

**Format User**:
- Username: `{kode_unit}` (lowercase)
- Email: `{kode_unit}@w3safe.local`  
- Password: `@w3Safe` (SAMA UNTUK SEMUA)

---

## Quick Steps

### 1. Get Unit List
```sql
SELECT 
  kode,
  nama,
  LOWER(kode) || '@w3safe.local' as email
FROM units 
WHERE aktif = true 
ORDER BY kode;
```
Run di: **Supabase SQL Editor**

### 2. Create Users
**Location**: Supabase Dashboard > Authentication > Users > Add user

**For each unit**:
```
Email: {kode}@w3safe.local
Password: @w3Safe
Auto Confirm: ✅
```

### 3. Test
```
Email: wil1@w3safe.local
Password: @w3Safe
```

---

## Files Created

| File | Purpose |
|------|---------|
| `supabase/generate-unit-users.sql` | SQL query untuk list units |
| `scripts/create-unit-users.ts` | Auto script (needs service key) |
| `scripts/generate-user-list.ts` | Generate JSON list |
| `docs/PANDUAN_BUAT_USER_UNIT.md` | Full documentation (BACA INI) |
| `docs/CREATE_UNIT_USERS.md` | Alternative guide |

---

## Password Info

**Default**: `@w3Safe`

✅ Meets requirements:
- 7 characters
- Uppercase: S
- Lowercase: w, a, f, e
- Special: @
- Number: 3

---

## Next: Read Full Guide

📖 **File**: `docs/PANDUAN_BUAT_USER_UNIT.md`

Berisi:
- Step-by-step dengan screenshot
- Troubleshooting
- User metadata setup
- RLS policy examples
- Security best practices
