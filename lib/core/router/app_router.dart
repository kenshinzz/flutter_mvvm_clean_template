import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speckit_flutter_template/core/router/route_names.dart';
import 'package:speckit_flutter_template/presentation/pages/home_page.dart';
import 'package:speckit_flutter_template/presentation/pages/settings_page.dart';
import 'package:speckit_flutter_template/presentation/pages/splash_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => _ErrorPage(error: state.error.toString()),
    routes: [
      // Splash Route
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const SplashPage()),
      ),

      // Home Route
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const HomePage()),
      ),

      // Settings Route
      GoRoute(
        path: RouteNames.settings,
        name: 'settings',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const SettingsPage()),
      ),

      // Auth Routes (for future implementation)
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const _ComingSoonPage(title: 'Login'),
        ),
      ),

      GoRoute(
        path: RouteNames.register,
        name: 'register',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const _ComingSoonPage(title: 'Register'),
        ),
      ),

      // Profile Routes (for future implementation)
      GoRoute(
        path: RouteNames.profile,
        name: 'profile',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const _ComingSoonPage(title: 'Profile'),
        ),
      ),
    ],

    // Redirect logic (e.g., for authentication)
    // Example: Check if user is authenticated
    // final isAuthenticated = false; // Replace with actual auth check
    // Uncomment to implement authentication redirect
    // if (!isAuthenticated && state.matchedLocation != RouteNames.login) {
    //   return RouteNames.login;
    // }
    redirect: (context, state) => null, // No redirect
  );
}

// Error Page Widget
class _ErrorPage extends StatelessWidget {
  const _ErrorPage({required this.error});
  final String error;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 80),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.go(RouteNames.home),
              icon: const Icon(Icons.home),
              label: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

// Coming Soon Page Widget (for unimplemented routes)
class _ComingSoonPage extends StatelessWidget {
  const _ComingSoonPage({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 100,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Coming Soon',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'This feature is under development',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.go(RouteNames.home),
            icon: const Icon(Icons.home),
            label: const Text('Go to Home'),
          ),
        ],
      ),
    ),
  );
}
