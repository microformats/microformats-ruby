module Microformats2
  class FormatParser
    class << self
      def parse(element, base=nil, parsing_children = false)
        @@base = base
        parse_node(element, parsing_children).flatten.compact
      end

      def parse_node(node, parsing_children=false)
        case
        when node.is_a?(Nokogiri::HTML::Document) then parse_node(node.children, parsing_children)
        when node.is_a?(Nokogiri::XML::NodeSet)   then parse_nodeset(node, parsing_children)
        when node.is_a?(Nokogiri::XML::Element)   then [parse_for_microformats(node, parsing_children)]
        end
      end

      def parse_nodeset(nodeset, parsing_children=false)
        nodeset.map { |node| parse_node(node, parsing_children) }
      end

      def parse_for_microformats(element, parsing_children=false)
        if property_classes(element).length >= 1 and parsing_children
          #do nothing because we don't want properties obj in children
        elsif format_classes(element).length >= 1
          parse_microformat(element)
        else
          parse_nodeset(element.children, parsing_children)
        end
      end

      def parse_microformat(element)
        # only create ruby object for first format class
        html_class = format_classes(element).first
        const_name = constant_name(html_class)
        klass = find_or_create_ruby_class(const_name)

        klass.new(element, @@base).parse
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

      def constant_name(html_class)
        # html-Class -> html-class -> html_class -> Html_class -> HtmlClass
        html_class.downcase.gsub("-","_").gsub(/^([a-z])/){$1.upcase}.gsub(/_(.)/){$1.upcase}
      end

      def find_or_create_ruby_class(const_name)
        if Object.const_defined?(const_name)
          klass = Object.const_get(const_name)
        else
          klass = Class.new(Microformats2::Format)
          Object.const_set const_name, klass
        end
        klass
      end
    end # class << self
  end
end
