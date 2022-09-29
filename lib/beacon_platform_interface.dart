//  Copyright (c) 2022 Altme.
//  Licensed under Apache License v2.0 that can be
//  found in the LICENSE file.

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'beacon_method_channel.dart';

abstract class BeaconPlatform extends PlatformInterface {
  BeaconPlatform() : super(token: _token);

  static final Object _token = Object();

  /// The default instance of [BeaconPlatform] to use.
  ///
  /// Defaults to [MethodChannelBeacon].
  static BeaconPlatform _instance = MethodChannelBeacon();

  /// The default instance of [BeaconPlatform] to use.
  ///
  /// Defaults to [MethodChannelBeacon].
  static BeaconPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [MethodChannelBeacon] when they register themselves.
  static set instance(BeaconPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initialize beacon
  Future<Map> startBeacon() async {
    throw UnimplementedError('startBeacon() has not been implemented.');
  }

  /// Pair wallet with dApp using [pairingRequest]
  Future<Map> pair({required String pairingRequest}) {
    throw UnimplementedError('pair() has not been implemented.');
  }

  /// Pair wallet with dApp using [P2PPeer] data
  Future<Map> addPeer({
    required String id,
    required String name,
    required String publicKey,
    required String relayServer,
    required String version,
  }) async {
    throw UnimplementedError('addPeer() has not been implemented.');
  }

  /// remove all peers
  Future<Map> removePeers() async {
    throw UnimplementedError('removePeers() has not been implemented.');
  }

  /// example responses to test
  Future<void> respondExample() async {
    throw UnimplementedError('respondExample() has not been implemented.');
  }

  /// listen to beacon response
  /// * [RequestType.permission] permission response
  /// * [RequestType.signPayload] sign payload response
  /// * [RequestType.operation] operation response
  /// * [RequestType.broadcast] broadcast response
  Stream<String> getBeaconResponse() {
    throw UnimplementedError('getBeaconResponse() has not been implemented.');
  }

  /// pause connection with dApp
  /// support iOS only
  Future<Map> pause() async {
    throw UnimplementedError('pause() has not been implemented.');
  }

  /// resume connection with dApp
  /// support iOS only
  Future<Map> resume() async {
    throw UnimplementedError('resume() has not been implemented.');
  }

  /// stop connection with dApp
  /// support iOS only
  Future<Map> stop() async {
    throw UnimplementedError('stop() has not been implemented.');
  }

  /// remove connection with single dApp using [publicKey]
  Future<Map> removePeer({required String publicKey}) async {
    throw UnimplementedError('removePeer() has not been implemented.');
  }

  /// get list of daPPs connected
  Future<Map> getPeers() async {
    throw UnimplementedError('getPeers() has not been implemented.');
  }

  /// send permission response
  /// [id] beacon request id
  /// [publicKey] public key of crypto account
  /// [address] wallet address key of crypto account
  Future<Map> permissionResponse({
    required String id,
    required String? publicKey,
    required String? address,
  }) async {
    throw UnimplementedError('permissionResponse() has not been implemented.');
  }

  /// send sign payload response
  /// [id] beacon request id
  /// [signature] signature using payload
  Future<Map> signPayloadResponse(
      {required String id, required String? signature}) async {
    throw UnimplementedError('signPayloadResponse() has not been implemented.');
  }

  /// send operation response
  /// [id] beacon request id
  /// [transactionHash] transactionHash from the operation
  Future<Map> operationResponse(
      {required String id, required String? transactionHash}) {
    throw UnimplementedError('operationResponse() has not been implemented.');
  }

  /// send broadcast response
  /// [id] beacon request id
  /// [transactionHash] transactionHash using signedTransaction
  Future<Map> broadcastResponse(
      {required String id, required String? transactionHash}) {
    throw UnimplementedError('broadcastResponse() has not been implemented.');
  }
}
