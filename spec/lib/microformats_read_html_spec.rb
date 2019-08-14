describe Microformats, '.read_html' do
  context 'when given a string of HTML' do
    let(:input) { '<div class="h-card"><p class="p-name">Jessica Lynn Suttles</p></div>' }

    it 'returns the HTML' do
      expect(described_class.read_html(input)).to include(input)
    end
  end

  context 'when given a file path' do
    let(:input) { 'spec/support/lib/microformats/simple.html' }

    it 'returns the HTML' do
      expect(described_class.read_html(input)).to include('<div class="h-card">')
    end
  end

  context 'when given a URL' do
    let(:url) { 'https://example.com' }

    before do
      stub_request(:get, url).to_return(status: 200, body: 'example')
    end

    it 'returns the HTML' do
      expect(described_class.read_html(url)).to eq('example')
    end
  end
end
