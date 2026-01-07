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

## License

This project is a template and can be used freely.
