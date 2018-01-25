module Microformats
  # stub to get around the tests for now
  class PropertySet
    def initialize(hash)
      @hash = hash
    end

    def to_h
      @hash
    end

    def to_hash
      @hash.to_hash
    end

    def to_json
      @hash.to_hash.to_json
    end

    def [](key)
      @hash[key]
    end

    def respond_to?(sym, include_private = false)
      key?(sym) || super(sym, include_private)
    end

    def method_missing(mname, *args, &block)
      if respond_to?(mname)
        result_hash = val?(mname)

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
      else
        super(mname, *args, &block)
      end
    end

    private

    def key?(name)
      name = name.to_s
      name_dash = name.tr('_', '-') if name.include?('_')

      !@hash[name].nil? || !@hash[name_dash].nil?
    end

    def val?(name)
      name = name.to_s
      name_dash = name.tr('_', '-') if name.include?('_')

      if !@hash[name].nil?
        @hash[name]
      elsif !@hash[name_dash].nil?
        @hash[name_dash]
      end
    end
  end
end
