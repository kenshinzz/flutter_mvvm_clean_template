import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mvvm_clean_template/core/di/providers.dart';
import 'package:mvvm_clean_template/core/di/service_locator.dart';
import 'package:mvvm_clean_template/core/router/app_router.dart';
import 'package:mvvm_clean_template/core/theme/app_theme.dart';
import 'package:mvvm_clean_template/l10n/app_localizations.dart';
import 'package:mvvm_clean_template/presentation/viewmodels/settings_viewmodel.dart';
import 'package:provider/provider.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies (GetIt)
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) =>
      // Wrap the app with MultiProvider for reactive state management
      MultiProvider(
        providers: getProviders(),
        child: Consumer<SettingsViewModel>(
          builder: (context, settingsViewModel, child) => MaterialApp.router(
            title: 'MVVM Clean Template',
            debugShowCheckedModeBanner: false,

            // Router Configuration
            routerConfig: AppRouter.router,

            // Theme Configuration - Now controlled by SettingsViewModel
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsViewModel.themeMode,

            // Localization Configuration - Now controlled by SettingsViewModel
            locale: settingsViewModel.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', ''), Locale('th', '')],
          ),
        ),
      );
}
