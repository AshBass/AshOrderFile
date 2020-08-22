
Pod::Spec.new do |s|
  s.name             = 'AshOrderFile'
  s.version          = '0.0.1'
  s.summary          = 'For order file'
  s.homepage         = 'https://github.com/AshBass/AshOrderFile'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AshBass' => 'ashbass@163.com' }
  s.source           = { :git => 'https://github.com/AshBass/AshOrderFile.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.ios.source_files = 'AshOrderFile/*.{h,m}'
  s.ios.preserve_path = 'AshOrderFile/AshOrderFile.rb'

end
