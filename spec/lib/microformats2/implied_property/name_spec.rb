require "spec_helper"
require "microformats2"

describe Microformats2::ImpliedProperty::Name do
  describe "spec/support/lib/microformats/implied_property" do
    describe "name-pass.html" do
      html = "spec/support/lib/microformats2/implied_property/name-pass.html"
      collection = Microformats2.parse(html)
      it "should have 6 microformats" do
        collection.all.length.should == 6
      end
      collection.all.each_with_index do |format, index|
        it "implies name to be 'Jessica' in case #{index+1}" do
          format.name.to_s.should == "Jessica"
        end
      end
    end
    describe "name-fail.html" do
      html = "spec/support/lib/microformats2/implied_property/name-fail.html"
      collection = Microformats2.parse(html)
      it "should have 8 microformats" do
        collection.all.length.should == 8
      end
      collection.all.each_with_index do |format, index|
        it "implies name to be '' in case #{index+1}" do
          format.name.to_s.should == ""
        end
      end
    end
  end
end
