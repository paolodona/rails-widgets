# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Paolo Dona", "Marco Campana"]
  gem.email         = ["paolo.dona@homestays.com"]
  gem.description   = %q{Ruby on Rails widgets}
  gem.summary        = %q{Ruby on Rails widgets}
  gem.homepage      = "https://github.com/paolodona/rails-widgets"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "rails-widgets"
  gem.require_paths = ["lib"]
  gem.version       = '1.0.0'
  gem.platform      = Gem::Platform::RUBY

  gem.add_dependency "railties", "~> 3.0"
  gem.add_development_dependency "rails",              "~> 3.0"
end
