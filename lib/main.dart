import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';
import 'core/database/app_database.dart';
import 'core/di/providers.dart';
import 'services/media_scanner_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // media_kit must be initialised before any Player is created.
  MediaKit.ensureInitialized();

  // Non-blocking UI config — these don't need to complete before runApp.
  unawaited(SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]));

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  final database = AppDatabase();

  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
      ],
      child: const MxVideoApp(),
    ),
  );

  // Deferred: WorkManager init doesn't need to block startup.
  unawaited(Workmanager().initialize(callbackDispatcher));
}
