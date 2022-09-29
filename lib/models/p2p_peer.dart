//  Copyright (c) 2022 Altme.
//  Licensed under Apache License v2.0 that can be
//  found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'p2p_peer.g.dart';

@JsonSerializable()
class P2PPeer {
  P2PPeer({
    required this.id,
    required this.name,
    required this.publicKey,
    required this.relayServer,
    required this.version,
    this.icon,
    this.appURL,
    this.isPaired,
  });

  factory P2PPeer.fromJson(Map<String, dynamic> json) =>
      _$P2PPeerFromJson(json);

  final String id;
  final String name;
  final String publicKey;
  final String relayServer;
  final String version;
  final String? icon;
  final String? appURL;
  final bool? isPaired;

  Map<String, dynamic> toJson() => _$P2PPeerToJson(this);
}
