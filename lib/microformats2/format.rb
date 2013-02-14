module Microformats2
  class Format
    CLASS_REG_EXP = /^(h-)/

    attr_reader :element

    def initialize(element)
      @element = element
      @added_methods = []
    end

    def parse
      properties
      format_types
      self
    end

    def properties
      @properties ||= create_properties
    end

    def create_properties
      PropertyParser.parse(element).map do |property|
        save_method_name(property.name)
        define_method(property.name)
        set_value(property.name, property)
      end
    end

    def save_method_name(method_name)
      unless @added_methods.include?(method_name)
        @added_methods << method_name
      end
    end

    def define_method(method_name)
      unless respond_to?(method_name)
        self.class.class_eval { attr_accessor method_name }
      end
    end

    def set_value(method_name, value)
      if current = send(method_name)
        current << value
      else
        send("#{method_name}=", [value])
      end
    end
    def format_types
      @format_types ||= element.attribute("class").to_s.split.select do |html_class|
        html_class =~ Format::CLASS_REG_EXP
      end
    end

    def to_hash
      hash = { type: format_types, properties: {} }
      @added_methods.each do |method_name|
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
