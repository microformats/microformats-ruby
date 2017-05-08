module Microformats2
  class PropertyParser
    class << self
      def parse(element, base)
        @@base = base
        parse_node(element).flatten.compact
      end

      def parse_node(node)
        case
        when node.is_a?(Nokogiri::XML::NodeSet) then parse_nodeset(node)
        when node.is_a?(Nokogiri::XML::Element) then [parse_for_properties(node)]
        end
      end

      def parse_nodeset(nodeset)
        nodeset.map { |node| parse_node(node) }
      end

      def parse_for_properties(element)
        if property_classes(element).length >= 1
          parse_property(element)
        elsif format_classes(element).length >= 1
          #do nothing because we don't want child elements ending up with their properties here
        else
          parse_nodeset(element.children)
        end
      end

      def parse_property(element)
        property_classes(element).map do |property_class|
          property   = Property.new(element, property_class, nil, @@base).parse
          properties = format_classes(element).empty? ? PropertyParser.parse(element.children, @@base) : []

          [property].concat properties
        end
      end

      def property_classes(element)
        element.attribute("class").to_s.split.select do |html_class|
          html_class =~ Property::CLASS_REG_EXP
        end
      end

      def format_classes(element)
        element.attribute("class").to_s.split.select do |html_class|
          html_class =~ Format::CLASS_REG_EXP
        end
      end
    end # class << self
  end
end
