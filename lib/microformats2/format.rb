module Microformats2
  class Format < Parser
    def type
      # ClassName -> className -> class-name
      self.class.name.gsub(/^([A-Z])/){$1.downcase}.gsub(/([A-Z])/){"-" + $1.downcase}
    end

    def to_hash
      hash = { type: [type], properties: {} }
      @added_methods.each do |method_name|
        hash[:properties][method_name.to_sym] = send(method_name)
      end
      hash
    end

    def to_json
      to_hash.to_json
    end

    def html_class_regex
      Microformats2::PropertyPrefixesRegEx
    end

    private

    def parse_microformat(element, html_classes)
      html_classes.each do |html_class|
        # p-class-name -> p
        prefix = html_class.split("-").first
        # p-class-name -> class_name
        method_name = html_class.split("-")[1..-1].join("_")
        # avoid overriding Object#class
        method_name = "klass" if method_name == "class"

        # parse property
        value = Microformats2::PropertyPrefixes[prefix].parse(element)

        # save property under custom method
        define_method_and_set_value(method_name, value)
      end
    end
  end
end
