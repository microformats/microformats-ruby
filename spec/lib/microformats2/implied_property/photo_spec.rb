require "spec_helper"
require "microformats2"

describe Microformats2::ImpliedProperty::Photo do
  describe "photo-pass.html" do
    html = "spec/support/lib/microformats2/implied_property/photo-pass.html"
    collection = Microformats2.parse(html)
    it "should have the correct number of formats" do
      collection.all.length.should == 6
    end
    collection.all.each_with_index do |format, index|
      it "passes case #{index+1}" do
        format.photo.first.value.should == "http://gravatar.com/jlsuttles"
      end
    end
  end
  describe "photo-fail.html" do
    html = "spec/support/lib/microformats2/implied_property/photo-fail.html"
    collection = Microformats2.parse(html)
    it "should have the correct number of formats" do
      collection.all.length.should == 8
    end
    collection.all.each_with_index do |format, index|
      it "fails case #{index+1}" do
        format.photo.should be_nil
      end
    end
  end
end
