lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'microformats/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = ['>= 2.7']

  spec.name          = 'microformats'
  spec.version       = Microformats::VERSION
  spec.authors       = ['Shane Becker', 'Jessica Lynn Suttles', 'Ben Roberts']
  spec.email         = ['veganstraightedge@gmail.com', 'jlsuttles@gmail.com', 'ben@thatmustbe.me']

  spec.summary       = 'Microformats2 and classic microformats parser'
  spec.description   = 'A Ruby gem to parse HTML containing microformats2 and classic microformats that returns a collection of dynamically defined Ruby objects, a Ruby hash, or a JSON hash.'
  spec.homepage      = 'https://github.com/microformats/microformats-ruby'
  spec.license       = 'CC0-1.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|vendor)/}) }
  spec.bindir        = 'bin'
  spec.executables   = ['microformats']
  spec.require_paths = ['lib']

  spec.post_install_message = 'Prior to version 4.0.0, the microformats gem was named "microformats2."'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rb-fsevent'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-console'
  spec.add_development_dependency 'webmock'

  spec.add_runtime_dependency 'json'
  spec.add_runtime_dependency 'nokogiri'
end
