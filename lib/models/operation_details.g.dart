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
    );

Map<String, dynamic> _$OperationDetailsToJson(OperationDetails instance) =>
    <String, dynamic>{
      'kind': _$OperationKindEnumMap[instance.kind],
      'amount': instance.amount,
      'destination': instance.destination,
    };

const _$OperationKindEnumMap = {
  OperationKind.generic: 'generic',
  OperationKind.transaction: 'transaction',
  OperationKind.delegation: 'delegation',
  OperationKind.origination: 'origination',
  OperationKind.transfer: 'transfer',
  OperationKind.reveal: 'reveal',
};
