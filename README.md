# Microformats2 (ruby)

[![Build Status](https://travis-ci.org/indieweb/microformats2-ruby.png?branch=master)](https://travis-ci.org/indieweb/microformats2-ruby)
[![Code Climate](https://codeclimate.com/github/indieweb/microformats2-ruby/badges/gpa.svg)](https://codeclimate.com/github/indieweb/microformats2-ruby)

A Ruby gem to parse HTML containing one or more [microformats2](http://microformats.org/wiki/microformats-2)
and return a collection of dynamically defined Ruby objects.


## Development Status

This gem sat unmaintained for quite a long time. It's now under new management. Work will begin shortly on getting it on par with the other Microformats2 parsers and the current state of the spec. (2015-12-23)

A work in progress.

Implemented:

* [parsing depth first, doc order](http://microformats.org/wiki/microformats2-parsing#parse_a_document_for_microformats)
* [parsing a p- property](http://microformats.org/wiki/microformats2-parsing#parsing_a_p-_property)
* [parsing a u- property](http://microformats.org/wiki/microformats2-parsing#parsing_a_u-_property)
* [parsing a dt- property](http://microformats.org/wiki/microformats2-parsing#parsing_a_dt-_property)
* [parsing a e- property](http://microformats.org/wiki/microformats2-parsing#parsing_an_e-_property)
* [parsing implied properties](http://microformats.org/wiki/microformats-2-parsing#parsing_for_implied_properties)
* nested properties
* nested microformat with associated property
* dynamic creation of properties
* [rel](http://microformats.org/wiki/rel)
* [normalize u-* property values](http://microformats.org/wiki/microformats2-parsing-faq#normalizing_u-.2A_property_values)

Not Implemented:

* nested microformat without associated property
* [value-class-pattern](http://microformats.org/wiki/value-class-pattern)
* [include-pattern](http://microformats.org/wiki/include-pattern)
* recognition of [vendor extensions](http://microformats.org/wiki/microformats2#VENDOR_EXTENSIONS)
* backwards compatible support for microformats v1


## Current Version

2.9.0

![Version 2.9.0](https://img.shields.io/badge/VERSION-2.9.0-green.svg)


## Requirements

* [nokogiri](https://github.com/sparklemotion/nokogiri)
* [json](https://github.com/flori/json)
* [activesupport](https://github.com/rails/rails/tree/master/activesupport)


## Installation

Add this line to your application's Gemfile:

```ruby
gem "microformats2"
```

And then execute:

```
bundle
```

Or install it yourself as:

```
gem install microformats2
```


## Usage

```ruby
require "microformats2"

source = "<div class='h-card'><p class='p-name'>Jessica Lynn Suttles</p></div>"
collection = Microformats2.parse(source)
# using singular accessors
collection.card.name.to_s #=> "Jessica Lynn Suttles"
# using :all returns an array
collection.card(:all)[0].name(:all).first.to_s #=> "Jessica Lynn Suttles"

source = "<article class='h-entry'>
  <h1 class='p-name'>Microformats 2</h1>
  <div class='h-card p-author'><p class='p-name'>Jessica Lynn Suttles</p></div>
</article>"
collection = Microformats2.parse(source)
collection.entry.name.to_s #=> "Microformats 2"
# accessing nested microformats
collection.entry.author.name.to_s #=> "Jessica Lynn Suttles"

# getting a copy of the canonical microformats2 hash structure
collection.to_hash

# the above, as JSON in a string
collection.to_json
```

* `source` can be a URL, filepath, or HTML


## Ruby Gem release process

Check out latest code from GitHub repo.

```
git pull origin master
```

Make sure the version has been bumped up in all four places:

- [lib/microformats2/version.rb](https://github.com/indieweb/microformats2-ruby/blob/master/lib/microformats2/version.rb#L2)
- [README.md (three places)](https://github.com/indieweb/microformats2-ruby/blob/master/README.md)

Do a test build locally to make sure it builds properly.

```
rake build
```

If that works, then do a test install locally.

  ```
rake install
```

If that works, uninstall the gem.

```
gem uninstall microformats2
```

Clean up any mess made from testing.

```
rake clean
rake clobber
```

Assuming your one of the gem owners and have release privileges, release the gem!

```
rake release
```

If that works, you’ve just release a new version of the gem! Yay! You can see it at:

[https://rubygems.org/gems/microformats2](https://rubygems.org/gems/microformats2)

If `rake release` failed because of an error with your authentication to rubygems.org, follow their instructions in the error message. Then repeat the `rake release` step.

If any other errors failed along the way before `rake release`, try to figure them out or reach out to the IRC/Slack channel for help.

Good luck.


## Authors

- Jessica Lynn Suttles / [@jlsuttles](https://github.com/jlsuttles)
- Shane Becker / [@veganstraightedge](https://github.com/veganstraightedge)
- Chris Stringer / [@jcstringer](https://github.com/jcstringer)
- Michael Mitchell / [@variousred](https://github.com/variousred)
- Jessica Dillon / [@jessicard](https://github.com/jessicard)
- Jeena Paradies / [@jeena](https://github.com/jeena)
- Marty McGuire / [@martymcguire](https://github.com/martymcguire)

## Contributions

1. Fork it
2. Get it running (see Installation above)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Write your code and **specs**
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

If you find bugs, have feature requests or questions, please
[file an issue](https://github.com/indieweb/microformats2-ruby/issues).


## Specs

**TODO** remove this and use the [microformats tests repo](https://github.com/microformats/tests) instead.

To update spec cases that are scraped from other sites.
**Warning:** This could break specs.
```
rake specs:update
```

To run specs
```
rake spec
```


## License

Microformats2 (ruby) is dedicated to the public domain using Creative Commons -- CC0 1.0 Universal.

http://creativecommons.org/publicdomain/zero/1.0
