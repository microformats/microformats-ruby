module Microformats2
  module ImpliedProperty
    class Url < Foundation

      def method_name
        "url"
      end

      protected

      def attr_map
        { "a[href]" => "href",
          ">a[href]:only-of-type" => "href" }
      end
    end
  end
end
