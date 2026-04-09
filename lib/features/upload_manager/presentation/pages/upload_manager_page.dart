import 'package:flutter/material.dart';

import '/features/upload_manager/domain/entities/sync_status.dart';
import '/features/upload_manager/domain/entities/upload_item.dart';
import '/features/upload_manager/domain/entities/upload_progress.dart';
import '/features/upload_manager/presentation/widgets/upload_manager_content_section.dart';
import '/features/upload_manager/presentation/widgets/upload_manager_header_section.dart';
import '/features/upload_manager/presentation/widgets/upload_manager_state_view.dart';

class UploadManagerPage extends StatelessWidget {
  const UploadManagerPage({
    required this.networkLabel,
    required this.phase,
    required this.summary,
    required this.items,
    required this.isPaused,
    required this.onPauseResume,
    required this.uploadSpeedMbps,
    required this.onClearSyncedItems,
    required this.onClearAllSyncedItems,
    super.key,
  });

  final String networkLabel;
  final SyncPhase phase;
  final UploadProgress summary;
  final List<UploadItem> items;
  final bool isPaused;
  final VoidCallback onPauseResume;
  final double? uploadSpeedMbps;
  final Future<void> Function(List<String> itemIds) onClearSyncedItems;
  final Future<void> Function() onClearAllSyncedItems;

  @override
  Widget build(BuildContext context) {
    final stateView = UploadManagerStateView(
      items: items,
      onClearSyncedItems: onClearSyncedItems,
      onClearAllSyncedItems: onClearAllSyncedItems,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
      children: [
        UploadManagerHeaderSection(
          networkLabel: networkLabel,
          phase: phase,
          summary: summary,
          isPaused: isPaused,
          onPauseResume: onPauseResume,
          uploadSpeedMbps: uploadSpeedMbps,
          hasItems: items.isNotEmpty,
        ),
        const SizedBox(height: 18),
        UploadManagerContentSection(items: items, stateView: stateView),
      ],
    );
  }
}
