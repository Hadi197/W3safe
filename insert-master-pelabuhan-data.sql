-- ===================================================================
-- INSERT MASTER PELABUHAN DATA
-- Wilayah 3 - Area Jawa 1, Area Kalimantan 3, Area Bali Nusatenggara
-- ===================================================================

-- Wilayah 3 ID: d4cbbacd-f743-4372-8a46-372abaee759f
-- Area Jawa 1 ID: f06ccb47-ef5c-4c8a-a070-17dbac58bb79
-- Area Kalimantan 3 ID: 4ee124e8-3690-4113-a68c-d2a1aefd0421
-- Area Bali Nusa Tenggara ID: e8ee7d16-8f35-44ba-8c44-ed94e6caa99a

INSERT INTO master_pelabuhan (id, wilayah_id, area_id, unit_id, aktif, created_at, updated_at)
VALUES 
  -- Area Jawa 1 - 5 units
  (gen_random_uuid(), 
   'd4cbbacd-f743-4372-8a46-372abaee759f', -- Wilayah 3
   'f06ccb47-ef5c-4c8a-a070-17dbac58bb79', -- Area Jawa 1
   '742ca854-25d1-405e-b0ec-0f34061653fb', -- Tanjung Perak
   true, NOW(), NOW()),
   
  (gen_random_uuid(), 
   'd4cbbacd-f743-4372-8a46-372abaee759f', 
   'f06ccb47-ef5c-4c8a-a070-17dbac58bb79', 
   'd0334aab-2a6e-4fff-9aea-a6e748c38d27', -- Gresik
   true, NOW(), NOW()),
   
  (gen_random_uuid(), 
   'd4cbbacd-f743-4372-8a46-372abaee759f', 
   'f06ccb47-ef5c-4c8a-a070-17dbac58bb79', 
   'b8721080-5dea-4cab-8844-a3b13d0d9fe5', -- Tanjung Wangi
   true, NOW(), NOW()),
   
  (gen_random_uuid(), 
   'd4cbbacd-f743-4372-8a46-372abaee759f', 
   'f06ccb47-ef5c-4c8a-a070-17dbac58bb79', 
   '98ccd845-ee5f-4185-9d88-d7c793e1f48c', -- Tanjung Emas
   true, NOW(), NOW()),
   
  (gen_random_uuid(), 
   'd4cbbacd-f743-4372-8a46-372abaee759f', 
   'f06ccb47-ef5c-4c8a-a070-17dbac58bb79', 
   '18fb6a0b-77a6-4c21-bdb6-fd1689d74c86', -- Tanjung Intan
   true, NOW(), NOW()),

  -- Area Kalimantan 3 - 7 units
  (gen_random_uuid(), 
   'd4cbbacd-f743-4372-8a46-372abaee759f', -- Wilayah 3
   '4ee124e8-3690-4113-a68c-d2a1aefd0421', -- Area Kalimantan 3
   'dddfe713-19bd-413f-85db-ac2a8efe2561', -- Banjarmasin
   true, NOW(), NOW()),
   
  (gen_random_uuid(), 
   'd4cbbacd-f743-4372-8a46-372abaee759f', 
   '4ee124e8-3690-4113-a68c-d2a1aefd0421', 
   '292980d9-703d-4387-ac72-8bf4e5152a73', -- Kotabaru
   true, NOW(), NOW()),
   
  (gen_random_uuid(), 
   'd4cbbacd-f743-4372-8a46-372abaee759f', 
   '4ee124e8-3690-4113-a68c-d2a1aefd0421', 
   '5b52f854-68c2-42e2-be3d-4865d5ceaa3b', -- Mekar Putih
   true, NOW(), NOW()),
   
  (gen_random_uuid(), 
   'd4cbbacd-f743-4372-8a46-372abaee759f', 
   '4ee124e8-3690-4113-a68c-d2a1aefd0421', 
   '7b2fa276-df4f-40e1-a10c-5e37ddb066ab', -- Batulicin
   true, NOW(), NOW()),
   
  (gen_random_uuid(), 
   'd4cbbacd-f743-4372-8a46-372abaee759f', 
   '4ee124e8-3690-4113-a68c-d2a1aefd0421', 
   '63ae4720-52ba-465c-946a-e6d08ca31f01', -- Satui (Satui/Bunati)
   true, NOW(), NOW()),
   
  (gen_random_uuid(), 
   'd4cbbacd-f743-4372-8a46-372abaee759f', 
   '4ee124e8-3690-4113-a68c-d2a1aefd0421', 
   'f6804405-a58d-488b-b3db-966510b09e96', -- Sampit
   true, NOW(), NOW()),
   
  (gen_random_uuid(), 
   'd4cbbacd-f743-4372-8a46-372abaee759f', 
   '4ee124e8-3690-4113-a68c-d2a1aefd0421', 
   '84e7477b-3ab9-4ee7-b38c-bf512baa265f', -- Kumai
   true, NOW(), NOW()),

  -- Area Bali Nusa Tenggara - 4 units
  (gen_random_uuid(), 
   'd4cbbacd-f743-4372-8a46-372abaee759f', -- Wilayah 3
   'e8ee7d16-8f35-44ba-8c44-ed94e6caa99a', -- Area Bali Nusa Tenggara
   '73713778-1d8b-4325-9324-32f42a9c1bb7', -- Benoa
   true, NOW(), NOW()),
   
  (gen_random_uuid(), 
   'd4cbbacd-f743-4372-8a46-372abaee759f', 
   'e8ee7d16-8f35-44ba-8c44-ed94e6caa99a', 
   '18a3a99c-8e95-4c27-a781-b1db61222c15', -- Celukan Bawang
   true, NOW(), NOW()),
   
  (gen_random_uuid(), 
   'd4cbbacd-f743-4372-8a46-372abaee759f', 
   'e8ee7d16-8f35-44ba-8c44-ed94e6caa99a', 
   'd543ec10-2ce4-48af-892f-97798d665503', -- Lembar
   true, NOW(), NOW()),
   
  (gen_random_uuid(), 
   'd4cbbacd-f743-4372-8a46-372abaee759f', 
   'e8ee7d16-8f35-44ba-8c44-ed94e6caa99a', 
   'c7afc2d3-b1d4-4377-8201-fa94f61f6ffa', -- Tenau Kupang
   true, NOW(), NOW());

-- Verify the inserted data
SELECT 
  mp.id,
  w.nama as wilayah,
  a.nama_area as area,
  u.nama as unit,
  mp.aktif
FROM master_pelabuhan mp
JOIN wilayah w ON mp.wilayah_id = w.id
JOIN areas a ON mp.area_id = a.id
JOIN units u ON mp.unit_id = u.id
WHERE w.kode = 'WIL-3'
ORDER BY a.nama_area, u.nama;
