
Pod::Spec.new do |s|

  s.name         = "ClingConstraints"
  s.version      = "1.1.1"
  s.summary      = "Library for programmatic constraints in iOS; emphasis on readability"

  s.description  = <<-DESC
  A programmatic constraints library for iOS written using Swift 4.2.
  Easily write constraints in code and keep them readable!
                   DESC

  s.homepage     = "https://github.com/Chris-Perkins/ClingConstraints"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Chris Perkins" => "http://ChrisPerkins.me" }
  s.social_media_url   = "http://ChrisPerkins.me"

  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/Chris-Perkins/ClingConstraints.git", :tag => "v#{s.version}" }

  s.source_files  = "ClingConstraints", "ClingConstraints/**/*.{h,m}"
  s.swift_version = '4.2'
end
