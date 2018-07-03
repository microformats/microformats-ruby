describe Microformats::PropertySet do
  let(:parser) { described_class.new }

  describe 'conversion functions' do
    let(:html) { '<div class="h-card"><p class="p-name">Jessica Lynn Suttles</p></div>' }
    let(:set) { Microformats.parse(html).items[0].properties }

    it 'is accessible as a hash []' do
      expect(set['name'][0]).to eq('Jessica Lynn Suttles')
    end

    it 'can convert to hash' do
      expect(set.to_hash['name'][0]).to eq('Jessica Lynn Suttles')
    end

    it 'can convert to hash by to_h' do
      expect(set.to_h['name'][0]).to eq('Jessica Lynn Suttles')
    end

    it 'converts to json' do
      expect(set.to_json).to eq('{"name":["Jessica Lynn Suttles"]}')
    end

    it 'converts to string' do
      expect(set.to_s).to eq(set.to_h.to_s)
    end
  end
end
