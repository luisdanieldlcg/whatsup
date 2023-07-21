import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:whatsup/common/util/logger.dart';

class AppConfig {
  static final Logger _logger = AppLogger.getLogger('AppConfig');
  static final int zegoCloudAppId = int.parse(dotenv.get("ZEGOCLOUD_APP_ID"));
  static final String zeroCloudAppSign = dotenv.get("ZEGOCLOUD_APP_SIGN");

  static final _androidSettings = FirebaseOptions(
    apiKey: dotenv.get("FIREBASE_ANDROID_API_KEY"),
    appId: dotenv.get("FIREBASE_ANDROID_APP_ID"),
    messagingSenderId: dotenv.get("FIREBASE_MESSAGING_SENDER_ID"),
    projectId: dotenv.get("FIREBASE_PROJECT_ID"),
    storageBucket: dotenv.get("FIREBASE_STORAGE_BUCKET"),
  );
  static final _iosSettings = FirebaseOptions(
    apiKey: dotenv.get("FIREBASE_IOS_API_KEY"),
    appId: dotenv.get("FIREBASE_IOS_APP_ID"),
    messagingSenderId: dotenv.get("FIREBASE_MESSAGING_SENDER_ID"),
    projectId: dotenv.get("FIREBASE_PROJECT_ID"),
    storageBucket: dotenv.get("FIREBASE_STORAGE_BUCKET"),
    iosClientId: dotenv.get("FIREBASE_IOS_CLIENT_ID"),
    iosBundleId: dotenv.get("FIREBASE_IOS_BUNDLE_ID"),
  );

  static FirebaseOptions get firebaseSettings {
    _logger.d("Running on ${defaultTargetPlatform.toString()} platform");
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _androidSettings;
      case TargetPlatform.iOS:
        return _iosSettings;
      default:
        throw UnsupportedError(
          'The platform: ${defaultTargetPlatform.toString()} is not currently supported.',
        );
    }
  }
}
