//  Copyright (c) 2022 Altme.
//  Licensed under Apache License v2.0 that can be
//  found in the LICENSE file.

import 'package:beacon_flutter/enums/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'operation_details.g.dart';

/// Class for operation details
@JsonSerializable()
class OperationDetails {
  /// Constructor for creating [OperationDetails] object.
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

  /// Constructor for deserialize json [Map] into [ConnectedPeers] object.
  factory OperationDetails.fromJson(Map<String, dynamic> json) =>
      _$OperationDetailsFromJson(json);

  /// types of operation
  /// [generic],
  /// [transaction],
  /// [delegation],
  /// [origination],
  /// [transfer],
  /// [reveal],
  OperationKind? kind;

  /// total amount
  String? amount;

  /// destination wallet address
  String? destination;

  /// source wallet address
  String? source;

  /// gasLimit
  String? gasLimit;

  /// storageLimit
  String? storageLimit;

  /// fee
  String? fee;

  /// counter
  String? counter;

  /// entrypoint
  String? entrypoint;

  /// code
  List<Map<String, dynamic>>? code;

  /// storage
  dynamic storage;

  /// parameters
  dynamic parameters;

  /// Return the serializable of this object into [Map].
  Map<String, dynamic> toJson() => _$OperationDetailsToJson(this);
}
