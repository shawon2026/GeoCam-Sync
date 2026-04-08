import 'package:flutter/material.dart';

import '/features/upload_manager/domain/entities/upload_item.dart';

class UploadManagerContentSection extends StatelessWidget {
  const UploadManagerContentSection({
    required this.items,
    required this.stateView,
    super.key,
  });

  final List<UploadItem> items;
  final Widget stateView;

  @override
  Widget build(BuildContext context) {
    return stateView;
  }
}
