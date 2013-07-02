require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'rspec'
require 'rspec/autorun'
require 'webmock/rspec'

RSpec.configure do |config|
  config.order = "random"
end
