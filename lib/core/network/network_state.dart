enum NetworkState { stable, unstable, offline }

extension NetworkStateX on NetworkState {
  bool get canUpload => this != NetworkState.offline;

  String get label {
    switch (this) {
      case NetworkState.stable:
        return 'Stable';
      case NetworkState.unstable:
        return 'Unstable';
      case NetworkState.offline:
        return 'Offline';
    }
  }
}
