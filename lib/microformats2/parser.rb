module Microformats2
  class Parser
    attr_reader :http_headers, :http_body

    def parse(html, headers={})
      html = read_html(html, headers)
      document = Nokogiri::HTML(html)
      Collection.new(document).parse
    end

    def read_html(html, headers={})
      open(html, headers) do |response|
        @http_headers = response.meta if response.respond_to?(:meta)
        @http_body = response.read
      end
      @http_body
    rescue Errno::ENOENT, Errno::ENAMETOOLONG => e
      html
    end
  end
end
