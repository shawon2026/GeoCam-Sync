import 'package:flutter/material.dart';

import '/core/utils/extension.dart';

class CameraPermissionDialog extends StatelessWidget {
  const CameraPermissionDialog({required this.onGivePermission, super.key});

  final VoidCallback onGivePermission;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.loc.cameraPermissionTitle),
      content: Text(context.loc.cameraPermissionHint),
      actions: [
        TextButton(
          onPressed: onGivePermission,
          child: Text(context.loc.goToSettings),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.loc.closeButton),
        ),
      ],
    );
  }
}
