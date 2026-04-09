import 'package:flutter/material.dart';
import '/core/presentation/widgets/global_text.dart';
import 'dart:io';

import '/core/constants/upload_constants.dart';
import '/core/utils/extension.dart';
import '/features/upload_manager/domain/entities/upload_item.dart';

class PendingUploadTile extends StatelessWidget {
  const PendingUploadTile({
    required this.item,
    this.isSelectable = false,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
    this.onDeleteTap,
    super.key,
  });

  final UploadItem item;
  final bool isSelectable;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDeleteTap;

  @override
  Widget build(BuildContext context) {
    final visual = _visualForStatus(item.status);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFFE2E8F0),
              width: isSelected ? 1.4 : 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: const Color(0xFFD8D7DE),
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.center,
                child:
                    item.thumbnailPath != null &&
                        File(item.thumbnailPath!).existsSync()
                    ? Image.file(
                        File(item.thumbnailPath!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Icon(visual.icon, color: visual.color, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: GlobalText.raw(
                            item.fileName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: visual.isMuted
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF1E293B),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                              decoration: item.status == UploadItemStatus.synced
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                        if (item.status == UploadItemStatus.uploading)
                          GlobalText.raw(
                            '${_speedLabel(item.progress)} MB/s',
                            style: const TextStyle(
                              color: Color(0xFF57A6FF),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        if (item.status == UploadItemStatus.synced &&
                            !isSelectable &&
                            onDeleteTap != null) ...[
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: onDeleteTap,
                            child: const Icon(
                              Icons.delete_outline,
                              color: Color(0xFF94A3B8),
                              size: 20,
                            ),
                          ),
                        ],
                        if (item.status == UploadItemStatus.synced &&
                            isSelectable) ...[
                          const SizedBox(width: 8),
                          Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: isSelected
                                ? const Color(0xFF3B82F6)
                                : const Color(0xFF94A3B8),
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    GlobalText.raw(
                      _sizeLabel(item.fileSize),
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (item.status == UploadItemStatus.uploading) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          minHeight: 4,
                          value: item.progress.clamp(0, 1),
                          backgroundColor: const Color(0xFFE2E8F0),
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFF57A6FF),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                    GlobalText.raw(
                      visual.label(context, item),
                      style: TextStyle(
                        color: visual.color,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _UploadTileVisual _visualForStatus(UploadItemStatus status) {
    switch (status) {
      case UploadItemStatus.pending:
        return _UploadTileVisual(
          color: const Color(0xFF7E8AA8),
          icon: Icons.schedule,
          isMuted: false,
          label: (context, _) => context.loc.uploadManagerInQueue,
        );
      case UploadItemStatus.uploading:
        return _UploadTileVisual(
          color: const Color(0xFF57A6FF),
          icon: Icons.cloud_upload_outlined,
          isMuted: false,
          label: (context, item) =>
              '${context.loc.uploadManagerUploadingNow} ${(item.progress * 100).round()}%',
        );
      case UploadItemStatus.waiting:
        return _UploadTileVisual(
          color: const Color(0xFFF7B955),
          icon: Icons.wifi_find_rounded,
          isMuted: false,
          label: (context, _) => context.loc.uploadManagerWaitingNetworkIssue,
        );
      case UploadItemStatus.synced:
        return _UploadTileVisual(
          color: const Color(0xFF00C17C),
          icon: Icons.check_circle_outline,
          isMuted: true,
          label: (context, _) => context.loc.uploadManagerSynced,
        );
      case UploadItemStatus.failed:
        return _UploadTileVisual(
          color: const Color(0xFFFF6B6B),
          icon: Icons.wifi_tethering_error_rounded,
          isMuted: false,
          label: (context, item) =>
              '${context.loc.uploadManagerRetrying} (${context.loc.uploadManagerAttempt} ${item.retryCount + 1}/${UploadConstants.maxRetryCount.value.toInt() + 1})',
        );
      case UploadItemStatus.paused:
        return _UploadTileVisual(
          color: const Color(0xFF7C83FD),
          icon: Icons.pause_circle_outline,
          isMuted: false,
          label: (context, _) => context.loc.uploadManagerPausedByUser,
        );
    }
  }

  String _sizeLabel(int fileSize) {
    if (fileSize >= 1024 * 1024 * 1024) {
      return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
    if (fileSize >= 1024 * 1024) {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(0)} MB';
    }
    if (fileSize >= 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    }
    return '$fileSize B';
  }

  String _speedLabel(double progress) {
    return (18 + (progress * 36)).toStringAsFixed(progress > 0.95 ? 0 : 1);
  }
}

class _UploadTileVisual {
  const _UploadTileVisual({
    required this.color,
    required this.icon,
    required this.isMuted,
    required this.label,
  });

  final Color color;
  final IconData icon;
  final bool isMuted;
  final String Function(BuildContext context, UploadItem item) label;
}
