module Microformats2
  class Collection
    attr_reader :items

    def initialize(element, url = nil)
      @element = element

      @base = nil
      if url != nil
        @base = url
      end
      if @element.search("base").size > 0
        @base = @element.search("base")[0].attribute("href")
      end

      @format_names = []
      @rels = {}
      @alternates = []
    end

    def parse
      items
      parse_rels
      self
    end

    def items
      @items ||= FormatParser.parse(@element, @base).each do |format|
        save_format_name(format.method_name)
        define_method(format.method_name)
        set_value(format.method_name, format)
      end
    end

    def all
      warn "[DEPRECATION] all is deprecated and will be removed in the next release.  Please use 'items' instead."
      items
    end

    def first
      warn "[DEPRECATION] first is deprecated and will be removed in the next release.  Please use 'items.first' instead."
      items.first
    end

    def last
      warn "[DEPRECATION] first is deprecated and will be removed in the next release.  Please use 'items.last' instead."
      items.last
    end

    def to_hash
      hash = { items: [], rels: @rels }
      all.each do |format|
        hash[:items] << format.to_hash
      end
      hash[:alternates] = @alternates unless @alternates.nil? || @alternates.empty?

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
        #self.class.class_eval { attr_accessor mn }
          self.class.class_eval("
            def #{mn}(arg = nil);
              if arg == :all
                @#{mn}_array
              else
                @#{mn}
              end
            end") 
        self.class.class_eval("def #{mn}=(x); @#{mn} = x; end") 
      end
      unless respond_to?(mn.pluralize)
        #self.class.class_eval { attr_accessor mn.pluralize }
        self.class.class_eval("def #{mn.pluralize};
          warn \"[DEPRECATION] pluralized accessors are deprecated and will be removed in the next release. Please use '#{mn}(:all)' instead.\"
          return @#{mn}_array; end") 
        self.class.class_eval("def #{mn.pluralize}=(x); @#{mn}_array = x; end") 

      end
    end

    def set_value(mn, value)
      unless current = send(mn)
        send("#{mn}=", value)
      end
      if current = send(mn.pluralize)
        current = [current] if mn == mn.pluralize #otherwise h-news fails completely
        current << value
      else
        send("#{mn.pluralize}=", [value])
      end
    end

    def parse_rels
      @element.search("*[@rel]").each do |rel|
        rel_values = rel.attribute("rel").text.split(" ")

        if rel_values.member?("alternate")
          alternate_inst = {}
          alternate_inst["url"] = Microformats2::AbsoluteUri.new(@base, rel.attribute("href").text).absolutize
          alternate_inst["rel"] = (rel_values - ["alternate"]).join(" ")
          unless rel.attribute("media").nil?
            alternate_inst["media"] = rel.attribute("media").text
          end
          unless rel.attribute("hreflang").nil?
            alternate_inst["hreflang"] = rel.attribute("hreflang").text
          end
          unless rel.attribute("type").nil?
            alternate_inst["type"] = rel.attribute("type").text
          end
          @alternates << alternate_inst
        else
          rel_values.each do |rel_value|
            @rels[rel_value] = [] unless @rels.has_key?(rel_value)
            unless rel.attribute("href").nil?
              @rels[rel_value] << Microformats2::AbsoluteUri.new(@base, rel.attribute("href").text).absolutize
            end
          end
        end
      end
    end
  end
end
