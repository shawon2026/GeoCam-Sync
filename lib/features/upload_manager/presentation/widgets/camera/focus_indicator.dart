import 'package:flutter/material.dart';

import '/core/utils/extension.dart';
import '/features/upload_manager/domain/repositories/camera_repository.dart';

class FocusIndicator extends StatelessWidget {
  const FocusIndicator({required this.focusPoint, super.key});

  final FocusPoint? focusPoint;

  @override
  Widget build(BuildContext context) {
    return Text(
      focusPoint == null
          ? context.loc.focusAuto
          : '${context.loc.focusPointLabel}: ${focusPoint!.x.toStringAsFixed(2)}, ${focusPoint!.y.toStringAsFixed(2)}',
    );
  }
}
