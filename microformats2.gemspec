# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'microformats2/version'

Gem::Specification.new do |gem|
  gem.name          = "microformats2"
  gem.version       = Microformats2::VERSION
  gem.authors       = ["Shane Becker", "Jessica Lynn Suttles", "Jessica Dillon"]
  gem.email         = ["veganstraightedge@gmail.com", "jlsuttles@gmail.com", "jessicard@mac.com"]
  gem.description   = %q{Parses HTML for microformats and return a collection of dynamically defined Ruby objects}
  gem.summary       = %q{microformats2 parser}
  gem.homepage      = "https://github.com/indieweb/microformats2-ruby"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "nokogiri"
  gem.add_runtime_dependency "json"
  gem.add_runtime_dependency "activesupport"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "rb-fsevent"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "webmock"

  gem.post_install_message = %q{

  "Calling all. This is our last cry before our eternal silence."
  - The 2.X version.

  Coming VERY SOON: The 3.0 Version!

  3.0 is a nearly complete re-write of the Microformats Ruby parser.
  3.0 will fix almost all outstanding issues on the GitHub repo,
  add classical Microformats support and more! But unfortunately,
  the cost of doing this is that there will be some breaking changes
  and changing API.

  The 2.9 release is a transitional release. Really, we want you using 3.0,
  but 2.9 gives you an opportunity to run your tests, fix any deprecation warnings,
  and be able to migrate to 3.0 with greater confidence. 

  In addition to deprecation warnings on changing methods,
  there are two changes that will not throw a warning:

  - no more exposed Nokogiri objects
  - the class names are changing

  If you depend on either of those directly, you'll want to do additional
  manual acceptance testing in this transition to 2.9 and 3.0.

  <3 

  }

end
