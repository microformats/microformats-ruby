describe Microformats::ParserResult do
  let(:parser) { Microformats::Parser.new }

  describe 'conversion functions' do
    let(:html) { '<div class="h-card"><p class="p-name">Jessica Lynn Suttles</p></div>' }
    let(:item) { parser.parse(html).items[0] }

    it 'is accessible as a hash []' do
      expect(item['properties']['name'][0]).to eq('Jessica Lynn Suttles')
    end

    it 'can convert to hash' do
      expect(item.to_hash['properties']['name'][0]).to eq('Jessica Lynn Suttles')
    end

    it 'can convert to hash by to_h' do
      expect(item.to_h['properties']['name'][0]).to eq('Jessica Lynn Suttles')
    end

    it 'converts to json' do
      expect(item.to_json).to eq('{"type":["h-card"],"properties":{"name":["Jessica Lynn Suttles"]}}')
    end

    it 'converts to string' do
      expect(item.to_s).to eq(item.to_h.to_s)
    end
  end

  describe 'parser result functions' do
    let(:html) { '<div class="h-card"><p class="p-name">Jessica Lynn Suttles</p><a rel="canonical" class="u-url u-like-of" href="https://example.com/">homepage</a></div>' }
    let(:item) { parser.parse(html).items[0] }

    it 'has respond_to? function' do
      expect(item).to respond_to(:respond_to?)
    end

    it 'returns PropertySets' do
      expect(item.properties).to be_kind_of(Microformats::PropertySet)
    end

    it 'supports old parser function calls by property name' do
      expect(item.name).to eq('Jessica Lynn Suttles')
      expect(item.url).to eq('https://example.com/')
      expect(item.like_of).to eq('https://example.com/')
    end
  end
end
