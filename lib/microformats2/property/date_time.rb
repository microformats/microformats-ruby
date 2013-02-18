module Microformats2
  module Property
    class DateTime < Foundation
      def to_s
        @to_s ||= value_class_pattern || element_value || text_value
      end

      def value
        ::DateTime.parse(to_s)
      end

      def to_hash
        if formats.empty?
          to_s
        else
          { value: to_s }.merge(formats.first.to_hash)
        end
      end

      protected

      def attr_map
        @attr_map ||= {
          "time" => "datetime",
          "ins" => "datetime",
          "abbr" => "title",
          "data" => "value" }
      end
    end
  end
end
