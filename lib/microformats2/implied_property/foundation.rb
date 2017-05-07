module Microformats2
  module ImpliedProperty
    class Foundation

      def initialize(element, base=nil)
        @element = element
        @base = base
      end

      def parse
        self if to_s
      end

      def method_name
        "foundation"
      end

      def to_s
        @to_s ||= element_value || selector_value
      end

      def to_hash
        to_s
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
