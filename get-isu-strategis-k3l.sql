-- QUERY UNTUK TABEL ISU STRATEGIS K3L
-- Menampilkan isu strategis/critical issue dan dukungan dari kantor pusat untuk setiap modul
-- Struktur: NO, CRITICAL ISSUE, DUKUNGAN YANG DIBUTUHKAN DARI KANTOR PUSAT

-- Filter berdasarkan periode (contoh: bulan November 2025)
WITH periode AS (
  SELECT 
    2025 as tahun,
    11 as bulan
),

-- 1. Safety Briefing - Ambil isu dari topik atau catatan yang penting
safety_briefing_issues AS (
  SELECT 
    'Safety Briefing' as modul,
    topik as critical_issue,
    CASE 
      WHEN topik ILIKE '%APD%' OR topik ILIKE '%alat pelindung%' THEN 'Penyediaan APD yang memadai dan pelatihan penggunaan'
      WHEN topik ILIKE '%prosedur%' OR topik ILIKE '%SOP%' THEN 'Sosialisasi dan pemutakhiran prosedur K3'
      WHEN topik ILIKE '%keselamatan%' OR topik ILIKE '%safety%' THEN 'Dukungan program peningkatan budaya keselamatan'
      ELSE 'Dukungan monitoring dan evaluasi implementasi K3'
    END as dukungan_kantor_pusat
  FROM safety_briefing, periode
  WHERE EXTRACT(YEAR FROM tanggal) = periode.tahun 
    AND EXTRACT(MONTH FROM tanggal) = periode.bulan
    AND status IN ('approved', 'completed')
  LIMIT 3
),

-- 2. Safety Patrol - Ambil temuan kritis sebagai isu strategis
safety_patrol_issues AS (
  SELECT 
    'Safety Patrol' as modul,
    'Temuan ' || COALESCE(temuan_kritikal, 0) || ' kritis, ' || COALESCE(temuan_mayor, 0) || ' mayor di ' || area_patrol as critical_issue,
    CASE 
      WHEN COALESCE(temuan_kritikal, 0) > 0 THEN 'Dukungan segera untuk perbaikan kondisi kritis dan audit mendalam'
      WHEN COALESCE(temuan_mayor, 0) > 2 THEN 'Asistensi teknis dan alokasi anggaran perbaikan'
      ELSE 'Monitoring berkala dan sharing best practice'
    END as dukungan_kantor_pusat
  FROM safety_patrol, periode
  WHERE EXTRACT(YEAR FROM tanggal_patrol) = periode.tahun 
    AND EXTRACT(MONTH FROM tanggal_patrol) = periode.bulan
    AND (COALESCE(temuan_kritikal, 0) > 0 OR COALESCE(temuan_mayor, 0) > 0)
  ORDER BY COALESCE(temuan_kritikal, 0) DESC, COALESCE(temuan_mayor, 0) DESC
  LIMIT 3
),

-- 3. Safety Drill - Ambil evaluasi dan rekomendasi sebagai isu
safety_drill_issues AS (
  SELECT 
    'Safety Drill' as modul,
    'Evaluasi drill ' || jenis_drill || ': ' || 
    COALESCE(
      CASE 
        WHEN evaluasi_overall ILIKE '%kurang%' THEN 'Masih terdapat kekurangan dalam pelaksanaan'
        WHEN evaluasi_overall ILIKE '%perlu%' THEN 'Perlu peningkatan kesiapan tim'
        WHEN review_notes ILIKE '%kurang%' THEN 'Masih terdapat kekurangan dalam pelaksanaan'
        WHEN COALESCE(jumlah_temuan, 0) > 0 THEN 'Ditemukan ' || jumlah_temuan || ' temuan yang perlu ditindaklanjuti'
        ELSE 'Perlu evaluasi lanjutan untuk improvement'
      END,
      'Perlu peningkatan kesiapan tanggap darurat'
    ) as critical_issue,
    CASE 
      WHEN jenis_drill = 'kebakaran' THEN 'Pelatihan fire fighting dan penyediaan alat pemadam'
      WHEN jenis_drill = 'evakuasi' THEN 'Simulasi berkala dan perbaikan jalur evakuasi'
      WHEN jenis_drill = 'gempa' THEN 'Pelatihan dan pengadaan peralatan emergency response'
      ELSE 'Dukungan pelatihan dan sertifikasi tim tanggap darurat'
    END as dukungan_kantor_pusat
  FROM safety_drill, periode
  WHERE EXTRACT(YEAR FROM tanggal_drill) = periode.tahun 
    AND EXTRACT(MONTH FROM tanggal_drill) = periode.bulan
    AND status IN ('completed', 'reviewed')
  LIMIT 2
),

-- 4. Safety Forum - Ambil masalah yang teridentifikasi dan action items
safety_forum_issues AS (
  SELECT 
    'Safety Forum' as modul,
    COALESCE(
      masalah_teridentifikasi[1],
      'Pembahasan: ' || agenda_utama
    ) as critical_issue,
    CASE 
      WHEN action_items IS NOT NULL AND jsonb_array_length(action_items) > 3 THEN 'Dukungan implementasi ' || jsonb_array_length(action_items)::text || ' action items dan alokasi resources'
      WHEN agenda_utama ILIKE '%kecelakaan%' OR agenda_utama ILIKE '%incident%' THEN 'Investigasi mendalam dan program pencegahan kecelakaan'
      WHEN agenda_utama ILIKE '%audit%' OR agenda_utama ILIKE '%compliance%' THEN 'Asistensi persiapan audit dan pemenuhan regulasi'
      ELSE 'Monitoring implementasi hasil forum dan fasilitasi koordinasi'
    END as dukungan_kantor_pusat
  FROM safety_forum, periode
  WHERE EXTRACT(YEAR FROM tanggal_forum) = periode.tahun 
    AND EXTRACT(MONTH FROM tanggal_forum) = periode.bulan
    AND status IN ('approved', 'completed')
  LIMIT 2
),

-- 5. Safety Induction - Ambil isu terkait kepatuhan dan sertifikasi
safety_induction_issues AS (
  SELECT 
    'Safety Induction' as modul,
    'Induction ' || jenis_peserta || ' - ' || nama_peserta || 
    CASE 
      WHEN status_ujian = 'tidak_lulus' THEN ' (Tidak Lulus Ujian)'
      WHEN perlu_reinduction THEN ' (Perlu Re-Induction)'
      ELSE ''
    END as critical_issue,
    CASE 
      WHEN jenis_peserta ILIKE '%tamu%' OR jenis_peserta ILIKE '%vendor%' THEN 'Standarisasi materi induction dan sistem tracking peserta eksternal'
      WHEN jenis_peserta ILIKE '%kontraktor%' THEN 'Modul induction khusus kontraktor dan monitoring kepatuhan'
      WHEN status_ujian = 'tidak_lulus' THEN 'Program remedial dan peningkatan kualitas training'
      ELSE 'Pengembangan e-learning induction dan database sertifikasi'
    END as dukungan_kantor_pusat
  FROM safety_induction, periode
  WHERE EXTRACT(YEAR FROM tanggal_induction) = periode.tahun 
    AND EXTRACT(MONTH FROM tanggal_induction) = periode.bulan
    AND status IN ('approved', 'completed')
  LIMIT 2
),

-- 6. Silent Inspection - Ambil temuan berdasarkan tingkat risiko
silent_inspection_issues AS (
  SELECT 
    'Silent Inspection' as modul,
    'Inspeksi ' || area_inspeksi || ' - Tingkat risiko: ' || COALESCE(tingkat_risiko, 'sedang') as critical_issue,
    CASE 
      WHEN tingkat_risiko = 'tinggi' OR tingkat_risiko = 'high' THEN 'Intervensi segera dan dukungan teknis perbaikan kondisi high risk'
      WHEN COALESCE(jumlah_temuan, 0) > 5 THEN 'Alokasi anggaran perbaikan dan program peningkatan awareness'
      ELSE 'Monitoring berkala dan sharing best practice antar unit'
    END as dukungan_kantor_pusat
  FROM silent_inspection, periode
  WHERE EXTRACT(YEAR FROM tanggal) = periode.tahun 
    AND EXTRACT(MONTH FROM tanggal) = periode.bulan
    AND (tingkat_risiko IN ('tinggi', 'high') OR COALESCE(jumlah_temuan, 0) > 3)
  ORDER BY 
    CASE tingkat_risiko 
      WHEN 'tinggi' THEN 1 
      WHEN 'high' THEN 1 
      WHEN 'sedang' THEN 2 
      ELSE 3 
    END,
    COALESCE(jumlah_temuan, 0) DESC
  LIMIT 3
),

-- 7. Management Walkthrough - Ambil temuan dan area fokus
management_walkthrough_issues AS (
  SELECT 
    'Management Walkthrough' as modul,
    'Walkthrough ' || area_inspeksi || ' menemukan ' || COALESCE(jumlah_temuan, 0) || ' temuan' as critical_issue,
    CASE 
      WHEN COALESCE(jumlah_temuan, 0) > 5 THEN 'Program perbaikan komprehensif dan alokasi anggaran khusus'
      WHEN COALESCE(jumlah_temuan, 0) > 0 THEN 'Dukungan implementasi corrective action dan monitoring progress'
      ELSE 'Replikasi best practice ke unit lain'
    END as dukungan_kantor_pusat
  FROM management_walkthrough, periode
  WHERE EXTRACT(YEAR FROM tanggal_walkthrough) = periode.tahun 
    AND EXTRACT(MONTH FROM tanggal_walkthrough) = periode.bulan
    AND status IN ('completed', 'approved')
  ORDER BY COALESCE(jumlah_temuan, 0) DESC
  LIMIT 2
)

-- Gabungkan semua isu strategis dari setiap modul
SELECT 
  ROW_NUMBER() OVER (ORDER BY modul) as no,
  critical_issue,
  dukungan_kantor_pusat
FROM (
  SELECT * FROM safety_briefing_issues
  UNION ALL
  SELECT * FROM safety_patrol_issues
  UNION ALL
  SELECT * FROM safety_drill_issues
  UNION ALL
  SELECT * FROM safety_forum_issues
  UNION ALL
  SELECT * FROM safety_induction_issues
  UNION ALL
  SELECT * FROM silent_inspection_issues
  UNION ALL
  SELECT * FROM management_walkthrough_issues
) all_issues
ORDER BY modul, critical_issue;

-- Alternatif query yang lebih sederhana (mengambil top issues saja):
/*
SELECT 
  ROW_NUMBER() OVER (ORDER BY tingkat_prioritas, modul) as no,
  critical_issue,
  dukungan_kantor_pusat
FROM (
  -- Safety Patrol - Temuan Kritis
  SELECT 
    1 as tingkat_prioritas,
    'Safety Patrol' as modul,
    'Temuan kritis di area operasional yang memerlukan penanganan segera' as critical_issue,
    'Dukungan teknis, anggaran perbaikan, dan audit safety komprehensif' as dukungan_kantor_pusat
  WHERE EXISTS (
    SELECT 1 FROM safety_patrol 
    WHERE EXTRACT(YEAR FROM tanggal_patrol) = 2025 
      AND EXTRACT(MONTH FROM tanggal_patrol) = 11
      AND COALESCE(temuan_kritikal, 0) > 0
  )
  
  UNION ALL
  
  -- Silent Inspection - Risiko Tinggi
  SELECT 
    1 as tingkat_prioritas,
    'Silent Inspection' as modul,
    'Area dengan tingkat risiko tinggi memerlukan intervensi' as critical_issue,
    'Program perbaikan kondisi unsafe dan peningkatan awareness pekerja' as dukungan_kantor_pusat
  WHERE EXISTS (
    SELECT 1 FROM silent_inspection 
    WHERE EXTRACT(YEAR FROM tanggal) = 2025 
      AND EXTRACT(MONTH FROM tanggal) = 11
      AND tingkat_risiko IN ('tinggi', 'high')
  )
  
  UNION ALL
  
  -- Safety Drill - Kesiapan Tanggap Darurat
  SELECT 
    2 as tingkat_prioritas,
    'Safety Drill' as modul,
    'Peningkatan kesiapan tim tanggap darurat perlu diperkuat' as critical_issue,
    'Pelatihan sertifikasi, peralatan emergency, dan simulasi berkala' as dukungan_kantor_pusat
  WHERE EXISTS (
    SELECT 1 FROM safety_drill 
    WHERE EXTRACT(YEAR FROM tanggal_drill) = 2025 
      AND EXTRACT(MONTH FROM tanggal_drill) = 11
  )
  
  UNION ALL
  
  -- Management Walkthrough - Follow Up Temuan
  SELECT 
    2 as tingkat_prioritas,
    'Management Walkthrough' as modul,
    'Follow up temuan management walkthrough memerlukan monitoring ketat' as critical_issue,
    'Sistem tracking tindak lanjut dan evaluasi efektivitas corrective action' as dukungan_kantor_pusat
  WHERE EXISTS (
    SELECT 1 FROM management_walkthrough 
    WHERE EXTRACT(YEAR FROM tanggal_walkthrough) = 2025 
      AND EXTRACT(MONTH FROM tanggal_walkthrough) = 11
      AND COALESCE(jumlah_temuan, 0) > 0
  )
  
  UNION ALL
  
  -- Safety Forum - Implementasi Action Items
  SELECT 
    3 as tingkat_prioritas,
    'Safety Forum' as modul,
    'Implementasi action items hasil safety forum memerlukan koordinasi' as critical_issue,
    'Fasilitasi koordinasi antar departemen dan monitoring progress action items' as dukungan_kantor_pusat
  WHERE EXISTS (
    SELECT 1 FROM safety_forum 
    WHERE EXTRACT(YEAR FROM tanggal_forum) = 2025 
      AND EXTRACT(MONTH FROM tanggal_forum) = 11
      AND action_items IS NOT NULL
  )
) prioritized_issues
ORDER BY tingkat_prioritas, modul;
*/
