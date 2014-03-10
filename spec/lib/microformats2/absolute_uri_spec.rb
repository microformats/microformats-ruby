require "spec_helper"
require "microformats2/absolute_uri"

describe Microformats2::AbsoluteUri do
  let(:subject) { Microformats2::AbsoluteUri }

  describe "#absolutize" do
    context "when relative is nil" do
      it "returns nil" do
        base = nil
        relative = nil
        expect(subject.new(base, relative).absolutize).to be_nil
      end
    end

    context "when relative is an empty string" do
      it "returns nil" do
        base = nil
        relative = ""
        expect(subject.new(base, relative).absolutize).to be_nil
      end
    end

    context "when relative is a valid URI" do
      context "and relative is absolute" do
        it "returns normalized relative" do
          base = nil
          relative = "http://google.com"
          result = "http://google.com/"
          expect(subject.new(base, relative).absolutize).to eq result
        end
      end

      context "and relative is not absolute" do
        context "and base is present but not absolute" do
          it "returns normalized relative" do
            base = "foo"
            relative = "bar/qux"
            result = "bar/qux"
            expect(subject.new(base, relative).absolutize).to eq result
           end
        end

        context "and base is present and absolute" do
          it "returns normalized base and relative joined" do
            base = "http://google.com"
            relative = "foo/bar"
            result = "http://google.com/foo/bar"
            expect(subject.new(base, relative).absolutize).to eq result
          end
        end

        context "and base is not present" do
          it "returns normalized relative" do
            base = nil
            relative = "foo/bar"
            result = "foo/bar"
            expect(subject.new(base, relative).absolutize).to eq result
          end
        end
      end
    end

    context "when relative in an invliad URI" do
      it "returns relative" do
        base = nil
        relative = "git@github.com:G5/microformats2.git"
        result = "git@github.com:G5/microformats2.git"
        expect(subject.new(base, relative).absolutize).to eq result
      end
    end
  end
end
