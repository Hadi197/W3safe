-- Fix existing safety_forum data to ensure foto_forum field is properly initialized
-- Run this after adding new columns to existing safety_forum table

-- Update all existing records to have empty arrays for array fields if they are NULL
UPDATE safety_forum SET
  foto_forum = COALESCE(foto_forum, ARRAY[]::TEXT[]),
  dokumen_pendukung = COALESCE(dokumen_pendukung, ARRAY[]::TEXT[]),
  topik_bahaya = COALESCE(topik_bahaya, ARRAY[]::TEXT[]),
  topik_kecelakaan = COALESCE(topik_kecelakaan, ARRAY[]::TEXT[]),
  topik_incident = COALESCE(topik_incident, ARRAY[]::TEXT[]),
  topik_observasi = COALESCE(topik_observasi, ARRAY[]::TEXT[]),
  topik_peraturan = COALESCE(topik_peraturan, ARRAY[]::TEXT[]),
  topik_training = COALESCE(topik_training, ARRAY[]::TEXT[]),
  topik_lainnya = COALESCE(topik_lainnya, ARRAY[]::TEXT[]),
  masalah_teridentifikasi = COALESCE(masalah_teridentifikasi, ARRAY[]::TEXT[]),
  rekomendasi = COALESCE(rekomendasi, ARRAY[]::TEXT[]),
  sop_baru = COALESCE(sop_baru, ARRAY[]::TEXT[]),
  apd_yang_diperlukan = COALESCE(apd_yang_diperlukan, ARRAY[]::TEXT[]),
  training_yang_diperlukan = COALESCE(training_yang_diperlukan, ARRAY[]::TEXT[]),
  presentasi_url = COALESCE(presentasi_url, ARRAY[]::TEXT[]),
  peserta_wajib = COALESCE(peserta_wajib, ARRAY[]::TEXT[]),
  peserta_hadir = COALESCE(peserta_hadir, ARRAY[]::TEXT[]),
  peserta_tidak_hadir = COALESCE(peserta_tidak_hadir, ARRAY[]::TEXT[]),
  risiko_teridentifikasi = COALESCE(risko_teridentifikasi, '[]'::JSONB),
  action_items = COALESCE(action_items, '[]'::JSONB),
  agenda_detail = COALESCE(agenda_detail, '[]'::JSONB),
  poin_poin_pembahasan = COALESCE(poin_poin_pembahasan, '[]'::JSONB),
  kesimpulan = COALESCE(kesimpulan, ''),
  tindak_lanjut = COALESCE(tindak_lanjut, ''),
  latar_belakang = COALESCE(latar_belakang, ''),
  tujuan_forum = COALESCE(tujuan_forum, ''),
  ringkasan_pembahasan = COALESCE(ringkasan_pembahasan, ''),
  keputusan = COALESCE(keputusan, ''),
  catatan = COALESCE(catatan, ''),
  tingkat_urgensi = COALESCE(tingkat_urgensi, 'normal'),
  kategori_forum = COALESCE(kategori_forum, ''),
  periode = COALESCE(periode, ''),
  jumlah_action_item = COALESCE(jumlah_action_item, 0),
  action_selesai = COALESCE(action_selesai, 0),
  action_progress = COALESCE(action_progress, 0),
  action_belum_mulai = COALESCE(action_belum_mulai, 0);

-- Verify the fix
SELECT
  id,
  nomor_forum,
  array_length(foto_forum, 1) as foto_count,
  array_length(dokumen_pendukung, 1) as dokumen_count,
  notulen_file_url,
  daftar_hadir_url,
  foto_forum,
  status
FROM safety_forum
ORDER BY created_at DESC
LIMIT 5;
