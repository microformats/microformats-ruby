describe Microformats::Parser do
  subject(:parser) { described_class.new }

  let(:base_url) { 'http://www.example.com' }

  let(:http_response_object) do
    {
      status: 200,
      headers: { 'Content-Length': 3 },
      body: 'abc'
    }
  end

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
        stub_request(:get, base_url).to_return(http_response_object)

        parser.parse(base_url)
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
        stub_request(:get, base_url).to_return(http_response_object)

        parser.parse("#{base_url} ")
      end

      it 'saves #http_body' do
        expect(parser.http_body).to eq('abc')
      end
    end
  end

  describe '#frozen_strings' do
    describe 'frozen url' do
      before do
        stub_request(:get, base_url).to_return(http_response_object)

        base_url.freeze
        parser.parse(base_url)
      end

      it 'saves #http_body' do
        expect(parser.http_body).to eq('abc')
      end
    end

    describe 'frozen html' do
      let(:html) { '<div class="h-card"><p class="p-name">Jessica Lynn Suttles</p></div>' }

      it 'returns Collection' do
        expect(parser.parse(html)).to be_kind_of(Microformats::Collection)
      end
    end
  end

  describe 'edge cases' do
    input_file_paths = Dir[File.expand_path('../../support/lib/edge_cases/*.html', __dir__)]

    input_file_paths.each do |input_file_path|
      let(:input_file) { File.read(input_file_path) }
      let(:output_file) { File.read(input_file_path.sub(/\.html$/, '.js')) }

      it "parses #{input_file_path.split('/').last}" do
        expect(JSON.parse(parser.parse(input_file).to_json)).to eq(JSON.parse(output_file))
      end
    end
  end

  # rubocop:disable RSpec/ExampleLength
  describe 'microformats test suite' do
    let(:base_url) { 'http://example.com' }

    output_file_paths = Dir[File.expand_path('../../../vendor/tests/tests/**/*.json', __dir__)]

    output_file_paths.each do |output_file_path|
      input_file_path = output_file_path.sub(/\.json$/, '.html')

      it "parses #{input_file_path.split('/')[-3..-1].join('/')}" do
        if input_file_path.match?(%r{/includes/})
          pending 'include-pattern are not implemented'

        elsif input_file_path.match?(%r{/h-entry/urlincontent})
          pending 'known issue / this is an aspect of nokogiri / won\'t fix'

        elsif input_file_path.match?(%r{/rel/duplicate-rels})
          pending 'known issue / this is an aspect of nokogiri / won\'t fix'

        # these tests are failing due to timestamp output not being correct
        elsif input_file_path.match?(%r{/h-feed/simple})
          pending 'Known timestamp issue'

        elsif input_file_path.match?(%r{/h-feed/implied-title})
          pending 'Known timestamp issue'

        elsif input_file_path.match?(%r{/h-entry/summarycontent})
          pending 'Known timestamp issue'

        elsif input_file_path.match?(%r{/h-event/dates})
          pending 'Known timestamp issue'

        # these tests are failing due to whitespace in the test suite not being correct, currently an open PR to fix this
        elsif input_file_path.match?(%r{/h-entry/mixedroots})
          pending 'Test Set whitespace issue'

        elsif input_file_path.match?(%r{/hnews/minimum})
          pending 'Test Set whitespace issue'

        elsif input_file_path.match?(%r{/hnews/all})
          pending 'Test Set whitespace issue'

        elsif input_file_path.match?(%r{/hreview/vcard})
          pending 'Test Set whitespace issue'

        elsif input_file_path.match?(%r{/hentry/summarycontent})
          pending 'Test Set whitespace issue'

        elsif input_file_path.match?(%r{/hfeed/simple})
          pending 'Test Set whitespace issue'

        elsif input_file_path.match?(%r{/h-card/impliedurlempty})
          pending 'trailing slash on url, need to look at this more'

        elsif input_file_path.match?(%r{/hproduct/aggregate})
          pending 'not entirely sure what is going on here, other parsers all get different results too'
        end

        # pending 'These are dynamic tests that are not yet passing so commenting out for now'

        input_file = File.read(input_file_path)
        output_file = File.read(output_file_path)

        expect(JSON.parse(parser.parse(input_file, base: base_url).to_json)).to eq(JSON.parse(output_file))
      end
    end
  end
  # rubocop:enable RSpec/ExampleLength
end
