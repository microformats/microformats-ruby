require "spec_helper"
require "microformats2"

describe Microformats2::Collection do
  describe "programatic case" do
    cases_dir = "spec/support/cases/microformats.org/microformats-2"
    html_files = Dir.entries(cases_dir).keep_if { |f| f =~ /([.]html$)/ }

    html_files.each do |html_file|
      it "#{html_file}" do
        json_file = html_file.gsub(/([.]html$)/, ".js")
        html = open(File.join(cases_dir, html_file)).read
        json = open(File.join(cases_dir, json_file)).read

        JSON.parse(Microformats2.parse(html).to_json).should == JSON.parse(json)
      end
    end
  end

  describe ".h-card simple" do
    before do
      html = "spec/support/hcard-simple.html"
      @collection = Microformats2.parse(html)
    end

    describe "#parse" do
      it "creates ruby class HCard" do
        @collection.h_card.should be_kind_of HCard
      end
      it "assigns .h-card .p-name to HCard#name" do
        @collection.h_card.name.value.should == "Jessica Lynn Suttles"
      end
      it "assigns both .h-card .u-url to HCard#url" do
        urls = ["http://flickr.com/jlsuttles", "http://twitter.com/jlsuttles"]
        @collection.h_card.url.map(&:value).should == urls
      end
      it "assings .h-card .dt-bday to HCard#bday" do
        @collection.h_card.bday.value.should be_kind_of DateTime
        @collection.h_card.bday.value.to_s.should == "1990-10-15T20:45:33-08:00"
      end
      it "assigns .h-card .e-content to HCard#content" do
        @collection.h_card.content.value.should == "Vegan. Cat lover. Coder."
      end
    end

    describe "#to_hash" do
      it "returns the correct Hash" do
        hash = {
          :items => [{
            :type => ["h-card"],
            :properties => {
              :url => ["http://flickr.com/jlsuttles", "http://twitter.com/jlsuttles"],
              :name => ["Jessica Lynn Suttles"],
              :bday => ["1990-10-15T20:45:33-08:00"],
              :content => ["Vegan. Cat lover. Coder."]
            }
          }]
        }
        @collection.to_hash.should == hash
      end
    end
  end

  describe ".h-entry .p-author.h-card nested" do
    before do
      html = "spec/support/hentry-pauthor-hcard-nested.html"
      @collection = Microformats2.parse(html)
    end

    describe "#parse" do
      it "creates ruby class HEntry" do
        @collection.h_entry.should be_kind_of HEntry
      end
      it "assigns .h-entry .p-author to HEntry#author" do
        @collection.h_entry.author.value.should == "Jessica Lynn Suttles"
      end
    end

    describe "#to_hash" do
      it "returns the correct Hash" do
        hash = {
          :items => [{
            :type => ["h-entry"],
            :properties => {
              :author => [{
                :value => "Jessica Lynn Suttles",
                :type => ["h-card", "h-org"],
                :properties => {
                  :url => ["http://twitter.com/jlsuttles"],
                  :name => ["Jessica Lynn Suttles"]
                }
              }]
            }
          }]
        }
        @collection.to_hash.should == hash
      end
    end
  end
end
