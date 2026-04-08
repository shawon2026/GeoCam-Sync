import 'package:flutter/material.dart';

import '/core/utils/extension.dart';

class PauseResumeButton extends StatelessWidget {
  const PauseResumeButton({
    required this.isPaused,
    required this.onPressed,
    super.key,
  });

  final bool isPaused;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
      label: Text(
        isPaused ? context.loc.resumeAllUploads : context.loc.pauseAllUploads,
      ),
    );
  }
}
