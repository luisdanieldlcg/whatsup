import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, Brightness>(
  (ref) => ThemeNotifier(),
  name: (ThemeNotifier).toString(),
);

class ThemeNotifier extends StateNotifier<Brightness> {
  ThemeNotifier() : super(_systemBrightness);

  static Brightness get _systemBrightness {
    // return SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return Brightness.light;
  }

  void toggle() {
    state = state == Brightness.dark ? Brightness.light : Brightness.dark;
  }
}

const kPrimaryColor = Color.fromRGBO(18, 140, 126, 1);
const kDarkBgColor = Color.fromRGBO(19, 28, 33, 1);
const kLightBgColor = Color.fromRGBO(246, 244, 244, 1);
const kTextHighlightColor = Color.fromRGBO(58, 113, 253, 1);
const kDarkAppBarColor = Color.fromRGBO(31, 44, 52, 1);
const kUnselectedLabelColor = Color.fromRGBO(190, 196, 201, 1);

final lightTheme = ThemeData.light().copyWith(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: kPrimaryColor,
  ),
  scaffoldBackgroundColor: kLightBgColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPrimaryColor,
      elevation: 1.0,
    ),
  ),
);

final darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: kDarkBgColor,
  colorScheme: ColorScheme.fromSeed(
    seedColor: kPrimaryColor,
    brightness: Brightness.dark,
  ),
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    color: kDarkAppBarColor,
    foregroundColor: Colors.white,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: kDarkBgColor,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 1.0,
      backgroundColor: kPrimaryColor,
      foregroundColor: Colors.black,
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: kPrimaryColor.withOpacity(0.25).withAlpha(65),
    contentTextStyle: const TextStyle(color: Colors.white),
  ),
  // set underline text field color same as kPrimaryColor
  inputDecorationTheme: const InputDecorationTheme(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
    ),
  ),
);
