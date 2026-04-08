import 'package:flutter/material.dart';

import '/core/utils/extension.dart';
import '/features/upload_manager/domain/entities/upload_item.dart';
import '/features/upload_manager/presentation/widgets/upload_manager/empty_upload_state.dart';
import '/features/upload_manager/presentation/widgets/upload_manager/pending_upload_list.dart';

class UploadManagerStateView extends StatelessWidget {
  const UploadManagerStateView({required this.items, super.key});

  final List<UploadItem> items;

  @override
  Widget build(BuildContext context) {
    final heading = Text(
      'PENDING UPLOADS (${items.length})',
      style: const TextStyle(
        color: Color(0xFF6E7A9A),
        fontSize: 13,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.1,
      ),
    );
    if (items.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heading,
          const SizedBox(height: 14),
          EmptyUploadState(message: context.loc.uploadManagerEmptyState),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading,
        const SizedBox(height: 14),
        PendingUploadList(items: items),
      ],
    );
  }
}
