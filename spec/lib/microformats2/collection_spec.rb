require "spec_helper"
require "microformats2"

describe Microformats2::Collection do
  before do
    @html = <<-HTML.strip
      <div class="h-card"><p class="p-name">Jessica Lynn Suttles</p></div>
    HTML
    @collection = Microformats2::Collection.new.parse(Nokogiri::HTML(@html))
  end

  describe "#to_hash" do
    it "returns the correct Hash" do
      hash = {items: [
        {type: ["h-card"], properties: {name: "Jessica Lynn Suttles"}}
      ]}
      @collection.to_hash.should == hash
    end
  end

  describe "#to_json" do
    it "returns the correct JSON" do
      json = {items: [
        {type: ["h-card"], properties: {name: "Jessica Lynn Suttles"}}
      ]}.to_json
      @collection.to_json.should == json
    end
  end
end
