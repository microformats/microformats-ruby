module Microformats2
  class PropertyParser
		class << self
			def parse(element)
				parse_node(element).flatten.compact
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

			def parse_property(element)
				property_classes(element).map do |property_class|
					# p-class-name -> p
					prefix = property_class.split("-").first
					# find ruby class for kind of property
					klass = Microformats2::Property::PREFIX_CLASS_MAP[prefix]

					klass.new(element, property_class).parse
				end
			end

			def property_classes(element)
				element.attribute("class").to_s.split.select do |html_class|
					html_class =~ Property::CLASS_REG_EXP
				end
			end
    end
  end
end
