require "nokogiri"
require "open-uri"
require "json"
require "microformats2/version"

module Microformats2
  class TextProperty
    def parse(element)
      element.text.gsub(/\n+/, " ").gsub(/\s+/, " ").strip
    end
  end
  class UrlProperty
    def parse(element)
      (element.attribute("href") || property.text).to_s
    end
  end
  class DateTimeProperty
    def parse(element)
      DateTime.parse(element.attribute("datetime") || property.text)
    end
  end
  class EmbeddedProperty
    def parse(element)
      element.text
    end
  end

  Prefixes = {
    "p" => TextProperty.new,
    "u" => UrlProperty.new,
    "dt" => DateTimeProperty.new,
    "e" => EmbeddedProperty.new
  }
  PrefixesRegEx = /^(p-|u-|dt-|e-)/

  class Root
    attr_accessor :properties

    def initialize(element)
      @properties = []
      parse_nodeset(element.children)
    end

    def type
      # ClassName -> className -> class-name
      self.class.name.gsub(/^([A-Z])/){$1.downcase}.gsub(/([A-Z])/){"-" + $1.downcase}
    end

    def to_hash
      hash = { type: [type], properties: {} }
      @properties.each do |method_name|
        hash[:properties][method_name] = send(method_name)
      end
      hash
    end

    def to_json(*a)
      to_hash.to_json(a)
    end

    def parse_nodeset(nodeset)
      nodeset.map { |node| parse_node(node) }
    end

    def parse_node(node)
      case
      when node.is_a?(Nokogiri::XML::NodeSet) then parse_nodeset(node)
      when node.is_a?(Nokogiri::XML::Element) then parse_element(node)
      end
    end

    def parse_element(element)
      # look for microformat property class
      html_classes = element.attribute("class").to_s.split
      html_classes.keep_if { |html_class| html_class =~ Microformats2::PrefixesRegEx }

      # if found microformat property, yay parse it
      if html_classes.length >= 1
        parse_property(element, html_classes)

      # if no microformat property found, look at children
      else
        parse_nodeset(element.children)
      end
    end

    def parse_property(element, html_classes)
      html_classes.each do |html_class|
        # p-class-name -> p
        prefix = html_class.split("-").first
        # p-class-name -> class_name
        method_name = html_class.split("-")[1..-1].join("_")
        value = Microformats2::Prefixes[prefix].parse(element)

        # avoid overriding Object#class
        if method_name == "class"
          method_name = "klass"
        end

        add_property(method_name)
        add_method(method_name)
        populate_method(method_name, value)
      end
    end

    def add_property(method_name)
      unless @properties.include?(method_name)
        @properties << method_name
      end
    end

    def add_method(method_name)
      unless respond_to?(method_name)
        self.class.class_eval { attr_accessor method_name }
      end
    end

    def populate_method(method_name, value)
      if cur = send(method_name)
        if cur.kind_of? Array
          cur << value
        else
          send("#{method_name}=", [cur, value])
        end
      else
        send("#{method_name}=", value)
      end
    end
  end

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
    nodeset.map { |node| parse_node(node) }
  end

  def self.parse_node(node)
    case
    when node.is_a?(Nokogiri::XML::NodeSet) then parse_nodeset(node)
    when node.is_a?(Nokogiri::XML::Element) then parse_element(node)
    end
  end

  def self.parse_element(element)
    # look for root microformat class
    html_classes = element.attribute("class").to_s.split
    html_classes.keep_if { |html_class| html_class =~ /^h-/ }

    # if found root microformat, yay parse it
    if html_classes.length >= 1
      parse_microformat(element, html_classes)

    # if no root microformat found, look at children
    else
      parse_nodeset(element.children)
    end
  end

  def self.parse_microformat(microformat, html_classes)
    # only worry about the first format for now
    html_class = html_classes.first

    # class_name -> class-name -> Class-name -> ClassName
    constant_name = html_class.gsub("-","_").gsub(/^([a-z])/){$1.upcase}.gsub(/_(.)/){$1.upcase}

    # get ruby class for microformat
    if Object.const_defined?(constant_name)
      klass = Object.const_get(constant_name)
    else
      klass = Class.new(Microformats2::Root)
      Object.const_set constant_name, klass
    end

    # get a new instance of the ruby class
    klass.new(microformat)
  end
end
