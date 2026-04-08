import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/usecases/usecase.dart';
import '/features/upload_manager/domain/repositories/camera_repository.dart';
import '/features/upload_manager/domain/usecases/camera/capture_photo.dart';
import '/features/upload_manager/domain/usecases/camera/delete_capture_files.dart';
import '/features/upload_manager/domain/usecases/camera/focus_at_point.dart';
import '/features/upload_manager/domain/usecases/camera/get_zoom_bounds.dart';
import '/features/upload_manager/domain/usecases/camera/initialize_camera.dart';
import '/features/upload_manager/domain/usecases/camera/pause_camera_preview.dart';
import '/features/upload_manager/domain/usecases/camera/resume_camera_preview.dart';
import '/features/upload_manager/domain/usecases/camera/set_zoom_level.dart';
import '/features/upload_manager/domain/usecases/camera/switch_camera.dart';
import '/features/upload_manager/domain/usecases/camera/toggle_flash.dart';
import 'camera_preview_state.dart';

class CameraPreviewCubit extends Cubit<CameraPreviewState> {
  CameraPreviewCubit({
    required InitializeCamera initializeCamera,
    required CapturePhoto capturePhoto,
    required SetZoomLevel setZoomLevel,
    required FocusAtPoint focusAtPoint,
    required SwitchCamera switchCamera,
    required GetZoomBounds getZoomBounds,
    required ToggleFlash toggleFlash,
    required PauseCameraPreview pauseCameraPreview,
    required ResumeCameraPreview resumeCameraPreview,
    required DeleteCaptureFiles deleteCaptureFiles,
  }) : _initializeCamera = initializeCamera,
       _capturePhoto = capturePhoto,
       _deleteCaptureFiles = deleteCaptureFiles,
       _setZoomLevel = setZoomLevel,
       _focusAtPoint = focusAtPoint,
       _switchCamera = switchCamera,
       _getZoomBounds = getZoomBounds,
       _toggleFlash = toggleFlash,
       _pauseCameraPreview = pauseCameraPreview,
       _resumeCameraPreview = resumeCameraPreview,
       super(const CameraPreviewState());

  final InitializeCamera _initializeCamera;
  final CapturePhoto _capturePhoto;
  final DeleteCaptureFiles _deleteCaptureFiles;
  final SetZoomLevel _setZoomLevel;
  final FocusAtPoint _focusAtPoint;
  final SwitchCamera _switchCamera;
  final GetZoomBounds _getZoomBounds;
  final ToggleFlash _toggleFlash;
  final PauseCameraPreview _pauseCameraPreview;
  final ResumeCameraPreview _resumeCameraPreview;

  Future<void> initialize() async {
    final result = await _initializeCamera(NoParams());
    await result.fold(
      (_) async {
        emit(state.copyWith(message: 'Failed to initialize camera'));
      },
      (_) async {
        final boundsResult = await _getZoomBounds(NoParams());
        boundsResult.fold(
          (_) => emit(state.copyWith(isReady: true, message: null)),
          (bounds) => emit(
            state.copyWith(
              isReady: true,
              zoomLevel: state.zoomLevel.clamp(bounds.minZoom, bounds.maxZoom),
              minZoom: bounds.minZoom,
              maxZoom: bounds.maxZoom,
              message: null,
            ),
          ),
        );
      },
    );
  }

  Future<void> capture() async {
    emit(state.copyWith(isCapturing: true, message: null));
    final result = await _capturePhoto(NoParams());
    result.fold(
      (_) =>
          emit(state.copyWith(isCapturing: false, message: 'Capture failed')),
      (capture) => emit(
        state.copyWith(
          isCapturing: false,
          captures: [...state.captures, capture],
        ),
      ),
    );
  }

  Future<void> changeZoom(double value) async {
    final result = await _setZoomLevel(value);
    result.fold(
      (_) => emit(state.copyWith(message: 'Zoom update failed')),
      (zoom) => emit(state.copyWith(zoomLevel: zoom)),
    );
  }

  Future<void> updateFocus(FocusPoint point) async {
    final result = await _focusAtPoint(point);
    result.fold(
      (_) => emit(state.copyWith(message: 'Focus update failed')),
      (focusPoint) => emit(state.copyWith(focusPoint: focusPoint)),
    );
  }

  Future<void> toggleCamera() async {
    final result = await _switchCamera(NoParams());
    await result.fold(
      (_) async {
        emit(state.copyWith(message: 'Camera switch failed'));
      },
      (cameraLens) async {
        final boundsResult = await _getZoomBounds(NoParams());
        boundsResult.fold(
          (_) =>
              emit(state.copyWith(cameraLens: cameraLens, flashEnabled: false)),
          (bounds) => emit(
            state.copyWith(
              cameraLens: cameraLens,
              minZoom: bounds.minZoom,
              maxZoom: bounds.maxZoom,
              zoomLevel: state.zoomLevel.clamp(bounds.minZoom, bounds.maxZoom),
              flashEnabled: false,
            ),
          ),
        );
      },
    );
  }

  Future<void> toggleFlash() async {
    final result = await _toggleFlash(NoParams());
    result.fold(
      (_) => emit(state.copyWith(message: 'Flash mode update failed')),
      (enabled) => emit(state.copyWith(flashEnabled: enabled)),
    );
  }

  Future<void> openGalleryPreview() async {
    if (state.captures.isEmpty) {
      return;
    }
    await _pauseCameraPreview(NoParams());
    emit(
      state.copyWith(
        isGalleryPreviewVisible: true,
        galleryIndex: state.galleryIndex.clamp(0, state.captures.length - 1),
      ),
    );
  }

  Future<void> closeGalleryPreview() async {
    await _resumeCameraPreview(NoParams());
    emit(state.copyWith(isGalleryPreviewVisible: false));
  }

  void updateGalleryIndex(int index) {
    emit(state.copyWith(galleryIndex: index));
  }

  Future<void> deleteSelectedCapture() async {
    if (state.captures.isEmpty) {
      return;
    }
    final index = state.galleryIndex.clamp(0, state.captures.length - 1);
    final selected = state.captures[index];
    await _deleteCaptureFiles(
      DeleteCaptureFilesParams(
        localPath: selected.localPath,
        thumbnailPath: selected.thumbnailPath,
      ),
    );

    final nextCaptures = [...state.captures]..removeAt(index);
    final nextIndex = nextCaptures.isEmpty
        ? 0
        : (index.clamp(0, nextCaptures.length - 1));

    if (nextCaptures.isEmpty) {
      await _resumeCameraPreview(NoParams());
      emit(
        state.copyWith(
          captures: nextCaptures,
          galleryIndex: nextIndex,
          isGalleryPreviewVisible: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        captures: nextCaptures,
        galleryIndex: nextIndex,
      ),
    );
  }
}
