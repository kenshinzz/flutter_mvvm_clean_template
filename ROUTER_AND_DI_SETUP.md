# GoRouter and Provider Dependency Injection Setup

This document describes the implementation of GoRouter for navigation and Provider for dependency injection in this MVVM Clean Architecture Flutter project.

## Table of Contents
- [Overview](#overview)
- [File Structure](#file-structure)
- [GoRouter Setup](#gorouter-setup)
- [Provider Dependency Injection](#provider-dependency-injection)
- [Example Pages](#example-pages)
- [Usage Examples](#usage-examples)
- [Adding New Features](#adding-new-features)

## Overview

This implementation provides:
- **GoRouter**: Declarative routing with type-safe navigation
- **Provider**: Reactive state management for ViewModels
- **GetIt**: Service locator for non-reactive dependencies (repositories, use cases, services)
- **Clean separation**: UI layer (Provider) and business logic layer (GetIt)

## File Structure

```
lib/
├── core/
│   ├── di/
│   │   ├── service_locator.dart    # GetIt setup for repositories/use cases
│   │   └── providers.dart          # Provider setup for ViewModels
│   └── router/
│       ├── app_router.dart         # GoRouter configuration
│       └── route_names.dart        # Route name constants
├── presentation/
│   ├── pages/
│   │   ├── splash_page.dart        # Splash screen
│   │   ├── home_page.dart          # Home screen
│   │   └── settings_page.dart      # Settings screen
│   └── viewmodels/
│       └── settings_viewmodel.dart # Settings ViewModel
└── main.dart                       # App entry point
```

## GoRouter Setup

### Route Names (`lib/core/router/route_names.dart`)

Centralized route constants for type-safe navigation:

```dart
class RouteNames {
  static const String splash = '/';
  static const String home = '/home';
  static const String settings = '/settings';
  // ... more routes
}
```

### Router Configuration (`lib/core/router/app_router.dart`)

GoRouter configuration with:
- Route definitions
- Error handling
- Redirect logic for authentication (ready to implement)
- Material page transitions

Key features:
- **Initial route**: Splash screen (`/`)
- **Error handling**: Custom error page with navigation
- **Placeholder pages**: Coming soon pages for unimplemented routes

### Navigation Examples

```dart
// Navigate to a route
context.go(RouteNames.home);

// Navigate with push (adds to stack)
context.push(RouteNames.settings);

// Pop current route
context.pop();

// Replace current route
context.replace(RouteNames.login);
```

## Provider Dependency Injection

### Service Locator (`lib/core/di/service_locator.dart`)

Uses GetIt for **non-reactive** dependencies:
- External services (http.Client, SharedPreferences, Connectivity)
- Network utilities (ApiClient, NetworkInfo)
- Repositories
- Use cases

**Initialization**:
```dart
await initializeDependencies();
```

**Usage**:
```dart
final apiClient = getIt<ApiClient>();
final networkInfo = getIt<NetworkInfo>();
```

### Providers (`lib/core/di/providers.dart`)

Uses Provider for **reactive** ViewModels:
- ViewModels that extend ChangeNotifier
- State that needs to trigger UI updates

**Current providers**:
- `SettingsViewModel`: Theme and locale management

**Adding new providers**:
```dart
ChangeNotifierProvider<YourViewModel>(
  create: (_) => YourViewModel(
    useCase: getIt<YourUseCase>(),
  ),
),
```

## Example Pages

### Splash Page
- Animated splash screen with logo
- Auto-navigates to home after 2 seconds
- Ideal for initialization tasks

### Home Page
- Counter example
- Navigation drawer
- Quick actions (theme toggle, language toggle)
- Demonstrates Provider consumption

### Settings Page
- Theme selection (Light/Dark/System)
- Language selection (English/Thai)
- Quick toggles
- Reset to defaults
- Demonstrates ViewModel interaction

## Usage Examples

### Consuming a ViewModel

```dart
// Watch for changes (rebuilds on change)
final viewModel = context.watch<SettingsViewModel>();

// Read once (no rebuilds)
final viewModel = context.read<SettingsViewModel>();

// Select specific property (rebuilds only when this property changes)
final themeMode = context.select<SettingsViewModel, ThemeMode>(
  (vm) => vm.themeMode,
);
```

### SettingsViewModel Features

```dart
// Theme Management
viewModel.setThemeMode(ThemeMode.dark);
viewModel.toggleTheme();
viewModel.setLightTheme();
viewModel.setDarkTheme();
viewModel.setSystemTheme();

// Language Management
viewModel.setLocale(Locale('th'));
viewModel.toggleLanguage();
viewModel.setEnglish();
viewModel.setThai();

// Reset
viewModel.resetSettings();

// State
viewModel.themeMode;
viewModel.locale;
viewModel.isLoading;
viewModel.isDarkMode;
```

## Adding New Features

### 1. Add a New Route

**Step 1**: Add route constant
```dart
// lib/core/router/route_names.dart
static const String profile = '/profile';
```

**Step 2**: Create page
```dart
// lib/presentation/pages/profile_page.dart
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('Profile Page')),
    );
  }
}
```

**Step 3**: Register route
```dart
// lib/core/router/app_router.dart
GoRoute(
  path: RouteNames.profile,
  name: 'profile',
  pageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    child: const ProfilePage(),
  ),
),
```

### 2. Add a New ViewModel

**Step 1**: Create ViewModel
```dart
// lib/presentation/viewmodels/user_viewmodel.dart
class UserViewModel extends ChangeNotifier {
  final GetUserUseCase _getUserUseCase;

  UserViewModel({required GetUserUseCase getUserUseCase})
      : _getUserUseCase = getUserUseCase;

  User? _user;
  User? get user => _user;

  Future<void> loadUser() async {
    final result = await _getUserUseCase();
    result.fold(
      (failure) => _user = null,
      (user) => _user = user,
    );
    notifyListeners();
  }
}
```

**Step 2**: Register use case in GetIt
```dart
// lib/core/di/service_locator.dart
getIt.registerLazySingleton(() => GetUserUseCase(getIt()));
```

**Step 3**: Register ViewModel in Provider
```dart
// lib/core/di/providers.dart
ChangeNotifierProvider<UserViewModel>(
  create: (_) => UserViewModel(
    getUserUseCase: getIt<GetUserUseCase>(),
  ),
),
```

**Step 4**: Use in UI
```dart
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userViewModel = context.watch<UserViewModel>();

    return Scaffold(
      body: userViewModel.user == null
        ? CircularProgressIndicator()
        : Text('Hello ${userViewModel.user!.name}'),
    );
  }
}
```

### 3. Add Authentication Guard

Update redirect logic in `app_router.dart`:

```dart
redirect: (BuildContext context, GoRouterState state) {
  final authViewModel = context.read<AuthViewModel>();
  final isAuthenticated = authViewModel.isAuthenticated;
  final isAuthRoute = state.matchedLocation == RouteNames.login;

  // Redirect to login if not authenticated
  if (!isAuthenticated && !isAuthRoute) {
    return RouteNames.login;
  }

  // Redirect to home if authenticated and on login page
  if (isAuthenticated && isAuthRoute) {
    return RouteNames.home;
  }

  return null; // No redirect
},
```

### 4. Pass Parameters in Routes

**Option 1: Path Parameters**
```dart
// Route definition
GoRoute(
  path: '/user/:id',
  builder: (context, state) {
    final userId = state.pathParameters['id']!;
    return UserDetailPage(userId: userId);
  },
),

// Navigation
context.go('/user/123');
```

**Option 2: Query Parameters**
```dart
// Route definition
GoRoute(
  path: '/search',
  builder: (context, state) {
    final query = state.uri.queryParameters['q'];
    return SearchPage(query: query);
  },
),

// Navigation
context.go('/search?q=flutter');
```

**Option 3: Extra Data**
```dart
// Navigation
context.push(
  RouteNames.userDetail,
  extra: User(id: '123', name: 'John'),
);

// Route definition
GoRoute(
  path: RouteNames.userDetail,
  builder: (context, state) {
    final user = state.extra as User;
    return UserDetailPage(user: user);
  },
),
```

## Best Practices

1. **Use GetIt for**: Repositories, Use Cases, Services (non-reactive)
2. **Use Provider for**: ViewModels (reactive state that drives UI)
3. **Navigation**: Always use `RouteNames` constants, never hardcode paths
4. **State Management**:
   - `context.watch()` for reactive UI updates
   - `context.read()` for one-time access (callbacks)
   - `context.select()` for specific property subscriptions
5. **ViewModel**:
   - Call `notifyListeners()` after state changes
   - Keep business logic in use cases, not ViewModels
   - ViewModels orchestrate use cases and manage UI state
6. **Error Handling**:
   - Handle errors in ViewModels
   - Show errors in UI using state properties
   - Use Either<Failure, Success> pattern from dartz

## Testing

### Unit Testing ViewModels
```dart
test('should toggle theme mode', () {
  final viewModel = SettingsViewModel(
    sharedPreferences: mockSharedPreferences,
  );

  viewModel.toggleTheme();

  expect(viewModel.themeMode, ThemeMode.dark);
});
```

### Widget Testing with Provider
```dart
testWidgets('should display settings', (tester) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsViewModel>(
          create: (_) => mockSettingsViewModel,
        ),
      ],
      child: MaterialApp(home: SettingsPage()),
    ),
  );

  expect(find.text('Settings'), findsOneWidget);
});
```

## Troubleshooting

### Provider Not Found
```
Error: Could not find the correct Provider<YourViewModel>
```
**Solution**: Ensure ViewModel is added to `providers.dart` and the widget is within the Provider scope.

### Route Not Found
```
Error: no routes for location: /your-route
```
**Solution**: Verify route is defined in `app_router.dart` with correct path.

### GetIt Not Registered
```
Error: Object/factory with type YourType is not registered
```
**Solution**: Register the dependency in `service_locator.dart` before use.

## Summary

This architecture provides:
- Clean separation between navigation and business logic
- Reactive state management with Provider
- Dependency injection with GetIt
- Type-safe routing with GoRouter
- Scalable structure for growing applications

All navigation, state management, and dependency injection follow Flutter best practices and the MVVM Clean Architecture pattern.
