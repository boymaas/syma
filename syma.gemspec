# -*- encoding: utf-8 -*-
require File.expand_path('../lib/syma/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Boy Maas"]
  gem.email         = ["boy.maas@gmail.com"]
  gem.description   = %q{Mininmal implemenation of the window driver pattern}
  gem.summary       = %q{Minimal window driver pattern implementation}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "syma"
  gem.require_paths = ["lib"]
  gem.version       = Syma::VERSION
  gem.add_dependency('colorize', '~> 0.5')
  gem.add_dependency('capybara', '~> 1.1')
end
