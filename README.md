# Microformats2

[![Code Climate](https://codeclimate.com/github/G5/microformats2.png)](https://codeclimate.com/github/G5/microformats2)

A Ruby gem to parse HTML containing one or more
[microformats2](http://microformats.org/wiki/microformats-2)
and return a collection of Ruby objects.



## Current Version

0.0.1


## Requirements

* "nokogiri", "~> 1.5.6"
* "json", "~> 1.7.6"


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

html = '<div class="h-org"><p class="p-name">G5</p></div'
formats = Microformats.parse(html)
puts formats.h_org.name.value # => "G5"
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
rake update_spec_cases
```

To run specs
```bash
rspec spec
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
