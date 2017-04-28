module Microformats2

  #stub to get around the tests for now
  class ParserResults
    def initialize(hash)
      @hash = hash
    end
    def to_hash
      @hash
    end
    def to_json
      to_hash.to_json
    end
  end

  class Parser < ParserCore
    attr_reader :http_headers, :http_body
    def initialize
      @http_headers = {}
    end

    def parse(html, headers={})

      @http_headers = {}

      @items = []
      @rels = {}
      @rel_urls = {}

      @alternates = []

      @base = nil

      html = read_html(html, headers)
      document = Nokogiri::HTML(html)

      found_base = parse_base(document)
      @base = found_base unless found_base.nil?
      
      parse_node(document)
      parse_rels(document)
      
      ParserResults.new({items: @items, rels: @rels, 'rel-urls': @rel_urls})
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
      if format_classes(element).length >= 1
        @items << FormatParser.new.parse(element, @base)
      else
        parse_nodeset(element.children)
      end
    end

    def parse_base(document)
      base = document.search("base").first
      base.values.first unless base.nil?
    end


    def parse_rels(element)
      element.search("*[@rel]").each do |rel|
        unless rel.attribute("href").nil?
          url = Microformats2::AbsoluteUri.new(@base, rel.attribute("href").text).absolutize

          rel_values = rel.attribute("rel").text.split(" ")
          rel_values.each do |rel_value|
              @rels[rel_value] = [] unless @rels.has_key?(rel_value)
              @rels[rel_value] << Microformats2::AbsoluteUri.new(@base, rel.attribute("href").text).absolutize
              @rels[rel_value].uniq!
          end

          @rel_urls[url] = {rels: rel_values} unless @rel_urls.has_key?(url)

          @rel_urls[url]['hreflang'] = rel.attribute('hreflang').value unless rel.attribute('hreflang').nil?
          @rel_urls[url]['media'] = rel.attribute('media').value unless rel.attribute('media').nil?
          @rel_urls[url]['title'] = rel.attribute('title').value unless rel.attribute('title').nil?
          @rel_urls[url]['type'] = rel.attribute('type').value unless rel.attribute('type').nil?
          @rel_urls[url]['text'] = rel.text.strip unless rel.text.empty?

        end
      end
    end


  end
end

