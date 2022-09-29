//  Copyright (c) 2022 Altme.
//  Licensed under Apache License v2.0 that can be
//  found in the LICENSE file.

import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'connected_peers.g.dart';

/// Class for connected dApps
@JsonSerializable()
class ConnectedPeers {
  /// Constructor for creating [ConnectedPeers] object.
  ConnectedPeers({
    this.peer,
  });

  /// Constructor for deserialize json [Map] into [ConnectedPeers] object.
  factory ConnectedPeers.fromJson(Map<String, dynamic> json) =>
      _$ConnectedPeersFromJson(json);

  /// list of peers
  List<P2PPeer>? peer;

  /// Return the serializable of this object into [Map].
  Map<String, dynamic> toJson() => _$ConnectedPeersToJson(this);
}
