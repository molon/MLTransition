Pod::Spec.new do |s|
  s.name         = "MLTransition"
  s.version      = "1.0"
  s.summary      = "仅仅iOS7可用, 拖返可直接从中间拖返。一句代码即可启用此功能。可随意设置leftBarButtonItem，也可使用边界拖返模式。(非截图实现，拖返过程中显示的view都是活动的) "
  s.homepage     = "https://github.com/molon/MLTransition"
  s.license      = "MIT"
  s.authors      = { "molon" => "dudl@qq.com" }
  s.source       = { :git => "https://github.com/molon/MLTransition.git", :tag => "1.0" }
  s.frameworks   = 'Foundation', 'CoreGraphics', 'UIKit'
  s.platform     = :ios, '7.0'
  s.source_files = 'MLBlackTransition/*.{h,m}'
  s.requires_arc = true
end
