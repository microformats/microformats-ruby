module Microformats2
	module Property
    class Embedded < Property::Parser
      def value
        @value ||= @element.inner_html.strip
      end
    end
	end
end
