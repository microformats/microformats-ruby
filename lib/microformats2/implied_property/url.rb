module Microformats2
  module ImpliedProperty
    class Url < Foundation

      def method_name
        "url"
      end

      def to_s
        @to_s = absolutize(super.to_s) if super.to_s != ""
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

      def name_map
        { "a" => "href" }
      end

      def selector_map
        { ">a[href]:only-of-type" => "href" }
      end
    end
  end
end
