Pod::Spec.new do |s|
  s.name             = 'RemoteSettings'
  s.version          = '1.0.0'
  s.summary          = 'A self-hosted remote config.'
  s.description      = <<-DESC
  A simple library for fetching your self-hosted remote config with caching capabilities.
                       DESC

  s.homepage         = 'https://github.com/numen31337/remote_settings'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alexander Kirsch' => 'spam-reporter-3000@alexander-kirsch.com' }
  s.source           = { :git => 'https://github.com/numen31337/remote_settings.git', :tag => s.version.to_s }
  s.source_files     = 'Sources/RemoteSettings/**/*'
  s.swift_version    = '5.0'
  s.ios.deployment_target = '9.0'
end
