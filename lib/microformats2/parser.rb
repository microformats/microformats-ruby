module Microformats2

  class Parser < ParserCore
    attr_reader :http_headers, :http_body
    def initialize
      @http_headers = {}
      super
    end

    def parse(html, base=nil, headers={})

      @http_headers = {}

      @items = []
      @rels = {}
      @rel_urls = {}

      @alternates = []

      @base = base

      html = read_html(html, headers)
      document = Nokogiri::HTML(html)

      found_base = parse_base(document)
      @base = found_base unless found_base.nil?
      
        document.traverse do |node|
            if not node.attribute('src').nil?
                absolute_url = Microformats2::AbsoluteUri.new(@base, node.attribute('src').value.to_s).absolutize
                node.attribute('src').value = absolute_url

            elsif not node.attribute('href').nil?
                absolute_url = Microformats2::AbsoluteUri.new(@base, node.attribute('href').value.to_s).absolutize
                node.attribute('href').value = absolute_url
            end
        end
      parse_node(document)
      parse_rels(document)
      
      ParserResult.new({'items' => @items, 'rels' => @rels, 'rel-urls' =>  @rel_urls})
    end

    def read_html(html, headers={})
      open(html, headers) do |response|
        @http_headers = response.meta if response.respond_to?(:meta)
        @http_body = response.read
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
        @items << FormatParser.new.parse(element, @base, nil, joined_classes, true)
      elsif fmt_classes.length >= 1
        @items << FormatParser.new.parse(element, @base, nil, fmt_classes, false)
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
          url = Microformats2::AbsoluteUri.new(@base, rel.attribute('href').text).absolutize

          rel_values = rel.attribute('rel').text.split(' ')
          rel_values.each do |rel_value|
              @rels[rel_value] = [] unless @rels.has_key?(rel_value)
              @rels[rel_value] << Microformats2::AbsoluteUri.new(@base, rel.attribute('href').text).absolutize
              @rels[rel_value].uniq!
          end

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

