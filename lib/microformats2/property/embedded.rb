module Microformats2
  module Property
    class Embedded < Foundation
      def to_s
        @to_s ||= string_value || @element.inner_html.strip
      end
      def to_hash
        if formats.empty?
          [{ value: @element.text.strip, html: to_s }]
        else
          { value: to_s }.merge(formats.first.to_hash)
        end
      end
    end
  end
end
