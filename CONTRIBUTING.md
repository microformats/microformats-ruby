# Contributing to microformats-ruby

There are a couple ways you can help improve microformats-ruby:

1. Fix an existing [issue][issues] and submit a [pull request][pulls].
1. Review open [pull requests][pulls].
1. Report a new [issue][issues]. _Only do this after you've made sure the behavior or problem you're observing isn't already documented in an open issue._

## Getting Started

microformats-ruby is developed using Ruby 2.5.0 and is additionally tested against versions 2.2.9, 2.3.6, and 2.4.3 using [Travis CI](https://travis-ci.org/microformats/microformats-ruby).

Before making changes to microformats-ruby, you'll want to install Ruby 2.5.0. It's recommended that you use a Ruby version managment tool like [rbenv](https://github.com/rbenv/rbenv), [chruby](https://github.com/postmodern/chruby), or [rvm](https://github.com/rvm/rvm). Once you've installed Ruby 2.5.0 using your method of choice, install the project's gems by running:

```sh
bundle install
```

## Making Changes

1. Fork and clone the project's repo.
1. Install development dependencies as outlined above.
1. Create a feature branch for the code changes you're looking to make: `git checkout -b my-new-feature`.
1. _Write some code!_
1. If your changes would benefit from testing, add the necessary tests and verify everything passes by running `bundle exec rspec`.
1. Commit your changes: `git commit -am 'Add some new feature or fix some issue'`. _(See [this excellent article](https://chris.beams.io/posts/git-commit/) for tips on writing useful Git commit messages.)_
1. Push the branch to your fork: `git push -u origin my-new-feature`.
1. Create a new [pull request][pulls] and we'll review your changes.

## Verifying Changes

We use the following tools to evaluate code quality and verify behavior:

- The test suite uses [RSpec](http://rspec.info) (`bundle exec rspec`).
- Static code analysis uses [RuboCop](https://github.com/bbatsov/rubocop) (`bundle exec rubocop`).

Before submitting a [pull request][pulls], use the above tools to verify your changes.

You may also test your code interactively by running:

```sh
bundle console
```

## Releasing New Versions

First, check out the latest code from GitHub:

```sh
git pull origin master
```

Following the [Semantic Versioning](https://semver.org) conventions, update the gem version throughout the project (but most importantly in `lib/microformats/version.rb`).

Confirm that the gem builds correctly:

```sh
bundle exec rake build
```

If that works, install the new version of the gem locally:

```sh
bundle exec rake install
```

If that works, uninstall the gem.

```sh
gem uninstall microformats
```

Clean up any mess made from testing.

```sh
bundle exec rake clean
bundle exec rake clobber
```

Assuming you're one of the gem owners and have release privileges, release the gem!

```
bundle exec rake release
```

If that works, you’ve just released a new version of the gem! Yay! You can see it at: [https://rubygems.org/gems/microformats](https://rubygems.org/gems/microformats)

### Handling Errors

If `rake release` failed because of an error with your authentication to RubyGems.org, follow the instructions in the error message then repeat the `rake release` step.

### Getting Help

If any other errors occurred along the way and you're stuck, get in touch via [IRC](http://microformats.org/wiki/irc) (#microformats on freenode) or the #microformats channel in [the IndieWebCamp Slack](https://indieweb.org/Slack) for help.

## Code Style

Code formatting conventions are defined in the `.editorconfig` file which uses the [EditorConfig](http://editorconfig.org) syntax. There are [plugins for a variety of editors](http://editorconfig.org/#download) that utilize the settings in the `.editorconfig` file. We recommended you install the EditorConfig plugin for your editor of choice.

Your bug fix or feature addition won't be rejected if it runs afoul of any (or all) of these guidelines, but following the guidelines will definitely make everyone's lives a little easier.

[issues]: https://github.com/microformats/microformats-ruby/issues
[pulls]: https://github.com/microformats/microformats-ruby/pulls
