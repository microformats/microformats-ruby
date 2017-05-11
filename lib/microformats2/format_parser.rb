module Microformats2
  class FormatParser < ParserCore

    def parse(element, base=nil, element_type=nil, fmt_classes=[], backcompat=false)
      @base = base

      @mode_backcompat = backcompat

      @properties = {}
      @children = []

      @format_property_type = element_type
      @value = nil

      @mode_backcompat = backcompat

      @fmt_classes =  fmt_classes

      parse_node(element.children)

      ##### Implied Properties######
      #NOTE: much of this code may be simplified by using element.css, not sure yet, but coding to have passing tests first
      # can optimize this later
      unless @mode_backcompat
        if @properties['name'].nil?

          if element.name == 'img' and not element.attribute('alt').nil?
            @properties['name'] = [element.attribute('alt').value.strip]
          elsif element.name == 'area' and not element.attribute('alt').nil?
            @properties['name'] = [element.attribute('alt').value.strip]
          elsif element.name == 'abbr' and not element.attribute('title').nil?
            @properties['name'] = [element.attribute('title').value.strip]

          else
            child_nodes = element.children.select{|n| not n.is_a?(Nokogiri::XML::Text)}

            if child_nodes.count == 1 and child_nodes.first.is_a?(Nokogiri::XML::Element) and format_classes(child_nodes.first).empty?
              node = child_nodes.first

              #else if .h-x>img:only-child[alt]:not([alt=""]):not[.h-*] then use that img’s alt for name
              if node.name == 'img' and not node.attribute('alt').nil? and not node.attribute('alt').value.empty?
                @properties['name'] = [node.attribute('alt').value.strip]

              #else if .h-x>area:only-child[alt]:not([alt=""]):not[.h-*] then use that area’s alt for name
              elsif node.name == 'area' and not node.attribute('alt').nil? and not node.attribute('alt').value.empty?
                @properties['name'] = [node.attribute('alt').value.strip]

              #else if .h-x>abbr:only-child[title]:not([title=""]):not[.h-*] then use that abbr title for name
              elsif node.name == 'abbr' and not node.attribute('title').nil? and not node.attribute('title').value.empty?
                @properties['name'] = [node.attribute('title').value.strip]

              else
                child_nodes = node.children.select{|n| not n.is_a?(Nokogiri::XML::Text)}
                if child_nodes.count == 1 and child_nodes.first.is_a?(Nokogiri::XML::Element) and format_classes(child_nodes.first).empty?
                  node = child_nodes.first

                  #else if .h-x>:only-child:not[.h-*]>img:only-child[alt]:not([alt=""]):not[.h-*] then use that img’s alt for name
                  if node.name == 'img' and not node.attribute('alt').nil? and not node.attribute('alt').value.empty?
                    @properties['name'] = [node.attribute('alt').value.strip]

                  #else if .h-x>:only-child:not[.h-*]>area:only-child[alt]:not([alt=""]):not[.h-*] then use that area’s alt for name
                  elsif node.name == 'area' and not node.attribute('alt').nil? and not node.attribute('alt').value.empty?
                    @properties['name'] = [node.attribute('alt').value.strip]

                  #else if .h-x>:only-child:not[.h-*]>abbr:only-child[title]:not([title=""]):not[.h-*] use that abbr’s title for name
                  elsif node.name == 'abbr' and not node.attribute('title').nil? and not node.attribute('title').value.empty?
                    @properties['name'] = [node.attribute('title').value.strip]

                  else
                    @properties['name'] = [element.text.strip]

                  end
                else
                  @properties['name'] = [element.text.strip]
                end
              end
            else
              @properties['name'] = [element.text.strip]
            end
          end
        end # end implied name


        if @properties['photo'].nil?
          if element.name == 'img' and not element.attribute('src').nil?
            @properties['photo'] = [element.attribute('src').value]
          elsif element.name == 'object' and not element.attribute('data').nil?
            @properties['photo'] = [element.attribute('data').value]
          else

            #else if .h-x>img[src]:only-of-type:not[.h-*] then use that img src for photo

            child_img_tags_with_src = element.children.select do |child|
              child.is_a?(Nokogiri::XML::Element) and child.name == 'img' and not child.attribute('src').nil?
            end
            if child_img_tags_with_src.count == 1
              node = child_img_tags_with_src.first
              if format_classes(node).empty?
                @properties['photo'] = [node.attribute('src').value.strip]
              end
            end

            if @properties['photo'].nil?

              #else if .h-x>object[data]:only-of-type:not[.h-*] then use that object’s data for photo

              child_object_tags_with_data = element.children.select do |child|
                child.is_a?(Nokogiri::XML::Element) and child.name == 'object' and not child.attribute('data').nil?
              end
              if child_object_tags_with_data.count == 1
                node = child_object_tags_with_data.first
                if format_classes(node).empty?
                  @properties['photo'] = [node.attribute('data').value.strip]
                end
              end
            end

            child_elements = element.children.select do |child| not child.is_a?(Nokogiri::XML::Text) end

            if @properties['photo'].nil? and child_elements.count == 1 and format_classes(child_elements.first).empty?

              #else if .h-x>:only-child:not[.h-*]>img[src]:only-of-type:not[.h-*], then use that img’s src for photo

              child_img_tags_with_src = child_elements.first.children.select do |child|
                child.is_a?(Nokogiri::XML::Element) and child.name == 'img' and not child.attribute('src').nil?
              end
              if child_img_tags_with_src.count == 1
                node = child_img_tags_with_src.first
                if format_classes(node).empty?
                  @properties['photo'] = [node.attribute('src').value.strip]
                end
              end

              if @properties['photo'].nil?

                #else if .h-x>:only-child:not[.h-*]>object[data]:only-of-type:not[.h-*], then use that object’s data for photo
                #
                child_object_tags_with_data = child_elements.first.children.select do |child|
                  child.is_a?(Nokogiri::XML::Element) and child.name == 'object' and not child.attribute('data').nil?
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
          unless @properties['photo'].nil?
            @properties['photo'] = [ Microformats2::AbsoluteUri.new(@base, @properties['photo'].first).absolutize ]
          end
        end

        if @properties['url'].nil?
          if element.name == 'a' and not element.attribute('href').nil?
            @properties['url'] = [element.attribute('href').value]
          elsif element.name == 'area' and not element.attribute('href').nil?
            @properties['url'] = [element.attribute('href').value]
          else
            #else if .h-x>a[href]:only-of-type:not[.h-*], then use that [href] for url
            child_a_tags_with_href = element.children.select do |child|
              child.is_a?(Nokogiri::XML::Element) and child.name == 'a' and not child.attribute('href').nil?
            end
            if child_a_tags_with_href.count == 1
              node = child_a_tags_with_href.first
              if format_classes(node).empty?
                @properties['url'] = [node.attribute('href').value.strip]
              end
            end

            if @properties['url'].nil?

              #else if .h-x>area[href]:only-of-type:not[.h-*], then use that [href] for url
              child_area_tags_with_href = element.children.select do |child|
                child.is_a?(Nokogiri::XML::Element) and child.name == 'area' and not child.attribute('href').nil?
              end
              if child_area_tags_with_href.count == 1
                node = child_area_tags_with_href.first
                if format_classes(node).empty?
                  @properties['url'] = [node.attribute('href').value.strip]
                end
              end
            end

            child_elements = element.children.select do |child| not child.is_a?(Nokogiri::XML::Text) end

            if @properties['url'].nil? and child_elements.count == 1 and format_classes(child_elements.first).empty?
              child_element = child_elements.first

              #else if .h-x>:only-child:not[.h-*]>a[href]:only-of-type:not[.h-*], then use that [href] for url
              child_a_tags_with_href = child_element.children.select do |child|
                child.is_a?(Nokogiri::XML::Element) and child.name == 'a' and not child.attribute('href').nil?
              end
              if child_a_tags_with_href.count == 1
                node = child_a_tags_with_href.first
                if format_classes(node).empty?
                  @properties['url'] = [node.attribute('href').value.strip]
                end
              end

              if @properties['url'].nil?

                #else if .h-x>:only-child:not[.h-*]>area[href]:only-of-type:not[.h-*], then use that [href] for url
                child_area_tags_with_href = child_element.children.select do |child|
                  child.is_a?(Nokogiri::XML::Element) and child.name == 'area' and not child.attribute('href').nil?
                end
                if child_area_tags_with_href.count == 1
                  node = child_area_tags_with_href.first
                  if format_classes(node).empty?
                    @properties['url'] = [node.attribute('href').value.strip]
                  end
                end
              end
            end
          end

          unless @properties['url'].nil?
            @properties['url'] = [ Microformats2::AbsoluteUri.new(@base, @properties['url'].first).absolutize ]
          end
        end

      end
      ##### END Implied Properties when not in backcompat mode######

      ### imply date for dt-end if dt-start is defined with a date ###
      if not @properties['end'].nil? and not @properties['start'].nil?
        start_date = nil
        @properties['start'].each do |start_val|
          if start_val =~ /^(\d{4}-[01]\d-[0-3]\d)/
            start_date = $1 if start_date.nil?
          elsif start_val =~ /^(\d{4}-[0-3]\d\d)/
            start_date = $1 if start_date.nil?
          end
        end
        unless start_date.nil?
          @properties['end'].map! do |end_val|
            if end_val=~ /^\d{4}-[01]\d-[0-3]\d/
              end_val
            elsif end_val=~ /^\d{4}-[0-3]\d\d/
              end_val
            else
              start_date + ' ' + end_val
            end
          end
        end
      end

      if @value.nil? or @value.empty?
        if element_type == 'p' and not @properties['name'].nil? and not @properties['name'].empty?
          @value = @properties['name'].first
        elsif element_type == 'u' and not @properties['url'].nil? and not @properties['url'].empty?
          @value = @properties['url'].first
        elsif not element_type.nil?
          @value = PropertyParser.new.parse(element, @base, element_type,  @mode_backcompat)
        end
      end

      h_object = {}

      h_object['value'] = @value unless @value.nil?
      h_object['type'] = fmt_classes
      h_object['properties'] = @properties

      h_object['children'] = @children unless @children.empty?

      if @format_property_type == 'e'
        h_object['value'] = element.text.strip
        h_object['html'] = element.inner_html
      end

      ##todo fall back to p- dt- u- parsing if value still not set?
      #  not sure that is correct by the spec actually

      h_object

    end


    def parse_element(element)

      prop_classes = property_classes(element)
      prop_classes = backcompat_property_classes(element) if @mode_backcompat

      bc_classes_found = false
      fmt_classes = format_classes(element)

      if fmt_classes.empty?
          fmt_classes = backcompat_format_classes(element)
          bc_classes_found = true unless fmt_classes.empty?
      end

      if prop_classes.length >= 1

        if fmt_classes.length >= 1

          prop_classes.each do |element_class|
            element_type = element_class.downcase.split('-')[0]
            property_name = element_class.downcase.split('-')[1..-1].join('-')

            parsed_format = FormatParser.new.parse(element, @base, element_type, fmt_classes, bc_classes_found )

            if @value.nil?
              if @format_property_type == 'p' and property_name == 'name'
                @value = parsed_format['value']
              #elsif @format_property_type == 'dt' and property_name == '???'
                #@value = parsed_format['value']
              elsif @format_property_type == 'u' and property_name == 'url'
                @value = parsed_format['value']
              end
            end

            @properties[property_name] = []  if @properties[property_name].nil?
            @properties[property_name] << parsed_format

          end

        else

          prop_classes.each do |element_class|
            element_type = element_class.downcase.split('-')[0]
            property_name = element_class.downcase.split('-')[1..-1].join('-')

            parsed_property = PropertyParser.new.parse(element, @base, element_type,  @mode_backcompat)

            if not parsed_property.nil? and not parsed_property.empty?
              @properties[property_name] = []  if @properties[property_name].nil?
              @properties[property_name] << parsed_property
            end
          end
          parse_nodeset(element.children)
        end

      elsif fmt_classes.length >= 1
        @children << FormatParser.new.parse(element, @base, nil, fmt_classes, bc_classes_found )
      else
        parse_nodeset(element.children)
      end
    end

  end
end
