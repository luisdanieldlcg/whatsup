import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, Brightness>(
  (ref) => ThemeNotifier(),
  name: (ThemeNotifier).toString(),
);

class ThemeNotifier extends StateNotifier<Brightness> {
  ThemeNotifier() : super(_systemBrightness);

  static Brightness get _systemBrightness {
    return SchedulerBinding.instance.platformDispatcher.platformBrightness;
  }

  void toggle() {
    state = state == Brightness.dark ? Brightness.light : Brightness.dark;
  }
}

const kPrimaryColor = Color.fromRGBO(0, 167, 131, 1);
const kDarkBgColor = Color.fromRGBO(19, 28, 33, 1);
const kTextHighlightColor = Color.fromRGBO(58, 113, 253, 1);
final lightTheme = ThemeData.light().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: kPrimaryColor,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPrimaryColor,
      foregroundColor: Colors.black,
    ),
  ),
  useMaterial3: true,
);

final darkTheme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
  scaffoldBackgroundColor: kDarkBgColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPrimaryColor,
      foregroundColor: Colors.black,
    ),
  ),
  useMaterial3: true,
);
