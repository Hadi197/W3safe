-- Fix foreign key relationship for safety_patrol -> units
-- This allows PostgREST to recognize the relationship for joins

-- First, check for any invalid unit_id values
SELECT id, nomor_patrol, unit_id
FROM safety_patrol
WHERE unit_id IS NOT NULL 
  AND unit_id NOT IN (SELECT id FROM units);

-- Clean up invalid unit_id references (set to NULL)
UPDATE safety_patrol
SET unit_id = NULL
WHERE unit_id IS NOT NULL 
  AND unit_id NOT IN (SELECT id FROM units);

-- Add foreign key constraint
ALTER TABLE safety_patrol 
ADD CONSTRAINT fk_safety_patrol_unit 
FOREIGN KEY (unit_id) 
REFERENCES units(id) 
ON DELETE SET NULL;

-- Verify the constraint was created
SELECT tc.constraint_name, tc.table_name, kcu.column_name 
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
  ON tc.constraint_name = kcu.constraint_name
WHERE tc.table_name = 'safety_patrol' 
  AND tc.constraint_type = 'FOREIGN KEY'
  AND kcu.column_name = 'unit_id';
