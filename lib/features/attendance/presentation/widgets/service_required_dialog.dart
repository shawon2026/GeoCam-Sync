import 'package:flutter/material.dart';
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
      title: Text(context.loc.locationServiceRequiredTitle),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onOpenSettings,
          child: Text(context.loc.enableLocation),
        ),
      ],
    );
  }
}
