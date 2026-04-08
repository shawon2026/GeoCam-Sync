import '/core/network/connectivity_service.dart';
import '/core/network/network_state.dart';

abstract class NetworkMonitorDataSource {
  Stream<NetworkState> watchNetworkState();

  Future<NetworkState> getCurrentState();
}

class NetworkMonitorDataSourceImpl implements NetworkMonitorDataSource {
  NetworkMonitorDataSourceImpl({
    required ConnectivityService connectivityService,
  }) : _connectivityService = connectivityService;

  final ConnectivityService _connectivityService;

  @override
  Future<NetworkState> getCurrentState() {
    return _connectivityService.getCurrentState();
  }

  @override
  Stream<NetworkState> watchNetworkState() {
    return _connectivityService.watchNetworkState();
  }
}
