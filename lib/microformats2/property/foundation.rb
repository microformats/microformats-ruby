module Microformats2
  module Property
    class Foundation
      attr_accessor :element, :name, :value, :formats

			def initialize(element, html_class)
				@element = element
        @name = to_method_name(html_class)
			end

      def to_method_name(html_class)
        # p-class-name -> class_name
        method_name = html_class.downcase.split("-")[1..-1].join("_")
        # avoid overriding Object#class
        method_name = "klass" if method_name == "class"
        method_name
      end

      def parse
        formats
				value
				self
      end

      def formats
				@formats ||= format_classes.length >=1 ? FormatParser.parse(element) : []
      end

			def format_classes
				@format_classes = element.attribute("class").to_s.split.select do |html_class|
					html_class =~ Format::CLASS_REG_EXP
				end
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
          { value: value.to_s }.merge(formats.first.to_hash)
        end
      end
    end
  end
end
