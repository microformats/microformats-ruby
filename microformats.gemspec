# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'microformats/version'

Gem::Specification.new do |gem|
  gem.name          = "microformats"
  gem.version       = Microformats::VERSION
  gem.authors       = ["Shane Becker", "Jessica Lynn Suttles", "Ben Roberts"]
  gem.email         = ["veganstraightedge@gmail.com", "jlsuttles@gmail.com", "ben@thatmustbe.me"]
  gem.description   = %q{Parses HTML for microformats and return a collection of dynamically defined Ruby objects}
  gem.summary       = %q{Microformats and microformats2 parser}
  gem.homepage      = "https://github.com/indieweb/microformats-ruby"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.post_install_message = %q{

Previously called "microformats2" (on version 3.1 and below).

}

  gem.required_ruby_version = ">= 2.0"

  gem.add_runtime_dependency "nokogiri"
  gem.add_runtime_dependency "json"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "rb-fsevent"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "webmock"
end
