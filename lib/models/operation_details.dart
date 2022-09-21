import 'package:beacon_flutter/enums/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'operation_details.g.dart';

@JsonSerializable()
class OperationDetails {
  OperationDetails({
    this.kind,
    this.amount,
    this.destination,
    this.source,
    this.gasLimit,
    this.storageLimit,
    this.fee,
    this.counter,
    this.entrypoint,
    this.code,
    this.storage,
    this.parameters,
  });

  factory OperationDetails.fromJson(Map<String, dynamic> json) =>
      _$OperationDetailsFromJson(json);

  OperationKind? kind;
  String? amount;
  String? destination;
  String? source;
  String? gasLimit;
  String? storageLimit;
  String? fee;
  String? counter;
  String? entrypoint;
  List<dynamic>? code;
  dynamic storage;
  dynamic parameters;

  Map<String, dynamic> toJson() => _$OperationDetailsToJson(this);
}
