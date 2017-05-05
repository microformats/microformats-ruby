module Microformats2
  module ImpliedProperty
    class Url < Foundation

      def method_name
        "url"
      end

      def real_name
        "url"
      end

      def to_s
        @to_s = Microformats2::AbsoluteUri.new(@base, super.to_s).absolutize
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
