import 'package:flutter/material.dart';

import '/features/upload_manager/domain/entities/upload_item.dart';
import '/features/upload_manager/presentation/widgets/upload_manager/pending_upload_tile.dart';

class PendingUploadList extends StatelessWidget {
  const PendingUploadList({
    required this.items,
    this.isSelectable = false,
    this.selectedIds = const <String>{},
    this.onItemTap,
    this.onItemLongPress,
    this.onDeleteTap,
    super.key,
  });

  final List<UploadItem> items;
  final bool isSelectable;
  final Set<String> selectedIds;
  final ValueChanged<UploadItem>? onItemTap;
  final ValueChanged<UploadItem>? onItemLongPress;
  final ValueChanged<UploadItem>? onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = items[index];
        return PendingUploadTile(
          item: item,
          isSelectable: isSelectable,
          isSelected: selectedIds.contains(item.id),
          onTap: onItemTap == null ? null : () => onItemTap!(item),
          onLongPress: onItemLongPress == null
              ? null
              : () => onItemLongPress!(item),
          onDeleteTap: onDeleteTap == null ? null : () => onDeleteTap!(item),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}
