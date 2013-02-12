require "spec_helper"
require "microformats2"

describe Microformats2 do
  before do
    @html = <<-HTML.strip
      <div class="h-card"><p class="p-name">Jessica Lynn Suttles</p></div>
    HTML
  end

  describe "::parse" do
    it "returns a collection" do
      Microformats2.parse(@html).should be_kind_of Microformats2::Collection
    end
  end

  describe "::read_html" do
    it "can be a string of html" do
      Microformats2.read_html(@html).should include @html
    end
    it "can be a file path to html" do
      html = "spec/support/simple_hcard.html"
      Microformats2.read_html(html).should include "<div class=\"h-card\">"
    end
    it "can be a url to html" do
      html = "http://google.com"
      Microformats2.read_html(html).should include "google"
    end
  end

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
end
