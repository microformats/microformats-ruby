require "spec_helper"
require "microformats2"

describe Microformats2::ImpliedProperty::Url do
  describe "spec/support/lib/microformats/implied_property" do
    describe "url-pass.html" do
      html = "spec/support/lib/microformats2/implied_property/url-pass.html"
      collection = Microformats2.parse(html)
      it "should have 2 microformats" do
        collection.all.length.should == 2
      end
      collection.all.each_with_index do |format, index|
        it "implies url to be 'http://github.com/jlsuttles' in case #{index+1}" do
          format.url.to_s.should == "http://github.com/jlsuttles"
        end
      end
    end
    describe "url-fail.html" do
      html = "spec/support/lib/microformats2/implied_property/url-fail.html"
      collection = Microformats2.parse(html)
      it "should have 2 microformats" do
        collection.all.length.should == 2
      end
      collection.all.each_with_index do |format, index|
        it "implies url to be '' in case #{index+1}" do
          expect {format.url.to_s.should == ""}.to raise_error(NoMethodError)
        end
      end
    end
  end
end
