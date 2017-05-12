require "nokogiri"
require "open-uri"
require "json"

require "microformats2/version"
require "microformats2/absolute_uri"
require "microformats2/parser_core"
require "microformats2/parser"
require "microformats2/format_parser"
require "microformats2/property_parser"
require "microformats2/time_property_parser"
require "microformats2/results/parser_result"
require "microformats2/results/collection"
require "microformats2/results/property_set"

module Microformats2
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
