module Microformats2
  module Property
    CLASS_REG_EXP = /^(p-|u-|dt-|e-)/
    PREFIX_CLASS_MAP = {
      "p" => Text,
      "u" => Url,
      "dt" => DateTime,
      "e" => Embedded }

    class << self

	    def new(element, property_class, value=nil)
	      # p-class-name -> p
	      prefix = property_class.split("-").first
	      # find ruby class for kind of property
	      klass = PREFIX_CLASS_MAP[prefix]
	      raise InvalidPropertyPrefix unless klass
	      klass.new(element, property_class, value)
	    end
	  end

  end
end
