module Microformats2
  module ImpliedProperty
    class Photo < Foundation

      def method_name
        "photo"
      end

      protected

      def name_map
        { "img" => "src",
          "object" => "data" }
      end

      def selector_map
        { ">img[src]:only-of-type" => "src",
          ">object[data]:only-of-type" => "data",
          ">:only-child>img[src]:only-of-type" => "src",
          ">:only-child>object[data]:only-of-type" => "data" }
      end
    end
  end
end
