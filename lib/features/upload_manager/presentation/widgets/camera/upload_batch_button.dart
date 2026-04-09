import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/presentation/widgets/global_text.dart';

import '/core/utils/extension.dart';

class UploadBatchButton extends StatelessWidget {
  const UploadBatchButton({
    required this.enabled,
    required this.count,
    required this.onPressed,
    super.key,
  });

  final bool enabled;
  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: const Icon(Icons.upload_outlined),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF2D66E8),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF8BA8EA),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          textStyle: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.1),
        ),
        label: GlobalText.raw(
          '${context.loc.uploadBatch.toUpperCase()} ($count)',
        ),
      ),
    );
  }
}
