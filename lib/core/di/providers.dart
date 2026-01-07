import 'package:provider/provider.dart';
import 'package:mvvm_clean_template/core/di/service_locator.dart';
import 'package:mvvm_clean_template/presentation/viewmodels/settings_viewmodel.dart';

/// Configure all providers for the application
/// This uses Provider for reactive state management of ViewModels
List<ChangeNotifierProvider> getProviders() {
  return [
    // Settings ViewModel
    ChangeNotifierProvider<SettingsViewModel>(
      create: (_) => SettingsViewModel(
        sharedPreferences: getIt(),
      ),
    ),

    // Add more ViewModels here as your app grows
    // Example:
    // ChangeNotifierProvider<AuthViewModel>(
    //   create: (_) => AuthViewModel(
    //     loginUseCase: getIt<LoginUseCase>(),
    //     logoutUseCase: getIt<LogoutUseCase>(),
    //   ),
    // ),
    //
    // ChangeNotifierProvider<UserViewModel>(
    //   create: (_) => UserViewModel(
    //     getUserUseCase: getIt<GetUserUseCase>(),
    //     updateUserUseCase: getIt<UpdateUserUseCase>(),
    //   ),
    // ),
  ];
}

/// Alternative approach: Use ProxyProvider for ViewModels that depend on other providers
/// Example:
/// ProxyProvider<AuthViewModel, UserViewModel>(
///   update: (context, auth, previous) => UserViewModel(
///     authToken: auth.token,
///     getUserUseCase: getIt<GetUserUseCase>(),
///   ),
/// ),

/// For streams or futures, use StreamProvider or FutureProvider
/// Example:
/// StreamProvider<User>(
///   create: (_) => userRepository.watchUser(),
///   initialData: User.empty(),
/// ),
