import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import '../../features/home/domain/usecases/get_home.dart';
import '/core/services/app_settings_service.dart';
import '/db/app_database.dart';
import '/core/network/api_client.dart';
import '/core/network/network_info.dart';
import '/core/utils/preferences_helper.dart';
import '/features/attendance/data/datasources/attendance_local_datasource.dart';
import '/features/attendance/data/datasources/location_datasource.dart';
import '/features/attendance/data/repositories/attendance_repository_impl.dart';
import '/features/attendance/domain/repositories/attendance_repository.dart';
import '/features/attendance/domain/usecases/check_attendance_eligibility.dart';
import '/features/attendance/domain/usecases/ensure_location_permission.dart';
import '/features/attendance/domain/usecases/ensure_location_service.dart';
import '/features/attendance/domain/usecases/get_office_location.dart';
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
import '/features/home/data/datasources/home_remote_datasource.dart';
import '/features/home/data/datasources/home_local_datasource.dart';
import '/features/home/data/repositories/home_repository_impl.dart';
import '/features/home/domain/repositories/home_repository.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<Location>(() => Location());
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );
  sl.registerLazySingleton<PrefHelper>(() => PrefHelper.instance);
  sl.registerLazySingleton<AppSettingsService>(
    () => const AppSettingsService(),
  );
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(dio: sl(), prefHelper: sl()),
  );

  // Home Feature
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetHome(sl()));

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
}
