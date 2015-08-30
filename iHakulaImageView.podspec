Pod::Spec.new do |s|

s.platform                 = :ios
s.ios.deployment_target    = '7.1'
s.version                  = "0.1.0"
s.name                     = "iHakulaImageView"
s.author                   = { "Wayde Sun" => "wsun191@gmail.com" }
s.homepage                 = "https://github.com/wayde191/iHakulaImageView"
s.summary                  = "iHakulaImageView shoudl be prepared when you want to use all IHakula components."
s.source                = { :git => "https://github.com/wayde191/iHakulaImageView.git", :tag => "#{s.version}"}
s.license               = { :type => "MIT", :file => "LICENSE" }

s.requires_arc             = true
s.framework                = "UIKit", "Foundation"

s.dependency 'IHakulaInfrastructure', '~> 0.2.0'

s.public_header_files = "#{s.name}/#{s.name}/**/*.{h}"
s.source_files  = "#{s.name}/#{s.name}/*.{h}"

s.subspec 'iHStretchableView' do |stretch|
stretch.source_files = "#{s.name}/#{s.name}/iHStretchableView/*.{h,m}"
end

s.subspec 'iHPageView' do |page|
page.source_files = "#{s.name}/#{s.name}/iHPageView/**/*.{h,m,png}"
end

s.subspec 'iHImageView' do |image|
image.source_files = "#{s.name}/#{s.name}/iHImageView/*.{h,m}"
end

s.subspec 'iHImageSlideView' do |slide|
slide.dependency "#{s.name}/iHImageView"
slide.source_files = "#{s.name}/#{s.name}/iHImageSlideView/*.{h,m,png}"
end

end