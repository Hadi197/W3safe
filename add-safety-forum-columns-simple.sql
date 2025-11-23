-- Simple script to add missing safety_forum columns one by one
-- Run this in Supabase SQL Editor

-- Add columns one by one with error handling
DO $$
BEGIN
    -- Array columns
    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS topik_bahaya TEXT[];
        RAISE NOTICE 'Added topik_bahaya column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'topik_bahaya column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS topik_kecelakaan TEXT[];
        RAISE NOTICE 'Added topik_kecelakaan column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'topik_kecelakaan column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS topik_incident TEXT[];
        RAISE NOTICE 'Added topik_incident column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'topik_incident column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS topik_observasi TEXT[];
        RAISE NOTICE 'Added topik_observasi column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'topik_observasi column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS topik_peraturan TEXT[];
        RAISE NOTICE 'Added topik_peraturan column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'topik_peraturan column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS topik_training TEXT[];
        RAISE NOTICE 'Added topik_training column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'topik_training column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS topik_lainnya TEXT[];
        RAISE NOTICE 'Added topik_lainnya column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'topik_lainnya column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS masalah_teridentifikasi TEXT[];
        RAISE NOTICE 'Added masalah_teridentifikasi column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'masalah_teridentifikasi column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS rekomendasi TEXT[];
        RAISE NOTICE 'Added rekomendasi column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'rekomendasi column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS sop_baru TEXT[];
        RAISE NOTICE 'Added sop_baru column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'sop_baru column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS apd_yang_diperlukan TEXT[];
        RAISE NOTICE 'Added apd_yang_diperlukan column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'apd_yang_diperlukan column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS training_yang_diperlukan TEXT[];
        RAISE NOTICE 'Added training_yang_diperlukan column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'training_yang_diperlukan column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS foto_forum TEXT[];
        RAISE NOTICE 'Added foto_forum column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'foto_forum column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS dokumen_pendukung TEXT[];
        RAISE NOTICE 'Added dokumen_pendukung column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'dokumen_pendukung column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS presentasi_url TEXT[];
        RAISE NOTICE 'Added presentasi_url column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'presentasi_url column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS peserta_wajib TEXT[];
        RAISE NOTICE 'Added peserta_wajib column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'peserta_wajib column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS peserta_hadir TEXT[];
        RAISE NOTICE 'Added peserta_hadir column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'peserta_hadir column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS peserta_tidak_hadir TEXT[];
        RAISE NOTICE 'Added peserta_tidak_hadir column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'peserta_tidak_hadir column might already exist: %', SQLERRM;
    END;

    -- JSONB columns
    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS agenda_detail JSONB;
        RAISE NOTICE 'Added agenda_detail column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'agenda_detail column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS poin_poin_pembahasan JSONB;
        RAISE NOTICE 'Added poin_poin_pembahasan column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'poin_poin_pembahasan column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS risiko_teridentifikasi JSONB;
        RAISE NOTICE 'Added risiko_teridentifikasi column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'risiko_teridentifikasi column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS action_items JSONB;
        RAISE NOTICE 'Added action_items column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'action_items column might already exist: %', SQLERRM;
    END;

    -- Text columns
    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS periode VARCHAR(50);
        RAISE NOTICE 'Added periode column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'periode column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS ketua_forum UUID;
        RAISE NOTICE 'Added ketua_forum column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'ketua_forum column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS notulen_by UUID;
        RAISE NOTICE 'Added notulen_by column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'notulen_by column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS latar_belakang TEXT;
        RAISE NOTICE 'Added latar_belakang column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'latar_belakang column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS tujuan_forum TEXT;
        RAISE NOTICE 'Added tujuan_forum column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'tujuan_forum column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS ringkasan_pembahasan TEXT;
        RAISE NOTICE 'Added ringkasan_pembahasan column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'ringkasan_pembahasan column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS kesimpulan TEXT;
        RAISE NOTICE 'Added kesimpulan column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'kesimpulan column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS keputusan TEXT;
        RAISE NOTICE 'Added keputusan column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'keputusan column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS notulen_file_url TEXT;
        RAISE NOTICE 'Added notulen_file_url column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'notulen_file_url column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS daftar_hadir_url TEXT;
        RAISE NOTICE 'Added daftar_hadir_url column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'daftar_hadir_url column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS forum_sebelumnya_id UUID;
        RAISE NOTICE 'Added forum_sebelumnya_id column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'forum_sebelumnya_id column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS evaluasi_tindak_lanjut TEXT;
        RAISE NOTICE 'Added evaluasi_tindak_lanjut column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'evaluasi_tindak_lanjut column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS jadwal_forum_berikutnya DATE;
        RAISE NOTICE 'Added jadwal_forum_berikutnya column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'jadwal_forum_berikutnya column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS agenda_forum_berikutnya TEXT;
        RAISE NOTICE 'Added agenda_forum_berikutnya column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'agenda_forum_berikutnya column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS catatan TEXT;
        RAISE NOTICE 'Added catatan column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'catatan column might already exist: %', SQLERRM;
    END;

    -- Integer columns
    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS jumlah_action_item INTEGER DEFAULT 0;
        RAISE NOTICE 'Added jumlah_action_item column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'jumlah_action_item column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS action_selesai INTEGER DEFAULT 0;
        RAISE NOTICE 'Added action_selesai column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'action_selesai column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS action_progress INTEGER DEFAULT 0;
        RAISE NOTICE 'Added action_progress column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'Added action_progress column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'action_progress column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS action_belum_mulai INTEGER DEFAULT 0;
        RAISE NOTICE 'Added action_belum_mulai column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'action_belum_mulai column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS progress_action_sebelumnya NUMERIC(5,2);
        RAISE NOTICE 'Added progress_action_sebelumnya column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'progress_action_sebelumnya column might already exist: %', SQLERRM;
    END;

    -- UUID columns
    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS unit_id UUID;
        RAISE NOTICE 'Added unit_id column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'unit_id column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS approved_by UUID;
        RAISE NOTICE 'Added approved_by column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'approved_by column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS created_by UUID;
        RAISE NOTICE 'Added created_by column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'created_by column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS updated_by UUID;
        RAISE NOTICE 'Added updated_by column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'updated_by column might already exist: %', SQLERRM;
    END;

    -- VARCHAR columns
    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS status_notulen VARCHAR(50) DEFAULT 'belum_dibuat';
        RAISE NOTICE 'Added status_notulen column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'status_notulen column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS tingkat_urgensi VARCHAR(50) DEFAULT 'normal';
        RAISE NOTICE 'Added tingkat_urgensi column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'tingkat_urgensi column might already exist: %', SQLERRM;
    END;

    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS kategori_forum VARCHAR(100);
        RAISE NOTICE 'Added kategori_forum column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'kategori_forum column might already exist: %', SQLERRM;
    END;

    -- TIMESTAMP columns
    BEGIN
        ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS approved_at TIMESTAMP WITH TIME ZONE;
        RAISE NOTICE 'Added approved_at column';
    EXCEPTION WHEN others THEN
        RAISE NOTICE 'approved_at column might already exist: %', SQLERRM;
    END;

    RAISE NOTICE 'All columns have been processed!';
END $$;

-- Check which columns were added
SELECT
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'safety_forum'
ORDER BY ordinal_position;
