module Microformats2
  module Property
    class DateTime < Foundation
      def value
        ::DateTime.parse(string_value)
      rescue ArgumentError => e
        string_value
      end

      def string_value
        @string_value ||= value_class_pattern || element_value || text_value
      end

      def to_hash
        if formats.empty?
          string_value.to_s
        else
          { value: string_value.to_s }.merge(formats.first.to_hash)
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
