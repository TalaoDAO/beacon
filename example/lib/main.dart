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
          "GUsRsanpcKvSjoUAB7jxhhrUnUnrbd97RMuqfnhTQoPQgspGnLXVZFM56eUo9KGFC4xYP6e4ESf175xdhvqSKsPCpDE8Ybaj2SfEF6ctke4dCbtSeseJZHhVySSwyJeeAWtM863BXqrfWmbZjKiMTRH5o2Thn3xEondKsFWrmHzrAAFzWqEEaW1UL7vQkGV8JzV3BMe3CGk2tWFntMBfZ1v6JfZmBQXDdwVjnHeMBJpX2WKLwxtKfaLMZ65KwkxJrj54uXKecKrYAM34e35VsNkx7j4NV3x4CJDnWBAH2DtMaB3bJHFJssqKUrsKFQ5gowHvSmFEvZe4");

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
