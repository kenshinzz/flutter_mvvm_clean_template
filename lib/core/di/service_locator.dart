import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mvvm_clean_template/core/network/api_client.dart';
import 'package:mvvm_clean_template/core/network/network_info.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies using GetIt
/// This is useful for services, repositories, and use cases that don't need to be reactive
Future<void> initializeDependencies() async {
  // External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  // HTTP Client
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // Core
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<Connectivity>()),
  );

  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(client: getIt<http.Client>()),
  );

  // Data Sources
  // Register your remote data sources here
  // Example:
  // getIt.registerLazySingleton<UserRemoteDataSource>(
  //   () => UserRemoteDataSourceImpl(getIt<ApiClient>()),
  // );

  // Register your local data sources here
  // Example:
  // getIt.registerLazySingleton<UserLocalDataSource>(
  //   () => UserLocalDataSourceImpl(getIt<SharedPreferences>()),
  // );

  // Repositories
  // Register your repositories here
  // Example:
  // getIt.registerLazySingleton<UserRepository>(
  //   () => UserRepositoryImpl(
  //     remoteDataSource: getIt<UserRemoteDataSource>(),
  //     localDataSource: getIt<UserLocalDataSource>(),
  //     networkInfo: getIt<NetworkInfo>(),
  //   ),
  // );

  // Use Cases
  // Register your use cases here
  // Example:
  // getIt.registerLazySingleton(() => GetUserUseCase(getIt<UserRepository>()));
  // getIt.registerLazySingleton(() => UpdateUserUseCase(getIt<UserRepository>()));

  // ViewModels will be registered with Provider in providers.dart
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
