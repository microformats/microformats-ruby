module Microformats2
  class Format
    attr_accessor :added_method_names

    def initialize
      @added_method_names = []
    end

    def parse(element)
      parse_nodeset(element.children)
      self
    end

    def type
      # ClassName -> className -> class-name
      self.class.name.gsub(/^([A-Z])/){$1.downcase}.gsub(/([A-Z])/){"-" + $1.downcase}
    end

    def to_hash
      hash = { type: [type], properties: {} }
      @added_method_names.each do |method_name|
        hash[:properties][method_name.to_sym] = send(method_name)
      end
      hash
    end

    def to_json
      to_hash.to_json
    end

    private

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
      html_classes.keep_if { |html_class| html_class =~ Microformats2::PropertyPrefixesRegEx }

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
        value = Microformats2::PropertyPrefixes[prefix].parse(element)

        # avoid overriding Object#class
        if method_name == "class"
          method_name = "klass"
        end

        save_method_name(method_name)
        add_method(method_name)
        populate_method(method_name, value)
      end
    end

    def save_method_name(method_name)
      unless @added_method_names.include?(method_name)
        @added_method_names << method_name
      end
    end

    def add_method(method_name)
      unless respond_to?(method_name)
        self.class.class_eval { attr_accessor method_name }
      end
    end

    def populate_method(method_name, value)
      if current = send(method_name)
        if current.kind_of? Array
          current << value
        else
          send("#{method_name}=", [current, value])
        end
      else
        send("#{method_name}=", value)
      end
    end
  end
end
