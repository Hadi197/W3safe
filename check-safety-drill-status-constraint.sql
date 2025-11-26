-- Check the status constraint definition
SELECT conname, pg_get_constraintdef(oid) 
FROM pg_constraint 
WHERE conrelid = 'safety_drill'::regclass 
AND conname = 'safety_drill_status_check';
