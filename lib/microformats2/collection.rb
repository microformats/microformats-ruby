module Microformats2
  class Collection
    attr_reader :all

    def initialize(element)
      @element = element
      @format_names = []
    end

    def parse
      all
      self
    end

    def all
      @all ||= FormatParser.parse(@element).each do |format|
        save_format_name(format.method_name)
        define_method(format.method_name)
        set_value(format.method_name, format)
      end
    end

    def first
      all.first
    end

    def last
      all.last
    end

    def to_hash
      hash = { items: [] }
      all.each do |format|
        hash[:items] << format.to_hash
      end
      hash
    end

    def to_json
      to_hash.to_json
    end

    private

    def save_format_name(format_name)
      unless @format_names.include?(format_name)
        @format_names << format_name
      end
    end

    def define_method(mn)
      unless respond_to?(mn)
        self.class.class_eval { attr_accessor mn }
      end
      unless respond_to?(mn.pluralize)
        self.class.class_eval { attr_accessor mn.pluralize }
      end
    end

    def set_value(mn, value)
      unless current = send(mn)
        send("#{mn}=", value)
      end
      if current = send(mn.pluralize)
        current << value
      else
        send("#{mn.pluralize}=", [value])
      end
    end
  end
end
