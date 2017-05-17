module Microformats

  #stub to get around the tests for now
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
      has_key?(sym) || super(sym, include_private)
    end


    def method_missing(mname, *args, &block)

      if respond_to? mname
        result_hash = get_val? mname
        if result_hash.is_a? Array
          if args[0].nil?
            result_hash = result_hash[0] #will return nil for an empty array

          elsif args[0] == :all
            return result_hash.map do |x|
              ParserResult.new(x)
            end

          elsif args[0].to_i < result_hash.count
            result_hash = result_hash[args[0].to_i]

          else
            result_hash = result_hash[0] #will return nil for an empty array
          end
        end

        if result_hash.is_a? Hash
          ParserResult.new(result_hash)
        else
          result_hash
        end
      else
         super(mname, *args, &block)
      end

    end

    private

    def has_key?(name)
      name = name.to_s
      name_dash = name.gsub('_', '-') if name.include? '_'
      not @hash[name].nil? or  not @hash[name_dash].nil? 
    end

    def get_val?(name)
      name = name.to_s
      name_dash = name.gsub('_', '-') if name.include? '_'

      if not @hash[name].nil?
        result_hash = @hash[name]

      elsif not @hash[name_dash].nil?
        result_hash = @hash[name_dash]
      else
        nil
      end
    end

  end
end

