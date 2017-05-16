require "spec_helper"
require "microformats/absolute_uri"

describe Microformats::AbsoluteUri do
  describe "#absolutize" do
    subject { Microformats::AbsoluteUri.new(relative, base: base).absolutize }
    let(:base) { nil }

    context "when relative is nil" do
      let(:relative) { nil }
      it { should be_nil }
    end

    context "when relative is an empty string" do
      let(:relative) { "" }
      it { should be_nil }
    end

    context "when relative is a valid absolute URI" do
      let(:relative) { "http://google.com" }
      it { should eq("http://google.com") }
    end

    context "when relative is a valid non-absolute URI" do
      let(:relative) { "bar/qux" }

      context "and base is present but not absolute" do
        let(:base) { "foo" }
        it { should eq("bar/qux") }
      end

      context "and base is present and absolute" do
        let(:base) { "http://google.com" }
        it { should eq("http://google.com/bar/qux") }
      end

      context "and base is not present" do
        let(:base) { nil }
        it { should eq("bar/qux") }
      end
    end

    context "when relative is an invalid URI" do
      let(:relative) { "git@github.com:indieweb/microformats-ruby.git" }
      it { should eq("git@github.com:indieweb/microformats-ruby.git") }
    end
  end
end
