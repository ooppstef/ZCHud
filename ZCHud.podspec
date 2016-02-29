Pod::Spec.new do |s|
  s.name         = "ZCHud"  
  s.version      = "0.1.0"  
  s.summary      = "A Simple Usage Hud" 
  s.homepage     = "https://github.com/ooppstef/ZCHud"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.platform     = :ios, "7.0"    
  s.source       = { :git => "https://github.com/ooppstef/ZCHud.git", :tag => s.version }
  s.source_files = "ZCHud/Sources/**/*.{h,m}" 
  s.author       = { "Charles" => "ooppstef@gmail.com" }
  s.requires_arc = true
end