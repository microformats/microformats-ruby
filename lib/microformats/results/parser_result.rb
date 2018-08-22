module Microformats
  # stub to get around the tests for now
  class ParserResult < ResultCore
    def to_s
      return @hash['value'] if @hash['value']
      @hash.to_s
    end

    def value
      @hash['value']
    end

    def properties
      PropertySet.new(@hash['properties'])
    end

    def respond_to_missing?(method, *)
      key?(method) || super
    end

    def method_missing(sym, *args, &block)
      name = sym.to_s
      name_dash = name.tr('_', '-') if name.include?('_')

      result = find_one_item(name)
      result = find_one_item(name_dash) if result.nil?

      if !result.nil?
        convert_to_parser_result(result, args[0])
      else
        super
      end
    end

    private

    def find_one_item(search_val)
      return @hash[search_val] unless @hash[search_val].nil?
      return @hash['properties'][search_val] unless @hash['properties'].nil?
    end

    def find_items(search_val)
      return if @hash['properties'].nil?
      @hash['properties'][search_val]
    end

    def convert_to_parser_result(input_array, selector)
      return ParserResult.new(input_array) unless input_array.is_a?(Array)

      if selector == :all
        return input_array.map do |x|
          ParserResult.new(x)
        end
      end

      result_array = input_array[selector_or_zero(selector, input_array.count)]

      return ParserResult.new(result_array) if result_array.is_a?(Hash) && !result_array.empty?
      result_array
    end
  end
end
