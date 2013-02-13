module Microformats2
  class PropertyParser
		class << self
			def parse(element)
				parse_node(element)
			end

			def parse_node(node)
				case
				when node.is_a?(Nokogiri::XML::NodeSet) then parse_nodeset(node)
				when node.is_a?(Nokogiri::XML::Element) then parse_for_properties(node)
				end
			end

			def parse_nodeset(nodeset)
				nodeset.map { |node| parse_node(node) }
			end

			def parse_for_properties(element)
				if property_classes(element).length >= 1
					parse_property(element)
				else
					parse_nodeset(element.children)
				end
			end

			def parse_property(element, html_classes)
				property_classes(element).each do |property_class|
					# p-class-name -> p
					prefix = property_class.split("-").first
					# p-class-name -> class_name
					method_name = property_class.split("-")[1..-1].join("_")
					# avoid overriding Object#class
					method_name = "klass" if method_name == "class"

					# find ruby class for kind of property
					klass = Microformats2::Property::PREFIX_CLASS_MAP[prefix]

					# parse property
					klass.new(element).parse
				end
			end

			def property_classes(element, regexp)
				element.attribute("class").to_s.split.select do |html_class|
					html_class =~ Property::CLASS_REG_EXP
				end
			end
    end
  end
end
