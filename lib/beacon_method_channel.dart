import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'beacon_platform_interface.dart';

/// An implementation of [BeaconPlatform] that uses method channels.
class MethodChannelBeacon extends BeaconPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('beaconMethod');
  @visibleForTesting
  final eventChannel = const EventChannel('beaconEvent');

  @override
  Future<Map> startBeacon() async {
    Map data = await methodChannel.invokeMethod('startBeacon');
    return data;
  }

  @override
  Future<Map> pair({required String pairingRequest}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("pairingRequest", () => pairingRequest);
    Map data = await methodChannel.invokeMethod('pair', args);
    return data;
  }

  @override
  Future<Map> addPeer({
    required String id,
    required String name,
    required String publicKey,
    required String relayServer,
    required String version,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("id", () => id);
    args.putIfAbsent("name", () => name);
    args.putIfAbsent("publicKey", () => publicKey);
    args.putIfAbsent("relayServer", () => relayServer);
    args.putIfAbsent("version", () => version);
    Map data = await methodChannel.invokeMethod('addPeer', args);
    return data;
  }

  @override
  Future<Map> removePeers() async {
    Map data = await methodChannel.invokeMethod('removePeers');
    return data;
  }

  @override
  Future<void> respondExample() async {
    await methodChannel.invokeMethod('respondExample');
    return;
  }

  @override
  Stream<String> getBeaconResponse() {
    return eventChannel.receiveBroadcastStream().cast();
  }

  @override
  Future<Map> pause() async {
    Map data = await methodChannel.invokeMethod('pause');
    return data;
  }

  @override
  Future<Map> resume() async {
    Map data = await methodChannel.invokeMethod('resume');
    return data;
  }

  @override
  Future<Map> stop() async {
    Map data = await methodChannel.invokeMethod('stop');
    return data;
  }
}
