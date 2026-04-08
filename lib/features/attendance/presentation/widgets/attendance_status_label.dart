import 'package:flutter/material.dart';
import '/core/presentation/widgets/global_text.dart';

class AttendanceStatusLabel extends StatelessWidget {
  const AttendanceStatusLabel({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlobalText(
        str: text,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF94A3B8),
        textAlign: TextAlign.center,
      ),
    );
  }
}
