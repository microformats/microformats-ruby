require 'nokogiri'
require 'time'
require 'date'

module Microformats2
  VERSION = "1.0.0"

  class LoadError < StandardError; end

  def self.parse(html)
    raise LoadError, "argument must be a String or File" unless [String, File].include?(html.class)

    doc = Nokogiri::HTML(html)
    microformats = Hash.new{|hash, key| hash[key] = Array.new}
    doc.css("*[class^=h-]").each do |microformat|
      constant_name = classify(microformat.attribute("class").to_s.gsub("-","_"))

      if Object.const_defined?(constant_name)
        klass = Object.const_get(constant_name)
      else
        klass = Class.new
        Object.const_set constant_name, klass
      end

      obj = klass.new

      # Add any properties to the object
      add_properties(microformat, obj)
      add_urls(microformat, obj)
      add_dates(microformat, obj)
      add_times(microformat, obj)

      microformats[constant_name.downcase.to_sym] << obj
    end

    return microformats
  end

  def self.add_method(obj, method_name)
    unless obj.respond_to?(method_name)
      obj.class.class_eval { attr_accessor method_name }
    end

    obj
  end

  def self.add_properties(mf, obj)
    %w(p n e i).each do |letter|
      mf.css("*[class|=#{letter}]").each do |property|
        property.attribute("class").to_s.split.each do |css_class|
          if css_class =~ /^[pnei]/
            css_class   = css_class[2..-1].gsub("-","_")
            method_name = css_class.gsub("-","_")
            value       = property.text.gsub(/\n+/, " ").gsub(/\s+/, " ").strip

            add_method(obj, method_name)

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
        end
      end
    end
  end

  def self.add_urls(mf, obj)
    mf.css("*[class*=u-]").each do |property|
      property.attribute("class").to_s.split.each do |css_class|
        if css_class =~ /^u/
          css_class   = css_class[2..-1].gsub("-","_")
          method_name = css_class.gsub("-","_")
          value       = property.attribute("href").to_s

          add_method(obj, method_name)

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
      end
    end
  end

  def self.add_dates(mf, obj)
    mf.css("*[class*=d-]").each do |property|
      property.attribute("class").to_s.split.each do |css_class|
        if css_class =~ /^d/
          css_class   = css_class[2..-1].gsub("-","_")
          method_name = css_class.gsub("-","_")
          value       = DateTime.parse((property.attribute("title") || property.text).to_s)

          add_method(obj, method_name)

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
      end
    end
  end

  def self.add_times(mf, obj)
    mf.css("*[class*=t-]").each do |property|
      property.attribute("class").to_s.split.each do |css_class|
        if css_class =~ /^t/
          css_class   = css_class[2..-1].gsub("-","_")
          method_name = css_class.gsub("-","_")
          value       = Time.parse((property.attribute("title") || property.text).to_s)

          add_method(obj, method_name)

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
      end
    end
  end

  # Thank you Rails Developers for your unitentional contribution to this project
  # File activesupport/lib/active_support/inflector/inflections.rb, line 206
  def self.classify(str)
    # strip out any leading schema name
    camelize(singularize(str.to_s.sub(/.*\./, '')))
  end

  # File activesupport/lib/active_support/inflector/inflections.rb, line 148
  def self.singularize(word)
    result = word.to_s.dup
  end

  # File activesupport/lib/active_support/inflector/methods.rb, line 28
  def self.camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
    if first_letter_in_uppercase
      lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    else
      lower_case_and_underscored_word.to_s[0].chr.downcase + camelize(lower_case_and_underscored_word)[1..-1]
    end
  end
end
