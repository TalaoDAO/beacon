import 'package:beacon_flutter/enums/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'operation_details.g.dart';

@JsonSerializable()
class OperationDetails {
  OperationDetails({
    this.kind,
    this.amount,
    this.destination,
  });

  factory OperationDetails.fromJson(Map<String, dynamic> json) =>
      _$OperationDetailsFromJson(json);

  OperationKind? kind;
  String? amount;
  String? destination;

  Map<String, dynamic> toJson() => _$OperationDetailsToJson(this);
}
