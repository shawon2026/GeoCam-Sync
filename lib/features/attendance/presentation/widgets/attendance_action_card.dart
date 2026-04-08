import 'package:flutter/material.dart';
import '/core/presentation/widgets/global_text.dart';

class AttendanceActionCard extends StatelessWidget {
  const AttendanceActionCard({
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.enabled,
    required this.isLoading,
    required this.onMark,
    required this.availabilityText,
    this.showLockIcon = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final String buttonLabel;
  final bool enabled;
  final bool isLoading;
  final VoidCallback onMark;
  final String availabilityText;
  final bool showLockIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: enabled ? const Color(0xFFD1D5DB) : const Color(0xFFCBD5E1),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLockIcon) ...[
            const Center(
              child: Icon(Icons.lock_outline_rounded, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 8),
          ],
          GlobalText(str: title, fontSize: 16, fontWeight: FontWeight.w700),
          const SizedBox(height: 6),
          GlobalText(
            str: subtitle,
            fontSize: 12,
            color: const Color(0xFF64748B),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: enabled && !isLoading ? onMark : null,
              style: FilledButton.styleFrom(
                backgroundColor: enabled
                    ? const Color(0xFF2563EB)
                    : const Color(0xFFB7C3D2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(buttonLabel),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              availabilityText,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
