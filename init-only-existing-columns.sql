-- Initialize ONLY columns that are confirmed to exist
-- Based on your query result showing: foto_forum, dokumen_pendukung, risiko_teridentifikasi

-- Initialize the columns we know exist
UPDATE safety_forum SET foto_forum = ARRAY[]::TEXT[] WHERE foto_forum IS NULL;
UPDATE safety_forum SET dokumen_pendukung = ARRAY[]::TEXT[] WHERE dokumen_pendukung IS NULL;
UPDATE safety_forum SET risiko_teridentifikasi = '[]'::JSONB WHERE risiko_teridentifikasi IS NULL;

-- Initialize other basic columns that should exist in the basic table
UPDATE safety_forum SET presentasi_url = ARRAY[]::TEXT[] WHERE presentasi_url IS NULL;
UPDATE safety_forum SET peserta_wajib = ARRAY[]::TEXT[] WHERE peserta_wajib IS NULL;
UPDATE safety_forum SET peserta_hadir = ARRAY[]::TEXT[] WHERE peserta_hadir IS NULL;
UPDATE safety_forum SET peserta_tidak_hadir = ARRAY[]::TEXT[] WHERE peserta_tidak_hadir IS NULL;

-- Initialize text columns that exist
UPDATE safety_forum SET periode = '' WHERE periode IS NULL;
UPDATE safety_forum SET latar_belakang = '' WHERE latar_belakang IS NULL;
UPDATE safety_forum SET tujuan_forum = '' WHERE tujuan_forum IS NULL;
UPDATE safety_forum SET ringkasan_pembahasan = '' WHERE ringkasan_pembahasan IS NULL;
UPDATE safety_forum SET keputusan = '' WHERE keputusan IS NULL;
UPDATE safety_forum SET catatan = '' WHERE catatan IS NULL;

-- Initialize integer columns that exist
UPDATE safety_forum SET jumlah_action_item = 0 WHERE jumlah_action_item IS NULL;
UPDATE safety_forum SET action_selesai = 0 WHERE action_selesai IS NULL;
UPDATE safety_forum SET action_progress = 0 WHERE action_progress IS NULL;
UPDATE safety_forum SET action_belum_mulai = 0 WHERE action_belum_mulai IS NULL;

-- Verify the result
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
