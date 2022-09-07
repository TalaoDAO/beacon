import 'beacon_platform_interface.dart';

class Beacon {
  Future<Map> startBeacon() {
    return BeaconPlatform.instance.startBeacon();
  }

  Future<Map> pair({required String pairingRequest}) {
    return BeaconPlatform.instance.pair(pairingRequest: pairingRequest);
  }

  Future<Map> addPeer({required String pairingRequest}) {
    return BeaconPlatform.instance.addPeer(pairingRequest: pairingRequest);
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

  Future<Map> pairingRequestToP2P({required String pairingRequest}) {
    return BeaconPlatform.instance
        .pairingRequestToP2P(pairingRequest: pairingRequest);
  }
}
