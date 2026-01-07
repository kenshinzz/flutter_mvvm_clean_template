# Flutter MVVM Clean Architecture Template

A production-ready Flutter project template implementing MVVM Clean Architecture pattern with comprehensive theme management, localization, environment configuration, and testing support.

## Project Structure

```
lib/
├── core/
│   ├── config/
│   │   ├── app_config.dart               # Global app configuration
│   │   └── env_config.dart               # Environment-specific config
│   ├── constants/
│   │   └── app_constants.dart            # Application-wide constants
│   ├── di/
│   │   ├── providers.dart                # Provider definitions
│   │   └── service_locator.dart          # GetIt dependency injection
│   ├── errors/
│   │   ├── exceptions.dart               # Exception classes
│   │   └── failures.dart                 # Failure classes for error handling
│   ├── extensions/
│   │   ├── context_extensions.dart       # BuildContext extensions
│   │   ├── datetime_extensions.dart      # DateTime extensions
│   │   ├── extensions.dart               # Barrel file
│   │   ├── list_extensions.dart          # List extensions
│   │   ├── num_extensions.dart           # Number extensions
│   │   └── string_extensions.dart        # String extensions
│   ├── lifecycle/
│   │   └── app_lifecycle_handler.dart    # App lifecycle management
│   ├── network/
│   │   ├── api_client.dart               # HTTP-based API client
│   │   └── network_info.dart             # Network connectivity checker
│   ├── state/
│   │   ├── async_state.dart              # Generic async state handling
│   │   └── pagination_state.dart         # Pagination state handling
│   ├── storage/
│   │   ├── auth_storage.dart             # Auth token storage
│   │   └── secure_storage.dart           # Secure storage wrapper
│   ├── theme/
│   │   ├── app_colors.dart               # Color palette
│   │   ├── app_text_styles.dart          # Text styles
│   │   └── app_theme.dart                # Theme configuration
│   ├── usecases/
│   │   └── usecase.dart                  # Base UseCase class
│   └── utils/
│       ├── date_utils.dart               # Date/time utilities
│       ├── logger.dart                   # Logging utility
│       └── validators.dart               # Input validators
├── data/
│   ├── datasources/
│   │   ├── user_local_datasource.dart    # User local cache
│   │   └── user_remote_datasource.dart   # User API calls
│   ├── models/
│   │   └── user_model.dart               # User data model
│   └── repositories/
│       └── user_repository_impl.dart     # User repository implementation
├── domain/
│   ├── entities/
│   │   └── user_entity.dart              # User business entity
│   ├── repositories/
│   │   └── user_repository.dart          # User repository interface
│   └── usecases/
│       ├── get_current_user_usecase.dart # Get current user
│       ├── get_users_usecase.dart        # Get users list
│       └── update_user_usecase.dart      # Update user
├── presentation/
│   ├── pages/
│   │   ├── home_page.dart                # Home screen
│   │   ├── settings_page.dart            # Settings screen
│   │   └── splash_page.dart              # Splash screen
│   ├── viewmodels/
│   │   └── settings_viewmodel.dart       # Settings state management
│   └── widgets/
│       └── common/
│           ├── async_value_widget.dart   # Async state widget builder
│           ├── empty_state_widget.dart   # Empty state display
│           ├── error_widget.dart         # Error display
│           └── loading_widget.dart       # Loading indicators
├── l10n/
│   ├── app_en.arb                        # English translations
│   └── app_th.arb                        # Thai translations
├── main.dart                             # Default entry point
├── main_dev.dart                         # Development entry point
├── main_staging.dart                     # Staging entry point
└── main_prod.dart                        # Production entry point
```

## Architecture Overview

This project follows **MVVM Clean Architecture** principles with three main layers:

### 1. Presentation Layer
- **Pages**: UI screens
- **ViewModels**: State management and business logic coordination
- **Widgets**: Reusable UI components

### 2. Domain Layer (Business Logic)
- **Entities**: Core business objects
- **Repositories**: Abstract repository interfaces
- **Use Cases**: Business rules and operations

### 3. Data Layer
- **Models**: Data transfer objects
- **Data Sources**: Remote (API) and Local (Cache) data sources
- **Repositories**: Implementation of domain repository interfaces

## Features

### 🌍 Environment Configuration

Support for multiple environments with separate configurations:

```bash
# Development
flutter run -t lib/main_dev.dart

# Staging
flutter run -t lib/main_staging.dart

# Production
flutter run -t lib/main_prod.dart --release
```

### 🎨 Theme Management
- Light and Dark theme support
- Material Design 3 (Material You)
- Comprehensive color palette
- Consistent text styles
- Customizable component themes

### 🌐 Localization
- Support for multiple languages (English & Thai by default)
- Easy to add more languages
- Type-safe translations with code generation
- Flutter's official l10n approach

### 🔒 Secure Storage
- Encrypted storage for sensitive data
- Auth token management
- Platform-specific secure storage (Keychain/EncryptedSharedPreferences)

### 📱 App Lifecycle
- Lifecycle event handling
- Easy-to-use mixin or widget wrapper
- Handle resume, pause, inactive states

### 🔧 Extensions Library
- **String**: Email validation, formatting, masking
- **DateTime**: Relative time, formatting, comparisons
- **BuildContext**: Theme, media query, navigation, snackbars
- **List**: Grouping, sorting, pagination helpers
- **Numbers**: Currency, file size, percentage formatting

### ⚡ Async State Management
- Generic `AsyncState<T>` for loading/success/error states
- `PaginationState<T>` for paginated data
- Pre-built widgets: `AsyncValueWidget`, `LoadingWidget`, `AppErrorWidget`, `EmptyStateWidget`

### 📦 Example Feature Module
Complete User feature demonstrating the full architecture:
- Entity → Model → Repository Interface → Repository Implementation
- Remote & Local Data Sources with caching
- Use Cases for business operations
- Ready to use as a template for new features

## Getting Started

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Generate Localization Files

```bash
flutter gen-l10n
```

### 3. Run the Application

```bash
# Development mode
flutter run -t lib/main_dev.dart

# Or default
flutter run
```

## Adding New Features

### 1. Create Entity (Domain Layer)

```dart
// lib/domain/entities/product_entity.dart
class ProductEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  
  const ProductEntity({...});
}
```

### 2. Create Model (Data Layer)

```dart
// lib/data/models/product_model.dart
class ProductModel extends ProductEntity {
  factory ProductModel.fromJson(Map<String, dynamic> json) => ...
  Map<String, dynamic> toJson() => ...
}
```

### 3. Define Repository Interface (Domain Layer)

```dart
// lib/domain/repositories/product_repository.dart
abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
}
```

### 4. Implement Repository (Data Layer)

```dart
// lib/data/repositories/product_repository_impl.dart
class ProductRepositoryImpl implements ProductRepository {
  // Implement with data sources
}
```

### 5. Create Use Cases (Domain Layer)

```dart
// lib/domain/usecases/get_products_usecase.dart
class GetProductsUseCase implements UseCase<List<ProductEntity>, NoParams> {
  Future<Either<Failure, List<ProductEntity>>> call(NoParams params) => ...
}
```

### 6. Register Dependencies

```dart
// lib/core/di/service_locator.dart
getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(...));
getIt.registerLazySingleton(() => GetProductsUseCase(...));
```

## Dependencies

### Core
- `flutter` - Flutter SDK
- `flutter_localizations` - Localization support

### State Management
- `provider` - Reactive state management

### Network
- `http` - HTTP client
- `connectivity_plus` - Network connectivity

### Storage
- `shared_preferences` - Local key-value storage
- `flutter_secure_storage` - Encrypted storage for sensitive data

### Dependency Injection
- `get_it` - Service locator

### Utilities
- `equatable` - Value equality
- `intl` - Internationalization
- `logger` - Logging
- `dartz` - Functional programming (Either type)

### Testing
- `mockito` - Mocking framework
- `build_runner` - Code generation for mocks
- `alchemist` - Snapshot/Golden testing

## Testing

### Run Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/core/network/api_client_test.dart

# Run tests with coverage
flutter test --coverage
```

### Generate Mocks

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Golden/Snapshot Tests

```bash
# Generate/update golden images
flutter test --update-goldens --tags=golden

# Run golden tests
flutter test --tags=golden

# Run all tests except golden tests
flutter test --exclude-tags=golden
```

### Test Structure

```
test/
├── core/
│   └── network/
│       └── api_client_test.dart          # API client tests
├── presentation/
│   └── viewmodels/
│       └── settings_viewmodel_test.dart  # ViewModel tests
├── golden/
│   ├── pages/                            # Page golden tests
│   └── widgets/                          # Widget golden tests
├── helpers/
│   └── test_helpers.dart                 # Test utilities
├── flutter_test_config.dart              # Alchemist config
└── widget_test.dart                      # Widget tests
```

## CI/CD

This project includes GitHub Actions workflows and Fastlane for automated deployment.

### Workflows

| Workflow | Trigger | Description |
|----------|---------|-------------|
| `ci.yml` | Push/PR to main, develop | Analyze, test, build |
| `cd-android.yml` | Tags `v*` / Manual | Deploy to Play Store |
| `cd-ios.yml` | Tags `v*` / Manual | Deploy to TestFlight/App Store |

### Quick Deploy

```bash
# Create a release tag to trigger deployment
git tag v1.0.0
git push origin v1.0.0
```

For detailed setup instructions, see [CI_CD_SETUP.md](CI_CD_SETUP.md).

## License

This project is a template and can be used freely.
