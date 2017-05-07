module Microformats2

  #stub to get around the tests for now
  class ParserResult
    def initialize(hash)
      @hash = hash
    end
    def to_hash
      @hash
    end
    def to_json
      to_hash.to_json
    end

    def method_missing(name, *args, &block)

      name = name.to_s
      name_dash = name.gsub('_', '-') if name.include? '_'

      if not @hash[name].nil?
        result_hash = @hash[name]

      elsif not @hash['properties'].nil? and not @hash['properties'][name].nil?
        result_hash = @hash['properties'][name]

      elsif not name_dash.nil? and not @hash[name_dash].nil?
        result_hash = @hash[name_dash]

      elsif not name_dash.nil? and not @hash['properties'].nil? and not @hash['properties'][name_dash].nil?
        result_hash = @hash['properties'][name_dash]

      elsif not @hash['items'].nil?
        result_hash = @hash['items'].select do |x|
            x['type'].include?('h-' + name)
        end
        if result_hash.empty? and not name_dash.nil?
          result_hash = @hash['items'].select do |x|
            x['type'].include?('h-' + name_dash)
          end
        end
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
  end
end

