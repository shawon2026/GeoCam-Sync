import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/di/service_locator.dart';
import '/core/presentation/widgets/global_appbar.dart';
import '/core/usecases/usecase.dart';
import '/core/utils/extension.dart';
import '/features/upload_manager/data/datasources/camera_datasource.dart';
import '/features/upload_manager/domain/repositories/camera_repository.dart';
import '/features/upload_manager/domain/usecases/sync/process_upload_queue.dart';
import '/features/upload_manager/domain/usecases/upload/add_files_to_queue.dart';
import '/features/upload_manager/domain/usecases/upload/create_upload_batch.dart';
import '/features/upload_manager/presentation/cubit/camera_preview/camera_preview_cubit.dart';
import '/features/upload_manager/presentation/cubit/camera_preview/camera_preview_state.dart';
import '/features/upload_manager/presentation/widgets/camera/camera_preview_view.dart';
import '/features/upload_manager/presentation/widgets/camera/capture_button.dart';
import '/features/upload_manager/presentation/widgets/camera/focus_indicator.dart';
import '/features/upload_manager/presentation/widgets/camera/gallery_count_preview.dart';
import '/features/upload_manager/presentation/widgets/camera/upload_batch_button.dart';
import '/features/upload_manager/presentation/widgets/camera/zoom_preset_buttons.dart';
import '/features/upload_manager/presentation/widgets/camera/zoom_slider.dart';

class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({super.key});

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  late final CameraPreviewCubit _cameraPreviewCubit;

  @override
  void initState() {
    super.initState();
    _cameraPreviewCubit = sl<CameraPreviewCubit>()..initialize();
  }

  @override
  void dispose() {
    _cameraPreviewCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cameraPreviewCubit,
      child: BlocConsumer<CameraPreviewCubit, CameraPreviewState>(
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF3F5F9),
            appBar: GlobalAppBar(title: context.loc.cameraPreviewTitle),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CameraPreviewView(
                  cameraLens: state.cameraLens,
                  controller: sl<CameraDataSource>().controller,
                  onTapUp: (details) {
                    final renderBox = context.findRenderObject() as RenderBox?;
                    if (renderBox == null) {
                      return;
                    }
                    final localPosition = renderBox.globalToLocal(
                      details.globalPosition,
                    );
                    final width = renderBox.size.width == 0
                        ? 1.0
                        : renderBox.size.width;
                    final height = renderBox.size.height == 0
                        ? 1.0
                        : renderBox.size.height;
                    _cameraPreviewCubit.updateFocus(
                      FocusPoint(
                        x: (localPosition.dx / width).clamp(0, 1),
                        y: (localPosition.dy / height).clamp(0, 1),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                FocusIndicator(focusPoint: state.focusPoint),
                const SizedBox(height: 12),
                ZoomSlider(
                  value: state.zoomLevel,
                  onChanged: _cameraPreviewCubit.changeZoom,
                ),
                const SizedBox(height: 12),
                ZoomPresetButtons(onSelect: _cameraPreviewCubit.changeZoom),
                const SizedBox(height: 12),
                GalleryCountPreview(count: state.captures.length),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CaptureButton(
                        isCapturing: state.isCapturing,
                        onPressed: _cameraPreviewCubit.capture,
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filled(
                      onPressed: _cameraPreviewCubit.toggleCamera,
                      icon: const Icon(Icons.cameraswitch_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                UploadBatchButton(
                  enabled: state.captures.isNotEmpty,
                  onPressed: () => _enqueueBatch(context, state),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _enqueueBatch(
    BuildContext context,
    CameraPreviewState state,
  ) async {
    if (state.captures.isEmpty) {
      return;
    }
    final batchResult = await sl<CreateUploadBatch>()(NoParams());
    final batch = batchResult.fold((_) => null, (value) => value);
    if (batch == null) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to create an upload batch')),
      );
      return;
    }
    final useCase = sl<AddFilesToQueue>();
    final result = await useCase(
      AddFilesToQueueParams(batchId: batch.id, captures: state.captures),
    );
    if (!context.mounted) {
      return;
    }
    if (result.isLeft()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to queue the captured photos')),
      );
      return;
    }
    await sl<ProcessUploadQueue>()(NoParams());
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${state.captures.length} files added to queue')),
    );
    Navigator.of(context).pop();
  }
}
