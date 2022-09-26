// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'p2p_peer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

P2PPeer _$P2PPeerFromJson(Map<String, dynamic> json) => P2PPeer(
      id: json['id'] as String,
      name: json['name'] as String,
      publicKey: json['publicKey'] as String,
      relayServer: json['relayServer'] as String,
      version: json['version'] as String,
      icon: json['icon'] as String?,
      appURL: json['appURL'] as String?,
      isPaired: json['isPaired'] as bool?,
    );

Map<String, dynamic> _$P2PPeerToJson(P2PPeer instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'publicKey': instance.publicKey,
      'relayServer': instance.relayServer,
      'version': instance.version,
      'icon': instance.icon,
      'appURL': instance.appURL,
      'isPaired': instance.isPaired,
    };
