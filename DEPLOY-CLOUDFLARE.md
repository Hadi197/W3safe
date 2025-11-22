# Deploy W3Safe ke Cloudflare Pages

## Prerequisites
- Akun Cloudflare (gratis)
- Repository GitHub sudah ter-push (✓ https://github.com/Hadi197/W3safe)
- Supabase project sudah setup

## Cara 1: Deploy via Cloudflare Dashboard (Paling Mudah)

### Step 1: Buat Project di Cloudflare Pages
1. Login ke https://dash.cloudflare.com
2. Pilih **Workers & Pages** di sidebar kiri
3. Klik **Create Application**
4. Pilih tab **Pages**
5. Klik **Connect to Git**

### Step 2: Connect ke GitHub Repository
1. Authorize Cloudflare untuk akses GitHub Anda
2. Pilih repository: **Hadi197/W3safe**
3. Klik **Begin Setup**

### Step 3: Configure Build Settings
Isi form dengan setting berikut:

**Project Name**: `w3safe` (atau nama custom Anda)

**Production Branch**: `main`

**Build Settings**:
- **Framework preset**: `Vue`
- **Build command**: 
  ```
  cd hsse-app && npm install && npm run build
  ```
- **Build output directory**: 
  ```
  hsse-app/dist
  ```

**Root directory**: (kosongkan atau isi `/`)

### Step 4: Environment Variables
Tambahkan environment variables berikut (klik **Add variable**):

| Variable Name | Value |
|--------------|-------|
| `VITE_SUPABASE_URL` | URL Supabase Anda (dari dashboard) |
| `VITE_SUPABASE_ANON_KEY` | Anon key dari Supabase |
| `NODE_VERSION` | `18` (atau `20`) |

**Cara mendapatkan Supabase credentials:**
1. Buka Supabase Dashboard
2. Pilih project Anda
3. Pergi ke **Settings** → **API**
4. Copy **Project URL** dan **anon/public key**

### Step 5: Deploy
1. Klik **Save and Deploy**
2. Tunggu proses build (3-5 menit)
3. Setelah selesai, Anda akan mendapat URL seperti: `https://w3safe.pages.dev`

---

## Cara 2: Deploy via Wrangler CLI (Command Line)

### Step 1: Install Wrangler
```bash
npm install -g wrangler
```

### Step 2: Login ke Cloudflare
```bash
wrangler login
```

### Step 3: Build Aplikasi
```bash
cd hsse-app
npm install
npm run build
```

### Step 4: Deploy
```bash
wrangler pages deploy dist --project-name=w3safe
```

---

## Setup Custom Domain (Opsional)

### Jika Anda punya domain sendiri:
1. Di Cloudflare Pages dashboard
2. Pilih project **w3safe**
3. Pergi ke tab **Custom domains**
4. Klik **Set up a custom domain**
5. Masukkan domain Anda (contoh: `w3safe.com`)
6. Ikuti instruksi untuk update DNS records

---

## Update Supabase Configuration

Setelah deploy, tambahkan URL Cloudflare ke Supabase allowed URLs:

1. Buka Supabase Dashboard
2. Pergi ke **Authentication** → **URL Configuration**
3. Tambahkan URL Cloudflare Anda ke:
   - **Site URL**: `https://w3safe.pages.dev`
   - **Redirect URLs**: `https://w3safe.pages.dev/**`

---

## Automatic Deployments

Cloudflare Pages otomatis akan rebuild dan deploy setiap kali Anda push ke GitHub:
- Push ke branch `main` → Deploy ke **Production**
- Push ke branch lain → Deploy ke **Preview** (staging)

---

## Troubleshooting

### Build Failed?
**Cek error di build log**. Masalah umum:
- Environment variables belum diset
- Node version tidak kompatibel
- Build command salah

### 404 Error pada routing?
Buat file `hsse-app/public/_redirects`:
```
/* /index.html 200
```

Atau buat file `hsse-app/public/_headers`:
```
/*
  X-Frame-Options: DENY
  X-Content-Type-Options: nosniff
```

### Supabase Connection Error?
- Pastikan environment variables sudah benar
- Cek apakah URL Cloudflare sudah ditambahkan ke Supabase allowed URLs
- Verify CORS settings di Supabase

---

## Monitoring & Logs

1. Pergi ke Cloudflare Pages dashboard
2. Pilih project **w3safe**
3. Tab **Deployments** - lihat history deploy
4. Tab **Functions** - lihat function logs (jika ada)
5. Tab **Analytics** - lihat traffic statistics

---

## Cost

Cloudflare Pages **GRATIS** untuk:
- Unlimited requests
- Unlimited bandwidth
- Unlimited sites
- 500 builds per month
- 1 concurrent build

Sangat cocok untuk production!
