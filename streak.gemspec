# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'streak/version'

# require File.expand_path('../lib/streak/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["David Czarnecki"]
  gem.email         = ["me@davidczarnecki.com"]
  gem.description   = %q{Streak is a gem for calculating win/loss streaks}
  gem.summary       = %q{Streak is a gem for calculating win/loss streaks}
  gem.homepage      = "https://github.com/czarneckid/streak"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "streak"
  gem.require_paths = ["lib"]
  gem.version       = Streak::VERSION

  gem.add_dependency 'redis'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
end
