import 'package:flutter/material.dart';
import '/core/presentation/widgets/global_text.dart';
import '/core/utils/extension.dart';

class EmptyUploadState extends StatelessWidget {
  const EmptyUploadState({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_upload_outlined,
            size: 40,
            color: Color(0xFF94A3B8),
          ),
          const SizedBox(height: 12),
          GlobalText.raw(
            context.loc.uploadManagerNoUploadsYet,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF334155),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          GlobalText.raw(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
