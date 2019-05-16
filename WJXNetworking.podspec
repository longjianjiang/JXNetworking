
Pod::Spec.new do |s|

  s.name         = "WJXNetworking"
  s.version      = "0.0.8"
  s.summary      = "A networking abstraction layer."


  s.homepage     = "https://github.com/longjianjiang/JXNetworking"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "longjianjiang" => "brucejiang5.7@gmail.com" }

  s.source       = { :git => "https://github.com/longjianjiang/JXNetworking.git", :tag => s.version.to_s }
  s.platform     = :ios, "8.0"
  s.requires_arc = true 
  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'Sources/JXNetworking/**/*.{h.m}'
    core.dependency 'AFNetworking'
    core.dependency 'CTMediator'
  end

  s.subspec 'ReactiveJXNetworking' do |ss|
    ss.source_files = 'Sources/ReactiveJXNetworking/'
    ss.dependency 'JXNetworking/Core'
    ss.dependency "ReactiveObjC"
  end
  
end
