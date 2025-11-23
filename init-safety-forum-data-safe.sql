-- Safe initialization of safety_forum data
-- Check if columns exist before updating

DO $$
DECLARE
    column_exists BOOLEAN;
BEGIN
    -- Check if risiko_teridentifikasi column exists
    SELECT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'safety_forum'
        AND column_name = 'risiko_teridentifikasi'
    ) INTO column_exists;

    IF column_exists THEN
        RAISE NOTICE 'Column risiko_teridentifikasi exists, proceeding with update';

        -- Initialize array and JSONB columns safely
        UPDATE safety_forum SET
          risiko_teridentifikasi = COALESCE(risko_teridentifikasi, '[]'::JSONB)
        WHERE risiko_teridentifikasi IS NULL;

        UPDATE safety_forum SET
          apd_yang_diperlukan = COALESCE(apd_yang_diperlukan, ARRAY[]::TEXT[])
        WHERE apd_yang_diperlukan IS NULL;

        UPDATE safety_forum SET
          training_yang_diperlukan = COALESCE(training_yang_diperlukan, ARRAY[]::TEXT[])
        WHERE training_yang_diperlukan IS NULL;

        UPDATE safety_forum SET
          foto_forum = COALESCE(foto_forum, ARRAY[]::TEXT[])
        WHERE foto_forum IS NULL;

        UPDATE safety_forum SET
          dokumen_pendukung = COALESCE(dokumen_pendukung, ARRAY[]::TEXT[])
        WHERE dokumen_pendukung IS NULL;

        UPDATE safety_forum SET
          presentasi_url = COALESCE(presentasi_url, ARRAY[]::TEXT[])
        WHERE presentasi_url IS NULL;

        UPDATE safety_forum SET
          peserta_wajib = COALESCE(peserta_wajib, ARRAY[]::TEXT[])
        WHERE peserta_wajib IS NULL;

        UPDATE safety_forum SET
          peserta_hadir = COALESCE(peserta_hadir, ARRAY[]::TEXT[])
        WHERE peserta_hadir IS NULL;

        UPDATE safety_forum SET
          peserta_tidak_hadir = COALESCE(peserta_tidak_hadir, ARRAY[]::TEXT[])
        WHERE peserta_tidak_hadir IS NULL;

        UPDATE safety_forum SET
          topik_bahaya = COALESCE(topik_bahaya, ARRAY[]::TEXT[])
        WHERE topik_bahaya IS NULL;

        UPDATE safety_forum SET
          topik_kecelakaan = COALESCE(topik_kecelakaan, ARRAY[]::TEXT[])
        WHERE topik_kecelakaan IS NULL;

        UPDATE safety_forum SET
          topik_incident = COALESCE(topik_incident, ARRAY[]::TEXT[])
        WHERE topik_incident IS NULL;

        UPDATE safety_forum SET
          topik_observasi = COALESCE(topik_observasi, ARRAY[]::TEXT[])
        WHERE topik_observasi IS NULL;

        UPDATE safety_forum SET
          topik_peraturan = COALESCE(topik_peraturan, ARRAY[]::TEXT[])
        WHERE topik_peraturan IS NULL;

        UPDATE safety_forum SET
          topik_training = COALESCE(topik_training, ARRAY[]::TEXT[])
        WHERE topik_training IS NULL;

        UPDATE safety_forum SET
          topik_lainnya = COALESCE(topik_lainnya, ARRAY[]::TEXT[])
        WHERE topik_lainnya IS NULL;

        UPDATE safety_forum SET
          masalah_teridentifikasi = COALESCE(masalah_teridentifikasi, ARRAY[]::TEXT[])
        WHERE masalah_teridentifikasi IS NULL;

        UPDATE safety_forum SET
          rekomendasi = COALESCE(rekomendasi, ARRAY[]::TEXT[])
        WHERE rekomendasi IS NULL;

        UPDATE safety_forum SET
          sop_baru = COALESCE(sop_baru, ARRAY[]::TEXT[])
        WHERE sop_baru IS NULL;

        UPDATE safety_forum SET
          action_items = COALESCE(action_items, '[]'::JSONB)
        WHERE action_items IS NULL;

        UPDATE safety_forum SET
          agenda_detail = COALESCE(agenda_detail, '[]'::JSONB)
        WHERE agenda_detail IS NULL;

        UPDATE safety_forum SET
          poin_poin_pembahasan = COALESCE(poin_poin_pembahasan, '[]'::JSONB)
        WHERE poin_poin_pembahasan IS NULL;

        -- Initialize text columns
        UPDATE safety_forum SET
          periode = COALESCE(periode, '')
        WHERE periode IS NULL;

        UPDATE safety_forum SET
          latar_belakang = COALESCE(latar_belakang, '')
        WHERE latar_belakang IS NULL;

        UPDATE safety_forum SET
          tujuan_forum = COALESCE(tujuan_forum, '')
        WHERE tujuan_forum IS NULL;

        UPDATE safety_forum SET
          ringkasan_pembahasan = COALESCE(ringkasan_pembahasan, '')
        WHERE ringkasan_pembahasan IS NULL;

        UPDATE safety_forum SET
          keputusan = COALESCE(keputusan, '')
        WHERE keputusan IS NULL;

        UPDATE safety_forum SET
          catatan = COALESCE(catatan, '')
        WHERE catatan IS NULL;

        UPDATE safety_forum SET
          tingkat_urgensi = COALESCE(tingkat_urgensi, 'normal')
        WHERE tingkat_urgensi IS NULL;

        UPDATE safety_forum SET
          kategori_forum = COALESCE(kategori_forum, '')
        WHERE kategori_forum IS NULL;

        UPDATE safety_forum SET
          kesimpulan = COALESCE(kesimpulan, '')
        WHERE kesimpulan IS NULL;

        UPDATE safety_forum SET
          evaluasi_tindak_lanjut = COALESCE(evaluasi_tindak_lanjut, '')
        WHERE evaluasi_tindak_lanjut IS NULL;

        UPDATE safety_forum SET
          agenda_forum_berikutnya = COALESCE(agenda_forum_berikutnya, '')
        WHERE agenda_forum_berikutnya IS NULL;

        -- Initialize integer columns
        UPDATE safety_forum SET
          jumlah_action_item = COALESCE(jumlah_action_item, 0)
        WHERE jumlah_action_item IS NULL;

        UPDATE safety_forum SET
          action_selesai = COALESCE(action_selesai, 0)
        WHERE action_selesai IS NULL;

        UPDATE safety_forum SET
          action_progress = COALESCE(action_progress, 0)
        WHERE action_progress IS NULL;

        UPDATE safety_forum SET
          action_belum_mulai = COALESCE(action_belum_mulai, 0)
        WHERE action_belum_mulai IS NULL;

        RAISE NOTICE 'All safety_forum data initialized successfully!';
    ELSE
        RAISE EXCEPTION 'Column risiko_teridentifikasi does not exist. Please run add-critical-safety-forum-columns.sql first.';
    END IF;
END $$;

-- Verify the initialization
SELECT
  id,
  nomor_forum,
  array_length(foto_forum, 1) as foto_count,
  array_length(dokumen_pendukung, 1) as dokumen_count,
  jsonb_array_length(risiko_teridentifikasi) as risiko_count,
  status
FROM safety_forum
ORDER BY created_at DESC
LIMIT 3;
