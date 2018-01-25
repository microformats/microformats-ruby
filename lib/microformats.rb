require 'nokogiri'
require 'open-uri'
require 'json'

require 'microformats/version'
require 'microformats/absolute_uri'
require 'microformats/parser_core'
require 'microformats/parser'
require 'microformats/format_parser'
require 'microformats/property_parser'
require 'microformats/time_property_parser'
require 'microformats/results/parser_result'
require 'microformats/results/collection'
require 'microformats/results/property_set'

module Microformats
  class << self
    def parse(html, base: nil)
      Parser.new.parse(html, base: base)
    end

    def read_html(html)
      Parser.new.read_html(html)
    end
  end # class << self

  class InvalidPropertyPrefix < StandardError; end
end
