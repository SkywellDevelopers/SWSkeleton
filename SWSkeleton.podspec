Pod::Spec.new do |s|
s.name             = 'SWSkeleton'
s.version          = '0.4.4'
s.summary          = 'MVVM application skeleton'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
Group of useful utilities and extensions to make application development process quicker
DESC

s.homepage         = 'https://github.com/SkywellDevelopers/SWSkeleton'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'SkywellDevelopers'=> 'helpdesk@skywell.com.ua' }
s.source           = { :git => 'https://github.com/SkywellDevelopers/SWSkeleton.git', :tag => s.version.to_s }

s.ios.deployment_target = '11.0'

s.source_files     = 'SWSkeleton/Core/**/*'
s.framework        = 'UIKit'
s.ios.xcconfig     = { "OTHER_SWIFT_FLAGS[config=Debug]" => "-D DEBUG" }
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
s.xcconfig = { 'SWIFT_VERSION' => '5.0' }
s.swift_version = '5.0'

s.dependency 'Alamofire', '4.8.2'
s.dependency 'AlamofireImage', '3.5.2'
s.dependency 'RealmSwift', '3.21.0'
s.dependency 'RxSwift', '5.1.1'
s.dependency 'RxCocoa', '5.1.1'
s.dependency 'RxSwiftExt', '5.2.0'

end
