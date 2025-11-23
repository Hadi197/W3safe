-- Add foreign key constraint for safety_forum -> units relationship
-- This will enable the join to work properly

-- Add foreign key constraint if it doesn't exist
DO $$
BEGIN
    -- Check if constraint already exists
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.table_constraints
        WHERE constraint_name = 'fk_safety_forum_unit'
        AND table_name = 'safety_forum'
    ) THEN
        -- Add the foreign key constraint
        ALTER TABLE safety_forum
        ADD CONSTRAINT fk_safety_forum_unit
        FOREIGN KEY (unit_id) REFERENCES units(id) ON DELETE SET NULL;

        RAISE NOTICE 'Foreign key constraint fk_safety_forum_unit added successfully';
    ELSE
        RAISE NOTICE 'Foreign key constraint fk_safety_forum_unit already exists';
    END IF;
END $$;

-- Verify the constraint was added
SELECT
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS referenced_table,
    ccu.column_name AS referenced_column
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_name = 'safety_forum'
    AND kcu.column_name = 'unit_id';
