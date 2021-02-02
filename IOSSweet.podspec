#
# Be sure to run `pod lib lint YetIOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  prjName = 'IOSSweet'
  s.name             = prjName
  s.version          = '1.0.0'
  s.summary          = "#{prjName} is an iOS  library writen by swift."
  s.description      = "#{prjName} is an iOS library writen by swift. OK"
 

  s.homepage         = "https://github.com/yangentao/#{prjName}"
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangentao' => 'entaoyang@163.com' }
  s.source           = { :git => "https://github.com/yangentao/#{prjName}.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

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
  # s.dependency 'AFNetworking', '~> 2.3'

end
