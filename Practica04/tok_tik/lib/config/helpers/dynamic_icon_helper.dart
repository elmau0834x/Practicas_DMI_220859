import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DynamicIconHelper {
  static const MethodChannel _channel = MethodChannel('com.toktik.app/icon');

  static Future<void> changeIcon(String season) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return;
    }

    await _channel.invokeMethod<void>('setIcon', season);
  }
}
