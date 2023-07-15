import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsup/common/theme.dart';
import 'package:whatsup/common/util/constants.dart';
import 'package:whatsup/common/widgets/primary_button.dart';
import 'package:whatsup/router.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeNotifierProvider) == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome to $kAppName",
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? kDarkBgColor : kLightBgColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Image.asset(
                  "assets/img/welcome_bg.png",
                  width: 240,
                  height: 240,
                  color: kPrimaryColor,
                ),
                const SizedBox(height: 50),
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "Read our "),
                      TextSpan(
                        text: "Privacy Policy. ",
                        style: TextStyle(color: kTextHighlightColor),
                      ),
                      TextSpan(text: "Tap \"Agree and continue\" to accept the "),
                      TextSpan(
                        text: "Terms of Service.",
                        style: TextStyle(color: kTextHighlightColor),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: 320,
                  child: PrimaryButton(
                    title: "AGREE AND CONTINUE",
                    onPressed: () => Navigator.pushNamed(context, PageRouter.login),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
