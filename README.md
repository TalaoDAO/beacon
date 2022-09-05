# Beacon Flutter Plugin

[![pub package](https://img.shields.io/github/v/tag/TalaoDAO/beacon?label=pub)](https://pub.dev/packages/beacon_flutter)

> Connect Wallets with dApps on Tezos

[Beacon](https://walletbeacon.io) is an implementation of the wallet interaction standard [tzip-10](https://gitlab.com/tzip/tzip/blob/master/proposals/tzip-10/tzip-10.md) which describes the connection of a dApp with a wallet.

# About

The `Beacon Flutter Plugin` provides Flutter developers with tools useful for setting up communication between native wallets supporting Tezos and dApps that implement [`beacon-sdk`](https://github.com/airgap-it/beacon-sdk).

# Platform Support

| Android | iOS  | MacOS | Web  | Linux | Windows  | 
|---------|------|-------|------|-------|----------|
|    ✔️    |   ✔️  |   x   |   x  |   x   |    x     | 

# iOS Setup
iOS 14 and newer. Reason: Beacon iOS SDK

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

[Beacon Android SDK](https://github.com/airgap-it/beacon-android-sdk)
[Beacon IOS SDK](https://github.com/airgap-it/beacon-ios-sdk)
[Naan](https://github.com/Tezsure/naan-wallet-1.0)
[Autonomy](https://github.com/bitmark-inc/autonomy-client)

