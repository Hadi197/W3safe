# 🔍 Troubleshoot Silent Inspection Storage Error

## ❌ Problem Statement

Bucket `silent-inspection-photos` sudah ada di Supabase, tapi masih dapat error:
```
POST https://oxskmrkzxkvifbappsic.supabase.co/storage/v1/object/silent-inspection-photos/... 400 (Bad Request)
```

## 🔍 Diagnosis Steps

### Step 1: Check Bucket Configuration

**Via Supabase Dashboard:**
1. Go to **Storage** → `silent-inspection-photos`
2. Verify:
   - ✅ **Public bucket** = `true`
   - ✅ **File size limit** = 1MB or more
   - ✅ **Allowed MIME types** include: `image/jpeg, image/png, image/jpg, image/webp`

### Step 2: Check Storage Policies

**Via Supabase Dashboard:**
1. Go to **Storage** → `silent-inspection-photos` → **Policies** tab
2. Required policies:

| Operation | Policy Name | Who | Status |
|-----------|-------------|-----|--------|
| INSERT (Upload) | `silent-inspection-insert` | `authenticated` | ❓ Check |
| SELECT (View) | `silent-inspection-select` | `public` | ❓ Check |
| UPDATE (Modify) | `silent-inspection-update` | `authenticated` | ❓ Check |
| DELETE (Remove) | `silent-inspection-delete` | `authenticated` | ❓ Check |

**SQL untuk check policies:**
```sql
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename = 'objects'
  AND policyname LIKE '%silent-inspection%';
```

### Step 3: Test Authentication

**Via Browser Console:**
```javascript
// Check if user is authenticated
console.log('Auth status:', supabase.auth.user() ? '✅ Authenticated' : '❌ Not authenticated')
```

## 🛠️ Quick Fixes

### Fix A: Setup Policies via Script
```bash
cd hsse-app
node setup-silent-inspection-policies-only.js
```

### Fix B: Manual Policy Setup
Jika script tidak work, jalankan SQL ini di **Supabase SQL Editor**:

```sql
-- Drop existing policies if any
DROP POLICY IF EXISTS "silent-inspection-insert" ON storage.objects;
DROP POLICY IF EXISTS "silent-inspection-select" ON storage.objects;
DROP POLICY IF EXISTS "silent-inspection-update" ON storage.objects;
DROP POLICY IF EXISTS "silent-inspection-delete" ON storage.objects;

-- Create INSERT policy (most important for upload)
CREATE POLICY "silent-inspection-insert"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'silent-inspection-photos');

-- Create SELECT policy (for viewing)
CREATE POLICY "silent-inspection-select"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'silent-inspection-photos');

-- Create UPDATE policy (for modifying)
CREATE POLICY "silent-inspection-update"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'silent-inspection-photos')
WITH CHECK (bucket_id = 'silent-inspection-photos');

-- Create DELETE policy (for removing)
CREATE POLICY "silent-inspection-delete"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'silent-inspection-photos');
```

### Fix C: Test Upload
```bash
cd hsse-app
node test-silent-inspection-upload.js
```

## 🔍 Common Issues & Solutions

### Issue 1: "new row violates row-level security policy"
**Cause:** Missing INSERT policy
**Fix:** Run the INSERT policy SQL above

### Issue 2: "Permission denied for schema storage"
**Cause:** User not authenticated
**Fix:** Pastikan user sudah login di aplikasi

### Issue 3: "File type not allowed"
**Cause:** MIME type not in allowed list
**Fix:** Check bucket configuration allows: `image/jpeg, image/png, image/jpg, image/webp`

### Issue 4: "File too large"
**Cause:** File exceeds size limit
**Fix:** Set file size limit to 1MB or more in bucket config

### Issue 5: Bucket not public
**Cause:** Bucket set to private
**Fix:** Set bucket to public in Supabase Dashboard

## 🧪 Testing Steps

### Test 1: Manual Upload via Dashboard
1. Supabase Dashboard → Storage → silent-inspection-photos
2. Try upload a small image file manually
3. If successful: ✅ Policies OK
4. If failed: ❌ Check policies

### Test 2: Application Upload
1. Run app: `npm run dev`
2. Login to app
3. Go to Silent Inspection → Add new
4. Upload photo
5. Check browser console for errors

### Test 3: Browser Console Test
```javascript
// Test basic storage access
const { data, error } = await supabase.storage
  .from('silent-inspection-photos')
  .list()
console.log('List result:', { data, error })

// Test upload small file
const testFile = new File(['test'], 'test.txt', { type: 'text/plain' })
const { data: uploadData, error: uploadError } = await supabase.storage
  .from('silent-inspection-photos')
  .upload('test.txt', testFile)
console.log('Upload result:', { uploadData, uploadError })
```

## 📋 Verification Checklist

- [ ] Bucket `silent-inspection-photos` exists ✅ (user confirmed)
- [ ] Bucket is set to **Public** ✅
- [ ] File size limit ≥ 1MB ✅
- [ ] MIME types include image formats ✅
- [ ] INSERT policy exists for authenticated users ❓
- [ ] SELECT policy exists for public ❓
- [ ] User is authenticated when uploading ❓
- [ ] Manual upload via Dashboard works ❓
- [ ] Application upload works ❓

## 🚨 Emergency Fix

Jika semua tidak work, coba:

1. **Delete & Recreate Bucket:**
   ```sql
   -- Delete bucket (this will delete all files!)
   DELETE FROM storage.objects WHERE bucket_id = 'silent-inspection-photos';
   DELETE FROM storage.buckets WHERE id = 'silent-inspection-photos';
   ```

2. **Recreate via Script:**
   ```bash
   node create-silent-inspection-bucket.js
   node setup-silent-inspection-policies-only.js
   ```

## 📞 Next Steps

1. Run: `node test-silent-inspection-upload.js`
2. Check hasil dan ikuti rekomendasi
3. Jika masih error, share error message lengkap
4. Check browser Network tab untuk request details

---

**Status:** 🔍 Diagnosis in progress
**Next:** Run test script and check policies

