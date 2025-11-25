-- Delete all existing LTIFR data
-- Run this first before inserting new sample data

DELETE FROM ltifr_records;

-- Verify deletion
SELECT COUNT(*) as total_records FROM ltifr_records;
