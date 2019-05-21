#
# Be sure to run `pod lib lint ClingConstraints.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name         = "ClingConstraints"
  s.version      = "1.1.3"
  s.summary      = "Library for programmatic constraints in iOS; emphasis on readability"

  s.description  = <<-DESC
  A programmatic constraints library for iOS written using Swift 4.2.
  Easily write constraints in code and keep them readable!
                   DESC

  s.homepage     = "https://github.com/Chris-Perkins/ClingConstraints"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Chris Perkins" => "http://ChrisPerkins.me" }
  s.social_media_url   = "http://ChrisPerkins.me"

  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/Chris-Perkins/ClingConstraints.git", :tag => s.version.to_s }

  s.source_files = 'ClingConstraints/Classes/*.{h,m,swift}'
  s.swift_version = '4.2'
end
