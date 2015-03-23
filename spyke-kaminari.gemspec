Gem::Specification.new('spyke-kaminari', '0.0.4') do |spec|
  spec.authors  = ['Todd Mazierski']
  spec.email    = ['todd@generalassemb.ly']
  spec.homepage = 'https://github.com/generalassembly/spyke-kaminari'
  spec.summary  = 'Kaminari pagination for Spyke models'
  spec.files    =  Dir['lib/**/*']

  spec.add_runtime_dependency 'spyke', '~>  3.1'
  spec.add_runtime_dependency 'activesupport', '~> 4'

  spec.add_development_dependency 'rspec', '3.1.0'
  spec.add_development_dependency 'pry', '0.10.1'
  spec.add_development_dependency 'webmock', '~> 1.20'
end
