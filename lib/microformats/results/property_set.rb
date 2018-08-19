module Microformats
  # stub to get around the tests for now
  class PropertySet < ResultCore
    def to_hash
      @hash.to_hash
    end

    def respond_to_missing?(method, *)
      key?(method) || super
    end

    def method_missing(mname, *args, &block)
      if key?(mname)
        find_value(mname)
      else
        super(mname, *args, &block)
      end
    end

    private

    def val?(name)
      unless key?(name)
        false
      end

      name = name.to_s
      name_dash = name.tr('_', '-') if name.include?('_')

      if !@hash[name].nil?
        @hash[name]
      elsif !@hash[name_dash].nil?
        @hash[name_dash]
      else
        false
      end
    end

    def find_value(name)
      result_hash = val?(name)
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

      if result_hash.is_a?(Hash)
        ParserResult.new(result_hash)
      else
        result_hash
      end
    end
  end
end
