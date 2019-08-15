describe Microformats::AbsoluteUri, '#absolutize' do
  subject { described_class.new(relative, base: base).absolutize }

  context 'when relative is nil' do
    let(:relative) { nil }
    let(:base) { 'http://example.com' }

    it { is_expected.to eq(base) }
  end

  context 'when relative is an empty string' do
    let(:relative) { '' }
    let(:base) { 'http://example.com' }

    it { is_expected.to eq(base) }
  end

  context 'when relative is a valid absolute URI' do
    let(:base) { nil }
    let(:relative) { 'http://google.com' }

    it { is_expected.to eq('http://google.com') }
  end

  context 'when relative is a valid non-absolute URI' do
    let(:relative) { 'bar/qux' }

    context 'when base is present but not absolute' do
      let(:base) { 'foo' }

      it { is_expected.to eq('bar/qux') }
    end

    context 'when base is present and absolute' do
      let(:base) { 'http://google.com' }

      it { is_expected.to eq('http://google.com/bar/qux') }
    end

    context 'when base is not present' do
      let(:base) { nil }

      it { is_expected.to eq('bar/qux') }
    end

    context 'when base has a subdir' do
      let(:base) { 'http://google.com/asdf.html' }

      it { is_expected.to eq('http://google.com/bar/qux') }
    end
  end

  context 'when relative is an invalid URI' do
    let(:base) { nil }
    let(:relative) { 'git@github.com:indieweb/microformats-ruby.git' }

    it { is_expected.to eq(relative) }
  end
end
