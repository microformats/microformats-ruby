module Microformats
  class PropertyParser < ParserCore
    def parse(element, base: nil, element_type:, format_class_array: [], backcompat: nil)
      @base = base
      @value = nil
      @property_type = element_type

      @fmt_classes = format_class_array
      @mode_backcompat = backcompat

      if element_type == 'p'
        parse_value_class_pattern(element)

        if @value.nil?
          @value =
            if element.name == 'abbr' && !element.attribute('title').nil?
              element.attribute('title').value.strip
            elsif element.name == 'link' && !element.attribute('title').nil?
              element.attribute('title').value.strip
            elsif (element.name == 'data' || element.name == 'input') && !element.attribute('value').nil?
              element.attribute('value').value.strip
            elsif (element.name == 'img' || element.name == 'area') && !element.attribute('alt').nil?
              element.attribute('alt').value.strip
            else
              render_text_and_replace_images(element, base: @base)
            end
        end
      elsif element_type == 'e'
        @value = {
          value: render_text_from_html(element, base: @base), # TODO: the spec doesn't say to remove script and style tags, assuming this to be in error
          html: element.inner_html.gsub(/\A +/, '').gsub(/ +\Z/, '')
        }
      elsif element_type == 'u'
        if %w[a area link].include?(element.name) && !element.attribute('href').nil?
          @value = element.attribute('href').value.strip
        elsif %w[img audio video source].include?(element.name) && !element.attribute('src').nil?
          @value = element.attribute('src').value.strip
        elsif element.name == 'video' && !element.attribute('poster').nil?
          @value = element.attribute('poster').value.strip
        elsif element.name == 'object' && !element.attribute('data').nil?
          @value = element.attribute('data').value.strip
        end

        if !@value.nil?
          @value = Microformats::AbsoluteUri.new(@value, base: @base).absolutize
        else
          parse_value_class_pattern(element)

          if @value.nil?
            @value =
              if element.name == 'abbr' && !element.attribute('title').nil?
                element.attribute('title').value.strip
              elsif (element.name == 'data' || element.name == 'input') && !element.attribute('value').nil?
                element.attribute('value').value.strip
              else
                render_text(element, base: @base)
              end
          end
        end
      elsif element_type == 'dt'
        @value = Microformats::TimePropertyParser.new.parse(element, base: base, element_type: element_type, format_class_array: format_class_array, backcompat: backcompat)
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
        @value_class_pattern_value <<
          if element.name == 'img' || element.name == 'area' && !element.attribute('alt').nil?
            element.attribute('alt').value.strip
          elsif element.name == 'data' && !element.attribute('value').nil?
            element.attribute('value').value.strip
          elsif element.name == 'abbr' && !element.attribute('title').nil?
            element.attribute('title').value.strip
          else
            element.text.strip
          end
      else
        p_classes = property_classes(element)
        p_classes = backcompat_property_classes(element) if @mode_backcompat

        if p_classes.empty? && format_classes(element).empty?
          parse_node(element.children)
        end
      end
    end

    def render_text_and_replace_images(node, base: nil)
      new_doc = Nokogiri::HTML(node.inner_html)
      new_doc.xpath('//script').remove
      new_doc.xpath('//style').remove

      new_doc.traverse do |node|
        if node.name == 'img' && !node.attribute('alt').nil?
          node.replace(' ' + node.attribute('alt').value.to_s + ' ')
        elsif node.name == 'img' && !node.attribute('src').nil?
          absolute_url = Microformats::AbsoluteUri.new(node.attribute('src').value.to_s, base: @base).absolutize

          node.replace(' ' + absolute_url + ' ')
        end
      end

      new_doc.text.strip
    end

    def render_text(node, base: nil)
      new_doc = Nokogiri::HTML(node.inner_html)
      new_doc.xpath('//script').remove
      new_doc.xpath('//style').remove
      new_doc.text.strip
    end

    def render_text_from_html(node, base: nil)
      el = node.clone
      el.css('br').each do |n|
        n.replace(Nokogiri::XML::Text.new("\r", el))
      end
      new_doc = Nokogiri::HTML(el.inner_html.gsub(/\n/, '').gsub(/\r/, "\n").gsub(/ +/, ' '))
      new_doc.xpath('//script').remove
      new_doc.xpath('//style').remove
      new_doc.text.strip
    end
  end
end
