require "nokogiri"
require "open-uri"
require "json"
require "active_support/inflector"

require "microformats2/version"
require "microformats2/absolute_uri"
require "microformats2/parser"
require "microformats2/format_parser"
require "microformats2/property_parser"
require "microformats2/collection"
require "microformats2/format"
require "microformats2/property/foundation"
require "microformats2/property/text"
require "microformats2/property/url"
require "microformats2/property/date_time"
require "microformats2/property/embedded"
require "microformats2/property"
require "microformats2/implied_property/foundation"
require "microformats2/implied_property/name"
require "microformats2/implied_property/photo"
require "microformats2/implied_property/url"

module Microformats2
  class << self
    def parse(html)
      Parser.new.parse(html)
    end

    def read_html(html)
      Parser.new.read_html(html)
    end
  end # class << self

  class InvalidPropertyPrefix < StandardError; end
end
