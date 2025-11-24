-- Check for missing units mentioned in the list
SELECT id, kode, nama FROM units 
WHERE nama IN ('Tanjung Emas', 'Tanjung Wangi')
ORDER BY nama;

-- Also check all units to see what we have
SELECT id, kode, nama FROM units ORDER BY nama;
