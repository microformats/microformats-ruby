require "spec_helper"
require "microformats2"

describe Microformats2::ImpliedProperty::Photo do
  describe "spec/support/lib/microformats/implied_property" do
    describe "photo-pass.html" do
      html = "spec/support/lib/microformats2/implied_property/photo-pass.html"
      collection = Microformats2.parse(html)
      it "should have 6 microformats" do
        collection.all.length.should == 6
      end
      collection.all.each_with_index do |format, index|
        it "implies photo to be 'http://gravatar.com/jlsuttles' in case #{index+1}" do
          format.photo.to_s.should == "http://gravatar.com/jlsuttles"
        end
      end
    end
    describe "photo-fail.html" do
      html = "spec/support/lib/microformats2/implied_property/photo-fail.html"
      collection = Microformats2.parse(html)
      it "should have 8 microformats" do
        collection.all.length.should == 8
      end
      collection.all.each_with_index do |format, index|
        it "implies photo to be '' in case #{index+1}" do
          expect {format.photo}.to raise_error(NoMethodError)
        end
      end
    end
  end
end
