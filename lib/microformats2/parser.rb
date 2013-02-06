module Microformats2
  class Parser
    attr_accessor :formats, :added_methods

    def initialize
      @formats = []
      @added_methods = []
    end

    # override and do interesting things here
    def parse(element)
      parse_nodeset(element.children)
      self
    end

    protected

    # override with regex to match before parsing microformat
    def html_class_regex
      /^(h-)/
    end

    # override and do interesting things here
    def parse_microformat(microformat, html_classes)
      # only worry about the first format for now
      html_class = html_classes.first

      # class-name -> class_name
      method_name = html_class.downcase.gsub("-","_")
      # class_name -> Class_name -> ClassName
      constant_name = method_name.gsub(/^([a-z])/){$1.upcase}.gsub(/_(.)/){$1.upcase}

      # get ruby class for microformat
      if Object.const_defined?(constant_name)
        klass = Object.const_get(constant_name)
      else
        klass = Class.new(Microformats2::Format)
        Object.const_set constant_name, klass
      end

      # parse microformat
      value = klass.new.parse(microformat)

      # save microformat in array in order
      @formats << value

      # save microformat under custom method
      define_method_and_set_value(method_name, value)
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
      html_classes = html_classes.select { |html_class| html_class =~ html_class_regex }

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
