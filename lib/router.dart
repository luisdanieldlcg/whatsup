import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/common/util/logger.dart';
import 'package:flutter_firebase_template/features/auth/pages/login.dart';
import 'package:flutter_firebase_template/features/welcome/pages/welcome.dart';

class PageRouter {
  static const String welcome = '/welcome';
  static const String login = 'auth/login';

  static Route<Widget> generateRoutes(RouteSettings settings) {
    AppLogger.getLogger((PageRouter).toString()).d('Navigating to ${settings.name}');
    switch (settings.name) {
      case welcome:
        return _createRoute(const WelcomePage());
      case login:
        return _createRoute(const LoginPage());
      default:
        return _createRoute(UnknownRoutePage(targetRoute: settings.name!));
    }
  }

  static Route<Widget> _createRoute(Widget child) {
    return MaterialPageRoute<Widget>(
      builder: (_) => child,
    );
  }
}

class UnknownRoutePage extends StatelessWidget {
  final String targetRoute;
  const UnknownRoutePage({
    super.key,
    required this.targetRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "The route '$targetRoute' was not found.",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
