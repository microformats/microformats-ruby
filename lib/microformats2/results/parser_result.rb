module Microformats2

  #stub to get around the tests for now
  class ParserResult

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
      if @hash['value']
        return @hash['value']
      else
        super
      end
    end

    def [](key)
      @hash[key]
    end

    def value
      @hash['value']
    end

    def properties
      PropertySet.new( @hash['properties'])
    end

    def respond_to?(sym, include_private = false)
      has_key?(sym) || has_property?(sym) || super(sym, include_private)
    end

    def method_missing(sym, *args, &block)

      name = sym.to_s
      name_dash = name.gsub('_', '-') if name.include? '_'

      if not @hash[name].nil?
        result_hash = @hash[name]

      elsif not @hash['properties'].nil? and not @hash['properties'][name].nil?
        result_hash = @hash['properties'][name]

      elsif not name_dash.nil? and not @hash[name_dash].nil?
        result_hash = @hash[name_dash]

      elsif not name_dash.nil? and not @hash['properties'].nil? and not @hash['properties'][name_dash].nil?
        result_hash = @hash['properties'][name_dash]

      else
        super(sym, *args, &block)
      end

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

      if result_hash.nil? or result_hash.empty?
        result_hash
      elsif result_hash.is_a? Hash
        ParserResult.new(result_hash)
      else
        result_hash
      end
    end

    private

    def has_key?(name)
      name = name.to_s
      name_dash = name.gsub('_', '-') if name.include? '_'

      not @hash[name].nil? or not @hash[name_dash].nil?
    end
    
    def has_property?(name)
      name = name.to_s
      name_dash = name.gsub('_', '-') if name.include? '_'
      return false if @hash['properties'].nil?
      not @hash['properties'][name].nil? or not @hash['properties'][name_dash].nil?
    end

  end
end

