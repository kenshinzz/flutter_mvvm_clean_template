# MVVM Clean Architecture - Complete Project Guide

## Quick Start Guide

### 1. Setup

```bash
# Install dependencies
flutter pub get

# Generate localization files (if needed)
flutter gen-l10n

# Run the app
flutter run
```

### 2. Test the Setup

After running `flutter run`, you should see:
- App title using localization
- Custom theme colors applied
- Light/Dark mode support (based on system settings)
- Welcome message in English or Thai

## Complete Feature Implementation Example

Let's implement a **User Profile** feature step-by-step.

### Step 1: Domain Layer

#### 1.1 Create Entity
**File**: `lib/domain/entities/user_entity.dart`

```dart
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, avatarUrl, createdAt];
}
```

#### 1.2 Create Repository Interface
**File**: `lib/domain/repositories/user_repository.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:mvvm_clean_template/core/errors/failures.dart';
import 'package:mvvm_clean_template/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUser(String id);
  Future<Either<Failure, List<UserEntity>>> getUsers();
  Future<Either<Failure, UserEntity>> createUser(UserEntity user);
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user);
  Future<Either<Failure, void>> deleteUser(String id);
}
```

#### 1.3 Create Use Case
**File**: `lib/domain/usecases/get_user_usecase.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mvvm_clean_template/core/errors/failures.dart';
import 'package:mvvm_clean_template/core/usecases/usecase.dart';
import 'package:mvvm_clean_template/domain/entities/user_entity.dart';
import 'package:mvvm_clean_template/domain/repositories/user_repository.dart';

class GetUserUseCase implements UseCase<UserEntity, GetUserParams> {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(GetUserParams params) async {
    return await repository.getUser(params.userId);
  }
}

class GetUserParams extends Equatable {
  final String userId;

  const GetUserParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
```

### Step 2: Data Layer

#### 2.1 Create Model
**File**: `lib/data/models/user_model.dart`

```dart
import 'package:mvvm_clean_template/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatarUrl,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatar_url'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      avatarUrl: entity.avatarUrl,
      createdAt: entity.createdAt,
    );
  }
}
```

#### 2.2 Create Remote Data Source
**File**: `lib/data/datasources/user_remote_datasource.dart`

```dart
import 'package:mvvm_clean_template/core/network/api_client.dart';
import 'package:mvvm_clean_template/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUser(String id);
  Future<List<UserModel>> getUsers();
  Future<UserModel> createUser(UserModel user);
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(String id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient apiClient;

  UserRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> getUser(String id) async {
    final response = await apiClient.get('/users/$id');
    return UserModel.fromJson(response.data);
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await apiClient.get('/users');
    return (response.data as List)
        .map((json) => UserModel.fromJson(json))
        .toList();
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    final response = await apiClient.post('/users', data: user.toJson());
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    final response = await apiClient.put('/users/${user.id}', data: user.toJson());
    return UserModel.fromJson(response.data);
  }

  @override
  Future<void> deleteUser(String id) async {
    await apiClient.delete('/users/$id');
  }
}
```

#### 2.3 Create Local Data Source (Optional)
**File**: `lib/data/datasources/user_local_datasource.dart`

```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mvvm_clean_template/data/models/user_model.dart';

abstract class UserLocalDataSource {
  Future<UserModel?> getCachedUser(String id);
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSourceImpl(this.sharedPreferences);

  static const String cachedUserPrefix = 'CACHED_USER_';

  @override
  Future<UserModel?> getCachedUser(String id) async {
    final jsonString = sharedPreferences.getString('$cachedUserPrefix$id');
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(
      '$cachedUserPrefix${user.id}',
      json.encode(user.toJson()),
    );
  }

  @override
  Future<void> clearCache() async {
    final keys = sharedPreferences.getKeys();
    for (final key in keys) {
      if (key.startsWith(cachedUserPrefix)) {
        await sharedPreferences.remove(key);
      }
    }
  }
}
```

#### 2.4 Create Repository Implementation
**File**: `lib/data/repositories/user_repository_impl.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:mvvm_clean_template/core/errors/exceptions.dart';
import 'package:mvvm_clean_template/core/errors/failures.dart';
import 'package:mvvm_clean_template/core/network/network_info.dart';
import 'package:mvvm_clean_template/data/datasources/user_local_datasource.dart';
import 'package:mvvm_clean_template/data/datasources/user_remote_datasource.dart';
import 'package:mvvm_clean_template/data/models/user_model.dart';
import 'package:mvvm_clean_template/domain/entities/user_entity.dart';
import 'package:mvvm_clean_template/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> getUser(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getUser(id);
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure(e.toString()));
      }
    } else {
      try {
        final cachedUser = await localDataSource.getCachedUser(id);
        if (cachedUser != null) {
          return Right(cachedUser);
        }
        return const Left(NetworkFailure('No internet connection and no cached data'));
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers() async {
    if (await networkInfo.isConnected) {
      try {
        final users = await remoteDataSource.getUsers();
        return Right(users);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> createUser(UserEntity user) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = UserModel.fromEntity(user);
        final createdUser = await remoteDataSource.createUser(userModel);
        return Right(createdUser);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = UserModel.fromEntity(user);
        final updatedUser = await remoteDataSource.updateUser(userModel);
        await localDataSource.cacheUser(updatedUser);
        return Right(updatedUser);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteUser(id);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
```

### Step 3: Presentation Layer

#### 3.1 Create ViewModel
**File**: `lib/presentation/viewmodels/user_viewmodel.dart`

```dart
import 'package:flutter/foundation.dart';
import 'package:mvvm_clean_template/domain/entities/user_entity.dart';
import 'package:mvvm_clean_template/domain/usecases/get_user_usecase.dart';

enum UserViewState { initial, loading, loaded, error }

class UserViewModel extends ChangeNotifier {
  final GetUserUseCase getUserUseCase;

  UserViewModel({required this.getUserUseCase});

  UserEntity? _user;
  UserViewState _state = UserViewState.initial;
  String? _errorMessage;

  UserEntity? get user => _user;
  UserViewState get state => _state;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == UserViewState.loading;
  bool get hasError => _state == UserViewState.error;
  bool get hasData => _state == UserViewState.loaded && _user != null;

  Future<void> loadUser(String userId) async {
    _state = UserViewState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await getUserUseCase(GetUserParams(userId: userId));

    result.fold(
      (failure) {
        _state = UserViewState.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (user) {
        _user = user;
        _state = UserViewState.loaded;
        notifyListeners();
      },
    );
  }

  void clearError() {
    _errorMessage = null;
    if (_state == UserViewState.error) {
      _state = UserViewState.initial;
    }
    notifyListeners();
  }

  void reset() {
    _user = null;
    _state = UserViewState.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
```

#### 3.2 Create Page
**File**: `lib/presentation/pages/user_profile_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mvvm_clean_template/presentation/viewmodels/user_viewmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserViewModel>().loadUser(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<UserViewModel>().loadUser(widget.userId);
            },
          ),
        ],
      ),
      body: Consumer<UserViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (viewModel.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.errorMessage ?? l10n.error,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      viewModel.loadUser(widget.userId);
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          if (!viewModel.hasData) {
            return Center(
              child: Text(l10n.noDataAvailable),
            );
          }

          final user = viewModel.user!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: theme.colorScheme.primary,
                    backgroundImage: user.avatarUrl != null
                        ? NetworkImage(user.avatarUrl!)
                        : null,
                    child: user.avatarUrl == null
                        ? Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                            style: theme.textTheme.displayLarge?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 24),

                // User Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          context,
                          icon: Icons.person,
                          label: 'Name',
                          value: user.name,
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          context,
                          icon: Icons.email,
                          label: l10n.email,
                          value: user.email,
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          context,
                          icon: Icons.calendar_today,
                          label: 'Member Since',
                          value: '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Handle edit
                        },
                        icon: const Icon(Icons.edit),
                        label: Text(l10n.edit),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Handle delete
                        },
                        icon: const Icon(Icons.delete),
                        label: Text(l10n.delete),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```

### Step 4: Dependency Injection

Create a service locator to manage dependencies.

**File**: `lib/core/di/injection_container.dart`

```dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mvvm_clean_template/core/network/api_client.dart';
import 'package:mvvm_clean_template/core/network/network_info.dart';
import 'package:mvvm_clean_template/data/datasources/user_local_datasource.dart';
import 'package:mvvm_clean_template/data/datasources/user_remote_datasource.dart';
import 'package:mvvm_clean_template/data/repositories/user_repository_impl.dart';
import 'package:mvvm_clean_template/domain/repositories/user_repository.dart';
import 'package:mvvm_clean_template/domain/usecases/get_user_usecase.dart';
import 'package:mvvm_clean_template/presentation/viewmodels/user_viewmodel.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => Connectivity());

  // Core
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(dio: getIt()));
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt()),
  );

  // Data Sources
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetUserUseCase(getIt()));

  // ViewModels
  getIt.registerFactory(() => UserViewModel(getUserUseCase: getIt()));
}
```

### Step 5: Update main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:mvvm_clean_template/core/di/injection_container.dart';
import 'package:mvvm_clean_template/core/theme/app_theme.dart';
import 'package:mvvm_clean_template/presentation/viewmodels/user_viewmodel.dart';
import 'package:mvvm_clean_template/presentation/pages/user_profile_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup dependency injection
  await setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<UserViewModel>()),
      ],
      child: MaterialApp(
        title: 'MVVM Clean Template',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('th', ''),
        ],
        home: const UserProfilePage(userId: '123'),
      ),
    );
  }
}
```

## Testing Strategy

### Unit Tests
Test use cases, repositories, and view models in isolation.

### Widget Tests
Test individual widgets and pages.

### Integration Tests
Test complete user flows.

## Best Practices Summary

1. **Always use Either<Failure, T>** for repository methods
2. **Keep entities pure** - No JSON serialization in entities
3. **Use models for data transfer** - JSON handling in models only
4. **Separate concerns** - ViewModels manage state, not business logic
5. **Inject dependencies** - Use GetIt for dependency injection
6. **Handle errors gracefully** - Use custom exceptions and failures
7. **Cache when possible** - Implement offline-first approach
8. **Test everything** - Write tests for each layer

## Folder Structure Reference

```
lib/
├── core/                           # Core utilities and configurations
│   ├── constants/                  # App constants
│   ├── di/                         # Dependency injection
│   ├── errors/                     # Error handling
│   ├── localization/               # Localization helpers
│   ├── network/                    # Network configuration
│   ├── theme/                      # Theme configuration
│   ├── usecases/                   # Base use case
│   └── utils/                      # Utilities
├── data/                           # Data layer
│   ├── datasources/                # Remote & local data sources
│   ├── models/                     # Data models
│   └── repositories/               # Repository implementations
├── domain/                         # Domain layer (business logic)
│   ├── entities/                   # Business entities
│   ├── repositories/               # Repository interfaces
│   └── usecases/                   # Use cases
└── presentation/                   # Presentation layer
    ├── pages/                      # UI pages
    ├── viewmodels/                 # State management
    └── widgets/                    # Reusable widgets
```

This structure ensures clean separation of concerns and makes the codebase highly maintainable and testable.
