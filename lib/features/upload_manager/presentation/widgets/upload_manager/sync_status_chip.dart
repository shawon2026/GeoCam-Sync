import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/presentation/widgets/global_text.dart';

import '/features/upload_manager/domain/entities/sync_status.dart';

class SyncStatusChip extends StatelessWidget {
  const SyncStatusChip({
    required this.networkLabel,
    required this.phase,
    super.key,
  });

  final String networkLabel;
  final SyncPhase phase;

  @override
  Widget build(BuildContext context) {
    final (Color dotColor, Color borderColor, Color bgColor) = switch (phase) {
      SyncPhase.uploading => (
        const Color(0xFF10B981),
        const Color(0xFF86EFAC),
        const Color(0xFFF0FDF4),
      ),
      SyncPhase.waiting => (
        const Color(0xFFF59E0B),
        const Color(0xFFFDE68A),
        const Color(0xFFFFFBEB),
      ),
      SyncPhase.retrying => (
        const Color(0xFFF97316),
        const Color(0xFFFECACA),
        const Color(0xFFFFF7ED),
      ),
      SyncPhase.completed => (
        const Color(0xFF22C55E),
        const Color(0xFF86EFAC),
        const Color(0xFFF0FDF4),
      ),
      _ => (
        const Color(0xFF0EA5E9),
        const Color(0xFFBAE6FD),
        const Color(0xFFF0F9FF),
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 9, color: dotColor),
          SizedBox(width: 8.w),
          GlobalText.raw(
            '$networkLabel  ${_phaseLabel(phase)}',
            style: TextStyle(
              color: dotColor,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  String _phaseLabel(SyncPhase phase) {
    switch (phase) {
      case SyncPhase.uploading:
        return 'UPLOADING';
      case SyncPhase.retrying:
        return 'RETRYING';
      case SyncPhase.waiting:
        return 'WAITING';
      case SyncPhase.paused:
        return 'PAUSED';
      case SyncPhase.completed:
        return 'READY';
      case SyncPhase.idle:
        return 'LINK';
    }
  }
}
