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
        @value ||= element_value || selector_value
      end

      def to_hash
        value.to_s
      end

      def to_json
        to_hash.to_json
      end

      protected

      def element_value
        name_map.each_pair do |elname, attr|
          if elname == @element.name && @element.attribute(attr)
            return @element.attribute(attr).to_s
          end
        end
        nil
      end

      def name_map
        {}
      end

      def selector_value
        selector_map.each_pair do |sel, attr|
          if selected_element = @element.css(sel).first
            return selected_element.attribute(attr).to_s
          end
        end
        nil
      end

      def selector_map
        {}
      end
    end
  end
end
