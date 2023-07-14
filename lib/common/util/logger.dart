import 'package:whatsup/common/util/run_mode.dart';
import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLogger {
  static Logger getLogger(String className) {
    return Logger(
      printer: AppLogPrinter(
        className: className,
      ),
      level: _findlevel(),
    );
  }

  static Level _findlevel() {
    final runMode = RunModeExtension.currentMode;
    if (runMode.isRelease) {
      return Level.error;
    }
    if (runMode.isProfile) {
      return Level.warning;
    }
    return Level.verbose;
  }
}

class AppLogPrinter extends LogPrinter {
  final String className;

  AppLogPrinter({
    required this.className,
  });

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.levelColors[event.level];
    final emoji = PrettyPrinter.levelEmojis[event.level]!;
    final emojiOutput = emoji.replaceAll(' ', '');
    final message = event.message;
    final time = DateTime.now();
    return [
      color!(
        "[${time.hour}:${time.minute}:${time.second}] [$className/${event.level.name.toUpperCase()}]$emojiOutput: $message",
      ),
    ];
  }
}

class ProviderStateChangeObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    // Log the new state provider state for debugging purposes
    AppLogger.getLogger(provider.name ?? 'provider').d('New state: $newValue');
  }
}
