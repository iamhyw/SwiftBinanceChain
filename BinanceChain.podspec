Pod::Spec.new do |s|
  s.name         = 'BinanceChain'
  s.version      = '1.0.0'
  s.license      = { :file => 'LICENSE' }
  s.summary      = 'BinanceChain'
  s.author       = { 'Michael Henderson' => 'roadkillrabbit@gmail.com' }
  s.homepage     = 'http://binance.org/'
  s.osx.deployment_target = '10.10'
  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '2.0'
  s.requires_arc = true
  s.source       = { :path => 'BinanceChain' }
  s.pod_target_xcconfig = {
    'OTHER_SWIFT_FLAGS[config=Debug]' => '-D DEBUG'
  }
  s.default_subspecs = 'Core'
  s.subspec 'Core' do |sub|
    sub.source_files = 'BinanceChain/Sources/Core/*.swift'
    sub.dependency 'Alamofire'
    sub.dependency 'SwiftyJSON'
    sub.dependency 'SwiftProtobuf'
    sub.dependency 'Starscream'
    sub.dependency 'Bech32'
    sub.dependency 'XCGLogger'
    sub.dependency 'secp256k1.swift'
  end
end
