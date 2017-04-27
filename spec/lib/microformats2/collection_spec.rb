require "spec_helper"
require "microformats2"

describe Microformats2::Parser do


  describe "node_modules/microformat-tests/tests" do
    #cases_dir = "node_modules/microformat-tests/tests/*"
    cases_dir = "node_modules/microformat-tests/tests/microformats-v2" #limit to only v2 for now
    Dir[File.join(cases_dir, "*")].each do |page_dir|
    describe page_dir.split("/")[-2..-1].join("/") do
        Dir[File.join(page_dir, "*")].keep_if { |f| f =~ /([.]json$)/ }.each do |json_file|
          it "#{json_file.split("/").last}" do
            #pending "These are dynamic tests that are not yet passing so commenting out for now"
            html_file = json_file.gsub(/([.]json$)/, ".html")
            html = open(html_file).read
            json = open(json_file).read
            
            JSON.parse(Microformats2.parse(html).to_json).should == JSON.parse(json)
          end
        end
      end
    end
  end

end
