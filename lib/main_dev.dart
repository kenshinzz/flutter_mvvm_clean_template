import 'package:flutter/material.dart';
import 'package:mvvm_clean_template/core/config/app_config.dart';
import 'package:mvvm_clean_template/core/config/env_config.dart';
import 'package:mvvm_clean_template/main.dart' as app;

/// Entry point for development environment
/// Run with: flutter run -t lib/main_dev.dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.init(Environment.dev);
  app.main();
}
