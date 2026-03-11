#import "BeaconPlugin.h"
#if __has_include(<beacon_flutter/beacon_flutter-Swift.h>)
#import <beacon_flutter/beacon_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "beacon_flutter-Swift.h"
#endif

@implementation BeaconPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBeaconPlugin registerWithRegistrar:registrar];
}
@end
