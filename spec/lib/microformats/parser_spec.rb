describe Microformats::Parser do
  let(:parser) { described_class.new }

  describe '#http_headers' do
    it 'starts as a blank hash' do
      expect(parser.http_headers).to eq({})
    end

    describe 'open file' do
      before do
        parser.parse('spec/support/lib/microformats/simple.html')
      end

      it 'does not save #http_headers' do
        expect(parser.http_headers).to eq({})
      end

      it 'saves #http_body' do
        expect(parser.http_body).to include('<!DOCTYPE html>')
      end
    end

    describe 'http response' do
      before do
        stub_request(:get, 'http://www.example.com/')
          .with(headers: { 'Accept': '*/*', 'User-Agent': 'Ruby' })
          .to_return(status: 200, body: 'abc', headers: { 'Content-Length': 3 })

        parser.parse('http://www.example.com')
      end

      it 'saves #http_headers' do
        expect(parser.http_headers).to eq('content-length' => '3')
      end

      it 'saves #http_body' do
        expect(parser.http_body).to eq('abc')
      end
    end
  end

  describe '#bad_input' do
    describe 'space after url' do
      before do
        stub_request(:get, 'http://www.example.com/')
          .with(headers: { 'Accept': '*/*', 'User-Agent': 'Ruby' })
          .to_return(status: 200, body: 'abc', headers: { 'Content-Length': 3 })
        parser.parse('http://www.example.com ')
      end

      it 'saves #http_body' do
        expect(parser.http_body).to eq('abc')
      end
    end
  end

  describe '#frozen_strings' do
    describe 'frozen url' do
      before do
        stub_request(:get, 'http://www.example.com/')
          .with(headers: { 'Accept': '*/*', 'User-Agent': 'Ruby' })
          .to_return(status: 200, body: 'abc', headers: { 'Content-Length': 3 })

        url = 'http://www.example.com'
        url.freeze
        parser.parse(url)
      end

      it 'saves #http_body' do
        expect(parser.http_body).to eq('abc')
      end
    end

    describe 'frozen html' do
      let(:html) { '<div class="h-card"><p class="p-name">Jessica Lynn Suttles</p></div>' }

      it 'returns Collection' do
        expect(Microformats.parse(html)).to be_kind_of Microformats::Collection
      end
    end
  end

  describe 'edge cases' do
    cases_dir = 'spec/support/lib/edge_cases/'

    Dir[File.join(cases_dir, '*')].keep_if { |f| f =~ /([.]js$)/ }.each do |json_file|
      it json_file.split('/').last.to_s do
        html_file = json_file.gsub(/([.]js$)/, '.html')
        html = File.read(html_file)
        json = File.read(json_file)

        expect(JSON.parse(Microformats.parse(html).to_json)).to eq(JSON.parse(json))
      end
    end
  end

  describe 'microformat-tests/tests' do
    cases_dir = 'vendor/tests/tests/*'
    # cases_dir = 'vendor/tests/tests/microformats-mixed'
    # cases_dir = 'vendor/tests/tests/microformats-v1'
    # cases_dir = 'vendor/tests/tests/microformats-working'
    # cases_dir = 'vendor/tests/tests/microformats-v2' #limit to only v2 for now

    Dir[File.join(cases_dir, '*')].each do |page_dir|
      describe page_dir.split('/')[-2..-1].join('/') do
        Dir[File.join(page_dir, '*')].keep_if { |f| f =~ /([.]json$)/ }.each do |json_file|
          it json_file.split('/').last.to_s do

            if json_file.match?(%r{/includes/})
              pending 'include-pattern are not implemented'

            elsif json_file.match?(%r{/h-entry/urlincontent})
              pending 'known issue / this is an aspect of nokogiri / won\'t fix'

            elsif json_file.match?(%r{/rel/duplicate-rels})
              pending 'known issue / this is an aspect of nokogiri / won\'t fix'

            elsif json_file.match?(%r{/h-card/impliedurlempty})
              pending 'trailing slash on url, need to look at this more'

            elsif json_file.match?(%r{/hproduct/aggregate})
              pending 'not entirely sure what is going on here, other parsers all get different results too'

            end

            # pending 'These are dynamic tests that are not yet passing so commenting out for now'

            html_file = json_file.gsub(/([.]json$)/, '.html')
            html = File.read(html_file)
            json = File.read(json_file)

            expect(JSON.parse(Microformats.parse(html, base: 'http://example.com').to_json)).to eq(JSON.parse(json))
          end
        end
      end
    end
  end
end
