import Foundation
import Combine
import BeaconBlockchainTezos
import BeaconClientWallet
import BeaconTransportP2PMatrix
import BeaconCore
import Base58Swift
import BeaconBlockchainSubstrate

typealias Completion<T> = (Result<T, Error>) -> Void

class BeaconConnectService{
    static var shared = BeaconConnectService()
    
    private var beaconClient: Beacon.WalletClient? = nil
    private var awaitingRequest: BeaconRequest<Tezos>? = nil
    
    let publisher = PassthroughSubject<BeaconRequest<Tezos>, Never>()
    
    func startBeacon() -> AnyPublisher<Void, Error>  {
        return Future<Void, Error> { [self] (promise) in
            do { 
                guard beaconClient == nil else {
                    listenForRequests()
                    return
                }
                
                Beacon.WalletClient.create(
                    with: .init(
                        name: "Altme",
                        blockchains: [Tezos.factory, Substrate.factory],
                        connections: [try Transport.P2P.Matrix.connection()]
                    )
                ) { result in
                    switch result {
                    case let .success(client):
                        print("Beacon client created")
                        
                        DispatchQueue.main.async {
                            self.beaconClient = client
                            self.listenForRequests()
                            print("Fetching peers")
                            self.beaconClient?.getPeers { result2 in
                                switch result2 {
                                case let .success(peers):
                                    print("Peers fetched")
                                    
                                    if(peers.count > 0){
                                        promise(.success(()))
                                    }else{
                                        print("Peer count is 0")
                                        promise(.failure(Beacon.Error.missingPairedPeer))
                                    }
                                    
                                case let .failure(error):
                                    print("Failed to fetch peers, got error: \(error)")
                                    promise(.failure(error))
                                }
                            }
                        }
                        
                    case let .failure(error):
                        print("Could not create Beacon client, got error: \(error)")
                        promise(.failure(error))
                    }
                }
                
            } catch {
                print("Could not create Beacon client, got error: \(error)")
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func listenForRequests() {
        beaconClient?.connect { result in
            switch result {
            case .success(_):
                print("Beacon client connected")
                self.beaconClient?.listen(onRequest: self.onBeaconRequest)
            case let .failure(error):
                print("Error while connecting for messages \(error)")
            }
        }
    }
    
    public init() {
    }
    
    private func onBeaconRequest(result: Result<BeaconRequest<Tezos>, Beacon.Error>) {
        switch result {
        case let .success(request):
            print("Sending response from dApp")
            self.awaitingRequest = request
            self.publisher.send(request)
        case let .failure(error):
            print("Error while processing incoming messages: \(error)")
        }
    }
    
    
    func pair(pairingRequest: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [self] (promise) in
            self.beaconClient?.pair(with: pairingRequest) { result in
                switch result {
                case .success(_):
                    print("Pairing succeeded")
                    promise(.success(()))
                case let .failure(error):
                    print("Failed to pair, got error: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func addPeer(
        id: String,
        name: String,
        publicKey: String,
        relayServer: String,
        version: String ) -> AnyPublisher<Beacon.P2PPeer, Error> {
            return  Future<Beacon.P2PPeer, Error> { [self] (promise) in
                let peer = Beacon.P2PPeer(
                    id : id,
                    name :name,
                    publicKey : publicKey,
                    relayServer : relayServer,
                    version : version
                )
                
                self.beaconClient?.add([.p2p(peer)]) { result in
                    switch result {
                    case .success(_):
                        print("Peers added \(peer) ")
                        promise(.success(peer))
                        
                    case let .failure(error):
                        print("addPeer Error: \(error)")
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
        }
    
  
    func removePeers() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [self] (promise) in
            self.beaconClient?.removeAllPeers { result in
                switch result {
                case .success(_):
                    print("Successfully removed peers")
                    promise(.success(()))
                    
                case let .failure(error):
                    print("Failed to remove peers, got error: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func removePeer(publicKey: String) -> AnyPublisher<Void, Error>  {
        return Future<Void, Error> { [self] (promise) in
            self.beaconClient?.removePeer(withPublicKey: publicKey)  { result in
                switch result {
                case .success(_):
                    print("Successfully removed peer")
                    promise(.success(()))
                    
                case let .failure(error):
                    print("Failed to remove peer, got error: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getPeers() -> AnyPublisher<[Beacon.Peer], Error> {
        return  Future<[Beacon.Peer], Error> { [self] (promise) in
            self.beaconClient?.getPeers { result in
                switch result {
                case let .success(peers):
                    print("Successfully fetched")
                    promise(.success(peers))
                    
                case let .failure(error):
                    print("getPeers Error: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    func getPeer(publicKey: String) -> AnyPublisher<Beacon.Peer, Error> {
        return Future<Beacon.Peer, Error> { [self] (promise) in
            guard let beaconDappClient = beaconClient else { return }
            beaconDappClient.storageManager.findPeers(where: { $0.publicKey == publicKey }) { result in
                switch result {
                case let .success(peer):
                    promise(.success(peer!))
                case let .failure(error):
                    promise(.failure(error))
                }

            }
        }
        .eraseToAnyPublisher()
    }
    
    func pause() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [self] (promise) in
            self.beaconClient?.pause() { result in
                switch result {
                case .success(_):
                    print("Paused")
                    promise(.success(()))
                case let .failure(error):
                    print("Failed to pause, got error: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func resume() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [self] (promise) in
            self.beaconClient?.resume() { result in
                switch result {
                case .success(_):
                    print("Resumed")
                    promise(.success(()))
                case let .failure(error):
                    print("Failed to resume, got error: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func stop() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [self] (promise) in
            self.beaconClient?.disconnect() { result in
                switch result {
                case .success(_):
                    print("disconnected")
                    promise(.success(()))
                case let .failure(error):
                    print("Failed to disconnect, got error: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func tezosResponse(call: FlutterMethodCall, completion: @escaping Completion<Void>) {
        // TODO(bibash): compare request.id with awaitingRequest.id
        if let request = awaitingRequest {
            awaitingRequest = nil
            do {
                beaconClient?.respond(with: try response(call:call, from: request)) { result in
                    switch result {
                    case .success(_):
                        print("Sent the example response from wallet")
                        completion(.success(()))
                    case let .failure(error):
                        print("Failed to send the response, got error: \(error)")
                        completion(.failure(error))
                    }
                }
            } catch {
                print("Failed to send the response, got error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    private func response(call: FlutterMethodCall, from request: BeaconRequest<Tezos>) throws -> BeaconResponse<Tezos> {
        let args: NSDictionary = call.arguments as! NSDictionary
        switch request {
        case let .permission(permissionRequest):
            let publicKey: String? = args["publicKey"] as? String
            if let publicKey = publicKey {
                guard let address = args["address"] as? String else { return permissionRequest.decline()}
                return try! permissionRequest.connect(publicKey: publicKey, address: address)
            } else {
                return permissionRequest.decline()
            }
            
        case let .blockchain(blockchainRequest):
            switch blockchainRequest {
            case let .signPayload(signPayload):
                let signature: String? = args["signature"] as? String
                if let signature = signature {
                    return signPayload.accept(signature: signature)
                } else {
                    return signPayload.decline()
                }
                
            case let .operation(operation):
                let transactionHash: String? = args["transactionHash"] as? String
                if let transactionHash = transactionHash {
                    return operation.done(transactionHash: transactionHash)
                } else {
                    return operation.decline()
                }
                
            case let .broadcast(broadcast):
                let transactionHash: String? = args["transactionHash"] as? String
                if let transactionHash = transactionHash {
                    return broadcast.show(transactionHash: transactionHash)
                } else {
                    return broadcast.decline()
                }
            }
        }
    }
    
    
    func respondExample(completion: @escaping Completion<Void>) {
        if let request = awaitingRequest {
            awaitingRequest = nil
            do {
                beaconClient?.respond(with: try exampleResponse(from: request)) { result in
                    switch result {
                    case .success(_):
                        print("Sent the example response from wallet")
                        completion(.success(()))
                    case let .failure(error):
                        print("Failed to send the response, got error: \(error)")
                        completion(.failure(error))
                    }
                }
            } catch {
                print("Failed to send the response, got error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    private func exampleResponse(from request: BeaconRequest<Tezos>) throws -> BeaconResponse<Tezos> {
        switch request {
        case let .permission(content):
            return .permission(
                try PermissionTezosResponse(from: content, account: Self.exampleTezosAccount(network: content.network))
            )
        case let .blockchain(blockchain):
            switch blockchain {
            case .signPayload(_):
                return .error(ErrorBeaconResponse(from: blockchain, errorType: .blockchain(.signatureTypeNotSupported)))
            default:
                return .error(ErrorBeaconResponse(from: blockchain, errorType: .aborted))
            }
        }
    }
    
    private static func exampleTezosAccount(network: Tezos.Network) throws -> Tezos.Account {
        try Tezos.Account(
            publicKey: "edpktpzo8UZieYaJZgCHP6M6hKHPdWBSNqxvmEt6dwWRgxDh1EAFw9",
            address: "tz1Mg6uXUhJzuCh4dH2mdBdYBuaiVZCCZsak",
            network: network
        )
    }
    
    
    func observeRequest() -> AnyPublisher<BeaconRequest<Tezos>, Never> {
        publisher.eraseToAnyPublisher()
    }
    
    
}


extension BeaconRequest: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        if let tezosRequest = self as? BeaconRequest<Tezos> {
            switch tezosRequest {
            case let .permission(content):
                try content.encode(to: encoder)
            case let .blockchain(blockchain):
                switch blockchain {
                case let .operation(content):
                    try content.encode(to: encoder)
                case let .signPayload(content):
                    try content.encode(to: encoder)
                case let .broadcast(content):
                    try content.encode(to: encoder)
                }
            }
        } else if let substrateRequest = self as? BeaconRequest<Substrate> {
            switch substrateRequest {
            case let .permission(content):
                try content.encode(to: encoder)
            case let .blockchain(blockchain):
                switch blockchain {
                case let .transfer(content):
                    try content.encode(to: encoder)
                case let .signPayload(content):
                    try content.encode(to: encoder)
                }
            }
        } else {
            throw Error.unsupportedBlockchain
        }
    }
    
    enum Error: Swift.Error {
        case unsupportedBlockchain
    }
}

extension PermissionTezosRequest {
    func connect(publicKey: String, address: String) throws -> BeaconResponse<Tezos> {
        return .permission(
            PermissionTezosResponse(
                from: self,
                account: try Tezos.Account(
                    publicKey: publicKey,
                    address: address,
                    network: network
                ))
        )
    }
    
    func decline() -> BeaconResponse<Tezos> {
        .error(ErrorBeaconResponse(from: self, errorType: .aborted))
    }
}

extension SignPayloadTezosRequest {
    func accept(signature: String) -> BeaconResponse<Tezos> {
        .blockchain(
            .signPayload(SignPayloadTezosResponse(from: self, signature: signature))
        )
    }
    
    func decline() -> BeaconResponse<Tezos> {
        .error(ErrorBeaconResponse(id: id, version: version, destination: origin, errorType: .aborted))
    }
}

extension OperationTezosRequest {
    func done(transactionHash: String) -> BeaconResponse<Tezos> {
        .blockchain(
            .operation(OperationTezosResponse(from: self, transactionHash: transactionHash))
        )
    }
    
    func decline() -> BeaconResponse<Tezos> {
        .error(ErrorBeaconResponse(id: id, version: version, destination: origin, errorType: .aborted))
    }
}

extension BroadcastTezosRequest {
    func show(transactionHash: String) -> BeaconResponse<Tezos> {
        .blockchain(
            .broadcast(BroadcastTezosResponse(id: id, version: version, destination: origin, transactionHash: transactionHash))
        )
    }
    
    func decline() -> BeaconResponse<Tezos> {
        .error(ErrorBeaconResponse(id: id, version: version, destination: origin, errorType: .aborted))
    }
}

 
