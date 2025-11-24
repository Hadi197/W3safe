-- Make pic_hse column nullable in safety_induction table
ALTER TABLE safety_induction 
ALTER COLUMN pic_hse DROP NOT NULL;

-- Verify the change
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'safety_induction'
  AND column_name = 'pic_hse';
