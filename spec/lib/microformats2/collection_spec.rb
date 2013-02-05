require "spec_helper"
require "microformats2"

describe Microformats2::Collection do
  describe "with simple h-card" do
    before do
      html = "spec/support/simple_hcard.html"
      @collection = Microformats2.parse(html)
    end

    describe "#parse" do
      it "creates ruby class HCard" do
        @collection.h_card.should be_kind_of HCard
      end
      it "assigns .h-card .p-name to HCard#name" do
        @collection.h_card.name.should == "Jessica Lynn Suttles"
      end
      it "assigns .h-card .u-url to HCard#url" do
        @collection.h_card.url.should == "http://twitter.com/jlsuttles"
      end
      it "assings .h-card .dt-bday to HCard#bday" do
        @collection.h_card.bday.should be_kind_of DateTime
        @collection.h_card.bday.to_s.should == "1990-10-15T20:45:33-08:00"
      end
      it "assigns .h-card .e-content to HCard#content" do
        @collection.h_card.content.should == "Vegan. Cat lover. Coder."
      end
    end

    describe "#to_hash" do
      it "returns the correct Hash" do
        hash = {
          :items => [{ :type => ["h-card"],
            :properties => {
              :url => "http://twitter.com/jlsuttles",
              :name => "Jessica Lynn Suttles",
              :bday => "1990-10-15T20:45:33-08:00",
              :content => "Vegan. Cat lover. Coder."
            }
          }]
        }
        @collection.to_hash.should == hash
      end
    end
  end
end
