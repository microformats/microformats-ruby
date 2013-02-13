module Microformats2
  class Format < Parser
    attr_reader :format_types

    def parse(element)
      html_classes = element.attribute("class").to_s.split
      @format_types = html_classes.select { |html_class| html_class =~ /^(h-)/ }
      super
    end

    def to_hash
      hash = { type: @format_types, properties: {} }
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

    private

    # look for both formats and properties
    def html_class_regex
      /^(h-|p-|u-|dt-|e-)/
    end

    def parse_microformat(element, html_classes)
      property_classes = html_classes.select { |html_class| html_class =~ Microformats2::Property::PrefixesRegEx }

      property_classes.each do |property_class|
        # p-class-name -> p
        prefix = property_class.split("-").first
        # p-class-name -> class_name
        method_name = property_class.split("-")[1..-1].join("_")
        # avoid overriding Object#class
        method_name = "klass" if method_name == "class"

        # parse property
        value = Microformats2::Property::Parsers[prefix].new(element).parse

        # save property under custom method
        define_method_and_set_value(method_name, value)
      end
    end
  end
end
