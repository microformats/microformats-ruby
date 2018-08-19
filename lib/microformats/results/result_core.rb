module Microformats
  # base class for shared code between result classes
  class ResultCore
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
      @hash.to_s
    end

    def [](key)
      @hash[key]
    end

    private

    def key?(name)
      name = name.to_s
      name_dash = name.tr('_', '-') if name.include?('_')

      !@hash[name].nil? || !@hash[name_dash].nil?
    end
  end
end
