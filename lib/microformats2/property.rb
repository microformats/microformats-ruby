module Microformats2
  module Property
    CLASS_REG_EXP = /^(p-|u-|dt-|e-)/
    PREFIX_CLASS_MAP = {
      "p" => Text,
      "u" => Url,
      "dt" => DateTime,
      "e" => Embedded }
  end
end
