# ![Microformats Logo](https://raw.githubusercontent.com/microformats/microformats-ruby/master/logo.svg?sanitize=true) Microformats Ruby

**A Ruby gem for parsing HTML documents containing microformats.**

[![Gem](https://img.shields.io/gem/v/microformats.svg?style=for-the-badge)](https://rubygems.org/gems/microformats)
[![Downloads](https://img.shields.io/gem/dt/microformats.svg?style=for-the-badge)](https://rubygems.org/gems/microformats)
[![Build](https://img.shields.io/travis/microformats/microformats-ruby/master.svg?style=for-the-badge)](https://travis-ci.org/microformats/microformats-ruby)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/microformats/microformats-ruby.svg?style=for-the-badge)](https://codeclimate.com/github/microformats/microformats-ruby)
[![Coverage](https://img.shields.io/codeclimate/c/microformats/microformats-ruby.svg?style=for-the-badge)](https://codeclimate.com/github/microformats/microformats-ruby/code)

## Key Features

- Compatible with both [classic microformats](http://microformats.org/wiki/Main_Page#Classic_Microformats) and [microformats2](http://microformats.org/wiki/microformats2) syntaxes.
- Provides a [CLI](https://en.wikipedia.org/wiki/Command-line_interface) for extracting microformats from a URL, file, or string.

## Getting Started

Before installing and using microformats-ruby, you'll want to have Ruby 2.2.9 (or newer) installed. It's recommended that you use a Ruby version managment tool like [rbenv](https://github.com/rbenv/rbenv), [chruby](https://github.com/postmodern/chruby), or [rvm](https://github.com/rvm/rvm).

microformats-ruby is developed using Ruby 2.4.4 and is additionally tested against version 2.5.1 using [Travis CI](https://travis-ci.org/microformats/microformats-ruby).

## Installation

If you're using [Bundler](https://bundler.io) to manage gem dependencies, add microformats-ruby to your project's Gemfile:

```ruby
source 'https://rubygems.org'

gem 'microformats', '~> 4.0', '>= 4.1.0'
```

…and then run:

```sh
bundle install
```

You may also install microformats-ruby directly using:

```sh
gem install microformats
```

## Usage

An example working with a basic [h-card](http://microformats.org/wiki/h-card):

```ruby
source = '<div class="h-card"><p class="p-name">Jessica Lynn Suttles</p></div>'
collection = Microformats.parse(source)

# Get a copy of the canonical microformats hash structure
collection.to_hash

# The above as JSON in a string
collection.to_json

# Return a string if there is only one item found
collection.card.name #=> "Jessica Lynn Suttles"
```

Below is a more complex markup structure using an [h-entry](http://microformats.org/wiki/h-entry) with a nested h-card:

```ruby
source = '<article class="h-entry">
  <h1 class="p-name">Microformats 2</h1>
  <div class="h-card p-author">
    <p class="p-name"><span class="p-first-name">Jessica</span> Lynn Suttles</p>
  </div>
</article>'

collection = Microformats.parse(source)

collection.entry.name.to_s #=> "Microformats 2"

# Accessing nested microformats
collection.entry.author.name.to_s #=> "Jessica Lynn Suttles"

# Accessing nested microformats can use shortcuts or expanded method
collection.entry.author.name #=> "Jessica Lynn Suttles"
collection.entry.properties.author.properties.name.to_s #=> "Jessica Lynn Suttles"

# Use `_` instead of `-` to return property values
collection.entry.author.first_name #=> "Jessica"
collection.rel_urls #=> {}
```

Using the same markup patterns as above, here's an h-entry with multiple authors, each marked up as h-cards:

```ruby
source = '<article class="h-entry">
  <h1 class="p-name">Microformats 2</h1>
  <div class="h-card p-author">
    <p class="p-name"><span class="p-first-name">Jessica</span> Lynn Suttles</p>
  </div>
  <div class="h-card p-author">
    <p class="p-name"><span class="p-first-name">Brandon</span> Edens</p>
  </div>
</article>'

collection = Microformats.parse(source)

# Arrays of items will always return the first item by default
collection.entry.author.name #=> "Jessica Lynn Suttles"
collection.entry.author(1).name #=> "Brandon Edens"

# Get the actual array of items by using `:all`
collection.entry.author(:all).count #=> 2
collection.entry.author(:all)[1].name #=> "Brandon Edens"
```

### Command Line Interface

microformats-ruby also includes a command like program that will parse HTML and return a JSON representation of the included microformats.

```sh
microformats http://tantek.com
```

The program accepts URLs, file paths, or strings of HTML as an argument. Additionally, the script accepts piped input from other programs:

```sh
curl http://tantek.com | microformats
```

## Implementation Status

| Status | Specification or Parsing Rule |
|:------:|:------------------------------|
| ✅ | [Parse a document for microformats](http://microformats.org/wiki/microformats2-parsing#parse_a_document_for_microformats) |
| ✅ | [Parsing a `p-` property](http://microformats.org/wiki/microformats2-parsing#parsing_a_p-_property) |
| ✅ | [Parsing a `u-` property](http://microformats.org/wiki/microformats2-parsing#parsing_a_u-_property) |
| ✅ | [Parsing a `dt-` property](http://microformats.org/wiki/microformats2-parsing#parsing_a_dt-_property) |
| ✅ | [Parsing an `e-` property](http://microformats.org/wiki/microformats2-parsing#parsing_an_e-_property) |
| ✅ | [Parsing for implied properties](http://microformats.org/wiki/microformats2-parsing#parsing_for_implied_properties) |
| ✅ | Nested properties |
| ✅ | Nested microformat with associated property |
| ✅ | Nested microformat without associated property |
| ✅ | Recognize dynamically created properties |
| ✅ | [Support for `rel` attribute values](http://microformats.org/wiki/rel) |
| ✅ | [Normalizing `u-*` property values](http://microformats.org/wiki/microformats2-parsing-faq#normalizing_u-.2A_property_values) |
| ✅ | Parse the [value class pattern](http://microformats.org/wiki/value-class-pattern) |
| ✅ | Recognize [vendor extensions](http://microformats.org/wiki/microformats2#VENDOR_EXTENSIONS) |
| ✅ | Support for [classic microformats](http://microformats.org/wiki/Main_Page#Classic_Microformats) |
| ❌ | Recognize the [include pattern](http://microformats.org/wiki/include-pattern)

## Improving microformats-ruby

Have questions about using microformats-ruby? Found a bug? Have ideas for new or improved features? Want to pitch in and write some code?

Check out [CONTRIBUTING.md](https://github.com/microformats/microformats-ruby/blob/master/CONTRIBUTING.md) for more on how you can help!

## Acknowledgments

The microformats-ruby logo is derived from the [microformats logo mark](http://microformats.org/wiki/spread-microformats) by [Rémi Prévost](http://microformats.org/wiki/User:Remi).

microformats-ruby is written and maintained by:

- Ben Roberts ([@dissolve](https://github.com/dissolve))
- Jason Garber [(@jgarber623](https://github.com/jgarber623))
- Jessica Suttles ([@jlsuttles](https://github.com/jlsuttles))
- Shane Becker ([@veganstraightedge](https://github.com/veganstraightedge))
- Chris Stringer ([@jcstringer](https://github.com/jcstringer))
- Michael Mitchell ([@variousred](https://github.com/variousred))
- Jessica Dillon ([@jessicard](https://github.com/jessicard))
- Jeena Paradies ([@jeena](https://github.com/jeena))
- Marty McGuire ([@martymcguire](https://github.com/martymcguire))
- Tom Morris [(@tommorris](https://github.com/tommorris))
- Don Peterson [(@dpetersen](https://github.com/dpetersen))
- Matt Bohme [(@quady](https://github.com/quady))
- Brian Miller [(@BRIMIL01](https://github.com/BRIMIL01))
- Christian Weiske [(@cweiske](https://github.com/cweiske))
- Christian Kruse [(@ckruse](https://github.com/ckruse))
- Barnaby Walters [(@barnabywalters](https://github.com/barnabywalters))
- Jeremy Keith [(@adactio](https://github.com/adactio))

## License

microformats-ruby is dedicated to the public domain using the [Creative Commons CC0 1.0 Universal license](https://creativecommons.org/publicdomain/zero/1.0/).

The authors waive all of their rights to the work worldwide under copyright law, including all related and neighboring rights, to the extent allowed by law. You can copy, modify, and distribute the work, even for commercial purposes, all without asking permission.

See [LICENSE](https://github.com/microformats/microformats-ruby/blob/master/LICENSE) for more details.
