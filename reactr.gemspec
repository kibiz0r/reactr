# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = 'reactr'
  gem.description   = "Reactive programming for Ruby"
  gem.homepage      = "https://github.com/kibiz0r/#{gem.name}"
  gem.version       = '0.0.1'

  gem.authors       = ['Michael Harrington']
  gem.email         = ['kibiz0r@gmail.com']

  gem.files         = `git ls-files`.split($\)
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'coalesce'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rr'

  gem.summary       = <<-END.gsub(/^ +/, '')
  Adds reactive operations to Ruby
  END
end
