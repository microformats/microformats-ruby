module Microformats2
  module Property
    class Parser < Microformats2::Parser
      attr_accessor :value, :element

			def initialize(element)
				@element = element
				super()
			end

      def parse
				html_classes = element.attribute("class").to_s.split
				format_classes = html_classes.select { |html_class| html_class =~ /^(h-)/ }
        if format_classes.length >= 1
          parse_microformat(element, format_classes)
        end
        self
      end

			def value
				@value ||= value_class_pattern || element_value || text_value
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
				attr_map[element.name]
			end

			def attr_map
				{}
			end

      def to_hash
        if formats.empty?
          value.to_s
        else
          { value: value.to_s }.merge formats.first.to_hash
        end
      end
    end
  end
end
