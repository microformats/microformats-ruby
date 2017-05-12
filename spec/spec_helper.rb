require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'rspec'
require 'webmock/rspec'

RSpec.configure do |config|
  config.order = "random"
end
