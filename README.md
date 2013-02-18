# Microformats2

[![Build Status](https://travis-ci.org/G5/microformats2.png?branch=master)](https://travis-ci.org/G5/microformats2)
[![Code Climate](https://codeclimate.com/github/G5/microformats2.png)](https://codeclimate.com/github/G5/microformats2)

A Ruby gem to parse HTML containing one or more [microformats2](http://microformats.org/wiki/microformats-2)
and return a collection of dynamically defined Ruby objects.

A work in progress.

Implemented:

* [parsing depth first, doc order](parse_a_document_for_microformats)
* [parsing a p- property](http://microformats.org/wiki/microformats2-parsing#parsing_a_p-_property)
* [parsing a u- property](http://microformats.org/wiki/microformats2-parsing#parsing_a_u-_property)
* [parsing a dt- property](http://microformats.org/wiki/microformats2-parsing#parsing_a_dt-_property)
* [parsing a e- property](http://microformats.org/wiki/microformats2-parsing#parsing_a_e-_property)
* [parsing implied properties](http://microformats.org/wiki/microformats-2-parsing#parsing_for_implied_properties)
* nested properties
* nested microformat with associated property

Not Implemented:

* [normalize u-* property values](http://microformats.org/wiki/microformats2-parsing-faq#normalizing_u-.2A_property_values)
* nested microformat without associated property
* [rel](http://microformats.org/wiki/rel)
* [value-class-pattern](http://microformats.org/wiki/value-class-pattern)
* [include-pattern](http://microformats.org/wiki/include-pattern)
* recognition of [vendor extensions](http://microformats.org/wiki/microformats2#VENDOR_EXTENSIONS)
* backwards compatable support for microformats v1


## Current Version

0.0.1


## Requirements

* "nokogiri", "~> 1.5.6"
* "json", "~> 1.7.6"
* "activesupport", "~> 3.2.12"


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

html = '<div class="h-card"><p class="p-name">Jessica Lynn Suttles</p></div>'
collection = Microformats.parse(html)
collection.card.first.name.first.value #=> "Jessica Lynn Suttles"
```


## Authors

* Jessica Lynn Suttles / [@jlsuttles](https://github.com/jlsuttles)


## Contributions

1. Fork it
2. Get it running (see Installation above)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Write your code and **specs**
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

If you find bugs, have feature requests or questions, please
[file an issue](https://github.com/G5/microformats2/issues).


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

Copyright (c) 2013 G5

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
