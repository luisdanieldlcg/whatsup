import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final int zegoCloudAppId = int.parse(dotenv.get("ZEGOCLOUD_APP_ID"));
  static final String zeroCloudAppSign = dotenv.get("ZEGOCLOUD_APP_SIGN");

  static FirebaseOptions get firebaseSettings {
    final runningOnIOS = defaultTargetPlatform == TargetPlatform.iOS;
    return FirebaseOptions(
      apiKey: dotenv.get("FIREBASE_API_KEY"),
      appId: dotenv.get("FIREBASE_APP_ID"),
      messagingSenderId: dotenv.get("FIREBASE_MESSAGING_SENDER_ID"),
      projectId: dotenv.get("FIREBASE_PROJECT_ID"),
      storageBucket: dotenv.get("FIREBASE_STORAGE_BUCKET"),
      iosBundleId: runningOnIOS ? dotenv.get("FIREBASE_IOS_BUNDLE_ID") : null,
      iosClientId: runningOnIOS ? dotenv.get("FIREBASE_IOS_CLIENT_ID") : null,
    );
  }
}
