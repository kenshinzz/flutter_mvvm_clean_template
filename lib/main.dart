import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_clean_template/core/di/providers.dart';
import 'package:mvvm_clean_template/core/di/service_locator.dart';
import 'package:mvvm_clean_template/core/router/app_router.dart';
import 'package:mvvm_clean_template/core/theme/app_theme.dart';
import 'package:mvvm_clean_template/l10n/app_localizations.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies (GetIt)
  await initializeDependencies();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp.router(
      title: 'MVVM Clean Template',
      debugShowCheckedModeBanner: false,

      // Router Configuration
      routerConfig: AppRouter.router,

      // Theme Configuration - Now controlled by SettingsNotifier
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,

      // Localization Configuration - Now controlled by SettingsNotifier
      locale: settings.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', ''), Locale('th', '')],
    );
  }
}
