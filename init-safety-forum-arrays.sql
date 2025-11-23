-- Initialize NULL arrays in safety_forum table
-- This fixes the issue where foto_forum and dokumen_pendukung are NULL instead of empty arrays

UPDATE safety_forum SET
    foto_forum = COALESCE(foto_forum, ARRAY[]::TEXT[]),
    dokumen_pendukung = COALESCE(dokumen_pendukung, ARRAY[]::TEXT[]),
    presentasi_url = COALESCE(presentasi_url, ARRAY[]::TEXT[]),
    peserta_wajib = COALESCE(peserta_wajib, ARRAY[]::TEXT[]),
    peserta_hadir = COALESCE(peserta_hadir, ARRAY[]::TEXT[]),
    peserta_tidak_hadir = COALESCE(peserta_tidak_hadir, ARRAY[]::TEXT[]),
    topik_bahaya = COALESCE(topik_bahaya, ARRAY[]::TEXT[]),
    topik_kecelakaan = COALESCE(topik_kecelakaan, ARRAY[]::TEXT[]),
    topik_incident = COALESCE(topik_incident, ARRAY[]::TEXT[]),
    topik_observasi = COALESCE(topik_observasi, ARRAY[]::TEXT[]),
    topik_peraturan = COALESCE(topik_peraturan, ARRAY[]::TEXT[]),
    topik_training = COALESCE(topik_training, ARRAY[]::TEXT[]),
    masalah_teridentifikasi = COALESCE(masalah_teridentifikasi, ARRAY[]::TEXT[]),
    rekomendasi = COALESCE(rekomendasi, ARRAY[]::TEXT[]),
    sop_baru = COALESCE(sop_baru, ARRAY[]::TEXT[]),
    apd_yang_diperlukan = COALESCE(apd_yang_diperlukan, ARRAY[]::TEXT[]),
    training_yang_diperlukan = COALESCE(training_yang_diperlukan, ARRAY[]::TEXT[])
WHERE
    foto_forum IS NULL OR
    dokumen_pendukung IS NULL OR
    presentasi_url IS NULL OR
    peserta_wajib IS NULL OR
    peserta_hadir IS NULL OR
    peserta_tidak_hadir IS NULL OR
    topik_bahaya IS NULL OR
    topik_kecelakaan IS NULL OR
    topik_incident IS NULL OR
    topik_observasi IS NULL OR
    topik_peraturan IS NULL OR
    topik_training IS NULL OR
    masalah_teridentifikasi IS NULL OR
    rekomendasi IS NULL OR
    sop_baru IS NULL OR
    apd_yang_diperlukan IS NULL OR
    training_yang_diperlukan IS NULL;

-- Verify the initialization for SF-2024-11-001
SELECT
    nomor_forum,
    array_length(foto_forum, 1) as foto_count,
    array_length(dokumen_pendukung, 1) as dokumen_count,
    CASE
        WHEN array_length(foto_forum, 1) > 0 OR array_length(dokumen_pendukung, 1) > 0 OR
             notulen_file_url IS NOT NULL OR daftar_hadir_url IS NOT NULL
        THEN 'Has documentation'
        ELSE 'No documentation'
    END as documentation_status
FROM safety_forum
WHERE nomor_forum = 'SF-2024-11-001';

-- Show summary of all forums
SELECT
    COUNT(*) as total_forums,
    COUNT(CASE WHEN array_length(foto_forum, 1) > 0 THEN 1 END) as forums_with_photos,
    COUNT(CASE WHEN array_length(dokumen_pendukung, 1) > 0 THEN 1 END) as forums_with_documents,
    COUNT(CASE WHEN notulen_file_url IS NOT NULL THEN 1 END) as forums_with_notulen,
    COUNT(CASE WHEN daftar_hadir_url IS NOT NULL THEN 1 END) as forums_with_attendance
FROM safety_forum;
