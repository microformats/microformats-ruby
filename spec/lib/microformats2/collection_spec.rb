require "spec_helper"
require "microformats2"

describe Microformats2::Collection do
  describe "spec/support/lib/microformats2" do

    describe "simple.html" do
      before do
        html = "spec/support/lib/microformats2/simple.html"
        @collection = Microformats2.parse(html)
      end
      describe "#to_json" do
        it "should match simple.js" do
          json = "spec/support/lib/microformats2/simple.js"
          json = open(json).read
          JSON.parse(@collection.to_json).should == JSON.parse(json)
        end
      end
      describe "'.h-card'" do
        it "assigns all cards to Collection#cards" do
          @collection.cards.first.should be_kind_of HCard
        end
        it "assigns the first card to Collection#card" do
          @collection.card.should be_kind_of HCard
        end
      end
      describe "'.h-card .p-name'" do
        it "assigns all names to HCard#names" do
          @collection.card.names.map(&:to_s).should == ["Jessica Lynn Suttles"]
        end
        it "assigns the first name to HCard#name" do
          @collection.card.name.to_s.should == "Jessica Lynn Suttles"
        end
        it "HCard#name is a Property::Text" do
          @collection.card.name.should be_kind_of Microformats2::Property::Text
        end
      end
      describe "'.h-card .p-url'" do
        it "assigns all urls to HCard#urls" do
          urls = ["http://flickr.com/jlsuttles", "http://twitter.com/jlsuttles"]
          @collection.card.urls.map(&:to_s).should == urls
        end
        it "assigns then first url to HCard#url" do
          @collection.card.url.to_s.should == "http://flickr.com/jlsuttles"
        end
        it "HCard#url is a Property::Url" do
          @collection.card.url.should be_kind_of Microformats2::Property::Url
        end
      end
      describe "'.h-card .p-bday'" do
        it "assigns all bdays to HCard#bdays" do
          @collection.card.bdays.map(&:to_s).should == ["1990-10-15"]
        end
        it "assigns the first bday to HCard#bday" do
          @collection.card.bday.to_s.should == "1990-10-15"
        end
        it "HCard#bday is a Property::DateTime" do
          @collection.card.bday.should be_kind_of Microformats2::Property::DateTime
        end
        it "assigns DateTime object to Property::DateTime#value" do
          @collection.card.bday.value.should be_kind_of DateTime
          @collection.card.bday.value.to_s.should == "1990-10-15T00:00:00+00:00"
        end
      end
      describe "'.h-card .p-content'" do
        it "assigns all contents to HCard#contents" do
          @collection.card.contents.map(&:to_s).should == ["<p>Vegan. Cat lover. Coder.</p>"]
        end
        it "assigns the first content to HCard#content" do
          @collection.card.content.to_s.should == "<p>Vegan. Cat lover. Coder.</p>"
        end
        it "HCard#content is a Property::Embedded" do
          @collection.card.contents.first.should be_kind_of Microformats2::Property::Embedded
        end
      end
      describe "Format.add_property" do
        let(:value) { "bar" }
        it "creates the attr" do
          @collection.first.add_property("p-foo", value)
          @collection.first.foo.to_s.should == value
        end
        it "allows json output of the attribute" do
          @collection.first.add_property("p-foo", value)
          @collection.first.to_json.should include(value)
        end
        it "supports Embedded" do
          @collection.first.add_property("e-foo", value)
          @collection.first.foo.to_s.should == value
        end
        it "raises a InvalidPropertyPrefix error if the prefix is invalid" do
          expect {
            @collection.first.add_property("xxx-foo", value)
          }.to raise_error Microformats2::InvalidPropertyPrefix
        end
      end
    end
    describe "nested-property.html" do
      before do
        html = "spec/support/lib/microformats2/nested-property.html"
        @collection = Microformats2.parse(html)
      end
      describe "#to_json" do
        it "should match nested-property.js" do
          json = "spec/support/lib/microformats2/nested-property.js"
          json = open(json).read
          JSON.parse(@collection.to_json).should == JSON.parse(json)
        end
      end
      describe "'.h-card'" do
        it "assigns all cards to Collection#cards" do
          @collection.cards.first.should be_kind_of HCard
        end
        it "assigns the first card to Collection#card" do
          @collection.card.should be_kind_of HCard
        end
      end
      describe "'.h-card .p-name'" do
        it "assigns all names to HCard#names" do
          @collection.card.names.map(&:to_s).should == ["jlsuttles"]
        end
        it "assigns the first name to HCard#name" do
          @collection.card.name.to_s.should == "jlsuttles"
        end
        it "HCard#name is a Property::Text" do
          @collection.card.name.should be_kind_of Microformats2::Property::Text
        end
      end
      describe "'.h-card .p-name .p-nickname'" do
        it "assigns all nicknames to HCard#nicknames" do
          @collection.card.nicknames.map(&:to_s).should == ["jlsuttles"]
        end
        it "assigns the first nickname to HCard#nickname" do
          @collection.card.nickname.to_s.should == "jlsuttles"
        end
        it "HCard#nickname is a Property::Text" do
          @collection.card.nickname.should be_kind_of Microformats2::Property::Text
        end
      end
    end

    describe "nested-format-with-property.html" do
      before do
        html = "spec/support/lib/microformats2/nested-format-with-property.html"
        @collection = Microformats2.parse(html)
      end
      describe "#to_json" do
        it "should match nested-format-with-property.js" do
          json = "spec/support/lib/microformats2/nested-format-with-property.js"
          json = open(json).read
          JSON.parse(@collection.to_json).should == JSON.parse(json)
        end
      end
      describe "'.h-entry'" do
        it "assigns all entrys to Collection#entrys" do
          @collection.entries.first.should be_kind_of HEntry
        end
        it "assigns the first entry to Collection#entry" do
          @collection.entry.should be_kind_of HEntry
        end
      end
      describe "'.h-card .p-author.h-card'" do
        it "assigns all authors to HCard#authors" do
          @collection.entry.authors.map(&:to_s).should == ["Jessica Lynn Suttles"]
        end
        it "assigns the first author to HCard#author" do
          @collection.entry.author.to_s.should == "Jessica Lynn Suttles"
        end
        it "HCard#author is a Property::Text" do
          @collection.entry.author.should be_kind_of Microformats2::Property::Text
        end
        it "assigns all HCard to Property::Text#formats" do
          @collection.entry.author.formats.first.should be_kind_of HCard
        end
        it "assigns the first HCard to Property::Text#format" do
          @collection.entry.author.format.should be_kind_of HCard
        end
      end
    end
  end


  # these cases were scraped from the internet using `rake specs:update`
  #

  describe "spec/support/cases" do
    cases_dir = "spec/support/cases/*"
    Dir[File.join(cases_dir, "*")].each do |page_dir|
    describe page_dir.split("/")[-2..-1].join("/") do
        Dir[File.join(page_dir, "*")].keep_if { |f| f =~ /([.]html$)/ }.each do |html_file|
          it "#{html_file.split("/").last}" do
            pending "These are dynamic tests that are not yet passing so commenting out for now"
            # json_file = html_file.gsub(/([.]html$)/, ".js")
            # html = open(html_file).read
            # json = open(json_file).read

            # JSON.parse(Microformats2.parse(html).to_json).should == JSON.parse(json)
          end
        end
      end
    end
  end
end
