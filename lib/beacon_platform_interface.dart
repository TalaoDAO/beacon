import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'beacon_method_channel.dart';

abstract class BeaconPlatform extends PlatformInterface {
  BeaconPlatform() : super(token: _token);

  static final Object _token = Object();

  static BeaconPlatform _instance = MethodChannelBeacon();

  static BeaconPlatform get instance => _instance;

  static set instance(BeaconPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<Map> startBeacon() {
    throw UnimplementedError('startBeacon() has not been implemented.');
  }

  Future<Map> pair({required String pairingRequest}) {
    throw UnimplementedError('pair() has not been implemented.');
  }

  Future<Map> removePeers() {
    throw UnimplementedError('removePeers() has not been implemented.');
  }

  Future<void> respondExample() {
    throw UnimplementedError('respondExample() has not been implemented.');
  }

  Stream<String> getBeaconResponse() {
    throw UnimplementedError('getBeaconResponse() has not been implemented.');
  }
}
