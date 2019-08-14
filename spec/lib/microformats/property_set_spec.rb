describe Microformats::PropertySet do
  let(:html) { '<div class="h-card"><p class="p-name">Jessica Lynn Suttles</p></div>' }
  let(:property_set) { Microformats.parse(html).items[0].properties }

  it 'is accessible as a hash []' do
    expect(property_set['name'][0]).to eq('Jessica Lynn Suttles')
  end

  it 'can convert to hash' do
    expect(property_set.to_hash['name'][0]).to eq('Jessica Lynn Suttles')
  end

  it 'can convert to hash by to_h' do
    expect(property_set.to_h['name'][0]).to eq('Jessica Lynn Suttles')
  end

  it 'converts to json' do
    expect(property_set.to_json).to eq('{"name":["Jessica Lynn Suttles"]}')
  end

  it 'converts to string' do
    expect(property_set.to_s).to eq(property_set.to_h.to_s)
  end
end
