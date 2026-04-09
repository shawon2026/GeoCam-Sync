import 'package:flutter/material.dart';
import '/core/presentation/widgets/global_text.dart';

import '/core/utils/extension.dart';

class NetworkWaitingDialog extends StatelessWidget {
  const NetworkWaitingDialog({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: GlobalText.raw(context.loc.networkStatusTitle),
      content: GlobalText.raw(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: GlobalText.raw(context.loc.closeButton),
        ),
      ],
    );
  }
}
