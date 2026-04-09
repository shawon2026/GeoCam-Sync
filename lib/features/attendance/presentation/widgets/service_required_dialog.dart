import 'package:flutter/material.dart';
import '/core/presentation/widgets/global_text.dart';
import '/core/utils/extension.dart';

class ServiceRequiredDialog extends StatelessWidget {
  const ServiceRequiredDialog({
    required this.message,
    required this.onOpenSettings,
    super.key,
  });

  final String message;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: GlobalText.raw(context.loc.locationServiceRequiredTitle),
      content: GlobalText.raw(message),
      actions: [
        TextButton(
          onPressed: onOpenSettings,
          child: GlobalText.raw(context.loc.enableLocation),
        ),
      ],
    );
  }
}
