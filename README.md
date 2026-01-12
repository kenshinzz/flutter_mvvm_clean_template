# Flutter MVVM Clean Architecture Template

A production-ready Flutter project template implementing **MVVM Clean Architecture** with comprehensive features including theme management, localization, CI/CD, and testing infrastructure.

[![CI](https://github.com/YOUR_USERNAME/flutter_mvvm_clean_template/actions/workflows/ci.yml/badge.svg)](https://github.com/YOUR_USERNAME/flutter_mvvm_clean_template/actions/workflows/ci.yml)
[![Flutter](https://img.shields.io/badge/Flutter-3.38.5-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10.4-blue.svg)](https://dart.dev)

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🏗️ **Clean Architecture** | Separation of concerns with Domain, Data, and Presentation layers |
| 📱 **MVVM Pattern** | ViewModels with Riverpod for reactive state management |
| 🌍 **Multi-Environment** | Dev, Staging, and Production configurations |
| 🎨 **Theme System** | Light/Dark/System themes with Material 3 |
| 🌐 **Localization** | English & Thai with type-safe translations |
| 🔒 **Secure Storage** | Encrypted storage for sensitive data |
| 🧪 **Testing** | Unit, Widget, and Golden tests with CI integration |
| 🚀 **CI/CD** | GitHub Actions + Fastlane for automated deployment |
| 📦 **Optimized Builds** | ProGuard/R8 shrinking, split APKs |

## 📁 Project Structure

```
lib/
├── core/                           # Core utilities and configurations
│   ├── config/                     # Environment configurations
│   │   ├── app_config.dart         # Global app configuration
│   │   └── env_config.dart         # Environment-specific config
│   ├── constants/                  # Application constants
│   ├── di/                         # Dependency injection
│   │   ├── providers.dart          # Riverpod provider exports
│   │   └── service_locator.dart    # GetIt service locator
│   ├── errors/                     # Exception & Failure classes
│   ├── extensions/                 # Dart extension methods
│   ├── lifecycle/                  # App lifecycle handling
│   ├── network/                    # API client & network info
│   ├── router/                     # GoRouter configuration
│   ├── state/                      # Generic state classes
│   ├── storage/                    # Secure & local storage
│   ├── theme/                      # Theme configuration
│   ├── usecases/                   # Base UseCase class
│   └── utils/                      # Utilities (logger, validators)
├── data/                           # Data layer
│   ├── datasources/                # Remote & Local data sources
│   ├── models/                     # Data models (DTOs)
│   └── repositories/               # Repository implementations
├── domain/                         # Domain layer (business logic)
│   ├── entities/                   # Business entities
│   ├── repositories/               # Repository interfaces
│   └── usecases/                   # Use cases
├── presentation/                   # Presentation layer
│   ├── pages/                      # Screen widgets
│   ├── viewmodels/                 # Riverpod Notifiers
│   └── widgets/                    # Reusable widgets
├── l10n/                           # Localization files
├── main.dart                       # Default entry point
├── main_dev.dart                   # Development entry point
├── main_staging.dart               # Staging entry point
└── main_prod.dart                  # Production entry point
```

## 🏛️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Pages     │  │  ViewModels │  │   Widgets           │  │
│  │ (Screens)   │◄─│  (Notifier) │  │   (Reusable UI)     │  │
│  └─────────────┘  └──────┬──────┘  └─────────────────────┘  │
└──────────────────────────┼──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│                      DOMAIN LAYER                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Entities   │  │  Use Cases  │  │   Repository        │  │
│  │  (Models)   │  │  (Business) │  │   (Interface)       │  │
│  └─────────────┘  └──────┬──────┘  └─────────────────────┘  │
└──────────────────────────┼──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│                       DATA LAYER                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Models    │  │ Data Sources│  │   Repository        │  │
│  │   (DTOs)    │  │ (API/Cache) │  │   (Implementation)  │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.38.5+
- Dart SDK 3.10.4+

### Installation

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/flutter_mvvm_clean_template.git
cd flutter_mvvm_clean_template

# Install dependencies
flutter pub get

# Generate localization files
flutter gen-l10n

# Generate mocks for testing
dart run build_runner build --delete-conflicting-outputs
```

### Running the App

```bash
# Development
flutter run -t lib/main_dev.dart

# Staging
flutter run -t lib/main_staging.dart

# Production
flutter run -t lib/main_prod.dart --release

# Default (same as dev)
flutter run
```

## 🎨 Theme Management

The app supports Light, Dark, and System themes with Material 3 design:

```dart
// In any ConsumerWidget
final settings = ref.watch(settingsProvider);
final notifier = ref.read(settingsProvider.notifier);

// Change theme
await notifier.setLightTheme();
await notifier.setDarkTheme();
await notifier.setSystemTheme();
await notifier.toggleTheme();
```

## 🌐 Localization

Supports English and Thai with type-safe translations:

```dart
// Access translations
final l10n = AppLocalizations.of(context)!;
Text(l10n.welcomeMessage);

// Change language
await notifier.setEnglish();
await notifier.setThai();
await notifier.toggleLanguage();
```

### Adding a New Language

1. Create `lib/l10n/app_XX.arb` (e.g., `app_ja.arb` for Japanese)
2. Add translations matching keys in `app_en.arb`
3. Update `supportedLocales` in `main.dart`
4. Run `flutter gen-l10n`

## 📦 Adding New Features

### 1. Create Entity (Domain Layer)

```dart
// lib/domain/entities/product_entity.dart
class ProductEntity extends Equatable {
  const ProductEntity({required this.id, required this.name, required this.price});
  
  final String id;
  final String name;
  final double price;
  
  @override
  List<Object?> get props => [id, name, price];
}
```

### 2. Create Model (Data Layer)

```dart
// lib/data/models/product_model.dart
class ProductModel extends ProductEntity {
  const ProductModel({required super.id, required super.name, required super.price});
  
  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'] as String,
    name: json['name'] as String,
    price: (json['price'] as num).toDouble(),
  );
  
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'price': price};
}
```

### 3. Define Repository Interface (Domain Layer)

```dart
// lib/domain/repositories/product_repository.dart
abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, ProductEntity>> getProductById(String id);
}
```

### 4. Implement Data Source & Repository (Data Layer)

```dart
// lib/data/datasources/product_remote_datasource.dart
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl({required this.apiClient});
  final ApiClient apiClient;
  
  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await apiClient.get('/products');
    return (response.data as List).map((e) => ProductModel.fromJson(e)).toList();
  }
}

// lib/data/repositories/product_repository_impl.dart
class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({required this.remoteDataSource});
  final ProductRemoteDataSource remoteDataSource;
  
  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final products = await remoteDataSource.getProducts();
      return Right(products);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
```

### 5. Create Use Case (Domain Layer)

```dart
// lib/domain/usecases/get_products_usecase.dart
class GetProductsUseCase implements UseCase<List<ProductEntity>, NoParams> {
  GetProductsUseCase({required this.repository});
  final ProductRepository repository;
  
  @override
  Future<Either<Failure, List<ProductEntity>>> call(NoParams params) =>
      repository.getProducts();
}
```

### 6. Register Dependencies

```dart
// lib/core/di/service_locator.dart
getIt
  ..registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  )
  ..registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: getIt<ProductRemoteDataSource>()),
  )
  ..registerLazySingleton(
    () => GetProductsUseCase(repository: getIt<ProductRepository>()),
  );
```

### 7. Create ViewModel (Presentation Layer)

```dart
// lib/presentation/viewmodels/product_viewmodel.dart
@immutable
class ProductState {
  const ProductState({this.products = const [], this.isLoading = false, this.error});
  
  final List<ProductEntity> products;
  final bool isLoading;
  final String? error;
  
  ProductState copyWith({List<ProductEntity>? products, bool? isLoading, String? error}) =>
      ProductState(
        products: products ?? this.products,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class ProductNotifier extends Notifier<ProductState> {
  @override
  ProductState build() => const ProductState();
  
  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await getIt<GetProductsUseCase>().call(NoParams());
    
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (products) => state = state.copyWith(products: products, isLoading: false),
    );
  }
}

final productProvider = NotifierProvider<ProductNotifier, ProductState>(ProductNotifier.new);
```

### 8. Create Page (Presentation Layer)

```dart
// lib/presentation/pages/product_page.dart
class ProductPage extends ConsumerWidget {
  const ProductPage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: AsyncValueWidget(
        isLoading: state.isLoading,
        error: state.error,
        data: state.products,
        builder: (products) => ListView.builder(
          itemCount: products.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(products[i].name),
            trailing: Text('\$${products[i].price}'),
          ),
        ),
        onRetry: () => ref.read(productProvider.notifier).loadProducts(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(productProvider.notifier).loadProducts(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
```

## 🧪 Testing

### Run Tests

```bash
# All tests (excluding golden)
flutter test --exclude-tags=golden

# With coverage
flutter test --coverage --exclude-tags=golden

# Specific test file
flutter test test/core/network/api_client_test.dart

# Golden tests only
flutter test --tags=golden

# Update golden images
flutter test --tags=golden --update-goldens
```

### Generate Mocks

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Test Structure

```
test/
├── core/
│   └── network/
│       └── api_client_test.dart      # API client unit tests
├── presentation/
│   └── viewmodels/
│       └── settings_viewmodel_test.dart
├── golden/
│   ├── pages/                        # Page golden tests
│   │   └── goldens/ci/               # CI-compatible golden images
│   └── widgets/                      # Widget golden tests
├── helpers/
│   └── test_helpers.dart             # Test utilities & mocks
├── flutter_test_config.dart          # Alchemist configuration
└── widget_test.dart                  # Widget integration tests
```

## 🚀 CI/CD

### GitHub Actions Workflows

| Workflow | Trigger | Description |
|----------|---------|-------------|
| `ci.yml` | Push/PR to `main`, `develop` | Analyze, test, build APK & iOS |
| `cd-android.yml` | Tag `v*` / Manual | Deploy to Google Play Store |
| `cd-ios.yml` | Tag `v*` / Manual | Deploy to TestFlight/App Store |

### Quick Deploy

```bash
# Create a release tag to trigger deployment
git tag v1.0.0
git push origin v1.0.0
```

For detailed setup, see [CI_CD_SETUP.md](CI_CD_SETUP.md).

## 📱 Build Commands

### Android

```bash
# Debug APK
flutter build apk --debug

# Release APK (fat - all architectures, ~50MB)
flutter build apk --release

# Split APKs by architecture (~15-18MB each)
flutter build apk --release --split-per-abi

# App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Debug
flutter build ios --debug

# Release (no codesign for CI)
flutter build ios --release --no-codesign

# Release with codesign
flutter build ios --release
```

## 📦 Dependencies

### Core

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management with compile-time safety |
| `go_router` | Declarative routing |
| `get_it` | Service locator for dependency injection |

### Network & Storage

| Package | Purpose |
|---------|---------|
| `http` | HTTP client for API calls |
| `connectivity_plus` | Network connectivity detection |
| `shared_preferences` | Local key-value storage |
| `flutter_secure_storage` | Encrypted storage for sensitive data |

### Utilities

| Package | Purpose |
|---------|---------|
| `equatable` | Value equality for entities |
| `dartz` | Functional programming (`Either` type) |
| `intl` | Internationalization & formatting |
| `logger` | Structured logging |

### Dev & Testing

| Package | Purpose |
|---------|---------|
| `flutter_lints` | Recommended lint rules |
| `mockito` | Mocking framework |
| `build_runner` | Code generation |
| `alchemist` | Golden/snapshot testing |

## 🔧 Configuration Files

| File | Purpose |
|------|---------|
| `analysis_options.yaml` | Dart analyzer & lint rules |
| `l10n.yaml` | Localization configuration |
| `dart_test.yaml` | Test tag configuration |
| `pubspec.yaml` | Dependencies & Flutter config |
| `android/app/proguard-rules.pro` | ProGuard rules for release builds |

## 📄 License

This project is a template and can be used freely for any purpose.

---

**Happy Coding! 🚀**
