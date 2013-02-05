require "nokogiri"
require "open-uri"
require "json"
require "microformats2/version"
require "microformats2/parser"
require "microformats2/collection"
require "microformats2/format"
require "microformats2/property"

module Microformats2
  class << self
    def parse(html)
      html = read_html(html)
      document = Nokogiri::HTML(html)
      Collection.new.parse(document)
    end

    def read_html(html)
      open(html).read
    rescue Errno::ENOENT => e
      html
    end
  end # class << self
end
