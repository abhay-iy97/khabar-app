import 'dart:io';

import 'package:news/plugins/platform/myplatform.dart';

class PlatformUtil {
  static MyPlatform myPlatform() {
    if (Platform.isAndroid) return MyPlatform.ANDROID;
    if (Platform.isIOS) return MyPlatform.IOS;
  }
}
