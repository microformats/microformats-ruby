require "nokogiri"
require "open-uri"
require "microformats2/version"

module Microformats2
  def self.parse(html)
    html = read_html(html)
    document = Nokogiri::HTML(html)
    parsed_document = parse_nodeset(document.children)
    parsed_document.flatten.compact
  end

  def self.read_html(html)
    open(html).read
  rescue Errno::ENOENT => e
    html
  end

  def self.parse_nodeset(nodeset)
    nodeset.map do |node| parse_node(node) end
  end

  def self.parse_node(node)
    case
    when node.is_a?(Nokogiri::XML::NodeSet) then parse_nodeset(node)
    when node.is_a?(Nokogiri::XML::Element) then parse_element(node)
    end
  end

  def self.parse_element(element)
    # innocent until proven guilty
    microformat = false

    # look for root microformat class
    element.attribute("class").to_s.split.each do |html_class|
      microformat = microformat || html_class =~ /^h-/
    end

    # if found root microformat, yay
    if microformat
      "YAY MICROFORMAT"

    # if no root microformat found, look at children
    else
      parse_nodeset(element.children)
    end
  end
end
