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

final lightTheme = ThemeData.light().copyWith(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
);

final darkTheme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
);
