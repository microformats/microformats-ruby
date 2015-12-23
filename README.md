# Microformats2

# Development Status

This gem sat unmaintained for quite a long time. It's now under new management. Work will begin shortly on getting it on par with the other Microformats2 parsers and the current state of the spec. (2015-12-23) 

[![Build Status](https://travis-ci.org/indieweb/microformats2-ruby.png?branch=master)](https://travis-ci.org/indieweb/microformats2-ruby)
[![Code Climate](https://codeclimate.com/github/indieweb/microformats2-ruby/badges/gpa.svg)](https://codeclimate.com/github/indieweb/microformats2-ruby)

A Ruby gem to parse HTML containing one or more [microformats2](http://microformats.org/wiki/microformats-2)
and return a collection of dynamically defined Ruby objects.

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
* backwards compatable support for microformats v1


## Current Version

2.0.1


## Requirements

* "nokogiri"
* "json"
* "activesupport"


## Installation

Add this line to your application's Gemfile:

    gem 'microformats2'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install microformats2


## Usage

```ruby
require "microformats2"

source = '<div class="h-card"><p class="p-name">Jessica Lynn Suttles</p></div>'
collection = Microformats2.parse(source)
# using singular accessors
collection.card.name.to_s #=> "Jessica Lynn Suttles"
# using plural accessors
collection.cards.first.names.first.to_s #=> "Jessica Lynn Suttles"

source = '<article class="h-entry">
  <h1 class="p-name">Microformats 2</h1>
  <div class="h-card p-author"><p class="p-name">Jessica Lynn Suttles</p></div>
</article>'
collection = Microformats2.parse(source)
collection.entry.name.to_s #=> "Microformats 2"
# accessing nested microformats
collection.entry.author.format.name.to_s #=> "Jessica Lynn Suttles"

# getting a copy of the canonical microformats2 hash structure
collection.to_hash

# the above, as JSON in a string
collection.to_json
```

* `source` can be a URL, filepath, or HTML

## Authors

* Jessica Lynn Suttles / [@jlsuttles](https://github.com/jlsuttles)
* Shane Becker / [@veganstraightedge](https://github.com/veganstraightedge)
* Chris Stringer / [@jcstringer](https://github.com/jcstringer)
* Michael Mitchell / [@variousred](https://github.com/variousred)
* Jessica Dillon / [@jessicard](https://github.com/jessicard)

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

To update spec cases that are scraped from other sites.
**Warning:** This could break specs.
```bash
rake specs:update
```

To run specs
```bash
rake spec
```

To keep specs running
```bash
guard
```


## License

Microformats2 is dedicated to the public domain using Creative Commons -- CC0 1.0 Universal.

http://creativecommons.org/publicdomain/zero/1.0
