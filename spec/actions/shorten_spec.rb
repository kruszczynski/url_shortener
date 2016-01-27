require 'spec_helper'

require './url-shortener/models/link'
require './url-shortener/actions/shorten'

module UrlShortener
  describe Actions::Shorten do
    subject { Actions::Shorten.call(url, custom_slug) }

    let(:url) { 'https://www.shopify.com' }
    let(:custom_slug) { 'marketing_is_great' }
    let(:params) { {url: url, custom_slug: custom_slug} }
    let(:link) { double('Link', params) }

    describe '.call' do
      it 'returns slug' do
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
