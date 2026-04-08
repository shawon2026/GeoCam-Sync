import 'package:flutter/material.dart';

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
    super.key,
  });

  final String networkLabel;
  final SyncPhase phase;
  final UploadProgress summary;
  final bool isPaused;
  final VoidCallback onPauseResume;
  final double? uploadSpeedMbps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: SyncStatusChip(networkLabel: networkLabel, phase: phase),
        ),
        const SizedBox(height: 12),
        UploadSummaryCard(
          summary: summary,
          isPaused: isPaused,
          onPauseResume: onPauseResume,
          uploadSpeedMbps: uploadSpeedMbps,
        ),
      ],
    );
  }
}
