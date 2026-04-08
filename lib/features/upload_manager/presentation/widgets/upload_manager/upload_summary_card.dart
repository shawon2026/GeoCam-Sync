import 'package:flutter/material.dart';

import '/core/utils/extension.dart';
import '/features/upload_manager/domain/entities/upload_progress.dart';

class UploadSummaryCard extends StatelessWidget {
  const UploadSummaryCard({
    required this.summary,
    required this.isPaused,
    required this.onPauseResume,
    required this.uploadSpeedMbps,
    super.key,
  });

  final UploadProgress summary;
  final bool isPaused;
  final VoidCallback onPauseResume;
  final double? uploadSpeedMbps;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'BATCH SYNC PROGRESS',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              Text(
                '${(summary.completion * 100).round()}%',
                style: const TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: summary.completion,
              minHeight: 6,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF4B82FF)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${summary.uploadedItems}/${summary.totalItems} ${context.loc.uploadSummaryUploaded}',
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                uploadSpeedMbps == null
                    ? '-- Mbps'
                    : '${uploadSpeedMbps!.toStringAsFixed(1)} Mbps',
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: onPauseResume,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF5C8DFF),
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  isPaused
                      ? context.loc.resumeAllUploads.toUpperCase()
                      : context.loc.pauseAllUploads.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
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
}
