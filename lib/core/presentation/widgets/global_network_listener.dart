 import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '/core/di/service_locator.dart';
import '/core/network/network_info.dart';
import '../../routes/navigation.dart';
import '../../utils/extension.dart';
import '../view_util.dart';
import 'global_text.dart';

class GlobalNetworkListener extends StatefulWidget {
  final Widget child;

  const GlobalNetworkListener({super.key, required this.child});

  @override
  State<GlobalNetworkListener> createState() => _GlobalNetworkListenerState();
}

class _GlobalNetworkListenerState extends State<GlobalNetworkListener> {
  bool _wasConnected = true;
  bool _isShowingDialog = false;
  // Track all active dialog contexts to ensure proper dismissal
  final List<BuildContext> _activeDialogContexts = [];

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
  }

  @override
  void dispose() {
    // Ensure all dialogs are dismissed when widget is disposed
    _dismissAllNetworkDialogs();
    super.dispose();
  }

  Future<void> _checkInitialConnectivity() async {
    final networkInfo = sl<NetworkInfo>();
    _wasConnected = await networkInfo.internetAvailable();

    // Show dialog immediately if no internet on app start
    if (!_wasConnected) {
      _showNetworkErrorDialog();
    }

    if (Platform.isAndroid) {
      // Listen for connectivity changes
      networkInfo.onConnectivityChanged.listen(_handleConnectivityChange);
    }
  }

  void _handleConnectivityChange(List<ConnectivityResult> connectivityResult) {
    final isConnected = connectivityResult.isNotEmpty &&
        connectivityResult.any((element) => element != ConnectivityResult.none);

    'isNetworkAvailable ::$isConnected'.log();

    // If network was connected but now disconnected
    if (_wasConnected && !isConnected) {
      _showNetworkErrorDialog();
    }
    // If network was disconnected but now connected
    else if (!_wasConnected && isConnected) {
      _dismissAllNetworkDialogs();
    }

    _wasConnected = isConnected;
  }

  void _showNetworkErrorDialog() {
    if (_isShowingDialog || !mounted) return;

    _isShowingDialog = true;

    // Show dialog on next frame to avoid build conflicts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Create a dialog context
      final BuildContext dialogContext = Navigation.key.currentContext!;

      ViewUtil.alertDialog(
        barrierDismissible: false,
        content: PopScope(
          canPop: false,
          onPopInvokedWithResult:
              (didpop, result) {}, // Prevent back button from closing dialog
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const GlobalText(str: 'No Internet Connection'),
              const SizedBox(height: 8),
              const GlobalText(str: 'Please check your network and retry.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final networkInfo = sl<NetworkInfo>();
                  final isConnected = await networkInfo.internetAvailable();
                  if (isConnected) {
                    _dismissAllNetworkDialogs();
                  }
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ).then((_) {
        // Remove this dialog context when it's closed
        _activeDialogContexts.remove(dialogContext);
        if (_activeDialogContexts.isEmpty) {
          _isShowingDialog = false;
        }
      });

      // Add this dialog context to our tracking list
      _activeDialogContexts.add(dialogContext);
    });
  }

  void _dismissAllNetworkDialogs() {
    if (!_isShowingDialog || !mounted) return;

    // Pop all dialogs by repeatedly calling Navigator.pop until no more dialogs
    final navigatorState = Navigation.key.currentState;
    if (navigatorState != null) {
      while (_isShowingDialog && navigatorState.canPop()) {
        navigatorState.pop();
      }
    }

    // Clear the tracking list
    _activeDialogContexts.clear();
    _isShowingDialog = false;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

 
