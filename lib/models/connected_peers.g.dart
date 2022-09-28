// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connected_peers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectedPeers _$ConnectedPeersFromJson(Map<String, dynamic> json) =>
    ConnectedPeers(
      peer: (json['peer'] as List<dynamic>?)
          ?.map((e) => P2PPeer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConnectedPeersToJson(ConnectedPeers instance) =>
    <String, dynamic>{
      'peer': instance.peer,
    };
