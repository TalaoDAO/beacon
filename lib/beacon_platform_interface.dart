import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'beacon_method_channel.dart';

abstract class BeaconPlatform extends PlatformInterface {
  /// Constructs a BeaconPlatform.
  BeaconPlatform() : super(token: _token);

  static final Object _token = Object();

  static BeaconPlatform _instance = MethodChannelBeacon();

  /// The default instance of [BeaconPlatform] to use.
  ///
  /// Defaults to [MethodChannelBeacon].
  static BeaconPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BeaconPlatform] when
  /// they register themselves.
  static set instance(BeaconPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
