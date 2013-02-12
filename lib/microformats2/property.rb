module Microformats2
  module Property
    class Parser < Microformats2::Parser
      attr_accessor :value

      def parse(element, format_classes=[])
        if format_classes.length >= 1
          parse_microformat(element, format_classes)
        end
        @value = parse_flat_element(element)
        self
      end

      def to_hash
        if @formats.empty?
          hash_safe_value
        else
          { value: hash_safe_value }.merge @formats.first.to_hash
        end
      end

      def hash_safe_value
        @value
      end
    end

    class Text < Property::Parser
      def parse_flat_element(element)
        element.text.gsub(/\n+/, " ").gsub(/\s+/, " ").strip
      end
    end

    class Url < Property::Parser
      def parse_flat_element(element)
        (element.attribute("href") || element.attribute("src") || element.text).to_s
      end
    end

    class DateTime < Property::Parser
      def parse_flat_element(element)
        ::DateTime.parse(element.attribute("datetime") || element.text)
      rescue ArgumentError => e
        (element.attribute("datetime") || element.text).to_s
      end
      def hash_safe_value
        @value.to_s
      end
    end

    class Embedded < Property::Parser
      def parse_flat_element(element)
        element.inner_html.strip
      end
    end

    Parsers = {
      "p" => Text,
      "u" => Url,
      "dt" => DateTime,
      "e" => Embedded
    }
    PrefixesRegEx = /^(p-|u-|dt-|e-)/
  end
end
