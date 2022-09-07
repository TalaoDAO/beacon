import 'dart:convert';

import 'beacon_platform_interface.dart';
import 'package:base_codecs/base_codecs.dart';

class Beacon {
  Future<Map> startBeacon() {
    return BeaconPlatform.instance.startBeacon();
  }

  Future<Map> pair({required String pairingRequest}) {
    return BeaconPlatform.instance.pair(pairingRequest: pairingRequest);
  }

  Future<Map> addPeer({required String pairingRequest}) async {
    Map p2pData = pairingRequestToP2P(pairingRequest: pairingRequest);
    return BeaconPlatform.instance.addPeer(
      id: p2pData['id'],
      name: p2pData['name'],
      publicKey: p2pData['publicKey'],
      relayServer: p2pData['relayServer'],
      version: p2pData['version'],
    );
  }

  Future<Map> removePeers() {
    return BeaconPlatform.instance.removePeers();
  }

  Future<void> respondExample() {
    return BeaconPlatform.instance.respondExample();
  }

  Stream<String> getBeaconResponse() {
    return BeaconPlatform.instance.getBeaconResponse();
  }

  Future<Map> pause() {
    return BeaconPlatform.instance.pause();
  }

  Future<Map> resume() {
    return BeaconPlatform.instance.resume();
  }

  Future<Map> stop() {
    return BeaconPlatform.instance.stop();
  }

  Map<String, dynamic> pairingRequestToP2P({required String pairingRequest}) {
    var uint8List = base58CheckDecode(pairingRequest);
    String decoded = utf8.decode(uint8List);
    Map<String, String> data = Map<String, String>.from(jsonDecode(decoded));
    return data;
  }
}
