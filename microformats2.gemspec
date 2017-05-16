# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'microformats2/version'

Gem::Specification.new do |gem|
  gem.name          = "microformats2"
  gem.version       = Microformats2::VERSION
  gem.authors       = ["Shane Becker", "Jessica Lynn Suttles", "Ben Roberts"]
  gem.email         = ["veganstraightedge@gmail.com", "jlsuttles@gmail.com", "ben@thatmustbe.me"]
  gem.description   = %q{Parses HTML for microformats and return a collection of dynamically defined Ruby objects}
  gem.summary       = %q{microformats2 parser}
  gem.homepage      = "https://github.com/indieweb/microformats2-ruby"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.post_install_message = %q{
The name of the Microformats Ruby Parser is changing from "microformats2" to "microformats". This is a one time change. (Thanks to @chrisjpowers for transferring the namespace to us.)

Follow these instructions to migrate.

1. Install the new gem. Uninstall the old gem.

    gem install microformats
    gem uninstall microformats2


2. Change any Gemfiles from:

    gem "microformats2"

to

    gem "microformats"
    bundle


3. Change any requires from:

    require "microformats2"

to

    require "microformats"
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
