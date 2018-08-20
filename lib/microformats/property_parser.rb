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
              render_text(element, base: @base)
            end
        end
      elsif element_type == 'e'
        @value = {
          value: render_text(element, base: @base),
          html: element.inner_html.strip
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
            render_and_strip(element.text.strip)
          end
      else
        p_classes = property_classes(element)
        p_classes = backcompat_property_classes(element) if @mode_backcompat

        if p_classes.empty? && format_classes(element).empty?
          parse_node(element.children)
        end
      end
    end
  end
end
