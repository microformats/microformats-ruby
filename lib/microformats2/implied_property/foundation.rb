module Microformats2
  module ImpliedProperty
    class Foundation
      def initialize(element)
        @element = element
      end

      def parse
        self if value
      end

      def method_name
        "foundation"
      end

      def value
        @value ||= element_value
      end

      def to_hash
        value.to_s
      end

      def to_json
        to_hash.to_json
      end

      protected

      def element_value
        ev = nil
        attr_map.each_pair do |k, v|
          selected_elements = @element.css(k)
          if selected_elements.first
            ev ||= selected_elements.first.attribute(v).to_s
          end
        end
        ev
      end

      def attribute
        attr_map[@element.name]
      end

      def attr_map
        {}
      end
    end
  end
end
