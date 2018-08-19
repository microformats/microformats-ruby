module Microformats
  # stub to get around the tests for now
  class PropertySet < ResultCore
    def to_hash
      @hash.to_hash
    end

    private

    def find_items(search_val)
      @hash[search_val]
    end
  end
end
