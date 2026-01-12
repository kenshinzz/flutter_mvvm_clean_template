/// Riverpod Providers - All dependency injection is handled here
///
/// This file replaces GetIt service_locator.dart with Riverpod providers.
/// All dependencies are lazily initialized and properly scoped.
library;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

// Re-export ViewModels
export 'package:mvvm_clean_template/presentation/viewmodels/settings_viewmodel.dart'
    show SettingsNotifier, SettingsState, settingsProvider;

// =============================================================================
// EXTERNAL DEPENDENCIES
// =============================================================================

/// SharedPreferences provider - must be overridden in main() before use
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden with a valid SharedPreferences instance',
  );
});

/// HTTP Client provider
final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

/// Connectivity provider
final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

// =============================================================================
// CORE SERVICES
// =============================================================================

/// Network info provider
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return NetworkInfoImpl(connectivity);
});

/// API client provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ref.watch(httpClientProvider);
  final apiClient = ApiClient(client: client);
  ref.onDispose(apiClient.dispose);
  return apiClient;
});

// =============================================================================
// STORAGE
// =============================================================================

/// Secure storage provider
final secureStorageProvider = Provider<SecureStorage>(
  (ref) => SecureStorageImpl(),
);

/// Auth storage provider
final authStorageProvider = Provider<AuthStorage>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthStorage(secureStorage: secureStorage);
});

// =============================================================================
// DATA SOURCES
// =============================================================================

/// User remote data source provider
final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRemoteDataSourceImpl(apiClient: apiClient);
});

/// User local data source provider
final userLocalDataSourceProvider = Provider<UserLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return UserLocalDataSourceImpl(sharedPreferences: prefs);
});

// =============================================================================
// REPOSITORIES
// =============================================================================

/// User repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final remoteDataSource = ref.watch(userRemoteDataSourceProvider);
  final localDataSource = ref.watch(userLocalDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return UserRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );
});

// =============================================================================
// USE CASES
// =============================================================================

/// Get current user use case provider
final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetCurrentUserUseCase(repository: repository);
});

/// Get users use case provider
final getUsersUseCaseProvider = Provider<GetUsersUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUsersUseCase(repository: repository);
});

/// Update user use case provider
final updateUserUseCaseProvider = Provider<UpdateUserUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UpdateUserUseCase(repository: repository);
});
