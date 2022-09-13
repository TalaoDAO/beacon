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

  @override
  Future<Map> removePeer({required String publicKey}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("publicKey", () => publicKey);
    Map data = await methodChannel.invokeMethod('removePeer', args);
    return data;
  }

  @override
  Future<Map> getPeers() async {
    Map data = await methodChannel.invokeMethod('getPeers');
    return data;
  }

  @override
  Future<Map> permissionResponse({
    required String id,
    required String? publicKey,
    required String? address,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("id", () => id);
    args.putIfAbsent("publicKey", () => publicKey);
    args.putIfAbsent("address", () => address);
    Map data = await methodChannel.invokeMethod('tezosResponse', args);
    return data;
  }

  @override
  Future<Map> signPayloadResponse(
      {required String id, required String? signature}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("id", () => id);
    args.putIfAbsent("signature", () => signature);
    Map data = await methodChannel.invokeMethod('tezosResponse', args);
    return data;
  }

  @override
  Future<Map> operationResponse(
      {required String id, required String? transactionHash}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("id", () => id);
    args.putIfAbsent("transactionHash", () => transactionHash);
    Map data = await methodChannel.invokeMethod('tezosResponse', args);
    return data;
  }
}
