import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../features/home/domain/usecases/get_home.dart';
import '/core/network/api_client.dart';
import '/core/network/network_info.dart';
import '/core/utils/preferences_helper.dart';
import '/features/home/data/datasources/home_remote_datasource.dart';
import '/features/home/data/datasources/home_local_datasource.dart';
import '/features/home/data/repositories/home_repository_impl.dart';
import '/features/home/domain/repositories/home_repository.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );
  sl.registerLazySingleton<PrefHelper>(() => PrefHelper.instance);
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
}

