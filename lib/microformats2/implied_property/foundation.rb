module Microformats2
  module ImpliedProperty
    class Foundation
      attr_reader :selector

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
        ev = nil
        name_map.each_pair do |elname, attr|
          if elname == @element.name && @element.attribute(attr)
            ev ||= @element.attribute(attr).to_s
            @selector ||= elname
          end
        end
        ev
      end

      def selector_value
        sv = nil
        selector_map.each_pair do |sel, attr|
          selected_elements = @element.css(sel)
          if selected_elements.first
            sv ||= selected_elements.first.attribute(attr).to_s
            @selector ||= sel
          end
        end
        sv
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
