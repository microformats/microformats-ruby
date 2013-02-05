require "spec_helper"
require "microformats2"

describe Microformats2 do
  before do
    @html = <<-HTML.strip
      <div class="h-card"><p class="p-name">Jessica Lynn Suttles</p></div>
    HTML
  end

  describe "::parse" do
    before do
      html = "spec/support/simple.html"
      @microformats2 = Microformats2.parse(@html)
    end
    it "returns an array of found root microformats" do
      @microformats2.first.should be_kind_of HCard
    end
    it "assigns properties to found root microformats" do
      puts @microformats2.first.to_hash
      @microformats2.first.name.should == "Jessica Lynn Suttles"
    end
  end

  describe "::read_html" do
    it "can be a string of html" do
      Microformats2.read_html(@html).should include @html
    end
    it "can be a file path to html" do
      html = "spec/support/simple.html"
      Microformats2.read_html(html).should include @html
    end
    it "can be a url to html" do
      html = "http://google.com"
      Microformats2.read_html(html).should include "google"
    end
  end
end
