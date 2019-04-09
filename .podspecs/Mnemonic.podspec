Pod::Spec.new do |spec|
  spec.name = 'Mnemonic'
  spec.version = '1.0.1'
  spec.summary = 'An implementation of BIP39 used Swift.'
  spec.description = <<-DESC
                       Swift implementation of Bitcoin BIP39: Mnemonic code for generating deterministic keys.
                       ```
                    DESC
  spec.homepage = 'https://github.com/onerootproject/Mnemonic'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = { 'Liu Pengpeng' => 'i@liupengpeng.com' }
  spec.social_media_url = 'https://twitter.com/pengpengliu'

  spec.source = { git: 'https://github.com/onerootproject/Mnemonic.git', tag: "v#{spec.version}" }
  spec.source_files = 'Mnemonic/**/*.{h,m,swift}'
  
  spec.ios.deployment_target = '10.0'
  spec.tvos.deployment_target = '10.0'
  spec.macos.deployment_target = '10.9'
  spec.watch.deployment_target = '2.0'
  spec.swift_version = '4.0'

  spec.dependency 'CryptoSwift'
end
