-- Check all columns for HSSE tables
-- Run this in Supabase SQL Editor first to see actual column names

-- Safety Briefing columns
SELECT 'safety_briefing' as table_name, column_name, data_type
FROM information_schema.columns
WHERE table_name = 'safety_briefing' AND table_schema = 'public'

UNION ALL

-- Silent Inspection columns
SELECT 'silent_inspection' as table_name, column_name, data_type
FROM information_schema.columns
WHERE table_name = 'silent_inspection' AND table_schema = 'public'

UNION ALL

-- Safety Drill columns
SELECT 'safety_drill' as table_name, column_name, data_type
FROM information_schema.columns
WHERE table_name = 'safety_drill' AND table_schema = 'public'

UNION ALL

-- Safety Induction columns
SELECT 'safety_induction' as table_name, column_name, data_type
FROM information_schema.columns
WHERE table_name = 'safety_induction' AND table_schema = 'public'

UNION ALL

-- Safety Forum columns
SELECT 'safety_forum' as table_name, column_name, data_type
FROM information_schema.columns
WHERE table_name = 'safety_forum' AND table_schema = 'public'

UNION ALL

-- Safety Patrol columns
SELECT 'safety_patrol' as table_name, column_name, data_type
FROM information_schema.columns
WHERE table_name = 'safety_patrol' AND table_schema = 'public'

UNION ALL

-- Management Walkthrough columns
SELECT 'management_walkthrough' as table_name, column_name, data_type
FROM information_schema.columns
WHERE table_name = 'management_walkthrough' AND table_schema = 'public'

UNION ALL

-- Unsafe Action/Condition columns
SELECT 'unsafe_action_condition' as table_name, column_name, data_type
FROM information_schema.columns
WHERE table_name = 'unsafe_action_condition' AND table_schema = 'public'

ORDER BY table_name, column_name;
