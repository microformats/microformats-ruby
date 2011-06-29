require 'nokogiri'
require 'time'
require 'date'

module Microformats2
  VERSION = "1.0.0"

  class LoadError < StandardError; end

  def self.parse(html)
    raise LoadError, "argument must be a String or File" unless [String, File].include?(html.class)

    html = html.read if IO === html

    doc = Nokogiri::HTML(html)
    microformats = Hash.new{|hash, key| hash[key] = Array.new}
    doc.css("*[class*=h-]").each do |microformat|
      microformat.attribute("class").to_s.split.each do |mf_class|
        if mf_class =~ /^h-/
          constant_name = mf_class.gsub("-","_").gsub(/^([a-z])/){$1.upcase}.gsub(/_(.)/) { $1.upcase }

          if Object.const_defined?(constant_name)
            klass = Object.const_get(constant_name)
          else
            klass = Class.new
            Object.const_set constant_name, klass
          end

          obj = klass.new

          add_properties(microformat, obj)

          microformats[constant_name.downcase.to_sym] << obj
        end
      end
    end

    microformats
  end

  def self.add_method(obj, method_name)
    unless obj.respond_to?(method_name)
      obj.class.class_eval { attr_accessor method_name }
    end

    obj
  end

  def self.populate_method(obj, method_name, value)
    if cur = obj.send(method_name)
      if cur.kind_of? Array
        cur << value
      else
        obj.send("#{method_name}=", [cur, value])
      end
    else
      obj.send("#{method_name}=", value)
    end
  end

  class Stripper
    def transform(property)
      property.text.gsub(/\n+/, " ").gsub(/\s+/, " ").strip
    end
  end

  class URL
    def transform(property)
      property.attribute("href").to_s
    end
  end

  class Date
    def transform(property)
      DateTime.parse((property.attribute("title") || property.text).to_s)
    end
  end

  class TimeThingy
    def transform(property)
      Time.parse((property.attribute("title") || property.text).to_s)
    end
  end

  FormatClass = {
    "p" => Stripper.new,
    "n" => Stripper.new,
    "e" => Stripper.new,
    "i" => Stripper.new,
    "u" => URL.new,
    "d" => Date.new,
    "t" => TimeThingy.new
  }

  def self.add_properties(mf, obj)
    FormatClass.each do |letter, trans|
      mf.css("*[class*=#{letter}-]").each do |property|
        property.attribute("class").to_s.split.each do |css_class|
          if css_class[0..1] == "#{letter}-"
            css_class   = css_class[2..-1].gsub("-","_")
            method_name = css_class.gsub("-","_")
            value       = trans.transform(property)

            add_method(obj, method_name)
            populate_method(obj, method_name, value)
          end
        end
      end
    end
  end
end
