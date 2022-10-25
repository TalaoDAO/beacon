//  Copyright (c) 2022 Altme.
//  Licensed under Apache License v2.0 that can be
//  found in the LICENSE file.

/// Request types of tezos responses
enum RequestType {
  permission,
  signPayload,
  operation,
  broadcast,
}

/// Types of operation
enum OperationKind {
  generic,
  transaction,
  delegation,
  origination,
  transfer,
  reveal,
}

/// Types of networks
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

enum SigningType {
  raw,
  operation,
  micheline,
}
