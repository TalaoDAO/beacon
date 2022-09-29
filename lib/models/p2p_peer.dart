//  Copyright (c) 2022 Altme.
//  Licensed under Apache License v2.0 that can be
//  found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'p2p_peer.g.dart';

/// Class for p2p peer data
@JsonSerializable()
class P2PPeer {
  /// Constructor for creating [P2PPeer] object.
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

  /// Constructor for deserialize json [Map] into [P2PPeer] object.
  factory P2PPeer.fromJson(Map<String, dynamic> json) =>
      _$P2PPeerFromJson(json);

  /// dApp id
  final String id;

  /// dApp name
  final String name;

  /// publicKey - unique id for connection
  final String publicKey;

  /// server url
  final String relayServer;

  /// version
  final String version;

  /// icon
  final String? icon;

  /// url of app
  final String? appURL;

  /// pairing status
  final bool? isPaired;

  /// Return the serializable of this object into [Map].
  Map<String, dynamic> toJson() => _$P2PPeerToJson(this);
}
