module Microformats2
  class ParserCore

    VALUE_CLASS_REG_EXP = /^(value)/
    VALUE_TITLE_CLASS_REG_EXP = /^(value-title)/
    FORMAT_CLASS_REG_EXP = /^(h-)/
    PROPERTY_CLASS_REG_EXP = /^(p-|u-|dt-|e-)/

    private

    def initialize
        @mode_backcompat = false

    end

    def parse_node(node)
      if node.is_a?(Nokogiri::HTML::Document) then 
        parse_node(node.children)
      elsif node.is_a?(Nokogiri::XML::NodeSet) then
        parse_nodeset(node)
      elsif node.is_a?(Nokogiri::XML::Element) then
        parse_element(node)
      else
        nil
      end
    end

    def parse_nodeset(nodeset)
        nodeset.each do |node|
          parse_node(node)
        end
    end

    def format_classes(element)
      ## TODO: check backcompat class names
      element.attribute("class").to_s.split.select do |html_class|
        html_class =~ FORMAT_CLASS_REG_EXP
      end
    end

    def property_classes(element)
      ## TODO: check backcompat class names
      element.attribute("class").to_s.split.select do |html_class|
        html_class =~ PROPERTY_CLASS_REG_EXP
      end
    end

    def value_classes(element)
      element.attribute("class").to_s.split.select do |html_class|
        html_class =~ VALUE_CLASS_REG_EXP
      end
    end
    def value_title_classes(element)
      element.attribute("class").to_s.split.select do |html_class|
        html_class =~ VALUE_TITLE_CLASS_REG_EXP
      end
    end

  end

end

