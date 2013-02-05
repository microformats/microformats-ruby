module Microformats2
  class TextProperty
    def parse(element)
      element.text.gsub(/\n+/, " ").gsub(/\s+/, " ").strip
    end
  end
  class UrlProperty
    def parse(element)
      (element.attribute("href") || property.text).to_s
    end
  end
  class DateTimeProperty
    def parse(element)
      DateTime.parse(element.attribute("datetime") || property.text)
    end
  end
  class EmbeddedProperty
    def parse(element)
      element.text
    end
  end

  PropertyPrefixes = {
    "p" => TextProperty.new,
    "u" => UrlProperty.new,
    "dt" => DateTimeProperty.new,
    "e" => EmbeddedProperty.new
  }
  PropertyPrefixesRegEx = /^(p-|u-|dt-|e-)/
end
