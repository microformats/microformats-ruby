module Microformats2
  class PropertyParser < ParserCore

      def parse(element, base, element_type)
        @base = base
        @value = nil
        
        if element_type == 'p'
            parse_node(element) #value class pattern

            if @value.nil? 
                if element.name == 'abbr' and not element.attribute('title').nil?
                    @value = element.attribute('title').value.strip
                elsif (element.name == 'data' or element.name == 'input') and not element.attribute('value').nil?
                    @value = element.attribute('value').value.strip
                elsif (element.name == 'img' or element.name == 'area') and not element.attribute('alt').nil?
                    @value = element.attribute('alt').value.strip
                else 
                    @value = element.text.strip
                    #todo this should actually replace any img elements with alt or src properties
                end
            end


        elsif element_type == 'e'
            @value = {
                value: element.text.strip,
                html: element.inner_html.strip
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

                parse_node(element) #value class pattern

                if @value.nil? 
                    if element.name == 'abbr' and not element.attribute('title').nil?
                        @value = element.attribute('title').value.strip
                    elsif (element.name == 'data' or element.name == 'input') and not element.attribute('value').nil?
                        @value = element.attribute('value').value.strip
                    else
                        @value = element.text.strip
                    end
                    
                end
            end

        elsif element_type == 'dt'

            parse_node(element) #value class pattern

            if @value.nil? 

                if ['time', 'ins', 'del'].include? element.name and not element.attribute('datetime').nil?
                    @value = element.attribute('datetime').value.strip
                elsif element.name == 'abbr' and not element.attribute('title').nil?
                    @value = element.attribute('title').value.strip
                elsif (element.name == 'data' or element.name == 'input') and not element.attribute('value').nil?
                    @value = element.attribute('value').value.strip
                else
                    @value = element.text.strip
                end
            end

        end

        @value
      end


      def parse_element(element)
        if property_classes(element).length == 0 and format_classes(element).length == 0
            if value_title_classes(element).length >= 1 
                @value = element.attribute('title').value.strip 

            elsif value_classes(element).length >= 1 
                if element.name == 'img' or element.name == 'area' and not element.attribute('alt').nil?
                    @value = element.attribute('alt').value.strip
                elsif element.name == 'data'
                    if element.attribute('value').nil?
                        @value = element.text.strip 
                    else
                        @value = element.attribute('value').value.strip 
                    end
                elsif element.name == 'abbr'
                    if element.attribute('title').nil?
                        @value = element.text.strip 
                    else
                        @value = element.attribute('title').value.strip 
                    end
                end

            else
                parse_node(element)
            end
        end
        
        #property_classes(element).map do |property_class|
          #property   = Property.new(element, property_class, nil, @base).parse
          #properties = format_classes(element).empty? ? PropertyParser.parse(element.children, @base) : []
#
          #[property].concat properties
        #end
      end


  end
end
