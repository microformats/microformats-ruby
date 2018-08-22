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
      return if @hash['properties'].nil?
      PropertySet.new(@hash['properties'])
    end

    private

    def convert_to_parser_result(input_array, selector)
      if input_array.is_a?(Array)
        super.convert_to_parser_result(input_array, selector)
      end

      if result.nil? || result.empty?
        result
      elsif result.is_a?(Hash)
        ParserResult.new(result)
      else
        result
      end
    end

    def find_items(search_val)
      return if @hash['properties'].nil?
      @hash['properties'][search_val]
    end
  end
end
