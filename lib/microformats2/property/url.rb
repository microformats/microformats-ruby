module Microformats2
  module Property
    class Url < Foundation

      def to_s
        @to_s = Microformats2::AbsoluteUri.new(@base, super.to_s).absolutize
      end

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
