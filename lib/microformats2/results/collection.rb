module Microformats2

  #stub to get around the tests for now
  class Collection
    def initialize(hash)
      @hash = hash
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

    def items
      @hash['items'].map do |item|
        ParserResult.new(item)
      end
    end

    def rels
      @hash['rels']
    end

    def rel_urls
      @hash['rel-urls']
    end

    def respond_to?(sym, include_private = false)
      has_item?(sym) || super(sym, include_private)
    end

    def method_missing(sym, *args, &block)

      name = sym.to_s
      name_dash = name.gsub('_', '-') if name.include? '_'

      if not @hash['items'].nil?
        result_hash = @hash['items'].select do |x|
            x['type'].include?('h-' + name)
        end
        if result_hash.empty? and not name_dash.nil?
          result_hash = @hash['items'].select do |x|
            x['type'].include?('h-' + name_dash)
          end
        end
      end

      super(sym, *args, &block) if result_hash.empty?

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

    def has_item?(name)
      name = name.to_s
      name_dash = name.gsub('_', '-') if name.include? '_'
      if not @hash['items'].nil?
        result_hash = @hash['items'].select do |x|
          x['type'].include?('h-' + name)
        end
        if result_hash.empty? and not name_dash.nil?
          result_hash = @hash['items'].select do |x|
            x['type'].include?('h-' + name_dash)
          end
        end
      end

      not result_hash.empty?
    end

  end
end

