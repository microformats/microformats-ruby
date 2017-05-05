require "spec_helper"
require "microformats2"

describe Microformats2 do
  before do
    @html = <<-HTML.strip
      <div class="h-card"><p class="p-name">Jessica Lynn Suttles</p></div>
    HTML
  end

  describe "::parse" do
    it "returns ParserResult" do
      expect(Microformats2.parse(@html)).to be_kind_of Microformats2::ParserResult
    end
  end

  describe "::read_html" do
    it "can be a string of html" do
      expect(Microformats2.read_html(@html)).to include @html
    end
    it "can be a file path to html" do
      html = "spec/support/lib/microformats2/simple.html"
      expect(Microformats2.read_html(html)).to include "<div class=\"h-card\">"
    end
    it "can be a url to html" do
      stub_request(:get, "http://google.com/").
               with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
               to_return(:status => 200, :body => "google", :headers => {})
      html = "http://google.com"
      expect(Microformats2.read_html(html)).to include "google"
    end
  end
end
