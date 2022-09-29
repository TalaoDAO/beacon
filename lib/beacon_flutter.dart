//  Copyright (c) 2022 Altme.
//  Licensed under Apache License v2.0 that can be
//  found in the LICENSE file.

import 'dart:convert';

import 'beacon_platform_interface.dart';
export 'enums/enums.dart';
export 'models/models.dart';
import 'package:base_codecs/base_codecs.dart';

/// Provide Beacon API for both Android and iOS.
class Beacon {
  /// Initialize beacon
  Future<Map> startBeacon() async {
    return await BeaconPlatform.instance.startBeacon();
  }

  /// Pair wallet with dApp using [pairingRequest]
  Future<Map> pair({required String pairingRequest}) async {
    return await BeaconPlatform.instance.pair(pairingRequest: pairingRequest);
  }

  /// Pair wallet with dApp using [P2PPeer] data
  Future<Map> addPeer({required String pairingRequest}) async {
    Map p2pData = pairingRequestToP2P(pairingRequest: pairingRequest);
    return await BeaconPlatform.instance.addPeer(
      id: p2pData['id'],
      name: p2pData['name'],
      publicKey: p2pData['publicKey'],
      relayServer: p2pData['relayServer'],
      version: p2pData['version'],
    );
  }

  /// remove all peers
  Future<Map> removePeers() async {
    return await BeaconPlatform.instance.removePeers();
  }

  /// example responses to test
  Future<void> respondExample() async {
    await BeaconPlatform.instance.respondExample();
    return;
  }

  /// listen to beacon response
  /// * [RequestType.permission] permission response
  /// * [RequestType.signPayload] sign payload response
  /// * [RequestType.operation] operation response
  /// * [RequestType.broadcast] broadcast response
  Stream<String> getBeaconResponse() {
    return BeaconPlatform.instance.getBeaconResponse();
  }

  /// pause connection with dApp
  /// support iOS only
  Future<Map> pause() async {
    return await BeaconPlatform.instance.pause();
  }

  /// resume connection with dApp
  /// support iOS only
  Future<Map> resume() async {
    return await BeaconPlatform.instance.resume();
  }

  /// stop connection with dApp
  /// support iOS only
  Future<Map> stop() async {
    return await BeaconPlatform.instance.stop();
  }

  /// convert [pairingRequest] to [P2PPeer] data
  Map<String, dynamic> pairingRequestToP2P({required String pairingRequest}) {
    var uint8List = base58CheckDecode(pairingRequest);
    String decoded = utf8.decode(uint8List);
    Map<String, String> data = Map<String, String>.from(jsonDecode(decoded));
    return data;
  }

  /// remove connection with single dApp using [publicKey]
  Future<Map> removePeerUsingPublicKey({required String publicKey}) async {
    return await BeaconPlatform.instance.removePeer(publicKey: publicKey);
  }

  /// remove connection with single dApp using [pairingRequest]
  Future<Map> removePeerUsingPairingRequest(
      {required String pairingRequest}) async {
    Map p2pData = pairingRequestToP2P(pairingRequest: pairingRequest);
    return await BeaconPlatform.instance
        .removePeer(publicKey: p2pData['publicKey']);
  }

  /// get list of daPPs connected
  Future<Map> getPeers() async {
    return await BeaconPlatform.instance.getPeers();
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
    return await BeaconPlatform.instance
        .permissionResponse(id: id, publicKey: publicKey, address: address);
  }

  /// send sign payload response
  /// [id] beacon request id
  /// [signature] signature using payload
  Future<Map> signPayloadResponse(
      {required String id, required String? signature}) async {
    return await BeaconPlatform.instance
        .signPayloadResponse(id: id, signature: signature);
  }

  /// send operation response
  /// [id] beacon request id
  /// [transactionHash] transactionHash from the operation
  Future<Map> operationResponse(
      {required String id, required String? transactionHash}) async {
    return await BeaconPlatform.instance
        .operationResponse(id: id, transactionHash: transactionHash);
  }

  /// send broadcast response
  /// [id] beacon request id
  /// [transactionHash] transactionHash using signedTransaction
  Future<Map> broadcastResponse(
      {required String id, required String? transactionHash}) async {
    return await BeaconPlatform.instance
        .broadcastResponse(id: id, transactionHash: transactionHash);
  }
}
