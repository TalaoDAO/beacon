import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'beacon_request.g.dart';

@JsonSerializable()
class BeaconRequest {
  BeaconRequest({
    this.type,
    this.request,

    /// operation extra fields
    this.operationDetails,

    /// permission extra fields
    this.peer,
  });

  factory BeaconRequest.fromJson(Map<String, dynamic> json) =>
      _$BeaconRequestFromJson(json);

  RequestType? type;
  Request? request;

  /// operation extra fields
  List<OperationDetails>? operationDetails;

  /// permission extra fields
  P2PPeer? peer;

  Map<String, dynamic> toJson() => _$BeaconRequestToJson(this);
}

@JsonSerializable()
class Request {
  Request({
    /// permission
    this.id,
    this.origin,
    this.scopes,
    this.version,
    this.destination,
    this.senderId,
    this.network,
    this.appMetadata,

    /// signInPayLoad extra fields
    this.sourceAddress,
    this.senderID,
    this.signingType,
    this.payload,

    /// broadcast extra fields
    this.signedTransaction,
  });

  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);

  /// permission
  String? id;
  Destination? origin;
  List<String>? scopes;
  String? version;
  Destination? destination;
  String? senderId;
  Network? network;
  AppMetadata? appMetadata;

  /// signInPayLoad extra fields
  String? sourceAddress;
  String? senderID;
  String? signingType;
  String? payload;

  /// broadcast extra fields
  String? signedTransaction;

  Map<String, dynamic> toJson() => _$RequestToJson(this);
}

@JsonSerializable()
class AppMetadata {
  AppMetadata({
    this.name,
    this.senderId,
  });

  factory AppMetadata.fromJson(Map<String, dynamic> json) =>
      _$AppMetadataFromJson(json);

  String? name;
  String? senderId;

  Map<String, dynamic> toJson() => _$AppMetadataToJson(this);
}

@JsonSerializable()
class Destination {
  Destination({
    this.kind,
    this.id,
  });

  factory Destination.fromJson(Map<String, dynamic> json) =>
      _$DestinationFromJson(json);

  String? kind;

  /// publicKey
  String? id;

  Map<String, dynamic> toJson() => _$DestinationToJson(this);
}

@JsonSerializable()
class Network {
  Network({
    this.type,
    this.rpcUrl,
  });

  factory Network.fromJson(Map<String, dynamic> json) =>
      _$NetworkFromJson(json);

  NetworkType? type;
  String? rpcUrl;

  Map<String, dynamic> toJson() => _$NetworkToJson(this);
}
