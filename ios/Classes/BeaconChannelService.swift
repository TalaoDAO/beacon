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
    
    let publisher = PassthroughSubject<String, Never>()
    
    func startBeacon() -> AnyPublisher<Void, Error>  {
        return Future<Void, Error> { [self] (promise) in
                do {
                    beaconClient?.disconnect {
                        print("disconnected \($0)")
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
            print("Sending response from wallet")
            self.awaitingRequest = request
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try? encoder.encode(request)
            
            DispatchQueue.main.async {
                let value = data.flatMap { String(data: $0, encoding: .utf8) }
                self.publisher.send(value!)
            }
        case let .failure(error):
            print("Error while processing incoming messages: \(error)")
            self.publisher.send(String("Error"))
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
    
    func respondExample(completion: @escaping Completion<Void>) {
        if let request = awaitingRequest {
            awaitingRequest = nil
            do {
                beaconClient?.respond(with: try response(from: request)) { result in
                    switch result {
                    case .success(_):
                        print("Sent the response from dApp")
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
    
    private func response(from request: BeaconRequest<Tezos>) throws -> BeaconResponse<Tezos> {
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
    
    
    private static func exampleSubstrateAccount(network: Substrate.Network) throws -> Substrate.Account {
        try Substrate.Account(
            publicKey: "628f3940a6210a2135ba355f7ff9f8e9fbbfd04f8571e99e1df75554d4bcd24f",
            address: "5EHw6XmdpoaaJiPMXFKr1CcHcXPVYZemc9NoKHhEoguavzJN",
            network: network
        )
    }
    
    
    func observeRequest() -> AnyPublisher<String, Never> {
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
