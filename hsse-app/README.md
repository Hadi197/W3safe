# 🏥 HSSE Management System

Aplikasi manajemen Health, Safety, Security & Environment (HSSE) berbasis Vue.js 3 + Supabase.

## 📋 Features

### ✅ Implemented (Phase 1)
- ✅ Vue.js 3 + TypeScript + Composition API
- ✅ Tailwind CSS untuk styling
- ✅ Pinia untuk state management
- ✅ Vue Router dengan authentication guards
- ✅ Supabase authentication & database
- ✅ Base Components (Input, Textarea, Select, DatePicker, FileUpload)
- ✅ Layout System (Auth Layout, Default Layout with Sidebar)
- ✅ Login & Profile pages
- ✅ Dashboard skeleton
- ✅ Placeholder pages untuk 7 HSSE modules

### 🚧 In Progress (Phase 2)
- 🚧 Master Data CRUD (Units, Wilayah, Pegawai, Tamu)
- 🚧 Dashboard dengan Chart.js
- 🚧 7 HSSE Modules dengan full CRUD

### 📦 Planned (Phase 3)
- 📦 File upload ke Supabase Storage
- 📦 Export to PDF/Excel
- 📦 Real-time notifications
- 📦 Advanced filtering & search
- 📦 Role-based permissions

## 🛠️ Tech Stack

- **Frontend**: Vue.js 3, TypeScript, Tailwind CSS
- **State Management**: Pinia
- **Routing**: Vue Router 4
- **Backend**: Supabase (PostgreSQL + Auth + Storage)
- **Charts**: Chart.js + vue-chartjs
- **Utilities**: date-fns, @vueuse/core

## 🚀 Quick Start

### Prerequisites
- Node.js >= 20.19.0
- Supabase Account

### Installation

1. **Install dependencies**
```bash
npm install
```

2. **Setup Environment Variables**

Edit file `.env.local`:
```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```

3. **Setup Database**

Jalankan migration SQL dari file `../07_MIGRATION_SQL.md` di Supabase SQL Editor:
- Migration 1: Enable UUID extension
- Migration 2: Create master tables
- Migration 3: Create HSSE transaction tables
- Migration 4: Create indexes
- Migration 5: Enable RLS policies
- Migration 6: Create helper functions
- Migration 7: Create triggers
- Migration 8: Insert sample data

4. **Run Development Server**
```bash
npm run dev
```

Server akan berjalan di: http://localhost:5173/

## 📁 Project Structure

```
src/
├── assets/              # CSS, images, fonts
│   └── main.css        # Tailwind imports & custom classes
├── components/
│   ├── base/           # Reusable base components
│   │   ├── BaseInput.vue
│   │   ├── BaseTextarea.vue
│   │   ├── BaseSelect.vue
│   │   ├── BaseDatePicker.vue
│   │   └── BaseFileUpload.vue
│   └── layout/         # Layout components
│       ├── AuthLayout.vue
│       └── DefaultLayout.vue
├── composables/        # Reusable composition functions
├── router/            
│   └── index.ts        # Route definitions & guards
├── services/
│   └── api/           # API service layer
│       ├── supabase.ts
│       └── auth.service.ts
├── stores/            # Pinia stores
│   └── auth.ts        # Authentication store
├── types/             # TypeScript type definitions
├── utils/             # Utility functions
├── views/             # Page components
│   ├── auth/          # Auth pages (Login, etc)
│   ├── master/        # Master data pages
│   ├── hsse/          # HSSE module pages
│   ├── DashboardView.vue
│   ├── ProfileView.vue
│   └── NotFoundView.vue
├── App.vue
└── main.ts
```

## 🔐 Authentication

Default login (akan dibuat setelah migration):
- Email: admin@hsse.com
- Password: (setup saat insert sample data)

## 📊 HSSE Modules

1. **Safety Briefing** - Daily safety briefings
2. **Silent Inspection** - Quarterly inspections
3. **Safety Forum** - Quarterly safety forums
4. **Management Walkthrough** - Monthly/quarterly walkthroughs
5. **Safety Patrol** - Daily/monthly patrols
6. **Safety Induction** - Employee & visitor inductions
7. **Safety Drill** - Safety drill exercises

## 🎨 Tailwind CSS Classes

Pre-defined utility classes dalam `main.css`:

### Buttons
- `.btn-primary` - Primary button (blue)
- `.btn-secondary` - Secondary button (gray)
- `.btn-danger` - Danger button (red)

### Forms
- `.input-field` - Standard input field
- `.label` - Form label

### Layout
- `.card` - White card with shadow

## 📝 Next Steps

### Master Data Development
1. Create services untuk Units, Wilayah, Pegawai
2. Create stores untuk state management
3. Build CRUD pages dengan table & forms
4. Add pagination & filtering

### Dashboard Development
1. Setup Chart.js components
2. Create API untuk dashboard statistics
3. Build real-time dashboard

### HSSE Modules Development
1. Implement form validation
2. Add file upload functionality
3. Create approval workflow
4. Build detail & edit pages

## 📚 Documentation

Dokumentasi lengkap tersedia di parent directory:
- `01_DATABASE_SCHEMA.md` - Database design
- `02_API_SPECIFICATION.md` - API endpoints
- `03_VUE_FOLDER_STRUCTURE.md` - Project structure
- `04_FORM_TEMPLATES.md` - Form components
- `05_DASHBOARD_CHART.md` - Dashboard design
- `06_MODULE_DETAILS.md` - Module specifications
- `07_MIGRATION_SQL.md` - SQL migrations
- `08_ROADMAP.md` - Development roadmap

## 🤝 Development Commands

```bash
# Install dependencies
npm install

# Run development server
npm run dev

# Type check
npm run type-check

# Build for production
npm run build

# Preview production build
npm run preview
```

## 📄 License

Private project for internal use.

---

**Status**: 🟡 Phase 1 Complete - Authentication & Basic Structure Ready  
**Next**: 🔵 Phase 2 - Master Data & Dashboard Development

Last updated: November 22, 2025

