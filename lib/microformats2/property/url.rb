module Microformats2
  module Property
    class Url < Foundation

      def to_s
        @to_s = absolutize(super.to_s)
      end

      # TODO: make dry, repeated in Collection
      def absolutize(href)
        uri = URI.parse(href)

        if @base && !uri.absolute?
          uri = URI.join(@base, href)
        end

        uri.normalize!
        uri.to_s
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
