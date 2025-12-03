-- =====================================================
-- DATABASE OPTIMIZATION: ADD INDEXES
-- Based on actual database column structure
-- =====================================================

-- Safety Briefing Indexes (has: created_at, unit_id, tanggal, created_by)
CREATE INDEX IF NOT EXISTS idx_safety_briefing_created_at ON safety_briefing(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_safety_briefing_unit_id ON safety_briefing(unit_id);
CREATE INDEX IF NOT EXISTS idx_safety_briefing_tanggal ON safety_briefing(tanggal DESC);
CREATE INDEX IF NOT EXISTS idx_safety_briefing_created_by ON safety_briefing(created_by);

-- Silent Inspection Indexes (has: created_at, unit_id, tanggal, tingkat_risiko, created_by)
CREATE INDEX IF NOT EXISTS idx_silent_inspection_created_at ON silent_inspection(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_unit_id ON silent_inspection(unit_id);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_tanggal ON silent_inspection(tanggal DESC);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_tingkat_risiko ON silent_inspection(tingkat_risiko);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_created_by ON silent_inspection(created_by);

-- Safety Drill Indexes (has: created_at, unit_id, tanggal_drill, created_by)
CREATE INDEX IF NOT EXISTS idx_safety_drill_created_at ON safety_drill(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_safety_drill_unit_id ON safety_drill(unit_id);
CREATE INDEX IF NOT EXISTS idx_safety_drill_tanggal ON safety_drill(tanggal_drill DESC);
CREATE INDEX IF NOT EXISTS idx_safety_drill_created_by ON safety_drill(created_by);

-- Safety Induction Indexes (has: created_at, unit_id, tanggal_induction, created_by)
CREATE INDEX IF NOT EXISTS idx_safety_induction_created_at ON safety_induction(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_safety_induction_unit_id ON safety_induction(unit_id);
CREATE INDEX IF NOT EXISTS idx_safety_induction_tanggal ON safety_induction(tanggal_induction DESC);
CREATE INDEX IF NOT EXISTS idx_safety_induction_created_by ON safety_induction(created_by);

-- Safety Forum Indexes (has: created_at, unit_id, tanggal_forum, created_by)
CREATE INDEX IF NOT EXISTS idx_safety_forum_created_at ON safety_forum(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_safety_forum_unit_id ON safety_forum(unit_id);
CREATE INDEX IF NOT EXISTS idx_safety_forum_tanggal ON safety_forum(tanggal_forum DESC);
CREATE INDEX IF NOT EXISTS idx_safety_forum_created_by ON safety_forum(created_by);

-- Safety Patrol Indexes (has: created_at, unit_id, tanggal_patrol, created_by)
CREATE INDEX IF NOT EXISTS idx_safety_patrol_created_at ON safety_patrol(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_safety_patrol_unit_id ON safety_patrol(unit_id);
CREATE INDEX IF NOT EXISTS idx_safety_patrol_tanggal ON safety_patrol(tanggal_patrol DESC);
CREATE INDEX IF NOT EXISTS idx_safety_patrol_created_by ON safety_patrol(created_by);

-- Management Walkthrough Indexes (has: created_at, unit_id, tanggal_walkthrough, created_by)
CREATE INDEX IF NOT EXISTS idx_management_walkthrough_created_at ON management_walkthrough(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_management_walkthrough_unit_id ON management_walkthrough(unit_id);
CREATE INDEX IF NOT EXISTS idx_management_walkthrough_tanggal ON management_walkthrough(tanggal_walkthrough DESC);
CREATE INDEX IF NOT EXISTS idx_management_walkthrough_created_by ON management_walkthrough(created_by);

-- Unsafe Action/Condition Indexes (has: created_at, tanggal_kejadian, created_by)
-- Note: This table has unit_kerja VARCHAR, not unit_id UUID
CREATE INDEX IF NOT EXISTS idx_unsafe_action_created_at ON unsafe_action_condition(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_unsafe_action_tanggal ON unsafe_action_condition(tanggal_kejadian DESC);
CREATE INDEX IF NOT EXISTS idx_unsafe_action_jenis ON unsafe_action_condition(jenis_kejadian);
CREATE INDEX IF NOT EXISTS idx_unsafe_action_created_by ON unsafe_action_condition(created_by);

-- Units Table Indexes
CREATE INDEX IF NOT EXISTS idx_units_aktif ON units(aktif) WHERE aktif = true;
CREATE INDEX IF NOT EXISTS idx_units_tipe ON units(tipe);
CREATE INDEX IF NOT EXISTS idx_units_nama ON units(nama);

-- Pegawai Table Indexes (has: id, nip, nama, email, jabatan, unit_id, wilayah_id, status, created_at)
CREATE INDEX IF NOT EXISTS idx_pegawai_unit_id ON pegawai(unit_id);
CREATE INDEX IF NOT EXISTS idx_pegawai_wilayah_id ON pegawai(wilayah_id);
CREATE INDEX IF NOT EXISTS idx_pegawai_status ON pegawai(status);
CREATE INDEX IF NOT EXISTS idx_pegawai_nip ON pegawai(nip);
CREATE INDEX IF NOT EXISTS idx_pegawai_email ON pegawai(email);

-- Wilayah Table Indexes
CREATE INDEX IF NOT EXISTS idx_wilayah_aktif ON wilayah(aktif) WHERE aktif = true;

-- Composite Indexes for common JOIN operations
CREATE INDEX IF NOT EXISTS idx_safety_briefing_unit_date ON safety_briefing(unit_id, tanggal DESC);
CREATE INDEX IF NOT EXISTS idx_silent_inspection_unit_date ON silent_inspection(unit_id, tanggal DESC);
CREATE INDEX IF NOT EXISTS idx_safety_drill_unit_date ON safety_drill(unit_id, tanggal_drill DESC);
CREATE INDEX IF NOT EXISTS idx_safety_induction_unit_date ON safety_induction(unit_id, tanggal_induction DESC);
CREATE INDEX IF NOT EXISTS idx_safety_forum_unit_date ON safety_forum(unit_id, tanggal_forum DESC);
CREATE INDEX IF NOT EXISTS idx_safety_patrol_unit_date ON safety_patrol(unit_id, tanggal_patrol DESC);
CREATE INDEX IF NOT EXISTS idx_management_walkthrough_unit_date ON management_walkthrough(unit_id, tanggal_walkthrough DESC);

-- Analyze tables to update statistics
ANALYZE safety_briefing;
ANALYZE silent_inspection;
ANALYZE safety_drill;
ANALYZE safety_induction;
ANALYZE safety_forum;
ANALYZE safety_patrol;
ANALYZE management_walkthrough;
ANALYZE unsafe_action_condition;
ANALYZE units;
ANALYZE pegawai;
ANALYZE wilayah;

-- =====================================================
-- COMPLETED: Database indexes created successfully
-- Expected improvements:
-- - Faster filtering by date, unit, and user
-- - Improved JOIN performance
-- - Better query optimization for monitoring dashboard
-- =====================================================
