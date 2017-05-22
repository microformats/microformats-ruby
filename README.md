# Microformats (ruby)

[![Build Status](https://travis-ci.org/indieweb/microformats-ruby.svg)](https://travis-ci.org/indieweb/microformats-ruby)
[![Code Climate](https://codeclimate.com/github/indieweb/microformats-ruby/badges/gpa.svg)](https://codeclimate.com/github/indieweb/microformats-ruby)

A Ruby gem to parse HTML containing one or more microformats and [microformats2](http://microformats.org/wiki/microformats-2)
and return a collection of dynamically defined Ruby objects, a Ruby hash or a JSON hash.


## Development Status

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
* nested microformat without associated property
* [value-class-pattern](http://microformats.org/wiki/value-class-pattern)
* recognition of [vendor extensions](http://microformats.org/wiki/microformats2#VENDOR_EXTENSIONS)
* backward compatible support for microformats v1

Not Implemented:

* [include-pattern](http://microformats.org/wiki/include-pattern)


## Current Version

4.0.3

![Version 4.0.3](https://img.shields.io/badge/VERSION-4.0.3-green.svg)


## Requirements

* [nokogiri](https://github.com/sparklemotion/nokogiri)
* [json](https://github.com/flori/json)


## Installation

Add this line to your application's Gemfile:

```ruby
gem "microformats"
```

And then execute:

```
bundle
```

Or install it yourself as:

```
gem install microformats
```


## Usage

```ruby
require "microformats"

source = "<div class='h-card'><p class='p-name'>Jessica Lynn Suttles</p></div>"
collection = Microformats.parse(source)

# getting a copy of the canonical microformats hash structure
collection.to_hash

# the above, as JSON in a string
collection.to_json

# shortcuts

# return a string if there is only one item found
collection.card.name #=> "Jessica Lynn Suttles"

source = "<article class='h-entry'>
  <h1 class='p-name'>Microformats 2</h1>
  <div class='h-card p-author'><p class='p-name'><span class='p-first-name'>Jessica</span> Lynn Suttles</p></div>
</article>"
collection = Microformats.parse(source)
collection.entry.name.to_s #=> "Microformats 2"

# accessing nested microformats
collection.entry.author.name.to_s #=> "Jessica Lynn Suttles"

# accessing nested microformats can use shortcuts or more expanded method
collection.entry.author.name #=> "Jessica Lynn Suttles"
collection.entry.properties.author.properties.name.to_s #=> "Jessica Lynn Suttles"

# use _ instead of - to get these items
collection.entry.author.first_name #=> "Jessica"
collection.rel_urls #=> {}

source = "<article class='h-entry'>
  <h1 class='p-name'>Microformats 2</h1>
  <div class='h-card p-author'><p class='p-name'><span class='p-first-name'>Jessica</span> Lynn Suttles</p></div>
  <div class='h-card p-author'><p class='p-name'><span class='p-first-name'>Brandon</span> Edens</p></div>
</article>"
collection = Microformats.parse(source)

# arrays of items with always take the first item by default
collection.entry.author.name #=> "Jessica Lynn Suttles"
collection.entry.author(1).name #=> "Brandon Edens"

# get the actual array with :all
collection.entry.author(:all).count #=> 2
collection.entry.author(:all)[1].name #=> "Brandon Edens"

```

* `source` can be a URL, filepath, or HTML

### Console utility

This gem also provides a command like script 'microformats' that will return the JSON equivalent
```
microformats http://example.com
```

You can give the microformats script a URL, filepath, or HTML

additionally, the script will accept input piped from stdin

```
curl http://example.com | microformats
```



## Ruby Gem release process

Check out latest code from GitHub repo.

```
git pull origin master
```

Make sure the version has been bumped up in all four places:

- [lib/microformats/version.rb](https://github.com/indieweb/microformats-ruby/blob/master/lib/microformats/version.rb#L2)
- [README.md (three places)](https://github.com/indieweb/microformats-ruby/blob/master/README.md)

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
gem uninstall microformats
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

[https://rubygems.org/gems/microformats](https://rubygems.org/gems/microformats)

If `rake release` failed because of an error with your authentication to rubygems.org, follow their instructions in the error message. Then repeat the `rake release` step.

If any other errors failed along the way before `rake release`, try to figure them out or reach out to the IRC/Slack channel for help.

Good luck.


## Authors

- Ben Roberts / [@dissolve](https://github.com/dissolve)
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
[file an issue](https://github.com/indieweb/microformats-ruby/issues).


## Testing

### Specs

This uses a copy of  [microformats tests repo](https://github.com/microformats/tests).

To run specs
```
rake spec

### Interactive

You can use the code interacively for testing but running
```
bundle console
```

## License

Microformats (ruby) is dedicated to the public domain using Creative Commons -- CC0 1.0 Universal.

http://creativecommons.org/publicdomain/zero/1.0
