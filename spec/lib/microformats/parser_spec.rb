require "spec_helper"
require "microformats"

describe Microformats::Parser do
  let(:parser) { Microformats::Parser.new }

  describe "#http_headers" do
    it "starts as a blank hash" do
      expect(parser.http_headers).to eq({})
    end

    describe "open file" do
      before do
        parser.parse("spec/support/lib/microformats/simple.html")
      end

      it "doesn't save #http_headers" do
        expect(parser.http_headers).to eq({})
      end
      it "saves #http_body" do
        expect(parser.http_body).to include "<!DOCTYPE html>"
      end
    end

    describe "http response" do
      before do
        stub_request(:get, "http://www.example.com/").
           with(:headers => {"Accept"=>"*/*", "User-Agent"=>"Ruby"}).
           to_return(:status => 200, :body => "abc", :headers => {"Content-Length" => 3})
        parser.parse("http://www.example.com")
      end

      it "saves #http_headers" do
        expect(parser.http_headers).to eq({"content-length" => "3"})
      end
      it "saves #http_body" do
        expect(parser.http_body).to eq("abc")
      end
    end
  end

  describe "bad markup" do
    cases_dir = "spec/support/lib/bad_markup/"
    Dir[File.join(cases_dir, "*")].keep_if { |f| f =~ /([.]js$)/ }.each do |json_file|
      it "#{json_file.split("/").last}" do

        html_file = json_file.gsub(/([.]js$)/, ".html")
        html = open(html_file).read
        json = open(json_file).read
        
        expect(JSON.parse(Microformats.parse(html).to_json)).to eq(JSON.parse(json))
      end
    end
  end

  describe "microformat-tests/tests" do
    cases_dir = "vendor/tests/tests/*" 
    #cases_dir = "vendor/tests/tests/microformats-mixed"
    #cases_dir = "vendor/tests/tests/microformats-v1"
    #cases_dir = "vendor/tests/tests/microformats-working"
    #cases_dir = "vendor/tests/tests/microformats-v2" #limit to only v2 for now
    Dir[File.join(cases_dir, "*")].each do |page_dir|
    describe page_dir.split("/")[-2..-1].join("/") do
        Dir[File.join(page_dir, "*")].keep_if { |f| f =~ /([.]json$)/ }.each do |json_file|
          it "#{json_file.split("/").last}" do

            if  json_file =~ /\/includes\//
              pending "include-pattern are not yet implemented"
            elsif json_file =~ /\/h-entry\/urlincontent/
              pending "known issue / this is an aspect of nokogiri / won't fix"
            elsif json_file =~ /\/hcard\/email/
              pending "believed issue with the test suite, test needs to be fixed"
            end
            #pending "These are dynamic tests that are not yet passing so commenting out for now"
            html_file = json_file.gsub(/([.]json$)/, ".html")
            html = open(html_file).read
            json = open(json_file).read
            
            expect(JSON.parse(Microformats.parse(html, base: 'http://example.com').to_json)).to eq(JSON.parse(json))
          end
        end
      end
    end
  end

end
