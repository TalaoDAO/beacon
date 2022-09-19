import 'package:json_annotation/json_annotation.dart';

enum RequestType {
  permission,
  signPayload,
  operation,
  broadcast,
}

enum OperationKind {
  generic,
  transaction,
  delegation,
  origination,
  transfer,
  reveal,
}

enum NetworkType {
  mainnet,
  ghostnet,
  mondaynet,
  delphinet,
  edonet,
  florencenet,
  granadanet,
  hangzhounet,
  ithacanet,
  jakartanet,
  kathmandunet,
  custom,
}
