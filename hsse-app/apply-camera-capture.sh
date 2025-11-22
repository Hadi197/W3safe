#!/bin/bash
# Auto-apply camera capture to all remaining modules
# This script will be used as a guide for manual updates

echo "Modules to update:"
echo "1. Safety Briefing (src/views/hsse/SafetyBriefingView.vue)"
echo "2. Silent Inspection (src/views/hsse/SilentInspectionView.vue)"
echo "3. Management Walkthrough (src/views/ManagementWalkthroughView.vue)"
echo "4. Safety Forum (src/views/hsse/SafetyForumView.vue)"
echo ""
echo "Pattern to apply for each:"
echo "1. Add import: import { useImageCompression } from '@/composables/useImageCompression'"
echo "2. Add composable: const { compressSingleImage, formatFileSize } = useImageCompression()"
echo "3. Update photo handler to use compressSingleImage(file)"
echo "4. Replace single file input with dual inputs (camera + gallery)"
echo "5. Add dual button UI (Ambil Foto + Pilih dari Galeri)"
echo ""
echo "Run this manually or use subagent for parallel processing"
