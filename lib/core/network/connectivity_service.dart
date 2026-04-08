import 'dart:async';

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

  @override
  Future<NetworkState> getCurrentState() async {
    final result = await _connectivity.checkConnectivity();
    return _mapResult(result);
  }

  @override
  Stream<NetworkState> watchNetworkState() {
    return _connectivity.onConnectivityChanged.map(_mapResult);
  }

  NetworkState _mapResult(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return NetworkState.offline;
    }
    if (results.contains(ConnectivityResult.mobile)) {
      return NetworkState.unstable;
    }
    return NetworkState.stable;
  }
}
