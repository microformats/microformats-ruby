module Microformats2
  module Property
    Parsers = {
      "p" => Text,
      "u" => Url,
      "dt" => DateTime,
      "e" => Embedded
    }
    PrefixesRegEx = /^(p-|u-|dt-|e-)/
  end
end
