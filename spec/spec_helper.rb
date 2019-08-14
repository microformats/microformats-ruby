$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'simplecov'
require 'webmock/rspec'

require 'microformats'

WebMock.disable_net_connect!
