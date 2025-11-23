-- Add only the critical missing columns for safety_forum
-- Run this FIRST before the full initialization script

-- Add the most important missing columns
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS risiko_teridentifikasi JSONB;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS apd_yang_diperlukan TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS training_yang_diperlukan TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS foto_forum TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS dokumen_pendukung TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS presentasi_url TEXT[];
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS action_items JSONB;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS agenda_detail JSONB;
ALTER TABLE safety_forum ADD COLUMN IF NOT EXISTS poin_poin_pembahasan JSONB;

-- Check if columns were added
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'safety_forum'
    AND column_name IN (
        'risiko_teridentifikasi',
        'apd_yang_diperlukan',
        'training_yang_diperlukan',
        'foto_forum',
        'dokumen_pendukung',
        'presentasi_url',
        'action_items',
        'agenda_detail',
        'poin_poin_pembahasan'
    )
ORDER BY column_name;
