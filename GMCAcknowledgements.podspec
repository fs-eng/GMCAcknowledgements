Pod::Spec.new do |s|
    s.name = "GMCAcknowledgements"
    s.version = "1.0.1"
    s.summary = "GMCAcknowledgements is a quick and easy way to include the acknowledgements file generated by CocoaPods."
    s.author = 'Hilton Campbell'
    s.homepage = "https://github.com/GalacticMegacorp/GMCAcknowledgements"
    s.license = 'MIT'
    s.source = { :git => "https://github.com/GalacticMegacorp/GMCAcknowledgements.git", :tag => s.version.to_s }
    s.platform = :ios, '6.1'
    s.source_files = 'GMCAcknowledgements/*.{h,m}'
    s.resources = 'GMCAcknowledgements/Resources/*.{lproj,html}'
    s.requires_arc = true
    s.frameworks = 'UIKit'
    
    s.dependency 'MMMarkdown'
end