module Microformats2
  module Property
    class Embedded < Foundation
      def value
        @value ||= @element.inner_html.strip
      end
    end
  end
end
