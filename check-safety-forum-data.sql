-- Check specific safety forum data for documentation
SELECT
    id,
    nomor_forum,
    foto_forum,
    dokumen_pendukung,
    notulen_file_url,
    daftar_hadir_url,
    CASE
        WHEN foto_forum IS NOT NULL AND array_length(foto_forum, 1) > 0
        THEN 'Has ' || array_length(foto_forum, 1) || ' photos'
        ELSE 'No photos'
    END as foto_status,
    CASE
        WHEN dokumen_pendukung IS NOT NULL AND array_length(dokumen_pendukung, 1) > 0
        THEN 'Has ' || array_length(dokumen_pendukung, 1) || ' documents'
        ELSE 'No documents'
    END as dokumen_status,
    CASE
        WHEN notulen_file_url IS NOT NULL AND notulen_file_url != ''
        THEN 'Has notulen'
        ELSE 'No notulen'
    END as notulen_status,
    CASE
        WHEN daftar_hadir_url IS NOT NULL AND daftar_hadir_url != ''
        THEN 'Has attendance list'
        ELSE 'No attendance list'
    END as attendance_status
FROM safety_forum
WHERE nomor_forum = 'SF-2024-11-001';

-- Check if arrays are properly initialized
SELECT
    id,
    nomor_forum,
    foto_forum IS NULL as foto_null,
    array_length(foto_forum, 1) as foto_count,
    dokumen_pendukung IS NULL as dokumen_null,
    array_length(dokumen_pendukung, 1) as dokumen_count
FROM safety_forum
WHERE nomor_forum = 'SF-2024-11-001';

-- Check all safety forum records for documentation
SELECT
    nomor_forum,
    CASE
        WHEN (foto_forum IS NOT NULL AND array_length(foto_forum, 1) > 0) OR
             (dokumen_pendukung IS NOT NULL AND array_length(dokumen_pendukung, 1) > 0) OR
             (notulen_file_url IS NOT NULL AND notulen_file_url != '') OR
             (daftar_hadir_url IS NOT NULL AND daftar_hadir_url != '')
        THEN 'Has documentation'
        ELSE 'No documentation'
    END as documentation_status,
    array_length(foto_forum, 1) as photo_count,
    array_length(dokumen_pendukung, 1) as document_count,
    CASE WHEN notulen_file_url IS NOT NULL THEN 'Yes' ELSE 'No' END as has_notulen,
    CASE WHEN daftar_hadir_url IS NOT NULL THEN 'Yes' ELSE 'No' END as has_attendance
FROM safety_forum
ORDER BY tanggal_forum DESC
LIMIT 5;
