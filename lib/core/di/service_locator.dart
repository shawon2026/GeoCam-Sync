import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import '/core/services/app_settings_service.dart';
import '/core/services/camera_permission_service.dart';
import '/core/network/connectivity_service.dart';
import '/db/app_database.dart';
import '/core/services/background_worker_service.dart';
import '/core/services/thumbnail_service.dart';
import '/features/attendance/data/datasources/attendance_local_datasource.dart';
import '/features/attendance/data/datasources/location_datasource.dart';
import '/features/attendance/data/repositories/attendance_repository_impl.dart';
import '/features/attendance/domain/repositories/attendance_repository.dart';
import '/features/attendance/domain/usecases/check_attendance_eligibility.dart';
import '/features/attendance/domain/usecases/ensure_location_permission.dart';
import '/features/attendance/domain/usecases/ensure_location_service.dart';
import '/features/attendance/domain/usecases/get_office_location.dart';
import '/features/attendance/domain/usecases/get_distance_to_office.dart';
import '/features/attendance/domain/usecases/get_today_attendance.dart';
import '/features/attendance/domain/usecases/is_location_permission_granted.dart';
import '/features/attendance/domain/usecases/is_location_service_enabled.dart';
import '/features/attendance/domain/usecases/is_precise_location_permission_granted.dart';
import '/features/attendance/domain/usecases/mark_attendance.dart';
import '/features/attendance/domain/usecases/open_app_settings.dart';
import '/features/attendance/domain/usecases/open_location_settings.dart';
import '/features/attendance/domain/usecases/save_office_location.dart';
import '/features/attendance/domain/usecases/watch_attendance_history.dart';
import '/features/attendance/domain/usecases/watch_live_distance.dart';
import '/features/attendance/presentation/cubit/attendance_cubit.dart';
import '/features/upload_manager/data/datasources/camera_datasource.dart';
import '/features/upload_manager/data/datasources/local_upload_datasource.dart';
import '/features/upload_manager/data/datasources/network_monitor_datasource.dart';
import '/features/upload_manager/data/datasources/remote_upload_datasource.dart';
import '/features/upload_manager/data/repositories/camera_repository_impl.dart';
import '/features/upload_manager/data/repositories/sync_repository_impl.dart';
import '/features/upload_manager/data/repositories/upload_repository_impl.dart';
import '/features/upload_manager/domain/repositories/camera_repository.dart';
import '/features/upload_manager/domain/repositories/sync_repository.dart';
import '/features/upload_manager/domain/repositories/upload_repository.dart';
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
import '/features/upload_manager/domain/usecases/sync/handle_network_recovery.dart';
import '/features/upload_manager/domain/usecases/sync/process_upload_queue.dart';
import '/features/upload_manager/domain/usecases/sync/retry_failed_uploads.dart';
import '/features/upload_manager/domain/usecases/sync/start_background_sync.dart';
import '/features/upload_manager/domain/usecases/sync/watch_sync_status.dart';
import '/features/upload_manager/domain/usecases/upload/add_files_to_queue.dart';
import '/features/upload_manager/domain/usecases/upload/create_upload_batch.dart';
import '/features/upload_manager/domain/usecases/upload/delete_synced_file_locally.dart';
import '/features/upload_manager/domain/usecases/upload/get_upload_summary.dart';
import '/features/upload_manager/domain/usecases/upload/pause_all_uploads.dart';
import '/features/upload_manager/domain/usecases/upload/resume_all_uploads.dart';
import '/features/upload_manager/domain/usecases/upload/watch_pending_uploads.dart';
import '/features/upload_manager/presentation/cubit/camera_preview/camera_preview_cubit.dart';
import '/features/upload_manager/presentation/cubit/sync_engine/sync_engine_cubit.dart';
import '/features/upload_manager/presentation/cubit/upload_manager/upload_manager_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  sl.registerLazySingleton<Location>(() => Location());
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // Core
  sl.registerLazySingleton<AppSettingsService>(
    () => const AppSettingsService(),
  );
  sl.registerLazySingleton<CameraPermissionService>(
    () => CameraPermissionService(appSettingsService: sl()),
  );
  sl.registerLazySingleton<ConnectivityService>(
    () => ConnectivityServiceImpl(connectivity: sl()),
  );
  sl.registerLazySingleton<BackgroundWorkerService>(
    () => const BackgroundWorkerService(),
  );
  sl.registerLazySingleton<ThumbnailService>(() => const ThumbnailService());

  // Attendance Feature
  sl.registerLazySingleton<AttendanceLocalDataSource>(
    () => AttendanceLocalDataSourceImpl(database: sl()),
  );
  sl.registerLazySingleton<LocationDataSource>(
    () => LocationDataSourceImpl(location: sl(), appSettingsService: sl()),
  );
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(
      localDataSource: sl(),
      locationDataSource: sl(),
    ),
  );

  sl.registerLazySingleton(() => EnsureLocationPermission(sl()));
  sl.registerLazySingleton(() => EnsureLocationService(sl()));
  sl.registerLazySingleton(() => IsLocationPermissionGranted(sl()));
  sl.registerLazySingleton(() => IsLocationServiceEnabled(sl()));
  sl.registerLazySingleton(() => IsPreciseLocationPermissionGranted(sl()));
  sl.registerLazySingleton(() => GetOfficeLocation(sl()));
  sl.registerLazySingleton(() => GetDistanceToOffice(sl()));
  sl.registerLazySingleton(() => SaveOfficeLocation(sl()));
  sl.registerLazySingleton(() => GetTodayAttendance(sl()));
  sl.registerLazySingleton(() => MarkAttendance(sl()));
  sl.registerLazySingleton(() => WatchLiveDistance(sl()));
  sl.registerLazySingleton(() => WatchAttendanceHistory(sl()));
  sl.registerLazySingleton(() => CheckAttendanceEligibility());
  sl.registerLazySingleton(() => OpenAppSettings(sl()));
  sl.registerLazySingleton(() => OpenLocationSettings(sl()));

  sl.registerFactory(
    () => AttendanceCubit(
      ensureLocationPermission: sl(),
      ensureLocationService: sl(),
      isLocationPermissionGranted: sl(),
      isLocationServiceEnabled: sl(),
      isPreciseLocationPermissionGranted: sl(),
      getOfficeLocation: sl(),
      getDistanceToOffice: sl(),
      saveOfficeLocation: sl(),
      getTodayAttendance: sl(),
      markAttendance: sl(),
      watchLiveDistance: sl(),
      watchAttendanceHistory: sl(),
      checkAttendanceEligibility: sl(),
      openAppSettings: sl(),
      openLocationSettings: sl(),
    ),
  );

  // Upload Manager Feature
  sl.registerLazySingleton<CameraDataSource>(
    () => CameraDataSourceImpl(thumbnailService: sl()),
  );
  sl.registerLazySingleton<LocalUploadDataSource>(
    () => LocalUploadDataSourceImpl(database: sl<AppDatabase>()),
  );
  sl.registerLazySingleton<RemoteUploadDataSource>(
    () => RemoteUploadDataSourceImpl(),
  );
  sl.registerLazySingleton<NetworkMonitorDataSource>(
    () => NetworkMonitorDataSourceImpl(connectivityService: sl()),
  );

  sl.registerLazySingleton<CameraRepository>(
    () => CameraRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<UploadRepository>(
    () => UploadRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<SyncRepository>(
    () => SyncRepositoryImpl(
      networkMonitorDataSource: sl(),
      localUploadDataSource: sl(),
      remoteUploadDataSource: sl(),
      backgroundWorkerService: sl(),
    ),
  );

  sl.registerLazySingleton(() => InitializeCamera(sl()));
  sl.registerLazySingleton(() => CapturePhoto(sl()));
  sl.registerLazySingleton(() => DeleteCaptureFiles(sl()));
  sl.registerLazySingleton(() => SetZoomLevel(sl()));
  sl.registerLazySingleton(() => FocusAtPoint(sl()));
  sl.registerLazySingleton(() => SwitchCamera(sl()));
  sl.registerLazySingleton(() => GetZoomBounds(sl()));
  sl.registerLazySingleton(() => ToggleFlash(sl()));
  sl.registerLazySingleton(() => PauseCameraPreview(sl()));
  sl.registerLazySingleton(() => ResumeCameraPreview(sl()));
  sl.registerLazySingleton(() => CreateUploadBatch(sl()));
  sl.registerLazySingleton(() => AddFilesToQueue(sl()));
  sl.registerLazySingleton(() => GetUploadSummary(sl()));
  sl.registerLazySingleton(() => PauseAllUploads(sl()));
  sl.registerLazySingleton(() => ResumeAllUploads(sl()));
  sl.registerLazySingleton(() => DeleteSyncedFileLocally(sl()));
  sl.registerLazySingleton(() => WatchPendingUploads(sl()));
  sl.registerLazySingleton(() => StartBackgroundSync(sl()));
  sl.registerLazySingleton(() => RetryFailedUploads(sl()));
  sl.registerLazySingleton(() => ProcessUploadQueue(sl()));
  sl.registerLazySingleton(() => WatchSyncStatus(sl()));
  sl.registerLazySingleton(() => HandleNetworkRecovery(sl()));

  sl.registerFactory(
    () => UploadManagerCubit(
      getUploadSummary: sl(),
      watchPendingUploads: sl(),
      pauseAllUploads: sl(),
      resumeAllUploads: sl(),
      deleteSyncedFileLocally: sl(),
    ),
  );
  sl.registerFactory(
    () => CameraPreviewCubit(
      initializeCamera: sl(),
      capturePhoto: sl(),
      setZoomLevel: sl(),
      focusAtPoint: sl(),
      switchCamera: sl(),
      getZoomBounds: sl(),
      toggleFlash: sl(),
      pauseCameraPreview: sl(),
      resumeCameraPreview: sl(),
      deleteCaptureFiles: sl(),
    ),
  );
  sl.registerFactory(
    () => SyncEngineCubit(
      startBackgroundSync: sl(),
      retryFailedUploads: sl(),
      processUploadQueue: sl(),
      watchSyncStatus: sl(),
      handleNetworkRecovery: sl(),
    ),
  );
}
