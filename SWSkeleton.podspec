Pod::Spec.new do |s|
s.name             = 'SWSkeleton'
s.version          = '0.1.6'
s.summary          = 'MVVM application skeleton'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
List of used protocols
DESC

s.homepage         = 'https://github.com/SkywellDevelopers/SWSkeleton'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'SkywellDevelopers'=> 'helpdesk@skywell.com.ua' }
s.source           = { :git => 'https://github.com/SkywellDevelopers/SWSkeleton.git', :tag => s.version.to_s }

s.ios.deployment_target = '10.0'

s.source_files     = "SWSkeleton/**/*.{swift}"
s.framework        = 'UIKit'
s.ios.xcconfig     = { "OTHER_SWIFT_FLAGS[config=Debug]" => "-D DEBUG" }
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
s.xcconfig = { 'SWIFT_VERSION' => '4.0' }

s.dependency 'Alamofire', '4.6.0'
s.dependency 'AlamofireImage', '3.3.0'
s.dependency 'RxSwift', '4.1.0'
s.dependency 'RxCocoa', '4.1.0'
s.dependency 'RealmSwift', '3.0.2'
s.dependency 'ObjectMapper', '3.1.0'

end
