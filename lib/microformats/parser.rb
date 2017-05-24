module Microformats

  class Parser < ParserCore
    attr_reader :http_headers, :http_body
    def initialize
      @http_headers = {}
      super
    end

    def parse(html, base: nil, headers:{})

      @http_headers = {}

      @items = []
      @rels = {}
      @rel_urls = {}

      @alternates = []

      @base = base

      html = read_html(html, headers: headers)
      document = Nokogiri::HTML(html)

      found_base = parse_base(document)
      @base = found_base unless found_base.nil?

      document.traverse do |node|
        if not node.attribute('src').nil?
          absolute_url = Microformats::AbsoluteUri.new(node.attribute('src').value.to_s, base: @base).absolutize
          node.attribute('src').value = absolute_url.to_s

        elsif not node.attribute('href').nil?
          absolute_url = Microformats::AbsoluteUri.new(node.attribute('href').value.to_s, base: @base).absolutize
          node.attribute('href').value = absolute_url.to_s
        end
      end
      parse_node(document)
      parse_rels(document)

      Collection.new({'items' => @items, 'rels' => @rels, 'rel-urls' =>  @rel_urls})
    end

    def read_html(html, headers:{})
      stripped_html = html.strip
      open(stripped_html, headers) do |response|
        @http_headers = response.meta if response.respond_to?(:meta)
        @http_body = response.read
      end
      if @base.nil?
          @base = stripped_html
      end
      @http_body
    rescue Errno::ENOENT, Errno::ENAMETOOLONG => e
      @http_body = html
    end

    private

    def parse_element(element)

      fmt_classes = format_classes(element)
      bc_fmt_classes = backcompat_format_classes(element).reject do |format_class|
        fmt_classes.include? format_class
      end
      joined_classes =  fmt_classes + bc_fmt_classes

      if bc_fmt_classes.length >= 1
        @items << FormatParser.new.parse(element, base: @base, format_class_array: joined_classes, backcompat: true)
      elsif fmt_classes.length >= 1
        @items << FormatParser.new.parse(element, base: @base, format_class_array: fmt_classes )
      else
        parse_nodeset(element.children)
      end
    end

    def parse_base(document)
      base = document.search('base').first
      base.values.first unless base.nil?
    end

    def parse_rels(element)
      element.search('*[@rel]').each do |rel|
        unless rel.attribute('href').nil?
          url = Microformats::AbsoluteUri.new(rel.attribute('href').text, base: @base).absolutize

          rel_values = rel.attribute('rel').text.split(' ')
          rel_values.each do |rel_value|
            @rels[rel_value] = [] unless @rels.has_key?(rel_value)
            @rels[rel_value] << Microformats::AbsoluteUri.new(rel.attribute('href').text, base: @base).absolutize
            @rels[rel_value].uniq!
          end

          unless rel_values.empty? 
              @rel_urls[url] = {} unless @rel_urls.has_key?(url)

              @rel_urls[url]['hreflang'] = rel.attribute('hreflang').value if @rel_urls[url]['hreflang'].nil? and not rel.attribute('hreflang').nil?
              @rel_urls[url]['media'] = rel.attribute('media').value if @rel_urls[url]['media'].nil? and not rel.attribute('media').nil?
              @rel_urls[url]['title'] = rel.attribute('title').value if @rel_urls[url]['title'].nil? and not rel.attribute('title').nil?
              @rel_urls[url]['type'] = rel.attribute('type').value if @rel_urls[url]['type'].nil? and not rel.attribute('type').nil?
              @rel_urls[url]['text'] = rel.text.strip if  @rel_urls[url]['text'].nil? and not rel.text.empty?
              @rel_urls[url]['rels'] = rel_values
          end

        end
      end
    end

  end
end

