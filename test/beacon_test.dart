// import 'package:flutter_test/flutter_test.dart';
// import 'package:beacon/beacon.dart';
// import 'package:beacon/beacon_platform_interface.dart';
// import 'package:beacon/beacon_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockBeaconPlatform 
//     with MockPlatformInterfaceMixin
//     implements BeaconPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final BeaconPlatform initialPlatform = BeaconPlatform.instance;

//   test('$MethodChannelBeacon is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelBeacon>());
//   });

//   test('getPlatformVersion', () async {
//     Beacon beaconPlugin = Beacon();
//     MockBeaconPlatform fakePlatform = MockBeaconPlatform();
//     BeaconPlatform.instance = fakePlatform;
  
//     expect(await beaconPlugin.getPlatformVersion(), '42');
//   });
// }
