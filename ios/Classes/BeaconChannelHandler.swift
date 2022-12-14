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
    
    func startBeacon(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args: NSDictionary = call.arguments as! NSDictionary
        let walletName: String = args["walletName"] as! String
        BeaconConnectService.shared.startBeacon(walletName: walletName)
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
                    "peer": serializedPeer!.dictionary()!
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
            .sink(receiveCompletion: {  (completion) in
                result([
                    "success": false,
                    "message": "Failed to fetch"
                ])
            }, receiveValue: { serializedPeers in
                
                var list = [Any]()
                for peer in serializedPeers {
                    let encoder = JSONEncoder()
                    
                    let data = try? encoder.encode(peer)
                    let requestData = data.flatMap { String(data: $0, encoding: .utf8) }
                    let requestDataDictionary = requestData!.dictionary()!
                    list.append(requestDataDictionary)
                }
                result([
                    "success": true,
                    "peer":  list
                ])
            })
            .store(in: &cancelBag)
    }
    
    
    func tezosResponse(call: FlutterMethodCall, result: @escaping FlutterResult) {
        BeaconConnectService.shared.tezosResponse(call:call, completion: { (data) in
            if(data.isSuccess){
                result([
                    "success": true
                ])
            }else{
                result([
                    "success": false
                ])
            }
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
                
                let encoder = JSONEncoder()
                
                let data = try? encoder.encode(request)
                let requestData = data.flatMap { String(data: $0, encoding: .utf8) }
                let requestDataDictionary = requestData!.dictionary()!
                
                
                var map: [String : Any] = [
                    "request": requestDataDictionary
                ]
                

                switch request {
                case .permission(_):
                    map["type"] = "permission"
                    
                    let peerPublicKey = request.origin.id
                    print(peerPublicKey)
                    BeaconConnectService.shared.getPeer(publicKey: peerPublicKey)
                        .tryMap { try JSONEncoder().encode($0) }
                        .map { String(data: $0, encoding: .utf8) }
                        .sink(receiveCompletion: {  (completion) in
                            //NOTHING
                        }, receiveValue: { peer in
                            map["peer"] = peer!.dictionary()!
                        })
                        .store(in: &self.cancelBag)

                case let .blockchain(blockchainRequest):
                    switch blockchainRequest {
                    case .signPayload(_):
                        map["type"] = "signPayload"
                    case let .operation(operation):
                        map["type"] = "operation"
                        
                        var operationDetails = [[String:Any?]]()
                        
                        func getParams(value: Micheline.MichelsonV1Expression) -> Any {
                            var params: [String: Any] = [:]

                            switch value {
                            case let .literal(literal):
                                switch literal {
                                case .string(let string):
                                    params["string"] = string
                                case .int(let value):
                                    params["int"] = value
                                case .bytes(let array):
                                    params["bytes"] = HexString(from: array).asString(withPrefix: false)
                                }
                            case let .prim(prim):
                                params["prim"] = prim.prim
                                params["args"] = prim.args?.map({ getParams(value: $0) })
                                if let annots = prim.annots {
                                    params["annots"] = annots
                                }
                                
                            case .sequence(let array):
                                var result = [Any]()
                                for mv1e in array {
                                    result.append(getParams(value: mv1e))
                                }

                                return result
                            }
                            
                            return params
                        }
                        
                        operation.operationDetails.forEach({ operation in
                            switch operation {
                            case let .transaction(transaction):
                                
                                let entrypoint: String?

                                switch transaction.parameters?.entrypoint {
                                case let .custom(custom):
                                    entrypoint = custom
                                case let .common(common):
                                    entrypoint = common.rawValue
                                case .none:
                                    entrypoint = nil
                                }
                                
                                let params: Any?
                                if let value = transaction.parameters?.value {
                                    params = getParams(value: value)
                                } else {
                                    params = nil
                                }
                                
                                let detail: [String : Any?] = [
                                    "kind": "transaction",
                                    "source": transaction.source,
                                    "gasLimit": transaction.gasLimit,
                                    "storageLimit": transaction.storageLimit,
                                    "fee": transaction.fee,
                                    "amount": transaction.amount,
                                    "counter": transaction.counter,
                                    "destination": transaction.destination,
                                    "entrypoint": entrypoint,
                                    "parameters": params,
                                ]
                                operationDetails.append(detail)
                            case let .origination(origination):
                                let code = getParams(value: origination.script.code)
                                let storage = getParams(value: origination.script.storage)
                                
                                let detail: [String : Any?] = [
                                    "kind": "origination",
                                    "source": origination.source,
                                    "gasLimit": origination.gasLimit,
                                    "storageLimit": origination.storageLimit,
                                    "fee": origination.fee,
                                    "balance": origination.balance,
                                    "counter": origination.counter,
                                    "code": code,
                                    "storage": storage,
                                ]
                                operationDetails.append(detail)
                            default:
                                break
                            }
                        })

                        
                        map["operationDetails"] = operationDetails
                        
                    case .broadcast(_):
                        map["type"] = "broadcast"
                        break;
                    }
                }
                

                
                events(map.json)
            }
            .store(in: &cancelBag)
    }
    

    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        cancelBag.removeAll()
        return nil
    }
    
}

extension Dictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }

    func printJson() {
        print(json)
    }

}

extension String{
    func dictionary() -> [String:AnyObject]? {
       if let data = self.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
               return json
           } catch {
               print("Something went wrong")
           }
       }
       return nil
   }
}


