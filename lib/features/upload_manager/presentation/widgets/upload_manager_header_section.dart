import 'package:flutter/material.dart';
import '/core/presentation/widgets/global_text.dart';
import '/core/utils/extension.dart';

import '/features/upload_manager/domain/entities/sync_status.dart';
import '/features/upload_manager/presentation/widgets/upload_manager/sync_status_chip.dart';
import '/features/upload_manager/presentation/widgets/upload_manager/upload_summary_card.dart';
import '/features/upload_manager/domain/entities/upload_progress.dart';

class UploadManagerHeaderSection extends StatelessWidget {
  const UploadManagerHeaderSection({
    required this.networkLabel,
    required this.phase,
    required this.summary,
    required this.isPaused,
    required this.onPauseResume,
    required this.uploadSpeedMbps,
    required this.hasItems,
    super.key,
  });

  final String networkLabel;
  final SyncPhase phase;
  final UploadProgress summary;
  final bool isPaused;
  final VoidCallback onPauseResume;
  final double? uploadSpeedMbps;
  final bool hasItems;

  @override
  Widget build(BuildContext context) {
    final showSummaryCard = hasItems && summary.pendingItems > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GlobalText.raw(
          context.loc.networkStatusTitle.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF7C8FB4),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        SyncStatusChip(networkLabel: networkLabel, phase: phase),
        if (showSummaryCard) ...[
          const SizedBox(height: 12),
          UploadSummaryCard(
            summary: summary,
            phase: phase,
            isPaused: isPaused,
            onPauseResume: onPauseResume,
            uploadSpeedMbps: uploadSpeedMbps,
          ),
        ],
      ],
    );
  }
}
