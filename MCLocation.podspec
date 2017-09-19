#
# Be sure to run `pod lib lint MCLocation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MCLocation'
  s.version          = '0.1.0'
  s.summary          = 'A short description of MCLocation.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/malhal/MCLocation'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Malcolm Hall' => 'malhal@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/malhal/MCLocation.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/malhal'

  s.ios.deployment_target = '8.0'

s.source_files = 'MCLocation/**/*.{h,m}'

#s.resource_bundles = {
#    'MCLocation' => ['MCLocation/*.{xcassets,xcdatamodeld}']
#  }

s.resources             = [ 'MCLocation/*.xcassets',
'MCLocation/*.xcdatamodeld']


  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit', 'CoreLocation'
  # s.dependency 'AFNetworking', '~> 2.3'
end
