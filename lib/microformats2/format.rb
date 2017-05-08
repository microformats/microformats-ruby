module Microformats2
  class Format
    CLASS_REG_EXP = /^(h-)/

    attr_reader :method_name

    def initialize(element, base)
      @element = element
      @base = base
      @method_name = to_method_name(format_types.first)
      @property_names = []
      @child_formats = []
      @child_formats_parsed = false
    end

    def parse
      format_types
      properties
      self
    end

    def children
      unless @child_formats_parsed
        parse_child_formats
        @child_formats_parsed = true
      end
      @child_formats
    end

    def format_types
      @format_types ||= @element.attribute("class").to_s.split.select do |html_class|
        html_class =~ Format::CLASS_REG_EXP
      end
    end

    def properties
      @properties ||= parse_properties.concat parse_implied_properties
    end

    def parse_properties
      PropertyParser.parse(@element.children, @base).each do |property|
        assign_property(property)
      end
    end

    def parse_child_formats
      FormatParser.parse(@element.children, @base, true).each do |child_format|
        @child_formats.push(child_format)
      end
    end

    def add_property(property_class, value)
      property = Property.new(nil, property_class, value, @base)
      assign_property(property)
    end

    def parse_implied_properties
      ip = []
      ip << ImpliedProperty::Name.new(@element, @base).parse unless property_present?(:name)
      ip << ImpliedProperty::Url.new(@element, @base).parse unless property_present?(:url)
      ip << ImpliedProperty::Photo.new(@element, @base).parse unless property_present?(:photo)
      ip.compact.each do |property|
        save_property_name(property.method_name)
        define_method(property.method_name)
        set_value(property.method_name, property)
      end
    end

    def property_present?(property)
      !! respond_to?(property) && send(property)
    end

    def to_hash
      hash = { type: format_types, properties: {} }
      @property_names.each do |method_name|
        hash[:properties][method_name.to_sym] = send(method_name.pluralize).map(&:to_hash)
      end
      unless children.empty?
        hash[:children] = []
        children.each do |child_format|
          hash[:children].push(child_format.to_hash)
        end
      end
      hash
    end

    def to_json
      to_hash.to_json
    end

    private

    def assign_property(property)
      save_property_name(property.method_name)
      define_method(property.method_name)
      set_value(property.method_name, property)
    end

    def to_method_name(html_class)
      # p-class-name -> class_name
      mn = html_class.downcase.split("-")[1..-1].join("_")
      # avoid overriding Object#class
      mn = "klass" if mn == "class"
      mn
    end

    def save_property_name(property_name)
      unless @property_names.include?(property_name)
        @property_names << property_name
      end
    end

    def define_method(mn)
      unless respond_to?(mn)
        self.singleton_class.class_eval { attr_accessor mn }
      end
      unless respond_to?(mn.pluralize)
        self.singleton_class.class_eval { attr_accessor mn.pluralize }
      end
    end

    def set_value(mn, value)
      unless current = send(mn)
        send("#{mn}=", value)
      end
      if current = send(mn.pluralize)
        current << value if current.respond_to? :<<
      else
        send("#{mn.pluralize}=", [value])
      end
    end
  end
end
