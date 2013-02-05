module Microformats2
  class Collection < Parser
    attr_accessor :formats

    def initialize
      @formats = []
      super
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

    def html_class_regex
     /^h-/
    end

    private

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
  end
end
