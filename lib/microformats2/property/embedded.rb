module Microformats2
	module Property
    class Embedded < Property::Parser
      def parse_flat_element(element)
        element.inner_html.strip
      end
    end
	end
end
