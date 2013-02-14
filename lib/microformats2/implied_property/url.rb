module Microformats2
  module ImpliedProperty
    class Url < Foundation

      def method_name
        "url"
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
