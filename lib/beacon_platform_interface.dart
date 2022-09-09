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

  Future<Map> startBeacon() async {
    throw UnimplementedError('startBeacon() has not been implemented.');
  }

  Future<Map> pair({required String pairingRequest}) {
    throw UnimplementedError('pair() has not been implemented.');
  }

  Future<Map> addPeer({
    required String id,
    required String name,
    required String publicKey,
    required String relayServer,
    required String version,
  }) async {
    throw UnimplementedError('addPeer() has not been implemented.');
  }

  Future<Map> removePeers() async {
    throw UnimplementedError('removePeers() has not been implemented.');
  }

  Future<void> respondExample() async {
    throw UnimplementedError('respondExample() has not been implemented.');
  }

  Stream<String> getBeaconResponse() {
    throw UnimplementedError('getBeaconResponse() has not been implemented.');
  }

  Future<Map> pause() async {
    throw UnimplementedError('pause() has not been implemented.');
  }

  Future<Map> resume() async {
    throw UnimplementedError('resume() has not been implemented.');
  }

  Future<Map> stop() async {
    throw UnimplementedError('stop() has not been implemented.');
  }

  Future<Map> removePeer({required String publicKey}) async {
    throw UnimplementedError('removePeer() has not been implemented.');
  }

  Future<Map> getPeers() async {
    throw UnimplementedError('getPeers() has not been implemented.');
  }

  Future<Map> permissionResponse({
    required String id,
    required String publicKey,
    required String address,
  }) async {
    throw UnimplementedError('permissionResponse() has not been implemented.');
  }

  Future<Map> signPayloadResponse(
      {required String id, required String signature}) async {
    throw UnimplementedError('signPayloadResponse() has not been implemented.');
  }

  Future<Map> operationResponse(
      {required String id, required String transactionHash}) {
    throw UnimplementedError('operationResponse() has not been implemented.');
  }
}
