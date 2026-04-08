import 'package:equatable/equatable.dart';

import '/core/network/network_state.dart';
import '/features/upload_manager/domain/entities/sync_status.dart';

class SyncEngineState extends Equatable {
  const SyncEngineState({
    this.networkState = NetworkState.offline,
    this.phase = SyncPhase.idle,
    this.message = '',
    this.uploadSpeedMbps,
  });

  final NetworkState networkState;
  final SyncPhase phase;
  final String message;
  final double? uploadSpeedMbps;

  SyncEngineState copyWith({
    NetworkState? networkState,
    SyncPhase? phase,
    String? message,
    double? uploadSpeedMbps,
  }) {
    return SyncEngineState(
      networkState: networkState ?? this.networkState,
      phase: phase ?? this.phase,
      message: message ?? this.message,
      uploadSpeedMbps: uploadSpeedMbps ?? this.uploadSpeedMbps,
    );
  }

  @override
  List<Object?> get props => [networkState, phase, message, uploadSpeedMbps];
}
