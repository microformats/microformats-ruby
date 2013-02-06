module Microformats2
  class Collection < Parser
    def to_hash
      hash = { items: [] }
      @formats.each do |format|
        hash[:items] << format.to_hash
      end
      hash
    end

    def to_json
      to_hash.to_json
    end
  end
end
