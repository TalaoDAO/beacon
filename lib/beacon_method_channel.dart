import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'beacon_platform_interface.dart';

/// An implementation of [BeaconPlatform] that uses method channels.
class MethodChannelBeacon extends BeaconPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('beacon');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
