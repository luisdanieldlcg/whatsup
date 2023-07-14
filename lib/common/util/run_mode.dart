import 'package:flutter/foundation.dart';

enum RunMode { release, profile, debug }

extension RunModeExtension on RunMode {
  static RunMode get currentMode {
    if (kReleaseMode) return RunMode.release;
    if (kProfileMode) return RunMode.profile;
    return RunMode.debug;
  }

  String get name {
    switch (this) {
      case RunMode.release:
        return 'release';
      case RunMode.profile:
        return 'profile';
      case RunMode.debug:
        return 'debug';
    }
  }

  bool get isRelease => this == RunMode.release;
  bool get isProfile => this == RunMode.profile;
  bool get isDebug => this == RunMode.debug;
}
