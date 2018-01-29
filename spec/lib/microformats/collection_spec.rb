describe Microformats::Collection do
  let(:parser) { Microformats::Parser.new }


    describe "collection to hash or string" do
      before do
        @html = '<div class="h-card"><p class="p-name">Jessica Lynn Suttles</p></div>'
        @html.freeze
      end

      it "is accessible as a hash []" do
          expect(Microformats.parse(@html)['items'][0]['properties']['name'][0]).to eq("Jessica Lynn Suttles")
      end
      it "can convert to hash" do
          expect(Microformats.parse(@html).to_hash['items'][0]['properties']['name'][0]).to eq("Jessica Lynn Suttles")
      end
      it "can convert to hash by to_h" do
          expect(Microformats.parse(@html).to_h['items'][0]['properties']['name'][0]).to eq("Jessica Lynn Suttles")
      end
      it "converts to string" do
          expect(Microformats.parse(@html).to_s).to eq("{\"items\"=>[{\"type\"=>[\"h-card\"], \"properties\"=>{\"name\"=>[\"Jessica Lynn Suttles\"]}}], \"rels\"=>{}, \"rel-urls\"=>{}}")
      end
    end

    describe "collection functions" do
      before do
        @html = '<div class="h-card"><p class="p-name">Jessica Lynn Suttles</p><a rel="canonical" class="u-url" href="https://example.com/">homepage</a></div><div class="h-as-sample"><p class="p-name">sample</p></div>'
        @html.freeze
      end

      it "is has rels function" do
          expect(Microformats.parse(@html).rels['canonical'][0]).to eq('https://example.com/')
      end

      it "is has rel_urls function" do
          expect(Microformats.parse(@html).rel_urls['https://example.com/']['rels'][0]).to eq('canonical')
      end

      it "has respond_to? function" do
          expect(Microformats.parse(@html)).to respond_to(:respond_to?)
      end

      it "supports old parser function calls by h- name" do
          expect(Microformats.parse(@html).card.to_hash).to eq(Microformats.parse(@html).items[0].to_hash)
          expect(Microformats.parse(@html).card(:all)[0].to_hash).to eq(Microformats.parse(@html).items[0].to_hash)
          expect(Microformats.parse(@html).card(0).to_hash).to eq(Microformats.parse(@html).items[0].to_hash)
          expect(Microformats.parse(@html).card(3).to_hash).to eq(Microformats.parse(@html).items[0].to_hash)
          expect(Microformats.parse(@html).as_sample.to_hash).to eq(Microformats.parse(@html).items[1].to_hash)
      end

      it "has an items function that returns an array of ParserResult objects" do
          expect(Microformats.parse(@html).items[0]).to be_kind_of Microformats::ParserResult
      end

    end

end
