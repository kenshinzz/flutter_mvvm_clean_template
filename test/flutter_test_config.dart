import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';

/// Global test configuration for Flutter tests
/// This file is automatically loaded by flutter_test
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Detect if running in CI environment
  final isCI = Platform.environment['CI'] == 'true' ||
      Platform.environment['GITHUB_ACTIONS'] == 'true';

  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      // Disable platform-specific goldens - they differ between macOS/Linux/Windows
      platformGoldensConfig: const PlatformGoldensConfig(enabled: false),
      // Use only CI goldens which are platform-agnostic
      ciGoldensConfig: CiGoldensConfig(
        enabled: true,
        // In CI, compare against existing goldens
        // Locally, you can update them with --update-goldens
        obscureText: !isCI,
        renderShadows: !isCI,
      ),
    ),
    run: testMain,
  );
}
