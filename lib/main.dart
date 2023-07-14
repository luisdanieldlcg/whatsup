import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/common/theme.dart';
import 'package:flutter_firebase_template/common/util/logger.dart';
import 'package:flutter_firebase_template/features/welcome/pages/welcome.dart';
import 'package:flutter_firebase_template/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'common/util/run_mode.dart';

final Logger logger = AppLogger.getLogger('init');

void main() {
  logger.i("Initializing app in ${RunModeExtension.currentMode.name} mode");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      observers: [ProviderStateChangeObserver()],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeNotifier == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
      onGenerateRoute: PageRouter.generateRoutes,
      home: const WelcomePage(),
    );
  }
}
