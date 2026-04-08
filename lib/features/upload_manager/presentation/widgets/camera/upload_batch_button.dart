import 'package:flutter/material.dart';

import '/core/utils/extension.dart';

class UploadBatchButton extends StatelessWidget {
  const UploadBatchButton({
    required this.enabled,
    required this.onPressed,
    super.key,
  });

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: const Icon(Icons.cloud_upload_outlined),
        label: Text(context.loc.uploadBatch),
      ),
    );
  }
}
