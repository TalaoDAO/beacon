//  Copyright (c) 2022 Altme.
//  Licensed under Apache License v2.0 that can be
//  found in the LICENSE file.

import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'beacon_request.g.dart';

/// Class for beacon requests from dApp to wallet
@JsonSerializable()
class BeaconRequest {
  /// Constructor for creating [BeaconRequest] object.
  BeaconRequest({
    this.type,
    this.request,

    /// [Request.operation] extra fields
    this.operationDetails,

    /// [Request.permission] extra fields
    this.peer,
  });

  /// Constructor for deserialize json [Map] into [BeaconRequest] object.
  factory BeaconRequest.fromJson(Map<String, dynamic> json) =>
      _$BeaconRequestFromJson(json);

  /// * [RequestType.permission] permission response
  /// * [RequestType.signPayload] sign payload response
  /// * [RequestType.operation] operation response
  /// * [RequestType.broadcast] broadcast response
  RequestType? type;

  // request data
  Request? request;

  /// [Request.operation] extra fields
  ///  list of operations to be performed by wallet
  List<OperationDetails>? operationDetails;

  /// [Request.permission] extra fields
  /// connected pair data
  P2PPeer? peer;

  /// Return the serializable of this object into [Map].
  Map<String, dynamic> toJson() => _$BeaconRequestToJson(this);
}

/// Class for request details
@JsonSerializable()
class Request {
  Request({
    this.id,
    this.origin,
    this.scopes,
    this.version,
    this.destination,
    this.network,
    this.appMetadata,

    /// [Request.signPayload] extra fields
    this.sourceAddress,
    this.senderID,
    this.signingType,
    this.payload,

    /// [Request.broadcast] extra fields
    this.signedTransaction,
  });

  /// Constructor for deserialize json [Map] into [Request] object.
  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);

  /// beacon request id
  String? id;

  /// wallet data
  Origin? origin;

  /// permissions from dApp
  List<String>? scopes;

  /// version
  String? version;

  /// dApp data
  Destination? destination;

  /// version
  Network? network;

  /// meta data of connection
  AppMetadata? appMetadata;

  /// [Request.signPayload] extra fields
  ///
  /// sender wallet address
  String? sourceAddress;

  /// sender id
  String? senderID;

  /// types of signing
  String? signingType;

  /// payload data sent from dApp
  String? payload;

  /// [Request.broadcast] extra fields
  String? signedTransaction;

  /// Return the serializable of this object into [Map].
  Map<String, dynamic> toJson() => _$RequestToJson(this);
}

/// Class for app metadata
@JsonSerializable()
class AppMetadata {
  /// Constructor for creating [AppMetadata] object.
  AppMetadata({
    this.name,
    this.senderId,
  });

  /// Constructor for deserialize json [Map] into [AppMetadata] object.
  factory AppMetadata.fromJson(Map<String, dynamic> json) =>
      _$AppMetadataFromJson(json);

  /// name of dApp
  String? name;

  /// id of dApp
  String? senderId;

  /// Return the serializable of this object into [Map].
  Map<String, dynamic> toJson() => _$AppMetadataToJson(this);
}

/// Class for wallet data
@JsonSerializable()
class Origin {
  /// Constructor for creating [Origin] object.
  Origin({
    this.kind,
    this.id,
  });

  /// Constructor for deserialize json [Map] into [Origin] object.
  factory Origin.fromJson(Map<String, dynamic> json) => _$OriginFromJson(json);

  /// relation kind e.g. [p2p]
  String? kind;

  /// publicKey
  String? id;

  /// Return the serializable of this object into [Map].
  Map<String, dynamic> toJson() => _$OriginToJson(this);
}

/// Class for dApp data
@JsonSerializable()
class Destination {
  /// Constructor for creating [Destination] object.
  Destination({
    this.kind,
    this.id,
  });

  /// Constructor for deserialize json [Map] into [Destination] object.
  factory Destination.fromJson(Map<String, dynamic> json) =>
      _$DestinationFromJson(json);

  /// relation kind e.g. [p2p]
  String? kind;

  /// publicKey
  String? id;

  /// Return the serializable of this object into [Map].
  Map<String, dynamic> toJson() => _$DestinationToJson(this);
}

/// Class for network data
@JsonSerializable()
class Network {
  /// Constructor for creating [Network] object.
  Network({
    this.type,
    this.rpcUrl,
  });

  /// Constructor for deserialize json [Map] into [Network] object.
  factory Network.fromJson(Map<String, dynamic> json) =>
      _$NetworkFromJson(json);

  /// network types
  /// [mainnet],
  /// [ghostnet],
  /// [mondaynet],
  /// [delphinet],
  /// [edonet],
  /// [florencenet],
  /// [granadanet],
  /// [hangzhounet],
  /// [ithacanet],
  /// [jakartanet],
  /// [kathmandunet],
  /// [custom],
  NetworkType? type;

  //rpc url of network
  String? rpcUrl;

  /// Return the serializable of this object into [Map].
  Map<String, dynamic> toJson() => _$NetworkToJson(this);
}
