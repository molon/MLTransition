Pod::Spec.new do |s|
s.name         = "MLTransition"
s.version      = "2.1.3"
s.summary      = "iOS7+, pop ViewController with pan gesture from middle or edge of screen. "
s.homepage     = "https://github.com/molon/MLTransition"
s.license      = "MIT"
s.author      = { "molon" => "dudl@qq.com" }

s.source       = {
:git => "https://github.com/molon/MLTransition.git",
:tag => "#{s.version}"
}

s.platform     = :ios, '7.0'
s.public_header_files = 'Classes/*.h'
s.source_files = 'Classes/*.{h,m}'
s.requires_arc = true

end
