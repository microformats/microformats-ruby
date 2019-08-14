describe Microformats, '.parse' do
  let(:html) { '<div class="h-card"><p class="p-name">Jessica Lynn Suttles</p></div>' }

  it 'returns Collection' do
    expect(described_class.parse(html)).to be_kind_of(Microformats::Collection)
  end
end
