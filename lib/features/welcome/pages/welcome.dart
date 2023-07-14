import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/common/theme.dart';
import 'package:flutter_firebase_template/common/util/misc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              const Text(
                "Welcome Page",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              const Text("The default theme is same as system theme"),
              const SizedBox(height: 20),
              const Text("Enable dark mode"),
              const SizedBox(height: 20),
              Switch(
                value: themeMode == Brightness.dark,
                onChanged: (_) {
                  ref.read(themeNotifierProvider.notifier).toggle();
                  showSnackbar(
                    context,
                    "Your theme has been switched to ${themeMode == Brightness.dark ? 'dark' : 'light'}",
                  );
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
