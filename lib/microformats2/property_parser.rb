module Microformats2
  class PropertyParser < ParserCore

    def parse(element, base, element_type, fmt_classes = [], backcompat = nil)
      @base = base
      @value = nil
      @property_type = element_type

      @fmt_classes = fmt_classes
      @mode_backcompat = backcompat

      if element_type == 'p'
        parse_value_class_pattern(element)

        if @value.nil?
          if element.name == 'abbr' and not element.attribute('title').nil?
            @value = element.attribute('title').value.strip
          elsif (element.name == 'data' or element.name == 'input') and not element.attribute('value').nil?
            @value = element.attribute('value').value.strip
          elsif (element.name == 'img' or element.name == 'area') and not element.attribute('alt').nil?
            @value = element.attribute('alt').value.strip
          else
            @value = render_text_and_replace_images(element, @base)
          end
        end

      elsif element_type == 'e'
        @value = {
          value: render_text(element, @base), #TODO the spec doesn't say to remove script and style tags, assuming this to be in error
          html: element.inner_html.gsub(/\A +/, '').gsub(/ +\Z/, '')
        }

      elsif element_type == 'u'
        if ['a', 'area'].include? element.name and not element.attribute('href').nil?
          @value = element.attribute('href').value.strip
        elsif ['img', 'audio', 'video', 'source'].include? element.name and not element.attribute('src').nil?
          @value = element.attribute('src').value.strip
        elsif element.name == 'video' and not element.attribute('poster').nil?
          @value = element.attribute('poster').value.strip
        elsif element.name == 'object' and not element.attribute('data').nil?
          @value = element.attribute('data').value.strip
        end

        if not @value.nil?
          @value = Microformats2::AbsoluteUri.new(@base, @value).absolutize
        else

          parse_value_class_pattern(element)

          if @value.nil?
            if element.name == 'abbr' and not element.attribute('title').nil?
              @value = element.attribute('title').value.strip
            elsif (element.name == 'data' or element.name == 'input') and not element.attribute('value').nil?
              @value = element.attribute('value').value.strip
            else
              @value = render_text(element, @base)
            end

          end
        end

      elsif element_type == 'dt'
        @value = Microformats2::TimePropertyParser.new.parse(element, base, element_type, fmt_classes, backcompat)

      end

      @value
    end

    def parse_value_class_pattern(element)
      @value_class_pattern_value = []
      parse_node(element.children)
      @value = @value_class_pattern_value.join unless @value_class_pattern_value.empty?
    end

    def parse_element(element)
      if value_title_classes(element).length >= 1
          @value_class_pattern_value << element.attribute('title').value.strip

      elsif value_classes(element).length >= 1
          if element.name == 'img' or element.name == 'area' and not element.attribute('alt').nil?
              @value_class_pattern_value << element.attribute('alt').value.strip
          elsif element.name == 'data' and not element.attribute('value').nil?
              @value_class_pattern_value << element.attribute('value').value.strip
          elsif element.name == 'abbr' and not element.attribute('title').nil?
              @value_class_pattern_value << element.attribute('title').value.strip
          else
              @value_class_pattern_value << element.text.strip
          end
      else
          p_classes = property_classes(element)
          p_classes = backcompat_property_classes(element) if @mode_backcompat
          if p_classes.length == 0 and format_classes(element).length == 0
              parse_node(element.children)
          end
      end
    end

    def render_text_and_replace_images(node, base)
      new_doc = Nokogiri::HTML(node.inner_html)
      new_doc.xpath('//script').remove
      new_doc.xpath('//style').remove
      new_doc.traverse do |node|
        if node.name == 'img' and not node.attribute('alt').nil?
          node.replace(' ' + node.attribute('alt').value.to_s + ' ')
        elsif node.name == 'img' and not node.attribute('src').nil?
          absolute_url = Microformats2::AbsoluteUri.new(@base, node.attribute('src').value.to_s).absolutize
          node.replace(' ' + absolute_url  + ' ')
        end
      end
      new_doc.text.strip
    end

    def render_text(node, base)
      new_doc = Nokogiri::HTML(node.inner_html)
      new_doc.xpath('//script').remove
      new_doc.xpath('//style').remove
      new_doc.text.strip
    end

  end
end
