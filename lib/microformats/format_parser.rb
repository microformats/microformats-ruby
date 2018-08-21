module Microformats
  class FormatParser < ParserCore
    def parse(element, base: nil, element_type: nil, format_class_array: [], backcompat: false)
      @base = base

      @mode_backcompat = backcompat

      @properties = {}
      @children = []
      @found_prefixes = Set.new

      @format_property_type = element_type
      @value = nil

      @mode_backcompat = backcompat

      @fmt_classes = format_class_array

      parse_node(element.children)

      # check properties for any missing h-* so we know not to imply anything
      check_for_h_properties

      imply_properties(element)

      if @value.nil? || @value.empty?
        if element_type == 'p' && !@properties['name'].nil? && !@properties['name'].empty?
          @value = @properties['name'].first
        elsif element_type == 'u' && !@properties['url'].nil? && !@properties['url'].empty?
          @value = @properties['url'].first
        elsif !element_type.nil?
          @value = PropertyParser.new.parse(element, base: @base, element_type: element_type, backcompat: @mode_backcompat)
        end
      end

      h_object = {}

      h_object['value'] = @value unless @value.nil?
      h_object['type'] = format_class_array
      h_object['properties'] = @properties

      h_object['children'] = @children unless @children.empty?

      if @format_property_type == 'e'
        h_object['value'] = render_text(element)
        h_object['html'] = element.inner_html.strip
      end

      # TODO: fall back to p- dt- u- parsing if value still not set?
      # not sure that is correct by the spec actually
      h_object
    end

    def parse_element(element)
      prop_classes = property_classes(element)
      prop_classes = backcompat_property_classes(element) if @mode_backcompat

      bc_classes_found = false
      fmt_classes = format_classes(element)

      prop_classes.each do |p_class|
        element_type = prefix_from_class(p_class)
        @found_prefixes.add(element_type.to_sym)
      end
      fmt_classes.each do |p_class|
        element_type = prefix_from_class(p_class)
        @found_prefixes.add(element_type.to_sym)
      end

      if fmt_classes.empty?
        fmt_classes = backcompat_format_classes(element)
        bc_classes_found = true unless fmt_classes.empty?
      end

      if prop_classes.length >= 1
        if fmt_classes.length >= 1
          prop_classes.each do |element_class|
            element_type = prefix_from_class(element_class)
            property_name = property_from_class(element_class)

            parsed_format = FormatParser.new.parse(element, base: @base, element_type: element_type, format_class_array: fmt_classes, backcompat: bc_classes_found)

            if @value.nil?
              if @format_property_type == 'p' && property_name == 'name'
                @value = parsed_format['value']
              # elsif @format_property_type == 'dt' and property_name == '???'
              #   @value = parsed_format['value']
              elsif @format_property_type == 'u' && property_name == 'url'
                @value = parsed_format['value']
              end
            end

            @properties[property_name] = [] if @properties[property_name].nil?
            @properties[property_name] << parsed_format
          end
        else
          prop_classes.each do |element_class|
            element_type = prefix_from_class(element_class)
            property_name = property_from_class(element_class)

            parsed_property = PropertyParser.new.parse(element, base: @base, element_type: element_type, backcompat: @mode_backcompat)

            unless parsed_property.nil?
              @properties[property_name] = [] if @properties[property_name].nil?
              @properties[property_name] << parsed_property
            end
          end

          parse_nodeset(element.children)
        end
      elsif fmt_classes.length >= 1
        @children << FormatParser.new.parse(element, base: @base, format_class_array: fmt_classes, backcompat: bc_classes_found)
      else
        parse_nodeset(element.children)
      end
    end

    def check_for_h_properties
      @properties.each do |_, prop|
        prop.each do |prop_entry|
          next unless prop_entry.respond_to?(:key) && prop_entry.key?('type')
          next if prop_entry['type'].nil?

          prop_entry['type'].each do |type|
            @found_prefixes.add(prefix_from_class(type).to_sym)
          end
        end
      end
    end

    def imply_name(element)
      return unless @properties['name'].nil? && !@found_prefixes.include?(:e) && !@found_prefixes.include?(:p) && !@found_prefixes.include?(:h) && @children.empty?

      if element.name == 'img' && !element.attribute('alt').nil?
        @properties['name'] = [element.attribute('alt').value.strip]
      elsif element.name == 'area' && !element.attribute('alt').nil?
        @properties['name'] = [element.attribute('alt').value.strip]
      elsif element.name == 'abbr' && !element.attribute('title').nil?
        @properties['name'] = [element.attribute('title').value.strip]
      else
        child_nodes = element.children.reject { |n| n.is_a?(Nokogiri::XML::Text) }

        if child_nodes.count == 1 && child_nodes.first.is_a?(Nokogiri::XML::Element) && format_classes(child_nodes.first).empty?
          node = child_nodes.first

          # else if .h-x>img:only-child[alt]:not([alt=""]):not[.h-*] then use that img's alt for name
          if node.name == 'img' && !node.attribute('alt').nil? && !node.attribute('alt').value.empty?
            @properties['name'] = [node.attribute('alt').value.strip]
          # else if .h-x>area:only-child[alt]:not([alt=""]):not[.h-*] then use that area's alt for name
          elsif node.name == 'area' && !node.attribute('alt').nil? && !node.attribute('alt').value.empty?
            @properties['name'] = [node.attribute('alt').value.strip]
          # else if .h-x>abbr:only-child[title]:not([title=""]):not[.h-*] then use that abbr title for name
          elsif node.name == 'abbr' && !node.attribute('title').nil? && !node.attribute('title').value.empty?
            @properties['name'] = [node.attribute('title').value.strip]
          else
            child_nodes = node.children.reject { |n| n.is_a?(Nokogiri::XML::Text) }

            if child_nodes.count == 1 && child_nodes.first.is_a?(Nokogiri::XML::Element) && format_classes(child_nodes.first).empty?
              node = child_nodes.first

              # else if .h-x>:only-child:not[.h-*]>img:only-child[alt]:not([alt=""]):not[.h-*] then use that img's alt for name
              if node.name == 'img' && !node.attribute('alt').nil? && !node.attribute('alt').value.empty?
                @properties['name'] = [node.attribute('alt').value.strip]
              # else if .h-x>:only-child:not[.h-*]>area:only-child[alt]:not([alt=""]):not[.h-*] then use that area's alt for name
              elsif node.name == 'area' && !node.attribute('alt').nil? && !node.attribute('alt').value.empty?
                @properties['name'] = [node.attribute('alt').value.strip]
              # else if .h-x>:only-child:not[.h-*]>abbr:only-child[title]:not([title=""]):not[.h-*] use that abbr's title for name
              elsif node.name == 'abbr' && !node.attribute('title').nil? && !node.attribute('title').value.empty?
                @properties['name'] = [node.attribute('title').value.strip]
              else
                @properties['name'] = [render_text(element)]
              end
            else
              @properties['name'] = [render_text(element)]
            end
          end
        else
          @properties['name'] = [render_text(element)]
        end
      end
    end

    def imply_photo(element)
      return unless @properties['photo'].nil?

      if element.name == 'img' && !element.attribute('src').nil?
        @properties['photo'] = [element.attribute('src').value]
      elsif element.name == 'object' && !element.attribute('data').nil?
        @properties['photo'] = [element.attribute('data').value]
      else
        # else if .h-x>img[src]:only-of-type:not[.h-*] then use that img src for photo
        child_img_tags_with_src = element.children.select do |child|
          child.is_a?(Nokogiri::XML::Element) && child.name == 'img' && !child.attribute('src').nil?
        end

        if child_img_tags_with_src.count == 1
          node = child_img_tags_with_src.first

          @properties['photo'] = [node.attribute('src').value.strip] if format_classes(node).empty?
        end

        if @properties['photo'].nil?
          # else if .h-x>object[data]:only-of-type:not[.h-*] then use that object's data for photo
          child_object_tags_with_data = element.children.select do |child|
            child.is_a?(Nokogiri::XML::Element) && child.name == 'object' && !child.attribute('data').nil?
          end

          if child_object_tags_with_data.count == 1
            node = child_object_tags_with_data.first

            if format_classes(node).empty?
              @properties['photo'] = [node.attribute('data').value.strip]
            end
          end
        end

        child_elements = element.children.reject { |child| child.is_a?(Nokogiri::XML::Text) }

        if @properties['photo'].nil? && child_elements.count == 1 && format_classes(child_elements.first).empty?
          # else if .h-x>:only-child:not[.h-*]>img[src]:only-of-type:not[.h-*], then use that img's src for photo
          child_img_tags_with_src = child_elements.first.children.select do |child|
            child.is_a?(Nokogiri::XML::Element) && child.name == 'img' && !child.attribute('src').nil?
          end

          if child_img_tags_with_src.count == 1
            node = child_img_tags_with_src.first

            if format_classes(node).empty?
              @properties['photo'] = [node.attribute('src').value.strip]
            end
          end

          if @properties['photo'].nil?
            # else if .h-x>:only-child:not[.h-*]>object[data]:only-of-type:not[.h-*], then use that object's data for photo
            child_object_tags_with_data = child_elements.first.children.select do |child|
              child.is_a?(Nokogiri::XML::Element) && child.name == 'object' && !child.attribute('data').nil?
            end

            if child_object_tags_with_data.count == 1
              node = child_object_tags_with_data.first

              if format_classes(node).empty?
                @properties['photo'] = [node.attribute('data').value.strip]
              end
            end
          end
        end
      end

      @properties['photo'] = [Microformats::AbsoluteUri.new(@properties['photo'].first, base: @base).absolutize] unless @properties['photo'].nil?
    end

    def imply_url(element)
      return unless @properties['url'].nil? && !@found_prefixes.include?(:u) && !@found_prefixes.include?(:h) && @children.empty?

      if element.name == 'a' && !element.attribute('href').nil?
        @properties['url'] = [element.attribute('href').value]
      elsif element.name == 'area' && !element.attribute('href').nil?
        @properties['url'] = [element.attribute('href').value]
      else
        # else if .h-x>a[href]:only-of-type:not[.h-*], then use that [href] for url
        child_a_tags_with_href = element.children.select do |child|
          child.is_a?(Nokogiri::XML::Element) && child.name == 'a' && !child.attribute('href').nil?
        end

        if child_a_tags_with_href.count == 1
          node = child_a_tags_with_href.first
          @properties['url'] = [node.attribute('href').value.strip] if format_classes(node).empty?
        end

        if @properties['url'].nil?
          # else if .h-x>area[href]:only-of-type:not[.h-*], then use that [href] for url
          child_area_tags_with_href = element.children.select do |child|
            child.is_a?(Nokogiri::XML::Element) && child.name == 'area' && !child.attribute('href').nil?
          end

          if child_area_tags_with_href.count == 1
            node = child_area_tags_with_href.first
            @properties['url'] = [node.attribute('href').value.strip] if format_classes(node).empty?
          end
        end

        child_elements = element.children.reject { |child| child.is_a?(Nokogiri::XML::Text) }

        if @properties['url'].nil? && child_elements.count == 1 && format_classes(child_elements.first).empty?
          child_element = child_elements.first
          # else if .h-x>:only-child:not[.h-*]>a[href]:only-of-type:not[.h-*], then use that [href] for url
          child_a_tags_with_href = child_element.children.select do |child|
            child.is_a?(Nokogiri::XML::Element) && child.name == 'a' && !child.attribute('href').nil?
          end

          if child_a_tags_with_href.count == 1
            node = child_a_tags_with_href.first
            @properties['url'] = [node.attribute('href').value.strip] if format_classes(node).empty?
          end

          if @properties['url'].nil?
            # else if .h-x>:only-child:not[.h-*]>area[href]:only-of-type:not[.h-*], then use that [href] for url
            child_area_tags_with_href = child_element.children.select do |child|
              child.is_a?(Nokogiri::XML::Element) && child.name == 'area' && !child.attribute('href').nil?
            end

            if child_area_tags_with_href.count == 1
              node = child_area_tags_with_href.first
              @properties['url'] = [node.attribute('href').value.strip] if format_classes(node).empty?
            end
          end
        end
      end

      @properties['url'] = [Microformats::AbsoluteUri.new(@properties['url'].first, base: @base).absolutize] unless @properties['url'].nil?
    end

    def prefix_from_class(class_name)
      class_name.downcase.split('-')[0]
    end

    def property_from_class(class_name)
      class_name.downcase.split('-')[1..-1].join('-')
    end

    # imply date for dt-end if dt-start is defined with a date ###
    def imply_dates
      return unless !@properties['end'].nil? && !@properties['start'].nil?

      start_date = nil

      @properties['start'].each do |start_val|
        if start_val =~ /^(\d{4}-[01]\d-[0-3]\d)/
          start_date = Regexp.last_match(1) if start_date.nil?
        elsif start_val =~ /^(\d{4}-[0-3]\d\d)/
          start_date = Regexp.last_match(1) if start_date.nil?
        end
      end

      unless start_date.nil?
        @properties['end'].map! do |end_val|
          if end_val.match?(/^\d{4}-[01]\d-[0-3]\d/)
            end_val
          elsif end_val.match?(/^\d{4}-[0-3]\d\d/)
            end_val
          else
            start_date + ' ' + end_val
          end
        end
      end
    end

    def imply_properties(element)
      ##### Implied Properties ######
      # NOTE: much of this code may be simplified by using element.css, not sure yet, but coding to have passing tests first
      # can optimize this later
      unless @mode_backcompat
        imply_name(element)
        imply_photo(element)
        imply_url(element)
      end
      ##### END Implied Properties when not in backcompat mode######

      imply_dates
    end
  end
end
