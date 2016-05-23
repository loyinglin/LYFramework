Pod::Spec.new do |s|
s.name = 'LYFramework'
s.version = '1.0.0'
s.license = 'MIT'
s.summary = 'useful method'
s.homepage = 'https://github.com/loyinglin/LYFramework'
s.authors = { 'loyinglin' => 'loying@foxmail.com' }
s.source = { :git => "https://github.com/loyinglin/LYFramework.git", :tag => s.version}
s.requires_arc = true
s.ios.deployment_target = '7.0'
s.source_files = 'LYFramework/**/*.{h,m}'
end
