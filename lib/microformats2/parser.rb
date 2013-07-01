module Microformats2
  class Parser
    def parse(html)
      html = read_html(html)
      document = Nokogiri::HTML(html)
      Collection.new(document).parse
    end

    def read_html(html)
      open(html).read
    rescue Errno::ENOENT, Errno::ENAMETOOLONG => e
      html
    end
  end
end
