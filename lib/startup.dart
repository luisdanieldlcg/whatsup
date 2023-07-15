import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/repositories/user.dart';
import 'package:whatsup/common/util/logger.dart';
import 'package:whatsup/features/home/pages/home.dart';
import 'package:whatsup/features/welcome/pages/welcome.dart';

class StartUp extends ConsumerWidget {
  static final _logger = AppLogger.getLogger((StartUp).toString());
  const StartUp({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userFetchProvider).when(
          data: (user) {
            return user.match(
              () {
                _logger.d("No user found, redirecting to WelcomePage");
                return const WelcomePage();
              },
              (_) {
                _logger.d("There is an active session, redirecting to HomePage");
                return const HomePage();
              },
            );
          },
          error: (err, trace) {
            return Scaffold(
              body: Text(err.toString()),
            );
          },
          loading: () => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
  }
}
