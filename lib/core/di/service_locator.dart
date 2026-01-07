import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mvvm_clean_template/core/network/api_client.dart';
import 'package:mvvm_clean_template/core/network/network_info.dart';
import 'package:mvvm_clean_template/core/storage/auth_storage.dart';
import 'package:mvvm_clean_template/core/storage/secure_storage.dart';
import 'package:mvvm_clean_template/data/datasources/user_local_datasource.dart';
import 'package:mvvm_clean_template/data/datasources/user_remote_datasource.dart';
import 'package:mvvm_clean_template/data/repositories/user_repository_impl.dart';
import 'package:mvvm_clean_template/domain/repositories/user_repository.dart';
import 'package:mvvm_clean_template/domain/usecases/get_current_user_usecase.dart';
import 'package:mvvm_clean_template/domain/usecases/get_users_usecase.dart';
import 'package:mvvm_clean_template/domain/usecases/update_user_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies using GetIt
/// This is useful for services, repositories, and use cases that don't need to be reactive
Future<void> initializeDependencies() async {
  // ========== External Dependencies ==========
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  getIt.registerLazySingleton<Connectivity>(Connectivity.new);

  // HTTP Client
  getIt.registerLazySingleton<http.Client>(http.Client.new);

  // ========== Core ==========
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<Connectivity>()),
  );

  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(client: getIt<http.Client>()),
  );

  // ========== Storage ==========
  getIt.registerLazySingleton<SecureStorage>(SecureStorageImpl.new);

  getIt.registerLazySingleton<AuthStorage>(
    () => AuthStorage(secureStorage: getIt<SecureStorage>()),
  );

  // ========== Data Sources ==========
  // User Data Sources
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<UserLocalDataSource>(
    () =>
        UserLocalDataSourceImpl(sharedPreferences: getIt<SharedPreferences>()),
  );

  // ========== Repositories ==========
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: getIt<UserRemoteDataSource>(),
      localDataSource: getIt<UserLocalDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // ========== Use Cases ==========
  getIt.registerLazySingleton(
    () => GetCurrentUserUseCase(repository: getIt<UserRepository>()),
  );

  getIt.registerLazySingleton(
    () => GetUsersUseCase(repository: getIt<UserRepository>()),
  );

  getIt.registerLazySingleton(
    () => UpdateUserUseCase(repository: getIt<UserRepository>()),
  );

  // ========== ViewModels ==========
  // ViewModels are registered with Provider in providers.dart for reactive state management
}

/// Reset all dependencies (useful for testing or logout)
Future<void> resetDependencies() async {
  await getIt.reset();
}
