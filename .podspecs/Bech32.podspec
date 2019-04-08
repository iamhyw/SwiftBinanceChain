Pod::Spec.new do |s|
  s.name             = "Bech32"
  s.version          = "1.0.0"
  s.summary          = "Base32 address format for native v0-16 witness outputs implementation"
  s.homepage         = "https://github.com/0xDEADP00L/Bech32"
  s.license          = 'MIT'
  s.author           = { "0xDEADP00L" => "0xDEADP00L" }
  s.source           = { :git => "git@github.com:0xDEADP00L/Bech32.git" }
  s.ios.deployment_target	= 10.0
  s.tvos.deployment_target	= 10.0
  s.macos.deployment_target	= 10.9
  s.watchos.deployment_target	= 2.0
  s.requires_arc = true
  s.source_files = 'Sources/*.swift'
end
