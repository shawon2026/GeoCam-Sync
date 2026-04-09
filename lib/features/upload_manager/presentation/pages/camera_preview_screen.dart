import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/core/presentation/widgets/global_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '/core/di/service_locator.dart';
import '/core/usecases/usecase.dart';
import '/features/upload_manager/data/datasources/camera_datasource.dart';
import '/features/upload_manager/domain/entities/camera_capture.dart';
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
  late final PageController _galleryPageController;
  double _baseZoomOnScaleStart = 1;

  @override
  void initState() {
    super.initState();
    _cameraPreviewCubit = sl<CameraPreviewCubit>()..initialize();
    _galleryPageController = PageController();
  }

  @override
  void dispose() {
    _galleryPageController.dispose();
    _cameraPreviewCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cameraPreviewCubit,
      child: BlocConsumer<CameraPreviewCubit, CameraPreviewState>(
        listener: (context, state) {
          if (state.isGalleryPreviewVisible && state.captures.isNotEmpty) {
            final safeIndex = state.galleryIndex.clamp(
              0,
              state.captures.length - 1,
            );
            if (_galleryPageController.hasClients &&
                _galleryPageController.page?.round() != safeIndex) {
              _galleryPageController.animateToPage(
                safeIndex,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
              );
            }
          }
          if (state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: GlobalText.raw(state.message!)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFF0F172A),
            body: Stack(
              children: [
                Positioned.fill(
                  child: CameraPreviewView(
                    controller: sl<CameraDataSource>().controller,
                    onTapPoint: _cameraPreviewCubit.updateFocus,
                    onScaleStart: (_) {
                      _baseZoomOnScaleStart = state.zoomLevel;
                    },
                    onScaleUpdate: (details) {
                      final nextZoom = _baseZoomOnScaleStart * details.scale;
                      _cameraPreviewCubit.changeZoom(nextZoom);
                    },
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.28),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.40),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: FocusIndicator(focusPoint: state.focusPoint),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 14.h),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _CircleActionButton(
                              icon: Icons.close_rounded,
                              onTap: () => Navigator.of(context).pop(),
                            ),
                            const Spacer(),
                            _CircleActionButton(
                              icon: state.flashEnabled
                                  ? Icons.flash_on_rounded
                                  : Icons.flash_off_rounded,
                              onTap: _cameraPreviewCubit.toggleFlash,
                              transparent: true,
                            ),
                            SizedBox(width: 10.w),
                            _CircleActionButton(
                              icon: Icons.settings_outlined,
                              onTap: () => openAppSettings(),
                              transparent: true,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ZoomSlider(
                            value: state.zoomLevel,
                            min: state.minZoom,
                            max: state.maxZoom,
                            onChanged: _cameraPreviewCubit.changeZoom,
                          ),
                        ),
                        SizedBox(height: 18.h),
                        ZoomPresetButtons(
                          selectedZoom: state.zoomLevel,
                          onSelect: _cameraPreviewCubit.changeZoom,
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GalleryCountPreview(
                              count: state.captures.length,
                              onTap: _cameraPreviewCubit.openGalleryPreview,
                            ),
                            CaptureButton(
                              isCapturing: state.isCapturing,
                              onPressed: _cameraPreviewCubit.capture,
                            ),
                            _CircleActionButton(
                              icon: Icons.cameraswitch_rounded,
                              onTap: _cameraPreviewCubit.toggleCamera,
                              large: true,
                              transparent: true,
                            ),
                          ],
                        ),
                        SizedBox(height: 18.h),
                        UploadBatchButton(
                          enabled: state.captures.isNotEmpty,
                          count: state.captures.length,
                          onPressed: () => _enqueueBatch(context, state),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.isGalleryPreviewVisible && state.captures.isNotEmpty)
                  Positioned.fill(
                    child: _GalleryOverlay(
                      captures: state.captures,
                      currentIndex: state.galleryIndex,
                      pageController: _galleryPageController,
                      onIndexChanged: _cameraPreviewCubit.updateGalleryIndex,
                      onClose: _cameraPreviewCubit.closeGalleryPreview,
                      onDelete: _cameraPreviewCubit.deleteSelectedCapture,
                    ),
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
    try {
      final batchResult = await sl<CreateUploadBatch>()(NoParams());
      final batch = batchResult.fold((_) => null, (value) => value);
      if (batch == null) {
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: GlobalText.raw('Unable to create an upload batch'),
          ),
        );
        return;
      }

      final queueResult = await sl<AddFilesToQueue>()(
        AddFilesToQueueParams(batchId: batch.id, captures: state.captures),
      );
      if (queueResult.isLeft()) {
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: GlobalText.raw('Unable to queue the captured photos'),
          ),
        );
        return;
      }

      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop();
      unawaited(sl<ProcessUploadQueue>()(NoParams()));
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: GlobalText.raw('Upload batch failed: $e')),
      );
    }
  }
}

class _GalleryOverlay extends StatelessWidget {
  const _GalleryOverlay({
    required this.captures,
    required this.currentIndex,
    required this.pageController,
    required this.onIndexChanged,
    required this.onClose,
    required this.onDelete,
  });

  final List<CameraCapture> captures;
  final int currentIndex;
  final PageController pageController;
  final ValueChanged<int> onIndexChanged;
  final VoidCallback onClose;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.84)),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                  ),
                  onPressed: onDelete,
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: onClose,
                ),
              ],
            ),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: captures.length,
                onPageChanged: onIndexChanged,
                itemBuilder: (context, index) {
                  final capture = captures[index];
                  return Center(
                    child: InteractiveViewer(
                      minScale: 1,
                      maxScale: 3,
                      child: Image.file(
                        File(capture.localPath),
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            const ColoredBox(
                              color: Color(0xFF1F2937),
                              child: Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8.h),
            GlobalText.raw(
              '${currentIndex + 1}/${captures.length}',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 14.h),
          ],
        ),
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  const _CircleActionButton({
    required this.icon,
    required this.onTap,
    this.large = false,
    this.transparent = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool large;
  final bool transparent;

  @override
  Widget build(BuildContext context) {
    final size = large ? 56.0 : 46.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: transparent
              ? Colors.black.withValues(alpha: 0.22)
              : Colors.black.withValues(alpha: 0.34),
        ),
        child: Icon(icon, color: Colors.white, size: large ? 28 : 24),
      ),
    );
  }
}
