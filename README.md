# Beacon Flutter Plugin

[![pub package](https://img.shields.io/github/v/tag/TalaoDAO/beacon?label=pub)](https://pub.dev/packages/beacon_flutter) [![GitHub](https://img.shields.io/github/license/TalaoDAO/beacon?color=2196F3)](https://pub.dev/packages/beacon_flutter/license)

> Connect Wallets with dApps on Tezos

[Beacon](https://walletbeacon.io) is an implementation of the wallet interaction standard [tzip-10](https://gitlab.com/tzip/tzip/blob/master/proposals/tzip-10/tzip-10.md) which describes the connection of a dApp with a wallet.

## About

The `Beacon Flutter Plugin` provides Flutter developers with tools useful for setting up communication between native wallets supporting Tezos and dApps that implement [`beacon-sdk`](https://github.com/airgap-it/beacon-sdk).

## Platform Support

| Android | iOS  | MacOS | Web  | Linux | Windows  | 
|---------|------|-------|------|-------|----------|
|    ✔️    |   ✔️  |   x   |   x  |   x   |    x     | 

## Use this package as a library

Depend on it

Run this command:

With Flutter:

```
$ flutter pub add beacon_flutter
```

This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):

```
dependencies:
  beacon_flutter: latest
```

Alternatively, your editor might support `flutter pub get`. Check the docs for your editor to learn more.

Import it
Now in your Dart code, you can use:
```
import 'package:beacon_flutter/beacon_flutter.dart';
```

## iOS Setup
iOS 14 and newer. Reason: Beacon iOS SDK

## Android Setup
Create a new file `proguard-rules.pro` in app directory:

```
-keep class co.altme.alt.me.altme.** { *; } // Add your id
-keep class it.airgap.beaconsdk.** { *; }  
-keep class com.sun.jna.** { *; }
-keep class * implements com.sun.jna.** { *; }

# Keep `Companion` object fields of serializable classes.
# This avoids serializer lookup through `getDeclaredClasses` as done for named companion objects.
-if @kotlinx.serialization.Serializable class **
-keepclassmembers class <1> {
    static <1>$Companion Companion;
}

# Keep `serializer()` on companion objects (both default and named) of serializable classes.
-if @kotlinx.serialization.Serializable class ** {
    static **$* *;
}
-keepclassmembers class <2>$<3> {
    kotlinx.serialization.KSerializer serializer(...);
}

# Keep `INSTANCE.serializer()` of serializable objects.
-if @kotlinx.serialization.Serializable class ** {
    public static ** INSTANCE;
}
-keepclassmembers class <1> {
    public static <1> INSTANCE;
    kotlinx.serialization.KSerializer serializer(...);
}

# @Serializable and @Polymorphic are used at runtime for polymorphic serialization.
-keepattributes RuntimeVisibleAnnotations,AnnotationDefault
```

Modify your `build.gradle` in in app directory:
```
buildTypes {
    release {
        ...
        useProguard true
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
    }
    debug {
        ...
    }
}
```
## What 

What can you do with this package?. 
### Starting beacon and listen to response
```dart 
await _beaconPlugin.startBeacon();  
Future.delayed(const Duration(seconds: 1), (){
  _beaconPlugin.getBeaconResponse().listen(
    (data) {
        final Map<String, dynamic> requestJson =
            jsonDecode(data) as Map<String, dynamic>;
        final BeaconRequest beaconRequest =
            BeaconRequest.fromJson(requestJson);
            
        switch (beaconRequest.type) {
          case RequestType.permission:
            ...
            break;
          case RequestType.signPayload:
            ...
            break;
          case RequestType.operation:
            ...
            break;
          case RequestType.broadcast:
            ...
            break;
        }
    },
  );
}); 
```

### Pairing wallet with dApp
```dart 
try {  
  ...
  final Map response = await _beaconPlugin.pair(pairingRequest: pairingRequest);

  final bool success = json.decode(response['success'].toString()) as bool;

  if (success) {
      ...
  } else {
    throw ...;
  }
} catch (e) {
  ...
}
```

### Pairing wallet with dApp using addPeer
```dart 
try {  
  ...
  final Map response = await _beaconPlugin.addPeer(pairingRequest: pairingRequest);

  final bool success = json.decode(response['success'].toString()) as bool;

  if (success) {
      ...
  } else {
    throw ...;
  }
} catch (e) {
  ...
} 
```

### convert pairingRequest to P2P
```dart
pairingRequestToP2P(pairingRequest: pairingRequest);  
```

### Disconnecting with dApp
```dart  
try {  
  ...
  final Map response = await _beaconPlugin.removePeerUsingPublicKey(publicKey: publicKey));

  final bool success = json.decode(response['success'].toString()) as bool;

  if (success) {
      ...
  } else {
    throw ...;
  }
} catch (e) {
  ...
}
```

### Disconnecting with all dApps
```dart 
Future<void> removePeers() async {
  try {  
    ...
    final Map response = await _beaconPlugin.removePeers());

    final bool success = json.decode(response['success'].toString()) as bool;

    if (success) {
       ...
    } else {
      throw ...;
    }
  } catch (e) {
    ...
  }
}
```

### Sending permission response to dApp
```dart 
try {  
  ...
  final Map response = await _beaconPlugin.permissionResponse(
    id: beaconRequest!.request!.id!,
    publicKey: publicKey, // publicKey of crypto account
    address: walletAddress, // walletAddress of crypto account
  );

  final bool success = json.decode(response['success'].toString()) as bool;

  if (success) {
      ...
  } else {
    throw ...;
  }
} catch (e) {
  ...
} 
```

### Reject permission response to dApp
```dart 
_beaconPlugin.permissionResponse(
  id: beaconRequest!.request!.id!,
  publicKey: null,
  address: null,
); 
```

### Sending sign payload response to dApp
```dart 
try {  
  ...
  //create signature using payload

  final Map response = await _beaconPlugin.signPayloadResponse(
    id: beaconRequest!.request!.id!,
    signature: signature,
  );

  final bool success = json.decode(response['success'].toString()) as bool;

  if (success) {
      ...
  } else {
    throw ...;
  }
} catch (e) {
  ...
} 
```

### Reject sign payload response to dApp
```dart 
_beaconPlugin.signPayloadResponse(
  id: beaconRequest!.request!.id!,
  signature: null,
);
``` 

## Sending operation response to dApp
```dart 
try {  
  ...
  // get transactionHash from the operation

  final Map response = await _beaconPlugin.operationResponse(
    id: beaconRequest!.request!.id!,
    transactionHash: transactionHash,
  );

  final bool success = json.decode(response['success'].toString()) as bool;

  if (success) {
      ...
  } else {
    throw ...;
  }
} catch (e) {
  ...
} 
```

## Reject operation response to dApp
```dart 
_beaconPlugin.operationResponse(
  id: beaconRequest!.request!.id!,
  transactionHash: null,
);
```

## Get peers lists that is connected with dApp
```dart 
final peers = await _beaconPlugin.getPeers();
final Map<String, dynamic> requestJson =
    jsonDecode(jsonEncode(peers)) as Map<String, dynamic>;
final ConnectedPeers connectedPeers =
    ConnectedPeers.fromJson(requestJson);
```


## Example
```dart
import 'dart:convert';

import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Beacon Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Beacon Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _beaconPlugin = Beacon();

  final TextEditingController pairingRequestController = TextEditingController(
      text:
          "GUsRsanpcLYPUk683gtFy4LJ6GAKP5BRe3jonDEQvXdCiYWnEGBq887akzYcKMbBnejMZMcFERAqzm8qqEHDnfPLyfNdjYVZ4qdGazMxu9X8iYeRSH7XUfCfoTfZMmnuQi5rccVEeM3JPRqZ1gUcyiuYQGBrEjyWH85JpV39GBcyw6Tkfiyauf2cUp4CYQqbbdiVRb5yLU3iogNXKn5wWKDBXj5HAHki7c12HgQvRqqiFJwsSPuv3Q8akazJkhX7adSuqEnvxo5LE15BdqM5GgXDic4ReSy3UTGNQbi3L2VXqb2yeiCfv5t1WAbQB1BB1NxT788yVRoS");

  bool hasPeers = false;

  String value = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startBeacon();
    });
  }

  startBeacon() async {
    final Map response = await _beaconPlugin.startBeacon();
    setState(() {
      hasPeers = json.decode(response['success'].toString());
    });
    getBeaconResponse();
  }

  void getBeaconResponse() {
    _beaconPlugin.getBeaconResponse().listen(
      (data) {
        setState(() {
          value = data.toString();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Beacon Demo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: const Text('Pairing Request: '),
              ),
              TextField(
                controller: pairingRequestController,
                maxLines: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: !hasPeers
                        ? null
                        : () async {
                            final Map response =
                                await _beaconPlugin.removePeers();

                            setState(() {
                              bool success =
                                  json.decode(response['success'].toString());
                              hasPeers = !success;
                            });

                            if (!hasPeers) {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Successfully disconnected.'),
                              ));
                            }
                          },
                    child: const Text('Unpair'),
                  ),
                  ElevatedButton(
                    onPressed: hasPeers
                        ? null
                        : () async {
                            final Map response = await _beaconPlugin.pair(
                              pairingRequest: pairingRequestController.text,
                            );

                            setState(() {
                              bool success =
                                  json.decode(response['success'].toString());
                              hasPeers = success;
                            });

                            if (hasPeers) {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Successfully paired.'),
                              ));
                            } else {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Failed to pair.'),
                              ));
                            }
                          },
                    child: const Text('Pair'),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: value.isEmpty
                      ? null
                      : () async {
                          setState(() {
                            value = '';
                          });
                          await _beaconPlugin.respondExample();
                        },
                  child: const Text('Respond'),
                ),
              ),
              const Divider(),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text('Beacon Response: '),
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  value,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

```
# Reference

* [Beacon Android SDK](https://github.com/airgap-it/beacon-android-sdk)
* [Beacon IOS SDK](https://github.com/airgap-it/beacon-ios-sdk)
* [Naan](https://github.com/Tezsure/naan-wallet-1.0)
* [Autonomy](https://github.com/bitmark-inc/autonomy-client)

# Author

Beacon Flutter Plugin is developed by [Altme](https://altme.io/). Please feel free to contact us at <thierry@altme.io>.

