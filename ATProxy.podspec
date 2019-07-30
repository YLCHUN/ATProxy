#
# Be sure to run `pod lib lint ATProxy.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ATProxy'
  s.version          = '0.2.4'
  s.summary          = '转场动画代理的代理，不再关心转场代理，实现灵活运用专场动画和交互动画。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

#  s.description      = <<-DESC
#TODO: Add long description of the pod here.
#                       DESC

  s.homepage         = 'https://github.com/youlianchun/ATProxy'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'YLCHUN' => 'youlianchunios@163.com' }
  s.source           = { :git => 'https://github.com/youlianchun/ATProxy.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.static_framework = true
  s.source_files = 'ATProxy/Classes/**/*'
  
  s.subspec 'ATProxy' do |ss|
    ss.ios.libraries = 'c++'
    ss.source_files = 'ATProxy/ATProxy/**/*'
  end
  
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'NO',
  }
  
  # s.resource_bundles = {
  #   'ATProxy' => ['ATProxy/Assets/*.png']
  # }

  s.public_header_files = 'ATProxy/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
