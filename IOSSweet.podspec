Pod::Spec.new do |s|
  prjName = 'IOSSweet'
  s.name             = prjName
  s.version          = '0.1.1'
  s.summary          = "#{prjName} is an iOS  library writen by swift."
  s.homepage         = "https://github.com/yangentao/#{prjName}"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangentao' => 'entaoyang@163.com' }
  s.source           = { :git => "https://github.com/yangentao/#{prjName}.git", :tag => s.version.to_s }

  s.platform = :ios
  s.ios.deployment_target = '12.0'
  s.swift_versions = ["5.0", "5.1", "5.2", "5.3"]
  s.source_files = "#{prjName}/Classes/**/*"
  s.resources = ["#{prjName}/Assets/*"]

  
  # s.resource_bundles = {
  #   prjName => ["#{prjName}/Assets/*.png"]
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'CFNetwork', 'CoreGraphics', 'AVFoundation', 'Photos'
  s.dependency 'SwiftSweet', '0.1.6'

end
