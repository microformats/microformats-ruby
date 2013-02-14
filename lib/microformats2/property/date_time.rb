module Microformats2
	module Property
    class DateTime < Foundation
			def value
				::DateTime.parse(super)
			rescue ArgumentError => e
			  super
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
