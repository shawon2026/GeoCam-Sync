import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/presentation/widgets/global_text.dart';

import '/core/utils/extension.dart';
import '/features/upload_manager/domain/entities/sync_status.dart';
import '/features/upload_manager/domain/entities/upload_progress.dart';

class UploadSummaryCard extends StatelessWidget {
  const UploadSummaryCard({
    required this.summary,
    required this.phase,
    required this.isPaused,
    required this.onPauseResume,
    required this.uploadSpeedMbps,
    super.key,
  });

  final UploadProgress summary;
  final SyncPhase phase;
  final bool isPaused;
  final VoidCallback onPauseResume;
  final double? uploadSpeedMbps;

  @override
  Widget build(BuildContext context) {
    final uploadedPercent = (summary.completion * 100).round();

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GlobalText.raw(
                  context.loc.uploadManagerBatchSyncProgress.toUpperCase(),
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
              GlobalText.raw(
                '$uploadedPercent%',
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: summary.completion),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 7,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF3B82F6)),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: GlobalText.raw(
                  _statusLabel(context),
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GlobalText.raw(
                uploadSpeedMbps == null
                    ? '-- Mbps'
                    : '${uploadSpeedMbps!.toStringAsFixed(1)} Mbps',
                style: TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 12.w),
              TextButton(
                onPressed: onPauseResume,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF5C8DFF),
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: GlobalText.raw(
                  isPaused
                      ? context.loc.resumeAllUploads.toUpperCase()
                      : context.loc.pauseAllUploads.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusLabel(BuildContext context) {
    if (isPaused || phase == SyncPhase.paused) {
      return context.loc.uploadManagerPausedByUser;
    }

    switch (phase) {
      case SyncPhase.uploading:
        return context.loc.uploadManagerUploadingNow;
      case SyncPhase.waiting:
        return context.loc.uploadManagerWaitingNetworkIssue;
      case SyncPhase.retrying:
        return context.loc.uploadManagerRetrying;
      case SyncPhase.idle:
      case SyncPhase.completed:
      case SyncPhase.paused:
        return '---';
    }
  }
}
