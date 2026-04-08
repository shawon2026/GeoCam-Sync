import 'package:flutter/material.dart';
import '/core/presentation/widgets/global_text.dart';
import '/core/utils/extension.dart';

class OfficeContextCard extends StatelessWidget {
  const OfficeContextCard({
    required this.hasOfficeLocation,
    required this.onSetOfficeLocation,
    this.officeCoordinateText,
    super.key,
  });

  final bool hasOfficeLocation;
  final String? officeCoordinateText;
  final VoidCallback onSetOfficeLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlobalText(
            str: context.loc.attendanceStepOfficeContext,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF64748B),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 126,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFD1D9E3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDDE7EE), Color(0xFFC5D4E0)],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.my_location,
                          size: 16,
                          color: Color(0xFF2563EB),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          officeCoordinateText ??
                              context.loc.officeLocationNotSet,
                          style: const TextStyle(
                            color: Color(0xFF475569),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GlobalText(
            str: context.loc.attendanceOfficeHint,
            fontSize: 13,
            color: const Color(0xFF64748B),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onSetOfficeLocation,
              icon: const Icon(Icons.add_circle_outline, size: 18),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              label: Text(
                hasOfficeLocation
                    ? context.loc.updateOfficeLocation
                    : context.loc.setOfficeLocation,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
