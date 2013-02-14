module Microformats2
  module ImpliedProperty
    class Name < Foundation

      def method_name
        "name"
      end

      def value
        @value ||= element_value || selector_value || text_value
      end

      protected

      def name_map
        { "img" => "alt",
          "abbr" => "title" }
      end

      def selector_map
        { ">img[alt]:only-of-type" => "alt",
          ">abbr[title]:only-of-type" => "title",
          ">:only-of-type>img[alt]:only-of-type" => "alt",
          ">:only-of-type>abbr[title]:only-of-type" => "title" }
      end

      private

      def text_value
        @element.inner_text.gsub(/\n+/, " ").gsub(/\s+/, " ").strip
      end
    end
  end
end
