require "spec_helper"
require "microformats2"

describe Microformats2::ImpliedProperty::Name do
  describe "name-pass.html" do
    html = "spec/support/lib/microformats2/implied_property/name-pass.html"
    collection = Microformats2.parse(html)
    it "should have the correct number of formats" do
      collection.all.length.should == 6
    end
    collection.all.each_with_index do |format, index|
      it "passes case #{index+1}" do
        format.name.first.value.should == "Jessica"
      end
    end
  end
  describe "name-fail.html" do
    html = "spec/support/lib/microformats2/implied_property/name-fail.html"
    collection = Microformats2.parse(html)
    it "should have the correct number of formats" do
      collection.all.length.should == 8
    end
    collection.all.each_with_index do |format, index|
      it "fails case #{index+1}" do
        format.name.first.value.should == ""
      end
    end
  end
end
