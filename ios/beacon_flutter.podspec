#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint beacon.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'beacon_flutter'
  s.version          = '1.0.1'
  s.summary          = 'The Beacon Flutter Plugin provides Flutter developers with tools useful for setting up communication between native wallets supporting Tezos and dApps that implement beacon-sdk.'
  s.description      = <<-DESC
A new Flutter beacon plugin.
                       DESC
  s.homepage         = 'https://github.com/TalaoDAO/beacon'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Altme' => 'bibashshrestha@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'BeaconCore', '3.2.1'
  s.dependency 'BeaconClientDApp', '3.2.1'
  s.dependency 'BeaconClientWallet', '3.2.1'
  s.dependency 'BeaconBlockchainSubstrate', '3.2.1'
  s.dependency 'BeaconBlockchainTezos', '3.2.1'
  s.dependency 'BeaconTransportP2PMatrix', '3.2.1'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
