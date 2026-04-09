import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import '/core/network/network_state.dart';

abstract class ConnectivityService {
  Stream<NetworkState> watchNetworkState();

  Future<NetworkState> getCurrentState();
}

class ConnectivityServiceImpl implements ConnectivityService {
  ConnectivityServiceImpl({required Connectivity connectivity})
    : _connectivity = connectivity;

  final Connectivity _connectivity;
  static const Duration _probeTimeout = Duration(seconds: 2);
  static const Duration _pollInterval = Duration(seconds: 3);
  static const Duration _freshConnectionWindow = Duration(seconds: 8);
  static const int _stableLatencyThresholdMs = 220;

  Set<ConnectivityResult> _lastConnectivity = <ConnectivityResult>{};
  DateTime? _connectedAt;

  @override
  Future<NetworkState> getCurrentState() async {
    final results = await _connectivity.checkConnectivity();
    return _resolveState(results);
  }

  @override
  Stream<NetworkState> watchNetworkState() {
    final controller = StreamController<NetworkState>();
    StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;
    Timer? pollTimer;
    NetworkState? lastEmitted;

    Future<void> emitFrom(List<ConnectivityResult> results) async {
      final next = await _resolveState(results);
      if (lastEmitted == next) {
        return;
      }
      lastEmitted = next;
      if (!controller.isClosed) {
        controller.add(next);
      }
    }

    Future<void> emitFromCurrentConnectivity() async {
      final results = await _connectivity.checkConnectivity();
      await emitFrom(results);
    }

    controller.onListen = () {
      unawaited(emitFromCurrentConnectivity());

      connectivitySubscription = _connectivity.onConnectivityChanged.listen((
        results,
      ) {
        unawaited(emitFrom(results));
      });

      pollTimer = Timer.periodic(_pollInterval, (_) {
        unawaited(emitFromCurrentConnectivity());
      });
    };

    controller.onCancel = () async {
      await connectivitySubscription?.cancel();
      pollTimer?.cancel();
      await controller.close();
    };

    return controller.stream;
  }

  Future<NetworkState> _resolveState(List<ConnectivityResult> results) async {
    final nextConnectivity = results.toSet();
    if (_isOffline(nextConnectivity)) {
      _lastConnectivity = nextConnectivity;
      _connectedAt = null;
      return NetworkState.offline;
    }

    final wasOffline = _isOffline(_lastConnectivity);
    if (wasOffline) {
      _connectedAt = DateTime.now();
    }
    _lastConnectivity = nextConnectivity;

    final latencyMs = await _probeLatencyMs();
    if (latencyMs == null) {
      // Connected to Wi-Fi/mobile but internet path is weak/unreachable.
      return NetworkState.unstable;
    }

    final now = DateTime.now();
    final isFreshConnection =
        _connectedAt != null &&
        now.difference(_connectedAt!) < _freshConnectionWindow;
    if (isFreshConnection || latencyMs > _stableLatencyThresholdMs) {
      return NetworkState.unstable;
    }
    return NetworkState.stable;
  }

  bool _isOffline(Set<ConnectivityResult> results) {
    return results.isEmpty || results.contains(ConnectivityResult.none);
  }

  Future<int?> _probeLatencyMs() async {
    final hosts = <String>['one.one.one.one', 'dns.google'];
    for (final host in hosts) {
      final latency = await _probeHostLatency(host);
      if (latency != null) {
        return latency;
      }
    }
    return null;
  }

  Future<int?> _probeHostLatency(String host) async {
    final stopwatch = Stopwatch()..start();
    try {
      final socket = await Socket.connect(host, 53).timeout(_probeTimeout);
      stopwatch.stop();
      await socket.close();
      return stopwatch.elapsedMilliseconds;
    } on SocketException {
      // Treat socket failure as no internet path to this probe host.
    } on TimeoutException {
      // Treat timeout as poor/unavailable internet for this probe host.
    } finally {
      if (stopwatch.isRunning) {
        stopwatch.stop();
      }
    }
    return null;
  }
}
