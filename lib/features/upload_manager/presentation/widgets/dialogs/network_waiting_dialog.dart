import 'package:flutter/material.dart';

import '/core/utils/extension.dart';

class NetworkWaitingDialog extends StatelessWidget {
  const NetworkWaitingDialog({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.loc.networkStatusTitle),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.loc.closeButton),
        ),
      ],
    );
  }
}
