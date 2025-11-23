-- Step by step initialization of safety_forum data
-- Run each statement separately if needed

-- Step 1: Initialize critical columns first
UPDATE safety_forum SET foto_forum = ARRAY[]::TEXT[] WHERE foto_forum IS NULL;
UPDATE safety_forum SET dokumen_pendukung = ARRAY[]::TEXT[] WHERE dokumen_pendukung IS NULL;

-- Step 2: Initialize other array columns
UPDATE safety_forum SET peserta_wajib = ARRAY[]::TEXT[] WHERE peserta_wajib IS NULL;
UPDATE safety_forum SET peserta_hadir = ARRAY[]::TEXT[] WHERE peserta_hadir IS NULL;
UPDATE safety_forum SET peserta_tidak_hadir = ARRAY[]::TEXT[] WHERE peserta_tidak_hadir IS NULL;

UPDATE safety_forum SET topik_bahaya = ARRAY[]::TEXT[] WHERE topik_bahaya IS NULL;
UPDATE safety_forum SET topik_kecelakaan = ARRAY[]::TEXT[] WHERE topik_kecelakaan IS NULL;
UPDATE safety_forum SET topik_incident = ARRAY[]::TEXT[] WHERE topik_incident IS NULL;
UPDATE safety_forum SET topik_observasi = ARRAY[]::TEXT[] WHERE topik_observasi IS NULL;
UPDATE safety_forum SET topik_peraturan = ARRAY[]::TEXT[] WHERE topik_peraturan IS NULL;
UPDATE safety_forum SET topik_training = ARRAY[]::TEXT[] WHERE topik_training IS NULL;
UPDATE safety_forum SET topik_lainnya = ARRAY[]::TEXT[] WHERE topik_lainnya IS NULL;

UPDATE safety_forum SET masalah_teridentifikasi = ARRAY[]::TEXT[] WHERE masalah_teridentifikasi IS NULL;
UPDATE safety_forum SET rekomendasi = ARRAY[]::TEXT[] WHERE rekomendasi IS NULL;
UPDATE safety_forum SET sop_baru = ARRAY[]::TEXT[] WHERE sop_baru IS NULL;

-- Step 3: Initialize columns that might not exist yet (skip if error)
DO $$
BEGIN
    -- Try to initialize risiko_teridentifikasi if it exists
    BEGIN
        EXECUTE 'UPDATE safety_forum SET risiko_teridentifikasi = COALESCE(risiko_teridentifikasi, ''[]''::JSONB) WHERE risiko_teridentifikasi IS NULL';
        RAISE NOTICE 'Initialized risiko_teridentifikasi column';
    EXCEPTION WHEN undefined_column THEN
        RAISE NOTICE 'risiko_teridentifikasi column does not exist yet, skipping';
    END;

    -- Try to initialize apd_yang_diperlukan if it exists
    BEGIN
        EXECUTE 'UPDATE safety_forum SET apd_yang_diperlukan = COALESCE(apd_yang_diperlukan, ARRAY[]::TEXT[]) WHERE apd_yang_diperlukan IS NULL';
        RAISE NOTICE 'Initialized apd_yang_diperlukan column';
    EXCEPTION WHEN undefined_column THEN
        RAISE NOTICE 'apd_yang_diperlukan column does not exist yet, skipping';
    END;

    -- Try to initialize training_yang_diperlukan if it exists
    BEGIN
        EXECUTE 'UPDATE safety_forum SET training_yang_diperlukan = COALESCE(training_yang_diperlukan, ARRAY[]::TEXT[]) WHERE training_yang_diperlukan IS NULL';
        RAISE NOTICE 'Initialized training_yang_diperlukan column';
    EXCEPTION WHEN undefined_column THEN
        RAISE NOTICE 'training_yang_diperlukan column does not exist yet, skipping';
    END;

    -- Try to initialize action_items if it exists
    BEGIN
        EXECUTE 'UPDATE safety_forum SET action_items = COALESCE(action_items, ''[]''::JSONB) WHERE action_items IS NULL';
        RAISE NOTICE 'Initialized action_items column';
    EXCEPTION WHEN undefined_column THEN
        RAISE NOTICE 'action_items column does not exist yet, skipping';
    END;

    -- Try to initialize other JSONB columns
    BEGIN
        EXECUTE 'UPDATE safety_forum SET agenda_detail = COALESCE(agenda_detail, ''[]''::JSONB) WHERE agenda_detail IS NULL';
        RAISE NOTICE 'Initialized agenda_detail column';
    EXCEPTION WHEN undefined_column THEN
        RAISE NOTICE 'agenda_detail column does not exist yet, skipping';
    END;

    BEGIN
        EXECUTE 'UPDATE safety_forum SET poin_poin_pembahasan = COALESCE(poin_poin_pembahasan, ''[]''::JSONB) WHERE poin_poin_pembahasan IS NULL';
        RAISE NOTICE 'Initialized poin_poin_pembahasan column';
    EXCEPTION WHEN undefined_column THEN
        RAISE NOTICE 'poin_poin_pembahasan column does not exist yet, skipping';
    END;
END $$;

-- Step 4: Initialize text columns
UPDATE safety_forum SET periode = '' WHERE periode IS NULL;
UPDATE safety_forum SET latar_belakang = '' WHERE latar_belakang IS NULL;
UPDATE safety_forum SET tujuan_forum = '' WHERE tujuan_forum IS NULL;
UPDATE safety_forum SET ringkasan_pembahasan = '' WHERE ringkasan_pembahasan IS NULL;
UPDATE safety_forum SET keputusan = '' WHERE keputusan IS NULL;
UPDATE safety_forum SET catatan = '' WHERE catatan IS NULL;
UPDATE safety_forum SET kesimpulan = '' WHERE kesimpulan IS NULL;
UPDATE safety_forum SET evaluasi_tindak_lanjut = '' WHERE evaluasi_tindak_lanjut IS NULL;
UPDATE safety_forum SET agenda_forum_berikutnya = '' WHERE agenda_forum_berikutnya IS NULL;

-- Step 5: Initialize integer columns
UPDATE safety_forum SET jumlah_action_item = 0 WHERE jumlah_action_item IS NULL;
UPDATE safety_forum SET action_selesai = 0 WHERE action_selesai IS NULL;
UPDATE safety_forum SET action_progress = 0 WHERE action_progress IS NULL;
UPDATE safety_forum SET action_belum_mulai = 0 WHERE action_belum_mulai IS NULL;

-- Step 6: Initialize default values for enum-like columns
UPDATE safety_forum SET tingkat_urgensi = 'normal' WHERE tingkat_urgensi IS NULL;
UPDATE safety_forum SET kategori_forum = '' WHERE kategori_forum IS NULL;

-- Verify the initialization
SELECT
  id,
  nomor_forum,
  array_length(foto_forum, 1) as foto_count,
  array_length(dokumen_pendukung, 1) as dokumen_count,
  status
FROM safety_forum
ORDER BY created_at DESC
LIMIT 3;
