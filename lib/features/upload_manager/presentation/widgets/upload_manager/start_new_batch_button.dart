import 'package:flutter/material.dart';
import '/core/presentation/widgets/global_text.dart';

import '/core/utils/extension.dart';

class StartNewBatchButton extends StatelessWidget {
  const StartNewBatchButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x663B82F6),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF3E73F1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          child: GlobalText.raw(context.loc.startNewUploadBatch.toUpperCase()),
        ),
      ),
    );
  }
}
