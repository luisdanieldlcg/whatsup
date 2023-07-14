import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/constants.dart';
import 'package:whatsup/common/util/logger.dart';
import 'package:whatsup/features/welcome/pages/welcome.dart';
import 'package:whatsup/firebase_options.dart';
import 'package:whatsup/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'common/util/run_mode.dart';

final Logger logger = AppLogger.getLogger('init');

void main() async {
  logger.i("Initializing app in ${RunModeExtension.currentMode.name} mode");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      title: kAppName,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeNotifier == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
      onGenerateRoute: PageRouter.generateRoutes,
      home: const WelcomePage(),
    );
  }
}
