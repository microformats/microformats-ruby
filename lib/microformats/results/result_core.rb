module Microformats
  # base class for shared code between result classes
  class ResultCore
    def initialize(hash)
      @hash = hash
    end

    def to_h
      @hash
    end

    def to_hash
      @hash
    end

    def to_json
      to_hash.to_json
    end

    def to_s
      @hash.to_s
    end

    def [](key)
      @hash[key]
    end

    def respond_to_missing?(method, *)
      key?(method) || super
    end

    def method_missing(sym, *args, &block)
      result = search_for_items(sym.to_s)

      if !result.nil? && !result.empty?
        convert_to_parser_result(result, args[0])
      else
        super
      end
    end

    private

    def key?(name)
      name = name.to_s
      name_dash = name.tr('_', '-') if name.include?('_')

      !find_items(name).nil? || !find_items(name_dash).nil?
    end

    # given a name, use find_items find all entries for it.  This will vary by class
    #  this also allows for underscores to be used in place of dashes
    def search_for_items(search_val)
      name = search_val.to_s
      name_dash = name.tr('_', '-') if name.include?('_')

      result = find_items(name)
      result = find_items(name_dash) if (result.nil? || result.empty?) && !name_dash.nil?

      result
    end

    # given a set of args and some selector within that, return a ParserResult object
    # or possibly a set of ParserResult Objects.
    # This is how previous versions of the parser returned objects and as such we are trying to
    # keep full support
    def convert_to_parser_result(input_array, selector)
      return ParserResult.new(input_array) unless input_array.is_a?(Array)

      if selector == :all
        return input_array.map do |x|
          ParserResult.new(x)
        end
      end

      ParserResult.new(input_array[selector_or_zero(selector, input_array.count)])
    end

    def find_items(_search_val)
      raise NotImplementedError, 'You must implement the find_items private method'
    end

    def selector_or_zero(selector, max)
      return selector.to_i if selector.to_i < max
      0
    end
  end
end
