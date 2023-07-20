import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final int zegoCloudAppId = int.parse(dotenv.get("ZEGOCLOUD_APP_ID"));
  static final String zeroCloudAppSign = dotenv.get("ZEGOCLOUD_APP_SIGN");
}
