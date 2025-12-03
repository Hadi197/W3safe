-- =====================================================
-- DELETE OLD DATA - Keep only December 3, 2025
-- =====================================================

-- Safety Briefing
DELETE FROM safety_briefing 
WHERE tanggal != '2025-12-03';

-- Silent Inspection  
DELETE FROM silent_inspection
WHERE tanggal != '2025-12-03';

-- Safety Drill
DELETE FROM safety_drill
WHERE tanggal_drill != '2025-12-03';

-- Safety Induction
DELETE FROM safety_induction
WHERE tanggal_induction != '2025-12-03';

-- Safety Forum
DELETE FROM safety_forum
WHERE tanggal_forum != '2025-12-03';

-- Safety Patrol
DELETE FROM safety_patrol
WHERE tanggal_patrol != '2025-12-03';

-- Management Walkthrough
DELETE FROM management_walkthrough
WHERE tanggal_walkthrough != '2025-12-03';

-- Unsafe Action/Condition
DELETE FROM unsafe_action_condition
WHERE tanggal_kejadian != '2025-12-03';

-- LTIFR Records (Delete ALL data)
DELETE FROM ltifr_records;

-- =====================================================
-- Show remaining records count
-- =====================================================

SELECT 
  'safety_briefing' as table_name,
  COUNT(*) as remaining_records
FROM safety_briefing
WHERE tanggal = '2025-12-03'

UNION ALL

SELECT 
  'silent_inspection',
  COUNT(*)
FROM silent_inspection
WHERE tanggal = '2025-12-03'

UNION ALL

SELECT 
  'safety_drill',
  COUNT(*)
FROM safety_drill
WHERE tanggal_drill = '2025-12-03'

UNION ALL

SELECT 
  'safety_induction',
  COUNT(*)
FROM safety_induction
WHERE tanggal_induction = '2025-12-03'

UNION ALL

SELECT 
  'safety_forum',
  COUNT(*)
FROM safety_forum
WHERE tanggal_forum = '2025-12-03'

UNION ALL

SELECT 
  'safety_patrol',
  COUNT(*)
FROM safety_patrol
WHERE tanggal_patrol = '2025-12-03'

UNION ALL

SELECT 
  'management_walkthrough',
  COUNT(*)
FROM management_walkthrough
WHERE tanggal_walkthrough = '2025-12-03'

UNION ALL

SELECT 
  'unsafe_action_condition',
  COUNT(*)
FROM unsafe_action_condition
WHERE tanggal_kejadian = '2025-12-03'

ORDER BY table_name;
