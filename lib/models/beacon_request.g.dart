// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beacon_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BeaconRequest _$BeaconRequestFromJson(Map<String, dynamic> json) =>
    BeaconRequest(
      type: $enumDecodeNullable(_$RequestTypeEnumMap, json['type']),
      request: json['request'] == null
          ? null
          : Request.fromJson(json['request'] as Map<String, dynamic>),
      operationDetails: (json['operationDetails'] as List<dynamic>?)
          ?.map((e) => OperationDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
      peer: json['peer'] == null
          ? null
          : P2PPeer.fromJson(json['peer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BeaconRequestToJson(BeaconRequest instance) =>
    <String, dynamic>{
      'type': _$RequestTypeEnumMap[instance.type],
      'request': instance.request,
      'operationDetails': instance.operationDetails,
      'peer': instance.peer,
    };

const _$RequestTypeEnumMap = {
  RequestType.permission: 'permission',
  RequestType.signPayload: 'signPayload',
  RequestType.operation: 'operation',
  RequestType.broadcast: 'broadcast',
};

Request _$RequestFromJson(Map<String, dynamic> json) => Request(
      id: json['id'] as String?,
      origin: json['origin'] == null
          ? null
          : Destination.fromJson(json['origin'] as Map<String, dynamic>),
      scopes:
          (json['scopes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      version: json['version'] as String?,
      destination: json['destination'] == null
          ? null
          : Destination.fromJson(json['destination'] as Map<String, dynamic>),
      senderId: json['senderId'] as String?,
      network: json['network'] == null
          ? null
          : Network.fromJson(json['network'] as Map<String, dynamic>),
      appMetadata: json['appMetadata'] == null
          ? null
          : AppMetadata.fromJson(json['appMetadata'] as Map<String, dynamic>),
      sourceAddress: json['sourceAddress'] as String?,
      senderID: json['senderID'] as String?,
      signingType: json['signingType'] as String?,
      payload: json['payload'] as String?,
    );

Map<String, dynamic> _$RequestToJson(Request instance) => <String, dynamic>{
      'id': instance.id,
      'origin': instance.origin,
      'scopes': instance.scopes,
      'version': instance.version,
      'destination': instance.destination,
      'senderId': instance.senderId,
      'network': instance.network,
      'appMetadata': instance.appMetadata,
      'sourceAddress': instance.sourceAddress,
      'senderID': instance.senderID,
      'signingType': instance.signingType,
      'payload': instance.payload,
    };

AppMetadata _$AppMetadataFromJson(Map<String, dynamic> json) => AppMetadata(
      name: json['name'] as String?,
      senderId: json['senderId'] as String?,
    );

Map<String, dynamic> _$AppMetadataToJson(AppMetadata instance) =>
    <String, dynamic>{
      'name': instance.name,
      'senderId': instance.senderId,
    };

Destination _$DestinationFromJson(Map<String, dynamic> json) => Destination(
      kind: json['kind'] as String?,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$DestinationToJson(Destination instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'id': instance.id,
    };

Network _$NetworkFromJson(Map<String, dynamic> json) => Network(
      type: $enumDecodeNullable(_$NetworkTypeEnumMap, json['type']),
      rpcUrl: json['rpcUrl'] as String?,
    );

Map<String, dynamic> _$NetworkToJson(Network instance) => <String, dynamic>{
      'type': _$NetworkTypeEnumMap[instance.type],
      'rpcUrl': instance.rpcUrl,
    };

const _$NetworkTypeEnumMap = {
  NetworkType.mainnet: 'mainnet',
  NetworkType.ghostnet: 'ghostnet',
  NetworkType.mondaynet: 'mondaynet',
  NetworkType.delphinet: 'delphinet',
  NetworkType.edonet: 'edonet',
  NetworkType.florencenet: 'florencenet',
  NetworkType.granadanet: 'granadanet',
  NetworkType.hangzhounet: 'hangzhounet',
  NetworkType.ithacanet: 'ithacanet',
  NetworkType.jakartanet: 'jakartanet',
  NetworkType.kathmandunet: 'kathmandunet',
  NetworkType.custom: 'custom',
};
