module Microformats2
  module Property
    class Foundation
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
        # TODO
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
    end
  end
end
