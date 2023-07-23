import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/constants.dart';
import 'package:whatsup/common/util/logger.dart';
import 'package:whatsup/config.dart';
import 'package:whatsup/features/call/service/call_invitation.dart';
import 'package:whatsup/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:whatsup/features/startup/pages/startup.dart';

import 'lib/common/util/run_mode.dart';

final Logger logger = AppLogger.getLogger('init');

void main() async {
  logger.i("Initializing app in ${RunModeExtension.currentMode.name} mode");
  await dotenv.load(fileName: '.env');
  final navigatorKey = GlobalKey<NavigatorState>();
  CallInvitationService.attachNavigatorKey(navigatorKey);
  CallInvitationService.useSysCallUI();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: dotenv.get("FIREBASE_PROJECT_ID"),
    options: AppConfig.firebaseSettings,
  );

  runApp(
    ProviderScope(
      observers: [ProviderStateChangeObserver()],
      child: App(navigatorKey: navigatorKey),
    ),
  );
}

class App extends ConsumerWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const App({
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider);
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: kAppName,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeNotifier == Brightness.light ? ThemeMode.light : ThemeMode.dark,
      onGenerateRoute: PageRouter.generateRoutes,
      home: const StartUp(),
    );
  }
}
