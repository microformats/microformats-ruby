# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'microformats2/version'

Gem::Specification.new do |gem|
  gem.name          = "microformats2"
  gem.version       = Microformats2::VERSION
  gem.authors       = ["Jessica Lynn Suttles"]
  gem.email         = ["jlsuttles@gmail.com"]
  gem.description   = %q{parses HTML for microformats and return a collection of dynamically defined Ruby objects}
  gem.summary       = %q{microformats2 parser}
  gem.homepage      = "https://github.com/G5/microformats2"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "nokogiri", "~> 1.5.6"
  gem.add_runtime_dependency "json", "~> 1.7.6"
  gem.add_runtime_dependency "activesupport", "~> 3.2.13"

  gem.add_development_dependency "rake", "~> 10.0.0"
  gem.add_development_dependency "rspec", "~> 2.11.0"
  gem.add_development_dependency "guard-rspec", "~> 2.1.0"
  gem.add_development_dependency "rb-fsevent", "~> 0.9.1"
  gem.add_development_dependency "simplecov", "~> 0.7.1"
  gem.add_development_dependency "debugger", "~> 1.2.1"
end
