require "spec_helper"
require "microformats2"

describe Microformats2::ImpliedProperty::Url do
  describe "url-pass.html" do
    html = "spec/support/lib/microformats2/implied_property/url-pass.html"
    collection = Microformats2.parse(html)
    it "should have the correct number of formats" do
      collection.all.length.should == 2
    end
    collection.all.each_with_index do |format, index|
      it "passes case #{index+1}" do
        format.url.first.value.should == "http://github.com/jlsuttles"
      end
    end
  end
  describe "url-fail.html" do
    html = "spec/support/lib/microformats2/implied_property/url-fail.html"
    collection = Microformats2.parse(html)
    it "should have the correct number of formats" do
      collection.all.length.should == 2
    end
    collection.all.each_with_index do |format, index|
      it "fails case #{index+1}" do
        format.url.should be_nil
      end
    end
  end
end
