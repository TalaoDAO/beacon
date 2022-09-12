import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:beacon/beacon.dart';
// import 'package:beacon/beacon_platform_interface.dart';
// import 'package:beacon/beacon_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'dart:convert';
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

void main() {
  test('getPlatformVersion', () async {
    Map<String, dynamic> jsosn = <String, dynamic>{
      "request": {
        "id": "0f602a48-2741-44b9-e550-47b1db52c4ea",
        "destination": {
          "kind": "p2p",
          "id":
              "c8aeee9c5e1d774d4301d50b8783b0afc721ace9945e92bac3f09937a10bc386"
        },
        "appMetadata": {
          "name": "Beacon Test Dapp",
          "senderID": "2vNp2zp5wXTZp"
        },
        "version": "2",
        "senderID": "2vNp2zp5wXTZp",
        "network": {
          "type": "jakartanet",
          "rpcUrl": "https:\/\/jakartanet.ecadinfra.com\/"
        },
        "scopes": ["operation_request", "sign"],
        "origin": {
          "kind": "p2p",
          "id":
              "45cb34244cb0aab790cf510eeccc25a732be163710aeb18049fd0f853d6a2c38"
        }
      },
      "type": "permission"
    };

    final BeaconRequest beaconRequest = BeaconRequest.fromJson(
        jsonDecode(jsonEncode(jsosn)) as Map<String, dynamic>);
    print(beaconRequest.type);
    final a = 42;
    expect(a, '42');
  });
}
