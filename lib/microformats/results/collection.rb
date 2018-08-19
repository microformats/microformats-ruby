module Microformats
  # stub to get around the tests for now
  class Collection < ResultCore
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

    def respond_to_missing?(method, *)
      item?(method) || super
    end

    def method_missing(sym, *args, &block)
      result = search_for_items(sym.to_s)

      if !result.empty?
        convert_to_parser_result(result, args[0])
      else
        super
      end
    end

    private

    # does the $hash['items'] array contain any items with an h-<name> class?
    def item?(name)
      return false if @hash['items'].nil?

      result = search_for_items(name)

      !result.empty?
    end

    # select all items which have h-<name> types
    #  for example, if you want to filter to only h-cards
    def select_h_items(search_val)
      @hash['items'].select do |x|
        x['type'].include?('h-' + search_val)
      end
    end

    # given a name, find all h-* entries for it
    #  this also allows for underscores to be used in place of dashes
    def search_for_items(search_val)
      name = search_val.to_s
      name_dash = name.tr('_', '-') if name.include?('_')

      result = select_h_items(name)
      result = select_h_items(name_dash) if result.empty? && !name_dash.nil?

      result
    end

    # given a set of args and some selector within that, return a ParserResult object
    # or possibly a set of ParserResult Objects.
    # This is how previous versions of the parser returned objects and as such we are trying to
    # keep full support
    def convert_to_parser_result(input_array, selector)
      return ParserResult.new(input_array) unless input_array.is_a?(Array)

      if selector == :all
        return input_array.map do |x|
          ParserResult.new(x)
        end
      end

      return ParserResult.new(input_array[selector.to_i]) if selector.to_i < input_array.count

      ParserResult.new(input_array[0])
    end
  end
end
