#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint beacon.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'beacon_flutter'
  s.version          = '2.0.2'
  s.summary          = 'The Beacon Flutter Plugin provides Flutter developers with tools useful for setting up communication between native wallets supporting Tezos and dApps that implement beacon-sdk.'
  s.description      = <<-DESC
A new Flutter beacon plugin.
                       DESC
  s.homepage         = 'https://github.com/TalaoDAO/beacon'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Altme' => 'bibashshrestha@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'beacon_flutter/Sources/beacon_flutter/**/*.swift'
  s.dependency 'Flutter'
  s.dependency 'BeaconCore', '4.0.3'
  s.dependency 'BeaconClientDApp', '4.0.3'
  s.dependency 'BeaconClientWallet', '4.0.3'
  s.dependency 'BeaconBlockchainSubstrate', '4.0.3'
  s.dependency 'BeaconBlockchainTezos', '4.0.3'
  s.dependency 'BeaconTransportP2PMatrix', '4.0.3'
  s.dependency 'Base58', '~> 4.0.3'
  s.dependency 'Base58Swift', '~> 2.1.0'
  s.platform = :ios, '15.5'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
