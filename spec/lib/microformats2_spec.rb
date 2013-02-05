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
      @microformats2 = Microformats2.parse(@html)
    end
    it "returns a collection" do
      @microformats2.should be_kind_of Microformats2::Collection
    end
    it "assigns root formats to collection" do
      @microformats2.h_card.should be_kind_of HCard
    end
    it "assigns properties to found root microformats" do
      @microformats2.h_card.name.should == "Jessica Lynn Suttles"
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
