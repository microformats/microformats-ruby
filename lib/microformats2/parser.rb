module Microformats2
  class Parser
    attr_accessor :added_methods

    def initialize
      @added_methods = []
    end

    def parse(element)
      parse_nodeset(element.children)
      self
    end

    protected

    # override with regex to match before parsing microformat
    def html_class_regex
      //
    end

    # override and do interesting things here
    def parse_microformat(element, html_classes)
      element
    end


    def parse_nodeset(nodeset)
      nodeset.map { |node| parse_node(node) }
    end

    def parse_node(node)
      case
      when node.is_a?(Nokogiri::XML::NodeSet) then parse_nodeset(node)
      when node.is_a?(Nokogiri::XML::Element) then parse_element(node)
      end
    end

    def parse_element(element)
      html_classes = element.attribute("class").to_s.split
      html_classes.keep_if { |html_class| html_class =~ html_class_regex }

      if html_classes.length >= 1
        parse_microformat(element, html_classes)
      else
        parse_nodeset(element.children)
      end
    end

    def define_method_and_set_value(method_name, value)
      save_method_name(method_name)
      define_method(method_name)
      set_value(method_name, value)
    end

    def save_method_name(method_name)
      unless @added_methods.include?(method_name)
        @added_methods << method_name
      end
    end

    def define_method(method_name)
      unless respond_to?(method_name)
        self.class.class_eval { attr_accessor method_name }
      end
    end

    def set_value(method_name, value)
      if current = send(method_name)
        if current.kind_of? Array
          current << value
        else
          send("#{method_name}=", [current, value])
        end
      else
        send("#{method_name}=", value)
      end
    end
  end
end
