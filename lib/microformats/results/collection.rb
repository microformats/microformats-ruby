module Microformats
  # stub to get around the tests for now
  class Collection
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
      return @hash['value'] if @hash['value']

      super
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
      item?(sym) || super(sym, include_private)
    end

    def method_missing(sym, *args, &block)
      name = sym.to_s
      name_dash = name.tr('_', '-') if name.include?('_')

      unless @hash['items'].nil?
        result_hash = @hash['items'].select do |x|
          x['type'].include?('h-' + name)
        end

        if result_hash.empty? && !name_dash.nil?
          result_hash = @hash['items'].select do |x|
            x['type'].include?('h-' + name_dash)
          end
        end
      end

      super(sym, *args, &block) if result_hash.empty?

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

    def item?(name)
      name = name.to_s
      name_dash = name.tr('_', '-') if name.include?('_')

      unless @hash['items'].nil?
        result_hash = @hash['items'].select do |x|
          x['type'].include?('h-' + name)
        end

        if result_hash.empty? && !name_dash.nil?
          result_hash = @hash['items'].select do |x|
            x['type'].include?('h-' + name_dash)
          end
        end
      end

      !result_hash.empty?
    end
  end
end
