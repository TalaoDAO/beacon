//  Copyright (c) 2022 Altme.
//  Licensed under Apache License v2.0 that can be
//  found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'beacon_platform_interface.dart';
import 'enums/enums.dart';

/// An implementation of [BeaconPlatform] that uses method channels.
class MethodChannelBeacon extends BeaconPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('beaconMethod');

  /// The event channel used to interact with the native platform.
  @visibleForTesting
  final eventChannel = const EventChannel('beaconEvent');

  /// Initialize beacon with walletName
  @override
  Future<Map> startBeacon({required String walletName}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("walletName", () => walletName);
    Map data = await methodChannel.invokeMethod('startBeacon', args);
    return data;
  }

  /// Pair wallet with dApp using [pairingRequest]
  @override
  Future<Map> pair({required String pairingRequest}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("pairingRequest", () => pairingRequest);
    Map data = await methodChannel.invokeMethod('pair', args);
    return data;
  }

  /// Pair wallet with dApp using [P2PPeer] data
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
    dynamic data = await methodChannel.invokeMethod('addPeer', args);
    if (data is String) {
      return jsonDecode(data);
    }
    return data;
  }

  /// remove all peers
  @override
  Future<Map> removePeers() async {
    Map data = await methodChannel.invokeMethod('removePeers');
    return data;
  }

  /// example responses to test
  @override
  Future<void> respondExample() async {
    await methodChannel.invokeMethod('respondExample');
    return;
  }

  /// listen to beacon response
  /// * [RequestType.permission] permission response
  /// * [RequestType.signPayload] sign payload response
  /// * [RequestType.operation] operation response
  /// * [RequestType.broadcast] broadcast response
  @override
  Stream<String> getBeaconResponse() {
    return eventChannel.receiveBroadcastStream().cast();
  }

  /// pause connection with dApp
  /// support iOS only
  @override
  Future<Map> pause() async {
    Map data = await methodChannel.invokeMethod('pause');
    return data;
  }

  /// resume connection with dApp
  /// support iOS only
  @override
  Future<Map> resume() async {
    Map data = await methodChannel.invokeMethod('resume');
    return data;
  }

  /// stop connection with dApp
  /// support iOS only
  @override
  Future<Map> stop() async {
    Map data = await methodChannel.invokeMethod('stop');
    return data;
  }

  /// remove connection with single dApp using [publicKey]
  @override
  Future<Map> removePeer({required String publicKey}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("publicKey", () => publicKey);
    Map data = await methodChannel.invokeMethod('removePeer', args);
    return data;
  }

  /// get list of daPPs connected
  @override
  Future<Map> getPeers() async {
    dynamic data = await methodChannel.invokeMethod('getPeers');
    if (data is String) {
      return jsonDecode(data);
    }
    return data;
  }

  /// send permission response
  /// [id] beacon request id
  /// [publicKey] public key of crypto account
  /// [address] wallet address key of crypto account
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

  /// send sign payload response
  /// [id] beacon request id
  /// [signature] signature using payload
  /// [type] signing type of payload
  @override
  Future<Map> signPayloadResponse({
    required String id,
    required String? signature,
    SigningType type = SigningType.micheline,
  }) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("id", () => id);
    args.putIfAbsent("signature", () => signature);
    args.putIfAbsent("type", () => describeEnum(type));
    Map data = await methodChannel.invokeMethod('tezosResponse', args);
    return data;
  }

  /// send operation response
  /// [id] beacon request id
  /// [transactionHash] transactionHash from the operation
  @override
  Future<Map> operationResponse(
      {required String id, required String? transactionHash}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("id", () => id);
    args.putIfAbsent("transactionHash", () => transactionHash);
    Map data = await methodChannel.invokeMethod('tezosResponse', args);
    return data;
  }

  /// send broadcast response
  /// [id] beacon request id
  /// [transactionHash] transactionHash using signedTransaction
  @override
  Future<Map> broadcastResponse(
      {required String id, required String? transactionHash}) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("id", () => id);
    args.putIfAbsent("transactionHash", () => transactionHash);
    Map data = await methodChannel.invokeMethod('tezosResponse', args);
    return data;
  }
}
