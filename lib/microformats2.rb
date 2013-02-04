require "nokogiri"
require "open-uri"
require "microformats2/version"

module Microformats2
  def self.parse(html)
    html = read_html(html)
    Nokogiri::HTML(html)
  end

  def self.read_html(html)
    open(html).read
  rescue Errno::ENOENT => e
    html
  end
end
