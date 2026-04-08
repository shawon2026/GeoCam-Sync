import 'package:flutter/material.dart';

import '/features/upload_manager/domain/entities/upload_item.dart';
import '/features/upload_manager/presentation/widgets/upload_manager/pending_upload_tile.dart';

class PendingUploadList extends StatelessWidget {
  const PendingUploadList({required this.items, super.key});

  final List<UploadItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PendingUploadTile(item: item),
            ),
          )
          .toList(),
    );
  }
}
