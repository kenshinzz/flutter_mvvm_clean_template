# Flutter MVVM Clean Architecture Template

A production-ready Flutter project template implementing **MVVM Clean Architecture** with **Riverpod** for both state management and dependency injection.

[![CI](https://github.com/YOUR_USERNAME/flutter_speckit_flutter_template/actions/workflows/ci.yml/badge.svg)](https://github.com/YOUR_USERNAME/flutter_speckit_flutter_template/actions/workflows/ci.yml)
[![Flutter](https://img.shields.io/badge/Flutter-3.38.5-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10.4-blue.svg)](https://dart.dev)

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🏗️ **Clean Architecture** | Separation of concerns with Domain, Data, and Presentation layers |
| 📱 **MVVM Pattern** | ViewModels with Riverpod Notifiers for reactive state management |
| 💉 **Riverpod DI** | Single, unified dependency injection using Riverpod providers |
| 🧭 **GoRouter Navigation** | Declarative, type-safe routing with path/query parameters |
| 🌍 **Multi-Environment** | Dev, Staging, and Production configurations |
| 🎨 **Theme System** | Light/Dark/System themes with Material 3 |
| 🌐 **Localization** | English & Thai with type-safe translations |
| 🔒 **Secure Storage** | Encrypted storage for sensitive data |
| 🧪 **Testing** | Unit, Widget, and Golden tests with CI integration |
| 🚀 **CI/CD** | GitHub Actions + Fastlane for automated deployment |
| 📦 **Optimized Builds** | ProGuard/R8 shrinking, split APKs |
| 🔢 **Version Management** | Semantic versioning with automated sync |

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

#### Using Makefile (Recommended)

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/flutter_speckit_flutter_template.git
cd flutter_speckit_flutter_template

# Complete setup (dependencies + iOS pods)
make setup

# Or setup individually
make install          # Install Flutter dependencies
make setup-ios        # Setup iOS pods
make setup-android    # Setup Android dependencies

# View all available commands
make help
```

#### Manual Installation

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/flutter_speckit_flutter_template.git
cd flutter_speckit_flutter_template

# Install dependencies
flutter pub get

# Generate localization files
flutter gen-l10n

# Generate mocks for testing
dart run build_runner build --delete-conflicting-outputs
```

### Running the App

#### Using Makefile

```bash
# Development (default)
make run
make run-dev

# Staging
make run-staging

# Production
make run-prod
```

#### Manual Commands

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

### Common Commands

The project includes a `Makefile` with convenient commands:

```bash
# Setup
make setup              # Complete setup
make install            # Install dependencies

# Build
make build-dev          # Build development
make build-staging      # Build staging
make build-prod        # Build production
make build-android-bundle  # Build Android App Bundle

# Run
make run                # Run development (default)
make run-staging        # Run staging
make run-prod           # Run production

# Test
make test               # Run all tests
make test-unit          # Unit tests only
make test-golden        # Golden/snapshot tests
make test-coverage      # Tests with coverage

# Code Quality
make format             # Format code
make analyze            # Analyze code
make lint               # Run all lint checks
make fix                # Auto-fix issues

# Fastlane
make fastlane-ios-beta      # Deploy iOS to TestFlight
make fastlane-ios-release   # Deploy iOS to App Store
make fastlane-android-beta  # Deploy Android to Internal Testing

# Clean
make clean              # Clean build files
make clean-all          # Clean everything

# View all commands
make help
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

## 🧭 Navigation with GoRouter

This project uses **GoRouter** for declarative, type-safe navigation. All routes are centralized in `lib/core/router/`.

### Route Configuration

Routes are defined in `lib/core/router/app_router.dart` and route names are constants in `lib/core/router/route_names.dart`:

```dart
// lib/core/router/route_names.dart
class RouteNames {
  static const String splash = '/';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String login = '/login';
  static const String profile = '/profile';
  // ... more routes
}
```

### Basic Navigation

```dart
// Navigate to a route (replaces current route)
context.go(RouteNames.home);

// Navigate with push (adds to navigation stack)
context.push(RouteNames.settings);

// Pop current route
context.pop();

// Replace current route
context.replace(RouteNames.login);

// Pop until a specific route
context.go(RouteNames.home);
```

### Navigation with Parameters

#### Path Parameters

```dart
// Route definition
GoRoute(
  path: '/user/:id',
  name: 'user-detail',
  builder: (context, state) {
    final userId = state.pathParameters['id']!;
    return UserDetailPage(userId: userId);
  },
),

// Navigation
context.go('/user/123');
// Or using named route
context.goNamed('user-detail', pathParameters: {'id': '123'});
```

#### Query Parameters

```dart
// Route definition
GoRoute(
  path: '/search',
  name: 'search',
  builder: (context, state) {
    final query = state.uri.queryParameters['q'];
    return SearchPage(query: query);
  },
),

// Navigation
context.go('/search?q=flutter');
// Or using named route
context.goNamed('search', queryParameters: {'q': 'flutter'});
```

#### Extra Data

```dart
// Navigation with extra data
context.push(
  RouteNames.profile,
  extra: User(id: '123', name: 'John'),
);

// Route definition
GoRoute(
  path: RouteNames.profile,
  builder: (context, state) {
    final user = state.extra as User;
    return ProfilePage(user: user);
  },
),
```

### Adding a New Route

**Step 1**: Add route constant to `route_names.dart`:
```dart
static const String productDetail = '/product/:id';
```

**Step 2**: Create the page widget:
```dart
// lib/presentation/pages/product_detail_page.dart
class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({required this.productId, super.key});
  final String productId;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Center(child: Text('Product ID: $productId')),
    );
  }
}
```

**Step 3**: Register route in `app_router.dart`:
```dart
GoRoute(
  path: RouteNames.productDetail,
  name: 'product-detail',
  builder: (context, state) {
    final productId = state.pathParameters['id']!;
    return ProductDetailPage(productId: productId);
  },
),
```

### Authentication Guards

Implement authentication redirects in `app_router.dart`:

```dart
redirect: (context, state) {
  // Access auth state from Riverpod using ProviderScope.containerOf
  final container = ProviderScope.containerOf(context);
  final authState = container.read(authProvider);
  final isAuthenticated = authState.isAuthenticated;
  final isAuthRoute = state.matchedLocation == RouteNames.login ||
                      state.matchedLocation == RouteNames.register;

  // Redirect to login if not authenticated
  if (!isAuthenticated && !isAuthRoute) {
    return RouteNames.login;
  }

  // Redirect to home if authenticated and on auth page
  if (isAuthenticated && isAuthRoute) {
    return RouteNames.home;
  }

  return null; // No redirect
},
```

**Note**: For more complex auth flows, consider using `GoRouter.refreshListenable` with a `ChangeNotifier` or `ValueNotifier` to automatically refresh routes when auth state changes.

### Error Handling

GoRouter automatically handles route errors with a custom error page:

```dart
errorBuilder: (context, state) => _ErrorPage(error: state.error.toString()),
```

### Navigation Best Practices

1. **Always use `RouteNames` constants** - Never hardcode route paths
2. **Use named routes** - Makes navigation more maintainable
3. **Handle parameters safely** - Always check for null values
4. **Use `context.go()` for top-level navigation** - Replaces entire stack
5. **Use `context.push()` for modal flows** - Adds to navigation stack
6. **Use `context.pop()` for going back** - Removes current route

### Current Routes

| Route | Path | Description |
|-------|------|-------------|
| Splash | `/` | Initial splash screen |
| Home | `/home` | Main home page |
| Settings | `/settings` | App settings |
| Login | `/login` | Login page (coming soon) |
| Register | `/register` | Registration page (coming soon) |
| Profile | `/profile` | User profile (coming soon) |

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

### Using Makefile

```bash
make test                # Run all tests
make test-unit           # Unit tests only (exclude golden)
make test-golden         # Golden/snapshot tests only
make test-golden-update  # Update golden test files
make test-coverage       # Run tests with coverage
```

### Manual Commands

```bash
# All tests (excluding golden)
flutter test --exclude-tags=golden

# With coverage
flutter test --coverage --exclude-tags=golden

# Specific test file
flutter test test/core/network/api_client_test.dart

# Golden tests only
flutter test --tags=golden

# Update golden files
flutter test --tags=golden --update-goldens

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

### Using Makefile

```bash
# Android
make build-android-dev      # Development APK
make build-android-staging  # Staging APK
make build-android-prod     # Production APK
make build-android-bundle   # App Bundle for Play Store

# iOS
make build-ios-dev         # Development (no codesign)
make build-ios-staging      # Staging (no codesign)
make build-ios-prod         # Production (no codesign)
```

### Manual Commands

#### Android

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

## 🔢 Version Management

The project uses **Semantic Versioning** (SemVer) format: `MAJOR.MINOR.PATCH+BUILD`

### Quick Commands

```bash
# Show current version
make version-app

# Bump versions
make version-bump-patch   # 1.0.0 -> 1.0.1
make version-bump-minor   # 1.0.0 -> 1.1.0
make version-bump-major   # 1.0.0 -> 2.0.0
make version-bump-build   # 1.0.0+1 -> 1.0.0+2

# Set version explicitly
make version-set VERSION=1.2.3 BUILD=10
```

### Accessing Version in Code

```dart
import 'package:speckit_flutter_template/core/utils/version_info.dart';

String version = VersionInfo.version;        // "1.0.0"
String buildNumber = VersionInfo.buildNumber; // "1"
String fullVersion = VersionInfo.fullVersion; // "1.0.0+1"
```

**Note**: Version is automatically synced from `pubspec.yaml` to Android and iOS during build.

For detailed versioning guide, see [VERSIONING.md](VERSIONING.md).

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
| `Makefile` | Centralized commands for development, build, test, and deployment |
| `analysis_options.yaml` | Dart analyzer & lint rules |
| `l10n.yaml` | Localization configuration |
| `dart_test.yaml` | Test tag configuration |
| `pubspec.yaml` | Dependencies & Flutter config |
| `android/app/proguard-rules.pro` | ProGuard rules for release builds |

## 📄 License

This project is a template and can be used freely for any purpose.

---

**Happy Coding! 🚀**
