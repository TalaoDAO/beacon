import 'beacon_platform_interface.dart';

class Beacon {
  Future<Map> startBeacon() {
    return BeaconPlatform.instance.startBeacon();
  }

  Future<Map> pair({required String pairingRequest}) {
    return BeaconPlatform.instance.pair(pairingRequest: pairingRequest);
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
}
