-- Add photos to existing safety briefings that don't have any
UPDATE safety_briefing
SET foto_briefing = '["https://example.com/default-photo.jpg"]'::jsonb
WHERE foto_briefing IS NULL OR foto_briefing = '[]'::jsonb OR jsonb_array_length(foto_briefing) = 0;

-- Verify the update
SELECT
    id,
    topik,
    CASE
        WHEN foto_briefing IS NULL THEN 0
        ELSE jsonb_array_length(foto_briefing)
    END as photo_count,
    foto_briefing
FROM safety_briefing
ORDER BY created_at DESC
LIMIT 5;
