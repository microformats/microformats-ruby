describe Microformats do
  let(:html) { '<div class="h-card"><p class="p-name">Jessica Lynn Suttles</p></div>' }

  describe '::parse' do
    it 'returns Collection' do
      expect(described_class.parse(html)).to be_kind_of(Microformats::Collection)
    end
  end

  describe '::read_html' do
    it 'can be a string of html' do
      expect(described_class.read_html(html)).to include(html)
    end

    it 'can be a file path to html' do
      html = 'spec/support/lib/microformats/simple.html'

      expect(described_class.read_html(html)).to include('<div class="h-card">')
    end

    it 'can be a url to html' do
      stub_request(:get, 'http://google.com/')
        .with(headers: { 'Accept': '*/*', 'User-Agent': 'Ruby' })
        .to_return(status: 200, body: 'google', headers: {})

      html = 'http://google.com'

      expect(described_class.read_html(html)).to include('google')
    end
  end
end
