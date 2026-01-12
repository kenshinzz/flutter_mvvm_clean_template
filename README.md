# Flutter MVVM Clean Architecture Template

A production-ready Flutter project template implementing **MVVM Clean Architecture** with **Riverpod** for both state management and dependency injection.

[![CI](https://github.com/YOUR_USERNAME/flutter_mvvm_clean_template/actions/workflows/ci.yml/badge.svg)](https://github.com/YOUR_USERNAME/flutter_mvvm_clean_template/actions/workflows/ci.yml)
[![Flutter](https://img.shields.io/badge/Flutter-3.38.5-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10.4-blue.svg)](https://dart.dev)

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🏗️ **Clean Architecture** | Separation of concerns with Domain, Data, and Presentation layers |
| 📱 **MVVM Pattern** | ViewModels with Riverpod Notifiers for reactive state management |
| 💉 **Riverpod DI** | Single, unified dependency injection using Riverpod providers |
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
│   │   └── providers.dart          # All Riverpod providers
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
                           │ ref.watch / ref.read
┌──────────────────────────▼──────────────────────────────────┐
│                      DOMAIN LAYER                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Entities   │  │  Use Cases  │  │   Repository        │  │
│  │  (Models)   │  │  (Business) │  │   (Interface)       │  │
│  └─────────────┘  └──────┬──────┘  └─────────────────────┘  │
└──────────────────────────┼──────────────────────────────────┘
                           │ Provider dependencies
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

## 💉 Dependency Injection with Riverpod

All dependencies are managed through Riverpod providers in `lib/core/di/providers.dart`:

```dart
// External dependencies
final sharedPreferencesProvider = Provider<SharedPreferences>(...);
final httpClientProvider = Provider<http.Client>(...);

// Core services
final apiClientProvider = Provider<ApiClient>(...);
final networkInfoProvider = Provider<NetworkInfo>(...);

// Repositories
final userRepositoryProvider = Provider<UserRepository>(...);

// Use Cases
final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>(...);

// ViewModels (Notifiers)
final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(...);
```

### Using Providers in Widgets

```dart
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch reactive state
    final settings = ref.watch(settingsProvider);
    
    // Read use case (non-reactive)
    final useCase = ref.read(getCurrentUserUseCaseProvider);
    
    // Call notifier methods
    ref.read(settingsProvider.notifier).toggleTheme();
  }
}
```

### Using Providers in Notifiers

```dart
class UserNotifier extends Notifier<UserState> {
  @override
  UserState build() {
    // Access other providers via ref
    final useCase = ref.watch(getCurrentUserUseCaseProvider);
    return const UserState();
  }
}
```

## 🎨 Theme Management

The app supports Light, Dark, and System themes with Material 3:

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

### 3. Create Data Source & Repository

```dart
// lib/data/datasources/product_remote_datasource.dart
final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProductRemoteDataSourceImpl(apiClient: apiClient);
});

// lib/data/repositories/product_repository_impl.dart
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final remoteDataSource = ref.watch(productRemoteDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return ProductRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});
```

### 4. Create Use Case

```dart
// lib/domain/usecases/get_products_usecase.dart
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetProductsUseCase(repository: repository);
});
```

### 5. Create ViewModel (Notifier)

```dart
// lib/presentation/viewmodels/product_viewmodel.dart
@immutable
class ProductState {
  const ProductState({this.products = const [], this.isLoading = false, this.error});
  
  final List<ProductEntity> products;
  final bool isLoading;
  final String? error;
  
  ProductState copyWith({...}) => ProductState(...);
}

class ProductNotifier extends Notifier<ProductState> {
  @override
  ProductState build() => const ProductState();
  
  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    
    final useCase = ref.read(getProductsUseCaseProvider);
    final result = await useCase.call(NoParams());
    
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (products) => state = state.copyWith(products: products, isLoading: false),
    );
  }
}

final productProvider = NotifierProvider<ProductNotifier, ProductState>(ProductNotifier.new);
```

### 6. Use in Widget

```dart
class ProductPage extends ConsumerWidget {
  const ProductPage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productProvider);
    
    return Scaffold(
      body: state.isLoading
          ? const CircularProgressIndicator()
          : ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (_, i) => ListTile(title: Text(state.products[i].name)),
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

### Testing with Provider Overrides

```dart
// Create a test container with mock providers
final container = ProviderContainer(
  overrides: [
    sharedPreferencesProvider.overrideWithValue(mockPrefs),
    userRepositoryProvider.overrideWithValue(mockRepository),
  ],
);

// Use in widget tests
await tester.pumpWidget(
  ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(mockPrefs)],
    child: const MyApp(),
  ),
);
```

### Generate Mocks

```bash
dart run build_runner build --delete-conflicting-outputs
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
| `flutter_riverpod` | State management & Dependency injection |
| `go_router` | Declarative routing |

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
