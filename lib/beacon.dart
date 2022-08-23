
import 'beacon_platform_interface.dart';

class Beacon {
  Future<String?> getPlatformVersion() {
    return BeaconPlatform.instance.getPlatformVersion();
  }
}
