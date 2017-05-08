module Microformats2
  module Property
    class Embedded < Foundation
      def to_s
        @to_s ||= string_value || @element.inner_html.strip
      end
    end
  end
end
