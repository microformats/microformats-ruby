require "spec_helper"
require "microformats2"

describe Microformats2::Parser do
  let(:parser) { Microformats2::Parser.new }

  describe "#http_headers" do
    it "starts as a blank hash" do
      parser.http_headers.should eq({})
    end

    describe "open file" do
      before do
        parser.parse("spec/support/lib/microformats2/simple.html")
      end

      it "doesn't save #http_headers" do
        parser.http_headers.should eq({})
      end
      it "saves #http_body" do
        parser.http_body.should include "<!DOCTYPE html>"
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
        parser.http_headers.should eq({"content-length" => "3"})
      end
      it "saves #http_body" do
        parser.http_body.should eq("abc")
      end
    end
  end
end
