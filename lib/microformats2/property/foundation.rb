module Microformats2
  module Property
    class Foundation

      VALUE_CLASS_REG_EXP = /^(value)/
      VALUE_TITLE_CLASS_REG_EXP = /^(value-title)/

      attr_reader :method_name

      def initialize(element, html_class, string_value=nil, base=nil)
        @element = element
        @method_name = to_method_name(html_class)
        @real_name = to_real_name(html_class)
        @string_value = string_value
        @base = base
      end

      def real_name
        @real_name
      end

      def parse
        to_s
        formats
        self
      end

      def to_s
        @to_s ||= string_value || value_class_pattern || element_value || text_value
      end

      def format
        formats.first
      end

      def formats
        @formats ||= format_classes.length >=1 ? FormatParser.parse(@element, @base) : []
      end

      def to_hash
        if formats.empty?
          to_s
        else
          { value: to_s }.merge(formats.first.to_hash)
        end
      end

      def to_json
        to_hash.to_json
      end

      protected

      def value_class_pattern
        result = value_parse(@element)
        result = nil if result.empty?
        result
      end

      def value_parse(element)
          value_parse_node(element).flatten.compact
      end

      def value_parse_node(node)
        case
        when node.is_a?(Nokogiri::XML::NodeSet) then value_parse_nodeset(node)
        when node.is_a?(Nokogiri::XML::Element) then [parse_for_value_class_pattern(node)]
        end
      end

      def value_parse_nodeset(nodeset)
        nodeset.map { |node| value_parse_node(node) }
      end

      def parse_for_value_class_pattern(element)
        if value_title_classes(element).length >= 1
            element.attribute("title").to_s.gsub(/\n+/, " ").gsub(/\s+/, " ").strip
        elsif value_classes(element).length >= 1
            element.inner_text.gsub(/\n+/, " ").gsub(/\s+/, " ").strip
        end
      end

      def element_value
        @element.attribute(attribute).to_s if attribute && @element.attribute(attribute)
      end

      def text_value
        @element.inner_text.gsub(/\n+/, " ").gsub(/\s+/, " ").strip
      end

      def string_value
        @string_value
      end

      def attribute
        attr_map[@element.name]
      end

      def attr_map
        {}
      end

      private

      def to_real_name(html_class)
        # p-class-name -> class_name
        mn = html_class.downcase.split("-")[1..-1].join("-")
        # avoid overriding Object#class
        mn = "klass" if mn == "class"
        mn
      end

      def to_method_name(html_class)
        # p-class-name -> class_name
        mn = html_class.downcase.split("-")[1..-1].join("_")
        # avoid overriding Object#class
        mn = "klass" if mn == "class"
        mn
      end

      def format_classes
        return [] unless @element
        @format_classes = @element.attribute("class").to_s.split.select do |html_class|
          html_class =~ Format::CLASS_REG_EXP
        end
      end

      def value_classes(element)
        element.attribute("class").to_s.split.select do |html_class|
          html_class =~ VALUE_CLASS_REG_EXP
        end
      end
      def value_title_classes(element)
        element.attribute("class").to_s.split.select do |html_class|
          html_class =~ VALUE_TITLE_CLASS_REG_EXP
        end
      end
    end
  end
end
