import 'dart:convert';

import 'beacon_platform_interface.dart';
import 'package:base_codecs/base_codecs.dart';

class Beacon {
  Future<Map> startBeacon() async {
    return await BeaconPlatform.instance.startBeacon();
  }

  Future<Map> pair({required String pairingRequest}) async {
    return await BeaconPlatform.instance.pair(pairingRequest: pairingRequest);
  }

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

  Future<Map> removePeers() async {
    return await BeaconPlatform.instance.removePeers();
  }

  Future<void> respondExample() async {
    await BeaconPlatform.instance.respondExample();
    return;
  }

  Stream<String> getBeaconResponse() {
    return BeaconPlatform.instance.getBeaconResponse();
  }

  Future<Map> pause() async {
    return await BeaconPlatform.instance.pause();
  }

  Future<Map> resume() async {
    return await BeaconPlatform.instance.resume();
  }

  Future<Map> stop() async {
    return await BeaconPlatform.instance.stop();
  }

  Map<String, dynamic> pairingRequestToP2P({required String pairingRequest}) {
    var uint8List = base58CheckDecode(pairingRequest);
    String decoded = utf8.decode(uint8List);
    Map<String, String> data = Map<String, String>.from(jsonDecode(decoded));
    return data;
  }

  Future<Map> removePeerUsingPublicKey({required String publicKey}) async {
    return await BeaconPlatform.instance.removePeer(publicKey: publicKey);
  }

  Future<Map> removePeerUsingPairingRequest(
      {required String pairingRequest}) async {
    Map p2pData = pairingRequestToP2P(pairingRequest: pairingRequest);
    return await BeaconPlatform.instance
        .removePeer(publicKey: p2pData['publicKey']);
  }

  Future<Map> getPeers() async {
    return await BeaconPlatform.instance.getPeers();
  }

  Future<Map> permissionResponse({
    required String id,
    required String publicKey,
    required String address,
  }) async {
    return await BeaconPlatform.instance
        .permissionResponse(id: id, publicKey: publicKey, address: address);
  }

  Future<Map> signPayloadResponse(
      {required String id, required String signature}) async {
    return await BeaconPlatform.instance
        .signPayloadResponse(id: id, signature: signature);
  }

  Future<Map> operationResponse(
      {required String id, required String transactionHash}) async {
    return await BeaconPlatform.instance
        .operationResponse(id: id, transactionHash: transactionHash);
  }
}
