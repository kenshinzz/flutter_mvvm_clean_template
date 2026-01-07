import 'dart:async';

import 'package:alchemist/alchemist.dart';

/// Global test configuration for Flutter tests
/// This file is automatically loaded by flutter_test
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Configure Alchemist for golden tests
  return AlchemistConfig.runWithConfig(
    config: const AlchemistConfig(
      // Use platform-agnostic rendering for CI compatibility
      platformGoldensConfig: PlatformGoldensConfig(enabled: true),
      // CI-friendly golden tests that work across platforms
      ciGoldensConfig: CiGoldensConfig(enabled: true),
    ),
    run: testMain,
  );
}
