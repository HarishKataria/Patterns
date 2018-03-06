Pod::Spec.new do |s|
  s.name = 'Patterns'
  s.version = '1.0.2'
  s.license = 'MIT'
  s.summary = 'Simplifying pattern building in Swift'
  s.homepage = 'https://github.com/harishkataria/Patterns'
  s.authors = { 'Harish Kataria' => 'hkatariajob@gmail.com' }
  s.source = { :git => 'https://github.com/harishkataria/Patterns.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'Source/**/*.swift'
end
