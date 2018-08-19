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
      key?(method) || property?(method) || super
    end

    def method_missing(sym, *args, &block)
      name = sym.to_s
      name_dash = name.tr('_', '-') if name.include?('_')

      if !@hash[name].nil?
        result_hash = @hash[name]
      elsif !@hash['properties'].nil? && !@hash['properties'][name].nil?
        result_hash = @hash['properties'][name]
      elsif !name_dash.nil? && !@hash[name_dash].nil?
        result_hash = @hash[name_dash]
      elsif !name_dash.nil? && !@hash['properties'].nil? && !@hash['properties'][name_dash].nil?
        result_hash = @hash['properties'][name_dash]
      else
        super(sym, *args, &block)
      end

      if result_hash.is_a?(Array)
        if args[0].nil?
          result_hash = result_hash[0] # will return nil for an empty array
        elsif args[0] == :all
          return result_hash.map do |x|
            ParserResult.new(x)
          end
        elsif args[0].to_i < result_hash.count
          result_hash = result_hash[args[0].to_i]
        else
          result_hash = result_hash[0] # will return nil for an empty array
        end
      end

      if result_hash.nil? || result_hash.empty?
        result_hash
      elsif result_hash.is_a?(Hash)
        ParserResult.new(result_hash)
      else
        result_hash
      end
    end

    private

    def property?(name)
      name = name.to_s
      name_dash = name.tr('_', '-') if name.include?('_')

      return false if @hash['properties'].nil?

      !@hash['properties'][name].nil? || !@hash['properties'][name_dash].nil?
    end
  end
end
