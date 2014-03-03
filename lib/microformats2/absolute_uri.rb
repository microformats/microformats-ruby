module Microformats2
  class AbsoluteUri
    attr_accessor :base, :relative

    def initialize(base, relative)
      @base = base
      @relative = relative
    end

    def absolutize
      return nil if relative.nil? or relative == ""

      uri = URI.parse(relative)

      if base && !uri.absolute?
        uri = URI.join(base.to_s, relative.to_s)
      end

      uri.normalize!
      uri.to_s
    rescue URI::InvalidURIError => e
      logger.warn e.message
      relative.to_s
    end

    def logger
     @logger ||= Logger.new(STDOUT)
     @logger.level = Logger::WARN
     @logger
    end
  end
end
