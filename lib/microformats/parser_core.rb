module Microformats
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
      if node.is_a?(Nokogiri::HTML::Document)
        parse_node(node.children)
      elsif node.is_a?(Nokogiri::XML::NodeSet)
        parse_nodeset(node)
      elsif node.is_a?(Nokogiri::XML::Element)
        parse_element(node)
      end
    end

    def parse_nodeset(nodeset)
      nodeset.each do |node|
        parse_node(node)
      end
    end

    def format_classes(element)
      element.attribute('class').to_s.split.select do |html_class|
        html_class =~ FORMAT_CLASS_REG_EXP
      end
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

        # these aren't actually specified by the backcompat faq, but probably should parse them
        when  /^h[fF]eed$/
          result_set << 'h-feed'
        when  /^h[nN]ews$/
          result_set << 'h-news'
        else
          if @fmt_classes.include?('h-entry') && html_class == 'author'
            result_set << 'h-card'
          end

          if @fmt_classes.include?('h-product') && html_class == 'review'
            result_set << 'h-review'
          end

          if @fmt_classes.include?('h-recipe') && html_class == 'author'
            result_set << 'h-card'
          end

          if @fmt_classes.include?('h-resume') && html_class == 'contact'
            result_set << 'h-card'
          end

          if @fmt_classes.include?('h-resume') && html_class == 'education'
            result_set << 'h-event'
          end

          if @fmt_classes.include?('h-resume') && html_class == 'experience'
            result_set << 'h-event'
          end

          if @fmt_classes.include?('h-resume') && html_class == 'affiliation'
            result_set << 'h-card'
          end

          if @fmt_classes.include?('h-review') && html_class == 'reviewer'
            result_set << 'h-card'
          end

          if @fmt_classes.include?('h-review') && html_class == 'item'
            if !html_classes.include?('vcard') && !html_classes.include?('vevent') && !html_classes.include?('hproduct')
              result_set << 'h-item'
            end
          end

          if @fmt_classes.include?('h-review-aggregate') && html_class == 'item'
            if !html_classes.include?('vcard') && !html_classes.include?('vevent') && !html_classes.include?('hproduct')
              result_set << 'h-item'
            end
          end

          if @fmt_classes.include?('h-review-aggregate') && html_class == 'reviewer'
            result_set << 'h-card'
          end

          if @fmt_classes.include?('h-entry') && html_class == 'location'
            result_set << 'h-adr'
            result_set << 'h-card'
          end

          if @fmt_classes.include?('h-feed') && html_class == 'author'
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

      if @fmt_classes.include?('h-entry') && rels.include?('bookmark')
        result_set << 'u-url'
      end

      if @fmt_classes.include?('h-entry') && rels.include?('tag')
        result_set << 'p-category'
      end

      if @fmt_classes.include?('h-recipe') && rels.include?('tag')
        result_set << 'p-category'
      end

      if @fmt_classes.include?('h-review') && rels.include?('tag')
        result_set << 'p-category'
      end

      if @fmt_classes.include?('h-feed') && rels.include?('tag')
        result_set << 'p-category'
      end

      if @fmt_classes.include?('h-review') && rels.include?('self') && rels.include?('bookmark')
        result_set << 'u-url'
      end

      if @fmt_classes.include?('h-news') && rels.include?('principles')
        result_set << 'u-principles'
      end

      # TODO: PROPOSED convert time.entry-date[datetime] to dt-published  see wiki/h-entry
      # TODO: PROPOSED convert rel=author to u-author  see wiki/h-entry

      element.attribute('class').to_s.split.each do |html_class|
        if @fmt_classes.include?('h-adr')
          if %w[post-office-box extended-address street-address locality region postal-code country-name].include?(html_class)
            result_set << 'p-' + html_class
          end
        end

        if @fmt_classes.include?('h-geo')
          if %w[longitude latitude].include?(html_class)
            result_set << 'p-' + html_class
          end
        end

        if @fmt_classes.include?('h-entry')
          if html_class == 'entry-title'
            result_set << 'p-name'
          elsif html_class == 'entry-summary'
            result_set << 'p-summary'
          elsif html_class == 'entry-content'
            result_set << 'e-content'
          elsif %w[updated published].include?(html_class)
            result_set << 'dt-' + html_class
          elsif %w[category author].include?(html_class)
            result_set << 'p-' + html_class
          end
        end

        # h-news isn't even listed in backcompat list, adding to follow test suite
        if @fmt_classes.include?('h-news')
          if %w[source-org entry dateline geo].include?(html_class)
            result_set << 'p-' + html_class
          end
        end

        if @fmt_classes.include?('h-feed')
          if html_class == 'fn'
            result_set << 'p-name'
          elsif %w[author summary].include?(html_class)
            result_set << 'p-' + html_class
          elsif %w[photo url].include?(html_class)
            result_set << 'u-' + html_class
          end
        end

        if @fmt_classes.include?('h-item')
          if html_class == 'fn'
            result_set << 'p-name'
          elsif %w[photo url].include?(html_class)
            result_set << 'u-' + html_class
          end
        end

        if @fmt_classes.include?('h-product')
          if html_class == 'fn'
            result_set << 'p-name'
          elsif %w[photo url identifier].include?(html_class)
            result_set << 'u-' + html_class
          elsif %w[brand category price review description].include?(html_class)
            result_set << 'p-' + html_class
          end
        end

        if @fmt_classes.include?('h-recipe')
          if html_class == 'fn'
            result_set << 'p-name'
          elsif html_class == 'instructions'
            result_set << 'e-instructions'
          elsif html_class == 'duration'
            result_set << 'dt-duration'
          elsif html_class == 'photo'
            result_set << 'u-photo'
          elsif %w[ingredient category yield summary nutrition author].include?(html_class)
            result_set << 'p-' + html_class
          end
        end

        if @fmt_classes.include?('h-resume')
          if %w[skill summary contact education experience affiliation].include?(html_class)
            result_set << 'p-' + html_class
          end
        end

        if @fmt_classes.include?('h-review')
          if html_class == 'summary'
            result_set << 'p-name'
          elsif html_class == 'fn'
            result_set << 'p-name'
          elsif html_class == 'reviewer'
            result_set << 'p-author'
          elsif html_class == 'dtreviewed'
            result_set << 'dt-published'
          elsif html_class == 'description'
            result_set << 'e-content'
          elsif %w[photo url identifier].include?(html_class)
            result_set << 'u-' + html_class
          elsif %w[rating best worst item].include?(html_class)
            result_set << 'p-' + html_class
          end
        end

        if @fmt_classes.include?('h-review-aggregate')
          if html_class == 'summary'
            result_set << 'p-name'
          elsif html_class == 'fn'
            result_set << 'p-name'
          elsif html_class == 'reviewer'
            result_set << 'p-author'
          elsif html_class == 'dtreviewed'
            result_set << 'dt-published'
          elsif html_class == 'description'
            result_set << 'e-content'
          elsif %w[photo url identifier].include?(html_class)
            result_set << 'u-' + html_class
          elsif %w[rating best worst item count votes average].include?(html_class)
            result_set << 'p-' + html_class
          end
        end

        if @fmt_classes.include?('h-event')
          if html_class == 'summary'
            result_set << 'p-name'
          elsif html_class == 'dtstart'
            result_set << 'dt-start'
          elsif html_class == 'dtend'
            result_set << 'dt-end'
          elsif html_class == 'duration'
            result_set << 'dt-duration'
          elsif html_class == 'geo'
            result_set << 'p-location'
          elsif %w[url].include?(html_class)
            result_set << 'u-' + html_class
          elsif %w[description category location attendee].include?(html_class)
            result_set << 'p-' + html_class
          end
        end

        if @fmt_classes.include?('h-card')
          if html_class == 'fn'
            result_set << 'p-name'
          elsif html_class == 'bday'
            result_set << 'dt-bday'
          elsif html_class == 'title'
            result_set << 'p-job-title'
          elsif html_class == 'rev'
            result_set << 'dt-rev'
          elsif %w[email logo photo url uid key].include?(html_class)
            result_set << 'u-' + html_class
          elsif %w[honorific-prefix given-name additional-name family-name honorific-suffix nickname
                   category adr extended-address street-address locality region postal-code country-name
                   label geo latitude longitude tel note org organization-name organization-unit role tz].include?(html_class)
            result_set << 'p-' + html_class

          # these aren't listed in the wiki, may be removed
          elsif %w[sound].include?(html_class)
            result_set << 'u-' + html_class
          # these aren't listed in the wiki, may be removed
          elsif %w[agent mailer sort-string class].include?(html_class)
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

    def render_and_strip(data)
      new_doc = Nokogiri::HTML(data)
      new_doc.xpath('//script|//style').remove
      new_doc.text.strip
    end

    def render_text(in_node, base: nil)
      doc = Nokogiri::HTML(in_node.inner_html)

      doc.xpath('//script|//style').remove

      # cannot use doc.css('img').each as it makes a copy of them, it does not modify the original
      doc.traverse do |node|
        next unless node.name == 'img'

        if !node.attribute('alt').nil?
          node.replace(node.attribute('alt').value.to_s)
        elsif !node.attribute('src').nil?
          node.replace(Microformats::AbsoluteUri.new(node.attribute('src').value.to_s, base: @base).absolutize)
        end
      end

      doc.text.strip
    end
  end
end
