module Microformats2
  module Property
    class Embedded < Foundation
      def to_s
        @to_s ||= @element.inner_html.strip
      end
    end
  end
end
