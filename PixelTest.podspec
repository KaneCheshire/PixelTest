Pod::Spec.new do |s|
  s.name             = 'PixelTest'
  s.version          = '2.0.0'
  s.summary          = 'PixelTest is a Swift-first, simple and modern snapshot testing tool.'
  s.description      = <<-DESC
  PixelTest is a modern, Swift-only snapshot testing tool.

  Snapshot testing compares one of your views rendered into an image, to a previously recorded image, allowing for 0% difference or the test will fail.

  Snapshot tests are perfect for quickly checking complex layouts, while at the same time future proofing them against accidental changes.

  As an added bonus, PixelTest also clears up after itself. If you fix a failing test, the failure and diff images are automatically removed for you.
                       DESC

  s.homepage         = 'https://github.com/kanecheshire/PixelTest'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kane Cheshire' => 'kane.cheshire@googlemail.com' }
  s.source           = { :git => 'https://github.com/kanecheshire/PixelTest.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/kanecheshire'

  s.ios.deployment_target = '9.0'
  s.source_files = 'PixelTest/**/*.swift'
  s.exclude_files = 'PixelTest/**/*.plist'
  s.frameworks = 'UIKit', 'XCTest'
  s.swift_version = '4.2'
  s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
end
