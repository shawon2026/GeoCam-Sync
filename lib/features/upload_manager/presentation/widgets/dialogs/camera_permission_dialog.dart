import 'package:flutter/material.dart';
import '/core/presentation/widgets/global_text.dart';

import '/core/utils/extension.dart';

class CameraPermissionDialog extends StatelessWidget {
  const CameraPermissionDialog({required this.onGivePermission, super.key});

  final VoidCallback onGivePermission;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: GlobalText.raw(context.loc.cameraPermissionTitle),
      content: GlobalText.raw(context.loc.cameraPermissionHint),
      actions: [
        TextButton(
          onPressed: onGivePermission,
          child: GlobalText.raw(context.loc.goToSettings),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: GlobalText.raw(context.loc.closeButton),
        ),
      ],
    );
  }
}
