import 'package:flutter/material.dart';
import 'package:speckit_flutter_template/core/config/app_config.dart';
import 'package:speckit_flutter_template/core/config/env_config.dart';
import 'package:speckit_flutter_template/main.dart' as app;

/// Entry point for production environment
/// Run with: flutter run -t lib/main_prod.dart --release
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.init(Environment.prod);
  app.main();
}
