import 'package:equatable/equatable.dart';

import '/core/network/network_state.dart';

enum SyncPhase { idle, uploading, retrying, waiting, paused, completed }

class SyncStatus extends Equatable {
  const SyncStatus({
    required this.networkState,
    required this.phase,
    required this.isBackgroundWorkerRegistered,
    required this.message,
    required this.uploadSpeedMbps,
  });

  final NetworkState networkState;
  final SyncPhase phase;
  final bool isBackgroundWorkerRegistered;
  final String message;
  final double? uploadSpeedMbps;

  SyncStatus copyWith({
    NetworkState? networkState,
    SyncPhase? phase,
    bool? isBackgroundWorkerRegistered,
    String? message,
    double? uploadSpeedMbps,
  }) {
    return SyncStatus(
      networkState: networkState ?? this.networkState,
      phase: phase ?? this.phase,
      isBackgroundWorkerRegistered:
          isBackgroundWorkerRegistered ?? this.isBackgroundWorkerRegistered,
      message: message ?? this.message,
      uploadSpeedMbps: uploadSpeedMbps ?? this.uploadSpeedMbps,
    );
  }

  @override
  List<Object?> get props => [
    networkState,
    phase,
    isBackgroundWorkerRegistered,
    message,
    uploadSpeedMbps,
  ];
}
