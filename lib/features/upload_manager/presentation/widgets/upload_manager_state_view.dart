import 'package:flutter/material.dart';

import '/core/utils/extension.dart';
import '/features/upload_manager/domain/entities/upload_item.dart';
import '/features/upload_manager/presentation/widgets/upload_manager/empty_upload_state.dart';
import '/features/upload_manager/presentation/widgets/upload_manager/pending_upload_list.dart';

enum _UploadTab { pending, synced }

class UploadManagerStateView extends StatefulWidget {
  const UploadManagerStateView({required this.items, super.key});

  final List<UploadItem> items;

  @override
  State<UploadManagerStateView> createState() => _UploadManagerStateViewState();
}

class _UploadManagerStateViewState extends State<UploadManagerStateView> {
  _UploadTab _activeTab = _UploadTab.pending;

  @override
  Widget build(BuildContext context) {
    final pendingItems = widget.items
        .where((item) => item.status != UploadItemStatus.synced)
        .toList(growable: false);
    final syncedItems = widget.items
        .where((item) => item.status == UploadItemStatus.synced)
        .toList(growable: false);
    final selectedItems = _activeTab == _UploadTab.pending
        ? pendingItems
        : syncedItems;

    if (widget.items.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          EmptyUploadState(message: context.loc.uploadManagerEmptyState),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _UploadTabs(
          pendingCount: pendingItems.length,
          syncedCount: syncedItems.length,
          activeTab: _activeTab,
          onTabChanged: (tab) => setState(() => _activeTab = tab),
        ),
        const SizedBox(height: 14),
        if (selectedItems.isEmpty)
          EmptyUploadState(
            message: _activeTab == _UploadTab.pending
                ? context.loc.uploadManagerNoPendingItems
                : context.loc.uploadManagerNoSyncedItems,
          )
        else
          PendingUploadList(items: selectedItems),
      ],
    );
  }
}

class _UploadTabs extends StatelessWidget {
  const _UploadTabs({
    required this.pendingCount,
    required this.syncedCount,
    required this.activeTab,
    required this.onTabChanged,
  });

  final int pendingCount;
  final int syncedCount;
  final _UploadTab activeTab;
  final ValueChanged<_UploadTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _UploadTabButton(
              label: '${context.loc.uploadSummaryPending} ($pendingCount)',
              isActive: activeTab == _UploadTab.pending,
              onTap: () => onTabChanged(_UploadTab.pending),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _UploadTabButton(
              label: '${context.loc.uploadManagerSynced} ($syncedCount)',
              isActive: activeTab == _UploadTab.synced,
              onTap: () => onTabChanged(_UploadTab.synced),
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadTabButton extends StatelessWidget {
  const _UploadTabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? const Color(0xFF2D6CFA) : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF64748B),
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}
