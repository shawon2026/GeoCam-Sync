import 'package:flutter/material.dart';

import '/core/utils/extension.dart';
import '/features/upload_manager/domain/entities/upload_item.dart';
import '/features/upload_manager/presentation/widgets/upload_manager/empty_upload_state.dart';
import '/features/upload_manager/presentation/widgets/upload_manager/pending_upload_list.dart';

enum _UploadTab { pending, synced }

class UploadManagerStateView extends StatefulWidget {
  const UploadManagerStateView({
    required this.items,
    required this.onClearSyncedItems,
    required this.onClearAllSyncedItems,
    super.key,
  });

  final List<UploadItem> items;
  final Future<void> Function(List<String> itemIds) onClearSyncedItems;
  final Future<void> Function() onClearAllSyncedItems;

  @override
  State<UploadManagerStateView> createState() => _UploadManagerStateViewState();
}

class _UploadManagerStateViewState extends State<UploadManagerStateView> {
  _UploadTab _activeTab = _UploadTab.pending;
  bool _selectionMode = false;
  bool _isClearing = false;
  final Set<String> _selectedSyncedIds = <String>{};

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

    _selectedSyncedIds.removeWhere(
      (id) => syncedItems.every((item) => item.id != id),
    );

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
          onTabChanged: (tab) {
            setState(() {
              _activeTab = tab;
              if (tab == _UploadTab.pending) {
                _selectionMode = false;
                _selectedSyncedIds.clear();
              }
            });
          },
        ),
        if (_activeTab == _UploadTab.synced && syncedItems.isNotEmpty) ...[
          const SizedBox(height: 10),
          _SyncedActionsBar(
            selectionMode: _selectionMode,
            selectedCount: _selectedSyncedIds.length,
            totalCount: syncedItems.length,
            isBusy: _isClearing,
            onToggleSelectionMode: () {
              setState(() {
                _selectionMode = !_selectionMode;
                if (!_selectionMode) {
                  _selectedSyncedIds.clear();
                }
              });
            },
            onToggleSelectAll: () {
              setState(() {
                if (_selectedSyncedIds.length == syncedItems.length) {
                  _selectedSyncedIds.clear();
                } else {
                  _selectedSyncedIds
                    ..clear()
                    ..addAll(syncedItems.map((item) => item.id));
                }
              });
            },
            onClearSelected: _clearSelected,
            onClearAll: _clearAll,
          ),
        ],
        const SizedBox(height: 14),
        if (selectedItems.isEmpty)
          EmptyUploadState(
            message: _activeTab == _UploadTab.pending
                ? context.loc.uploadManagerNoPendingItems
                : context.loc.uploadManagerNoSyncedItems,
          )
        else
          PendingUploadList(
            items: selectedItems,
            isSelectable: _activeTab == _UploadTab.synced && _selectionMode,
            selectedIds: _selectedSyncedIds,
            onItemTap: _activeTab == _UploadTab.synced
                ? (item) {
                    if (!_selectionMode) {
                      return;
                    }
                    setState(() {
                      if (_selectedSyncedIds.contains(item.id)) {
                        _selectedSyncedIds.remove(item.id);
                      } else {
                        _selectedSyncedIds.add(item.id);
                      }
                    });
                  }
                : null,
            onItemLongPress: _activeTab == _UploadTab.synced
                ? (item) {
                    setState(() {
                      _selectionMode = true;
                      if (_selectedSyncedIds.contains(item.id)) {
                        _selectedSyncedIds.remove(item.id);
                      } else {
                        _selectedSyncedIds.add(item.id);
                      }
                    });
                  }
                : null,
            onDeleteTap: (_activeTab == _UploadTab.synced && !_selectionMode)
                ? (item) => _clearSingle(item.id)
                : null,
          ),
      ],
    );
  }

  Future<void> _clearSingle(String itemId) async {
    final shouldClear = await _confirmClear(
      title: context.loc.uploadManagerClearSyncedSingle,
      content: context.loc.uploadManagerClearSyncedConfirm,
    );
    if (!shouldClear) {
      return;
    }
    await _runClearAction(() => widget.onClearSyncedItems([itemId]));
  }

  Future<void> _clearSelected() async {
    if (_selectedSyncedIds.isEmpty) {
      return;
    }
    final shouldClear = await _confirmClear(
      title: context.loc.uploadManagerClearSelected,
      content: context.loc.uploadManagerClearSyncedConfirm,
    );
    if (!shouldClear) {
      return;
    }
    final ids = _selectedSyncedIds.toList(growable: false);
    await _runClearAction(() async {
      await widget.onClearSyncedItems(ids);
      if (mounted) {
        setState(() {
          _selectedSyncedIds.clear();
          _selectionMode = false;
        });
      }
    });
  }

  Future<void> _clearAll() async {
    final shouldClear = await _confirmClear(
      title: context.loc.uploadManagerClearAllSynced,
      content: context.loc.uploadManagerClearSyncedConfirm,
    );
    if (!shouldClear) {
      return;
    }
    await _runClearAction(() async {
      await widget.onClearAllSyncedItems();
      if (mounted) {
        setState(() {
          _selectedSyncedIds.clear();
          _selectionMode = false;
        });
      }
    });
  }

  Future<void> _runClearAction(Future<void> Function() action) async {
    if (_isClearing) {
      return;
    }
    setState(() => _isClearing = true);
    await action();
    if (mounted) {
      setState(() => _isClearing = false);
    }
  }

  Future<bool> _confirmClear({
    required String title,
    required String content,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.loc.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.loc.delete),
          ),
        ],
      ),
    );
    return result ?? false;
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

class _SyncedActionsBar extends StatelessWidget {
  const _SyncedActionsBar({
    required this.selectionMode,
    required this.selectedCount,
    required this.totalCount,
    required this.isBusy,
    required this.onToggleSelectionMode,
    required this.onToggleSelectAll,
    required this.onClearSelected,
    required this.onClearAll,
  });

  final bool selectionMode;
  final int selectedCount;
  final int totalCount;
  final bool isBusy;
  final VoidCallback onToggleSelectionMode;
  final VoidCallback onToggleSelectAll;
  final Future<void> Function() onClearSelected;
  final Future<void> Function() onClearAll;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton(
          onPressed: isBusy ? null : onToggleSelectionMode,
          child: Text(
            selectionMode
                ? context.loc.cancel
                : context.loc.uploadManagerSelect,
          ),
        ),
        if (selectionMode)
          OutlinedButton(
            onPressed: isBusy ? null : onToggleSelectAll,
            child: Text(
              selectedCount == totalCount
                  ? context.loc.uploadManagerUnselectAll
                  : context.loc.uploadManagerSelectAll,
            ),
          ),
        if (selectionMode)
          FilledButton.tonal(
            onPressed: isBusy || selectedCount == 0 ? null : onClearSelected,
            child: Text(
              '${context.loc.uploadManagerClearSelected} ($selectedCount)',
            ),
          ),
        FilledButton.tonal(
          onPressed: isBusy ? null : onClearAll,
          child: Text(context.loc.uploadManagerClearAllSynced),
        ),
      ],
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
