import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '/core/di/service_locator.dart';
import '../../utils/extension.dart';

class GlobalNetworkListener extends StatefulWidget {
  final Widget child;

  const GlobalNetworkListener({super.key, required this.child});

  @override
  State<GlobalNetworkListener> createState() => _GlobalNetworkListenerState();
}

class _GlobalNetworkListenerState extends State<GlobalNetworkListener> {
  Stream<List<ConnectivityResult>> get _connectivityStream =>
      sl<Connectivity>().onConnectivityChanged;

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    if (Platform.isAndroid) {
      _connectivityStream.listen(_handleConnectivityChange);
    }
  }

  void _handleConnectivityChange(List<ConnectivityResult> connectivityResult) {
    final isConnected =
        connectivityResult.isNotEmpty &&
        connectivityResult.any((element) => element != ConnectivityResult.none);

    'isNetworkAvailable ::$isConnected'.log();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
