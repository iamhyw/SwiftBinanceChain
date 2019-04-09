source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

def common
	pod 'BinanceChain', :path => '.'
	pod 'SwiftProtobuf', :inhibit_warnings => true
	pod 'Starscream', :inhibit_warnings => true
	pod 'Bech32', :podspec => '.podspecs/Bech32.podspec'
end

target "BinanceChain" do
	platform :ios, '10.0'
	common
end

target "Desktop" do
	platform :macos, '10.10'
	common
end
