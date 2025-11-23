# Setup Storage Bucket for Unsafe Action/Condition Files

## Problem
The unsafe action/condition form was failing with 400 Bad Request error when trying to upload photos, videos, or audio files because the required storage bucket didn't exist.

## Solution
Created a dedicated storage bucket `unsafe-action-condition-files` for all unsafe action/condition media uploads.

## Manual Setup Required (IMPORTANT)

### 1. Create Storage Bucket in Supabase Dashboard

1. Login to Supabase Dashboard: https://supabase.com/dashboard
2. Select your project: `oxskmrkzxkvifbappsic` (W3safe)
3. Go to **Storage** in the left menu
4. Click **New bucket**
5. Fill in the form:
   - **Name**: `unsafe-action-condition-files`
   - **Public bucket**: ✅ Check (files need to be publicly accessible)
   - **File size limit**: 10MB (for video files)
   - **Allowed MIME types**: Add the following:
     - `image/jpeg`, `image/png`, `image/jpg`, `image/webp`
     - `video/mp4`, `video/webm`, `video/avi`, `video/quicktime`
     - `audio/mpeg`, `audio/wav`, `audio/webm`, `audio/mp3`, `audio/m4a`
6. Click **Create bucket**

### 2. Setup Storage Policies

After creating the bucket, run the SQL in `supabase/create-unsafe-action-condition-storage.sql` in the Supabase SQL Editor:

1. Go to **SQL Editor** in Supabase Dashboard
2. Copy the entire contents of `supabase/create-unsafe-action-condition-storage.sql`
3. Paste and run the SQL
4. Verify the policies were created by checking the last query result (should show the policies)

### 3. Test the Setup

After completing both steps above:
- Photo uploads should work in the unsafe action/condition form
- Video uploads should work
- Audio recordings should work

## Alternative: Run Setup Script

If you prefer, you can try running the automated script (though it may fail due to permissions):

```bash
node create-unsafe-action-condition-bucket.js
```

But manual setup through the dashboard is recommended.

## Files Updated

- ✅ `src/services/hsse/unsafe-action-condition.service.ts` - Updated to use `unsafe-action-condition-files` bucket
- ✅ `supabase/create-unsafe-action-condition-storage.sql` - Storage policies
- ✅ `SETUP-UNSAFE-ACTION-CONDITION-STORAGE.md` - This documentation
- ✅ `create-unsafe-action-condition-bucket.js` - Automated setup script