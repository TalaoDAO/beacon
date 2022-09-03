import Flutter
import UIKit

public class SwiftBeaconPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    var sink: FlutterEventSink!
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftBeaconPlugin()
        
        let methodChannel = FlutterMethodChannel(name: "beaconMethod", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "beaconEvent", binaryMessenger: registrar.messenger())
        
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventChannel.setStreamHandler(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "startBeacon":
            BeaconChannelHandler.shared.startBeacon(result: result)
        case "pair":
            BeaconChannelHandler.shared.pair(call: call, result: result)
        case "removePeers":
            BeaconChannelHandler.shared.removePeers(result: result)
        case "respondExample":
            BeaconChannelHandler.shared.respondExample(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }
}
