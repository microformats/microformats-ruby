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
  end
end
