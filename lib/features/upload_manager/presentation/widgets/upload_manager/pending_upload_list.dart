import 'package:flutter/material.dart';

import '/features/upload_manager/domain/entities/upload_item.dart';
import '/features/upload_manager/presentation/widgets/upload_manager/pending_upload_tile.dart';

class PendingUploadList extends StatelessWidget {
  const PendingUploadList({required this.items, super.key});

  final List<UploadItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => PendingUploadTile(item: items[index]),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}
