import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '/core/di/service_locator.dart';
import '/core/network/network_info.dart';
import '../../utils/extension.dart';

class GlobalNetworkListener extends StatefulWidget {
  final Widget child;

  const GlobalNetworkListener({super.key, required this.child});

  @override
  State<GlobalNetworkListener> createState() => _GlobalNetworkListenerState();
}

class _GlobalNetworkListenerState extends State<GlobalNetworkListener> {
  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    final networkInfo = sl<NetworkInfo>();
    await networkInfo.internetAvailable();

    if (Platform.isAndroid) {
      // Listen for connectivity changes
      networkInfo.onConnectivityChanged.listen(_handleConnectivityChange);
    }
  }

  void _handleConnectivityChange(List<ConnectivityResult> connectivityResult) {
    final isConnected = connectivityResult.isNotEmpty &&
        connectivityResult.any((element) => element != ConnectivityResult.none);

    'isNetworkAvailable ::$isConnected'.log();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
