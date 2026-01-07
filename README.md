# Flutter MVVM Clean Architecture Template

A production-ready Flutter project template implementing MVVM Clean Architecture pattern with comprehensive theme management and localization support.

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart          # Application-wide constants
│   ├── errors/
│   │   ├── exceptions.dart             # Exception classes
│   │   └── failures.dart               # Failure classes for error handling
│   ├── network/
│   │   ├── api_client.dart             # HTTP-based API client
│   │   └── network_info.dart           # Network connectivity checker
│   ├── theme/
│   │   ├── app_colors.dart             # Color palette
│   │   ├── app_text_styles.dart        # Text styles
│   │   └── app_theme.dart              # Theme configuration
│   ├── usecases/
│   │   └── usecase.dart                # Base UseCase class
│   └── utils/
│       ├── date_utils.dart             # Date/time utilities
│       ├── logger.dart                 # Logging utility
│       └── validators.dart             # Input validators
├── data/
│   ├── datasources/                    # Remote & local data sources
│   ├── models/                         # Data models (JSON serializable)
│   └── repositories/                   # Repository implementations
├── domain/
│   ├── entities/                       # Business entities
│   ├── repositories/                   # Repository interfaces
│   └── usecases/                       # Business logic use cases
├── presentation/
│   ├── pages/                          # UI screens/pages
│   ├── viewmodels/                     # State management (ViewModels)
│   └── widgets/                        # Reusable widgets
├── l10n/
│   ├── app_en.arb                      # English translations
│   └── app_th.arb                      # Thai translations
└── main.dart                           # Application entry point
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

### Theme Management
- Light and Dark theme support
- Material Design 3 (Material You)
- Comprehensive color palette
- Consistent text styles
- Customizable component themes

### Localization
- Support for multiple languages (English & Thai by default)
- Easy to add more languages
- Type-safe translations with code generation
- Flutter's official l10n approach

### Core Utilities
- **API Client**: Pre-configured HTTP client with error handling
- **Network Info**: Connectivity checking
- **Validators**: Common input validation (email, password, phone, etc.)
- **Logger**: Debug and production logging
- **Date Utils**: Date/time formatting and manipulation
- **Error Handling**: Structured exceptions and failures

## Getting Started

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Generate Localization Files

```bash
flutter gen-l10n
```

Or run:

```bash
flutter pub get
```

This will automatically generate localization files in `.dart_tool/flutter_gen/gen_l10n/`.

### 3. Run the Application

```bash
flutter run
```

## Adding New Features

Follow Clean Architecture principles when adding features. See the detailed examples in the full documentation.

## Dependencies

### Core
- `flutter` - Flutter SDK
- `flutter_localizations` - Localization support

### State Management
- `provider` - State management solution

### Network
- `http` - HTTP client
- `connectivity_plus` - Network connectivity

### Storage
- `shared_preferences` - Local key-value storage

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

When adding new mock annotations, regenerate mocks with:

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
│       └── api_client_test.dart        # API client tests
├── presentation/
│   └── viewmodels/
│       └── settings_viewmodel_test.dart # ViewModel tests
├── golden/
│   ├── pages/
│   │   ├── home_page_golden_test.dart   # Page golden tests
│   │   └── settings_page_golden_test.dart
│   └── widgets/
│       ├── button_golden_test.dart      # Widget golden tests
│       └── card_golden_test.dart
├── helpers/
│   └── test_helpers.dart               # Test utilities
├── flutter_test_config.dart            # Alchemist config
└── widget_test.dart                    # Widget tests
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
