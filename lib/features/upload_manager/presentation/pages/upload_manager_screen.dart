import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '/core/network/network_state.dart';
import '/core/di/service_locator.dart';
import '/core/presentation/widgets/global_appbar.dart';
import '/core/routes/app_routes.dart';
import '/core/routes/navigation.dart';
import '/core/services/camera_permission_service.dart';
import '/core/utils/extension.dart';
import '/features/upload_manager/presentation/cubit/sync_engine/sync_engine_cubit.dart';
import '/features/upload_manager/presentation/cubit/sync_engine/sync_engine_state.dart';
import '/features/upload_manager/presentation/cubit/upload_manager/upload_manager_cubit.dart';
import '/features/upload_manager/presentation/cubit/upload_manager/upload_manager_state.dart';
import '/features/upload_manager/presentation/pages/upload_manager_page.dart';
import '/features/upload_manager/presentation/widgets/dialogs/camera_permission_dialog.dart';
import '/features/upload_manager/presentation/widgets/upload_manager/upload_manager_loading_view.dart';

class UploadManagerScreen extends StatefulWidget {
  const UploadManagerScreen({super.key});

  @override
  State<UploadManagerScreen> createState() => _UploadManagerScreenState();
}

class _UploadManagerScreenState extends State<UploadManagerScreen>
    with WidgetsBindingObserver {
  late final UploadManagerCubit _uploadManagerCubit;
  late final SyncEngineCubit _syncEngineCubit;
  bool _waitingForCameraSettings = false;
  bool _cameraDialogVisible = false;
  bool _openingCamera = false;
  BuildContext? _cameraDialogContext;

  CameraPermissionService get _cameraPermissionService =>
      sl<CameraPermissionService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _uploadManagerCubit = sl<UploadManagerCubit>()..initialize();
    _syncEngineCubit = sl<SyncEngineCubit>()
      ..initialize()
      ..processQueue();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _waitingForCameraSettings) {
      Future<void>.delayed(
        const Duration(milliseconds: 250),
        _recheckCameraPermission,
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _uploadManagerCubit.close();
    _syncEngineCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _uploadManagerCubit),
        BlocProvider.value(value: _syncEngineCubit),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F5F9),
        appBar: GlobalAppBar(
          title: context.loc.uploadManagerTitle,
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 6, 16, 16),
          child: BlocBuilder<SyncEngineCubit, SyncEngineState>(
            builder: (context, syncState) {
              return BlocBuilder<UploadManagerCubit, UploadManagerState>(
                builder: (context, uploadState) {
                  return FilledButton(
                    onPressed: _startNewBatchFlow,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF3E73F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    child: Text(
                      context.loc.startNewUploadBatch.toUpperCase(),
                    ),
                  );
                },
              );
            },
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<UploadManagerCubit, UploadManagerState>(
            builder: (context, uploadState) {
              if (uploadState.isLoading) {
                return const UploadManagerLoadingView();
              }
              return BlocBuilder<SyncEngineCubit, SyncEngineState>(
                builder: (context, syncState) {
                  return UploadManagerPage(
                    networkLabel: syncState.networkState.label,
                    phase: syncState.phase,
                    summary: uploadState.summary,
                    items: uploadState.items,
                    isPaused: uploadState.isPaused,
                    uploadSpeedMbps: syncState.uploadSpeedMbps,
                    onPauseResume: uploadState.isPaused
                        ? () => unawaited(_resumeAndProcessQueue())
                        : () => unawaited(_uploadManagerCubit.pauseAll()),
                    onClearSyncedItems: _uploadManagerCubit.clearSyncedItems,
                    onClearAllSyncedItems: _uploadManagerCubit.clearAllSyncedItems,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _startNewBatchFlow() async {
    if (_openingCamera) {
      return;
    }
    if (await _cameraPermissionService.isGranted()) {
      _openCamera();
      return;
    }

    final firstTry = await _cameraPermissionService.request();
    if (!mounted) {
      return;
    }
    if (firstTry.isGranted) {
      _openCamera();
      return;
    }

    final secondTry = await _cameraPermissionService.request();
    if (!mounted) {
      return;
    }
    if (secondTry.isGranted) {
      _openCamera();
      return;
    }

    _showCameraPermissionDialog();
  }

  Future<void> _recheckCameraPermission() async {
    final granted = await _cameraPermissionService.isGranted();
    if (!mounted) {
      return;
    }
    if (granted) {
      _waitingForCameraSettings = false;
      if (_cameraDialogContext?.mounted ?? false) {
        Navigator.of(_cameraDialogContext!).pop();
      }
      _cameraDialogContext = null;
      _cameraDialogVisible = false;
      _openCamera();
      return;
    }
    _showCameraPermissionDialog();
  }

  void _showCameraPermissionDialog() {
    if (_cameraDialogVisible || !mounted) {
      return;
    }
    _cameraDialogVisible = true;
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        _cameraDialogContext = dialogContext;
        return CameraPermissionDialog(
          onGivePermission: () async {
            if (_cameraDialogContext?.mounted ?? false) {
              Navigator.of(_cameraDialogContext!).pop();
            }
            _waitingForCameraSettings = true;
            await _cameraPermissionService.openSettings();
          },
        );
      },
    ).then((_) {
      _cameraDialogContext = null;
      _cameraDialogVisible = false;
    });
  }

  Future<void> _openCamera() async {
    if (!mounted || _openingCamera) {
      return;
    }
    _openingCamera = true;
    await Navigation.push(context, appRoutes: AppRoutes.cameraPreview);
    _openingCamera = false;
  }

  Future<void> _resumeAndProcessQueue() async {
    await _uploadManagerCubit.resumeAll();
    await _syncEngineCubit.processQueue();
  }
}
