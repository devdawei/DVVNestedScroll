
Pod::Spec.new do |s|

s.name         = 'DVVNestedScroll'
s.summary      = 'iOS 嵌套滚动控制，类似于美团，饿了么首页效果'
s.version      = '1.0.0'
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.authors      = { 'devdawei' => '2549129899@qq.com' }
s.homepage     = 'https://github.com/devdawei'

s.platform     = :ios
s.ios.deployment_target = '9.0'
s.requires_arc = true

s.source       = { :git => 'https://github.com/devdawei/DVVNestedScroll.git', :tag => s.version.to_s }

s.source_files = 'DVVNestedScroll/DVVNestedScroll/*.{h,m}'

s.frameworks = 'Foundation', 'UIKit'

end
