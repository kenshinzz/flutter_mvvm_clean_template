/// Riverpod Providers Configuration
///
/// All Riverpod providers are defined directly in their respective files:
/// - SettingsNotifier: lib/presentation/viewmodels/settings_viewmodel.dart
///
/// This file serves as a barrel export for all providers and can be extended for:
/// - Provider overrides for testing
/// - Provider observers for logging
/// - Centralized provider exports
library;

export 'package:mvvm_clean_template/presentation/viewmodels/settings_viewmodel.dart'
    show SettingsNotifier, SettingsState, settingsProvider;

// Future providers can be exported here as well:
// export 'package:mvvm_clean_template/presentation/viewmodels/auth_viewmodel.dart'
//     show authProvider, AuthNotifier, AuthState;
//
// export 'package:mvvm_clean_template/presentation/viewmodels/product_viewmodel.dart'
//     show productProvider, ProductNotifier, ProductState;
