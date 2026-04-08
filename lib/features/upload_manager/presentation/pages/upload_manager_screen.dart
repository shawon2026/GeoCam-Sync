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
import '/features/upload_manager/domain/entities/sync_status.dart';
import '/features/upload_manager/presentation/cubit/sync_engine/sync_engine_cubit.dart';
import '/features/upload_manager/presentation/cubit/sync_engine/sync_engine_state.dart';
import '/features/upload_manager/presentation/cubit/upload_manager/upload_manager_cubit.dart';
import '/features/upload_manager/presentation/cubit/upload_manager/upload_manager_state.dart';
import '/features/upload_manager/presentation/pages/upload_manager_page.dart';
import '/features/upload_manager/presentation/widgets/dialogs/camera_permission_dialog.dart';

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
      _recheckCameraPermission();
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
      child: MultiBlocListener(
        listeners: [
          BlocListener<UploadManagerCubit, UploadManagerState>(
            listener: (context, state) {
              if (state.message != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message!)));
              }
            },
          ),
          BlocListener<SyncEngineCubit, SyncEngineState>(
            listener: (context, state) {
              if (state.message.isNotEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: const Color(0xFFF3F5F9),
          appBar: GlobalAppBar(
            title: context.loc.uploadManagerTitle,
            showLanguageSwitcher: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: BlocBuilder<SyncEngineCubit, SyncEngineState>(
                  builder: (context, syncState) {
                    return Center(
                      child: _SyncAppBarStatus(
                        networkState: syncState.networkState,
                        phase: syncState.phase,
                      ),
                    );
                  },
                ),
              ),
            ],
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
                          ? _uploadManagerCubit.resumeAll
                          : _uploadManagerCubit.pauseAll,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _startNewBatchFlow() async {
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
      _openCamera();
      return;
    }
    _showCameraPermissionDialog();
  }

  void _showCameraPermissionDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return CameraPermissionDialog(
          onGivePermission: () async {
            Navigator.of(context).pop();
            _waitingForCameraSettings = true;
            await _cameraPermissionService.openSettings();
          },
        );
      },
    );
  }

  void _openCamera() {
    Navigation.push(context, appRoutes: AppRoutes.cameraPreview);
  }
}

class _SyncAppBarStatus extends StatelessWidget {
  const _SyncAppBarStatus({required this.networkState, required this.phase});

  final NetworkState networkState;
  final SyncPhase phase;

  @override
  Widget build(BuildContext context) {
    final color = switch (networkState) {
      NetworkState.stable => const Color(0xFF16A34A),
      NetworkState.unstable => const Color(0xFFF59E0B),
      NetworkState.offline => const Color(0xFFDC2626),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 6),
          Text(
            '${networkState.label} ${phase.name}',
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
