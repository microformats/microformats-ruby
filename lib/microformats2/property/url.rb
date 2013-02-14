module Microformats2
  module Property
    class Url < Foundation

      protected

      def attr_map
        @attr_map = {
          "a" => "href",
          "area" => "href",
          "img" => "src",
          "object" => "data",
          "abbr" => "title",
          "data" => "value" }
      end
    end
  end
end
