#
# Be sure to run `pod lib lint MHLocation.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MHLocation'
  s.version          = '0.1.0'
  s.summary          = 'A short description of MHLocation.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/malhal/MHLocation'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Malcolm Hall' => 'malhal@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/malhal/MHLocation.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/malhal'

  s.ios.deployment_target = '8.0'

s.source_files = 'MHLocation/**/*.{h,m}'

#s.resource_bundles = {
#    'MHLocation' => ['MHLocation/*.{xcassets,xcdatamodeld}']
#  }

s.resources             = [ 'MHLocation/*.xcassets',
'MHLocation/*.xcdatamodeld']


  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit', 'CoreLocation'
  # s.dependency 'AFNetworking', '~> 2.3'
end
