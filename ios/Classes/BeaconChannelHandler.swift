import Combine
import Flutter
import BeaconBlockchainTezos
import BeaconClientWallet
import BeaconTransportP2PMatrix
import BeaconCore
import Base58Swift
import SwiftUI


class BeaconChannelHandler: NSObject {
    
    static let shared = BeaconChannelHandler()
    
    private var cancelBag = Set<AnyCancellable>()
    
    func startBeacon(result: @escaping FlutterResult) {
        BeaconConnectService.shared.startBeacon()
            .sink(receiveCompletion: {  _ in
                result([
                    "success": false
                ])
            }, receiveValue: { _ in
                result([
                    "success": true
                ])
            })
            .store(in: &cancelBag)
    }
    
    func pair(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args: NSDictionary = call.arguments as! NSDictionary
        let pairingRequest: String = args["pairingRequest"] as! String
        
        BeaconConnectService.shared.pair(pairingRequest: pairingRequest)
            .sink(receiveCompletion: {  _ in
                result([
                    "success": false
                ])
            }, receiveValue: { _ in
                result([
                    "success": true
                ])
            })
            .store(in: &cancelBag)
    }
    
    func addPeer(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args: NSDictionary = call.arguments as! NSDictionary
        let id: String = args["id"] as! String
        let name: String = args["name"] as! String
        let publicKey: String = args["publicKey"] as! String
        let relayServer: String = args["relayServer"] as! String
        let version: String = args["version"] as! String
        
        BeaconConnectService.shared.addPeer(id: id, name: name, publicKey: publicKey, relayServer: relayServer, version: version)
            .tryMap { try JSONEncoder().encode($0) }
            .map { String(data: $0, encoding: .utf8) }
            .sink(receiveCompletion: {  (completion) in
                result([
                    "success": false,
                    "message": "Failed to addd peer"
                ])
            }, receiveValue: { serializedPeer in
                result([
                    "success": true,
                    "peer": serializedPeer as Any
                ])
            })
            .store(in: &cancelBag)
    }
    
    
    func removePeers(result: @escaping FlutterResult) {
        BeaconConnectService.shared.removePeers()
            .sink(receiveCompletion: { _ in
                result([
                    "success": false
                ])
            }, receiveValue: { _ in
                result([
                    "success": true
                ])
            })
            .store(in: &cancelBag)
    }
    
    
    func removePeer(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args: NSDictionary = call.arguments as! NSDictionary
        let publicKey: String = args["publicKey"] as! String
        BeaconConnectService.shared.removePeer(publicKey: publicKey)
            .sink(receiveCompletion: { _ in
                result([
                    "success": false
                ])
            }, receiveValue: { _ in
                result([
                    "success": true
                ])
            })
            .store(in: &cancelBag)
    }
    
    func getPeers(result: @escaping FlutterResult) {
        BeaconConnectService.shared.getPeers()
            .tryMap { try JSONEncoder().encode($0) }
            .map { String(data: $0, encoding: .utf8) }
            .sink(receiveCompletion: {  (completion) in
                result([
                    "success": false,
                    "message": "Failed to fetch"
                ])
            }, receiveValue: { serializedPeers in
                result([
                    "success": true,
                    "peer": serializedPeers as Any
                ])
            })
            .store(in: &cancelBag)
    }
    
    
    func tezosResponse(call: FlutterMethodCall, result: @escaping FlutterResult) {
        BeaconConnectService.shared.tezosResponse(call:call, completion: { _ in
            result([
                "success": true
            ])
        })
    }
    
    func respondExample(result: @escaping FlutterResult) {
        BeaconConnectService.shared.respondExample(completion: { _ in
            result([
                "success": true
            ])
        })
    }
    
    func pause(result: @escaping FlutterResult) {
        BeaconConnectService.shared.pause()
            .sink(receiveCompletion: { _ in
                result([
                    "success": false
                ])
            }, receiveValue: { _ in
                result([
                    "success": true
                ])
            })
            .store(in: &cancelBag)
    }
    
    func resume(result: @escaping FlutterResult) {
        BeaconConnectService.shared.resume()
            .sink(receiveCompletion: { _ in
                result([
                    "success": false
                ])
            }, receiveValue: { _ in
                result([
                    "success": true
                ])
            })
            .store(in: &cancelBag)
    }
    
    func stop(result: @escaping FlutterResult) {
        BeaconConnectService.shared.stop()
            .sink(receiveCompletion: { _ in
                result([
                    "success": false
                ])
            }, receiveValue: { _ in
                result([
                    "success": true
                ])
            })
            .store(in: &cancelBag)
    }
    
}

extension BeaconChannelHandler: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.observeEvents(events: events)
        return nil
    }
    
    func observeEvents(events: @escaping FlutterEventSink) {
        BeaconConnectService.shared.observeRequest()
            .throttle(for: 1.0, scheduler: RunLoop.main, latest: true)
            .sink { request in
                
                var type = ""
                
                let encoder = JSONEncoder()
               // encoder.outputFormatting = .prettyPrinted
                let data = try? encoder.encode(request)
                let requestData = data.flatMap { String(data: $0, encoding: .utf8) }
                

                switch request {
                case .permission(_):
                    type = "permission"

                case let .blockchain(blockchainRequest):
                    switch blockchainRequest {
                    case .signPayload(_):
                        type = "signPayload"
                    case .operation(_):
                        type = "operation"
                    case .broadcast(_):
                        type = "broadcast"
                        break;
                    }
                }
                
                let map = [
                    "type": type,
                    "request": requestData,
                ]
                
             
                let data2 = try? encoder.encode(map)
                let output = data2.flatMap { String(data: $0, encoding: .utf8) }
                
                
                events(output)
            }
            .store(in: &cancelBag)
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        cancelBag.removeAll()
        return nil
    }
    
}
