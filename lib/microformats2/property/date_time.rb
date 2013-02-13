module Microformats2
	module Property
    class DateTime < Property::Parser
      def hash_safe_value
        @value.to_s
      end

			def parse_flat_element(element)
				value = Element.new(element).value
				begin
					::DateTime.parse(value)
        rescue ArgumentError => e
			   value
				end
			end

			class Element < Struct.new(:element)
				ATTR_MAP = {
					"time" => "datetime",
					"ins" => "datetime",
					"abbr" => "title",
					"data" => "value"
				}

				def value
					value_class_pattern || element_value || text_value
				end

				def value_class_pattern
					# TODO
				end

				def element_value
					element.attribute(attribute).to_s if attribute
				end

				def text_value
					element.inner_text.gsub(/\n+/, " ").gsub(/\s+/, " ").strip
				end

				def attribute
					ATTR_MAP[element.name]
				end
			end
    end
	end
end
