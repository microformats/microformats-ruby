module Microformats2
  class Format
    CLASS_REG_EXP = /^(h-)/

    attr_reader :element, :properties, :format_types

    def initialize(element)
      @element = element
      @format_types = []
      @properties = []
    end

    def parse
      properties << PropertyParser.parse(element)
      format_types
      self
    end

    def format_types
      @format_types ||= element.attribute("class").to_s.split.select do |html_class|
        html_class =~ Format::CLASS_REG_EXP
      end
    end

    def to_hash
      hash = { type: @format_types, properties: {} }
      properties.each do |method_name|
        value = send(method_name)
        value = value.is_a?(Array) ? value : [value]
        hash[:properties][method_name.to_sym] = value.map(&:to_hash)
      end
      hash
    end

    def to_json
      to_hash.to_json
    end
  end
end
