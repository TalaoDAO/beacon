// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationDetails _$OperationDetailsFromJson(Map<String, dynamic> json) =>
    OperationDetails(
      kind: $enumDecodeNullable(_$OperationKindEnumMap, json['kind']),
      amount: json['amount'] as String?,
      destination: json['destination'] as String?,
      source: json['source'] as String?,
      gasLimit: json['gasLimit'] as String?,
      storageLimit: json['storageLimit'] as String?,
      fee: json['fee'] as String?,
      counter: json['counter'] as String?,
      entrypoint: json['entrypoint'] as String?,
      code: json['code'] as List<dynamic>?,
      storage: json['storage'],
      parameters: json['parameters'],
    );

Map<String, dynamic> _$OperationDetailsToJson(OperationDetails instance) =>
    <String, dynamic>{
      'kind': _$OperationKindEnumMap[instance.kind],
      'amount': instance.amount,
      'destination': instance.destination,
      'source': instance.source,
      'gasLimit': instance.gasLimit,
      'storageLimit': instance.storageLimit,
      'fee': instance.fee,
      'counter': instance.counter,
      'entrypoint': instance.entrypoint,
      'code': instance.code,
      'storage': instance.storage,
      'parameters': instance.parameters,
    };

const _$OperationKindEnumMap = {
  OperationKind.generic: 'generic',
  OperationKind.transaction: 'transaction',
  OperationKind.delegation: 'delegation',
  OperationKind.origination: 'origination',
  OperationKind.transfer: 'transfer',
  OperationKind.reveal: 'reveal',
};
