module Microformats2
  class Collection
    attr_accessor :added_methods, :formats

    def initialize
      @added_methods = []
      @formats = []
    end

    def parse(document)
      parse_nodeset(document.children)
      self
    end

    def to_hash
      hash = { items: [] }
      @formats.each do |format|
        hash[:items] << format.to_hash
      end
      hash
    end

    def to_json
      to_hash.to_json
    end

    private

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
      # look for root microformat class
      html_classes = element.attribute("class").to_s.split
      html_classes.keep_if { |html_class| html_class =~ /^h-/ }

      # if found root microformat, yay parse it
      if html_classes.length >= 1
        parse_microformat(element, html_classes)

      # if no root microformat found, look at children
      else
        parse_nodeset(element.children)
      end
    end

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

      # get a new instance of the ruby class
      format = klass.new.parse(microformat)

      @formats << format

      save_method_name(method_name)
      add_method(method_name)
      populate_method(method_name, format)
    end

    def save_method_name(method_name)
      unless @added_methods.include?(method_name)
        @added_methods << method_name
      end
    end

    def add_method(method_name)
      unless respond_to?(method_name)
        self.class.class_eval { attr_accessor method_name }
      end
    end

    def populate_method(method_name, value)
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
