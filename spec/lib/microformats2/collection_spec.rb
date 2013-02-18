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
      describe "#card" do
        it "returns array of HCard objects" do
          @collection.card.first.should be_kind_of HCard
        end
      end
      describe "HCard#names parsed from '.h-card .p-name'" do
        it "assigns Property from '.h-card .p-name' to HCard#names" do
          @collection.first.names.first.should be_kind_of Microformats2::Property::Text
        end
        it "assigns inner_text to Property#to_s" do
          @collection.first.names.first.to_s.should == "Jessica Lynn Suttles"
        end
        it "assigns the first name to HCard#name" do
          @collection.first.name.to_s.should == "Jessica Lynn Suttles"
        end
      end
      describe "HCard#urls parsed from '.h-card .p-url'" do
        it "assigns Property from '.h-card .p-url' to HCard#urls" do
          @collection.first.urls.first.should be_kind_of Microformats2::Property::Url
        end
        it "assigns inner_text to Property#to_s" do
          urls = ["http://flickr.com/jlsuttles", "http://twitter.com/jlsuttles"]
          @collection.first.urls.map(&:to_s).should == urls
        end
        it "assigns first url to HCard#url" do
          @collection.first.url.to_s.should == "http://flickr.com/jlsuttles"
        end
      end
      describe "HCard#bdays parsed from '.h-card .p-bday'" do
        it "assigns Property from '.h-card .p-bday' to HCard#bdays" do
          @collection.first.bdays.first.should be_kind_of Microformats2::Property::DateTime
        end
        it "assigns datetime attribute to Property#to_s" do
          @collection.first.bdays.first.to_s.should == "1990-10-15"
        end
        it "assigns first bday to HCard#bday" do
          @collection.first.bday.to_s.should == "1990-10-15"
        end
        it "assigns DateTime object to Property#to_s" do
          @collection.first.bdays.first.value.should be_kind_of DateTime
          @collection.first.bdays.first.value.to_s.should == "1990-10-15T00:00:00+00:00"
        end
      end
      describe "HCard#contents parsed from '.h-card .p-content'" do
        it "assigns Property from '.h-card .p-content' to HCard#contents" do
          @collection.first.contents.first.should be_kind_of Microformats2::Property::Embedded
        end
        it "assigns inner_text to Property#to_s" do
          @collection.first.contents.first.to_s.should == "<p>Vegan. Cat lover. Coder.</p>"
        end
        it "assigns first content to HCard#content" do
          @collection.first.content.to_s.should == "<p>Vegan. Cat lover. Coder.</p>"
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
      describe "#card" do
        it "returns array of HCard objects" do
          @collection.card.first.should be_kind_of HCard
        end
      end
      describe "HCard#name parsed from '.h-card .p-name'" do
        it "assigns Property from '.h-card .p-name' to HCard#names" do
          @collection.first.name.first.should be_kind_of Microformats2::Property::Text
        end
        it "assigns inner_text to Property#to_s" do
          @collection.first.name.first.to_s.should == "jlsuttles"
        end
      end
      describe "HCard#nickname parsed from '.h-card .p-name .p-nickname'" do
        it "assigns Property from '.h-card .p-nickname' to HCard#nicknames" do
          @collection.first.nickname.first.should be_kind_of Microformats2::Property::Text
        end
        it "assigns inner_text to Property#to_s" do
          @collection.first.nickname.first.to_s.should == "jlsuttles"
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
      describe "#entry" do
        it "returns array of HEntry objects" do
          @collection.entry.first.should be_kind_of HEntry
        end
      end
      describe "HEntry#author parsed from '.h-entry .p-author.h-card'" do
        it "assigns Property to HEntry#authors" do
          @collection.first.author.first.should be_kind_of Microformats2::Property::Text
        end
        it "assigns inner_text to Property#to_s" do
          @collection.first.author.first.to_s.should == "Jessica Lynn Suttles"
        end
        it "assigns HCard to Property#formats" do
          @collection.first.author.first.formats.first.should be_kind_of HCard
        end
      end
    end
  end

  #
  # these cases were scraped from the internet using `rake specs:update`
  #
  describe "spec/support/cases" do
    cases_dir = "spec/support/cases/*"
    Dir[File.join(cases_dir, "*")].each do |page_dir|
    describe page_dir.split("/")[-2..-1].join("/") do
        Dir[File.join(page_dir, "*")].keep_if { |f| f =~ /([.]html$)/ }.each do |html_file|
          it "#{html_file.split("/").last}" do
            json_file = html_file.gsub(/([.]html$)/, ".js")
            html = open(html_file).read
            json = open(json_file).read

            JSON.parse(Microformats2.parse(html).to_json).should == JSON.parse(json)
          end
        end
      end
    end
  end
end
