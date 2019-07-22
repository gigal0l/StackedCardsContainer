#
# Be sure to run `pod lib lint StackedCardsContainer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'StackedCardsContainer'
  s.version          = '1.5.0'
  s.summary          = 'StackedCardsContainer'


  s.homepage         = 'https://github.com/AndrewZub/StackedCardsContainer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AndrewZub' => 'andrew@wearemad.ru' }
  s.source           = { :git => 'https://github.com/AndrewZub/StackedCardsContainer.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'StackedCardsContainer/Classes/**/*'
  s.swift_version = '4.2'
end
