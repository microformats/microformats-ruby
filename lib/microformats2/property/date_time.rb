module Microformats2
	module Property
    class DateTime < Property::Parser
			def value
				::DateTime.parse(super)
			rescue ArgumentError => e
			  super
			end

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
