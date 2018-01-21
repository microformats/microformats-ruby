# <span role="presentation" style="display: inline-block; vertical-align: middle; width: 1em">![''][logo]</span> microformats-ruby

**A Ruby gem for parsing HTML documents containing microformats.**

[![Gem](https://img.shields.io/gem/v/microformats.svg?style=for-the-badge)](https://rubygems.org/gems/microformats)
[![Downloads](https://img.shields.io/gem/dt/microformats.svg?style=for-the-badge)](https://rubygems.org/gems/microformats)
[![Build](https://img.shields.io/travis/indieweb/microformats-ruby/master.svg?style=for-the-badge)](https://travis-ci.org/indieweb/microformats-ruby)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/indieweb/microformats-ruby.svg?style=for-the-badge)](https://codeclimate.com/github/indieweb/microformats-ruby)
[![Coverage](https://img.shields.io/codeclimate/c/indieweb/microformats-ruby.svg?style=for-the-badge)](https://codeclimate.com/github/indieweb/microformats-ruby/code)

## Key Features

- Compatible with both [classic microformats](http://microformats.org/wiki/Main_Page#Classic_Microformats) and [microformats2](http://microformats.org/wiki/microformats2) syntaxes.
- Provides a [CLI](https://en.wikipedia.org/wiki/Command-line_interface) for extracting microformats from a URL, file, or string.

## Getting Started

Before installing and using microformats-ruby, you'll want to have Ruby 2.2.9 (or newer) installed. It's recommended that you use a Ruby version managment tool like [rbenv](https://github.com/rbenv/rbenv), [chruby](https://github.com/postmodern/chruby), or [rvm](https://github.com/rvm/rvm).

microformats-ruby is developed using Ruby 2.5.0 and is additionally tested against versions 2.2.9, 2.3.6, and 2.4.3 using [Travis CI](https://travis-ci.org/indieweb/microformats-ruby).

## Installation

If you're using [Bundler](http://bundler.io) to manage gem dependencies, add microformats-ruby to your project's Gemfile:

```rb
ruby '2.5.0'

source 'https://rubygems.org'

gem 'microformats', '~> 4.0', '>= 4.0.7'
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

```rb
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

```rb
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

Check out [CONTRIBUTING.md](https://github.com/indieweb/microformats-ruby/blob/master/CONTRIBUTING.md) for more on how you can help!

## Acknowledgments

The microformats-ruby logo is derived from the [microformats logo mark](http://microformats.org/wiki/spread-microformats) by [Rémi Prévost](http://microformats.org/wiki/User:Remi).

microformats-ruby is written and maintained by:

- Ben Roberts ([@dissolve](https://github.com/dissolve))
- Jessica Lynn Suttles ([@jlsuttles](https://github.com/jlsuttles))
- Shane Becker ([@veganstraightedge](https://github.com/veganstraightedge))
- Chris Stringer ([@jcstringer](https://github.com/jcstringer))
- Michael Mitchell ([@variousred](https://github.com/variousred))
- Jessica Dillon ([@jessicard](https://github.com/jessicard))
- Jeena Paradies ([@jeena](https://github.com/jeena))
- Marty McGuire ([@martymcguire](https://github.com/martymcguire))

## License

microformats-ruby is dedicated to the public domain using the [Creative Commons CC0 1.0 Universal license](https://creativecommons.org/publicdomain/zero/1.0/).

The authors waive all of their rights to the work worldwide under copyright law, including all related and neighboring rights, to the extent allowed by law. You can copy, modify, and distribute the work, even for commercial purposes, all without asking permission.

See [LICENSE.md](https://github.com/indieweb/microformats-ruby/blob/master/LICENSE.md) for more details.

[logo]: data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzM3IiBoZWlnaHQ9IjMzNyIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48ZGVmcz48bGluZWFyR3JhZGllbnQgeDE9IjUwJSIgeTE9IjAlIiB4Mj0iNTAlIiB5Mj0iMTAwJSIgaWQ9ImEiPjxzdG9wIHN0b3AtY29sb3I9IiNmNTUxNWYiIG9mZnNldD0iMCUiLz48c3RvcCBzdG9wLWNvbG9yPSIjOWYwNDFiIiBvZmZzZXQ9IjEwMCUiLz48L2xpbmVhckdyYWRpZW50PjxsaW5lYXJHcmFkaWVudCB4MT0iMCUiIHkxPSIwJSIgeTI9IjEwMCUiIGlkPSJiIj48c3RvcCBzdG9wLWNvbG9yPSIjZjU1MTVmIiBvZmZzZXQ9IjAlIi8+PHN0b3Agc3RvcC1jb2xvcj0iIzlmMDQxYiIgb2Zmc2V0PSIxMDAlIi8+PC9saW5lYXJHcmFkaWVudD48L2RlZnM+PGcgc3Ryb2tlPSIjZmZmIiBzdHJva2Utd2lkdGg9IjE2IiBmaWxsPSJub25lIj48cGF0aCBkPSJNMCAxMDUuNzFjMC0zMC4xOSAyMi4wNC01Mi4zMyA1Mi4xMS01Mi4zM2gxNTcuMzdjMzAuMDY5IDAgNTIuMTA5IDIyLjE0IDUyLjEwOSA1Mi4zM3YxNTUuOTZjMCAzMC4xODktMjIuMDQgNTIuMzMtNTIuMTA5IDUyLjMzSDUyLjExQzIyLjA0IDMxNCAwIDI5MS44NTkgMCAyNjEuNjdWMTA1LjcxeiIgZmlsbD0idXJsKCNhKSIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoOCA4KSIvPjxwYXRoIGQ9Ik04OC41OSA1NS40M2MwLTI0LjEzIDE3LjY1LTQxLjgyIDQxLjczLTQxLjgyaDEyNi4wMmMyNC4wOCAwIDQxLjczIDE3LjY5IDQxLjczIDQxLjgydjEyNC42NGMwIDI0LjEzLTE3LjY1IDQxLjgyLTQxLjczIDQxLjgySDEzMC4zMmMtMjQuMDggMC00MS43My0xNy42OS00MS43My00MS44MlY1NS40M3oiIGZpbGw9InVybCgjYikiIHRyYW5zZm9ybT0idHJhbnNsYXRlKDggOCkiLz48cGF0aCBkPSJNMTc4LjIyMSAyOC4zN0MxNzguMjIxIDEyIDE5MC4yNSAwIDIwNi42NiAwaDg1LjlDMzA4Ljk3MSAwIDMyMSAxMiAzMjEgMjguMzd2ODQuNTZjMCAxNi4zNy0xMi4wMjkgMjguMzctMjguNDM5IDI4LjM3aC04NS45Yy0xNi40MSAwLTI4LjQzOS0xMi0yOC40MzktMjguMzdWMjguMzdoLS4wMDF6IiBmaWxsPSJ1cmwoI2IpIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSg4IDgpIi8+PC9nPjwvc3ZnPg==
