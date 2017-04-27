module Microformats2
  class FormatParser < ParserCore

      def parse(element, base=nil, element_type=nil, backcompat=false)
        @base = base

        @properties = {}
        @children = []

        @format_property_type = element_type
        @value = nil

        @mode_backcompat = backcompat

        parse_node(element.children)

        h_object = {type: format_classes(element), properties: @properties}

        h_object['children'] = @children unless @children.empty?


        ##### Implied Properties######
        #NOTE: much of this code may be simplified by using element.css, not sure yet, but coding to have passing tests first
        # can optimize this later
        unless @mode_backcompat
          if @properties['name'].nil?

            if element.name == "img" and not element.attribute("alt").nil?
              @properties['name'] = [element.attribute("alt").value.strip]
            elsif element.name == "area" and not element.attribute("alt").nil?
              @properties['name'] = [element.attribute("alt").value.strip]

            elsif element.children.count == 1 and element.children.first.is_a?(Nokogiri::XML::Element)
                node = element.children.first

                #else if .h-x>img:only-child[alt]:not([alt=""]):not[.h-*] then use that img’s alt for name
                if node.name == 'img' and not node.attribute('alt').nil? and not node.attribute('alt').value.empty? and format_classes(node) == 0
                    @properties['name'] = [node.attribute("alt").value.strip]
                
                #else if .h-x>area:only-child[alt]:not([alt=""]):not[.h-*] then use that area’s alt for name
                elsif node.name == 'area' and not node.attribute('alt').nil? and not node.attribute('alt').value.empty? and format_classes(node) == 0
                    @properties['name'] = [node.attribute("alt").value.strip]
                
                #else if .h-x>abbr:only-child[title]:not([title=""]):not[.h-*] then use that abbr title for name
                elsif node.name == 'abbr' and not node.attribute('title').nil? and not node.attribute('title').value.empty? and format_classes(node) == 0
                    @properties['name'] = [node.attribute("title").value.strip]
                
                elsif node.children.count == 1 and element.children.first.is_a?(Nokogiri::XML::Element)
                    node = node.children.first

                    #else if .h-x>:only-child:not[.h-*]>img:only-child[alt]:not([alt=""]):not[.h-*] then use that img’s alt for name
                    if node.name == 'img' and not node.attribute('alt').nil? and not node.attribute('alt').value.empty? and format_classes(node) == 0
                        @properties['name'] = [node.attribute("alt").value.strip]
                    
                    #else if .h-x>:only-child:not[.h-*]>area:only-child[alt]:not([alt=""]):not[.h-*] then use that area’s alt for name
                    elsif node.name == 'area' and not node.attribute('alt').nil? and not node.attribute('alt').value.empty? and format_classes(node) == 0
                        @properties['name'] = [node.attribute("alt").value.strip]
                    
                    #else if .h-x>:only-child:not[.h-*]>abbr:only-child[title]:not([title=""]):not[.h-*] use that abbr’s title for name 
                    elsif node.name == 'abbr' and not node.attribute('title').nil? and not node.attribute('title').value.empty? and format_classes(node) == 0
                        @properties['name'] = [node.attribute("title").value.strip]
                    end
                end
            else
                @properties['name'] = [element.text.strip]
            end
          end # end implied name


          if @properties['photo'].nil?
            if element.name == "img" and not element.attribute("src").nil?
                @properties['photo'] = [element.attribute("src").value]
            elsif element.name == "object" and not element.attribute("data").nil?
                @properties['photo'] = [element.attribute("data").value]
            else 
                
                #else if .h-x>img[src]:only-of-type:not[.h-*] then use that img src for photo
                #
                child_img_tags_with_src = element.children.select do |child|
                    child.is_a?(Nokogiri::XML::Element) and child.name == 'img' and not child.attribute('src').nil?
                end
                if child_img_tags_with_src.count == 1
                    node = child_img_tags_with_src.first
                    if format_classes(node).empty?
                        @properties['photo'] = [node.attribute("src").value.strip]
                    end
                end

                if @properties['photo'].nil?

                    #else if .h-x>object[data]:only-of-type:not[.h-*] then use that object’s data for photo
                    #
                    child_object_tags_with_data = element.children.select do |child|
                        child.is_a?(Nokogiri::XML::Element) and child.name == 'object' and not child.attribute('data').nil?
                    end
                    if child_object_tags_with_data.count == 1
                        node = child_object_tags_with_data.first
                        if format_classes(node).empty?
                            @properties['photo'] = [node.attribute("data").value.strip]
                        end
                    end
                end

                if @properties['photo'].nil? and element.children.count == 1 and format_classes(element.children.first) == 0 
                    child_element = element.children.first

                    #else if .h-x>:only-child:not[.h-*]>img[src]:only-of-type:not[.h-*], then use that img’s src for photo
                    #
                    child_img_tags_with_src = child_element.children.select do |child|
                        child.is_a?(Nokogiri::XML::Element) and child.name == 'img' and not child.attribute('src').nil?
                    end
                    if child_img_tags_with_src.count == 1
                        node = child_img_tags_with_src.first
                        if format_classes(node).empty?
                            @properties['photo'] = [node.attribute("src").value.strip]
                        end
                    end

                    if @properties['photo'].nil?

                        #else if .h-x>:only-child:not[.h-*]>object[data]:only-of-type:not[.h-*], then use that object’s data for photo 
                        #
                        child_object_tags_with_data = child_element.children.select do |child|
                            child.is_a?(Nokogiri::XML::Element) and child.name == 'object' and not child.attribute('data').nil?
                        end
                        if child_object_tags_with_data.count == 1
                            node = child_object_tags_with_data.first
                            if format_classes(node).empty?
                                @properties['photo'] = [node.attribute("data").value.strip]
                            end
                        end
                    end
                end
                
            end
            unless @properties['photo'].nil?
              @properties['photo'] = [ Microformats2::AbsoluteUri.new(@base, @properties['photo'].first).absolutize ]
            end
          end

          #TODO relative urls
          if @properties['url'].nil?
            if element.name == "a" and not element.attribute("href").nil?
              @properties['url'] = [element.attribute("href").value]
            elsif element.name == "area" and not element.attribute("href").nil?
              @properties['url'] = [element.attribute("href").value]
            else 
                #else if .h-x>a[href]:only-of-type:not[.h-*], then use that [href] for url
                child_a_tags_with_href = element.children.select do |child|
                    child.is_a?(Nokogiri::XML::Element) and child.name == 'a' and not child.attribute('href').nil?
                end
                if child_a_tags_with_href.count == 1
                    node = child_a_tags_with_href.first
                    if format_classes(node).empty?
                        @properties['url'] = [node.attribute("href").value.strip]
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
                            @properties['url'] = [node.attribute("href").value.strip]
                        end
                    end
                end

                if @properties['url'].nil? and element.children.count == 1 and format_classes(element.children.first) == 0 
                    child_element = element.children.first

                    #else if .h-x>:only-child:not[.h-*]>a[href]:only-of-type:not[.h-*], then use that [href] for url
                    child_a_tags_with_href = child_element.children.select do |child|
                        child.is_a?(Nokogiri::XML::Element) and child.name == 'a' and not child.attribute('href').nil?
                    end
                    if child_a_tags_with_href.count == 1
                        node = child_a_tags_with_href.first
                        if format_classes(node).empty?
                            @properties['url'] = [node.attribute("href").value.strip]
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
                                @properties['url'] = [node.attribute("href").value.strip]
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
        ##### END Implied Properties######


        h_object['value'] = @value unless @value.nil?

        if @format_property_type == 'e'
            h_object['value'] = element.text.strip
            h_object['html'] = element.inner_html.strip
        end

        ##todo fall back to p- dt- u- parsing if value still not set

        h_object

      end


      def parse_element(element)
        if property_classes(element).length >= 1 and format_classes(element).length >= 1

          property_classes(element).each do |element_class|
              element_type = element_class.downcase.split("-")[0]
              property_name = element_class.downcase.split("-")[1..-1].join("-")

              parsed_format = FormatParser.new.parse(element, @base, element_type ) 

              if @value.nil?
                  if @format_property_type == 'p' and property_name == 'name'
                    @value = parsed_format[:value]
                  #elsif @format_property_type == 'dt' and property_name == '???'
                    #@value = parsed_format[:value]
                  elsif @format_property_type == 'u' and property_name == 'url'
                    @value = parsed_format[:value]
                  end
              end

              @properties[property_name] = []  if @properties[property_name].nil?
              @properties[property_name] << parsed_format

          end

        elsif property_classes(element).length >= 1
          #what to do if there is more than one property class?
          
          property_classes(element).each do |element_class|
              element_type = element_class.downcase.split("-")[0]
              property_name = element_class.downcase.split("-")[1..-1].join("-")

              parsed_property = PropertyParser.new.parse(element, @base, element_type) 

              if @value.nil?
                  if @format_property_type == 'p' and property_name == 'name'
                    @value = parsed_property
                  #elsif @format_property_type == 'dt' and property_name == '???'
                    #@value = parsed_property
                  elsif @format_property_type == 'u' and property_name == 'url'
                    @value = parsed_property
                  end
              end
              
              @properties[property_name] = []  if @properties[property_name].nil?
              @properties[property_name] << parsed_property
              parse_nodeset(element.children)

          end

        elsif format_classes(element).length >= 1
          @children << FormatParser.new.parse(element, @base)
        else
          parse_nodeset(element.children)
        end
      end


  end
end
