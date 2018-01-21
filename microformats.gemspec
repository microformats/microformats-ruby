lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'microformats/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = ['>= 2.0', '< 2.6']

  spec.name          = 'microformats'
  spec.version       = Microformats::VERSION
  spec.authors       = ['Shane Becker', 'Jessica Lynn Suttles', 'Ben Roberts']
  spec.email         = ['veganstraightedge@gmail.com', 'jlsuttles@gmail.com', 'ben@thatmustbe.me']

  spec.summary       = 'Microformats2 and classic microformats parser'
  spec.description   = 'A Ruby gem to parse HTML containing microformats2 and classic microformats that returns a collection of dynamically defined Ruby objects, a Ruby hash, or a JSON hash.'
  spec.homepage      = 'https://github.com/indieweb/microformats-ruby'
  spec.license       = 'CC0-1.0'

  spec.files         = `git ls-files`.split("\x0").select { |f| f.match(%r{^(bin|lib)/}) }

  spec.bindir        = 'bin'
  spec.executables   = ['microformats']
  spec.require_paths = ['lib']

  spec.post_install_message = 'Prior to version 4.0.0, the microformats gem was named "microformats2."'

  spec.add_development_dependency 'guard-rspec', '~> 4.7', '>= 4.7.3'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rb-fsevent', '~> 0.10.2'
  spec.add_development_dependency 'rspec', '~> 3.7'
  spec.add_development_dependency 'rubocop', '~> 0.52.1'
  spec.add_development_dependency 'simplecov', '~> 0.15.1'
  spec.add_development_dependency 'simplecov-console', '~> 0.4.2'
  spec.add_development_dependency 'webmock', '~> 3.3'

  spec.add_runtime_dependency 'json', '~> 2.1'
  spec.add_runtime_dependency 'nokogiri', '~> 1.8', '>= 1.8.1'
end
