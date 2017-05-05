module Microformats2
  class ParserCore

    VALUE_CLASS_REG_EXP = /^value$/
    VALUE_TITLE_CLASS_REG_EXP = /^value-title$/
    FORMAT_CLASS_REG_EXP = /^h-[a-z-]+$/
    PROPERTY_CLASS_REG_EXP = /^(p-|u-|dt-|e-)[a-z-]+$/


    def initialize
        @mode_backcompat = false
        @fmt_classes = []
    end

    private

    def parse_node(node)
      if node.is_a?(Nokogiri::HTML::Document) then 
        parse_node(node.children)
      elsif node.is_a?(Nokogiri::XML::NodeSet) then
        parse_nodeset(node)
      elsif node.is_a?(Nokogiri::XML::Element) then
        parse_element(node)
      else
        nil
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

    def render_html(node, base)
        new_doc = Nokogiri::HTML(node.inner_html)
        new_doc.traverse do |node|
            if not node.attribute('src').nil?
                absolute_url = Microformats2::AbsoluteUri.new(@base, node.attribute('src').value.to_s).absolutize
                node.attribute('src').value = absolute_url

            elsif not node.attribute('href').nil?
                absolute_url = Microformats2::AbsoluteUri.new(@base, node.attribute('href').value.to_s).absolutize
                node.attribute('href').value = absolute_url
            end
        end
        new_doc.children[1].inner_html.gsub(/\A +/, '').gsub(/ +\Z/, '')
    end

    def render_text(node, base)
        new_doc = Nokogiri::HTML(node.inner_html)
        new_doc.xpath('//script').remove
        new_doc.xpath('//style').remove
        new_doc.text.strip
    end


    def parse_nodeset(nodeset)
        nodeset.each do |node|
          parse_node(node)
        end
    end

    def format_classes(element)
      result_set = []
      element.attribute('class').to_s.split.each do |html_class|
        case html_class
        when FORMAT_CLASS_REG_EXP
            result_set << html_class
        end
      end
      #element.attribute('class').to_s.split.select do |html_class|
        #html_class =~ FORMAT_CLASS_REG_EXP
      #end
      result_set
    end

    def backcompat_format_classes(element)
      result_set = []
      html_classes = element.attribute('class').to_s.split
      html_classes.each do |html_class|
        case html_class

        when  /^adr$/
            result_set << 'h-adr'
        when  /^geo$/
            result_set << 'h-geo'
        when  /^h[eE]ntry$/
            result_set << 'h-entry'
        when  /^h[pP]roduct$/
            result_set << 'h-product'
        when  /^h[rR]ecipe$/
            result_set << 'h-recipe'
        when  /^h[rR]esume$/
            result_set << 'h-resume'
        when  /^h[rR]eview$/
            result_set << 'h-review'
        when  /^h[rR]eview-aggregate$/
            result_set << 'h-review-aggregate'
        when  /^[vh][eE]vent$/
            result_set << 'h-event'
        when  /^[vh][cC]ard$/
            result_set << 'h-card'

            #these aren't actually specified by the backcompat faq, but probably should parse them
        when  /^h[fF]eed$/
            result_set << 'h-feed'
        when  /^h[nN]ews$/
            result_set << 'h-news'


        else
          if @fmt_classes.include? 'h-entry' and html_class == 'author'
            result_set << 'h-card'
          end
          if @fmt_classes.include? 'h-product' and html_class == 'review'
            result_set << 'h-review'
          end
          if @fmt_classes.include? 'h-recipe' and html_class == 'author'
            result_set << 'h-card'
          end
          if @fmt_classes.include? 'h-resume' and html_class == 'contact'
            result_set << 'h-card'
          end
          if @fmt_classes.include? 'h-resume' and html_class == 'education'
            result_set << 'h-event'
          end
          if @fmt_classes.include? 'h-resume' and html_class == 'experience'
            result_set << 'h-event'
          end
          if @fmt_classes.include? 'h-resume' and html_class == 'affiliation'
            result_set << 'h-card'
          end
          if @fmt_classes.include? 'h-review' and html_class == 'reviewer'
            result_set << 'h-card'
          end
          if @fmt_classes.include? 'h-review' and html_class == 'item'
              if not html_classes.include? 'vcard' and not html_classes.include? 'vevent' and not html_classes.include? 'hproduct'
                result_set << 'h-item'
              end
          end
          if @fmt_classes.include? 'h-review-aggregate' and html_class == 'item'
              if not html_classes.include? 'vcard' and not html_classes.include? 'vevent' and not html_classes.include? 'hproduct'
                result_set << 'h-item'
              end
          end
          if @fmt_classes.include? 'h-review-aggregate' and html_class == 'reviewer'
            result_set << 'h-card'
          end
          if @fmt_classes.include? 'h-entry' and html_class == 'location'
            result_set << 'h-adr'
            result_set << 'h-card'
          end
          if @fmt_classes.include? 'h-feed' and html_class == 'author'
            result_set << 'h-card'
          end
        end


      end
      result_set.uniq
    end

    def property_classes(element)
      element.attribute('class').to_s.split.select do |html_class|
        html_class =~ PROPERTY_CLASS_REG_EXP
      end
    end

    def backcompat_property_classes(element)
      result_set = []
      rels = element.attribute('rel').to_s.split

      if @fmt_classes.include? 'h-entry' and rels.include? 'bookmark'
        result_set << 'u-url'
      end
      if @fmt_classes.include? 'h-entry' and rels.include? 'tag'
        result_set << 'p-category'
      end
      if @fmt_classes.include? 'h-recipe' and rels.include? 'tag'
        result_set << 'p-category'
      end
      if @fmt_classes.include? 'h-review' and rels.include? 'tag'
        result_set << 'p-category'
      end
      if @fmt_classes.include? 'h-feed' and rels.include? 'tag'
        result_set << 'p-category'
      end
      if @fmt_classes.include? 'h-review' and rels.include? 'self' and rels.include? 'bookmark'
        result_set << 'u-url'
      end
            #TODO PROPOSED convert time.entry-date[datetime] to dt-published  see wiki/h-entry
            #TODO PROPOSED convert rel=author to u-author  see wiki/h-entry


      element.attribute('class').to_s.split.each do |html_class|

          if @fmt_classes.include? 'h-adr'
            if [
                    'post-office-box',
                    'extended-address',
                    'street-address',
                    'locality',
                    'region',
                    'postal-code',
                    'country-name'
            ].include? html_class
                result_set << 'p-' + html_class

            end
          end

          if @fmt_classes.include? 'h-geo'
            if [ 'longitude', 'latitude' ].include? html_class
                result_set << 'p-' + html_class

            end
          end

          if @fmt_classes.include? 'h-entry'
            if html_class ==  'entry-title'
                result_set << 'p-name'

            elsif html_class ==  'entry-summary'
                result_set << 'p-summary'

            elsif html_class ==  'entry-content'
                result_set << 'e-content'

            elsif ['updated', 'published'].include? html_class
                result_set << 'dt-' + html_class

            elsif [ 'category', 'author' ].include? html_class
                result_set << 'p-' + html_class

            end

          end

          if @fmt_classes.include? 'h-news'
            if [ 'source-org', 'entry', 'dateline', 'geo' ].include? html_class
                result_set << 'p-' + html_class
            end
          end

          if @fmt_classes.include? 'h-feed'
            if html_class ==  'fn'
                result_set << 'p-name'
            elsif [ 'author', 'summary' ].include? html_class
                result_set << 'p-' + html_class
            elsif ['photo', 'url'].include? html_class
                result_set << 'u-' + html_class
            end
          end

          if @fmt_classes.include? 'h-item'
            if html_class ==  'fn'
                result_set << 'p-name'
            elsif ['photo', 'url'].include? html_class
                result_set << 'u-' + html_class
            end
          end
          if @fmt_classes.include? 'h-product'
            if html_class ==  'fn'
                result_set << 'p-name'
            elsif ['photo', 'url', 'identifier'].include? html_class
                result_set << 'u-' + html_class
            elsif [ 'brand', 'category', 'price', 'review', 'description' ].include? html_class
                result_set << 'p-' + html_class
            end
          end

          if @fmt_classes.include? 'h-recipe'
            if html_class ==  'fn'
                result_set << 'p-name'
            elsif html_class ==  'instructions'
                result_set << 'e-instructions'
            elsif html_class ==  'duration'
                result_set << 'dt-duration'
            elsif html_class ==  'photo'
                result_set << 'u-photo'
            elsif [ 'ingredient', 'category', 'yield', 'summary', 'nutrition', 'author' ].include? html_class
                result_set << 'p-' + html_class

            end
          end

          if @fmt_classes.include? 'h-resume'
            if [ 'skill', 'summary', 'contact', 'education', 'experience', 'affiliation' ].include? html_class
                result_set << 'p-' + html_class

            end
          end

          if @fmt_classes.include? 'h-review'
            if html_class ==  'summary'
                result_set << 'p-name'
            elsif html_class ==  'fn'
                result_set << 'p-name'
            elsif html_class ==  'reviewer'
                result_set << 'p-author'
            elsif html_class ==  'dtreviewed'
                result_set << 'dt-published'
            elsif html_class ==  'description'
                result_set << 'e-content'
            elsif ['photo', 'url', 'identifier'].include? html_class
                result_set << 'u-' + html_class
            elsif [ 'rating', 'best', 'worst', 'item'].include? html_class
                result_set << 'p-' + html_class
            end
          end

          if @fmt_classes.include? 'h-review-aggregate'
            if html_class ==  'summary'
                result_set << 'p-name'
            elsif html_class ==  'fn'
                result_set << 'p-name'
            elsif html_class ==  'reviewer'
                result_set << 'p-author'
            elsif html_class ==  'dtreviewed'
                result_set << 'dt-published'
            elsif html_class ==  'description'
                result_set << 'e-content'
            elsif ['photo', 'url', 'identifier'].include? html_class
                result_set << 'u-' + html_class
            elsif [ 'rating', 'best', 'worst', 'item', 'count', 'votes', 'average' ].include? html_class
                result_set << 'p-' + html_class
            end
          end

          if @fmt_classes.include? 'h-event'
            if html_class ==  'summary'
                result_set << 'p-name'
            elsif html_class ==  'dtstart'
                result_set << 'dt-start'
            elsif html_class ==  'dtend'
                result_set << 'dt-end'
            elsif html_class ==  'duration'
                result_set << 'dt-duration'
            elsif html_class ==  'geo'
                result_set << 'p-location'
            elsif ['url'].include? html_class
                result_set << 'u-' + html_class
            elsif [ 'description', 'category', 'location', 'attendee'].include? html_class
                result_set << 'p-' + html_class
            end
          end

          if @fmt_classes.include? 'h-card'
            if html_class ==  'fn'
                result_set << 'p-name'
            elsif html_class ==  'bday'
                result_set << 'dt-bday'
            elsif html_class ==  'title'
                result_set << 'p-job-title'
            elsif html_class ==  'rev'
                result_set << 'dt-rev'

            elsif ['email', 'logo', 'photo', 'url', 'uid', 'key'].include? html_class
                result_set << 'u-' + html_class
            elsif [ 'honorific-prefix', 'given-name', 'additional-name', 'family-name', 'honorific-suffix', 'nickname',
                    'category', 'adr', 'extended-address', 'street-address', 'locality', 'region', 'postal-code', 'country-name',
                    'label', 'geo', 'latitude', 'longitude', 'tel', 'note', 'org', 'organization-name', 'organization-unit', 'role', 'tz' ].include? html_class
                result_set << 'p-' + html_class
            end
          end

      end
      result_set.uniq
    end

    def value_classes(element)
      element.attribute('class').to_s.split.select do |html_class|
        html_class =~ VALUE_CLASS_REG_EXP
      end
    end
    def value_title_classes(element)
      element.attribute('class').to_s.split.select do |html_class|
        html_class =~ VALUE_TITLE_CLASS_REG_EXP
      end
    end

  end

end

