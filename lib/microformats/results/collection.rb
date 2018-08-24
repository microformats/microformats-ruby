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
      values?(method) || super
    end

    private

    # does the $hash['items'] array contain any items with an h-<name> class?
    def values?(name)
      return false if @hash['items'].nil?

      result = search_for_items(name)

      !result.empty?
    end

    # select all items which have h-<name> types
    #  for example, if you want to filter to only h-cards
    def find_items(search_val)
      @hash['items'].select do |x|
        x['type'].include?('h-' + search_val)
      end
    end
  end
end
