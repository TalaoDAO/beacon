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
    
    func respondExample(result: @escaping FlutterResult) {
        BeaconConnectService.shared.respondExample(completion: { _ in
            result([
                "success": true
            ])
        })
    }
}

extension BeaconChannelHandler: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.observeEvents(events: events)
        return nil
    }
    
    func observeEvents(events: @escaping FlutterEventSink) {
        BeaconConnectService.shared.observeRequest()
            .sink { (event) in
                events(event)
            }
            .store(in: &cancelBag)
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        cancelBag.removeAll()
        return nil
    }
    
}
