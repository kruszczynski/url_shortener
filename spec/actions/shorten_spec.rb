require 'spec_helper'

require './url-shortener/actions/shorten'

module UrlShortener
  describe Actions::Shorten do
    subject { Actions::Shorten.call(url, custom_slug) }

    let(:url) { 'https://www.shopify.com' }
    let(:custom_slug) { 'marketing_is_great' }
    let(:slug) { 'W44' }
    let(:slug_number) { 145_336 }
    let(:params) do
      {url: url, custom_slug: custom_slug, slug: slug, slug_number: slug_number}
    end
    let(:link) { double('Link', params) }

    describe '.call' do
      it 'returns slug' do
        expect(SlugNumber).to receive(:latest) { slug_number }
        expect(SlugGenerator).to receive(:generate).with(slug_number) { slug }
        expect(Link)
          .to receive(:new)
          .with(params)
          .and_return(link)
        expect(link).to receive(:save)
        expect(subject).to eq(custom_slug)
      end
    end
  end # describe UrlShortener::Actions::Shorten
end # module UrlShortener
