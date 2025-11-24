-- ===================================================================
-- INSERT MISSING UNITS (Tanjung Emas dan Tanjung Wangi)
-- ===================================================================

INSERT INTO units (id, kode, nama, aktif, created_at, updated_at)
VALUES 
  (gen_random_uuid(), 'UNIT-TANJUNGEMAS', 'Tanjung Emas', true, NOW(), NOW()),
  (gen_random_uuid(), 'UNIT-TANJUNGWANGI', 'Tanjung Wangi', true, NOW(), NOW());

-- Get the newly created unit IDs
SELECT id, kode, nama FROM units WHERE kode IN ('UNIT-TANJUNGEMAS', 'UNIT-TANJUNGWANGI');
