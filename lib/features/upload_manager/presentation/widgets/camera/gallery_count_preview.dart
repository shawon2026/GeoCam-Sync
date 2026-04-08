import 'package:flutter/material.dart';

import '/core/utils/extension.dart';

class GalleryCountPreview extends StatelessWidget {
  const GalleryCountPreview({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.photo_library_outlined, size: 18),
      label: Text('$count ${context.loc.capturedItemCount}'),
    );
  }
}
