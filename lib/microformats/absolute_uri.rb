module Microformats
  class AbsoluteUri
    attr_accessor :base, :relative

    def initialize(relative, base: nil)
      @base = base
      @relative = relative
      @base.strip! unless @base.nil?
      @relative.strip! unless @relative.nil?
    end

    def absolutize
      return base if relative.nil? or relative == ""
      return relative if relative =~ /^https?:\/\//
      return base + relative if relative =~ /^#/

      uri = URI.parse(relative)

      if base && !uri.absolute?
        uri = URI.join(base.to_s, relative.to_s)
      end

      uri.normalize!
      uri.to_s

    rescue URI::BadURIError, URI::InvalidURIError => e
      relative.to_s
    end
  end
end
